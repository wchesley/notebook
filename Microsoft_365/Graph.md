[Back](./README.md)

# Microsoft Graph API Quick Reference for Microsoft 365 Administrators

## Prerequisites

- Install the Microsoft Graph PowerShell module:
  ```powershell
  Install-Module Microsoft.Graph -Scope CurrentUser
  ```

- Connect to Microsoft Graph:
  ```powershell
  Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"
  ```

## Common Tasks

### List All Users
```powershell
Get-MgUser
```

### Get a Specific User
```powershell
Get-MgUser -UserId user@domain.com
```

The `Get-MgUser -Filter` option is limited on it's filtering capabilities. In more advanced cases (like filtering by `contains`) it's easier to grab a list of all users and filter locally in PowerShell: 

```ps1
Get-MgUser -All | Where-Object {$_.UserPrincipalName -like "*walker.chesley*"}
```

### Create a New User
```powershell
New-MgUser -AccountEnabled $true -DisplayName "John Doe" -MailNickname "johndoe" -UserPrincipalName "johndoe@domain.com" -PasswordProfile @{ ForceChangePasswordNextSignIn = $true; Password = "TempP@ssw0rd!" }
```

### List All Groups
```powershell
Get-MgGroup
```

### Add a User to a Group
```powershell
Add-MgGroupMember -GroupId <GroupId> -DirectoryObjectId <UserId>
```

### List Teams
```powershell
Get-MgTeam
```

## Disconnect from Microsoft Graph
```powershell
Disconnect-MgGraph
```

> For more cmdlets and advanced scenarios, see the [Microsoft Graph PowerShell documentation](https://learn.microsoft.com/powershell/microsoftgraph/).