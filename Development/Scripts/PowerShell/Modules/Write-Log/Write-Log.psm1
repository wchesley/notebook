<#
.SYNOPSIS
    Log messages with standardized formatting and severity levels.

.DESCRIPTION
    This function logs messages with a standardized format, including a timestamp and severity level.
    Supports Information, Warning, and Error levels if no severity level is given then stdout (Write-Host) is used.

.PARAMETER Message
    The message to log. 
    This parameter is required.
    Aliases: mgs, m

.PARAMETER Level
    The severity level of the message. 
    Defaults to "Verbose" which writes to console's host output stream (Write-Host).
    Valid values: "Information", "Info", "Warning", "Warn", "Error", "Err", "Verbose", "v"
    Aliases: lvl, l

.PARAMETER Path
    Optional file path to log messages to a file.
    If provided, the log message will be appended to the specified file.
    Must be full path to a file, not just a directory.
    If the file does not exist, it will be created.
    Alias: p

.EXAMPLE
    Write-Log -Message "This is an informational message." -Level "Information"

    Logs an informational message.

.EXAMPLE
    Write-Log -Message "This is a normal message" 

    Logs a normal message to console's stdout.

.EXAMPLE
    Write-Log -Message "This is a warning message." -Level "Warning" -Path "C:\Logs\app.log"

    Logs a warning message to both the console and appends it to the specified log file.

.OUTPUTS
    User provided message ($Message) preceeded by timestamp and tailored to given severity level ($Level) 

#>
function Write-Log {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias("msg", "m")]
        [string]$Message,

        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateSet("Information", "Warning", "Error", "Verbose")]
        [Alias("lvl", "l")]
        [string]$Level = "Verbose",

        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [Alias("p")]
        [string]$Path
    )

    begin {
        $dateStamp = "[{0}]" -f (Get-Date -Format s)
        $logLine = "$dateStamp - [$Level] - $Message"
    }
    process {
        switch ($Level) {
            "Information" { Write-Information $logLine }
            "Warning" { Write-Warning $logLine }
            "Error" { Write-Error $logLine }
            default { Write-Host $logLine }
        }

        if ($PSBoundParameters.ContainsKey('Path')) {
            try {
                Add-Content -Path $Path -Value $logLine
            }
            catch {
                Write-Error "Failed to write log to file at $Path Error $($_.Exception.Message)"
            }
        }
    }
}

# SIG # Begin signature block
# MIIHXAYJKoZIhvcNAQcCoIIHTTCCB0kCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCMTLyQeXi3vO8w
# 1QXfTo2QtwV7x1Lf+JOOvh5G5zbBYaCCBKQwggSgMIIDiKADAgECAhNCAAAAR1OX
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
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgLV+K
# XjMtLH6hAArf/fh6MBasUICEy3AF7BP6LpYhz80wDQYJKoZIhvcNAQEBBQAEggEA
# qazUKcMw3AJjWgbMzi8QnEwmAt3fQnsDmYAsOqhX/Xm0lczsOLRMVTQjMmcMkuz4
# 7zq/9hwXwgJ4n6lo9tKbEEtYKqwuHX1SQ6mz3dHpJRp30fX5ae5WuDm8f2ciltMZ
# P5nJ+ttqvkj9dWIMaar/GAdLPLdbr9ALNlG9t5O3D+sO8s3XlxVzpr9WbWZY3CJC
# 1sWBQAQhy3gRiDPAw9t97l0dQfQW8tgzqlgpsJ+bG7LUb9zkg+k0FTyidJyC0/yC
# wCckQ9n409VixKRwddTKswy6oTXqPd2wR07RTTOn3+hIeoApEwz08pTUndhVHgNm
# AC8+PyHDrYne7MsG7EM10A==
# SIG # End signature block
