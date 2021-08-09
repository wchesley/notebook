# ZFS Migration Plan
1. Back up current pool via rclone sync to External HDD
2. Destroy old pool
3. Recreate as two different mirrors then striped together in new storage server
4. migrated backed up data back into new stripped-mirror pool 