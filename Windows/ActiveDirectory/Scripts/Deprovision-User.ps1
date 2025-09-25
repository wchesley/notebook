<#
.SYNOPSIS
    Deprovisions a user in Active Directory.
.DESCRIPTION
    This script is used to safely deprovision an Active Directory user. It finds a user based on their display name,
    prompts for confirmation, and then performs the following actions:
    1. Disables the user account.
    2. Removes the user from all security and distribution groups.
    3. Clears sensitive attributes (manager, mobile phone).
    4. Updates the description field with deprovisioning information.
    5. (optional) Moves the user to a specified OU for disabled users.
    6. (optional) Deletes the user from Active Directory.

    The script is designed to be idempotent; running it multiple times on the same user will not cause errors.
    It performs a forest-wide search across all catalogs and allows for individual user selection if multiple users are found.
    The script will skip secondary DC's provided the name scheme for all DC's is consistent (i.e., DC1, DC2, etc.). The DC only needs to contain 'DC2' to be excluded from the search.
.PARAMETER DisplayName
    The full display name of the user you want to deprovision. This parameter is mandatory.
.PARAMETER DisabledUsersOU
    The distinguished name of the Organizational Unit where disabled users will be moved.
    If not specified, the script will not move the user.
.PARAMETER DeleteUser
    If this switch is provided, the user will be deleted from Active Directory after deprovisioning.
    Use with caution as this action is irreversible.
.EXAMPLE
    .\Deprovision-ADUser.ps1 -DisplayName "John Doe"

    This command will search the entire forest for the user with the display name "John Doe", prompt for confirmation, 
    and if confirmed, will proceed with the deprovisioning process without moving the user to a new OU.
.EXAMPLE
    .\Deprovision-ADUser.ps1 -DisplayName "Jane Smith" -DisabledUsersOU "OU=Disabled Users,DC=corp,DC=contoso,DC=com"

    This command will find "Jane Smith" in the forest and, after confirmation, perform all deprovisioning steps, including
    moving the user object to the "Disabled Users" OU in the corp.contoso.com domain.
.EXAMPLE
    .\Deprovision-ADUser.ps1 -DisplayName "Alice Johnson" -DeleteUser

    This command will find "Alice Johnson" in the forest and, after confirmation, perform all deprovisioning steps and then delete the user from Active Directory.
.NOTES
    Author: Walker Chesley
    Date: 2025-09-24
    Requires the Active Directory module for PowerShell (part of RSAT).
    Run this script with an account that has permissions to modify AD user objects.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Enter the display name of the user to deprovision.")]
    [ValidateNotNullOrEmpty()]
    [string]$DisplayName,

    [Parameter(Mandatory = $false, HelpMessage = "Enter the Distinguished Name of the OU for disabled users.")]
    [string]$DisabledUsersOU,

    [Parameter(Mandatory = $false, HelpMessage = "Delete user from AD after deprovisioning. This action is irreversible.")]
    [switch]$DeleteUser
)

#-------------------------- [Initialisations] -------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'

# Import Modules:
Import-Module ActiveDirectory -ErrorAction Stop

# this path will need to be updated to the modules path on your machine. by default it's using the module folder relative to this script as it exists within this repository: 
Import-Module "$PSScriptRoot\..\..\Development\Scripts\PowerShell\Modules\Show-ProgressBar\Show-ProgressBar.psm1" -ErrorAction Stop
#--------------------------- [Declarations] ---------------------------

# Global Variables: 
# Example: $varName = "Value"

# Trap Error & Exit: 
trap { "Error found: $_"; break; }

#---------------------------- [Functions] -----------------------------

# --- Helper Function ---
function Show-UserInfo {
    <#
    .SYNOPSIS
        Displays key information about an AD user.
    .DESCRIPTION
        This function takes an AD user object and displays important attributes in a readable format.
    .PARAMETER user
        The AD user object to display information for.
    .EXAMPLE
        Show-UserInfo -user $adUser
        Displays information about the specified AD user.
    .NOTES
        Author: Walker Chesley
        Date: 2025-09-24
        Requires the Active Directory module for PowerShell (part of RSAT).
    #>
    param($user)
    
    $userInfo = [PSCustomObject]@{
        'Display Name'        = $user.DisplayName
        'Logon Name'          = $user.SamAccountName
        'User Principal Name' = $user.UserPrincipalName
        'Enabled'             = $user.Enabled
        'Current OU'          = $user.DistinguishedName
    }
    
    $userInfo | Format-List
}

#---------------------------- [Main Script] ---------------------------
# --- Main Script Body ---
try {
    # Check if the Active Directory module is available
    if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
        throw "Active Directory module not found. Please install the Remote Server Administration Tools (RSAT)."
    }

    # --- Find the User (Forest-Wide Search) ---
    Write-Host "Searching for user '$DisplayName' in the Active Directory forest..." -ForegroundColor Cyan
    $ForestGC = (Get-ADForest).GlobalCatalogs | Where-Object { $_ -ne $null -and ($_ -notlike "*DC2*") } # Exclude all secondary DC's as this results in duplicates in search. 
    if (-not $ForestGC -or $ForestGC.Count -eq 0) {
        throw "Could not find a Global Catalog server in the forest. Cannot perform a forest-wide search."
    }

    $adUsers = New-Object System.Collections.Generic.List[PSObject]
    $catalogCount = $ForestGC.Count
    foreach ($gc in $ForestGC) {
        try {
            $progressPercentage = [double]($ForestGC.IndexOf($gc) / $catalogCount)
            $progressBar = Show-ProgressBar -Progress $progressPercentage -Width 10
            $gcString = $gc.ToString()
            if($gcString.EndsWith("autoinc.local")) {
                $gcPrintName = $gcString.Split(".")[1]
            }
            $progressStatus = "{0} {1}/{2} Searching: {3}`n" -f $progressBar, ($ForestGC.IndexOf($gc) + 1), $catalogCount, $gcPrintName
            # Clear console for cleaner progress bar display: 
            Write-Output "$([char]27)[H$([char]27)[2J"
            Write-Host "`r$progressStatus" -NoNewline
            
            $users = Get-ADUser -Filter "DisplayName -like '*$DisplayName*'" -Server $gcString -Properties DisplayName, SamAccountName, UserPrincipalName, DistinguishedName, Enabled, Description, MemberOf, Manager, mobile
            if ($users) {
                
                if ($users -is [array]) {
                    $adUsers.AddRange($users)
                }
                else {
                    $adUsers.Add($users)
                }
            }
        }
        catch {
            Write-Warning "Failed to query global catalog server $gc. Error: $_"
        }
    }
    
    if ($null -eq $adUsers) {
        throw "Error: No user found with the display name '$DisplayName' in the forest."
    }

    $selectedUser = $null

    # --- User Selection Logic ---
    if ($adUsers.Count -eq 0) {
        throw "Error: No user found with the display name '$DisplayName' in the forest."
    }
    if ($adUsers.Count -eq 1) {
        $selectedUser = $adUsers[0]
    }
    elseif ($adUsers.Count -gt 1) {
        Write-Host "Multiple users found. Please select the correct user to deprovision:" -ForegroundColor Yellow
        $i = 1
        $adUsers | ForEach-Object {
            Write-Host "[$i] DisplayName: $($_.DisplayName), UPN: $($_.UserPrincipalName), DN: $($_.DistinguishedName)"
            $i++
        }

        while ($true) {
            $choice = Read-Host "Enter the number of the user to deprovision (or 'q' to quit)"
            if ($choice -eq 'q') {
                Write-Host "Operation cancelled by the user." -ForegroundColor Yellow
                return
            }
            if (($choice -as [int]) -and ($choice -ge 1) -and ($choice -le $adUsers.Count)) {
                $selectedUser = $adUsers[$choice - 1]
                break
            }
            else {
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            }
        }
    }
    
    # --- Confirmation Step ---
    Write-Host "User selected. Please verify the details below:" -ForegroundColor Green
    Show-UserInfo($selectedUser)

    $confirmation = Read-Host "Are you sure you want to deprovision this user? (y/n)"
    if ($confirmation.ToLower() -ne 'y') {
        Write-Host "Operation cancelled by the user." -ForegroundColor Yellow
        return
    }

    # --- Deprovisioning Process ---
    Write-Host "Starting deprovisioning process for $($selectedUser.SamAccountName)..." -ForegroundColor Cyan

    # 1. Disable the account (Idempotent Check)
    if ($selectedUser.Enabled) {
        if ($PSCmdlet.ShouldProcess($selectedUser.DistinguishedName, "Disable Account")) {
            Disable-ADAccount -Identity $selectedUser
            Write-Host "[SUCCESS] User account has been disabled." -ForegroundColor Green
        }
    }
    else {
        Write-Host "[SKIPPED] User account is already disabled." -ForegroundColor Yellow
    }

    # 2. Remove from groups (Idempotent Check)
    $groups = Get-ADUser -Identity $selectedUser -Properties MemberOf | Select-Object -ExpandProperty MemberOf
    if ($groups.Count -gt 0) {
        Write-Host "Removing user from all groups..." -ForegroundColor Cyan
        foreach ($groupDN in $groups) {
            # The Primary Group cannot be removed directly and will cause an error.
            $group = Get-ADGroup $groupDN
            if ($group.GroupCategory -eq "Security" -and $group.Name -eq "Domain Users") {
                Write-Host "[SKIPPED] Skipping primary group 'Domain Users'." -ForegroundColor DarkGray
                continue
            }

            if ($PSCmdlet.ShouldProcess($groupDN, "Remove user from group")) {
                Remove-ADGroupMember -Identity $groupDN -Members $selectedUser -Confirm:$false
                Write-Host " - Removed from: $groupDN"
            }
        }
        Write-Host "[SUCCESS] User removed from all non-primary groups." -ForegroundColor Green
    }
    else {
        Write-Host "[SKIPPED] User is not a member of any groups." -ForegroundColor Yellow
    }

    # 3. Update description
    $deprovisionDate = Get-Date -Format "yyyy-MM-dd HH:mm"
    $newDescription = "DEPROVISIONED on $deprovisionDate. Original Description: $($selectedUser.Description)"
    if ($selectedUser.Description -notlike "DEPROVISIONED*") {
        if ($PSCmdlet.ShouldProcess($selectedUser.DistinguishedName, "Update Description to '$newDescription'")) {
            Set-ADUser -Identity $selectedUser -Description $newDescription
            Write-Host "[SUCCESS] User description has been updated." -ForegroundColor Green
        }
    }
    else {
        Write-Host "[SKIPPED] User description already contains deprovisioning info." -ForegroundColor Yellow
    }


    # 4. Clear sensitive attributes
    if ($selectedUser.Manager -or $selectedUser.mobile) {
        if ($PSCmdlet.ShouldProcess($selectedUser.DistinguishedName, "Clear Manager and Mobile attributes")) {
            Set-ADUser -Identity $selectedUser -Clear Manager, mobile
            Write-Host "[SUCCESS] Cleared manager and mobile attributes." -ForegroundColor Green
        }
    }
    else {
        Write-Host "[SKIPPED] Manager and mobile attributes are already clear." -ForegroundColor Yellow
    }


    # 5. Move to Disabled Users OU
    if (-not ([string]::IsNullOrEmpty($DisabledUsersOU))) {
        # First, check if the OU exists
        if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$DisabledUsersOU'")) {
            Write-Warning "The specified DisabledUsersOU does not exist: $DisabledUsersOU. Skipping move operation."
        }
        else {
            if ($selectedUser.DistinguishedName -notlike "*$DisabledUsersOU") {
                if ($PSCmdlet.ShouldProcess($selectedUser.DistinguishedName, "Move to OU '$DisabledUsersOU'")) {
                    Move-ADObject -Identity $selectedUser -TargetPath $DisabledUsersOU
                    Write-Host "[SUCCESS] User has been moved to the '$DisabledUsersOU' OU." -ForegroundColor Green
                }
            }
            else {
                Write-Host "[SKIPPED] User is already in the target OU." -ForegroundColor Yellow
            }
        }
    }
    else {
        Write-Host "[INFO] No -DisabledUsersOU specified. Skipping move operation." -ForegroundColor DarkGray
    }

    # 6. Delete User (if specified) - Irreversible Action
    if ($PSCmdlet.ShouldProcess("$selectedUser", "Delete User from AD. This action is irreversible.")) {
        $confirmDelete = Read-Host "Are you absolutely sure you want to delete this user? This action cannot be undone. (y/n)"
        if ($confirmDelete -eq 'y') {
            Remove-ADUser -Identity $selectedUser -Confirm:$false
            Write-Host "[SUCCESS] User has been deleted." -ForegroundColor Green
        }
        else {
            Write-Host "User deletion cancelled by the user." -ForegroundColor Yellow
        }
    }
    

    Write-Host "Deprovisioning process completed successfully." -ForegroundColor Green
}
catch {
    # Catch any terminating errors and display them in red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}




# SIG # Begin signature block
# MIIdwAYJKoZIhvcNAQcCoIIdsTCCHa0CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCqX81goxh7XSB9
# QlQw8m+sEGPl7PvH8VlCsLnbc69UnqCCF94wggSgMIIDiKADAgECAhNCAAAAR1OX
# TCWdlVi/AAAAAABHMA0GCSqGSIb3DQEBCwUAMEUxFTATBgoJkiaJk/IsZAEZFgVs
# b2NhbDEXMBUGCgmSJomT8ixkARkWB2F1dG9pbmMxEzARBgNVBAMTCkFJLUNFUlQt
# Q0EwHhcNMjUwODE1MTUxNzU5WhcNMjYwODE1MTUxNzU5WjAeMRwwGgYDVQQDDBMk
# YXV0b2luY3NpZ25pbmdjZXJ0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEA6y2GbaUXh5fj5p9tChB9tkTfoUrflAfjqJb2WNaMtyRejcpCzlJLF1OUk1x9
# n+zdyNNdHW+B2IKHmWNaANOshYxoFhFIypWI36og+dn4PQ/7ogpfSCw1oe3mni6b
# JqwCvOCmqM+CKsV69e4eOtdMhWHBWVk2pLgg0Y5Doj1mouCK4vKx4I15J8xyC9YG
# DCUU5WvLrKKujMBDMhrTJM4kE0BzLAaP3eIUAhx4UXKBN1tBWiHj2YjIcjK1T0d4
# TPbA7TFOfT2Ltr5NmhTvqWyBNv18ZGt3kye0JEiV/T+oWs9v50eqjv0ct1BTT+4z
# 8HV1FGjOtj2Tmj6UUpWQNei27QIDAQABo4IBrjCCAaowPAYJKwYBBAGCNxUHBC8w
# LQYlKwYBBAGCNxUIg8TbPYGguhOC9YUhhoyvQvmlUYFLh4+gFu7AHwIBZAIBAzAT
# BgNVHSUEDDAKBggrBgEFBQcDAzAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIw
# ADAbBgkrBgEEAYI3FQoEDjAMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRq+KMA/23i
# sZevf+72ZLmB+Yy1KzAfBgNVHSMEGDAWgBTHnjJY0XmXxQw6r+gikzKxZe++azBz
# BgNVHR8EbDBqMGigZqBkhjNodHRwOi8vcGtpLmFpLWNlcnQuYXV0b2luYy5sb2Nh
# bC9wa2kvQUktQ0VSVC1DQS5jcmyGLWh0dHA6Ly9wa2kuYWktY2VydC5hdXRvaW5j
# LmNvbS9BSS1DRVJULUNBLmNybDBlBggrBgEFBQcBAQRZMFcwVQYIKwYBBQUHMAKG
# SWh0dHA6Ly9wa2kuYWktY2VydC5hdXRvaW5jLmxvY2FsL3BraS9BSS1DZXJ0LmF1
# dG9pbmMubG9jYWxfQUktQ0VSVC1DQS5jcnQwDQYJKoZIhvcNAQELBQADggEBAHVs
# MY5kVqX64RH+TzI2PCmI+StzwvuQ+nHcRICvPWnaSmti9tCkMScCTG2LLgvNiZMZ
# bR5digH7S6n1kabELDYyxUQ4jjmk+gAwsoYu/KhnBcKjaS0e7Jv/yTt0OMqn2AUn
# V45/uv62wyl8WDvosybsLMJIsIv2u/JLQbKwg05Hu97SMD9zIvoZ7mbSiZAQ2DXZ
# rWDO6KhGV0xGycUyY92hmG+KFdf/UGLKzB4bNRHQoKMtGnUulq/flv9Tjzc6oEdx
# 0gPGoL2IxnMrKElCleUZX011lkSLgGfIz3EESaCEYqDCCepXxKrpTHuK/ihg6KOJ
# 1pv/gHje63ULkTyFI8UwggWNMIIEdaADAgECAhAOmxiO+dAt5+/bUOIIQBhaMA0G
# CSqGSIb3DQEBDAUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0
# IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yMjA4MDEwMDAwMDBaFw0zMTExMDkyMzU5
# NTlaMGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQg
# Um9vdCBHNDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAL/mkHNo3rvk
# XUo8MCIwaTPswqclLskhPfKK2FnC4SmnPVirdprNrnsbhA3EMB/zG6Q4FutWxpdt
# HauyefLKEdLkX9YFPFIPUh/GnhWlfr6fqVcWWVVyr2iTcMKyunWZanMylNEQRBAu
# 34LzB4TmdDttceItDBvuINXJIB1jKS3O7F5OyJP4IWGbNOsFxl7sWxq868nPzaw0
# QF+xembud8hIqGZXV59UWI4MK7dPpzDZVu7Ke13jrclPXuU15zHL2pNe3I6PgNq2
# kZhAkHnDeMe2scS1ahg4AxCN2NQ3pC4FfYj1gj4QkXCrVYJBMtfbBHMqbpEBfCFM
# 1LyuGwN1XXhm2ToxRJozQL8I11pJpMLmqaBn3aQnvKFPObURWBf3JFxGj2T3wWmI
# dph2PVldQnaHiZdpekjw4KISG2aadMreSx7nDmOu5tTvkpI6nj3cAORFJYm2mkQZ
# K37AlLTSYW3rM9nF30sEAMx9HJXDj/chsrIRt7t/8tWMcCxBYKqxYxhElRp2Yn72
# gLD76GSmM9GJB+G9t+ZDpBi4pncB4Q+UDCEdslQpJYls5Q5SUUd0viastkF13nqs
# X40/ybzTQRESW+UQUOsxxcpyFiIJ33xMdT9j7CFfxCBRa2+xq4aLT8LWRV+dIPyh
# HsXAj6KxfgommfXkaS+YHS312amyHeUbAgMBAAGjggE6MIIBNjAPBgNVHRMBAf8E
# BTADAQH/MB0GA1UdDgQWBBTs1+OC0nFdZEzfLmc/57qYrhwPTzAfBgNVHSMEGDAW
# gBRF66Kv9JLLgjEtUYunpyGd823IDzAOBgNVHQ8BAf8EBAMCAYYweQYIKwYBBQUH
# AQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYI
# KwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAE
# CjAIMAYGBFUdIAAwDQYJKoZIhvcNAQEMBQADggEBAHCgv0NcVec4X6CjdBs9thbX
# 979XB72arKGHLOyFXqkauyL4hxppVCLtpIh3bb0aFPQTSnovLbc47/T/gLn4offy
# ct4kvFIDyE7QKt76LVbP+fT3rDB6mouyXtTP0UNEm0Mh65ZyoUi0mcudT6cGAxN3
# J0TU53/oWajwvy8LpunyNDzs9wPHh6jSTEAZNUZqaVSwuKFWjuyk1T3osdz9HNj0
# d1pcVIxv76FQPfx2CWiEn2/K2yCNNWAcAgPLILCsWKAOQGPFmCLBsln1VWvPJ6ts
# ds5vIy30fnFqI2si/xK4VC0nftg62fC2h5b9W9FcrBjDTZ9ztwGpn1eqXijiuZQw
# gga0MIIEnKADAgECAhANx6xXBf8hmS5AQyIMOkmGMA0GCSqGSIb3DQEBCwUAMGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBH
# NDAeFw0yNTA1MDcwMDAwMDBaFw0zODAxMTQyMzU5NTlaMGkxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1
# c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEyNTYgMjAyNSBDQTEwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC0eDHTCphBcr48RsAcrHXbo0Zo
# dLRRF51NrY0NlLWZloMsVO1DahGPNRcybEKq+RuwOnPhof6pvF4uGjwjqNjfEvUi
# 6wuim5bap+0lgloM2zX4kftn5B1IpYzTqpyFQ/4Bt0mAxAHeHYNnQxqXmRinvuNg
# xVBdJkf77S2uPoCj7GH8BLuxBG5AvftBdsOECS1UkxBvMgEdgkFiDNYiOTx4OtiF
# cMSkqTtF2hfQz3zQSku2Ws3IfDReb6e3mmdglTcaarps0wjUjsZvkgFkriK9tUKJ
# m/s80FiocSk1VYLZlDwFt+cVFBURJg6zMUjZa/zbCclF83bRVFLeGkuAhHiGPMvS
# GmhgaTzVyhYn4p0+8y9oHRaQT/aofEnS5xLrfxnGpTXiUOeSLsJygoLPp66bkDX1
# ZlAeSpQl92QOMeRxykvq6gbylsXQskBBBnGy3tW/AMOMCZIVNSaz7BX8VtYGqLt9
# MmeOreGPRdtBx3yGOP+rx3rKWDEJlIqLXvJWnY0v5ydPpOjL6s36czwzsucuoKs7
# Yk/ehb//Wx+5kMqIMRvUBDx6z1ev+7psNOdgJMoiwOrUG2ZdSoQbU2rMkpLiQ6bG
# RinZbI4OLu9BMIFm1UUl9VnePs6BaaeEWvjJSjNm2qA+sdFUeEY0qVjPKOWug/G6
# X5uAiynM7Bu2ayBjUwIDAQABo4IBXTCCAVkwEgYDVR0TAQH/BAgwBgEB/wIBADAd
# BgNVHQ4EFgQU729TSunkBnx6yuKQVvYv1Ensy04wHwYDVR0jBBgwFoAU7NfjgtJx
# XWRM3y5nP+e6mK4cD08wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUF
# BwMIMHcGCCsGAQUFBwEBBGswaTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGln
# aWNlcnQuY29tMEEGCCsGAQUFBzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5j
# b20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJo
# dHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNy
# bDAgBgNVHSAEGTAXMAgGBmeBDAEEAjALBglghkgBhv1sBwEwDQYJKoZIhvcNAQEL
# BQADggIBABfO+xaAHP4HPRF2cTC9vgvItTSmf83Qh8WIGjB/T8ObXAZz8OjuhUxj
# aaFdleMM0lBryPTQM2qEJPe36zwbSI/mS83afsl3YTj+IQhQE7jU/kXjjytJgnn0
# hvrV6hqWGd3rLAUt6vJy9lMDPjTLxLgXf9r5nWMQwr8Myb9rEVKChHyfpzee5kH0
# F8HABBgr0UdqirZ7bowe9Vj2AIMD8liyrukZ2iA/wdG2th9y1IsA0QF8dTXqvcnT
# mpfeQh35k5zOCPmSNq1UH410ANVko43+Cdmu4y81hjajV/gxdEkMx1NKU4uHQcKf
# ZxAvBAKqMVuqte69M9J6A47OvgRaPs+2ykgcGV00TYr2Lr3ty9qIijanrUR3anzE
# wlvzZiiyfTPjLbnFRsjsYg39OlV8cipDoq7+qNNjqFzeGxcytL5TTLL4ZaoBdqbh
# OhZ3ZRDUphPvSRmMThi0vw9vODRzW6AxnJll38F0cuJG7uEBYTptMSbhdhGQDpOX
# gpIUsWTjd6xpR6oaQf/DJbg3s6KCLPAlZ66RzIg9sC+NJpud/v4+7RWsWCiKi9EO
# LLHfMR2ZyJ/+xhCx9yHbxtl5TPau1j/1MIDpMPx0LckTetiSuEtQvLsNz3Qbp7wG
# WqbIiOWCnb5WqxL3/BAPvIXKUjPSxyZsq8WhbaM2tszWkPZPubdcMIIG7TCCBNWg
# AwIBAgIQCoDvGEuN8QWC0cR2p5V0aDANBgkqhkiG9w0BAQsFADBpMQswCQYDVQQG
# EwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xQTA/BgNVBAMTOERpZ2lDZXJ0
# IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQwOTYgU0hBMjU2IDIwMjUgQ0Ex
# MB4XDTI1MDYwNDAwMDAwMFoXDTM2MDkwMzIzNTk1OVowYzELMAkGA1UEBhMCVVMx
# FzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBTSEEy
# NTYgUlNBNDA5NiBUaW1lc3RhbXAgUmVzcG9uZGVyIDIwMjUgMTCCAiIwDQYJKoZI
# hvcNAQEBBQADggIPADCCAgoCggIBANBGrC0Sxp7Q6q5gVrMrV7pvUf+GcAoB38o3
# zBlCMGMyqJnfFNZx+wvA69HFTBdwbHwBSOeLpvPnZ8ZN+vo8dE2/pPvOx/Vj8Tch
# TySA2R4QKpVD7dvNZh6wW2R6kSu9RJt/4QhguSssp3qome7MrxVyfQO9sMx6ZAWj
# FDYOzDi8SOhPUWlLnh00Cll8pjrUcCV3K3E0zz09ldQ//nBZZREr4h/GI6Dxb2Uo
# yrN0ijtUDVHRXdmncOOMA3CoB/iUSROUINDT98oksouTMYFOnHoRh6+86Ltc5zjP
# KHW5KqCvpSduSwhwUmotuQhcg9tw2YD3w6ySSSu+3qU8DD+nigNJFmt6LAHvH3KS
# uNLoZLc1Hf2JNMVL4Q1OpbybpMe46YceNA0LfNsnqcnpJeItK/DhKbPxTTuGoX7w
# JNdoRORVbPR1VVnDuSeHVZlc4seAO+6d2sC26/PQPdP51ho1zBp+xUIZkpSFA8vW
# doUoHLWnqWU3dCCyFG1roSrgHjSHlq8xymLnjCbSLZ49kPmk8iyyizNDIXj//cOg
# rY7rlRyTlaCCfw7aSUROwnu7zER6EaJ+AliL7ojTdS5PWPsWeupWs7NpChUk555K
# 096V1hE0yZIXe+giAwW00aHzrDchIc2bQhpp0IoKRR7YufAkprxMiXAJQ1XCmnCf
# gPf8+3mnAgMBAAGjggGVMIIBkTAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBTkO/zy
# Me39/dfzkXFjGVBDz2GM6DAfBgNVHSMEGDAWgBTvb1NK6eQGfHrK4pBW9i/USezL
# TjAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwgZUGCCsG
# AQUFBwEBBIGIMIGFMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wXQYIKwYBBQUHMAKGUWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFRydXN0ZWRHNFRpbWVTdGFtcGluZ1JTQTQwOTZTSEEyNTYyMDI1Q0ExLmNy
# dDBfBgNVHR8EWDBWMFSgUqBQhk5odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGln
# aUNlcnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdSU0E0MDk2U0hBMjU2MjAyNUNBMS5j
# cmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEB
# CwUAA4ICAQBlKq3xHCcEua5gQezRCESeY0ByIfjk9iJP2zWLpQq1b4URGnwWBdEZ
# D9gBq9fNaNmFj6Eh8/YmRDfxT7C0k8FUFqNh+tshgb4O6Lgjg8K8elC4+oWCqnU/
# ML9lFfim8/9yJmZSe2F8AQ/UdKFOtj7YMTmqPO9mzskgiC3QYIUP2S3HQvHG1FDu
# +WUqW4daIqToXFE/JQ/EABgfZXLWU0ziTN6R3ygQBHMUBaB5bdrPbF6MRYs03h4o
# bEMnxYOX8VBRKe1uNnzQVTeLni2nHkX/QqvXnNb+YkDFkxUGtMTaiLR9wjxUxu2h
# ECZpqyU1d0IbX6Wq8/gVutDojBIFeRlqAcuEVT0cKsb+zJNEsuEB7O7/cuvTQasn
# M9AWcIQfVjnzrvwiCZ85EE8LUkqRhoS3Y50OHgaY7T/lwd6UArb+BOVAkg2oOvol
# /DJgddJ35XTxfUlQ+8Hggt8l2Yv7roancJIFcbojBcxlRcGG0LIhp6GvReQGgMgY
# xQbV1S3CrWqZzBt1R9xJgKf47CdxVRd/ndUlQ05oxYy2zRWVFjF7mcr4C34Mj3oc
# CVccAvlKV9jEnstrniLvUxxVZE/rptb7IRE2lskKPIJgbaP5t2nGj/ULLi49xTcB
# ZU8atufk+EMF/cWuiC7POGT75qaL6vdCvHlshtjdNXOCIUjsarfNZzGCBTgwggU0
# AgEBMFwwRTEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRcwFQYKCZImiZPyLGQBGRYH
# YXV0b2luYzETMBEGA1UEAxMKQUktQ0VSVC1DQQITQgAAAEdTl0wlnZVYvwAAAAAA
# RzANBglghkgBZQMEAgEFAKCBhDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMC8GCSqGSIb3DQEJBDEiBCDA/PJPOo1WkMkSxQtJruFZcq3fn18gGQQ3
# jVxQapUaPzANBgkqhkiG9w0BAQEFAASCAQChGXiDhR+7t9GdJ4OJxYvu0nE+nJ5L
# TTa2QGbBeHAx5XJJzGADsdYmEc2exKarCZPymsdYXXh85rs/zQdYTWhjC+2k2TBb
# cWNGsR+mgOt3cfcplaOMrLec082kU308LWpwgn8669q7qHH+Esxq4FdbyNp1RcYE
# osHnobAqY1/JNQdZUQt382YElTr3qYsY2D6kUaZ7LgH0WqFQFUGxfnvjE1d9dKs5
# kdDjeaw9CmMOaGenWG7dwwIhPJOE/+JNy4G5/LFYKxsnfrFcmT7PlRUm2+lAmXnd
# 5W5WHGrwmaufz30g4gywJcpJa/IB/An2FLeRP/alvek4gqx6CJadFOfPoYIDJjCC
# AyIGCSqGSIb3DQEJBjGCAxMwggMPAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNV
# BAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0
# IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1IENBMQIQCoDvGEuN8QWC
# 0cR2p5V0aDANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
# BwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkyNTEzMzUwN1owLwYJKoZIhvcNAQkEMSIE
# ILrvkFpZE+UPfHQT/vCEPMdRF/3L4pNzjMhPWdvUnncfMA0GCSqGSIb3DQEBAQUA
# BIICALz+mKOOq5PlFwKg7+YBoaEUTxlAelnwUlGAnsKcilt3GSStNxPqdf69OYrz
# qAYDUkXJCrj2Pb4KEOB4VkHkki8ZLO/I2VRSXJ5Pbag32Hno9Zs0hqmygeQ/+MGJ
# AQQglYtCagecNg7Payg6peMxF2sKRf1/jOuvEVeV0y3E0QoBpTO32S8RB2Scg2Gp
# vSiqmqdz8ChOVvzSGZ0VsGE1RUcS04j/E9yLETVdgTODnnzqfD+iWrymnDUtqRQS
# 4saV6yuBsawxeR3pXGeb0yB+8+VwF1MdZ92wvtuunea2wcFIer+U1rhL1z5NxO+m
# 1bFHDt5oM0uJ5WL1VCbdQnxBd7zHothcpLJPvhtWJUXEMXzVANtBdqJVh56kOVtZ
# 3uA88vM12K78culH9UlxieCDkhLn2zx9K7i5AvoOie9SvfpHC0kBfwZKFjbLHWfx
# UyPpU3Dk9/+NdP+s2OoGWdhoxSUylnhz1w5xBSjANwr81i43DJSXJ560zaig8Tsn
# RTDYfA+cFbo4n2qc9BMBHqtKMWFMqnfcwlMCKaXruNqpRms3F16fHCAMWWy+Qygy
# Q/XxM3e0DuW+jamJTxPqgi0uxbmKuD7HL1UtMXnad/Yz8f7Iq1Ht5J5CS8b/Dybm
# h6RmoZyGg21T5eG0ELhozJB5RxI+mmVDmuK+1ZKJ98OsEZ2n
# SIG # End signature block
