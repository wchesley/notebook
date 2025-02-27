[back](../README.md)

# VMWare

- [ESXi](./ESXi.md)
- [vSphere](./vSphere.md)
- [VMWare Cloud Foundation (VCF)](./vcf.md)

## Notes and Links

Collection of useful links or unfinished notes related to VMWare: 

Resizing Linux VM host disks using LVM is a similar process to Proxmox, see: [resize disk](../Proxmox/resize_disk.md)

### Links: 

- [VMWare Security Advisories](https://www.vmware.com/security/advisories.html)
- [KB 2148493 - Understanding vSAN on-disk format versions and compatibility](https://kb.vmware.com/s/article/2148493)

## Scratch 

### Disabling HA per VM in vSphere

From vSphere web UI, navigate to your HA cluster and select it, then Configure -> VM Overrides -> Click `Add`

To disable HA monitoring for a VM; select your VM from the list. Set vShpere DRS to `Disabled` and vSphere HA - VM Monitoring to `disabled`.

