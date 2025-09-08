# Manually Create Templates

Created: April 12, 2021 10:57 PM

1. Create LXC container from standard template and customize it.
2. Shut down the customized LXC container and create a **backup** in the web UI. Use **GZIP** compression.
3. Rename and copy the backup into the **.../template/cache** folder where the other LXC templates are located.

I'm a CentOS fan, so when renaming, I just identified the new template as *custom* in the name.  For example...

Standard template name:   centos-7-default_20171212_amd64.tar.xz

Customized template name:  centos-7-custom_20190309_amd64.tar.gz

From my personal experience, the backups had names like vzdump-lxc-110-2021_04_12-21_07_31.tar.gz to which I renamed to something like alpine-3.12-golden_2021_04_12-21.tar.gz

- Default Local Backup Directory in Proxmox Host: `/mnt/data/prox-backup/dump`
- Default Local Template Storage in Proxmox Host: `/var/lib/vz/template/cache/`

### This guy does it in CLI:

[Customize a CentOS LXC Container with Proxmox * Nathan Curry](https://www.nathancurry.com/blog/15-customize-lxc-container-template-on-proxmox/)

# Create and connect to the container

The web UI is easy and fills out important info for you, but I created it through the CLI using a template I had preloaded.

`root@gold:~# pct create 105 gluster:vztmpl/centos-7-default_20171212_amd64.tar.xz --storage local-lvm --net0 *name*=eth0,ip=dhcp,ip6=dhcp,bridge=vmbr0 --password=password
root@gold:~# pct start 105
root@gold:~# pct console 105`

# Make desired changes

You can do pretty much anything, but keep it simple:

```
# Install packages
[root@CT105 ~]# yum -y update && yum -y install openssh-server vim sudo
# Add user
[root@CT105 ~]# adduser -G wheel nc
[root@CT105 ~]# passwd nc
# Enable passwordless sudo (welcome to non-production)
[root@CT105 ~]# visudo
# enable SSH
[root@CT105 ~]# systemctl enable sshd          
[root@CT105 ~]# systemctl start sshd   # so I can verify it works
# clean cache and tmp
[root@CT105 ~]# yum clean all
[root@CT105 ~]# rm -rf /var/cache/yum
[root@CT105 ~]# rm -rf /tmp/*
```

When you’re done, power it down;

`[root@CT105 ~]# poweroff`

# Roll it back up

Powering off dumps you right back into the host cli, where you run:

`root@gold:~# vzdump 105 --compress gzip --dumpdir /root/
root@gold:~# mv FILENAME.tar.gz /mnt/pve/gluster/template/cache/centos-7-ssh-20180908.tar.gz`

Now you can spin up instances with your new template.

