# Powershell

PowerShell is a task automation and configuration management program from Microsoft, consisting of a command-line shell and the associated scripting language. Initially a Windows component only, known as Windows PowerShell, it was made open-source and cross-platform on August 18, 2016, with the introduction of PowerShell Core. The former is built on the .NET Framework, the latter on .NET (previously .NET Core).

- [Powershell](#powershell)
- [Snippits and small scripts](#snippits-and-small-scripts)
  - [Check if Port is in use:](#check-if-port-is-in-use)
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


# Snippits and small scripts

- [Docs](https://learn.microsoft.com/en-us/powershell/)
- [Github](https://github.com/PowerShell/PowerShell)
- [Powershell Profile](./powershell_profile.md)
- [Powershell Script Template](./Powershell_template.md)

## Check if Port is in use: 

```ps1
Get-NetTCPConnection | where Localport -eq 5000 | select Localport,OwningProcess
Localport OwningProcess
--------- -------------
    5000          1684
```

## Install msi from powershell script: 

Use [`Start-Process`](https://ss64.com/ps/start-process.html) to installs the msi package from PowerShell using `msiexec` with the `/i` and`/qn` parameters. You can optionally test using the `-wait` parameter of `Start-Process` in case it helps in your particular case. There is also a `/norestart` parameter to use with `msiexec`.

```ps1
$pkg = "D:\a\test\ultimate\WindowsApplicationDriver_1.2.1.msi";
Start-Process msiexec "/i $pkg /qn";
##Start-Process msiexec "/i $pkg /qn" -Wait;
##Start-Process msiexec "/i $pkg /norestart /qn" -Wait;

```

## Get password from Environment Variable: 

```ps1
$passwd = ConvertTo-SecureString $env:password -AsPlainText -Force
```

## Get Password from User Input: 

This will prompt the user to enter their password twice, no output is echo'd to shell for passwords: 
```ps1
$passwd = Read-Host 'What is your password?' -AsSecureString
```

## Set password for user: 

Option 1. - This prompts you to input password into console twice: 
```ps1
net user svcNessus *
```

Option 2. - Use password from a variable: 

```ps1
net user svcNessus $passwd
```

## Create new Local User: 

```ps1
New-LocalUser -Name "svcNessus" -Description "Nessus service account" -Password $passwd
```

## Add Local User to Administrators group: 

```ps1
Add-LocalGroupMember -Group Administrators -Member svcNessus -Verbose
```

## Set Local User password to never expire: 

```ps1
Set-LocalUser -Name "svcNessus" -PasswordNeverExpires 1
```

## List folder size: 

```ps1
[math]::Round((Get-ChildItem -Path C:\Temp -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB,2)
```

## Set ACL to directory recusively 

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