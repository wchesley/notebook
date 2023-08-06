# iSCSI

> Note I (wchesley) did not follow this directly when setting up my iSCSI storage originally. I found this when troubleshooting and ACL issue with a new node in my proxmox cluster. I thought it was general and through enough to follow and set up iSCSI storage on another debian system again if I needed to. Original article source is [here](https://www.thegeekdiary.com/how-to-configure-iscsi-target-and-initiator-using-targetcli-in-centos-rhel-7/). 

Internet Small Computer System Interface (iSCSI) is an IP-based standard for connecting storage devices. iSCSI uses IP networks to encapsulate SCSI commands, allowing data to be transferred over long distances. iSCSI provides shared storage among a number of client systems. Storage devices are attached to servers (targets). Client systems (initiators) access the remote storage devices over IP networks. To the client systems, the storage devices appear to be locally attached. iSCSI uses the existing IP infrastructure and does not require any additional cabling, as is the case with Fibre Channel (FC) storage area networks.

## Installing targetcli

1. RHEL/CentOS 7 uses the Linux-IO (LIO) kernel target subsystem for iSCSI. In addition to iSCSI, LIO supports a number of storage fabrics including Fibre Channel over Ethernet (FCoE), iSCSI access over Mellanox InfiniBand networks (iSER), and SCSI access over Mellanox InfiniBand networks (SRP). In RHEL 7, all storage fabrics are managed with the targetcli utility.

To configure RHEL system as an iSCSI server, begin by installing the targetcli software package:

`# yum install targetcli`

2. Installing the targetcli software package also installs the python-rtslib package, which provides the `/usr/lib/systemd/system/target.service` file. Before using the targetcli utility to create, delete, and view storage targets, use the systemctl command to enable and start the target service on the iSCSI server.

`# systemctl enable target`
Created symlink from `/etc/systemd/system/multi-user.target.wants/target.service` to `/usr/lib/systemd/system/target.service`.

`# systemctl start target`

### Adding the device

1. Add the disk `/dev/xvdf` as iSCSI device under Backstores `/backstores/block`. Backstores are local storage resources that the kernel target uses to “back” the SCSI devices it exports.

`# targetcli` 

```bash
/> cd /backstores/block/
/backstores/block> create disk0 /dev/xvdf
Created block storage object disk0 using /dev/xvdf.
```

2. Verify the New device using “ls” under the /backstores/block directory of targetcli command line.

### Create new IQN

1. The following example uses the create command to create an IQN (iSCSI Qualified Name) with a target. Use the create command without any arguments to create an iSCSI target by using a default target name. By default, the target is identified by an “iqn” identifier. This is an iSCSI Qualified Name (IQN), which uniquely identifies a target.

```bash
/>/> cd /iscsi 
/iscsi> create
Created target iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
/iscsi>
```

2. Verify the newly create IQN using ls command under /iscsi directory.

### Setting up the ACL

Access Control Lists (ACLs) restrict access to LUNs from remote systems. You can create an ACL for each initiator to enforce authentication when the initiator connects to the target. This allows you to give a specific initiator exclusive access to a specific target.

2. Before you can create an ACL, you will have to find out the initiator name from your client (iscsi-initiator). Use the command below on the client to get the initiator name.

```bash
[root@initiator ~]# cat /etc/iscsi/initiatorname.iscsi 
InitiatorName=iqn.1994-05.com.redhat:aabb51a64012
```

2. The following example uses the create command to create an ACL for an initiator. From the targetcli shell, begin by using the cd command to change to the acls directory within the [target/TGP] hierarchy. Use the initiator name you just obtained from the command above.

/> cd /iscsi/iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721/tpg1/acls 
/iscsi/iqn.20...721/tpg1/acls> create iqn.1994-05.com.redhat:aabb51a64012
Created Node ACL for iqn.1994-05.com.redhat:aabb51a64012

3. Verify the new ACL you have just setup.

create ACL for CentOS 7 iscsi target configuration
### Creating Target Portal Group (TPG)

A default Target Portal Group (TPG) is created when you create a new IQN. A network portal is an IP address:port pair. An iSCSI target is accessed by remote systems through the network portal. The default portal of 0.0.0.0:3260 allows the iSCSI server to listen on all IPv4 addresses on port 3260. You can delete the default portal and configure portals as needed. Both IPv4 and IPv6 addresses are supported.

1. As you can see in the command below the default TGP is already created.

/> cd /iscsi/iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721/tpg1/portals/
/iscsi/iqn.20.../tpg1/portals> ls

iscsi target portal group RHEL 7 iscsi configuration

2. To allow remote systems to access an iSCSI target on port 3260, either disable the firewalld service on the iSCSI server or configure firewalld to trust the 3260/tcp port. The following example uses firewall-cmd to open the 3260/tcp port for the firewalld service.

`# firewall-cmd --permanent --add-port=3260/tcp`

If you include the –permanent option when adding a port, use the firewall-cmd command to reload the configuration.

`# firewall-cmd –reload`

### Adding iSCSI disks to the TPG

1. Now we need to add the Disk (disk0) we created earlier in this post to the default TPG.

/> cd /iscsi/iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721/tpg1/luns 
/iscsi/iqn.20...721/tpg1/luns> create /backstores/block/disk0 
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.1994-05.com.redhat:aabb51a64012

2. Verify your configuration.

RHEL 7 CentOS 7 iscsi configuration
Save the configuration

The last step is to save the configuration using the “saveconfig” command. Make sure you run the command from the “/” directory, otherwise it will fail.

/> saveconfig
Last 10 configs saved in /etc/target/backup.
Configuration saved to /etc/target/saveconfig.json

## Configuring the iSCSI initiator

1. On your iscsi-initiator run a discovery against the target to verify your iqn is available.

iscsiadm --mode discoverydb --type sendtargets --portal [ip-of-target] --discover
[ip-of-target]:3260,1 iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721

2. Login into the target

```
[username@iSCSIclient]# iscsiadm --mode node --targetname iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721 --portal [ip-of-target] --login
Logging in to [iface: default, target: iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721, portal: [ip-of-target],3260] (multiple)
Login to [iface: default, target: iqn.2003-01.org.linux-iscsi.geeklab.x8664:sn.81b9fd11a721, portal: [ip-of-target],3260] successful.
```

3. Verify if you can see the new iSCSI storage.

```
# cat /proc/scsi/scsi 
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: LIO-ORG  Model: disk0            Rev: 4.0 
  Type:   Direct-Access                    ANSI  SCSI revision: 05
```

# Scratch notes from Troubleshooting

```
iscsiadm: initiator reported error (24 - iSCSI login failed due to authorizationfailure)
iscsiadm: Could not log into all portals
```

Since the failure still persists, use the `-d` option with the `iscsiadm` command and attemptto log into the target again, but also generate verbose debug information. Since the errormessages are related to authorization failure, look for debug messages that correspond to this.

```bash
[root@servera ~]#iscsiadm -m node -T iqn.2016-01.com.example.lab:iscsistorage --login -d8... 
Output omitted ...iscsiadm: updated 'node.session.queue_depth', '32' => '32'
iscsiadm: updated 'node.session.nr_sessions', '1' => '1'
iscsiadm: updated 'node.session.auth.authmethod', 'None' => 'None'iscsiadm: updated 'node.session.timeo.replacement_timeout', '120' => '120'iscsiadm: updated 'node.session.err_timeo.abort_timeout', '15' => '15'... Output omitted ...
```

9.The debug messages indicate that the initiator is no longer using authenticationto log into the target. With that issue removed, the failure to login to the targetmight be due to an ACL restriction. Check to see if the initiator name matches theiqn.2016-01.com.example.lab:serveraname allowed in the ACL.[root@servera ~]#cat /etc/iscsi/initiatorname.iscsiInitiatorName=iqn.2016-01.lab.example.com:servera10.The initiator name is incorrectly configured. Fix the name and then restartiscsidfor thechange to take effect.[root@servera ~]#cat /etc/iscsi/initiatorname.iscsiInitiatorName=iqn.2016-01.com.example.lab:servera[root@servera ~]#systemctl restart iscsid11.Reattempt a login to the target to verify whether the login issue has been resolved.

```bash
RH342-RHEL7.2-en-1-20160321165[root@servera ~]#iscsiadm -m node -T iqn.2016-01.com.example.lab:iscsistorage --login
Logging in to [iface: default, target: iqn.2016-01.com.example.lab:iscsistorage,portal: 172.25.250.254,3260] (multiple)
Login to [iface: default, target: iqn.2016-01.com.example.lab:iscsistorage, portal:172.25.250.254,3260] successful
```