[back](./README.md)

# VBR v12 Security Updates

- [VBR v12 Security Updates](#vbr-v12-security-updates)
  - [MFA Improvements](#mfa-improvements)
    - [Turn on MFA for user accounts](#turn-on-mfa-for-user-accounts)
    - [Additional MFA settings](#additional-mfa-settings)
  - [gMSA - Group Managed Service Accounts](#gmsa---group-managed-service-accounts)
      - [Benefits of using gMSAs](#benefits-of-using-gmsas)
    - [Add gMSA account to the VBR Console](#add-gmsa-account-to-the-vbr-console)
  - [Linux - SSH and SUOD are not required](#linux---ssh-and-suod-are-not-required)
  - [Auto-Logoff feature](#auto-logoff-feature)
- [Summary](#summary)
- [Further Reading:](#further-reading)

**Veeam Backup & Replication (VBR)** v12 has some significant new enhancements to the security
aspect of the application. This chapter will look at some of the more critical changes. The first thing
discussed will be the improvements to using multi-factor authentication (MFA) for console login
and group-managed service account (gMSA) support. You will learn how Linux no longer requires
Secure Shell (SSH) or super user do (SUDO) for management. Lastly, we will look at the auto-logoff
feature for the console allowing resources to be kept in check.

- Improvements to Multifactor Authentication (MFA)
- Group managed Service Accoutn (gMSA)
- Linux no longer requires SSH or sudo access

## MFA Improvements

Prior to v12, only adminstrator users were allowed to login to the VBR console. Now normal users can sign into VBR with username, password and TOTOP (Timebased One-Time Password - MFA). Turning on MFA forces users to use their username, password then TOTP to sign into VBR console, providing an additional layer of security, plus the added benifit of not running VBR as admin all the time, or when admin credentials are not needed. 

### Turn on MFA for user accounts

1. Open VBR console, click on the hamburger menu (top right) and select **Users and Roles**
2. You are presented with a security dialog that allows you to add users and enable MFA. 
3. Use the **Add** button to add your local user and then enable MFA by checking **Require two-factor authentication for interactive login** box. 
4. Click **Ok** to close the dialog, and we can now log on as **VeeamUser** to the console to enable MFA. 
   1. **Note:** If a security group is added to the **Security** window, you will receive a message about removing the group and only adding users to allow MFA. 
5. Remove the required security group, add the required users to this dialog, and proceed to the next step. 
6. Launch the console from the desktop icon, enter the credentials for the user added to the **Security** diaglog, and click **Connect**.
7. After clicking **Connect**, you will be prompted to setup MFA using one of your choses applications (Recommended, 2FAS or Authy). In this example we will use **2FAS** (Android app store) to configure MFA for **VeeamUser**.
8. Scan the QR code or enter the manual code into your authentication application. Click **Next** to proceed. You will be presented with a **Confirmation Code** dialog where you enter the code from your authentication application. 
9. After entering the correct code in the required box, click **Confirm**, the console will open for the user. 

> **Note:** 
> 
> When you enable MFA, it applies to all users listed within the **Security** dialog. Therefor, i fyou need to have a user excluded from MFA, then you would need to have MFA turned off for all, which in the end, degrades security posture. 

### Additional MFA settings

There are some additional things you can do with MFA to ensure further security: 

1. **MFA within a Guest operating system (OS)**: Most guest OSSes support some form of MFA login to go along with using your password. Some options include using an authenticator application, a security key, face ID, and a PIN. While all of these are secure, using an authenticator application or security key is considered more secure
2. **MFA Offline**: Setting up MFA also works when your system is offline, meaning not on the domain, but in a workgroup or not connected to the network. This option is helpful for air gaps with backups and your infrastructure. 

## gMSA - Group Managed Service Accounts

gMSA is new to VBR v12, and though very similar to **standalone managed service account (sMSA)**, gMSA extends sMSA functionality over multiple servers. Some gMSA features are: 

- Automatic password management
- simplified **service principal name (SPN)** management. 
- Delegation of management to other administrators
- Ability to get used across multiple servers

gMSA is used in conjuction with the Microsoft Key Distribution Service, which keeps a secret key identifier that is used with the gMSA account. It is essential for the practical applicaiton use of gMSA accounts, allowing administrators to not worry about password sync with your services as it is all auto-managed from the domain controllers. 

#### Benefits of using gMSAs

Using a gMSA offers users a single identity solution with enhanced security. It provides the following benefits: 

- **Strong Passwords**: A gMSA uses a 240-byte randomly generated complex passwords. Using a complicateed and lengthy password helps to minimize the chances of a service being brute forced during a dictionary attack. 
- **Cycling of Passwords**: The gMSA password is managed by the Windows OS and is changed every 30 days (this can be modified when creating the gMSA account). WIth this, administrator are no longer required to schedule changing the password or manageing service outages, which helps to keep the service account secure. 
- **Support for simplified SPN management**: When setting up a gMSA account via PowerShell, you set the SPN during account creation, allowing services to suport automatic SPN registration against the gMSA account. 

### Add gMSA account to the VBR Console

1. From the hamburger menu (top right), select **Credentials and Passowrd** then **Datacenter Credentials**. 
2. The **Managed Credentials** window now opens. Click **Add...** and then select **Managed service account...**: 
3. You will then type in the domain account, the gMSA account: 
4. Type a value in the **Username** field and click **Ok** to proceed to add the gMSA accoutn. You will then see the account in the credentials list displayed as **Managed service account**. 

> **Note:** 
>
> When added, the account shows a different icon to signify that it is a managed service account froom the domain. Domain accoutns are the **only** supported for gMSA, and you cannot use servers not part of an Active Directory Domain. 

This process now completes the process for adding a gMSA accoutn to the VBR console to be used within the environment. 

## Linux - SSH and SUOD are not required

Prior to VBR v12, you would have to setup and enable SSH and SUDO services working when a linux server has been added to VBR, with an exception for hardened repositories. 

With Linux Hardened repositories, VBR v12 has made enhancements so that once yhou have added the repository to the system, you no longer need the single-use credential account in the SUDO group, in addition, you can disable SSH on the server. 

Veeam accomplishes this by using certificates, which are stored in the VBR database, and it is with this that future communication is handled. The cert allows the following: 

- Component upgrades, for example, the transport or installer service.
- Modifying settings within the Linus hardened repository, for example, concurrent tasks.
- Managing all aspects from within the Veeam environment. 

This section covered the changes to Linux hardened repositories with the requirement of SSH and SUDO being replaced by certificates within the database. 

## Auto-Logoff feature

Now users can't leave their VBR console open in a disconnected session! This enhances security and free's up system resources as a disconnected RDP session doesn't release it's resources and instead keeps them locked. 

To enable auto logoff: 

1. Open VBR 12 console
2. Click on the hamburger menu (top right) and select **Users and Roles** from the menu: 
3. The **Security** dialog will open on the screen: 
4. From within the **Security** dialog, check the **Enable auto logoff after X min of inactivity** checkbox to enable auto logoff. (Bottom of **Security** menu).
5. Modify the number of minutes for wich you want the system to wait before it logs a user off the VBR console. 
6. Click **Ok** button to confirm the setting and close the dialog. 

# Summary 

This chapter reviewed many of the new security enhancements Veeam has added to v12. First, we examined using the MFA setting in the VBR console to enhance security and require a code for logging in to the console. Then, we looked at the Linux hardened repository enhancement, which does not require SSH or SUDO now and uses certificates to manage and update components. Lastly, we discussed the new auto logoff feature, which helps enhance security and free up system resources. After reading this chapter, you should better understand the multitude of new features added for the security of the VBR console and services.

# Further Reading: 
- [Microsoft - gMSA](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/group-managed-service-accounts-overview)
- [Veeam - gMSA](https://helpcenter.veeam.com/docs/backup/vsphere/using_gmsa.html?ver=120)
- [Veeam - MFA](https://helpcenter.veeam.com/docs/backup/vsphere/mfa.html?ver=120)