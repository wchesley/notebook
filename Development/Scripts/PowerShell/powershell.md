[back](./README.md)

# Powershell

PowerShell is a task automation and configuration management program from Microsoft, consisting of a command-line shell and the associated scripting language. Initially a Windows component only, known as Windows PowerShell, it was made open-source and cross-platform on August 18, 2016, with the introduction of PowerShell Core. The former is built on the .NET Framework, the latter on .NET (previously .NET Core).

- [Powershell](#powershell)
- [Snippits and small scripts](#snippits-and-small-scripts)
  - [Check if Port is in use:](#check-if-port-is-in-use)
  - [Test if port is open/closed](#test-if-port-is-openclosed)
  - [Install msi from powershell script:](#install-msi-from-powershell-script)
  - [Get password from Environment Variable:](#get-password-from-environment-variable)
  - [Get Password from User Input:](#get-password-from-user-input)
  - [Set password for user:](#set-password-for-user)
  - [Create new Local User:](#create-new-local-user)
  - [Add Local User to Administrators group:](#add-local-user-to-administrators-group)
  - [Set Local User password to never expire:](#set-local-user-password-to-never-expire)
  - [List folder size:](#list-folder-size)
  - [Set ACL to directory recusively](#set-acl-to-directory-recusively)
  - [Get users currently logged into system:](#get-users-currently-logged-into-system)
    - [Get Count of users with given name:](#get-count-of-users-with-given-name)
  - [Uninstall any app by name:](#uninstall-any-app-by-name)
  - [Get Office 365 Update Channel:](#get-office-365-update-channel)
  - [Get Active Directory Users \& Groups - Output to CSV](#get-active-directory-users--groups---output-to-csv)
  - [Set Event Log Size limits (increase or decrease)](#set-event-log-size-limits-increase-or-decrease)
    - [Syntax](#syntax)
    - [Description](#description)
    - [Examples](#examples)
      - [Example 1: Increase the size of an event log](#example-1-increase-the-size-of-an-event-log)
      - [Example 2: Retain an event log for a specified duration](#example-2-retain-an-event-log-for-a-specified-duration)
  - [Get Hard Drive (Disk) Information](#get-hard-drive-disk-information)
  - [Create System Link (symlink)](#create-system-link-symlink)
  - [Rejoin computer to domain](#rejoin-computer-to-domain)
  - [Get file size(s) in directory](#get-file-sizes-in-directory)
  - [Get File last access time and last write time](#get-file-last-access-time-and-last-write-time)
  - [Get Printers \& Printer Queue Status](#get-printers--printer-queue-status)
    - [Get/Set Printer Driver](#getset-printer-driver)
  - [Ping all hosts in subnet](#ping-all-hosts-in-subnet)
  - [Create Shortcut (.lnk file)](#create-shortcut-lnk-file)
  - [Get Service Startup Type](#get-service-startup-type)
  - [Get Available Image/Document Scanners](#get-available-imagedocument-scanners)
  - [netsh](#netsh)
  - [PowerCfg](#powercfg)
    - [Syntax](#syntax-1)
    - [/change or /X](#change-or-x)
      - [Syntax:](#syntax-2)
      - [Arguments:](#arguments)
      - [value](#value)
  - [Get Chrome Version](#get-chrome-version)
  - [Enable Legacy Print Preview](#enable-legacy-print-preview)
  - [Disable Internet Explorer](#disable-internet-explorer)
  - [Get Windows Full Build Number](#get-windows-full-build-number)


# Snippits and small scripts

- [Docs](https://learn.microsoft.com/en-us/powershell/)
- [Github](https://github.com/PowerShell/PowerShell)
- [Powershell Profile](./powershell_profile.md)
- [Powershell Script Template](./Powershell_template.md)
- [about_Alias_Provider](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_alias_provider?view=powershell-7.5)

## Check if Port is in use: 
<sub>[back to top](#powershell)</sub>

```ps1
Get-NetTCPConnection | where Localport -eq 5000 | select Localport,OwningProcess
Localport OwningProcess
--------- -------------
    5000          1684
```

## Test if port is open/closed

```ps1
Test-NetConnection [FQDN/IP Address] -Port [port number]
```
Where:  
- `[FQDN/IP Address]` is the domain name or IP address of the server to which you are trying to connect;
- `[-Port]` is the port number where the server is listening.

```ps1
Test-NetConnection rpc.acronis.com -Port 443
```

## Install msi from powershell script: 
<sub>[back to top](#powershell)</sub>

Use [`Start-Process`](https://ss64.com/ps/start-process.html) to installs the msi package from PowerShell using `msiexec` with the `/i` and`/qn` parameters. You can optionally test using the `-wait` parameter of `Start-Process` in case it helps in your particular case. There is also a `/norestart` parameter to use with `msiexec`.

```ps1
$pkg = "D:\a\test\ultimate\WindowsApplicationDriver_1.2.1.msi";
Start-Process msiexec "/i $pkg /qn";
##Start-Process msiexec "/i $pkg /qn" -Wait;
##Start-Process msiexec "/i $pkg /norestart /qn" -Wait;

```

## Get password from Environment Variable: 
<sub>[back to top](#powershell)</sub>

```ps1
$passwd = ConvertTo-SecureString $env:password -AsPlainText -Force
```

## Get Password from User Input: 
<sub>[back to top](#powershell)</sub>

This will prompt the user to enter their password twice, no output is echo'd to shell for passwords: 
```ps1
$passwd = Read-Host 'What is your password?' -AsSecureString
```

## Set password for user: 
<sub>[back to top](#powershell)</sub>

Option 1. - This prompts you to input password into console twice: 

```ps1
net user svcNessus *
```

Option 2. - Use password from a variable: 

```ps1
net user svcNessus $passwd
```

## Create new Local User: 
<sub>[back to top](#powershell)</sub>

```ps1
New-LocalUser -Name "svcNessus" -Description "Nessus service account" -Password $passwd
```

## Add Local User to Administrators group: 
<sub>[back to top](#powershell)</sub>

```ps1
Add-LocalGroupMember -Group Administrators -Member svcNessus -Verbose
```

## Set Local User password to never expire: 
<sub>[back to top](#powershell)</sub>

```ps1
Set-LocalUser -Name "svcNessus" -PasswordNeverExpires 1
```

## List folder size: 
<sub>[back to top](#powershell)</sub>

```ps1
[math]::Round((Get-ChildItem -Path C:\Temp -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB,2)
```

## Set ACL to directory recusively 
<sub>[back to top](#powershell)</sub>

Pulled from [Stackoverflow](https://stackoverflow.com/questions/50481541/grant-domain-user-group-privilege-to-folders-recursively)

For recursive permissions you need to set `ContainerInherit,ObjectInherit`

Here is an example (Note it's not my code):

```ps1
$Path = "C:\temp\New folder"
$Acl = (Get-Item $Path).GetAccessControl('Access')
$Username = "Domain\User"
$Ar = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'FullControl', 'ContainerInherit,ObjectInherit', 'None', 'Allow')
$Acl.SetAccessRule($Ar)
Set-Acl -path $Path -AclObject $Acl
```

For more details take a look at http://www.tomsitpro.com/articles/powershell-manage-file-system-acl,2-837.html


## Get users currently logged into system: 
<sub>[back to top](#powershell)</sub>

```ps
PS C:\Users\wchesley> query user
 USERNAME              SESSIONNAME        ID  STATE   IDLE TIME  LOGON TIME
>wchesley              console             1  Active      none   7/24/2024 7:36 AM
```

### Get Count of users with given name: 

```ps1
$count = Get-LocalUser | where-Object Name -eq "svcNessus" | Measure
```

## Uninstall any app by name: 
<sub>[back to top](#powershell)</sub>

- Get app name
```powershell
Get-WmiObject win32_product | findstr /I "yourAppName"
```
- Assign the `Name` to a variable
```powershell
$AppName = "Microsoft Silverlight"
```
- Remove the app: 
```powershell
Get-WmiObject Win32_product | Where {$_.name -eq $AppName} | ForEach { $_.Uninstall() }
```

## Get Office 365 Update Channel: 
<sub>[back to top](#powershell)</sub>

ref: https://www.devhut.net/determine-the-office-update-channel/

This returns whole CDN Path: 
	`$CDNBaseUrl = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name CDNBaseUrl`

Then to get Channel specific GUID: 
`$UpdateChannel = $CDNBaseUrl.Split('/') | Select -Last 1`

notes: 

the registry key lives at "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" we need to check key named CDNBaseUrl to determine the update channel this PC is on. I took the following VB


```Vb
	 Select Case LCase(sOfficeUpdateCDN)
        Case LCase("492350f6-3a01-4f97-b9c0-c7c6ddf67d60")
            PS_GetOfficeUpdateChannel = "Current Channel"
        Case LCase("64256afe-f5d9-4f86-8936-8840a6a4f5be")
            PS_GetOfficeUpdateChannel = "Current Channel (Preview)"
        Case LCase("7ffbc6bf-bc32-4f92-8982-f9dd17fd3114")
            PS_GetOfficeUpdateChannel = "Semi-Annual Enterprise Channel"
        Case LCase("b8f9b850-328d-4355-9145-c59439a0c4cf")
            PS_GetOfficeUpdateChannel = "Semi-Annual Enterprise Channel (Preview)"
        Case LCase("55336b82-a18d-4dd6-b5f6-9e5095c314a6")
            PS_GetOfficeUpdateChannel = "Monthly Enterprise"
        Case LCase("5440fd1f-7ecb-4221-8110-145efaa6372f")
            PS_GetOfficeUpdateChannel = "Beta"
        Case LCase("f2e724c1-748f-4b47-8fb8-8e0d210e9208")
            PS_GetOfficeUpdateChannel = "LTSC"
        Case LCase("2e148de9-61c8-4051-b103-4af54baffbb4")
            PS_GetOfficeUpdateChannel = "LTSC Preview"
        Case Else
            PS_GetOfficeUpdateChannel = "Non CTR version / No Update Channel selected."
    End Select
```
Ended up with the following powershell: 
```ps
$OfficeUpdateChannel = "None"
$CDNBaseUrl = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" -Name CDNBaseUrl

$UpdateChannel = $CDNBaseUrl.Split('/') | Select -Last 1

switch ($UpdateChannel) {
    "492350f6-3a01-4f97-b9c0-c7c6ddf67d60" { $OfficeUpdateChannel = "Current Channel" }
    "64256afe-f5d9-4f86-8936-8840a6a4f5be" { $OfficeUpdateChannel = "Current Channel (Preview)" }
    "7ffbc6bf-bc32-4f92-8982-f9dd17fd3114" { $OfficeUpdateChannel = "Semi-Annual Enterprise Channel" }
    "b8f9b850-328d-4355-9145-c59439a0c4cf" { $OfficeUpdateChannel = "Semi-Annual Enterprise Channel (Preview)" }
    "55336b82-a18d-4dd6-b5f6-9e5095c314a6" { $OfficeUpdateChannel = "Monthly Enterprise" }
    "5440fd1f-7ecb-4221-8110-145efaa6372f" { $OfficeUpdateChannel = "Beta" }
    "f2e724c1-748f-4b47-8fb8-8e0d210e9208" { $OfficeUpdateChannel = "LTSC" }
    "2e148de9-61c8-4051-b103-4af54baffbb4" { $OfficeUpdateChannel = "LTSC (Preview)" }
    Default { $OfficeUpdateChannel = "Non CTR version / No Update Channel selected"}
}
Write-Host "O365 update channel: $OfficeUpdateChannel
```

## Get Active Directory Users & Groups - Output to CSV
<sub>[back to top](#powershell)</sub>

```ps1
# Import the Active Directory module
Import-Module ActiveDirectory

# Get all AD groups
$groups = Get-ADGroup -Filter *

# Create an array to store the results
$results = @()

# Loop through each group
foreach ($group in $groups) {
    # Get members of the group
    $members = Get-ADGroupMember -Identity $group.DistinguishedName | Where-Object {$_.objectClass -eq "user"}
    
    # If the group has members
    if ($members) {
        foreach ($member in $members) {
	 # Get user details including the enabled status
            $user = Get-ADUser -Identity $member.SamAccountName -Properties Enabled
            # Create a custom object with group and user information
            $result = [PSCustomObject]@{
                GroupName = $group.Name
                UserName = $member.Name
                UserSamAccountName = $member.SamAccountName
		UserEnabled = $user.Enabled
            }
            # Add the result to the array
            $results += $result
        }
    } else {
        # If the group has no members, add an entry with empty user fields
        $result = [PSCustomObject]@{
            GroupName = $group.Name
            UserName = ""
            UserSamAccountName = ""
  	    UserEnabled = $null
        }
        $results += $result
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\ADGroupsAndUsers.csv" -NoTypeInformation

# Display the results in the console
$results | Format-Table -AutoSize

Write-Host "Results have been exported to C:\ADGroupsAndUsers.csv"
```

## Set Event Log Size limits (increase or decrease)
<sub>[back to top](#powershell)</sub>

<sub>Also see <a href="https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-eventlog?view=powershell-5.1">Get-EventLog</a> for reading the event log.</sub>

Sets the event log properties that limit the size of the event log and the age of its entries.

[](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/limit-eventlog?view=powershell-5.1#syntax)

### Syntax

```ps1
Limit-EventLog
        [-LogName] <String[]>
        [-ComputerName <String[]>]
        [-RetentionDays <Int32>]
        [-OverflowAction <OverflowAction>]
        [-MaximumSize <Int64>]
        [-WhatIf]
        [-Confirm]
        [<CommonParameters>]
```

[ref](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/limit-eventlog?view=powershell-5.1#description)

### Description

The `Limit-EventLog` cmdlet sets the maximum size of a classic event log, how long each event must be retained, and what happens when the log reaches its maximum size. You can use it to limit the event logs on local or remote computers.

The cmdlets that contain the EventLog noun (the EventLog cmdlets) work only on classic event logs. To get events from logs that use the Windows Event Log technology in Windows Vista and later versions of Windows, use `Get-WinEvent`.

### Examples

#### Example 1: Increase the size of an event log

```ps1
Limit-EventLog -LogName "Windows PowerShell" -MaximumSize 20KB
```

This command increases the maximum size of the Windows PowerShell event log on the local computer to 20480 bytes (20 KB).

[](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/limit-eventlog?view=powershell-5.1#example-2-retain-an-event-log-for-a-specified-duration)

#### Example 2: Retain an event log for a specified duration

```ps1
Limit-EventLog -LogName Security -ComputerName "Server01", "Server02" -RetentionDays 7
```

This command ensures that events in the Security log on the Server01 and Server02 computers are retained for at least 7 days.

## Get Hard Drive (Disk) Information
<sub>[back to top](#powershell)</sub>

apart from the classic tools like the Disk Management Utility or Diskpart.

The corresponding Powershell cmdlets can be retrieved with the following command:

    Get-Command -Module Storage -Name Get*
    

-   **Get-PhysicalDisk** allows you to get information about physical disks and device characteristics.
-   **Get-Disk display** gets disk information at the logical level of the operating system.
-   **Get-Partition** shows partition information on all drives.
-   **Get-Volume** displays volume information on all disks.

Ex:

```ps1
Get-PhysicalDisk |ft -Wrap
```

![Get-PhysicalDisk](https://danielschwensen.github.io/assets/2020/Get-PhysicalDisk.png)

```ps1
Get-Disk
```

![Get-Disk](https://danielschwensen.github.io/assets/2020/Get-Disk.png)

```ps1
Get-Partition
```

![Get-Partition](https://danielschwensen.github.io/assets/2020/Get-Partition.png)

```ps1
Get-Volume
```

![Get-Volume](https://danielschwensen.github.io/assets/2020/Get-Volume.png)

## Create System Link (symlink)
<sub>[back to top](#powershell)</sub>

**Windows 10 (and Powershell 5.0 in general) allows you to [create symbolic links via the New-Item cmdlet](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-item).**

Usage:

```ps1
New-Item -Path C:\LinkDir -ItemType SymbolicLink -Value F:\RealDir
```

Or in your profile:

```ps1
function make-link ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}
```

## Rejoin computer to domain
<sub>[back to top](#powershell)</sub>

As of server 2008 R2, `Test-ComputerSecureChannel` was added as a cmdlet in powershell, making this an easy process. 

```ps1
Test-ComputerSecureChannel -Repair -Credential (Get-Credential)
```

Will require that you input domain admin credentials in a window pop-up before it will repair the relationship.

## Get file size(s) in directory
<sub>[back to top](#powershell)</sub>

```ps1
Get-ChildItem -Path 'E:\Backups' -Recurse -Force -File | Select-Object -Property FullName `,@{Name='SizeGB';Expression={$_.Length / 1GB}} `  ,@{Name='SizeMB';Expression={$_.Length / 1MB}}` ,@{Name='SizeKB';Expression={$_.Length / 1KB}} | Sort-Object { $_.SizeKB } -Descending | 
Export-Csv -Path C:\Temp\SYNOLOGYLUN_file_sizes.csv  
```

Alternate: Replace `Export-Csv` with `Output-Grid` to not create a file and have a new window popup with your results.

## Get File last access time and last write time
<sub>[back to top](#powershell)</sub>

This just involves appending a filter to your `ls`, `gci` or `Get-ChildItem` command: 

```ps1
get-childitem -Path C:\Path\To\Dir -Recurse  | Select FullName,LastAccessTime,LastWriteTime
```

Since Windows 10 "Redstone 4" (April 2018) update, `LastAccessTime` should be enabled by default. To confirm that `LastAccessTime` is enabled (Windows 10, post April 2019), the value is located in the following registry key: `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\FileSystem`.

The `NtfsDisableLastAccessUpdate` value may contain one of the following integers:

    0x80000000: User Managed, the “Last Access” updates are enabled,
    0x80000001: User Managed, the “Last Access” updates are disabled,
    0x80000002: System Managed, the “Last Access” updates are enabled,
    0x80000003: System Managed, the “Last Access” updates are disabled.

For Windows 10 prior to April 2019 the following registry key should be set to `1`: 

`HKLM\SYSTEM\CurrentControlSet\Control\FileSystem > NtfsDisableLastAccessUpdate`

## Get Printers & Printer Queue Status
<sub>[back to top](#powershell)</sub>

Get all printers: 

```ps1
Get-Printer
```

Get all printers job queue status: 

```ps1
$AllPrinters = Get-Printer
foreach ($printer in $AllPrinters) {
    Get-PrintJob -PrinterObject $printer
}
```

Example output: 

```ps1
PS C:\> $Printers = Get-Printer
PS C:\> foreach($printer in $Printers) {
>> Get-PrintJob -PrinterObject $printer
>> }

Id    ComputerName    PrinterName     DocumentName         SubmittedTime        JobStatus      
--    ------------    -----------     ------------         -------------        ---------
2                     EPSON25D7F7 ... 0229-02-Oil.dwg      5/7/2025 3:10:57 PM  Error, Printing
3                     EPSON25D7F7 ... 0229-02-Oil.dwg      5/7/2025 3:13:17 PM  Normal


PS C:\> get-printer

Name                           ComputerName    Type         DriverName                PortName        Shared   Published  DeviceType     
----                           ------------    ----         ----------                --------        ------   ---------  ----------
SEC84251932C63E                                Local        Samsung M337x 387x 407... WSD-82d55bd4... False    False      Print
progeCAD PDF Virtual Printe...                 Local        Amyuni Document Conver... NUL:            False    False      Print
progeCAD Image Virtual Prin...                 Local        Amyuni Document Conver... NUL:            False    False      Print
OneNote (Desktop)                              Local        Send to Microsoft OneN... NUL:            False    False      Print
Microsoft XPS Document Writer                  Local        Microsoft XPS Document... PORTPROMPT:     False    False      Print
Microsoft Print to PDF                         Local        Microsoft Print To PDF    PORTPROMPT:     False    False      Print
HP Color LaserJet 3600                         Local        HP Color LaserJet 3600    HPDIU_192.16... False    False      Print
Fax                                            Local        Microsoft Shared Fax D... SHRFAX:         False    False      Print
EPSON25D7F7 (WF-6590 Series)                   Local        Microsoft IPP Class Dr... WSD-5e72957b... False    False      Print
```

### Get/Set Printer Driver

Changed printer driver for user via powershell: 
```ps1
Get-Printer -Name '<printer name>' 
Get-PrinterDriver -Name '<Driver Name>'
Get-PrinterDriver # <- View all installed drivers
# Both just to confirm we're working with the correct device^^ 
Set-Printer -Name "<PrinterName>" -DriverName "<DriverName>"
```
> Where:
> - `<PrinterName>` is the string name of the printer
> - `<DriverName>` is the string name of the desired driver

## Ping all hosts in subnet
<sub>[back to top](#powershell)</sub>

So you can’t install Advanced IP Scanner or Angry IP Scanner etc…

Use this PS Script instead: 

```ps1
for ($i = 1; $i -lt 255; $i++) {
Test-Connection “192.168.1.$i” -Count 1 -ErrorAction SilentlyContinue
}
```

Adjust IP range as needed, currently set for a `/24` subnet. Takes about a minute or so to run through all hosts. 

## Create Shortcut (.lnk file)
<sub>[back to top](#powershell)</sub>

I want to create a shortcut with PowerShell for this executable:

```ps1
C:\Program Files (x86)\ColorPix\ColorPix.exe
```

While there's no native commandlet in PowerShell, you can use a COM object instead: 

```ps1
$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\ColorPix.lnk")
$Shortcut.TargetPath = "%SystemDrive%\Program Files (x86)\ColorPix\ColorPix.exe"
$Shortcut.Save()
```

If so desired, you could create a PowerShell script save as `Set-Shortcut.ps1` in your `$PWD` (or save to your user/system `$PATH`):

```ps1
param ( [string]$SourceExe, [string]$DestinationPath )

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($DestinationPath)
$Shortcut.TargetPath = $SourceExe
$Shortcut.Save()
```

Usage: 

```ps1
Set-Shortcut "%SystemDrive%\Program Files (x86)\ColorPix\ColorPix.exe" "$Home\Desktop\ColorPix.lnk"
```

If you want to pass arguments to the target exe, it can be done by:

```ps1
#Set the additional parameters for the shortcut
$Shortcut.Arguments = "/argument=value"
```

_...before_ _$Shortcut.Save()_.

For convenience, here is a modified version of Set-Shortcut.PS1:

```ps1
param ( [string]$SourceExe, [string]$ArgumentsToSourceExe, [string]$DestinationPath )
$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($DestinationPath)
$Shortcut.TargetPath = $SourceExe
$Shortcut.Arguments = $ArgumentsToSourceExe
$Shortcut.Save()
```

It accepts arguments as its second parameter to set the Destination path of the new shortcut. 

## Get Service Startup Type
<sub>[back to top](#powershell)</sub>

To determine the startup type of a Windows service using PowerShell, the Get-Service cmdlet can be employed. This cmdlet retrieves information about installed services, and the StartupType property of the returned service objects contains the desired information.
To get the startup type of a specific service:

```ps1
(Get-Service -Name "ServiceName").StartupType
```

Replace "ServiceName" with the actual name of the service (e.g., "BITS" or "Spooler").
To get the startup type for all services:

```ps1
Get-Service | Select-Object Name, DisplayName, StartupType
```

This command lists the name, display name, and startup type for every service on the system.
To filter services based on their startup type:

```ps1
Get-Service | Where-Object {$_.StartupType -eq "Automatic"}
```

This example filters for services with an "Automatic" startup type. Other common StartupType values include "Manual," "Disabled," and "AutomaticDelayedStart."

## Get Available Image/Document Scanners
<sub>[back to top](#powershell)</sub>

To get a list of available Image/Document scanners via powershell: 

```ps1
Get-PNPDevice -Class "Image"
Status     Class      FriendlyName   InstanceId 
------     -----      ------------   ---------- 
OK         Image      fi-7160        USB\VID_...
```

## netsh
<sub>[back to top](#powershell)</sub>

View wireless profiles: 

```ps1
netsh wlan show profiles
Profiles on interface Wi-Fi:

Group policy profiles (read only)
---------------------------------
    <None>

User profiles
-------------
    All User Profile     : WTN-Wireless
```

Show available interfaces: 

```ps1
netsh interface show interface
Admin State    State          Type             Interface Name
-------------------------------------------------------------------------
Enabled        Connected      Dedicated        Ethernet
Enabled        Disconnected   Dedicated        Wi-Fi
```

Export wireless profile (use `key=clear` for plaintext password of wifi network):

```ps1
netsh wlan export profile name="KOAMA-Wireless" folder=C:\Support interface="Wi-Fi"
```

- This command exports the wirless profile information to a XML file at the given directory (`folder=`)

Import wireless profile: 

```ps1
netsh wlan add profile filename="C:\Support\Wi-Fi-WTN-Wireless.xml"
```

## PowerCfg
<sub>[back to top](#powershell)</sub>

Use powercfg.exe to control power plans - also called power schemes - to use the available sleep states, to control the power states of individual devices, and to analyze the system for common energy-efficiency and battery-life problems.

### Syntax

Powercfg command lines use the following syntax:

`powercfg /option [arguments] [/?]`

where option is one of the options listed in the following table, and arguments is one or more arguments that apply to the selected option. Including `/?` in a command line displays help for the specified option. For a full list of CLI options see [powercfg cli options](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/powercfg-command-line-options#command-line-options)

---

A `powercfg` option I've been using quite a bit is `/change`

### /change or /X

Modifies a setting value in the current power scheme.

#### Syntax:

` /change setting value`

#### Arguments:

 setting

  Specifies one of the following options:

- monitor-timeout-ac
- monitor-timeout-dc
- disk-timeout-ac
- disk-timeout-dc
- standby-timeout-ac
- standby-timeout-dc
- hibernate-timeout-ac
- hibernate-timeout-dc

> Where AC is battery power and DC is plugged in. PC's without a battery will choose to ignore the AC power settings, who would have thought? 

#### value

Specifies the new value, in minutes.

Examples:

`powercfg /change monitor-timeout-ac 5`

```ps1
# Disable sleep on DC power: 
powercfg /x standby-timeout-dc 0
```

## Get Chrome Version
<sub>[back to top](#powershell)</sub>

Get the current installed version of Google Chrome: 

```ps1
(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)' | Get-Item | Select-Object -ExpandProperty VersionInfo
```

## Enable Legacy Print Preview
<sub>[back to top](#powershell)</sub>

Print preview not working in windows 11? Enable legacy print preview. Via Powershell or CMD run:  
`reg add "HKCU\Software\Microsoft\Print\UnifiedPrintDialog" /v "PreferLegacyPrintDialog" /d 1 /t REG_DWORD /f`  
This registry key will enable legacy print preview for windows 11. 

## Disable Internet Explorer

use DISM: 

```ps1
dism /online /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0 /NoRestart
```

Optionally (required to satisfy vulnerability scanners ie. Nessus), set registry killbit: 

```ps1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "NotifyDisableIEOptions" /t REG_DWORD /d 1 /f
```

## Get Windows Full Build Number

```ps1
$properties = 'CurrentMajorVersionNumber','CurrentMinorVersionNumber','CurrentBuild','UBR'

"{0}.{1}.{2}.{3}" -f ($properties | ForEach-Object {Get-ItemPropertyValue -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' -Name $_})

## Example: 
PS C:\Users\walker.chesley> $properties = 'CurrentMajorVersionNumber','CurrentMinorVersionNumber','CurrentBuild','UBR'
PS C:\Users\walker.chesley> "{0}.{1}.{2}.{3}" -f ($properties | ForEach-Object {Get-ItemPropertyValue -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' -Name $_})
10.0.26200.7623
PS C:\Users\walker.chesley>
```