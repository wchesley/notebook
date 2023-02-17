# Backup
Backup procedure and setup process

## Procedure
1. plug in external HDD to r720
2. check which device the system sees it as: `sudo fdisk -l`
3. mount the drive `sudo mount /dev/sdf1 /home/wchesley/backup`
4. run rclone to mirror Nextpool to exHDD: `sudo rclone sync /Nextpool /home/wchesley/backup -P --transfers 16`
5. Process runs for about 8-12hrs
6. unmount exHDD with `sudo umount /home/wchesley/backup`
7. uplug exHDD and store for next time. 

## Setup
Recently been trying to automate backup process further, added udev rule to automount drive when it's plugged in. Found [here](https://superuser.com/questions/1433539/automatically-execute-backup-script-when-external-hard-drive-is-plugged-with-sys). Suggests adding (or creating) `/etc/udev/rules.d/80-autocomplete.rules` with the following rule: `ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="xxxyyy-1234-4567-8910-aaabbb", ENV{SYSTEMD_WANTS}+="media-backup.mount"`
> Finding device UUID with `sudo blkid` in my case "Elements" was also listed next to the partition `/dev/sdf1` listing.

After creating the udev rule I created a systemd service that depends on the `ENV{SYSTEMD_WANTS}` name in the udev rule. The service should run when drive is mounted. 
