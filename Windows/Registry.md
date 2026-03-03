<sub>[back](./README.md)</sub>

# Windows Registry

The Windows registry is a central database that is leveraged by the operating system and many applications to store all sorts of configuration information and user preferences.

Leveraging data from the registry can provide key insights to an investigation that may not be found in other artifacts. A few of the key areas of focus are:

- User activity (program execution, files and folders accessed, urls types)
- System configuration (OS information, hostname, timezone, adapter settings, network configuration, audit policy)
- Installed applications
- Attached storage devices
- Malware persistence


This document is an overview of key components of Windows Registry forensics, **including:**

- Registry hives
- Registry artifacts
- Registry analysis tools
- Registry forensics tips

If you’d like to us to add something to our Windows forensics cheat sheet, [please contact us](https://www.cybertriage.com/contact/).

## **Core Windows Registry Hives and Their Forensic Value**

Each Windows registry hive is a file that stores **config settings** and **system/user data**, and these are essential sources in forensic investigations.

As DFIR expert [Chris Ray](https://www.linkedin.com/in/chris-ray-88175a21/)
 explains, “Windows Registry is a key source of forensic data because of
 its function within the system. It’s used as a repository to store 
system and application settings, configurations, preferences, usage 
telemetry, and more.”

**Breakdown of each:**

| **NTUSER.DAT**  |  |
| --- | --- |
| **Location** | `C:\Users\<username>\NTUSER.DAT` |
| **Loaded under** | `HKEY_USERS\<SID>` |
| **Forensic value** | Tracks user-specific settings and activity. |
| **Contains** | <ul> <li>[**UserAssist**](https://www.cybertriage.com/blog/userassist-forensics-2025/): Tracks program execution for apps with GUI components or app/LNK files launched via the Windows UI. </li> <li>[**RunMRU**](https://www.cybertriage.com/blog/how-to-investigate-runmru-2025/): Tracks program execution for commands run via Windows run dialog. </li> <li>[**OpenSaveMRU**](https://www.cybertriage.com/artifact/windows-opensave-mru-artifact/): Tracks files opened/saved via Windows Open/Save dialog. </li> <li>[**OfficeMRU**](https://www.cybertriage.com/artifact/office-mru-registry/): Tracks most recently used files for each Office app. Ex: Word, Excel, PowerPoint. </li> <li>[**LastVistedMRU**](https://www.forensafe.com/blogs/lastvisitedmru.html): Tracks applications that have used the Windows Open/Save dialog, along with last location opened for each app. </li> <li>[**RecentDocs**](https://www.forensafe.com/blogs/recentdocs.html): Tracks recently accessed files and folders opened. Used to populate various “recent” tables in Windows. </li> <li>[**WordWheelQuery**](https://www.4n6post.com/2023/02/registry-wordwheelquery.html): Tracks an ordered list of search strings put into Windows File Explorer search box. </li> <li>[**TypedPaths**](https://forensafe.com/blogs/typedpaths.html): Tracks paths typed into File Explorer path bar directly by a user. </li> <li>[**ShellBags**](https://www.cybertriage.com/blog/shellbags-forensic-analysis-2025/): Includes UNC path based data. Can show evidence of users opening folders. </li> <li>[**MountPoints2**](https://docs.velociraptor.app/artifact_references/pages/windows.registry.mountpoints2/): Tracks mounted USB and network shares. </li> <li> [**User-specific installed apps**](https://github.com/keydet89/RegRipper3.0/blob/bdf7ac2500a41319479846fe07202b7e8a61ca1f/plugins/uninstall.pl#L4): Tracks what apps have been installed for the user instead of system-wide. </li> <li>**User-specific Autorun entries**: User-specific persistence in the Registry. Ex: Run/RunOnce keys. </li></ul> |

| **UsrClass.dat** |  |
| --- | --- |
| **Location** | `C:\Users\<username>\AppData\Local\Microsoft\Windows\UsrClass.dat` |
| **Loaded under** | `HKEY_USERS\<SID>_Classes` |
| **Forensic value** | Mainly stores user-specific shell settings and mappings. |
| **Contains** | <ul> <li>[**ShellBag**](https://www.cybertriage.com/blog/shellbags-forensic-analysis-2025/): Tracks existence of folders and archive files. Includes UNC path-based data. Can show evidence of users opening folders. </li><li>[**MUICache**](https://www.cybertriage.com/blog/muicache-2025-guide/): Tracks program execution for apps with a GUI component. </li></ul> |

| **SAM (Security Account Manager)** |  |
| --- | --- |
| **Location** | `C:\Windows\System32\Config\SAM` |
| **Loaded under** | `HKEY_LOCAL_MACHINE\SAM` |
| **Forensic value** | Contains details about local user accounts and groups. |
| **Contains** | <ul> <li>**Local user account information:** Ex: username, SID, creation date, last logon date, etc. </li><li>**Local groups and their members:** Ex: Figure out who is a local admin. </li><li>**Local account password hashes:** Used for offline password cracking. </li></ul> |

| **SYSTEM** |  |
| --- | --- |
| **Location** | `C:\Windows\System32\Config\SYSTEM` |
| **Loaded under** | `HKEY_LOCAL_MACHINE\SYSTEM` |
| **Forensic value** | Tracks system config and USB/device usage. |
| **Contains** | <ul> <li>[**ShimCache**](https://www.cybertriage.com/blog/shimcache-and-amcache-forensic-analysis-2025/): Used to track app compatibility info. Can prove file existence and sometimes file execution. </li><li>[**Activity Moderator (BAM/DAM**)](https://forensafe.com/blogs/bam.html): Used to track apps that run in the background or are used during various low-power usage scenarios. </li><li>[**Windows Services**](https://github.com/keydet89/RegRipper3.0/blob/bdf7ac2500a41319479846fe07202b7e8a61ca1f/plugins/services.pl#L4): Contains info on all installed Windows services, including system drivers. </li><li>[**MountedDevices**](https://winreg-kb.readthedocs.io/en/latest/sources/system-keys/Mounted-devices.html): Used to map drive letters to attached devices. </li><li>[**Enum USB\USBSTOR**](https://www.forensafe.com/blogs/usbforensics.html): Used to get a list of attached USB device history: Vendor ID, product ID, serial#, first and last attached times. </li><li>[**TCP/IP Interfaces**](https://www.cybertriage.com/blog/how-to-find-evidence-of-network-windows-registry/): Lists out network interface details. Ex. Assigned IP, DNS address, default gateway, and DHCP lease time. </li><li>**System configuration details**: Time zone, computer name, last shutdown time, network interfaces, and network history. </li></ul> |

| **SOFTWARE** |  |
| --- | --- |
| **Location** | `C:\Windows\System32\Config\SOFTWARE` |
| **Loaded under** | `HKEY_LOCAL_MACHINE\SOFTWARE` |
| **Forensic value** | Lists installed software, system settings, and global auto-run entries. |
| **Contains** | <ul> <li>[**System-wide installed applications**](https://www.forensafe.com/blogs/installedprograms.html): Contains info about currently installed apps installed system-wide. </li><li>[**NetworkList**](https://www.cybertriage.com/blog/how-to-find-evidence-of-network-windows-registry/): Lists connected network names along with first and last connection times. </li><li>[**Scheduled Tasks**:](https://www.cybertriage.com/blog/windows-scheduled-tasks-for-dfir-investigations/) Tracks Window Task definitions commonly used for persistence and privilege escalation. </li><li>[**Profilelist**](https://forensafe.com/blogs/profileslist.html): Provides a mapping of user SIDs to profile directory location. </li><li>[**OS Information**](https://www.forensafe.com/blogs/systeminformation.html): OS version, build numbers, product name, and install date. </li><li>**System-wide Autorun entries**: Persistence in the registry. Ex: Run/RunOnce keys.</li></ul> |

| **SECURITY** |  |
| --- | --- |
| **Location** | `C:\Windows\System32\Config\SECURITY` |
| **Loaded under** | `HKEY_LOCAL_MACHINE\SECURITY` |
| **Forensic value** | Contains security policies and auditing settings. Mainly used to 
understand what artifacts may not be available due to poor audit 
policies. |
| **Contains** | <ul> <li>[**Local audit policy config**](https://www.kazamiya.net/en/PolAdtEv): Details the current audit settings of the system to help better understand what data may be found in the event log. </li><li>**LSA secrets**: Contains sensitive data such as cached domain credentials and service account passwords. </li></ul> |

| **Amcache.hve** |  |
| --- | --- |
| **Location** | `C:\Windows\AppCompat\Programs\Amcache.hve` |
| **Loaded under** | Not part of the Windows Registry. |
| **Forensic value** | Tracks executable metadata and run history, even for deleted files. |
| **Contains** | <ul> <li>Prove files existed on disk even after file deletion. </li><li>Provides insight into installed applications, along with how the app was installed. </li><li>SHA1 hash for PE files and drivers even after file deletion. </li><li>Stores comprehensive metadata for PE files and DLLs like file size, SHA1, and PE header info like CompanyName, FileVersion, etc. </li></ul> |

## **Key Registry Artifacts by Forensic Purpose**

The list below is an up-to-date reference for data artifacts in the Windows Registry.

That said, we don’t recommend investigators memorize these details: If you approach investigations **data artifact first**, you risk **losing the forest for the trees**. Instead, we suggest using higher-level computing concepts to guide your investigation: The [information artifact level vs the data artifact level](https://www.cybertriage.com/blog/information-artifacts-simplify-dfir-analysis.).

DFIR experts like [Brian Carrier](https://www.linkedin.com/in/carrier4n6/) recommend this approach because it makes investigations both **easier** and **more comprehensive**.

### **Program Execution Tracking**

| **Artifact** | **Path** | **Value** |
| --- | --- | --- |
| [**UserAssist**](https://www.cybertriage.com/blog/userassist-forensics-2025/) | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist` | Tracks last run time, run count, and path for apps with GUI components; values are ROT13-encoded. |
| **ShimCache (AppCompatCache)** | `SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache` | Can prove existence of files (even after being deleted) and in some scenarios provide high degree of confidence on execution. |
| [**AmCache**](https://www.cybertriage.com/blog/shimcache-and-amcache-forensic-analysis-2025/) | `C:\Windows\AppCompat\Programs\Amcache.hve` | Can prove existence of files (even after being deleted) and in some scenarios provide high degree of confidence on execution. |
| [**RunMRU**](https://www.cybertriage.com/blog/how-to-investigate-runmru-2025/) | `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU` | Commands typed into Windows Run dialog. |
| [**MUICache**](https://www.cybertriage.com/blog/muicache-2025-guide/) | `HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache` | Full path to executable with a GUI component and limited PE header info. |
| **BAM/DAM** | `SYSTEM\CurrentControlSet\Services\{dam|bam}\State\UserSettings\{SID}` | Full path to executable and last execution time. |

### **USB and External Device History**

| **Artifact** | **Path** | **Value** |
| --- | --- | --- |
| **USBSTOR** | `SYSTEM\CurrentControlSet\Enum\USBSTOR` | Device vendor, model, serial number, and first/last connection times. |
| **MountedDevices** | `SYSTEM\MountedDevices` | Drive letter to device mapping. |
| **MountPoints2** | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2` | Records user-level mounted devices; can include network shares mounted. |
| **Windows Portable Devices** | `SOFTWARE\Microsoft\Windows Portable Devices` | Details about connected media devices. |

### **User Activity**

| **Artifact** | **Path** | **Value** |
| --- | --- | --- |
| **RecentDocs** | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs` | Recently accessed files (names only not path), grouped by extension on per-user basis. |
| [**OpenSaveMRU**](https://www.cybertriage.com/artifact/windows-opensave-mru-artifact/) | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePIDlMRU` | Recently accessed files (full paths) opened/saved via Windows 
Open/Save dialog. Grouped by extension and recorded on per-user basis. |
| [**ShellBags**](https://www.cybertriage.com/blog/shellbags-forensic-analysis-2025/) | `NTUSER.DAT\Software\Microsoft\Windows\Shell`

`UsrClass.DAT\Local Settings\Software\Microsoft\Windows\Shell` | Folders that exist on the system (even after deletion) and evidence of users opening folders in certain scenarios. |
| **TypedPaths** | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths` | Tracks typed data into Explorer search bar on per-user basis. |
| **WordWheelQuery** | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery` | Tracks ordered list of search queries in Explorer search dialog on per-user basis. |

### **Network + Remote Connections**

| **Artifact** | **Path** | **Value** |
| --- | --- | --- |
| **RDP Connections MRU** | `NTUSER.DAT\Software\Microsoft\Terminal Server Client\Default` | MRU list of endpoints recently connected to via Windows RDP. |
| **RDP Connections** | `NTUSER.DAT\Software\Microsoft\Terminal Server Client\Servers` | Subkeys contain hostnames of systems that have been RDP’ed to with username used. Can contain more data than the default key. |
| [**NetworkList Profiles**](https://www.cybertriage.com/blog/how-to-find-evidence-of-network-windows-registry/) | `SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles` | Names of networks the system has connected to as well as first and last connection times. |
| [**Network Interfaces**](https://www.cybertriage.com/blog/how-to-find-evidence-of-network-windows-registry/) | `HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\` | Info on all the system’s network interfaces: IP, DNS, default gateway, and leasing info. |

### **Persistence and Autostart**

| **Artifact** | **Path** | **Value** |
| --- | --- | --- |
| [**Run/RunOnce Keys**](https://attack.mitre.org/techniques/T1547/001/) | `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Run`  `NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\RunOnce`  `SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce`  `SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer\Run`  `SOFTWARE\Microsoft\Windows\CurrentVersion\Run` | Programs autostart when users log on. |
| [**Windows Services**](https://attack.mitre.org/techniques/T1543/003/) | `SYSTEM\CurrentControlSet\Services` | Kernel drivers and services information. Commonly used for persistence. |
| [**Winlogon**](https://attack.mitre.org/techniques/T1547/004/) | `SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` | Alternative login shells or persistence mechanisms. |
| [**Scheduled Tasks**](https://attack.mitre.org/techniques/T1053/) | `HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache` | Find persistence from scheduled tasks in the Registry. |