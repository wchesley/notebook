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