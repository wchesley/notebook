# Proxmox

Created: April 12, 2021 10:57 PM

Proxmox VE is a complete, open-source server management platform for enterprise virtualization. It tightly integrates the KVM hypervisor and Linux Containers (LXC), software-defined storage and networking functionality, on a single platform. With the integrated web-based user interface you can manage VMs and containers, high availability for clusters, or the integrated disaster recovery tools with ease.

Free and Open Source Hypervisor. https://www.proxmox.com/en/proxmox-ve
[Documentation](https://pve.proxmox.com/pve-docs/) also built into the server. 
[Forums](https://forum.proxmox.com/)

## My docs and references: 
- [Post-Install Setup](./Setup.md)
- [2FA Setup](./2FA_Setup.md)
- [Email Alerts](./Email-Alerts.md)
- [Reset LXC password](./forgotLXC_passwd.md)
- [Manually Create Template LXC/VM](./Manually-Create-Templates.md)
- [Backups](./Proxmox-Backup.md)
- [Resize Disk](./resize_disk.md)
- [Storage](./Storage.md)


Make sure to add the community pve repo and get rid of the enterprise repo (you can skip this step if you have a valid enterprise subscription)
```bash
echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" >> /etc/apt/sources.list
rm /etc/apt/sources.list.d/pve-enterprise.list
```

## CPU Choice: 

Some VM's will perform better if the CPU type is set to 'host'. ie. Erxes Dev machine at work, when building the site, CPU would spike and hover around ~105%. Essentially locking up the VM until the site completed build cycle. Changing CPU type to 'Host' and rebuilt the site casues CPU to stay between 70-90% use, VM still usable, and had faster build times. 

## Kill stuck VM or LXC
Sometimes VMs or LXC's get stuck, mostly I can kill them with stop, but sometimes I forget and do shutdown instead. This hangs forever, stopping times out because it can't get the lock on the VM.  
* Find the VM by it's ID
  * `ps aux | grep "/usr/bin/kvm -id VMID"`
* Once we find the PID we kill the process using the command.
  * `kill -9 PID`

## Reset root password on PVE host

- Boot into grub, select single user but do not press enter.
- Press e to go into edit mode.
- Scroll down to the kernel line you will boot from, it starts with "linux /boot/vmlinuz-……."
- Scroll to the end of that line and press space key once and type init=/bin/bash
- Press Ctrl X to boot


**Remount / as Read/Write**  
`mount -rw -o remount /`

**Change the root account password with**  
`passwd`

**Change any other account password with**  
`passwd username`

**type new password, confirm and hit enter and then reboot.**
