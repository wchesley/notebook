# ZFS On Linux

## Table of Contents: 
- [ZFS Send/Receive](/ZFS/ZFS-send-receive)
- [ZFS Migration Plan](/ZFS/ZFS-migration-plan)

~~My setup was largely configured according to recommendations from Aaron Toponce's blog series on [ZFS Administration](https://pthree.org/2012/12/04/zfs-administration-part-i-vdevs/)~~ Moved over to using openzfs documentation instead, Aaron's article is great, but dated, written in 2012. Though openZFS docs are still very similar to Aaron Toponce's writings. 10/31/2023 -> Aaron's site is offline, can still access via archive.org.  

## Current configuration
- ~~2x2Tb Hdd's (WD and Hitachi) as ZFS Mirror~~
- Now using 4x2TB drives as ZFS striped mirror, renamed to Nextpool

Ran into a curious issue that is, I suspect, a result of the forced import of the OG Nextpool into the new server. My Resilver wouldn't get pas 3% and kept restarting
	- https://github.com/openzfs/zfs/issues/840
	- https://github.com/openzfs/zfs/issues/9551
	- https://serverfault.com/questions/994806/zpool-stuck-in-resilvering-loop
	- https://forums.freebsd.org/threads/stuck-in-degraded-resilver-endless-loop.49018/

One of those articles, think it was the first github issue, mentioned that WD drives weren't as good in ZFS? I've been using one for years in the OG pool, didn't have an issue till the resilver AND it was the WD drive that was having the issues during the resilver. Not directly an issue? But something to consider. Should probably change out the WD drive before any other one.

## Move pool mountpoint
* [stack exchange](https://unix.stackexchange.com/questions/311590/how-do-i-change-the-mount-point-for-a-zfs-pool)

`zfs set mountpoint=/mynewfolder mypool`

## Adding Disks by ID: 
* Lists disks with `ls -l /dev/disk/by-id/
* List from heimdall as of 3/9/2023:
```bash
root@heimdall:/home/wchesley# ls -l /dev/disk/by-id
total 0
lrwxrwxrwx 1 root root 10 Mar  4 02:02 dm-name-ubuntu--vg-ubuntu--lv -> ../../dm-0
lrwxrwxrwx 1 root root 10 Mar  4 02:02 dm-uuid-LVM-Y9yL2jOGxFEuAYWABh5RZqKIGCZiVbFVo2INfv1g3PcEz0GdSt0d5VAtTb39zUWp -> ../../dm-0
lrwxrwxrwx 1 root root 11 Mar  4 02:02 lvm-pv-uuid-52zGFy-XR7t-vIpW-0mR2-0ibc-10pE-NMEPvy -> ../../zd0p3
lrwxrwxrwx 1 root root 13 Mar  4 02:02 lvm-pv-uuid-i9W06I-7MFE-49x2-kG0W-BxYf-tXsy-sDjbRS -> ../../md126p3
lrwxrwxrwx 1 root root 11 Mar  4 02:02 md-uuid-f9887cf9:e13dfa65:dcc4e4f6:6fd27d41 -> ../../md127
lrwxrwxrwx 1 root root 11 Mar  4 02:02 md-uuid-ff19420b:71964c5d:08ea6ca3:e1909032 -> ../../md126
lrwxrwxrwx 1 root root 13 Mar  4 02:02 md-uuid-ff19420b:71964c5d:08ea6ca3:e1909032-part1 -> ../../md126p1
lrwxrwxrwx 1 root root 13 Mar  4 02:02 md-uuid-ff19420b:71964c5d:08ea6ca3:e1909032-part2 -> ../../md126p2
lrwxrwxrwx 1 root root 13 Mar  4 02:02 md-uuid-ff19420b:71964c5d:08ea6ca3:e1909032-part3 -> ../../md126p3
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-350000396a800ad1d -> ../../sdc
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-350000396a800ad1d-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-350000396a800ad1d-part9 -> ../../sdc9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-350000396a800aee5 -> ../../sdd
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-350000396a800aee5-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-350000396a800aee5-part9 -> ../../sdd9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-35000039ff3ee055f -> ../../sde
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-35000039ff3ee055f-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-35000039ff3ee055f-part9 -> ../../sde9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-35000cca01b36af28 -> ../../sdh
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-35000cca01b36af28-part1 -> ../../sdh1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-35000cca01b36af28-part9 -> ../../sdh9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-35000cca223c275c9 -> ../../sdg
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-35000cca223c275c9-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-35000cca223c275c9-part9 -> ../../sdg9
lrwxrwxrwx 1 root root  9 Mar  9 13:31 scsi-35000cca242d87d80 -> ../../sdl
lrwxrwxrwx 1 root root  9 Mar  9 13:30 scsi-35000cca242d87e0d -> ../../sdi
lrwxrwxrwx 1 root root  9 Mar  9 13:30 scsi-35000cca24dc3cdcf -> ../../sdj
lrwxrwxrwx 1 root root  9 Mar  9 13:30 scsi-35000cca24dc45294 -> ../../sdk
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-350014ee2069a9b9e -> ../../sdf
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-350014ee2069a9b9e-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-350014ee2069a9b9e-part9 -> ../../sdf9
lrwxrwxrwx 1 root root  9 Mar  9 14:44 scsi-3500a0751e6a399c8 -> ../../sdn
lrwxrwxrwx 1 root root  9 Mar  9 14:39 scsi-3500a0751e6a39b24 -> ../../sdm
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-355cd2e41504b9304 -> ../../sdb
lrwxrwxrwx 1 root root  9 Mar  9 14:44 scsi-SATA_CT1000MX500SSD1_2304E6A399C8 -> ../../sdn
lrwxrwxrwx 1 root root  9 Mar  9 14:39 scsi-SATA_CT1000MX500SSD1_2304E6A39B24 -> ../../sdm
lrwxrwxrwx 1 root root  9 Mar  9 13:31 scsi-SATA_HGST_HUS726060AL_NAHRW3YX -> ../../sdl
lrwxrwxrwx 1 root root  9 Mar  9 13:30 scsi-SATA_HGST_HUS726060AL_NAHRW8HX -> ../../sdi
lrwxrwxrwx 1 root root  9 Mar  9 13:30 scsi-SATA_HGST_HUS726060AL_NCG8BDTS -> ../../sdj
lrwxrwxrwx 1 root root  9 Mar  9 13:30 scsi-SATA_HGST_HUS726060AL_NCG9HT6S -> ../../sdk
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-SATA_Hitachi_HUA72302_YFG5DSUA -> ../../sdg
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SATA_Hitachi_HUA72302_YFG5DSUA-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SATA_Hitachi_HUA72302_YFG5DSUA-part9 -> ../../sdg9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-SATA_SSDSC2BB120G7R_PHDV843001ZY150MGN -> ../../sdb
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-SATA_TOSHIBA_DT01ACA2_14E87EAKS -> ../../sde
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SATA_TOSHIBA_DT01ACA2_14E87EAKS-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SATA_TOSHIBA_DT01ACA2_14E87EAKS-part9 -> ../../sde9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-SATA_WDC_WD20EARX-00P_WD-WCAZAD630190 -> ../../sdf
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SATA_WDC_WD20EARX-00P_WD-WCAZAD630190-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SATA_WDC_WD20EARX-00P_WD-WCAZAD630190-part9 -> ../../sdf9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-SHITACHI_HUS72302CLAR2000_YFGZ29HD -> ../../sdh
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SHITACHI_HUS72302CLAR2000_YFGZ29HD-part1 -> ../../sdh1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-SHITACHI_HUS72302CLAR2000_YFGZ29HD-part9 -> ../../sdh9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-STOSHIBA_AL13SEB300_Y510A0K0FRD6 -> ../../sdc
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-STOSHIBA_AL13SEB300_Y510A0K0FRD6-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-STOSHIBA_AL13SEB300_Y510A0K0FRD6-part9 -> ../../sdc9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 scsi-STOSHIBA_AL13SEB300_Y510A0L1FRD6 -> ../../sdd
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-STOSHIBA_AL13SEB300_Y510A0L1FRD6-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 scsi-STOSHIBA_AL13SEB300_Y510A0L1FRD6-part9 -> ../../sdd9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 usb-WD_Elements_25A3_5758333244433048594A4645-0:0 -> ../../sda
lrwxrwxrwx 1 root root 10 Mar  4 02:02 usb-WD_Elements_25A3_5758333244433048594A4645-0:0-part1 -> ../../sda1
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x50000396a800ad1d -> ../../sdc
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x50000396a800ad1d-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x50000396a800ad1d-part9 -> ../../sdc9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x50000396a800aee5 -> ../../sdd
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x50000396a800aee5-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x50000396a800aee5-part9 -> ../../sdd9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x5000039ff3ee055f -> ../../sde
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x5000039ff3ee055f-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x5000039ff3ee055f-part9 -> ../../sde9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x5000cca01b36af28 -> ../../sdh
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x5000cca01b36af28-part1 -> ../../sdh1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x5000cca01b36af28-part9 -> ../../sdh9
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x5000cca223c275c9 -> ../../sdg
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x5000cca223c275c9-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x5000cca223c275c9-part9 -> ../../sdg9
lrwxrwxrwx 1 root root  9 Mar  9 13:31 wwn-0x5000cca242d87d80 -> ../../sdl
lrwxrwxrwx 1 root root  9 Mar  9 13:30 wwn-0x5000cca242d87e0d -> ../../sdi
lrwxrwxrwx 1 root root  9 Mar  9 13:30 wwn-0x5000cca24dc3cdcf -> ../../sdj
lrwxrwxrwx 1 root root  9 Mar  9 13:30 wwn-0x5000cca24dc45294 -> ../../sdk
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x50014ee2069a9b9e -> ../../sdf
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x50014ee2069a9b9e-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Mar  4 02:02 wwn-0x50014ee2069a9b9e-part9 -> ../../sdf9
lrwxrwxrwx 1 root root  9 Mar  9 14:44 wwn-0x500a0751e6a399c8 -> ../../sdn
lrwxrwxrwx 1 root root  9 Mar  9 14:39 wwn-0x500a0751e6a39b24 -> ../../sdm
lrwxrwxrwx 1 root root  9 Mar  4 02:02 wwn-0x55cd2e41504b9304 -> ../../sdb
```

create zpool via `zpool create poolname mirror /dev/disk/by-id/scsi-SATA_CT1000MX500SSD1_2304E6A39B24 /dev/disk/by-id/ scsi-SATA_CT1000MX500SSD1_2304E6A399C8`

mirrored stripe*: `zpool create poolname mirror /dev/disk/by-id/scsi-SATA_CT1000MX500SSD1_2304E6A39B24 /dev/disk/by-id/ scsi-SATA_CT1000MX500SSD1_2304E6A399C8 mirror /dev/disk/by-id/scsi-SATA_CT1000MX500SSD1_2304E6A39B24 /dev/disk/by-id/ scsi-SATA_CT1000MX500SSD1_2304E6A399C8` 
<br><sub>* Drive id's are duplicated here intentionally</sub>