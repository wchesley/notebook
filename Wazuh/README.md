# Wazuh

Free open source SIEM

## Notes to be stored later: 

- [Wazuh Rules](./rules.md)
  - [Active Directory Rules](./AD_rules.md)
- [TSC/SOC Compliance](./TSC-SOC.md)
- [Email Alerts](./Email_Alerts.md)
- [Notes from work](./Notes.md)

configured 'operational' user on my edge router for wazuh, enabled it's ssh access, had to change it's login shell (default to `/usr/bin/nologin`) then give it control over it's `~/.ssh/authorized_keys` file, `chown wazuh:users /home/wazuh/.ssh/authorized_keys`.

Enabled syslog on wazuh server: https://documentation.wazuh.com/current/user-manual/capabilities/log-data-collection/syslog.html
configured edge router to send logs here in web UI. Swapped this from `tcp` to `udp` evening of 12/13 as I wasn't getting any logs from it, haven't looked at it since then. 

also added edge router as agentless monitor: https://documentation.wazuh.com/current/user-manual/capabilities/agentless-monitoring/agentless-configuration.html

Email alerts are setup from homelab. 

sysmon config is added to win11 laptop, found a way to make it shut up about apps to via [this tech Community article (microsoft)](https://techcommunity.microsoft.com/t5/sysinternals-blog/sysmon-the-rules-about-rules/ba-p/733649). 
- I'd like a way to fine tune sysmon monitoring, I doubt work will use it on endpoints, but for sure on servers. 

also ref: 
https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/localfile.html#log-format
https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/localfile.html


## Wazuh API failed to connect

Happens occasionally after a reboot or change to wazuh config. Just restart wazuh-manager service via `systemctl restart wazuh-manager`. Give it a few minutes to restart, then check `systemctl status wazuh-manager`. 