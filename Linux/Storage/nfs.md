# NFS

- [NFS Performance Tuening](./nfs_performance.md)

My current mount settings for new hosts: `192.168.0.118:/zData /mnt/Nextpool nfs nfsvers=4.2,rsize=1048576,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0`

add that line into `/etc/fstab`, run `system daemon-reload` and `mount -a` to mount that nfs share to `/mnt/Nextpool`. Ensure the directory exists first, ie. `mkdir -p /mnt/Nextpool`
  
- [Ref Archwiki](https://wiki.archlinux.org/title/fstab#Automount_with_systemd)
- [The Glorious Stackexchange](https://unix.stackexchange.com/questions/654952/consistent-auto-mount-of-external-hard-drive)
- [NFS Client and Server](./NFS-Client-and-Server.md)
- [Digital Ocean guide for NFS client & Server](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04)