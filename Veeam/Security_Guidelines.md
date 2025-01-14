[back](./README.md)

# General Security Considerations

- [General Security Considerations](#general-security-considerations)
  - [Network](#network)
  - [User Roles and Permissions](#user-roles-and-permissions)
  - [Microsoft Windows Server](#microsoft-windows-server)
  - [Linux Server](#linux-server)
- [Securing Backup Infrastructure](#securing-backup-infrastructure)
  - [Infrastructure Planning](#infrastructure-planning)
  - [Backup Server](#backup-server)
  - [Veeam Backup \& Replication Database](#veeambackupreplication-database)
  - [Backup Repositories](#backup-repositories)
  - [Veeam Backup Enterprise Manager](#veeam-backup-enterprise-manager)
  - [Veeam Cloud Connect](#veeam-cloud-connect)


General security considerations include best practices which help you to hardenbackup infrastructure, build a more secure environment, and mitigate risks of being compromised. Ensure that your backup infrastructure meet the common recommendations described in this section. For more information about hardening specific backup infrastructure components, see [Securing Backup Infrastructure](https://helpcenter.veeam.com/docs/backup/vsphere/securing_backup_infrastructure.html).

## Network

To secure the communication channel for backup traffic, consider the following recommendations:

- Use network segmentation. Create network segmentation policies to define network boundaries,
control traffic between subnets and limit access to security-sensitive
backup infrastructure components. Also, ensure that only [ports used by backup infrastructure components](https://helpcenter.veeam.com/docs/backup/vsphere/used_ports.html) are opened.
- Isolate backup traffic. Use an isolated network to transport data between backup infrastructure components — backup server, backup proxies, repositories and so on.
- Disable outdated network protocols. Check that the following protocols are disabled:
- SSL 2.0 and 3.0 as they have well-known security vulnerabilities and are not NIST-approved. For more information, see [NIST guidelines](https://csrc.nist.gov/publications/detail/sp/800-52/rev-2/final).
- TLS 1.0 and 1.1 if they are not needed. For more information, see [NIST guidelines](https://csrc.nist.gov/publications/detail/sp/800-52/rev-2/final).
- LLMNR and NetBIOS broadcast protocols to prevent spoofing and man-in-the-middle (MITM) attacks.
- SMB 1.0 protocol as it has a number of serious security vulnerabilities
including remote code execution. For more information, see [this Microsoft article](https://techcommunity.microsoft.com/t5/storage-at-microsoft/stop-using-smb1/ba-p/425858).

## User Roles and Permissions

Administratorprivileges on a backup server or a backup proxy allow the user to access other backup infrastructure components. If an attacker gains such permissions, they can destroy most of the production data, backups, and replicas, as well as compromise other systems in your environment. To mitigate risks, use the principle of the least privilege. Provide the minimal required permissions needed for the accounts to run. For more information, see [Permissions](https://helpcenter.veeam.com/docs/backup/vsphere/required_permissions.html).

Security Audit

Perform regular security audits to estimate your backup infrastructure by security criteria and understand if it is compliant with best practices, industry standards, or federal regulations.

The most possible causes of a credential theft are missing operating system updates and use of outdated authentication protocols. To mitigate risks, ensure that all software and hardware running backup infrastructure components are updated regularly. If the latest security updates and patches are installed on backup infrastructure servers, this will reduce the risk of exploiting vulnerabilities by attackers. Note that you should work out an update management strategy without a negative impact on production environment.

> ### Note
>
> You can [subscribe to Veeam security advisories](https://www.veeam.com/knowledge-base.html) published in the Veeam Knowledge Base to stay up to date with the latest security updates.

## Microsoft Windows Server

To secure Microsoft Windows-based backup infrastructure components, consider the following recommendations:

- Use operating system versions with Long Term Servicing Channel (LTSC). For these versions Microsoft provides extended support including regular security updates. For more information, see [this Microsoft article](https://docs.microsoft.com/en-us/windows-server/get-started/extended-security-updates-overview).
- Turn on Microsoft Defender Firewall with Advanced Security. Set up rules for inbound and outbound connections according to your
infrastructure and Microsoft best practices. For more information, see [this Microsoft article](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-firewall/best-practices-configuring).
- Disable remote services if they are not needed:
- Remote Desktop Service
- Remote Registry service
- Remote PowerShell
- Windows Remote Management service

> ### Note
>
> A backup server also requires additional configuration described in section [Securing Backup Infrastructure](https://helpcenter.veeam.com/docs/backup/vsphere/securing_backup_infrastructure.html#backup_server).


## Linux Server

To secure Linux-based backup infrastructure components, consider the following recommendations:

- Use operating system versions with long-term support (LTS). LTS versions of popular community-based and commercial Linux
distributions have extended support including regular security updates.
- Choose strong encryption algorithms for SSH. To communicate with Linux servers deployed as a part of the backup infrastructure, Veeam Backup & Replication uses SSH. Make sure that for the SSH tunnel you use a strong and proven encryption algorithm, with sufficient key length. For more information, see [this section](https://helpcenter.veeam.com/docs/backup/vsphere/system_requirements.html#encrypted_communication). Also, ensure that private keys are kept in a highly secure place and cannot be uncovered by a third-party.

> ### Note
>
> For the Linux hardened repository, instead of SSH Veeam Backup & Replication uses SHA256RSA self-signed certificates with 2048-bit RSA key.


- **Avoid using password authentication to connect to remote servers over SSH**. Using key-based SSH authentication is generally considered more secure
than using password authentication and helps averting man-in-the-middle
(MITM) attacks. The private key is not passed to the server and cannot
be captured even if a user connects to a fake server and accepts a bad
fingerprint.

> ### Note
>
>A Linux hardened repository requires a specific security configuration. For more information, see [Hardened Repository](https://helpcenter.veeam.com/docs/backup/vsphere/hardened_repository.html).

# Securing Backup Infrastructure

This section includes recommendations for hardening specific backup infrastructure components in addition to [general security considerations](https://helpcenter.veeam.com/docs/backup/vsphere/general_security_considerations.html).

## Infrastructure Planning

For
 large environments, adding the backup server and other backup 
infrastructure components to a management domain in a separate Active 
Directory forest is the best practice for building the most secure 
infrastructure.

For
 medium-sized and small environments, backup infrastructure components 
can be placed to a separate workgroup. If you want to use specific Veeam
 Backup Enterprise Manager features, for example, [SAML authentication](https://helpcenter.veeam.com/docs/backup/em/veeam_backup_em_saml.html?ver=120) or [restore of Microsoft Exchange items](https://helpcenter.veeam.com/docs/backup/em/restore_msexchange.html?ver=120), you can add this component to the domain.

In
 both cases, backup infrastructure components should be placed to a 
separate network where applicable. Also, it is recommended to use the [hardened backup repository](https://helpcenter.veeam.com/docs/backup/vsphere/hardened_repository.html).

## Backup Server

To secure the backup server, consider the following recommendations:

- Restrict outbound connections. To enable product update check, automatic license update, and license
usage reporting, the backup server must be connected to the internet and be able to send requests to servers on the internet. Allow only HTTPS
connections to the Veeam Update Notification Server (dev.veeam.com), Veeam License Update Servers (vbr.butler.veeam.com, autolk.veeam.com), and Microsoft WSUS servers or Microsoft Update sites.
- Restrict inbound connections. Inbound connectivity to backup servers from the internet must not be
allowed. If you want to manage backup servers remotely over the
Internet, you can deploy the Veeam Backup & Replication console on a jump server. Service providers who want to manage backup
servers remotely can use the Veeam Backup Remote Access functionality.
For more information, see the [Using Remote Access Console](https://helpcenter.veeam.com/docs/backup/cloud/cc_remote.html?ver=120) section in the Veeam Cloud Connect Guide.

> ### Note
>
>The account used for RDP access must not have local Administrator privileges on the jump server, and you must never use the saved credentials functionality for RDP access or any other remote console connections. To restrict users from saving RDP credentials, you can use Group Policies. For more information, see [this article](https://docs.microsoft.com/en-us/answers/questions/383902/how-to-prevent-windows-from-saving-rdp-connection.html).


- Encrypt backup traffic. By default, Veeam Backup & Replication encrypts network traffic transferred between public networks. To ensure secure communication of sensitive data within the boundaries of the
same network, encrypt backup traffic also in private networks. For more
information, see [Enabling Traffic Encryption](https://helpcenter.veeam.com/docs/backup/vsphere/enable_network_encryption.html).
- Use multi-factor authentication. Enable multi-factor authentication (MFA) in the Veeam Backup & Replication console to protect user accounts with additional user verification. For more information, see [Multi-Factor Authentication](https://helpcenter.veeam.com/docs/backup/vsphere/mfa.html).
- Use self-signed TLS certificates generated by Veeam Backup & Replication. This type of certificates is recommended for establishing a secure
connection from backup infrastructure components to the backup server.
For more information, see [Generating Self-Signed Certificate](https://helpcenter.veeam.com/docs/backup/vsphere/self_signed_tls.html).
- Reduce the number of user sessions opened for a long time. Set the idle timeout to automatically log off users. To do this, go to Users and Roles, select the Enable auto log off after <number> min of inactivity check box, and set the number of minutes.
- Restrict untrusted Linux VMs and Linux servers to connect to the backup server. Enable a manual SSH fingerprint verification for machines that do not meet specific conditions. For more information, see [Linux Hosts Authentication](https://helpcenter.veeam.com/docs/backup/vsphere/linux_fingerprint_check.html).
- Use the recommended Access Control List (ACL) for the custom installation folder. If you specify a custom installation folder for Veeam Backup & Replication, use the recommended ACL configuration to prevent privilege escalation
and arbitrary code execution (ACE) attacks. Remove all inherited
permissions from this folder. Then, add the following permissions:
    - Administrators: Full control, applies to this folder, subfolders and files
    - SYSTEM: Full control, applies to this folder, subfolders and files
    - CREATOR OWNER: Full control, applies to subfolders and files only
    - Users: Read & Execute, applies to this folder, subfolders and files

## Veeam Backup & Replication Database

The
 Veeam Backup & Replication configuration database stores 
credentials of user accounts required to connect to virtual servers and 
other systems in the backup infrastructure. All passwords stored in the 
database are encrypted. However, a user with administrator privileges on
 the backup server can decrypt passwords which is a potential threat.

To secure the Veeam Backup & Replication configuration database, consider the following recommendations:

- Restrict user access to the database. Check that only authorized users can access the backup server and the server that hosts the Veeam Backup & Replication configuration database (if the database runs on a remote server).
- Encrypt data in configuration backups. Enable data encryption for configuration backup to secure sensitive
data stored in the configuration database. For details, see [Creating Encrypted Configuration Backups](https://helpcenter.veeam.com/docs/backup/vsphere/config_backup_encrypted.html). Also, ensure that the repository for configuration backups is not located in the same network with the backup server.

## Backup Repositories

To secure data stored in backups and replicas, consider the following recommendations:

- Follow the 3-2-1 rule. To build a successful data protection, use the 3-2-1 rule when
designing your backup infrastructure. For more information, see [Plan How Many Copies of Data You Need (3-2-1 rule)](https://helpcenter.veeam.com/docs/backup/vsphere/planning.html#step4).
- Ensure physical security of all data storage components. All devices including backup repositories, proxies, and gateway servers must be physically located in an access-controlled area.
- Restrict user access to backups and replicas. Check that only authorized users have permissions to access backups and replicas on target servers.
- Encrypt data in backups. Use Veeam Backup & Replication built-in encryption to protect data in backups. For more information, see [Encryption Best Practices](https://helpcenter.veeam.com/docs/backup/vsphere/encryption_best_practices.html).
- Encrypt SMB traffic. If you use SMB shares in your backup infrastructure, [enable SMB signing](https://techcommunity.microsoft.com/t5/storage-at-microsoft/configure-smb-signing-with-confidence/ba-p/2418102) to prevent NTLMv2 relay attacks. Also, [enable SMB encryption](https://docs.microsoft.com/en-us/windows-server/storage/file-server/smb-security).
- Enable immutability for backups. To protect backup files from being modified or deleted, you can make
them immutable. The feature is supported for any tier of scale-out
backup repository.
- Use offline media to keep backup files in addition to virtual storage. For more information, see [Backup Repositories with Rotated Drives](https://helpcenter.veeam.com/docs/backup/vsphere/backup_repository_rotated.html) and [Tape Devices Support](https://helpcenter.veeam.com/docs/backup/vsphere/tape_device_support.html?ver=120).
- Ensure security of mount servers. Machines performing roles of mount servers have access to the backup
repositories and ESXi hosts which make them a potential source of
vulnerability. Check that all required [security recommendations](https://helpcenter.veeam.com/docs/backup/vsphere/general_security_considerations.html) are applied to these backup infrastructure components.

## Veeam Backup Enterprise Manager

To secure Veeam Backup Enterprise Manager server, consider the following recommendations:

- Install Veeam Backup & Replication server and Veeam Backup Enterprise Manager on different machines. Deploy [Veeam Backup Enterprise Manager](https://helpcenter.veeam.com/docs/backup/vsphere/enterprise_manager.html) on a server different from the Veeam Backup & Replication server to prevent a key change attack. Even if passwords are lost due
to unauthorized access, you can restore lost data with the help of
Enterprise Manager. For more information, see [Decrypting Data Without Password](https://helpcenter.veeam.com/docs/backup/vsphere/decrypt_without_pass.html).
- Enable encryption password loss protection. To improve data loss protection, provide an alternative way to decrypt
the data if a password for encrypted backup or tape is lost. For more
information, see [Managing Encryption Keys](https://helpcenter.veeam.com/docs/backup/em/em_manage_keys.html?ver=120).
- Use the recommended Access Control List (ACL) for the custom installation folder. If you specify a custom installation folder for Veeam Backup Enterprise Manager, use the recommended ACL configuration to prevent privilege escalation
and arbitrary code execution (ACE) attacks. Remove all inherited
permissions from this folder. Then, add the following permissions:
- Administrators: Full control, applies to this folder, subfolders and files
- SYSTEM: Full control, applies to this folder, subfolders and files
- CREATOR OWNER: Full control, applies to subfolders and files only
- Users: Read & Execute, applies to this folder, subfolders and files

## Veeam Cloud Connect

Veeam
 Cloud Connect secures communication between the provider side and 
tenant side with TLS. If an attacker obtains a provider’s private key, 
backup traffic can be eavesdropped and decrypted. The attacker can also 
use the certificate to impersonate the provider (man-in-the-middle 
attack). To mitigate risks, Veeam Cloud Connect providers must ensure 
that the TLS certificate is kept in a highly secure place and cannot be 
uncovered by a third-party.