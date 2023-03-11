# Proxmox

Created: April 12, 2021 10:57 PM

Proxmox VE is a complete, open-source server management platform for enterprise virtualization. It tightly integrates the KVM hypervisor and Linux Containers (LXC), software-defined storage and networking functionality, on a single platform. With the integrated web-based user interface you can manage VMs and containers, high availability for clusters, or the integrated disaster recovery tools with ease.

Free and Open Source Hypervisor. https://www.proxmox.com/en/proxmox-ve
[Documentation](https://pve.proxmox.com/pve-docs/) also built into the server. 
[Forums](https://forum.proxmox.com/)

## My docs and references: 
- [Email Alerts](./Email-Alerts.md)
- [Reset LXC password](./forgotLXC_passwd.md)
- [Manually Create Template LXC/VM](./Manually-Create-Templates.md)
- [Backups](./Proxmox-Backup.md)
- [Resize Disk](./resize_disk.md)


Make sure to add the community pve repo and get rid of the enterprise repo (you can skip this step if you have a valid enterprise subscription)
```bash
echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" >> /etc/apt/sources.list
rm /etc/apt/sources.list.d/pve-enterprise.list
```
q
## Kill stuck VM or LXC
Sometimes VMs or LXC's get stuck, mostly I can kill them with stop, but sometimes I forget and do shutdown instead. This hangs forever, stopping times out because it can't get the lock on the VM.  
* Find the VM by it's ID
  * `ps aux | grep "/usr/bin/kvm -id VMID"`
* Once we find the PID we kill the process using the command.
  * `kill -9 PID`