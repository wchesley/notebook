# Veeam Backup and Restore

Veeam Software is a Russian-founded and now privately held US-based information technology company owned by Insight Partners that develops backup, disaster recovery and modern data protection software for virtual, cloud-native, SaaS, Kubernetes and physical workloads. The company headquarters is in Columbus, Ohio, United States.

User guide is [here - warning 2.3k page pdf](https://www.veeam.com/veeam_backup_12_user_guide_vsphere_pg.pdf)

*has to be installed on windows*

## VBR Setup Issues

If you have an agent that was previously managed by another VBR or Veeam Service Provider Console (VSPC). The previous agent has to be totally removed before VBR can take over. While this can be requested from VSPC, we ran into an issue where it didn't remove it properly. Windows no longer see's it in intalled programs list but Veeam can't install a new Agent to the machine from VBR. 

This issue was resolved by removing all files and folders related to Veeam as well as the registry keys it created. A brief list of what was removed is below: 

- C:\Program Files\Veeam
- C:\ProgramData\Veeam
- C:\Users\<username>\AppData\Local\Veeam
- C:\Users\<username>\AppData\Roaming\Veeam
- HKLM:\SOFTWARE\Veeam

Once these were removed we could install Veeam Agent from VBR server to the individual machines. 