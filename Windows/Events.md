<sub>[Back](./README.md)</sub>

# Windows Events

Windows Events are detailed records of system, security, and application activities stored by the operating system to aid in troubleshooting, monitoring, and auditing. Accessed via the Event Viewer tool (`eventvwr.msc`), these logs categorize data into Critical, Error, Warning, and Information levels to help identify root causes of failures or potential security breaches.

> [!NOTE]
> For a full list of windows events see [here](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/). This list is **not** managed or maintained by Microsoft. It **is** managed by a 3rd party.  

## Use Windows Event Viewer Review as an alternative to the attack surface
reduction rules reporting page in the Microsoft Defender portal

To review apps that would be blocked, open Event Viewer and filter 
for Event ID 1121 in the Microsoft-Windows-Windows Defender/Operational 
log. The following table lists all network protection events.

| Event ID | Description |
| --- | --- |
| 5007 | Event when settings are changed |
| 1121 | Event when an attack surface reduction rule fires in block mode |
| 1122 | Event when an attack surface reduction rule fires in audit mode |

## Logon Events

| Event ID | Description |
| --- | --- |
| 4648 | A logon was attempted using explicit credentials | 
| 4672 | Special Privileges assigned to new logon | 
| 4774 | An account was mapped for logon | 
| 4775 | An account could not be mapped for logon | 