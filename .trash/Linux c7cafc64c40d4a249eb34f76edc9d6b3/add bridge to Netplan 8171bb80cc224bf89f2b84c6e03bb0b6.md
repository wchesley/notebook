# add bridge to Netplan

Created: June 29, 2021 11:35 AM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: July 8, 2021 3:30 PM

[](https://fabianlee.org/2019/04/01/kvm-creating-a-bridged-netw192.rk-with-netplan-on-ubuntu-bionic/)

Excerpt of the goodies: 

### Created a bridge with Netplan

To create a bridged network, you need to disable the specific 
settings on the physical network, and instead apply them to the bridge. 
 Make a backup of your old file before modifying.

```
cd /etc/netplan

# make backup
sudo cp 50-cloud-init.yaml 50-cloud-init.yaml.orig

# modify, add bridge
sudo vi 50-cloud-init.yaml
```

Below is an example showing how we take the physical network example 
above, and created a bridge named ‘br0’ that has the same properties.

```
`network:
  version: 2
  renderer: networkd

  ethernets:
    enp1s0:
      dhcp4: false
      dhcp6: false
      #addresses: [192.168.1.239/24]
      #gateway4: 192.168.1.1
      #mtu: 1500
      #nameservers:
      #  addresses: [8.8.8.8]

  bridges:
    br0:
      interfaces: [enp1s0]
      addresses: [192.168.1.239/24]
      gateway4: 192.168.2.1
      mtu: 1500
      nameservers:
        addresses: [8.8.8.8]
      parameters:
        stp: true
        forward-delay: 4
      dhcp4: no
      dhcp6: no

```

Then apply the new netplan with bridged network with the commands 
below.  But be sure you have physical access to the host in case network
 connectivity needs to be investigated.

```
sudo netplan generate
sudo netplan --debug apply
```

You may temporarily lost network connectivity if you are connected over ssh after running the apply command.

You can see the network entities at the OS level by using these commands:

```
# bridge control
brctl show

# network control
networkctl
networkctl status br0

# ip list
ip a | grep " br0:" -A 3
# show host routes
ip route

# show arp table (IP to MAC)
arp -n
```