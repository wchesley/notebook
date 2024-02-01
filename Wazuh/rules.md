# Rules

Out of the box, Wazuh has a comprehensive set of pre-configured rules. 
While these rules cover a wide range of potential security issues, there
are still scenarios or risks unique to an organization that these rules
may not cover. To compensate for this, organizations can create custom 
alert rules, which is the focus of this doc.

- [Rules](#rules)
- [Understanding Rules](#understanding-rules)
  - [Rule Order](#rule-order)
- [Custom Rules](#custom-rules)
  - [Adding Local Rules (Linux)](#adding-local-rules-linux)
  - [Ignoring Rule Alerts (Windows)](#ignoring-rule-alerts-windows)
  - [Creating Rule Alerts (Windows)](#creating-rule-alerts-windows)
- [Rules Syntax](#rules-syntax)
  - [Overview](#overview)
- [Reference](#reference)


# Understanding Rules

Here is an example of an alert rule that looks for the “svchost.exe” string in the “sysmon.image” field:

sysmon_rules.xml

```xml
<rule id="184666" level="12">
  <if_group>sysmon_event1</if_group>
  <field name="sysmon.image">svchost.exe</field>
  <description>Sysmon - Suspicious Process - svchost.exe</description>
  <mitre>
    <id>T1055</id>
  </mitre>
  <group>pci_dss_10.6.1,pci_dss_11.4,...</group>
</rule>
```

- A rule block has multiple options
- rule-id — The unique identity of the rule
- rule level — The classification of levels from 0–15 indicating the level of severity as listed by Wazuh
- if_group — Specifies the group name that triggers this rule when that group has matched
- field name — The name of the field extracted from the decoder. The value in this field is matched using regex
- group — Contains a list of groups or categories that the rule belongs to. It can be used for organizing and filtering rules

## Rule Order

- In Wazuh rules are processed based on several factors determining rule order
- One factor that will be discussed that is relevant to making custom rules is the “if” condition prerequisites
- if_group option in the previous task, but there other “if” condition prerequisites like the if_side option shown below:

```xml
sysmon_rules.xml
<rule id="184667" level="0">
    <if_sid>184666</if_sid>
    <field name="sysmon.parentImage">\\\\services.exe</field>
    <description>Sysmon - Legitimate Parent Image - svchost.exe</description>
</rule>
```

- **if_sid** — Specifies the ID of another rule that triggers this rule. In this example, the rule is triggered if an event with the ID of `184666` has been triggered.

These “if” condition prerequisites are considered the “parent” that must be 
evaluated first. Because of this parent-child relationship, it is 
essential to note that Wazuh Rules are triggered from a top-to-down 
manner. When rules are processed, the condition prerequisites are 
checked, and the rule order is updated.

# Custom Rules

As mentioned before, the pre-existing rules are comprehensive. However, it cannot cover all use cases, especially for all organizations with unique needs and requirements.

There are several reasons why we want to have custom rules:

- You want to enhance the detection capabilities of Wazuh.
- You are integrating a not-so-well-known security solution.
- You use an old version of a security solution with an older log format.
- You recently learned of a new attack and want to create a specific detection rule.
- You want to fine-tune a rule.

Here's an example from Auditd log: 

```syslog
type=SYSCALL msg=audit(1479982525.380:50): arch=c000003e syscall=2 success=yes exit=3 a0=7ffedc40d83b a1=941 a2=1b6 a3=7ffedc40cce0 items=2 ppid=432 pid=3333 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="touch" exe="/bin/touch" key="audit-wazuh-w" type=CWD msg=audit(1479982525.380:50):  cwd="/var/log/audit" type=PATH msg=audit(1479982525.380:50): item=0 name="/var/log/audit/tmp_directory1/" inode=399849 dev=ca:02 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=PARENT type=PATH msg=audit(1479982525.380:50): item=1 name="/var/log/audit/tmp_directory1/malware.py" inode=399852 dev=ca:02 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=CREATE type=PROCTITLE msg=audit(1479982525.380:50): proctitle=746F756368002F7661722F6C6F672F61756469742F746D705F6469726563746F7279312F6D616C776172652E7079
```

The log describes an event wherein a `touch` command (probably as root user) was used to create a new file called `malware.py` in the `/var/log/audit/tmp_directory1/` directory. The command was successful, and the log was generated based on an audit rule with the key "audit-wazuh-w".

When Wazuh ingests the above log, the pre-existing rule below will get triggered because of the value of `<match>`:

`auditd_rules.xml`

```xml
<rule id="80790" level="3">
  <if_group>audit_watch_write</if_group>
  <match>type=CREATE</match>
  <description>Audit: Created: $(audit.file.name)<description>
  <group>audit_watch_write,audit_watch_create,gdpr_II_5.1.f,gdpr_IV_30.1.g,</group>
</rule>
```
## Adding Local Rules (Linux)

For this exercise, let’s create a custom rule that will override the above rule so we have more control over the information we display.

To do this, you need to do the following:

1. Connect to the server using SSH at `10.10.177.121` and use `thm` for the username and `TryHackMe!` the password. The credentials and connection details are listed in Task 1 of this room.
2. Use the `sudo su` command to become the root user.
3. Open the file `/var/ossec/etc/rules/local_rules.xml` using your favourite editor.
4. Paste the following text at the end of the file:

local_rules.xml

```xml
<group name="audit,">
  <rule id="100002" level="3">
    <if_sid>80790</if_sid>
    <field name="audit.cwd">downloads|tmp|temp</field>
    <description>Audit: $(audit.exe) created a file with filename $(audit.file.name) the folder $(audit.directory.name).</description>
    <group>audit_watch_write,</group>
  </rule>
  </group>
```

The rule above will get triggered if a file is created in the downloads, 
tmp, or temp folders. Let’s break this down so we can better understand:

- **group name=”audit,”** We are setting this to the same value as the grouped rules in audit_rules.xml.
- rule id=”100002" — Each custom rule needs to have a unique ID. Custom IDs start from `100001` onwards. Since there is already an existing example rule that uses `100001`, we are going to use `100002`.
- **level=”3"** — We are setting this to 3 (Successful/Authorized events) because a file created in these folders isn’t necessarily malicious.
- **if_sid** — We set the parent to rule ID `80790` because we want that rule to be processed before this one.
- **field name=”[audit.directory.name](http://audit.directory.name/)”** The string here is matched using regex. In this case, we are looking
for tmp, temp, or downloads matches. This value is compared to the `audit.cwd` variable fetched by the auditd decoder.
- **description** The description that will appear on the alert. Variables can be used here using the format `$(variable.name)`.
- **group** — Used for grouping this specific alert. We just took the same value from rule `80790`.

Save the file and restart the wazuh-manager so it can load the new custom rules:

`systemcl restart wazuh-manager`

## Ignoring Rule Alerts (Windows)

When sysmon is installed onto windows workstations, it can be rather chatty about applications and their normal processes. This is not a one shot guide and should be examined carefully with each exception created to this rule. Using the following rule from wazuh: 

```xml
<group name="sysmon,sysmon_eid10_detections,windows,">

  <rule id="92900" level="12">
    <if_group>sysmon_event_10</if_group>
    <field name="win.eventdata.targetImage" type="pcre2">(?i)lsass\.exe</field>
    <field name="win.eventdata.grantedAccess" type="pcre2">(?i)(0x1010|0x40)</field>
    <field name="win.eventdata.sourceImage" type="pcre2" negate="yes">(?i)(C:\\\\Program Files|wmiprvse\.exe)</field>
    <options>no_full_log</options>
    <description>Lsass process was accessed by $(win.eventdata.sourceImage) with read permissions, possible credential dump</description>
    <mitre>
      <id>T1003.001</id>
    </mitre>
  </rule>
<!-- truncated for example -->
</group>
```

- See the full file [here](https://github.com/wazuh/wazuh/blob/234a7977a105181271de63c4b06d44d3f9ab876a/ruleset/rules/0945-sysmon_id_10.xml#L8)

For example, my windows workstation likes to complain about `AEMAgent.exe` accessing `lsass.exe`. This is part of our RMM software and was generating several alerts per minute, this rule level is 12, so Wazuh automatically generates a notification for this rule when it's tripped. Below is an example of the event as Wazuh see's it:  

```json
{
  "_index": "wazuh-alerts-4.x-2024.02.01",
  "_id": "iBxSZY0BkpJoYydoU9RI",
  "_version": 1,
  "_score": null,
  "_source": {
    "input": {
      "type": "log"
    },
      "win": {
        "eventdata": {
          "sourceThreadId": "8668",
          "grantedAccess": "0x101000",
          "targetProcessGUID": "{853d8595-60b7-65bb-0d00-00000000ff00}",
          "targetProcessId": "1016",
          "utcTime": "2024-02-01 15:38:27.133",
          "sourceUser": "NT AUTHORITY\\\\SYSTEM",
          "sourceProcessId": "11080",
          "sourceImage": "C:\\\\ProgramData\\\\CentraStage\\\\AEMAgent\\\\AEMAgent.exe",
          "targetImage": "C:\\\\WINDOWS\\\\system32\\\\lsass.exe",
          "sourceProcessGUID": "{853d8595-6108-65bb-8701-00000000ff00}",
          "callTrace": "C:\\\\WINDOWS\\\\SYSTEM32\\\\ntdll.dll+9f834|C:\\\\Program Files\\\\SentinelOne\\\\Sentinel Agent 23.3.3.264\\\\InProcessClient64.dll+85995|C:\\\\Program Files\\\\SentinelOne\\\\Sentinel Agent 23.3.3.264\\\\InProcessClient64.dll+858d5|C:\\\\WINDOWS\\\\System32\\\\KERNELBASE.dll+2cb3e|UNKNOWN(00007FFD2817A3BB)",
          "targetUser": "NT AUTHORITY\\\\SYSTEM"
        },
        "system": {
          "eventID": "10",
          "keywords": "0x8000000000000000",
          "providerGuid": "{5770385f-c22a-43e0-bf4c-06f5698ffbd9}",
          "level": "4",
          "channel": "Microsoft-Windows-Sysmon/Operational",
          "opcode": "0",
          "message": "\"Process accessed:\r\nRuleName: -\r\nUtcTime: 2024-02-01 15:38:27.133\r\nSourceProcessGUID: {853d8595-6108-65bb-8701-00000000ff00}\r\nSourceProcessId: 11080\r\nSourceThreadId: 8668\r\nSourceImage: C:\\ProgramData\\CentraStage\\AEMAgent\\AEMAgent.exe\r\nTargetProcessGUID: {853d8595-60b7-65bb-0d00-00000000ff00}\r\nTargetProcessId: 1016\r\nTargetImage: C:\\WINDOWS\\system32\\lsass.exe\r\nGrantedAccess: 0x101000\r\nCallTrace: C:\\WINDOWS\\SYSTEM32\\ntdll.dll+9f834|C:\\Program Files\\SentinelOne\\Sentinel Agent 23.3.3.264\\InProcessClient64.dll+85995|C:\\Program Files\\SentinelOne\\Sentinel Agent 23.3.3.264\\InProcessClient64.dll+858d5|C:\\WINDOWS\\System32\\KERNELBASE.dll+2cb3e|UNKNOWN(00007FFD2817A3BB)\r\nSourceUser: NT AUTHORITY\\SYSTEM\r\nTargetUser: NT AUTHORITY\\SYSTEM\"",
          "version": "3",
          "systemTime": "2024-02-01T15:38:27.1349490Z",
          "eventRecordID": "5727789",
          "threadID": "8144",
          "computer": "CyberSecurity.westgatecomp.local",
          "task": "10",
          "processID": "5848",
          "severityValue": "INFORMATION",
          "providerName": "Microsoft-Windows-Sysmon"
        }
      }
    },
    "rule": {
      "firedtimes": 166,
      "mail": true,
      "level": 12,
      "description": "Lsass process was accessed by C:\\\\ProgramData\\\\CentraStage\\\\AEMAgent\\\\AEMAgent.exe with read permissions, possible credential dump",
      "groups": [
        "sysmon",
        "sysmon_eid10_detections",
        "windows"
      ],
      "mitre": {
        "technique": [
          "LSASS Memory"
        ],
        "id": [
          "T1003.001"
        ],
        "tactic": [
          "Credential Access"
        ]
      },
      "id": "92900"
    },
    "location": "EventChannel",
    "decoder": {
      "name": "windows_eventchannel"
    },
}
```

It's a lot of output but we can see that `win.eventdata.sourceImage` (tracing down the JSON array from windows -> eventdata -> sourceImage) contains the program that is the source of the rule being triggered, and `win.eventdata.targetImage` is where `AEMAgent.exe` is accessing `lsass.exe`. By referring to [Wazuh Rules Syntax](https://documentation.wazuh.com/current/user-manual/ruleset/ruleset-xml-syntax/rules.html) and [this reddit post](https://www.reddit.com/r/Wazuh/comments/uhl0je/help_me_understand_this_level_12_sysmon_rule/). We can put together a working rule to append to the server's `/var/ossec/etc/rules/local_rules.xml` file. For this example, the rule looks like the following: 

```xml
<group name="sysmon,windows,security_event,">

  <rule id="101001" level="0">
    <if_sid>92900</if_sid>
    <if_group>sysmon</if_group>
    <field name="win.eventdata.sourceImage">\\AEMAgent.exe</field>
    <description>Sysmon - Legitimate Parent Image - AEMAgent.exe</description>
  </rule>

</group>
```

> As of 02-01-2024 I am still testing this rule exception. While I've not seen any alerts fired, I've also not seen if this rule has tripped for anything else. I have seen rule `92900` get tripped before on my machine by `svchost.exe`. Judging by the logs, it gets tripped twice a day, around 7:37am.  

Now when `AEMAgent.exe` accesses `lsass.exe` we won't be alerted about it, instead this alert will be ignored. 

## Creating Rule Alerts (Windows)

<sub>taken from: https://www.reddit.com/r/Wazuh/comments/m7wi7h/windows_events_alerts_with_wazuh/</sub>

First of all, as you say, you need to have a wazuh agent installed, and that it be connected to a wazuh manager.

Once it is correctly configured and connected, then you have to check if the manager has by default rules for the use cases that you comment.

In this repository https://github.com/wazuh/wazuh-ruleset you can find the decoders and rules that wazuh-manager has by default (all these files are being migrated to the repository wazuh/wazuh https://github.com/wazuh/wazuh).

For example, imagine that I want to generate an alert when there has been a Remote access login failure, and the event 20189 has occurred.

Looking for that eventID, I find the following rule https://github.com/wazuh/wazuh-ruleset/blob/master/rules/0620-win-generic_rules.xml#L22

In this case, there would be a rule for my use case, and since it is a level 5 rule, by default it would generate an alert (the default threshold to generate an alert is level 3).

In case it doesn't exist then I would have to create a custom rule for my use case.

Here are some useful links that show how they can be created:

- Creating decoders and rules from scratch: https://wazuh.com/blog/creating-decoders-and-rules-from-scratch/

- Sibling decoders: flexible extraction of information: https://wazuh.com/blog/sibling-decoders-flexible-extraction-of-information/

- Custom rules and decoders: https://documentation.wazuh.com/4.0/user-manual/ruleset/custom.html

- Testing decoders and rules: https://documentation.wazuh.com/4.0/user-manual/ruleset/testing.html

Once you have your rule created and you have verified that it is generating the alert, it is now possible to configure it so that the alert is also sent by email. You can do it in several ways, but if you want to force the alert to always be sent by email, then the simplest thing would be to define the sending by email in the rule declaration itself https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/index.html#force-forwarding-an-alert-by-email.

Below I provide links that can be helpful for this configuration

- Configuring email alerts: https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/index.html

- How to Send Email Notifications: https://wazuh.com/blog/how-to-send-email-notifications-with-wazuh/

- Email alerts configuration: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/email_alerts.html

- SMTP server with authentication: https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/smtp_authentication.html

# Rules Syntax

The Wazuh Ruleset combined with any customs 
rules is used to analyze incoming events and generate alerts when 
appropriate. The Ruleset is in constant expansion and enhancement thanks
 to the collaborative effort of our developers and our growing 
community.

Our aim is to provide the best guidance possible for anyone who may 
be looking into developing their own custom rules. Remember that you can
 always [contribute](https://documentation.wazuh.com/current/user-manual/ruleset/contribute.html) to our community.

## Overview

The **xml labels** used to configure `rules` are listed here.

|Option|Values|Description|
|:----|:----|:----|
|<span class="std std-ref">rule</span>|See <span class="std std-ref">table</span> below.|Its starts a new rule and its defining options.|
|<span class="std std-ref">match</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will attempt to find a match in the log using [<span class="std std-ref">sregex</span>](regex.html#sregex-os-match-syntax)  bydefault, deciding if the rule should be triggered.|
|<span class="std std-ref">regex</span>|Any [<span class="doc">regular expression</span>](regex.html).|It does the same as `<span class="pre">match</span>`, but with [<span class="std std-ref">regex</span>](regex.html#os-regex-syntax) as default.|
|decoded_as|Any decoder's name.|It will match with logs that have been decoded by a specific decoder.|
|<span class="std std-ref">category</span>|Any [<span class="std std-ref">type</span>](decoders.html#decoders-type).|It will match with logs whose decoder's [<span class="std std-ref">type</span>](decoders.html#decoders-type) concur.|
|<span class="std std-ref">field</span>|Name and any [<span class="doc">regular expression</span>](regex.html).|It will compare a field extracted by the decoder in [<span class="std std-ref">order</span>](decoders.html#decoders-order) with aregular expression.|
|srcip|Any IP address.|It will compare the IP address with the IP decoded as `<span class="pre">srcip</span>`. Use "!" to negate it.|
|dstip|Any IP address.|It will compare the IP address with the IP decoded as `<span class="pre">dstip</span>`. Use "!" to negate it.|
|<span class="std std-ref">srcport</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a port with a value decoded as `<span class="pre">srcport</span>`.|
|<span class="std std-ref">dstport</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a port with a value decoded as `<span class="pre">dstport</span>`.|
|data|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a data with a value decoded as  `<span class="pre">data</span>`.|
|<span class="std std-ref">extra_data</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing an extra data with a value decodedas `<span class="pre">extra_data</span>`.|
|<span class="std std-ref">user</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a user with a value decoded as `<span class="pre">user</span>`.|
|<span class="std std-ref">system_name</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a system name with a value decodedas `<span class="pre">system_name</span>`.|
|<span class="std std-ref">program_name</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a program name with a value pre-decodedas `<span class="pre">program_name</span>`.|
|<span class="std std-ref">protocol</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a protocol with a value decoded as `<span class="pre">protocol</span>`.|
|<span class="std std-ref">hostname</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a hostname with a value pre-decodedas `<span class="pre">hostname</span>`.|
|time|Any time range. e.g. (hh:mm-hh:mm)|It checks if the event was generated during that time range.|
|weekday|monday - sunday, weekdays, weekends|It checks whether the event was generated during certain weekdays.|
|<span class="std std-ref">id</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing an ID with a value decoded as `<span class="pre">id</span>`|
|<span class="std std-ref">url</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a URL with a value decoded as `<span class="pre">url</span>`|
|<span class="std std-ref">location</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a location with a value pre-decodedas `<span class="pre">location</span>`.|
|<span class="std std-ref">action</span>|Any String or [<span class="doc">regular expression</span>](regex.html).|It will compare a string or regular expression representing an action with a value decodedas `<span class="pre">action</span>`.|
|<span class="std std-ref">status</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a status with a value decoded as `<span class="pre">status</span>`.|
|<span class="std std-ref">srcgeoip</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a GeoIP source with a value decodedas `<span class="pre">srcgeoip</span>`.|
|<span class="std std-ref">dstgeoip</span>|Any [<span class="doc">regular expression</span>](regex.html).|It will compare a regular expression representing a GeoIP destination with a value decodedas `<span class="pre">dstgeoip</span>`.|
|if_sid|A list of rule IDs separated by commas or spaces.|It works similar to parent decoder. It will match when a rule ID on the list has previously matched.|
|if_group|Any group name.|It will match if the indicated group has matched before.|
|if_level|Any level from 1 to 16.|It will match if that level has already been triggered by another rule.|
|if_matched_sid|Any rule ID (Number).|Similar to `<span class="pre">if_sid</span>` but it will only match if the ID has been triggered in a period of time.|
|if_matched_group|Any group name.|Similar to `<span class="pre">if_group</span>` but it will only match if the group has been triggered in a period of time.|
|same_id|None.|The decoded `<span class="pre">id</span>` must be the same.|
|different_id|None.|The decoded `<span class="pre">id</span>` must be different.|
|same_srcip|None.|The decoded `<span class="pre">srcip</span>` must be the same.|
|different_srcip|None.|The decoded `<span class="pre">srcip</span>` must be different.|
|same_dstip|None.|The decoded `<span class="pre">dstip</span>` must be the same.|
|different_dstip|None.|The decoded `<span class="pre">dstip</span>` must be different.|
|same_srcport|None.|The decoded `<span class="pre">srcport</span>` must be the same.|
|different_srcport|None.|The decoded `<span class="pre">srcport</span>` must be different.|
|same_dstport|None.|The decoded `<span class="pre">dstport</span>` must be the same.|
|different_dstport|None.|The decoded `<span class="pre">dstport</span>` must be different.|
|same_location|None.|The `<span class="pre">location</span>` must be the same.|
|different_location|None.|The `<span class="pre">location</span>` must be different.|
|same_srcuser|None.|The decoded `<span class="pre">srcuser</span>` must be the same.|
|different_srcuser|None.|The decoded `<span class="pre">srcuser</span>` must be different.|
|same_user|None.|The decoded `<span class="pre">user</span>` must be the same.|
|different_user|None.|The decoded `<span class="pre">user</span>` must be different.|
|same_field|None.|The decoded `<span class="pre">field</span>` must be the same as the previous ones.|
|different_field|None.|The decoded `<span class="pre">field</span>` must be different than the previous ones.|
|same_protocol|None.|The decoded `<span class="pre">protocol</span>` must be the same.|
|different_protocol|None.|The decoded `<span class="pre">protocol</span>` must be different.|
|same_action|None.|The decoded `<span class="pre">action</span>` must be the same.|
|different_action|None.|The decoded `<span class="pre">action</span>` must be different.|
|same_data|None.|The decoded `<span class="pre">data</span>` must be the same.|
|different_data|None.|The decoded `<span class="pre">data</span>` must be different.|
|same_extra_data|None.|The decoded `<span class="pre">extra_data</span>` must be the same.|
|different_extra_data|None.|The decoded `<span class="pre">extra_data</span>` must be different.|
|same_status|None.|The decoded `<span class="pre">status</span>` must be the same.|
|different_status|None.|The decoded `<span class="pre">status</span>` must be different.|
|same_system_name|None.|The decoded `<span class="pre">system_name</span>` must be the same.|
|different_system_name|None.|The decoded `<span class="pre">system_name</span>` must be different.|
|same_url|None.|The decoded `<span class="pre">url</span>` must be the same.|
|different_url|None.|The decoded `<span class="pre">url</span>` must be different.|
|same_srcgeoip|None.|The decoded `<span class="pre">srcgeoip</span>` must the same.|
|different_srcgeoip|None.|The decoded `<span class="pre">srcgeoip</span>` must be different.|
|same_dstgeoip|None.|The decoded `<span class="pre">dstgeoip</span>` must the same.|
|different_dstgeoip|None.|The decoded `<span class="pre">dstgeoip</span>` must be different.|
|description|Any String.|Provides a human-readable description to explain what is the purpose of the rule. Please, use thisfield when creating custom rules.|
|list|Path to the CDB file.|Perform a CDB lookup using an ossec list.|
|info|Any String.|Extra information using certain attributes.|
|<span class="std std-ref">options</span>|See the table <span class="std std-ref">below.</span>|Additional rule options that can be used.|
|check_diff|None.|Determines when the output of a command changes.|
|group|Any String.|Add additional groups to the alert.|
|<span class="std std-ref">mitre</span>|See <span class="std std-ref">Mitre table</span> below.|Contains Mitre Technique IDs that fit the rule|
|var|Name for the variable. Most used: BAD_WORDS|Defines a variable that can be used anywhere inside the same file.|

# Reference

[Custom Alert Rules - Wazuh (Medium)](https://medium.com/@josephalan17201972/custom-alert-rules-in-wazuh-tryhackme-write-up-613e8e99a6b3)

[Wazuh Rules Syntax](https://documentation.wazuh.com/current/user-manual/ruleset/ruleset-xml-syntax/rules.html)  

[Wazuh rule 0945-sysmon_id_10.xml](https://github.com/wazuh/wazuh/blob/234a7977a105181271de63c4b06d44d3f9ab876a/ruleset/rules/0945-sysmon_id_10.xml#L8)

[Help Me Understand This Level 12 Sysmon Rule : r/Wazuh](https://www.reddit.com/r/Wazuh/comments/uhl0je/help_me_understand_this_level_12_sysmon_rule/)