# PVE Backup 
Every LXC and VM gets backed up weekly on Saturday's starting at 3am. An alert email will be sent out to chesley.walker@gmail.com on each backup, successful or not. 
To add a LXC or VM to the backup schedule 
- log into Proxmox web gui
- click on Datacenter
- Click on Backup in the Datacenter submenu
- Highlight the top backup job, only day listed is Saturday
- Click Edit
	- A table of all LXC's and VM's will appear, check the newly added LXC or VM and click OK

## Weekly backup settings
- Full stop LXC or VM
- Compression is ZSTD
- Runs every Saturday at 3am

## Game Server Backups
I care just a smidgen more about loosing game progress, game servers are backed up nightly on top of the weekly backups. 
- Nightly backups are only snapshots
- Run every day BUT Saturday at 3:30am
- Email notifications are only on failure
- Included LXC's are Valheim and Minecraft 

# PBS Proxmox Backup Server
Free 150gb cloud hosted option from tuxis.nl
I've created your Proxmox Backup Server account. Please see the details below:

Host: pbs001.tuxis.nl
User: DB1476
Realm: pbs
Datastore: DB1476_chesley-PBS

Your PBS Password: alreadyChanged (Please change it ASAP!)

Login to https://pbs001.tuxis.nl:8007/ to check your pruning and verification settings.
If you have any questions please let us know.

grabbed this soley to back up gitlab instance elsewhere. almost lost that vm and would have lost a lot with it (this included)