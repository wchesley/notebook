# Resize disks PVE - Ubuntu 20.04

Massive issues resizing a disk when plex was full: eventually resolved by this article: <https://forum.proxmox.com/threads/full-disk-usage-on-ubuntu-vm.53157/>\
\
\## Steps

I first resized disk in web UI \
Then got into the VM and ran the following: 

\- sudo /sbin/lvresize -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv

\- sudo /sbin/resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv