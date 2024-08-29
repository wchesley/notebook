# Veeam Backup and Restore

Veeam Software is a Russian-founded and now privately held US-based information technology company owned by Insight Partners that develops backup, disaster recovery and modern data protection software for virtual, cloud-native, SaaS, Kubernetes and physical workloads. The company headquarters is in Columbus, Ohio, United States.

# Notes: 

1. [Installation (v12)](./Installation.md)
2. [Security (v12)](./VBR_v12_Security_Updates.md)
3. [NAS Backups (v12)](./NAS_Backup.md)
4. [Proxmox VE Integration](./Proxmox.md)
5. [User guide - warning 2.3k page pdf](https://www.veeam.com/veeam_backup_12_user_guide_vsphere_pg.pdf)

*has to be installed on windows*

## Upgrade Veeam Backup & Replication

ref: [Upgrade VBR to 12.2](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr.html?ver=120)

- In essence, download the new versions ISO from Veeam. 
- open the ISO once download is complete
- run `setup.exe` located within root directory of ISO
- Follow the wizard to upgrade Veeam Backup & Replication

To perform upgrade of Veeam Backup & Replication to version
 12.2, you must be running version 11a (build 11.0.1.1261) or later on 
the supported operating system (refer to the [System Requirements](https://helpcenter.veeam.com/docs/backup/hyperv/system_requirements.html) section of this document). For information on upgrade from earlier versions, see [this Veeam KB article](https://www.veeam.com/kb2053).

Before you upgrade Veeam Backup & Replication, [check prerequisites](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_byb.html). Then use the Veeam Backup & Replication upgrade wizard to install the product.

1. [Start the upgrade wizard](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_launch.html).
2. [Select the component to upgrade](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_select_component.html).
3. [Read and accept the license agreement](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_license_agreement.html).
4. [Review the components that will be upgraded](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_upgrade.html).
5. [Provide a license file](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_license.html).
6. [Install missing software](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_missing.html).
7. [Specify service account settings](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_service_account.html).
8. [Specify the database engine and instance](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_database.html).
9. [Perform the configuration check](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_configuration_check.html).
10. [Begin upgrade](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_ready_to_upgrade.html).

## VBR Setup Issues

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