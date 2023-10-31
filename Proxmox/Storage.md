# PVE Storage

## Wiping disk complains it has a holder

When wiping disks in PVE web UI, if the disk was used in another PVE system and hasn't been wiped you might have issues wiping it from PVE GUI. Thanks to [this forum post](https://forum.proxmox.com/threads/sda-has-a-holder.97771/), I found that you can list LVM groups with `pvs` then remove the volume groups you don't need with `vgremove`. For the Device-mapped disks, check with `dmsetup ls` and remove mapping with `dmsetup remove`. 

## Created ZFS Storage pool outside of PVE GUI Doesn't show up in PVE GUI. 

After I created a new ZFS storage pool, it doesn't show up in PVE GUI. You can see it in `Datacenter > Storage > Add > ZFS` but cannot add VM's, LXC's or backups to the storage pool. This can be done via CLI command `pvesm add`, however I didn't know enough information about the command to feel comfortable running it. Instead I edited the `storage.cfg` file directly. 

First create a backup of `storage.cfg` via `cp /etc/pve/storage.cfg /etc/pve/storage.cfg.bak`  
Then edit `storage.cfg` via nano or vi. Below is an example `storage.cfg` file from PVE forums: 

```cfg
dir: local
        path /var/lib/vz
        content vztmpl,iso,backup

lvmthin: local-lvm
        thinpool data
        vgname pve
        content images,rootdir

zfspool: HL-Storage
        pool HL-Storage
        content images,rootdir
        mountpoint /HL-Storage
        nodes worker1,worker2
        sparse 0
```

The ZFS values will need to be changed according to your environment. 

Once the new `storage.cfg` is in place, refresh the PVE Web UI and it should appear under your host in the left hand menu. 

You can also edit the `content` value, to add features like `backup` and `iso` to allow backups and iso storage on the ZFS pool. 