# VMWare Cloud Foundation (VCF)

## Overview

VMware Infrastructure is a collection of virtualization products from VMware (a division of Dell Technologies). Virtualization is an abstraction layer that decouples hardware from operating systems. The VMware Infrastructure suite allows enterprises to optimize and manage their IT infrastructure through virtualization as an integrated offering. The core product families are vSphere, vSAN and NSX for on-premises virtualization. VMware Cloud Foundation (VCF) is an infrastructure platform for hybrid cloud management. The VMware Infrastructure suite is designed to span a large range of deployment types to provide maximum flexibility and scalability. 

## Notes

### Passwords expired and can't be updated or remediated from SDDC

Had an issue where we couldn't update 2/4 ESXi hosts passwords for svc account or root, plus 1 NSXT-Edge host with the same issue. Even when we set the password to be the same as what SDDC saw as ESXi/NSXT-Edge hosts passwords, we still couldn't apply remediations on the passwords. 

#### ESXi

Later learned that the svc accounts on the ESXi hosts with issues didn't exist. We just needed to recreate the account, set the password and permissions then we could remediate in SDDC, the svc account has to be remediated first, then root can be remdiated. After logging into root shell of ESXi host: 

```bash
# we tested the accounts existence with passwd: 
$ passwd svc-vcf-esxi01
#$ passwd: user 'svc-vcf-esxi01' does not exist.
$ esxcli system account add -i svc-vcf-esxi01 -d "VCF Service User" -p -c
#$ Enter value for 'password':
#$ enter value for 'password-confirmation':
$ esxcli system permission set -i svc-vcf-esxi01 -r Admin
$ # Proceed to SDDC to remediate the passwd just set against svc-vcf-esxi01
```

Then head into SDDC, remediate using the same passwd just set against the service account. Once that remediation gets applied, you can remediate the root account. 

#### NSXT-Edge

Resetting passwords on NSXT-Edge is very different from ESXi, there is some setup that needs to be done first else you will break you NSXT-Edge installation. This process assumes you do not know any of the account passwords other than root. Essentially the process involves you stopping the API service, creating a special file that shows VCF we have changed passwords intentionally. Change you passwords, then restart the API service. 

```bash
# root shell on NSXT-Edge host: 
$ /etc/init.d/nsx-edge-api-server stop
$ touch /var/vmware/nsx/reset_cluster_credentials
# proceed to change passwords via passwd command ie. 
$ passwd admin
...
# confirming the file exists before restarting service: 
$ ls /var/vmware/nsx
# when complete, restart the API service: 
$ /etc/init.d/nsx-edge-api-server start
# confirm passwords changed: 
$ chage -l admin

```

Once passwords are changed in NSXT-Edge and API service is restarted. Apply the password remediation in SDDC. There is no specific order for these passwords, we started with root and went through the list. 