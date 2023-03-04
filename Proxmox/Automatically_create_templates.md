# Automatically create templates (Terraform)
Pulled together from two related posts from austinsnerdythings.com
- [how-to-create-a-proxmox-ubuntu-cloud-init-image](https://austinsnerdythings.com/2021/08/30/how-to-create-a-proxmox-ubuntu-cloud-init-image/)
- [how-to-deploy-vms-in-proxmox-with-terraform](https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/)
- [Terraform Proxmox Provider](https://github.com/Telmate/terraform-provider-proxmox)

## Overview
* make sure libguestfs-tools are installed on proxmox server: 
  * `sudo apt update -y && sudo apt install libguestfs-tools -y`

### Ubuntu
* Cloud images are pulled from https://cloud-images.ubuntu.com/
  * ie `wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img`
* with guestFS tools installed we can install packages to the image directly: 
  * `sudo virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent`
  * or run commands: `sudo virt-customize -a focal-server-cloudimg-amd64.img --run-command 'useradd UserName'`

### Fedora 
* images are pulled from: https://dl.fedoraproject.org/pub/alt/live-respins/
  * specifically after the kde build: https://dl.fedoraproject.org/pub/alt/live-respins/F37-LXDE-x86_64-LIVE-20230301.iso
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