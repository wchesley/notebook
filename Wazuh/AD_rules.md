[back](./README.md)

# Wazuh Active Directory Rules
 
## Overview

Active Directory (AD) is the most widely used Identity and Access Management (IAM) technology for Windows domain networks in modern organizations. It is adopted by small, medium, and large enterprises to manage enterprise networks, so it is an ideal target for attackers. AD is a perfect target for attackers because many system administrators use it to manage enterprise networks.

To defend against threats, organizations need to implement the principle of defense in depth. Implementing several layers of defense mechanisms ensures that when the initial line of defense fails and hackers get access to Active Directory, the consequences are limited and contained. 

### Active Directory attacks: Infrastructure setup

We use the following setup to simulate AD attacks and show how Wazuh can detect them:

- A Centos 7 endpoint with Wazuh 4.3.10 installed. You can install the Wazuh central components using this Quickstart installation guide.
- A Windows Server 2022 domain controller running the Wazuh agent 4.3.10. This domain controller hosts the Active Directory infrastructure. You can use this Wazuh guide to install the Wazuh agent. In this blogpost, we use the domain names Windows10 and wazuhtest.com
- A Windows 10 Pro or Enterprise edition endpoint running Wazuh agent 4.3.10. The Windows 10 endpoint is registered to the Active Directory and serves as the attacker’s initial foothold after compromise. 
- A domain account on the Active Directory with local administrative privilege on the compromised Windows 10 endpoint. This account is the compromised user account used to simulate our attacks. 
- A domain administrator account on the Active Directory is required to serve as the target of the pass the hash attack.
- A Mimikatz copy in the compromised Windows 10 endpoint. To run the mimikatz.exe, you can navigate to the mimikatz_trunk/x64 (or x32, depending on your system architecture). Mimikatz is required to perform the attack simulations.

## Detection rules

To detect AD attacks, we create rules on the Wazuh server to detect IoCs in Windows security events and system events monitored by Sysmon.
Sysmon integration

1. Download Sysmon from the Microsoft Sysinternals page with the configuration file sysmonconfig.xml on the Windows 2022 domain controller and the compromised Windows 10  endpoint.

2. Run the following command to install Sysmon with the downloaded configuration file via PowerShell (run as administrator):  
`.\sysmon.exe -accepteula -i sysmonconfig.xml`

3. Configure both Wazuh agents to collect Sysmon events by adding the following settings to the agent configuration file in "C:\Program Files (x86)\ossec-agent\ossec.conf":
```xml
<ossec_config>
  <localfile>    
    <location>Microsoft-Windows-Sysmon/Operational</location>
    <log_format>eventchannel</log_format>
  </localfile>
</ossec_config>
```

4. Apply the changes by restarting the agents using this PowerShell command:
Restart-Service -Name wazuh

## Wazuh server configuration

1. To generate alerts on the Wazuh dashboard whenever an attacker performs any of the attacks mentioned above,  add the following rules to the /var/ossec/etc/rules/local_rules.xml file on the Wazuh server:

```xml
<group name="security_event, windows,">

  <!-- This rule detects DCSync attacks using windows security event on the domain controller -->
  <rule id="110001" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4662$</field>
    <field name="win.eventdata.properties" type="pcre2">{1131f6aa-9c07-11d1-f79f-00c04fc2dcd2}|{19195a5b-6da0-11d0-afd3-00c04fd930c9}</field>
    <options>no_full_log</options>
    <description>Directory Service Access. Possible DCSync attack</description>
  </rule>
 
 <!-- This rule ignores Directory Service Access originating from machine accounts containing $ -->
 <rule id="110009" level="0">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4662$</field>
    <field name="win.eventdata.properties" type="pcre2">{1131f6aa-9c07-11d1-f79f-00c04fc2dcd2}|{19195a5b-6da0-11d0-afd3-00c04fd930c9}</field>
    <field name="win.eventdata.SubjectUserName" type="pcre2">\$$</field>
    <options>no_full_log</options>
    <description>Ignore all Directory Service Access that is originated from a machine account containing $</description>
  </rule>
 
  <!-- This rule detects Keberoasting attacks using windows security event on the domain controller -->
  <rule id="110002" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4769$</field>
    <field name="win.eventdata.TicketOptions" type="pcre2">0x40810000</field>
    <field name="win.eventdata.TicketEncryptionType" type="pcre2">0x17</field>
    <options>no_full_log</options>
    <description>Possible Keberoasting attack</description>
  </rule>
 
  <!-- This rule detects Golden Ticket attacks using windows security events on the domain controller -->
  <rule id="110003" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4624$</field>
    <field name="win.eventdata.LogonGuid" type="pcre2">{00000000-0000-0000-0000-000000000000}</field>
    <field name="win.eventdata.logonType" type="pcre2">3</field>
    <options>no_full_log</options>
    <description>Possible Golden Ticket attack</description>
  </rule>
  <!-- This rule detects when PsExec is launched remotely to perform lateral movement within the domain. The rule uses Sysmon events collected from the domain controller. -->
  <rule id="110004" level="12">
    <if_sid>61600</if_sid>
    <field name="win.system.eventID" type="pcre2">17|18</field>
    <field name="win.eventdata.PipeName" type="pcre2">\\PSEXESVC</field>
    <options>no_full_log</options>
    <description>PsExec service launched for possible lateral movement within the domain</description>
  </rule>

  <!-- This rule detects NTDS.dit file extraction using a sysmon event captured on the domain controller -->
  <rule id="110006" level="12">
    <if_group>sysmon_event1</if_group>
    <field name="win.eventdata.commandLine" type="pcre2">NTDSUTIL</field>
    <description>Possible NTDS.dit file extraction using ntdsutil.exe</description>
  </rule>

  <!-- This rule detects Pass-the-ash (PtH) attacks using windows security event 4624 on the compromised endpoint -->
  <rule id="110007" level="12">
    <if_sid>60103</if_sid>
    <field name="win.system.eventID">^4624$</field>
    <field name="win.eventdata.LogonProcessName" type="pcre2">seclogo</field>
    <field name="win.eventdata.LogonType" type="pcre2">9</field>
    <field name="win.eventdata.AuthenticationPackageName" type="pcre2">Negotiate</field>
    <field name="win.eventdata.LogonGuid" type="pcre2">{00000000-0000-0000-0000-000000000000}</field>
    <options>no_full_log</options>
    <description>Possible Pass the hash attack</description>
  </rule>
  
  <!-- This rule detects credential dumping when the command sekurlsa::logonpasswords is run on mimikatz -->
  <rule id="110008" level="12">
    <if_sid>61612</if_sid>
    <field name="win.eventdata.TargetImage" type="pcre2">(?i)\\\\system32\\\\lsass.exe</field>
    <field name="win.eventdata.GrantedAccess" type="pcre2">(?i)0x1010</field>
    <description>Possible credential dumping using mimikatz</description>
  </rule>
  
</group>
```

The above xml file is a combination of the ones presented in Wazuh's blog posts covering this topic. Emulating the attacks and verifying the rules work is covered in both posts ([part 1](https://wazuh.com/blog/how-to-detect-active-directory-attacks-with-wazuh-part-1-of-2/), [part 2](https://wazuh.com/blog/how-to-detect-active-directory-attacks-with-wazuh-part-2/)), and is not covered in this article. 

# Reference

- [Using Wazuh to monitor Sysmon events](https://wazuh.com/blog/using-wazuh-to-monitor-sysmon-events/)
- [How to detect Active Directory attacks with Wazuh [Part 1 of 2]](https://wazuh.com/blog/how-to-detect-active-directory-attacks-with-wazuh-part-1-of-2/)
- [How to detect Active Directory attacks with Wazuh [Part 2 of 2]](https://wazuh.com/blog/how-to-detect-active-directory-attacks-with-wazuh-part-2/)
- [Configuring log collection for different operating systems (Wazuh-Documentation)](https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/configuration.html#windows)