[back](./README.md)

# ZFS Migration Plan

## Moving to new physical host: 

This method is not ideal, you should use `zfs export poolname` move your drives, then use `zfs import poolname` instead. You can view pools available for import by running `zfs import` with no arguments. You can change the name of the pool on import as well, `zfs import oldpoolname newpoolname`, this will not update the pools mountpoint. 

I chose this method as I was moving to a new host with new disks being added. My current mirror of 2x2TB transformed into striped mirrors of 4x2TB drives, hence why I destroyed the old pool. Though, I intentionally split the two originial drives, to where each is mirrored with one of the new ones. zfs resliver never fully completed for me; but the restoration process from the external drive was extraordinarily fast. 

1. Back up current pool via rclone sync to External HDD
2. Destroy old pool
3. Recreate as two different mirrors then striped together in new storage server
4. rclone to migrate backed up data back into new stripped-mirror pool 

## Migrate to new drives: 
Again, wanted to recreate the pool as I had purchased new 4x6Tb drives and decided I wanted to turn dedup on for the pool. It only really 'counts' if new data is written, it won't dedup what data is alread at rest on the pool. 

* create snapshot of current pool
  * `zfs snapshot Nextpool@test`
* Build new pool if you haven't already. 
* zfs send and receive the data
  * `zfs send Nextpool@test | zfs receive zData`
    * I did precreate the pool for this, named `zData`, zfs complained about the data already existing? something to that effect, needed to run the `zfs receive` command with a `-F` flag. Still kept the properties I set at pool creation after data import. 
* This can take a while depending on how much data you are moving. For me, 2.6TB took about 3hrs to drives on the same host. You can check progress (loosly) with `zfs iostat`
* Double check data is present in new pool