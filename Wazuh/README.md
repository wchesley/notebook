# Wazuh

Free open source SIEM

## Notes to be stored later: 

- [Notes from work](./Notes.md)
- [Email Alerts](./Email_Alerts.md)

configured 'operational' user on my edge router for wazuh, enabled it's ssh access, had to change it's login shell (default to `/usr/bin/nologin`) then give it control over it's `~/.ssh/authorized_keys` file, `chown wazuh:users /home/wazuh/.ssh/authorized_keys`.

Enabled syslog on wazuh server: https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/syslog.html
configured edge router to send logs here in web UI. 

also added edge router as agentless monitor: https://documentation.wazuh.com/current/user-manual/capabilities/agentless-monitoring/agentless-configuration.html

Email alerts are setup from homelab. 

sysmon config is added to win11 laptop, found a way to make it shut up about apps to via [this tech Community article (microsoft)](https://techcommunity.microsoft.com/t5/sysinternals-blog/sysmon-the-rules-about-rules/ba-p/733649). 
- I'd like a way to fine tune sysmon monitoring, I doubt work will use it on endpoints, but for sure on servers. 

also ref: 
https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/localfile.html#log-format
https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/localfile.html
