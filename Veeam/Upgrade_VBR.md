[back](./README.md)

# Upgrade Veeam Backup & Replication

ref: [Upgrade VBR to 12.2](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr.html?ver=120)  
ref: 12.3.1 Update [KB4696](https://www.veeam.com/kb4696)

- In essence, download the new versions ISO from Veeam. 
- open the ISO once download is complete
- run `setup.exe` located within root directory of ISO
- Follow the wizard to upgrade Veeam Backup & Replication

To perform upgrade of Veeam Backup & Replication to version
 12.2, you must be running version 11a (build 11.0.1.1261) or later on 
the supported operating system (refer to the [System Requirements](https://helpcenter.veeam.com/docs/backup/hyperv/system_requirements.html) section of this document). For information on upgrade from earlier versions, see [this Veeam KB article](https://www.veeam.com/kb2053).

Before you upgrade Veeam Backup & Replication, [check prerequisites](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_byb.html). Then use the Veeam Backup & Replication upgrade wizard to install the product.

1. [Start the upgrade wizard](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_launch.html).
2. [Select the component to upgrade](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_select_component.html).
3. [Read and accept the license agreement](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_license_agreement.html).
4. [Review the components that will be upgraded](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_upgrade.html).
5. [Provide a license file](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_license.html).
6. [Install missing software](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_missing.html).
7. [Specify service account settings](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_service_account.html).
8. [Specify the database engine and instance](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_database.html).
9. [Perform the configuration check](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_configuration_check.html).
10. [Begin upgrade](https://helpcenter.veeam.com/docs/backup/hyperv/upgrade_vbr_ready_to_upgrade.html).

## Check VBR Version (Powershell)

To get the current VBR version via powershell; it can be easily found in the Local Machine (HKLM) registry hive. From an admin powershell console: 

```ps1
$CoreDllPath = (Get-ItemProperty -Path "HKLM:\Software\Veeam\Veeam Backup and Replication\" | Select-Object -ExpandProperty CorePath) + "Veeam.Backup.Core.dll"
$CoreDll = Get-Item -Path $CoreDllPath
$CoreDll.VersionInfo.ProductVersion + " - " + $CoreDll.VersionInfo.Comments
```

On a typicaly VBR installation, comments may or may not be present and the output (without comments): 

```ps1
PS C:\> $CoreDll.VersionInfo.ProductVersion + " - " + $CoreDll.VersionInfo.Comments 
12.3.0.310 -   
PS C:\>  
```