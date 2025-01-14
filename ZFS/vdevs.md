[back](./README.md)

# VDEVs

## Virtual Device Introduction

To start, we need to understand the concept of virtual devices, or VDEVs, as ZFS uses them internally extensively. If you are already familiar with RAID, then this concept is not new to you, although you may not have referred to it as "VDEVs". Basically, we have a meta-device that represents one or more physical devices. In Linux software RAID, you might have a "/dev/md0" device that represents a RAID-5 array of 4 disks. In this case, "/dev/md0" would be your "VDEV".

There are seven types of VDEVs in ZFS:

1. disk (default)- The physical hard drives in your system.
2. file- The absolute path of pre-allocated files/images.
3. mirror- Standard software RAID-1 mirror.
4. raidz1/2/3- Non-standard distributed parity-based software RAID levels.
5. spare- Hard drives marked as a "hot spare" for ZFS software RAID.
6. cache- Device used for a level 2 adaptive read cache (L2ARC).
7. log- A separate log (SLOG) called the "ZFS Intent Log" or ZIL.

It's important to note that VDEVs are always dynamically striped. This will make more sense as we cover the commands below. However, suppose there are 4 disks in a ZFS stripe. The stripe size is calculated by the number of disks and the size of the disks in the array. If more disks are added, the stripe size can be adjusted as needed for the additional disk. Thus, the dynamic nature of the stripe.
Some zpool caveats

I would be amiss if I didn't meantion some of the caveats that come with ZFS:

    Once a device is added to a VDEV, it cannot be removed.
    You cannot shrink a zpool, only grow it.
    RAID-0 is faster than RAID-1, which is faster than RAIDZ-1, which is faster than RAIDZ-2, which is faster than RAIDZ-3.
    Hot spares are not dynamically added unless you enable the setting, which is off by default.
    A zpool will not dynamically rezise when larger disks fill the pool unless you enable the setting BEFORE your first disk replacement, which is off by default.
    A zpool will know about "advanced format" 4K sector drives IF AND ONLY IF the drive reports such.
    Deduplication is EXTREMELY EXPENSIVE, will cause performance degredation if not enough RAM is installed, and is pool-wide, not local to filesystems.
    On the other hand, compression is EXTREMELY CHEAP on the CPU, yet it is disabled by default.
    ZFS suffers a great deal from fragmentation, and full zpools will "feel" the performance degredation.
    ZFS suports encryption natively, but it is NOT Free Software. It is proprietary copyrighted by Oracle.

For the next examples, we will assume 4 drives: /dev/sde, /dev/sdf, /dev/sdg and /dev/sdh, all 8 GB USB thumb drives. Between each of the commands, if you are following along, then make sure you follow the cleanup step at the end of each section.
## A simple pool

Let's start by creating a simple zpool wyth my 4 drives. I could create a zpool named "tank" with the following command:

`# zpool create tank sde sdf sdg sdh`

In this case, I'm using four disk VDEVs. Notice that I'm not using full device paths, although I could. Because VDEVs are always dynamically striped, this is effectively a RAID-0 between four drives (no redundancy). We should also check the status of the zpool:

```bash
# zpool status tank
  pool: tank
 state: ONLINE
 scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  sde       ONLINE       0     0     0
	  sdf       ONLINE       0     0     0
	  sdg       ONLINE       0     0     0
	  sdh       ONLINE       0     0     0

errors: No known data errors
```

Let's tear down the zpool, and create a new one. Run the following before continuing, if you're following along in your own terminal:

`# zpool destroy tank`

## A simple mirrored zpool

In this next example, I wish to mirror all four drives (/dev/sde, /dev/sdf, /dev/sdg and /dev/sdh). So, rather than using the disk VDEV, I'll be using "mirror". The command is as follows:

```bash
# zpool create tank mirror sde sdf sdg sdh
# zpool status tank
  pool: tank
 state: ONLINE
 scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sde     ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	    sdg     ONLINE       0     0     0
	    sdh     ONLINE       0     0     0

errors: No known data errors
```

Notice that "mirror-0" is now the VDEV, with each physical device managed by it. As mentioned earlier, this would be analogous to a Linux software RAID "/dev/md0" device representing the four physical devices. Let's now clean up our pool, and create another.

`# zpool destroy tank`

## Nested VDEVs

VDEVs can be nested. A perfect example is a standard RAID-1+0 (commonly referred to as "RAID-10"). This is a stripe of mirrors. In order to specify the nested VDEVs, I just put them on the command line in order (emphasis mine):

```bash
# zpool create tank mirror sde sdf mirror sdg sdh
# zpool status
  pool: tank
 state: ONLINE
 scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	tank        ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sde     ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	  mirror-1  ONLINE       0     0     0
	    sdg     ONLINE       0     0     0
	    sdh     ONLINE       0     0     0

errors: No known data errors
```

The first VDEV is "mirror-0" which is managing /dev/sde and /dev/sdf. This was done by calling "mirror sde sdf". The second VDEV is "mirror-1" which is managing /dev/sdg and /dev/sdh. This was done by calling "mirror sdg sdh". Because VDEVs are always dynamically striped, "mirror-0" and "mirror-1" are striped, thus creating the RAID-1+0 setup. Don't forget to cleanup before continuing:

`# zpool destroy tank`

## File VDEVs

As mentioned, pre-allocated files can be used fer setting up zpools on your existing ext4 filesystem (or whatever). It should be noted that this is meant entirely for testing purposes, and not for storing production data. Using files is a great way to have a sandbox, where you can test compression ratio, the size of the deduplication table, or other things without actually committing production data to it. When creating file VDEVs, you cannot use relative paths, but must use absolute paths. Further, the image files must be preallocated, and not sparse files or thin provisioned. Let's see how this works:

```bash
# for i in {1..4}; do dd if=/dev/zero of=/tmp/file$i bs=1G count=4 &> /dev/null; done
# zpool create tank /tmp/file1 /tmp/file2 /tmp/file3 /tmp/file4
# zpool status tank
  pool: tank
 state: ONLINE
 scan: none requested
config:

	NAME          STATE     READ WRITE CKSUM
	tank          ONLINE       0     0     0
	  /tmp/file1  ONLINE       0     0     0
	  /tmp/file2  ONLINE       0     0     0
	  /tmp/file3  ONLINE       0     0     0
	  /tmp/file4  ONLINE       0     0     0

errors: No known data errors
```

In this case, we created a RAID-0. We used preallocated files using /dev/zero that are each 4GB in size. Thus, the size of our zpool is 16 GB in usable space. Each file, as with our first example using disks, is a VDEV. Of course, you can treat the files as disks, and put them into a mirror configuration, RAID-1+0, RAIDZ-1 (coming in the next post), etc.

`# zpool destroy tank`

## Hybrid pools

This last example should show you the complex pools you can setup by using different VDEVs. Using our four file VDEVs from the previous example, and our four disk VDEVs /dev/sde through /dev/sdh, let's create a hybrid pool with cache and log drives. Again, I emphasized the nested VDEVs for clarity:

```bash
# zpool create tank mirror /tmp/file1 /tmp/file2 mirror /tmp/file3 /tmp/file4 log mirror sde sdf cache sdg sdh
# zpool status tank
  pool: tank
 state: ONLINE
 scan: none requested
config:

	NAME            STATE     READ WRITE CKSUM
	tank            ONLINE       0     0     0
	  mirror-0      ONLINE       0     0     0
	    /tmp/file1  ONLINE       0     0     0
	    /tmp/file2  ONLINE       0     0     0
	  mirror-1      ONLINE       0     0     0
	    /tmp/file3  ONLINE       0     0     0
	    /tmp/file4  ONLINE       0     0     0
	logs
	  mirror-2      ONLINE       0     0     0
	    sde         ONLINE       0     0     0
	    sdf         ONLINE       0     0     0
	cache
	  sdg           ONLINE       0     0     0
	  sdh           ONLINE       0     0     0

errors: No known data errors
```

There's a lot going on here, so let's disect it. First, we created a RAID-1+0 using our four preallocated image files. Notice the VDEVs "mirror-0" and "mirror-1", and what they are managing. Second, we created a third VDEV called "mirror-2" that actually is not used for storing data in the pool, but is used as a ZFS intent log, or ZIL. We'll cover the ZIL in more detail in another post. Then we created two VDEVs for caching data called "sdg" and "sdh". The are standard disk VDEVs that we've already learned about. However, they are also managed by the "cache" VDEV. So, in this case, we've used 6 of the 7 VDEVs listed above, the only one missing is "spare".

Noticing the indentation will help you see what VDEV is managing what. The "tank" pool is comprised of the "mirror-0" and "mirror-1" VDEVs for long-term persistent storage. The ZIL is magaged by "mirror-2", which is comprised of /dev/sde and /dev/sdf. The read-only cache VDEV is managed by two disks, /dev/sdg and /dev/sdh. Neither the "logs" nor the "cache" are long-term storage for the pool, thus creating a "hybrid pool" setup.

`# zpool destroy tank`

## Real life example

In production, the files would be physical disk, and the ZIL and cache would be fast SSDs. Here is my current zpool setup which is storing this blog, among other things:

```bash
# zpool status pool
  pool: pool
 state: ONLINE
 scan: scrub repaired 0 in 2h23m with 0 errors on Sun Dec  2 02:23:44 2012
config:

        NAME                                              STATE     READ WRITE CKSUM
        pool                                              ONLINE       0     0     0
          raidz1-0                                        ONLINE       0     0     0
            sdd                                           ONLINE       0     0     0
            sde                                           ONLINE       0     0     0
            sdf                                           ONLINE       0     0     0
            sdg                                           ONLINE       0     0     0
        logs
          mirror-1                                        ONLINE       0     0     0
            ata-OCZ-REVODRIVE_OCZ-33W9WE11E9X73Y41-part1  ONLINE       0     0     0
            ata-OCZ-REVODRIVE_OCZ-X5RG0EIY7MN7676K-part1  ONLINE       0     0     0
        cache
          ata-OCZ-REVODRIVE_OCZ-33W9WE11E9X73Y41-part2    ONLINE       0     0     0
          ata-OCZ-REVODRIVE_OCZ-X5RG0EIY7MN7676K-part2    ONLINE       0     0     0

errors: No known data errors
```

Notice that my "logs" and "cache" VDEVs are OCZ Revodrive SSDs, while the four platter disks are in a RAIDZ-1 VDEV (RAIDZ will be discussed in the next post). However, notice that the name of the SSDs is "ata-OCZ-REVODRIVE_OCZ-33W9WE11E9X73Y41-part1", etc. These are found in /dev/disk/by-id/. The reason I chose these instead of "sdb" and "sdc" is because the cache and log devices don't necessarily store the same ZFS metadata. Thus, when the pool is being created on boot, they may not come into the pool, and could be missing. Or, the motherboard may assign the drive letters in a different order. This isn't a problem with the main pool, but is a big problem on GNU/Linux with logs and cached devices. Using the device name under /dev/disk/by-id/ ensures greater persistence and uniqueness.

Also do notice the simplicity in the implementation. Consider doing something similar with LVM, RAID and ext4. You would need to do the following:

```bash
# mdadm -C /dev/md0 -l 0 -n 4 /dev/sde /dev/sdf /dev/sdg /dev/sdh
# pvcreate /dev/md0
# vgcreate /dev/md0 tank
# lvcreate -l 100%FREE -n videos tank
# mkfs.ext4 /dev/tank/videos
# mkdir -p /tank/videos
# mount -t ext4 /dev/tank/videos /tank/videos
```

The above was done in ZFS (minus creating the logical volume, which will get to later) with one command, rather than seven.
Conclusion

This should act as a good starting point for getting the basic understanding of zpools and VDEVs. The rest of it is all downhill from here. You've made it over the "big hurdle" of understanding how ZFS handles pooled storage. We still need to cover RAIDZ levels, and we still need to go into more depth about log and cache devices, as well as pool settings, such as deduplication and compression, but all of these will be handled in separate posts. Then we can get into ZFS filesystem datasets, their settings, and advantages and disagvantages. But, you now have a head start on the core part of ZFS pools.