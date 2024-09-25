# Powershell Profile



## Profile Locations

<table><thead><tr><th>Description</th><th>Path</th><th>Command to open</th></tr></thead><tbody><tr><td>Current user – Current host</td><td>$Home\[My ]Documents\<br>PowerShell\Microsoft.PowerShell_profile.ps1</td><td>$profile</td></tr><tr><td>Current user – <br>All hosts</td><td>$Home\[My ]Documents\<br>PowerShell\Profile.ps1</td><td>$profile.CurrentUserAllHosts<br></td></tr><tr><td>All Users – <br>Current Host</td><td>$PSHOME\Microsoft.PowerShell_profile.ps1</td><td>$profile.AllUsersCurrentHost</td></tr><tr><td>All Users – <br>All Hosts</td><td>$PSHOME\Profile.ps1</td><td>$profile.AllUsersAllHosts</td></tr></tbody></table>

Typically your user profiles are stored at `C:\Users\<username>\Documents\WindowsPowerShell`, by convention your profile is named `Microsoft.PowerShell_profile.ps`, but the name `profile.ps1` will work too. 

You can find the location of your profile from powershell by running: 

```ps1
$profile
```

## How to create your PowerShell Profile

Using PowerShell Profiles can really make your daily work a lot 
easier. You no longer need to navigate to the correct folder to run a 
script that you often use. Or you can create easy-to-use aliases for 
cmdlets that you use often.

The first step in creating your own profile is to test if you already have a profile. Open PowerShell and type:

```ps1
test-path $profile
```

If it returns False, then we need to create the profile first, type:

```ps1
New-Item -Path $profile -Type File -Force
```

To edit your new profile execute: 

```ps1
ise $profile
```

This will open ISE to edit your powershell profile. If you'd prefer, you can open it in any text editor. 

# My Profile 

```ps1
$shell = $Host.UI.RawUI

$shell.WindowTitle = "wchesley"

$PSStyle.Background.Black
$PSStyle.Foreground.Green

## Customize the prompt for admin or regular user: 
function prompt {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    $prefix = if (Test-Path variable:/PSDebugContext) { '[DBG]: ' } else { '' }
    if ($principal.IsInRole($adminRole)) {
        $prefix = "[ADMIN]:$prefix"
    }
    $body = 'PS ' + $PWD.path
    $suffix = $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
    "${prefix}${body}${suffix}"
}

## map grep to case insensitive search: 
function FindStrCaseInsensitive {findstr /I}
Set-Alias -Name grep -Value FindStrCaseInsensitive

## Add argument completer for the dotnet CLI tool
$scriptblock = {
    param($wordToComplete, $commandAst, $cursorPosition)
    dotnet complete --position $cursorPosition $commandAst.ToString() |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $scriptblock

## Set PSReadLine options and keybindings
Set-PSReadLineOption -Colors @{
    Command = 'Cyan'
    Number = 'Yellow'
    Member = 'Green'
    Operator = 'Yellow'
    Type = 'Green'
    Variable = 'Magenta'
    Parameter = 'Magenta'
    ContinuationPrompt = 'DarkGreen'
    Default = 'Green'
    Error = 'DarkRed'
}
(Get-PSReadLineOption).HistoryNoDuplicates = $False
(Get-PSReadLineOption).HistorySearchCaseSensitive = $False
(Get-PSReadLineOption).HistorySearchCursorMovesToEnd = $True
(Get-PSReadLineOption).ShowToolTips = $True
(Get-PSReadLineOption).EditMode = "Vi"

$env:path += ";C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools"

Set-Alias which Get-Command
Set-Alias touch New-Item
Set-Alias Invoke-WebRequest curl.exe
```