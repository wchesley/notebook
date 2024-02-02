# Wazuh Notes

Work notes, there's a readme on my laptop that I've not yet commited. 

# Windows changes: 

Added sysmon and a config. Sysmon is from [microsoft](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) and the config is from [olafhartong/sysmon-modular](https://github.com/olafhartong/sysmon-modular). Wazuh also provides a config using the same repo to construct theirs: https://wazuh.com/resources/blog/detecting-process-injection-with-wazuh/sysmonconfig.xml

~~Setup email alerts via postfix from Wazuh Server CLI, tests using CLI work and make it to my email, however I'm not seeing any alerts from Wazuh, despite having that configured.~~ This is working now, see [Email Alerts](./Email_Alerts.md)

### 12-12-2023

Created dedicated wazuh.westgate gmail address, credentials and appPasswd are in ITGlue. 

DHCP also gave issues, and this should have been done at server creation but I hadn't had an issue with it before...Reassigned VM to 50.63, and added DNS entry for Wazuh.domainname.local

**Users changes** when creating a read-only user, ie audit user account. I had to specify their roles as 'readall' and 'kibanauser' else you can't use the WebUI properly. Further more, webUI user accounts need to be configured from Wazuh Web UI -> Main Menu (Three lines, top left of screen) -> Under "OpenSearch Plugins" Select "Security" -> Select "Internal Users". 

### 12-14-2023

**Logon Failures**  
- `rule.id: 60122` -> Logon failure - Unknown user or bad password.  
- `data.win.eventdata.ipAddress: 127.0.0.1` -> in this case it was local host, as this example comes from me miss typing my password to my own machine.  

### 02-02-2024

Adding a Mac device is pretty simple, just have to run installer from bash shell instead of default zsh shell. Switch to bash via `/bin/bash` from terminal window, then run the installer as `sudo`. Past this, I don't see a need to configure a Mac device further. Most everything we're after appears configured out of the box. 

