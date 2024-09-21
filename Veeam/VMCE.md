# Veeam Certififed Engineer (VMCE)

Exam notes as I go through VMCE training course targeting Veeam Backup & Replication version 12. 

## Forward vs Reverse Incremental Backups

![Forward vs Reverse Incremental Backups diagram](../Images/FwdVsReverseIncrementalBackups.jpg)

Forward backups start with a full backup and each incremental backup only tracks the changes since the last full backup. 

Reverse backups will always show the full backup as the latest restore point. The incremental changes are historical in this case and are rolled up into the full backup. This is a legacy method of backups when Veeam was targeting small/medium businesses, it was easier and more desirable for customers to export the latest (full) backup to removeable media. With modern filesystems this makes next to zero sense to implement. 

> #### Quote from [Veeam Forums](https://forums.veeam.com/veeam-agent-for-windows-f33/forward-incremental-vs-reverse-incremental-t88990.html)
> Reversed incremental is where Veeam started over 15 years ago. Back then we focused on VSMB customers, and having the latest backup as full backup available as a self-contained file provided certain benefits to those types of customers (it allowed for simple scripted export of backup files to removable media, tape etc.)
>
>These days, reverse incremental makes no sense because Veeam can do virtually everything natively (all those use cases that benefitted from reverse incremental backup format). While this backup mode never really had technical benefits, only drawbacks (in terms of performance and I/O load). We plan to discontinue reverse incremental backup mode in future, so I recommend you avoid deploying at least your new jobs like that. This, the comparison is very simple: don't use it :D
>
>Please note that literally every backup software has a concept of "backup chains" due to relying on incremental backup paradigm. Most just "hide" this fact from you because they do not let you select different types of backup chains. Veeam had to do it because we started from reverse incremental, then added more classic forward incremental for larger customers, but could not immediately remove reverse incremental due to many customers still having use cases dependent on that.
>
>In fact, it was not before later Veeam version and especially the proliferation of modern backup storage (ReFS/XFS/object) when reverse incremental really started to sink dramatically in our customer base, because it really does not make ANY sense for such deployments.

## GFS Grandfather, Father, Son

Veeams terminology for keeping multiple backup copies, ie keeping 1 weekly, 1 monthly and 1 yearly, so you always have 3 full extra backups at earlier dates in time on top of your normal backups (full backup + incrementals) in short term storage. GFS is more typical for archival storage and plays a key role in a Retention Policy. 

Retention policy is influenced by the frequency of backups, the way the backups are categorized, the total number of backups (Jobs, GFS, retention points), the rate of change in data foreach machine with a backup job. This also heavily influences the amount of storage you will need and where you will be able to store all backups and their copies. 