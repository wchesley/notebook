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