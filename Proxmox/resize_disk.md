# Resize disks PVE - Ubuntu 20.04

Massive issues resizing a disk when plex was full: eventually resolved by this article: <https://forum.proxmox.com/threads/full-disk-usage-on-ubuntu-vm.53157/>

## Steps

I first resized disk in web UI 
Then got into the VM and ran the following: 

`- sudo /sbin/lvresize -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv`

`- sudo /sbin/resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv`

> As of 1/10/2024, provided LVM is used for file system, I've only had to run the above two commands to expand a disk and host see's changes live. 

# Process per notebook
Process per my hand written notes: 
1. Power down VM
	1. Add space to disk via proxmox webUI
2. Power up VM 
	1. in VM console run: `sudo fdisk -l` to verify VM see's new space
3. Run `sudo parted`
   1. `parted` detect that you're not using all the space available and offers to fix/ignore, I chose fix then proceeded with step 4, the `print` command wasn't necessary as telling `parted` to fix it showed the partitions. step 5 & 6 weren't necessary in this case. 	
4. From parted shell: 
	1. `(parted) print` -> lists partitions and their sizes (in bytes I think) root partition is typically #3 
	2. `(parted) resizepart 3 100%` Tell partition 3 to use all available space
	3. `(parted) quit` exit parted shell 
5. Run `sudo pvresize /dev/sda3` use whatever /dev/sda your root partition is on, check back on `fdisk -l` if you forget. 
6. Run `sudo lvextend -l 100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv` Have LVM consume rest of partition
7. run `sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv` Have filesystem consume rest of free space. 

Though I'm not 100% on the specifics for any of this, I know it works, have had to resize Plex VM a few times now. 

## From PVE Wiki: 

###### [Link to PVE Wiki - Resize Disk](https://pve.proxmox.com/wiki/Resize_disks)

### 2. Enlarge the partition(s) in the virtual disk

Depending on the installed guest there is several diffent ways to resize the partions
Offline for all guests

- Use gparted or similar tool (recommended)
In gparted and possibly most other tools, LVM and Windows dynamic disc is not supported

Boot the virtual machine with gparted or similar tool, enlarge the partion and optionally the file system. With som linux clients you often need to enlarge the extended partion, move the swappartion, shrink the extended partion and enlarge the root partion. (or simple delete the swap and partion andre create it again - but remember to activwate the swap agin (last step).
Gparted have some warnings about some specific operations not well supported with windows guest - outside the scope of this document but read the warnings in gparted.


#### Online for Windows Guests

Guest is Windows 7, Windows Vista or Windows Server 2008
logon as administrator and extend the disk and filesystem (Using Disk manager)
For more info www.petri.co.il/extend-disk-partition-vista-windows-server-2008.htm
Guest is Windows 10: logon as administrator and extend the disk and filesystem (Using Disk manager). If you do not see the ability to extend the disk (i.e. nothing seems to have happened as a result of using the resize command), go to the Windows command prompt and do a: shutdown -s -t 0 (This is a "normal" shutdown, as opposed to the "fast" shutdown that's the default for Win 8 and onwards.) After a reboot, you'll now see the ability to expand the disk.

#### Online for Linux Guests

Here we will enlarge a LVM PV partition, but the procedure is the same for every kind of partitions. Note that the partition you want to enlarge should be at the end of the disk. If you want to enlarge a partition which is anywhere on the disk, use the offline method.

##### Check that the kernel has detected the change of the hard drive size

(here we use VirtIO so the hard drive is named vda)

	dmesg | grep vda
	[ 3982.979046] vda: detected capacity change from 34359738368 to 171798691840

Example with EFI

##### Print the current partition table

	fdisk -l /dev/vda | grep ^/dev
	GPT PMBR size mismatch (67108863 != 335544319) will be corrected by w(rite).
	/dev/vda1      34     2047     2014 1007K BIOS boot
	/dev/vda2    2048   262143   260096  127M EFI System
	/dev/vda3  262144 67108830 66846687 31.9G Linux LVM


##### Resize the partition 3 (LVM PV) to occupy the whole remaining space of the hard drive)

	parted /dev/vda
	(parted) print
	Warning: Not all of the space available to /dev/vda appears to be used, you can
	fix the GPT to use all of the space (an extra 268435456 blocks) or continue
	with the current setting? 
	Fix/Ignore? F 

	(parted) resizepart 3 100%
	(parted) quit

Example without EFI

Another example without EFI using parted:

	parted /dev/vda

	(parted) print

	Number  Start   End     Size    Type      File system  Flags
	1       1049kB  538MB   537MB   primary   fat32        boot
	2       539MB   21.5GB  20.9GB  extended
	3       539MB   21.5GB  20.9GB  logical                lvm

Yoy will want to resize the 2nd partition first (extended):

	(parted) resizepart 2 100%
	(parted) resizepart 3 100%

##### Check the new partition table

	(parted) print

	Number  Start   End     Size    Type      File system  Flags
	1       1049kB  538MB   537MB   primary   fat32        boot
	2       539MB   26.8GB  26.3GB  extended
	3       539MB   26.8GB  26.3GB  logical                lvm

	(parted) quit


### 3. Enlarge the filesystem(s) in the partitions on the virtual disk

If you did not resize the filesystem in step 2

### Online for Linux guests with LVM

Enlarge the physical volume to occupy the whole available space in the partition:

	pvresize /dev/vda3

List logical volumes:

	lvdisplay

	--- Logical volume ---
	LV Path                /dev/{volume group name}/root
	LV Name                root
	VG Name                {volume group name}
	LV UUID                DXSq3l-Rufb-...
	LV Write Access        read/write
	LV Creation host, time ...
	LV Status              available
	# open                 1
	LV Size                <19.50 GiB
	Current LE             4991
	Segments               1
	Allocation             inherit
	Read ahead sectors     auto
	- currently set to     256
	Block device           253:0


Enlarge the logical volume and the filesystem (the file system can be mounted, works with ext4 and xfs). Replace "{volume group name}" with your specific volume group name:

#This command will increase the partition up by 20GB

	lvresize --size +20G --resizefs /dev/{volume group name}/root 

#Use all the remaining space on the volume group  

	lvresize --extents +100%FREE --resizefs /dev/{volume group name}/root
