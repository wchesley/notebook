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

`# Install packages
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
[root@CT105 ~]# rm -rf /tmp/*`

When you’re done, power it down;

`[root@CT105 ~]# poweroff`

# Roll it back up

Powering off dumps you right back into the host cli, where you run:

`root@gold:~# vzdump 105 --compress gzip --dumpdir /root/
root@gold:~# mv FILENAME.tar.gz /mnt/pve/gluster/template/cache/centos-7-ssh-20180908.tar.gz`

Now you can spin up instances with your new template.

# Automatically create templates (Terraform)
Pulled together from two related posts from austinsnerdythings.com
- [how-to-create-a-proxmox-ubuntu-cloud-init-image](https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/)
- [how-to-deploy-vms-in-proxmox-with-terraform](https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/)
- [Terraform Proxmox Provider](https://github.com/Telmate/terraform-provider-proxmox)

## Overview
* make sure libguestfs-tools are installed on proxmox server: 
  * `sudo apt update -y && sudo apt install libguestfs-tools -y`
* Cloud images are pulled from https://cloud-images.ubuntu.com/
  * ie `wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img`
* with guestFS tools installed we can install packages to the image directly: 
  * `sudo virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent`
  * or run commands: `sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'useradd austin'`
* Tie it all together in a nice bash script: <br><sub>Current script as of 03/02/2023</sub>
```bash
#!/bin/bash
#cd "$(dirname "$0")"
WEBHOOK_URL="https://discord.com/api/webhooks/1080958430103224430/Bspnp_rcrZRbmlEfBoqf4LJGpG639ZFaXAaDZ_KKKECoYJefJp9uaGtc1GUQnqJzAebd"
#CURRENTDATE=`date +"%Y-%m-%d %T"`
CURRENTDATE()
{
 date +"%Y-%m-%d %T"
}
cd "$(dirname ${BASH_SOURCE[0]})"
echo "Working out of: ${PWD}"
## Download weekly image: 
# Remove old image: 
/usr/bin/curl -H "Content-Type: application/json" -d '{"username":"Weekly Ubuntu Image Maker", "content":"Starting setup of new weekly image, time: '"${CURRENTDATE}"'"}' $WEBHOOK_URL
rm jammy-server-cloudimg-amd64.img
# Remove old template:
qm destroy 9000
echo "old image and template removed, fetching new one"
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
/usr/bin/curl -H "Content-Type: application/json" -d '{"username":"Weekly Ubuntu Image Maker", "content":"New Image Downloaded. Starting setup, time: '"${CURRENTDATE}"'"}' $WEBHOOK_URL
## Cloud-init:
virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent
# Ansible setup: 
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'useradd ansible'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'mkdir -p /home/ansible/.ssh'
virt-customize -a jammy-server-cloudimg-amd64.img --ssh-inject ansible:file:/root/.ssh/id_rsa.pub
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'chown -R ansible:ansible /home/ansible'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'usermod -aG sudo ansible'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'useradd wchesley'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'mkdir -p /home/wchesley'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'usermod -aG sudo wchesley'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'chow -R wchesley:wchesley /home/wchesley'
virt-customize -a jammy-server-cloudimg-amd64.img --run-command 'ufw allow from 192.168.0.0/24 to any port 22'
## Create VM: 
/usr/bin/curl -H "Content-Type: application/json" -d '{"username":"Weekly Ubuntu Image Maker", "content":"Setup complete creating VM and teplating, time: '"${CURRENTDATE}"'"}' $WEBHOOK_URL
qm create 9000 --name "ubuntu-gold-weekly" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0,firewall=1
qm importdisk 9000 jammy-server-cloudimg-amd64.img local-lvm
qm set 9000 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-9000-disk-0
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 local-lvm:cloudinit
qm set 9000 --agent enabled=1
qm template 9000
echo "now, clone the template and expand the disk"
/usr/bin/curl -H "Content-Type: application/json" -d '{"username":"Weekly Ubuntu Image Maker", "content":"Templating complete, new image is ready, time: '"${CURRENTDATE}"'"}' $WEBHOOK_URL
```

* ~~So far process leaves me with broken network, had to set netplan by hand. need to find a way to automate disk resizing, ansible maybe? oh, and had to reset root password from cloud init file...~~
* Fixed network, had a line in there that ignored network changes just before setting the IP address...removed that line and network works...also, changing disk type (in template for now, from web GUI) to virtio SCSI Single, automagically expanded the disk for me upon vm creation with terraform. 
* Added Alerts to discord with scripts progress and a `CURRENTDATE` function. 