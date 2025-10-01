<#
.SYNOPSIS
    Moves a file from one location to another in an idempotent manner.

.DESCRIPTION
    This script moves a file from the source path to the destination path.
    If the source file does not exist, or if the destination file already exists,
    the operation is skipped to avoid overwriting or losing data.

.PARAMETER SourcePath
    The full path to the source file to be moved.

.PARAMETER DestinationPath
    The full path to the destination location where the file should be moved.

.EXAMPLE
    .\move_file.ps1 -SourcePath "C:\Source\file.txt" -DestinationPath "C:\Destination\file.txt"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [string]$DestinationPath
)

function Move-FileIdempotent {
    param(
        [string]$Source,
        [string]$Destination
    )

    try {
        if (-not (Test-Path -Path $Source -PathType Leaf)) {
            Write-Host "Source file does not exist: $Source"
            return
        }

        if (Test-Path -Path $Destination -PathType Leaf) {
            Write-Host "Destination file already exists: $Destination"
            return
        }

        $destinationDir = Split-Path -Path $Destination -Parent
        if (-not (Test-Path -Path $destinationDir)) {
            New-Item -Path $destinationDir -ItemType Directory -Force | Out-Null
        }

        Move-Item -Path $Source -Destination $Destination -ErrorAction Stop
        Write-Host "File moved successfully from '$Source' to '$Destination'."
    }
    catch {
        Write-Error "Error moving file: $_"
        exit 1
    }
}

Move-FileIdempotent -Source $SourcePath -Destination $DestinationPath
# SIG # Begin signature block
# MIIHXAYJKoZIhvcNAQcCoIIHTTCCB0kCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDIs0IL+NOcfvU5
# pI2NYzOzH0rqnkPdqnL3+sHTMuNG8qCCBKQwggSgMIIDiKADAgECAhNCAAAAR1OX
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgbbGj
# WfacuYODRG/wtrWChpfuPzBrNL9Eb5nL9bInZ1IwDQYJKoZIhvcNAQEBBQAEggEA
# 1KK3i+rd4gE7ilb8okKzfe8k5Jku5IJyD9AZuDApQCUzOUn1mdr/KJOYENuwWe3L
# +RDEJp/a5lshmAxAoQW/ZFnn5H23JM5efJwOp+Mm7Oc/ckBDJyQ8YYaCzqxTzkh7
# S5GB8PIApMMWXa8PuqXJRuq5yiy9Mff/B6L4guNiTBVlyJND2u32GjBZPXXTZXH2
# 9lb6DKmVLPILNd/impsD4ghcTXfBN7eViYfZ0mckr3MHQg8shQpE1zZbEkBIrQRq
# gvl018kGRaW2MjpJmqVGU4IXnaDYe9IdtLRb3/1+32jD7gUH1yDkS//y/xDpWd7z
# WCJqXxCTu2QYEOpATFhKOA==
# SIG # End signature block
