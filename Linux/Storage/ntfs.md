# NTFS

NTFS stands for New Technology File System. This file-storing system is standard on Windows machines, but Linux systems also use it to organize data.

Most Linux systems mount the disks automatically. However, in dual-boot setups, where file exchange is required between two systems with NTFS partitions, this procedure is performed manually.

Normally, mounting with NTFS will give you a read only file system. An example of mounting with read only file system:

`sudo mount -t ntfs /dev/sdz1 /mnt/ntfs`

## Mount NTFS with Read and Write Permissions

You will need to install `fuse` and `ntfs-3` on your system, for ubuntu/debian: 

```bash
sudo apt update
sudo apt install fuse ntfs-3g
```

In some cases (ubuntu) apt will show both as already installed, for Debian (proxmox) I was missing `ntfs-3g`. Now you can mount the partition with read and write permissions:

`sudo mount -t ntfs-3g /dev/sdz1 /mnt/ntfs`

You can confirm the partition is mounted with `df -hT`