[back](./README.md)

# VCF Passwords

- [VCF Passwords](#vcf-passwords)
  - [Passwords expired and can't be updated or remediated from SDDC](#passwords-expired-and-cant-be-updated-or-remediated-from-sddc)
    - [VCF 4.x-5.x](#vcf-4x-5x)
    - [ESXi](#esxi)
    - [NSXT-Edge](#nsxt-edge)
    - [NSXT Manager](#nsxt-manager)
        - [Below is an excerpt from https://vinsanity.uk](#below-is-an-excerpt-from-httpsvinsanityuk)
        - [End Excerpt](#end-excerpt)
    - [Replace Expired SSL Certificates](#replace-expired-ssl-certificates)
- [Links and References](#links-and-references)


## Passwords expired and can't be updated or remediated from SDDC

Had an issue where we couldn't update 2/4 ESXi hosts passwords for svc account or root, plus 1 NSXT-Edge host with the same issue. Even when we set the password to be the same as what SDDC saw as ESXi/NSXT-Edge hosts passwords, we still couldn't apply remediations on the passwords. 

### VCF 4.x-5.x

1. Login to the vCenter/vSphere UI and find the SDDC Manager VM.
2. Once you click on the SDDC Manager VM, under the IP address should be the host FQDN for which ESXi the VM is sitting on.
3. Open a new tab and paste the ESXi host FQDN into your browser and login to the host UI via root. 
4. Click on Virtual Machines, then click on the SDDC Manager VM > Edit > VM Options > Boot Options
5. Set the Boot Delay to 10000 milliseconds.
6. Open the VM console and On the right-hand side of the console should be a button that says Actions. Click on Actions > Power > Reset.
7. When you see the Photon screen, hit the 'e' key to get into the GRUB. 
8. Use the arrow keys to navigate to the line beginning with linux and add the following to the end of the line

    `rw init=/bin/bash`

9. Press the `F10` key to continue booting the VM. 
10. Run the following commands to unlock the vcf and root accounts:
    - For VCF versions up to VCF 5.0.0.1, use :

        `/usr/bin/pam_tally2 -u root -r`

        `/usr/bin/pam_tally2 -u vcf -r`

    - For VCF versions starting from VCF 5.1.0.0, use:

        `/usr/sbin/faillock --user root --reset`
        
        `/usr/sbin/faillock --user vcf --reset`

    - Note: If there are any failures, you will need to use the up arrow key to re-run the command until the failures column shows 0.
11. Run the following commands to set the accounts to a temporary password: 

    `passwd vcf`

    `passwd root`

12. Then reboot SDDC by running the following: 

    `reboot -f`

13. After a few minutes, SSH into the SDDC Manager with the vcf user and temp password and then su root and enter the temp password for root. 
Then run the following command to clear the passwords:

    `echo "" >/etc/security/opasswd` 

13. Now we can reset the accounts to new passwords or a password previously used by using commands mentioned in Step # 11

- Note: Make a note of what the vcf and root passwords were changed to.

16. Here is the below command to change the age of the VCF and Root 

VCF :  `chage -M 999 vcf`

Root : `chage -M 999 root`


### ESXi

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

### NSXT-Edge

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

### NSXT Manager

ref: https://docs.vmware.com/en/VMware-NSX-T-Data-Center/3.2/administration/GUID-8816B842-2EC4-40A8-A618-F68DB29FABD2.html

ref: https://kb.vmware.com/s/article/60335

VMWare KB [60335](https://kb.vmware.com/s/article/60335) is what proved to be the fix for our most recent NSXT Manager password sync issue with SDDC. Our NSXT manager was slightly different as far as disk set up goes in the article. We didn't have a partition at `/dev/sda6` as they suggested for Priv CLI passwd. When I reset passwd for only `/dev/sda2` it would fail after I exited admin shell, I couldn't use that passwd to sign back into admin account. Once I did the reset on `/dev/sda2` & `/dev/sda3` for our NSXT-B instance, I was able to remediate the passwd in SDDC. 

For good measure, before I remediated passwd in SDDC, I ran `set user admin password` command as admin...and set the passwd to what I had just changed it to in the `shadow` file. 

Also, just to note, the provided perl command in VMWare's article only returns `0*`, even on another machine (WSL-Ubuntu & Debian 12). Since I knew the root passwd, I just copied it's hash and placed it in admins place. 

##### Below is an excerpt from [https://vinsanity.uk](https://vinsanity.uk/2021/08/20/nsx-t-manager-account-has-been-locked/)

Had a problem today trying to access via the UI to an NSX-T Manager with admin user, received the following error message:

**Your login attempt was not successful.  
The username/password combination is incorrect or the account specified has been locked.**

SHH also gave me errors (If you can’t SSH, don’t forget to test a console session to the VM)

To fix this issue i logged in via SSH as root and reset the admin user password by running the following commands (Note to self, need to be in the NSX CLI):

`root@nsxmgr-01:/# su admin`

`set user admin`

> Author Note: in my case, I needed to use `set user admin password` else the command complained it was missing an arguement. This was for NSX-T v3.1 

```bash
Current password: Type the OLD password
New password: enter new password
Confirm new password: re-type new password to confirm
```

This then allowed access via the UI web interface

It is also possible to modify the default admin password expiration using the following command:

```bash
nsxcli> get user admin password-expiration 
nsxcli> set user admin password-expiration <1 - 9999>
```

To remove the password expiration policy on any NSX Manager simply typing the following command:

```bash
nsxcli> clear user audit password-expiration
```

Hope this helps someone, let know

Some examples of the commands I’d used:
```bash
vcf-m1-nsx3> set user admin password-expiration 9999
vcf-m1-nsx3> clear user audit password-expiration

root@vcf-m1-en01:~# set user admin password-expiration 9999

root@vcf-m1-en01:~# set user root password-expiration 9999
root@vcf-m1-en01:~# set user audit password-expiration 9999

nsx-mgt1> clear user admin password-expiration
nsx-mgt1> clear user root password-expiration
nsx-mgt1> clear user audit password-expiration


get user admin password-expiration 


Pam tally 2 is a useful command
pam_tally2 --user root --reset
```

##### End Excerpt

I wasn't able to remediate the password via CLI nor from webUI as I was told it was invalid caller or user in WebUI and CLI complained of the previous password being incorrect. The password is infact different between the root shell and nsxcli. I can run `passwd admin` from root shell and set the password to what I'd like, to only `su admin` and run `set user admin password` and input the same password I just set in root shell only to be told previous password is incorrect.  

### Replace Expired SSL Certificates 

Log into VCenter as root user. For WG-DC, we have the python script saved to root's home directory. The script is named `nsxtVmaCert.py`, needs to be run once foreach NSXT Manager, and once more for the Virtual IP (VIP). 

ref: https://kb.vmware.com/s/article/89921

---
# Links and References
- https://docs.vmware.com/en/VMware-NSX-T-Data-Center/3.2/administration/GUID-8816B842-2EC4-40A8-A618-F68DB29FABD2.html
- https://docs.vmware.com/en/VMware-NSX-T-Data-Center/3.1/administration/GUID-DB31B304-66A5-4516-9E55-2712D12B4F27.html
- https://blog.zuthof.nl/2022/01/19/nsx-t-tidbits-appliance-root-password-reset-made-easy/
- https://vinsanity.uk/2021/08/20/nsx-t-manager-account-has-been-locked/
- [Lookup Account Credentials](https://docs.vmware.com/en/VMware-Cloud-Foundation/4.5/vcf-admin/GUID-24B42A36-1F37-4407-957D-F1A1C869411D.html)
- [Remediate Passwords](https://docs.vmware.com/en/VMware-Cloud-Foundation/4.3/com.vmware.vcf.vxrail.doc/GUID-92E16E2F-9053-4BBA-9BF9-7B5065C680CF.html)
- [Managing Passwords in VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation/5.0/vcf-admin/GUID-1D25D0B6-E054-4F49-998C-6D386C800061.html)
- [How to reset the VRM, SDDC Manager Controller, SDDC Manager Utility, VIA or Cloud Builder root user password (2149860)](https://kb.vmware.com/s/article/2149860)
- [Steps to recover expired Service Accounts in VMware Cloud Foundation (83615)](https://kb.vmware.com/s/article/83615)
- [Replace Expired or Self-signed NSX-T Manager Certificates with VMCA-Signed Certificates (89921)](https://kb.vmware.com/s/article/89921)
- [Reset 'admin' and/or CLI Privilege Mode passwords for NSX Manager, NSX for vSphere 6.3 & 6.4 (60335)](https://kb.vmware.com/s/article/60335)
- [Reset VCF and Root passwd in SDDC](https://knowledge.broadcom.com/external/article/323984/how-to-reset-sddc-manager-vcf-and-root-u.html)