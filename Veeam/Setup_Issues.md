[back](./README.md)

# VBR Setup Issues

If you have an agent that was previously managed by another VBR or Veeam Service Provider Console (VSPC). The previous agent has to be totally removed before VBR can take over. While this can be requested from VSPC, we ran into an issue where it didn't remove it properly. Windows no longer see's it in intalled programs list but Veeam can't install a new Agent to the machine from VBR. 

This issue was resolved by removing all files and folders related to Veeam as well as the registry keys it created. A brief list of what was removed is below: 

- C:\Program Files\Veeam
- C:\ProgramData\Veeam
- C:\Users\<username>\AppData\Local\Veeam
- C:\Users\<username>\AppData\Roaming\Veeam
- HKLM:\SOFTWARE\Veeam

Once these were removed we could install Veeam Agent from VBR server to the individual machines. 

Well that worked on at least one site. Ran into issues again with a different site, same story, Veeam agent backups that are now managed by VBR. I ended up using a modified version of the svc_nessus setup script to setup the PC's for Veeam, allowed in ports 139, 445 and 6160, removed creation of 'westgate' user account, but left in portion to add 'westgate' to local admin group. WMI logic remains in tact as Veeam needs access to hidden shared of 'C\$', 'ADMIN\$' & 'IPC\$'. I honestly think it is a matter of time between when the script runs and when Veeam decides it wants to see the changes. More testing is required to determine the true cause. As last thing I did was white list Veeam Server IP for each host's firewall...not really an ideal solution. 

> The uninstall issue is Veeam specific. The permissions issues are related to non-domain accounts specifically. 


## Veeam Agent & SentinelOne

Veeam will try to adjust the boot records of a machine when capturing backups. SentinelOne does not like this one bit, there's a group that could be created in SentinelOne, but I'm not sure of how to set that up, then point it to all of our (Wesgate Computers) Veeam Agent machines. 

The error code in Veeam will look similar to the following: 

```
Error: Failed to enable DC SafeBoot mode Cannot execute [SetIntegerElement] method of [\\SERVERDC01\root\wmi:BcdObject.Id="{29e04330-060f-11e8-a8a4-9d3d29195e45}",StoreFilePath=""]. COM error: Code: 0xd0000022 
```

You can manually alter the single machine via an Admin Terminal. Config file location `C:\Program Files\SentinelOne\Version x\SentinelCtl.exe`

Navigate to this directory in Admin CMD. Then run this command: 

`sentinelctl config -p agent.safeBootProtection -v false`

We had tamper protection enabled, so you would throw a -`k “Pass Phrase From Sentinel One Web Console Here”` on the end. But the passphrase for that device wasn’t working in my case. So I turned off tamper protection for the group (only the one server was in there) and I edited the config. On the device details in Sentinel one you can go to Actions> Configuration to see the SafeBootProtection settings and confirm when it updates from True to False then re enable tamper protection.

## How to migrate Veeam agent to associate with a New VBR Server

When a Veeam rescann or backup job fails for the following reason: 

`Error: Failed to generate certificate for office: host is managed by another backup server <HostName>.`

> If the original VBR server exists, remove the afflicted PC from any jobs or protection groups it is apart of. The new VBR server should be able to take over after a restart of the Veeam-Agent service of the target machine. 

Typically, once a machine has been removed from all jobs and protection groups on a Veeam Backup Server, records tying that Veeam Agent deployment to that Veeam Backup Server should be removed.

However, if the Veeam Backup Server managing the Veeam Agent deployment is no longer available or has been decommissioned, perform the following procedure to reset the Veeam Agent configuration, forcing it into standalone operation mode.

> **Note:** These steps should **not** be performed if the managing Veeam Backup Server is still active and accessible.

### **Standalone Reset Commands**

[ref KB-4548](https://www.veeam.com/kb4548)

For **Veeam Agent *for Microsoft Windows***, open an Administrative PowerShell prompt and execute:

`& 'C:\Program Files\Veeam\Endpoint Backup\Veeam.Agent.Configurator.exe' -removeOwner /i /force`

If the Veeam Agent *for Microsoft Windows* deployment was operating in [Managed by Server mode](https://helpcenter.veeam.com/docs/backup/agents/agent_job_protection_mode.html?zoom_highlight=%22Managed%20by%20backup%20server%22), the above command will exit with code 3:

```
Unable to set agent to self-managed mode because this backup agent is already managed by the backup server.

```

Use the Manual Standalone Reset Script below to forcibly untether the Veeam Agent *for Microsoft Windows* deployment from Veeam Backup & Replication.

**Manual Standalone Reset Script**
            
        
**Note:** When Veeam Agent *for Microsoft Windows* is deployed in [Managed by Server](https://helpcenter.veeam.com/docs/backup/agents/agent_job_protection_mode.html?zoom_highlight=%22Managed%20by%20backup%20server%22)
 mode, no shortcuts for the application are created in the start menu. 
The commands below to disassociate the deployment will not create those 
shortcuts. This procedure is only intended for migrating a Veeam Agent *for Microsoft Windows*
 deployment from being managed by a dead Veeam Backup Server to a new 
one. To achieve actual standalone operation, uninstall Veeam Agent *for Microsoft Windows* and reinstall using the [standalone package](https://www.veeam.com/windows-backup-download.html).
Open an Administrative PowerShell console and run the following commands:
*This process mimics the reset procedure the Veeam Agent Configurator would perform.*

```ps1
Remove-Item -Path $(Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.FriendlyName -eq "Veeam Agent Certificate" }).PSPath -Confirm:$false
Set-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam Agent for Microsoft Windows\ManagedMode" -Name "License" -Value "" -ErrorAction Ignore
Set-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -Name "DisableNotifications" -Value 0 -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "SerializedConnectionParams" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "ManagedModeInstallation" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "VbrServerName" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "CatchAllOwnership" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "VBRServerId" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "JobSettings" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "BackupServerIPAddress" -ErrorAction Ignore
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "RMMProviderMode" -ErrorAction IgnoreRemove-ItemProperty -Path "HKLM:\SOFTWARE\Veeam\Veeam EndPoint Backup" -name "ReadonlyMode" -ErrorAction Ignore
Restart-Service "Veeam Agent for Microsoft Windows"
```

For **Veeam Agent *for Linux*** and **Veeam Agent *for Mac***:

`sudo veeamconfig mode reset --force`