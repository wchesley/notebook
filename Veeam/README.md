[back](../README.md)

# Veeam Backup and Restore

Veeam Software is a Russian-founded and now privately held US-based information technology company owned by Insight Partners that develops backup, disaster recovery and modern data protection software for virtual, cloud-native, SaaS, Kubernetes and physical workloads. The company headquarters is in Columbus, Ohio, United States.

# Notes: 

1. [Installation (v12)](./Installation.md)
2. [Security (v12)](./VBR_v12_Security_Updates.md)
3. [NAS Backups (v12)](./NAS_Backup.md)
4. [Proxmox VE Integration](./Proxmox.md)
5. [Deployment](./Deployment.md)
6. [Upgrade VBR 12](./Upgrade_VBR.md)
7. [Setup Issue Notes](./Setup_Issues.md)
8. [Security Guidelines](./Security_Guidelines.md)
9. [User guide - warning 2.3k page pdf](https://www.veeam.com/veeam_backup_12_user_guide_vsphere_pg.pdf)

*has to be installed on windows*

## Terms

- **Recovery Point Objective (RPO)** - Period of time which you may accept to lose data. This is the time from the latest restore point to when the failure occured.
- **Recover Time Objective (RTO)** - The amount of time from the beginning of an incident until all services are back online and available to users. How long can we wait for restore to take place? How long can we accept being down? 
- **3-2-1 Rule** - The Golden Rule of backups, this is not Veeam specific: 
  - **3** - You must have at least 3 copies of your data, the original production copy and two backups. First copy is the original production data. Second copy is a backup created by a backup job. Third copy is a copy of the backup to another location, preferably offsite, Tape, air-gapped machine or cloud (S3) storage.
  - **2** - You must use at least two different types of media to store copies of data
  - **1** - You must keep at least one backup off-site. Ie. in the cloud or a remote site. One of the (backup) repositories must be offline, air-gapped or immutable.  

## Naming Conventions

Do not use Microsoft Windows reserved names for names of the backup server, managed servers, backup repositories, jobs, tenants and other objects created inVeeam Backup & Replication: CON, PRN, AUX, NUL, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8, COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8 and LPT9.

If you plan to store backups on a repository operating in the per-machine mode, do not use Microsoft Windows reserved names for names of the virtual machines to 
back up.

If you use a reserved name, Veeam Backup & Replication may not work as expected. For more information on naming conventions in Microsoft Windows, see [Microsoft Docs](https://msdn.microsoft.com/en-us/library/aa365247.aspx?f=255&MSPPError=-2147217396#naming_conventions).
