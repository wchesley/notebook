[back](../README.md)

# ZFS on Linux

If using a RAID card you will need to flash it to `IT` mode or use it in HBA mode. If flashing your card, see here: https://fohdeesha.com/docs/perc.html

Else, place the card into HBA/JBOD mode and configure ZFS to your needs.

## Links

Most links are copies from Aaron Toponce's website that is sadly, no longer available online but can still be access through archive.org.

- [Home](./ZFS-Home.md)
- [Intent Log](./ZFS-Intent-Log.md)
- [ARC](./ARC.md)
- [RAIDz](./RAIDZ.md)
- [Migration Plan](./ZFS-migration-plan.md)
- [Send-Receive](./ZFS-send-receive.md)
- [Snapshot-Clone](./ZFS-Snapshot-clone.md)

## Creation issue

"new" to me SAS disks (not SATA) that I'm trying to create a pool from. Disks have been wiped and cleared but upon creation either give a `one or more device(s) is already in use` or `internal error: out of memory`. Both of which are technically false. The device in use error occurs just after wiping partitions from the 4 disks, internal memory error comes after first zpool creation attempt post-partition wipe. The zpool create command does create the partitions on all 4 disks but for some reason the pool itself is never created? I have to wipe the disks each time to attempt new pool creation else fase the dreadded OOM error, which for the record, server has almost 300GB of RAM, OOM is not the issue...zARC is allowed to use 188Gb of this RAM, but still shouldn't be an issue. 