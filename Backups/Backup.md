# Backup
Backup procedure and setup process

## Full Backup Procedure
1. plug in external HDD to PVE-Thor
2. check which device the system sees it as: `sudo fdisk -l`
3. mount the drive `sudo mount /dev/sdf1 /mnt/backup`
4. run rclone to mirror Nextpool to exHDD: `nohup ./full_backup.sh &`
5. Process runs for about 0-4hrs
6. unmount exHDD with `sudo umount /home/wchesley/backup`
7. uplug exHDD and store for next time.

The script will send notifications to the chesleyFamily Discord server, Alerts channel via webhook. This will backup everything with in the `zData` zfs pool that lives on Heimdal. 

## Setup
Recently been trying to automate backup process further, added udev rule to automount drive when it's plugged in. Found [here](https://superuser.com/questions/1433539/automatically-execute-backup-script-when-external-hard-drive-is-plugged-with-sys). Suggests adding (or creating) `/etc/udev/rules.d/80-autocomplete.rules` with the following rule: `ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="xxxyyy-1234-4567-8910-aaabbb", ENV{SYSTEMD_WANTS}+="media-backup.mount"`
> Finding device UUID with `sudo blkid` in my case "Elements" was also listed next to the partition `/dev/sdf1` listing.

After creating the udev rule I created a systemd service that depends on the `ENV{SYSTEMD_WANTS}` name in the udev rule. The service should run when drive is mounted. 

## Client File-Level Backups

Provided by BackupPC at 10.0.1.10/backuppc

Currently backing up both windows machines. This is a beta test of BackupPc. It's only getting my User folder at this time. 

End goal is to have this do filelevel backups for all clients at the house, then have another box of this setup offsite for remote backups. 

## VM & Container Backups

Anything that lives in Proxmox is backed up bi-weekly to `zData` pool on Heimdal. 

Gameservers are 'special' and get backed up nightly, plus a full backup weekly. 

There are a select few VM's and Containers that also get nightly backups to Tuxis, a cloud-based Proxmox Backup Server. 