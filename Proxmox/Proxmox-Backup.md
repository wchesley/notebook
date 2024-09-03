# PVE Backup 

With 12.2 Veeam Backup & Repliation, Veeam now supports backups from a PVE host. [Notes here](../Veeam/Proxmox.md). This will be deployed and tested within the lab. 

For production use in the lab, we use Proxmox Backup Server as it's created soley for Proxmox backups. [Docs here](https://pbs.proxmox.com/docs/). 

## General
Every LXC and VM gets backed up daily starting at 2am. Each host runs their backup jobs at a separate time, starting about 1hr after the previous job started, so 2am, 3am and 4am all are backup start times. Odin is the first host to get backups, Loki and then Freja. An alert email will be sent out to chesley.walker@gmail.com on each backup, successful or not. 
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

### Local: 

Host: 10.0.100.254?
user: odin
realm: pve

Server gets backups from all 3 hosts, stored to zfs RAID 10 (4x8Tb). 

### Offsite - managed: 

Will use Thor's guts for a new PBS remote server. It will connect to the local PBS server and serve as a remote copy destination. The two sites will be connected over tailscale. The offsite deployment will be at the Lake house, as it's far, geographically speaking from my location, and is in an accessible spot that we don't have to pay for. IP schema of the Lake is unknown, but probably 192.168.0.0/24. 

remote user account should denote that it's a remote account in the name. 

### Offsite - Cloud (non-managed): 
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