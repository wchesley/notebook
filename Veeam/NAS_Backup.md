[back](./README.md)

# NAS Backups VBR v12

This document focuses on what's new in Veeam backup & replication v12 with **Network-attached storage (NAS)** backups. 

This document covers the following topics: 
- Understanding NAS backup - archive copy mode and direct-to-object storage
- Understanding NAS Backup wiht immutability support
- Discovering NFS backup publishing as an SMB sharej
- Learning about health check features adn the cloud helper appliance.

## Understanding NAS backup - Archive copy mode and direct-to-object storage

With VBR v12, you can add NAS shares to your inventory. Then you back them up to object storage and an archive repository for further retention. This process is accomplished when setting upp your file copy job to incude your NAS folders. 

When adding your NFS share on your NAS device, you have a wizard that walks you through setting things up: 

1. The first screen of the **File Share** wizard is the **NFS File Share** screen, where you input the location of your NAS share and set the **advanced** options. 
2. After enterign ytour information, click **Next >** to move to the **Processing** section to setup options: 
3. After setting the **Processing** options, clicck **Apply** to move to the **Apply** screen to make the changes, or add the file share. Click **Next >** to proceed to the **Summary** screen to review the settings and then click **Finish** to complete the **File Share** wizard. 

This adds the NFS share, which is the first step in backing up your NAS device and shares. Next we will look at both direct-to-object storage and archive repository options.

Complete the following steps to setup a new file copy job, sending it directly to object storage and configuring an archival repository: 
1. From the **Home** tab, you can right-click the job window and select **Backup | File share...** or use the **Backup Job** button in the toolbar.
2. You are then presented with the **New File Backup Job** window. Enter the **Name** and **Description** values, then click **Next >** to proceed to the **Files and Folders** tab. You do have the option to mark this job as **High Priority** as well if your backup window or SLA time requires this: 
3. You are now on the **Files and Folders** screen of the wizard, where you can select the `NFS` share added in the preceding section: 
4. After selecting your share and clicking **Ok**, click **Next >** to move to the **Backup Repository** window, where you can choose an object storage repository for the direct-to-object option: 
> **Note:**
>
> The default number of days to keep files is 28, which you can change to your desired configuration. You can also set advanced options such as file versions, access control lists (**ACL**) handling, srorage and so one, from the **Advanced** button. 

5. After selecting your repsoitory, click **Next >** to proceed to the **Archive repository** tab, where you can setup an archival copy of your NAS backups: At this point in the wizard, you can set the following things: 
   - The archive repository location can be local, network, or internet-based block or object storage
   - You can turn on the **Archive recent file versions** option to make immediate copies of your backup on the archive
   - You can turn on **Archive Oldest file versions for:**, which allows you to set a retention period in months or years. This option will move the oldest backup in the chain to the archive repository and remove it from primary storage to save space. 
   - Lastly, the **Files to archive** option defaults to **All**, but you can click **Choose...** button to select other options: Ie. include or exclude files by extension (file type)
6. After clicking **Next >**, you are then at the **Schedule** screen, where you can schedule your job to run. Click **Apply** to create your job, which presents the **Summary** screen, then click **Finish** to complete the wizard. 
> **Note:**
>
> You can run your job immediatly by turning on the **Run the job when I click Finish** checkbox, which will not wait for the scheduled time, instead running your job immediatley. 

### NAS Backup with Immutibility 

You will need object-storage with immutibility support for this to function. 

The process is the same as *NAS backup - Archive copy mode and direct-to-object storage*. The only difference is when you come to **Backup Repository** screen of the **New File Backup Job** wizard, you select an immutable repository to send your NAS backup to. 

After your backup completes you will have a line in the summary screen that states `Setting immutability for backup completed successfully`. 

## NFS backup publishing as an SMB share

