<# 
.SYNOPSIS
    Backup bitlocker keys protector ID's to Microsoft Intune.
.DESCRIPTION
    This script backs up BitLocker keys and their protector IDs to Microsoft 
    Intune for recovery purposes.
.INPUTS
    None
.OUTPUTS
    exit 0: BitLocker key is already backed up or BitLocker is not enabled.
    exit 1: BitLocker key is not backed up, remediation required.
    exit 2: An error occurred while checking the BitLocker key backup status,
    do not remediate.
    Any other exit code indicates an error and intune will show the device 
    as non-compliant and remediations will not run.
.EXAMPLE
    BackupBitLockerKey.ps1
    Backs up BitLocker keys and protector IDs to Microsoft Intune.
.NOTES
    Version: 1.0.4
    Author: Walker Chesley
    Created: 2025-09-16
    Modified: 2025-09-16
    Change Log: 
    - Initial release
#>

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param (
    # Define parameters here
)

#-------------------------- [Initialisations] -------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'

#--------------------------- [Declarations] ---------------------------

# Global Variables: 
[int]$daysSinceLastBackup = 15 # Number of days to check for last backup event

# Trap Error & Exit: 
trap { "Error found: $_"; break; }

#---------------------------- [Functions] -----------------------------

function Get-BitLockerStatus {
    <#
        .SYNOPSIS
            Get the BitLocker status of the specified drive.
        
        .DESCRIPTION
            This function retrieves the BitLocker status of the specified drive 
            and checks if it is enabled and fully encrypted with a recovery password protector.

        .PARAMETER MountPoint
            The drive letter or mount point of the volume to check. Default is the system drive (C:).

        .OUTPUTS
            Returns the BitLocker volume object if BitLocker is enabled and fully encrypted with a recovery password protector.
            Returns $null if BitLocker is not enabled or not fully encrypted.

        .EXAMPLE
            Get-BitLockerStatus -MountPoint "C:"
            Checks the BitLocker status of the C: drive.

        .NOTES
            Run this script as an administrator.
            Requires the BitLocker module, which is included in Windows 10/11 and Windows Server 2016/2019/2022.
            Information and/or References:
                https://learn.microsoft.com/en-us/powershell/module/bitlocker/get-bitlockervolume
    #>
    param (
        [string]$MountPoint = $env:SystemDrive.Substring(0, 2) # Default to C: drive
    )
    
    # Get BitLocker Status
    try {
        $blk = Get-BitLockerVolume -MountPoint $MountPoint -ErrorAction Stop
        if ($blk.ProtectionStatus -eq 'On' -and $blk.VolumeStatus -eq 'FullyEncrypted' -and $blk.KeyProtector.any{ $_.KeyProtectorType -eq 'RecoveryPassword' }) {
            Write-Host "BitLocker is enabled and fully encrypted on $MountPoint drive."
            return $blk
        }
        else {
            Write-Error "BitLocker is not fully enabled or encrypted on $MountPoint drive."
        }
        return $null
    }
    catch {
        Write-Error "Failed to get BitLocker status: $_"
        return $null
    }
}

function Test-AzureADBitLockerBackup {
    <#
    .SYNOPSIS
        Check the BitLocker Management event log for event ID 845 to confirm successful backup of BitLocker key to Azure AD for the system drive.

    .DESCRIPTION
        This function queries the BitLocker Management event log for event ID 845 and checks if the level of the event is "Information". 
        If the event is found and is specifically for the system drive, it means the BitLocker key backup to Azure AD was successful.

    .PARAMETER nDays
        The number of past days to check for the event. The default is 15.

    .OUTPUTS
        Returns int status code to indicate success/failure as follows: 
        Returns 0 if the BitLocker key backup to Azure AD for the system drive was successful in the past nDays.
        Returns 1 if no such event was found in the past nDays.
        Returns 2 if an error occurred while querying the event log.
    
    .NOTES
        This function requires administrator privileges.

        Information and/or References:
            https://techcommunity.microsoft.com/t5/intune-customer-success/using-bitlocker-recovery-keys-with-microsoft-endpoint-manager/ba-p/2255517

    .EXAMPLE
        Test-AzureADBitLockerBackup -nDays 7
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int]
        $nDays = 15
    )

    try {
        # Get the date nDays ago
        $pastDate = (Get-Date).AddDays(-$nDays)

        # Get the system drive from the environment variables
        $systemDrive = $env:SystemDrive

        # Get the BitLocker Management event log events with ID 845 and Level 4 (Information) from the past nDays
        $events = Get-WinEvent -FilterHashTable @{LogName = "Microsoft-Windows-BitLocker/BitLocker Management"; ID = 845; Level = 4; StartTime = $pastDate } -ErrorAction Stop

        # If events exist, check if any of them are for the system drive
        if ($events) {
            foreach ($event in $events) {
                $eventData = [xml]$event.ToXml()
                $volume = $eventData.Event.EventData.Data | Where-Object { $_.Name -eq 'VolumeMountPoint' } | Select-Object -ExpandProperty '#text'
                if ($volume -eq $systemDrive) {
                    Write-Host "BitLocker key backup to Azure AD for the system drive ($systemDrive) was successful in the past $nDays day(s)." -ForegroundColor Green
                    return 0
                }
            }

            Write-Host "No events found in the past $nDays day(s) indicating successful BitLocker key backup to Azure AD for the system drive ($systemDrive)." -ForegroundColor Yellow
            return 1
        }
        else {
            Write-Host "No events found in the past $nDays day(s) indicating successful BitLocker key backup to Azure AD." -ForegroundColor Yellow
            return 1
        }
    }
    catch {
        Write-Host "Failed to query BitLocker Management event log: $_" -ForegroundColor Red
        return 2
    }
}


#---------------------------- [Main Script] ---------------------------
# Main Execution
try {
    $blkStatus = Get-BitLockerStatus
    if ($blkStatus) {
        $backupStatus = Test-AzureADBitLockerBackup -nDays $daysSinceLastBackup
        switch ($backupStatus) {
            0 {
                Write-Host "BitLocker key backup to Azure AD for the system drive last occurred the past $daysSinceLastBackup day(s)."
                exit 0
            }
            1 {
                Write-Host "BitLocker key backup to Azure AD for the system drive was not found."
                exit 1 # remediation required
            }
            2 {
                Write-Host "Failed to check BitLocker key backup status."
                exit 2 # error occurred, do not remediate
            }
            Default {
                Write-Host "Unknown backup status."
                exit 2 # exit 2 to avoid remediation if unknown status, flagging this machine as non-compliant
            }
        }
    }
    else {
        Write-Host "Failed to get BitLocker Status. Please review device manually and enable BitLocker and allow the drive to become fully encrypted before running this remediation again."
        exit 2 # exit 2 to avoid remediation if unknown status, flagging this machine as non-compliant
    }
}
catch {
    # catch any error from script: 
    Write-Error "An error occurred: $_"
    exit 0 # exit 0 to avoid remediation if error occurs
}
finally {
    # always run this code, even in event of error:
    $blkStatus = $null
}
# SIG # Begin signature block
# MIIHXAYJKoZIhvcNAQcCoIIHTTCCB0kCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCUnn+U48NFDk78
# hrgwLfMGNykjzbMXK54kMCFxVl+k+aCCBKQwggSgMIIDiKADAgECAhNCAAAAR1OX
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
# 1pv/gHje63ULkTyFI8UxggIOMIICCgIBATBcMEUxFTATBgoJkiaJk/IsZAEZFgVs
# b2NhbDEXMBUGCgmSJomT8ixkARkWB2F1dG9pbmMxEzARBgNVBAMTCkFJLUNFUlQt
# Q0ECE0IAAABHU5dMJZ2VWL8AAAAAAEcwDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgit/x
# +ieH0Z4vWNc1k7C8A53Vri2anfnxYR86mEDKsJgwDQYJKoZIhvcNAQEBBQAEggEA
# cbka+d93Q1NOu2JFeUJE0QWVX06RpMaGVIbVyPRP7b1PKmRVHifV28RPewSX4H82
# 8cDIjgnHRIddfmvdmfOUjrsbHIZ/QDYD/uloaKHrvpiKKEKsKqNx/qZwdc4JQCu1
# sWCFAHHijjZYDN/kYC0yeIS98DXzkavaUwl5jILex6Z7PqD5d85+dYYmdr22VVWE
# cpY4gEM1Vyyq/i5SlYSkTjD9XiTz9rUAP6clGCZuP5XcrHLUERnxktNkYtoJSrUu
# rnt6wPnWGmr1jaiZFz1s3A0UZGLI1GAJgbeXMxbh1x87XpeRLs1qQ3tscXBHedg/
# CZgv8ozGaOty+cS8bPC7yw==
# SIG # End signature block
