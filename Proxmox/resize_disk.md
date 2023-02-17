# Resize disks PVE - Ubuntu 20.04

Massive issues resizing a disk when plex was full: eventually resolved by this article: <https://forum.proxmox.com/threads/full-disk-usage-on-ubuntu-vm.53157/>

## Steps

I first resized disk in web UI 
Then got into the VM and ran the following: 

`- sudo /sbin/lvresize -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv`

`- sudo /sbin/resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv`

# Process per notebook
Process per my hand written notes: 
1. Power down VM
	1. Add space to disk via proxmox webUI
2. Power up VM 
	1. in VM console run: `sudo fdisk -l` to verify VM see's new space
3. Run `sudo parted`
4. From parted shell: 
	1. `(parted) print` -> lists partitions and their sizes (in bytes I think) root partition is typically #3 
	2. `(parted) resizepart 3 100%` Tell partition 3 to use all available space
	3. `(parted) quit` exit parted shell 
5. Run `sudo pvresize /dev/sda3` use whatever /dev/sda your root partition is on, check back on `fdisk -l` if you forget. 
6. Run `sudo lvextend -l 100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv` Have LVM consume rest of partition
7. run `sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv` Have filesystem consume rest of free space. 

Though I'm not 100% on the specifics for any of this, I know it works, have had to resize Plex VM a few times now. 