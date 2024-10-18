Score: 1 / 1

#### A backup administrator must enable guest file system indexing for a backup job of a Linux file server VM. All required credentials are added to the Veeam Backup & Replication server. VMware Tools (VIX) cannot be used due to security regulations. What should be done to make it possible in the following environment?

![](https://lwfiles.mycourse.app/64768b4fe486f630b28c2a65-public/855b908faab15635c9cfa0a05cad08e6.png)

    Connect the ESXi host to the VM network.

    Use the Veeam Backup & Replication server as a guest interaction proxy.

    Connect the Veeam Backup & Replication server to the VM network.

    Use the Windows proxy server as a guest interaction proxy.

Correct answer

Use the Windows proxy server as a guest interaction proxy.

Feedback

You are correct!

Score: 1 / 1

#### A company needs several VMware VMs restored back to their Fibre Channel SAN. A Veeam backup proxy is present as a VM on each ESXi host. Which transport mode will be used by default to restore these VMs?

    Quick Migration

    Network

    Virtual appliance

    Direct Storage Access (Direct SAN)

Correct answer

Direct Storage Access (Direct SAN)

Feedback

You are correct!

Score: 1 / 1

#### A Veeam backup proxy server is configured as follows: No modifications are allowed to the transport mode. When performing a restore of a thin-provisioned VMware virtual disk on an NFS data store using this proxy server, what transport mode will be used?

![](https://lwfiles.mycourse.app/64768b4fe486f630b28c2a65-public/d5876b26d044d5eea92a4c8fae2192e3.png)

    Network

    Virtual appliance

    Direct NFS access

    Direct SAN access

Correct answer

Direct NFS access

Feedback

You are correct!

## A company’s infrastructure consists of multiple VMware servers that store VMs on local storage. What proxy transport mode should be preferred to back up these VMs?

### Virtual Appliance

> In the Virtual appliance mode, Veeam Backup & Replication uses the VMware SCSI HotAdd capability that allows attaching devices to a VM while the VM is running. During backup, replication or restore disks of the processed VM are attached to the VMware backup proxy. VM data is retrieved or written directly from/to the datastore, instead of going through the network. Virtual Appliance Mode is recommended for Local Storage. For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/transport_modes.html?ver=120)


## 12 VMware VMs are being backed up daily by a forward incremental backup job, which has a 14-day retention, creating synthetic fulls on Saturdays. After running for more than 31 days, which of the following would be accurate?

### Both the performance tier and capacity tier will contain 14 to 20 days of restore points.

> You can combine both the Copy backups to object storage as soon as they are created option and the Move backups to object storage as they age out of the operational restores window option. In such a scenario, a copy session will be copying newly created backups right upon creation. For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/capacity_tier_copy.html?ver=120#combining-copy-and-move-operations)


## A daily VMware backup job retention is 31 days, keeping weekly GFS full backups for 14 weeks. It is Jan. 20. A file from a backup that occurred on Jan. 1 must be recovered. Where is the data?

### In the capacity tier

> Once the backup chain becomes inactive (for example, sealed) and exceeds the operational restore window, data blocks will be removed from each associated backup file in such an inactive backup chain and only metadata will be preserved. Such a behavior mimics data movement, but instead of moving data that was already copied, Veeam Backup & Replication purges associated data blocks from the performance extents. For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/capacity_tier_copy.html?ver=120#combining-copy-and-move-operations)

## A Veeam administrator is concerned about keeping backups on site and has traditionally used tapes to create weekly offsite backups and free up storage. Recently, concerns have arisen about being able to begin recovery without waiting for the tapes to return from off site. The company is currently using Scale-out Backup Repositories. What option would satisfy the requirement and maintain the weekly offsite copy?

### Move to capacity tier

> Capacity tier is an additional tier of storage that can be attached to a scale-out backup repository. Data from the scale-out backup repository performance extents can be transported to the capacity tier for long-term storage. This feature is useful to move inactive backup chains to capacity extents if you are running out of storage space on the performance extents. For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/capacity_tier.html?ver=120)

## An administrator has been tasked with creating a dynamic protection group to protect physical Linux servers. Where must the CSV file be stored?

### On a local drive of the Veeam Backup Server.

> The CSV file can reside in a folder on the local drive of the Veeam backup server or in a network shared folder accessible from the backup server. Technically, Windows Servers cannot access NFS shares without additional software (not specified.) For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/agents/protection_group_csv.html?ver=120#csv)

## When using an archive repository, when will a file from a NAS backup be moved to the archive?

### When the file is deleted.

> By default, all files deleted from the backup repository will be moved to the archive repository. If you do not need all the files in the archive, you can choose what files to keep. For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/file_share_backup_job_archive_repo.html?ver=120)

## Veeam Backup & Replication has been performed as a default all-in-one installation. A single backup job has been configured for some Windows VMs. Which mount server will be used for a file-level restore on a Windows VM during this process?

### The mount server configured for the repository

>Mount server associated with the backup repository on which the backup file resides. Veeam Backup & Replication uses this mount point when the restore process starts and allows you to browse the VM file system and restore files.
>
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/guest_restore_scenarios.html?ver=120)

## The administrator of a VMware vSphere environment needs to do an application-aware backup of a PostgreSQL database on a Linux VM. In order to do this, they must:

### Tick "Enable application-aware processing" in the VM backup job. No additional agents are necessary.

> Non-persistent runtime components help to avoid agent-related drawbacks such as pre-installing, troubleshooting and updating. These components are deployed on every VM added to the job when the job starts. As soon as the job finishes, the components are removed. This method is used for guest processing by default. For more information referr to the helpcenter.
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/non_persistent_runtime_components.html?ver=120)

## An administrator has decided to set up a VM backup job covering their Oracle servers. What feature must be enabled to ensure quiescence of the Oracle databases during the backup?

### Enable application-aware processing.

> To create transactionally consistent backups or replicas of VMs that run the following applications, you must enable application-aware processing in job settings: Microsoft Active Directory Microsoft SQL Server Microsoft SharePoint Microsoft Exchange Oracle PostgreSQL For more information referr to the helpcenter.
>
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/application_aware_processing.html?ver=120)

## An hourly backup job for seven Hyper-V VMs has been configured at the main site, keeping 14 days' worth of backup files. They want to get a copy of the VM backups to a repository at the disaster recovery site. They want to keep two months' worth of backup files at the disaster recovery site. They also need to be able to restore the VMs to any given day within two months and want to minimize the storage used at disaster recovery. How should a backup copy job be configured to meet these requirements?

### Use periodic copy (pruning) mode, keeping 62 days of retention.

> In the immediate copy mode, backup copy job copies the recent complete restore point created by a source backup job on the first run. On the next runs, Veeam Backup & Replication copies the oldest source restore points until there are no restore points left. In the periodic copy mode, backup copy job starts according to schedule. Backup copy job copies the recent complete restore point created by a source backup job on the first run. On the next runs backup copy job continues to copy the recent complete restore points. For more information referr to the helpcenter.
>
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/backup_copy_select_point.html?ver=120)

## An administrator is asked to change a backup copy job from periodic mode to immediate mode. How can this be accomplished?

### Modify the copy job settings in the console.

> Veeam Backup & Replication allows you to change the selected backup copy mode by editing backup copy job settings. For more information referr to the helpcenter.
>
> [Related Veeam Doc](https://helpcenter.veeam.com/docs/backup/vsphere/backup_copy_modes.html?ver=120#changing-backup-copy-modes)

## Which agent can perform full computer backups, to enable bare metal restores? Choosing two of the following:

###     Veeam Agent for IBM AIX & Veeam Agent for Oracle Solaris

> In case of a disaster, you can restore individual files and folders from backups to their original location or a new location. Bare metal recovery is not an option. For more information referr to the helpcenter. [Link](https://helpcenter.veeam.com/docs/agentformac/userguide/overview.html?ver=20)
>
> Options for question were: MacOS, IBM AIX, Oracle Solaris, FreeBSD and BeOS

## The Microsoft SQL Server on which the configuration database resides is corrupted. A backup administrator wants to deploy the configuration database on a new Microsoft SQL Server and recover data from the configuration backup. Which configuration restore mode should be used?

### Restore

> Select Restore if you want to restore data from the configuration backup to the database used by the initial backup server. Select Migrate if you want to restore data from the configuration backup to the database used by another backup server. For more information referr to the helpcenter.
>
> [Related Veeam Link](https://helpcenter.veeam.com/docs/backup/vsphere/restore_vbr_mode.html?ver=120)

## An infrastructure with 50 VMs has a power outage. After the VMware cluster has booted up again, three large VMs seem to be stuck in a boot loop. Assuming only the OS is installed on the VM OS disk, which method would require the least amount of backup data transferred to allow the VMs to boot?

### Perform a Virtual Disk Restore with the quick rollback feature disabled.

> It is recommended that you use quick rollback if you restore a VM or VM disk after a problem that has occurred at the level of the VM guest OS — for example, there has been an application error or a user has accidentally deleted a file on the VM guest OS. Do not use quick rollback if the problem has occurred at the VM hardware level, storage level or due to a power loss. For more information referr to the helpcenter.
>
> [Related Veeam Link](https://helpcenter.veeam.com/docs/backup/vsphere/incremental_restore.html?ver=120)

## A physical Linux server protected by a centrally managed Veeam agent is physically damaged. An Amazon EC2 infrastructure is available, and the physical server is eligible for virtualization. Which recovery step provides the lowest possible RTO?

### Restore to Amazon EC2 VM

> You can use the Veeam Backup & Replication console to restore computers from Veeam Agent backups to Amazon EC2. For more information referr to the helpcenter.
>
> [Related Veeam Link](https://helpcenter.veeam.com/docs/backup/agents/integration_restore_to_amazon.html?ver=120)

## Veeam Agent for Microsoft Windows has been installed in unmanaged mode on a Windows physical server. The backup job is configured to write to a Veeam repository. Which of the following media types is available for recovery media creation?

### SD card
- the fuck? 

> You can create a recovery image on different kinds of media: Removable storage devices such as USB drives or SD cards CD/DVD/BD ISO images on local or external computer drives For more information referr to the helpcenter.
>
> [Related Link](https://helpcenter.veeam.com/docs/agentforwindows/userguide/recovery_media.html?ver=60)

---

## At 18:00, after an issue, a VM is stuck in:  Error code 0xc000000f The application or operating system couldn't be loaded because a required file is missing or contains errors. The VM is configured as follows:

|   |   |
| --- | --- |
| Platform | Vmware vSphere | 
|  Application | SQL Server |
| Disk 1 (OS)  | 60 GB, CBT Enabled  |
| Disk 2(DATA) | 400 GB, CBT enabled |

## During troubleshooting, a VMware administrator found that a datastore was not available several times. The last backup was created at 01:00. Choose the recovery approach that provides the lowest RTO and least amount of data loss.

### Instant Disk Recovery 

> See [Veeam Docs](https://helpcenter.veeam.com/docs/backup/vsphere/disk_restores.html?ver=120)

## When restoring Linux or Unix guest OS files, which components can be used to mount the volume containing files to be restored? (Choose 2)

### Helper Appliance & Helper Host
(NFS, Helper Host, Mount Server, SMB, Helper appliance)

> Mounting disks to a helper host. As a helper host, you can select the target host where you want to restore files from the backup or any other Linux server. We recommend you to specify the same server to which you want to restore the files. This will improve the performance. Mounting disks to a helper appliance. The helper appliance is a helper VM running a stripped down Linux kernel that has minimal set of components. The appliance is quite small — around 50 MB. It requires 2048 MB RAM and 2 CPU. For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/guest_restore_linux.html?ver=120#how-restore-works)

## A database administrator is working on a PowerShell script. Due to an error, the script drops 10 tables out of 100 from the Microsoft SQL database. Veeam Explorer for Microsoft SQL will be used to restore it. Choose the option that will restore functionality with the minimum impact on user experience and RPO.

### Use the "Restore database schema and data" option to perform a restore of the deleted Microsoft SQL items.

> Use the Object and Data check boxes in the Database Schema and Data Restore Wizard to specify what database objects and data should be restored. For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/explorers/vesql_database_obj_schema.html?ver=120)

## What does Veeam's Staged Restore functionality enable during restores?

### Remove personal or sensitive data from VMs.

> Staged restore can help you ensure that recovered VMs do not contain any personal or sensitive data. For example, you can instruct Veeam Backup & Replication to run a Windows PowerShell script that removes Active Directory users For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/staged_restore_about.html?ver=120)

## In a replica job, if both replica mapping and replica seeding are chosen, which takes precedence?

### Replica mapping if a restored VM or replica is available

> NOTE: If a VM has a seed and is mapped to an existing replica, replication will be performed using replica mapping because mapping has a higher priority. For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/replica_seeding_vm.html?ver=120#configuring-replica-seeding)

## If a replication job is defined without modifying any settings on the schedule tab, when will the job first run?

### Never

> To run the replication job automatically, select the Run the job automatically check box. If you do not select this check box, you will have to start the job manually. For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/replica_schedule_vm.html?ver=120)

## Which Veeam failover option can result in data loss?

### Undo failover

> Failover undo is one of the ways to finalize failover. When you undo failover, you switch back from a VM replica to the source VM. Veeam Backup & Replication discards all changes made to the VM replica while it was in the Failover state. For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/undo_failover.html?ver=120)

## Due to a power outage, Site A is completely down. The disaster recovery strategy was implemented (see diagram). What is the correct way to start replicated VMs on Site B?

![SiteAToSiteB](https://lwfiles.mycourse.app/64768b4fe486f630b28c2a65-public/605df21c60b63db089c350610732c3ae.png)

### Power on VMs manually through vCenter.

> Site A is completely down. Veeam Backup & Replication Server is not available to initiate failover.


---

###### Take 2

## A company’s infrastructure consists of multiple VMware servers that store VMs on local storage. What proxy transport mode should be preferred to back up these VMs?

### Virtual appliance

> In the Virtual appliance mode, Veeam Backup & Replication uses the VMware SCSI HotAdd capability that allows attaching devices to a VM while the VM is running. During backup, replication or restore disks of the processed VM are attached to the VMware backup proxy. VM data is retrieved or written directly from/to the datastore, instead of going through the network. Virtual Appliance Mode is recommended for Local Storage. For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/transport_modes.html?ver=120)

## After a reboot a physical Windows server shows volume E as inaccessible. It looks like the volume has been corrupted. The server has several volumes: C (OS-60GB), D (data-2TB) and E (data-600GB). Employees urgently need to access the files on this volume. Which of the following would bring the server back up and running the fastest on the same hardware?

### Perform a Volume Level Restore for drive E.

> If data on a computer volume gets corrupted, you can restore this volume from the backup. For volume-level restore, you can use backups that were created at the volume level. File-level backups cannot be used for volume restore. For more information referr to the helpcenter.
>
> [Reladed Doc](https://helpcenter.veeam.com/docs/backup/agents/integration_volume_restore.html?ver=120)

## What does Veeam's Staged Restore functionality enable during restores?

### Remove personal or sensitive data from VMs.

> Staged restore can help you ensure that recovered VMs do not contain any personal or sensitive data. For example, you can instruct Veeam Backup & Replication to run a Windows PowerShell script that removes Active Directory users For more information referr to the helpcenter.
>
> [Related Doc](https://helpcenter.veeam.com/docs/backup/vsphere/staged_restore_about.html?ver=120)

