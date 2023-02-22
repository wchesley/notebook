# Proxmox

Created: April 12, 2021 10:57 PM

Proxmox VE is a complete, open-source server management platform for enterprise virtualization. It tightly integrates the KVM hypervisor and Linux Containers (LXC), software-defined storage and networking functionality, on a single platform. With the integrated web-based user interface you can manage VMs and containers, high availability for clusters, or the integrated disaster recovery tools with ease.

Free and Open Source Hypervisor. https://www.proxmox.com/en/proxmox-ve
[Documentation](https://pve.proxmox.com/pve-docs/) also built into the server. 
[Forums](https://forum.proxmox.com/)

## My docs and references: 
- [Email Alerts](./Email-Alerts.md)
- [Reset LXC password](./forgotLXC_passwd.md)
- [Manually Create Template LXC/VM](./Manually-Create-Templates.md)
- [Backups](./Proxmox-Backup.md)
- [Resize Disk](./resize_disk.md)

# ZFS over ISCSI
Have this at least set up now.. but am failing to start VM full errora; 
```bash
kvm: -drive file=iscsi://192.168.0.118/iqn.2003-01.org.linux-iscsi.heimdall.x8664:sn.f461fed3663d/0,if=none,id=drive-scsi0,format=raw,cache=none,aio=io_uring,detect-zeroes=on: iSCSI: Failed to connect to LUN : iscsi_service failed with : iscsi_service_reconnect_if_loggedin. Can not reconnect right now.

TASK ERROR: start failed: QEMU exited with code 1
```
current target: iqn.2003-01.org.linux-iscsi.heimdall.x8664:sn.f461fed3663d
group tpg1
zpool tank
thin provision

annnnndddd I just fixed it....was the portal, I had it backwards in my head, portal should have been host IP address instead of PVE nodes ip addresses. 

# My setup for ZFS over ISCSI

2x300gb 10krpm SAS drives in zfs stripe - This is a testing ground, idgaf about data here. For Production, I'd use 4 drives in a striped mirror. Enabled lz4 compression and deduplication for this pool.

- [although a guide for freenas, this was immensely helpful](https://forum.proxmox.com/threads/iscsi-failed-to-connect-to-lun-iscsi_service-failed.82179/)
- [Most excellent guide, auf deutch](https://deepdoc.at/dokuwiki/doku.php?id=virtualisierung:proxmox_kvm_und_lxc:proxmox_debian_als_zfs-over-iscsi_server_verwenden)

ssh into storage server (heimdall in my case)  
installed targetcli on heimdall where drives live.  
`sudo apt install targetcli-fb`

enabled iscsi daemon service `systemctl enable iscsid.service`. 

FROM PVE SERVER: get iscsi initiator name from PVE: `cat /etc/iscsi/initiatorname.iscsi `

Run `sudo targetcli`
- lands you in target cli shell
```bash
/ >  ls
o- / .....................................................................................................  [ ... ] 
  o- backstores ..........................................................................................  [ ... ] 
  | o- block ..............................................................................  [ Storage Objects:  0 ] 
  | o- fileio .............................................................................  [ Storage Objects:  0 ] 
  | o- pscsi ..............................................................................  [ Storage Objects:  0 ] 
  | o- ramdisk ............................................................................  [ Storage Objects:  0 ] 
  o- iscsi ........................................................................................  [ Targets:  0 ] 
  o- loopback .....................................................................................  [ Targets:  0 ] 
  o- sbp ..........................................................................................  [ Targets:  0 ] 
  o- vhost ........................................................................................  [ Targets:  0 ] 
  ```

- cd into iscsi `cd ./iscsi`
- create one with `create` 
- create an initiator `create <initiatorname>` This is your ACL we grabbed earlier
- cd from `tpg1`, cd into `portals`
- accept the default of `0.0.0.0:3260` or set the IP address of your server. 
- run `saveconfig` then `exit`
- for good measure, I restarted both `iscsid.service` and `targetcli.service`

pve storage.cfg example: 
```cfg
zfs: iscsi-zfs
        blocksize 4k
        iscsiprovider LIO
        pool testpool/iscsi
        portal backup.tux.at
        target iqn.2019-03.org.linux-iscsi.backup.tux.at:sn.baef28cdfaff
        content images
        lio_tpg tpg1
        nowritecache 1
        sparse 1 
```

and from PVE GUI:  

![zfsOverISCSIimage](../iscsi-over-zfs.png)

From the [docs](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#storage_zfs)
## 7.18. ZFS over ISCSI Backend

Storage pool type: zfs

This backend accesses a remote machine having a ZFS pool as storage and an iSCSI target implementation via ssh. For each guest disk it creates a ZVOL and, exports it as iSCSI LUN. This LUN is used by Proxmox VE for the guest disk.

The following iSCSI target implementations are supported:

    LIO (Linux)

    IET (Linux)

    ISTGT (FreeBSD)

    Comstar (Solaris)

Note 	This plugin needs a ZFS capable remote storage appliance, you cannot use it to create a ZFS Pool on a regular Storage Appliance/SAN
### 7.18.1. Configuration

In order to use the ZFS over iSCSI plugin you need to configure the remote machine (target) to accept ssh connections from the Proxmox VE node. Proxmox VE connects to the target for creating the ZVOLs and exporting them via iSCSI. Authentication is done through a ssh-key (without password protection) stored in /etc/pve/priv/zfs/<target_ip>_id_rsa

The following steps create a ssh-key and distribute it to the storage machine with IP 192.0.2.1:

    mkdir /etc/pve/priv/zfs
    ssh-keygen -f /etc/pve/priv/zfs/192.0.2.1_id_rsa
    ssh-copy-id -i /etc/pve/priv/zfs/192.0.2.1_id_rsa.pub root@192.0.2.1
    ssh -i /etc/pve/priv/zfs/192.0.2.1_id_rsa root@192.0.2.1

The backend supports the common storage properties content, nodes, disable, and the following ZFS over ISCSI specific properties:

pool

    The ZFS pool/filesystem on the iSCSI target. All allocations are done within that pool.
portal

    iSCSI portal (IP or DNS name with optional port).
target

    iSCSI target.
iscsiprovider

    The iSCSI target implementation used on the remote machine
comstar_tg

    target group for comstar views.
comstar_hg

    host group for comstar views.
lio_tpg

    target portal group for Linux LIO targets
nowritecache

    disable write caching on the target
blocksize

    Set ZFS blocksize parameter.
sparse

    Use ZFS thin-provisioning. A sparse volume is a volume whose reservation is not equal to the volume size.

Configuration Examples (/etc/pve/storage.cfg)

    zfs: lio
    blocksize 4k
    iscsiprovider LIO
    pool tank
    portal 192.0.2.111
    target iqn.2003-01.org.linux-iscsi.lio.x8664:sn.xxxxxxxxxxxx
    content images
    lio_tpg tpg1
    sparse 1

    zfs: solaris
    blocksize 4k
    target iqn.2010-08.org.illumos:02:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:tank1
    pool tank
    iscsiprovider comstar
    portal 192.0.2.112
    content images

    zfs: freebsd
    blocksize 4k
    target iqn.2007-09.jp.ne.peach.istgt:tank1
    pool tank
    iscsiprovider istgt
    portal 192.0.2.113
    content images

    zfs: iet
    blocksize 4k
    target iqn.2001-04.com.example:tank1
    pool tank
    iscsiprovider iet
    portal 192.0.2.114
    content images

### 7.18.2. Storage Features

The ZFS over iSCSI plugin provides a shared storage, which is capable of snapshots. You need to make sure that the ZFS appliance does not become a single point of failure in your deployment.
Table 16. Storage features for backend iscsi 
| Content types 	| Image formats 	| Shared 	| Snapshots 	| Clones|
|--- |--- |--- |---|---|
| images | raw | yes | yes | no | 

