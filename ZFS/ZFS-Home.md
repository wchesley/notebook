# ZFS On Linux
## Table of Contents: 
- [ZFS Send/Receive](/ZFS/ZFS-send-receive)
- [ZFS Migration Plan](/ZFS/ZFS-migration-plan)

~~My setup was largely configured according to recommendations from Aaron Toponce's blog series on [ZFS Administration](https://pthree.org/2012/12/04/zfs-administration-part-i-vdevs/)~~ Moved over to using openzfs documentation instead, Aaron's article is great, but dated, written in 2012. Though openZFS docs are still very similar to Aaron Toponce's writings.  

## Current configuration
- ~~2x2Tb Hdd's (WD and Hitachi) as ZFS Mirror~~
- Now using 4x2TB drives as ZFS striped mirror, renamed to Nextpool

Ran into a curious issue that is, I suspect, a result of the forced import of the OG Nextpool into the new server. My Resilver wouldn't get pas 3% and kept restarting
	- https://github.com/openzfs/zfs/issues/840
	- https://github.com/openzfs/zfs/issues/9551
	- https://serverfault.com/questions/994806/zpool-stuck-in-resilvering-loop
	- https://forums.freebsd.org/threads/stuck-in-degraded-resilver-endless-loop.49018/

One of those articles, think it was the first github issue, mentioned that WD drives weren't as good in ZFS? I've been using one for years in the OG pool, didn't have an issue till the resilver AND it was the WD drive that was having the issues during the resilver. Not directly an issue? But something to consider. Should probably change out the WD drive before any other one.