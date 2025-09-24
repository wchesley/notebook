<# 
.SYNOPSIS
    Add quotation marks to unquoted service paths in Windows services.

.DESCRIPTION
    This script checks all Windows services for unquoted service paths and adds quotation marks where necessary. This only affects services with paths containing spaces that are not already quoted.
    This script is designed to run as a Microsoft Intune remediation script. See the accompanying detect.ps1 script for detection.

.INPUTS
    None

.OUTPUTS
    Exit 0: No errors, remediation successful.
    Exit 1: Errors occurred during remediation.

.EXAMPLE
    FixUnquotedServicePaths.ps1
    Scans and fixes unquoted service paths in Windows services.

.NOTES
    Version: 1.1.2
    Author: Walker Chesley
    Created: 2025-09-16
    Modified: 2025-09-16
    Change Log: 
    - Initial release v1.0.0
    - 2025-09-24: Added -WhatIf support and error handling v1.1.0
    - 2025-09-24: Simplified detection logic to better match detect.ps1 v1.1.2
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

# Trap Error & Exit: 
trap { "Error found: $_"; break; }

#---------------------------- [Main Script] ---------------------------

try {
    ## Grab all the registry keys pertinent to services
    $services = Get-WmiObject win32_service | Where-Object {
        $_.PathName -notmatch '^"' -and
        $_.PathName -notmatch 'C:\\Windows' -and
        $_.PathName -match '\s' -and
        $_.PathName -notmatch '"'
    }
    if($services.Count -eq 0) {
        Write-Host "No unquoted service paths detected. Exiting."
        exit 0
    }
    Write-Host "Found $($services.Count) services with unquoted paths. Starting remediatiation..."
    foreach ($svc in $services) {
        $name = $svc.Name
        $path = $svc.PathName

        # Only quote the executable path, not arguments
        if ($path -match '^[^"]+\.exe\b') {
            $exe = $Matches[0]
            $args = $path.Substring($exe.Length).Trim()
            $newPath = "`"$exe`""
            if ($args) { $newPath += " $args" }
        }
        else {
            $newPath = "`"$path`""
        }

        try {
            if ($PSCmdlet.ShouldProcess("$name", "Set quotes around service path")) {
                sc.exe config $name binPath= "$newPath"
                Write-Host "Remediated service: $name, new path: $newPath"
            }
        }
        catch {
            Write-Host "Failed to remediate service: $name"
            exit 1
        }
    }
    exit 0
}
catch {
    # catch any error from script: 
    Write-Error "An error occurred: $_"
    exit 1
}
finally {
    Write-Host "Remediation Completed."
}

# SIG # Begin signature block
# MIIdwAYJKoZIhvcNAQcCoIIdsTCCHa0CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCALotk8h/jlaGP2
# tjFMsahR10NS1LiImVVrvGKDKcjRC6CCF94wggSgMIIDiKADAgECAhNCAAAAR1OX
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
# AYI3AgEVMC8GCSqGSIb3DQEJBDEiBCA9UCuP0aqx8t4peGH5kvSy06+1a/MR9g4F
# rGvud/B3PDANBgkqhkiG9w0BAQEFAASCAQBayD+N9dTTetKP0WzvewvwXyZ4au7O
# JfCc8bXjVcxeSu8/Aj4SlGLL/ToOwmn9PDn8tjffx/cWzcJ8fvs0YxfdNHlJfmiV
# IB+eikX0rVr4eFsjdvxXWK2/yJgc0fGKwHo8QpeYJfZtI3Yc7uVC5IWoefRn0qRC
# eb1XM7TCdtQYJZozujooHUppHK7EVufjblCPQkma4M+PcKZl3VXL4FPQWYGJFPoQ
# D2SFkPidrEmRoxa0XUizkle0TjJ+ojrOGCD94ztVYkE45VYIqyrGmATC77w+/y2d
# MebeKg8spZJFeM71RozH8xx1LMXUo0hR/7U4DHqit6nRbUjDp7y91IzZoYIDJjCC
# AyIGCSqGSIb3DQEJBjGCAxMwggMPAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNV
# BAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0
# IFRpbWVTdGFtcGluZyBSU0E0MDk2IFNIQTI1NiAyMDI1IENBMQIQCoDvGEuN8QWC
# 0cR2p5V0aDANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
# BwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDkyNDEzNDIyMlowLwYJKoZIhvcNAQkEMSIE
# ICpmP+YAiKglshjW5vA1R0XIN464jBN9xVgYyVMxPahfMA0GCSqGSIb3DQEBAQUA
# BIICAEPMYrSv9zbdPAUorN+cTLmEDU81OuFRpFQpIZ55pjaagaD1K3gYSNiN5YKd
# mJehu30q+sCO2Z9+6xR42Sd1C9Nwn4WE/i6U9RBw2+/KJtT9PEGgVftTSraGINyC
# 8iY6gROtKIh8OX0zUC8vPNvHE+pOM0ykbp1DJfDfCFwcjDpfqi0mtXB16nZigXn3
# Vsg6DOdOIQgXszM9PQXXTAWZltp8Btyjjoj3SuHuDW2pBKp4NUTFRVf9nQNzoOym
# 2tCFMdLT9eYMyrxanN1PNIaItJ3SipObfa1szqcZKNSu0jA9CMZmlQH77lxS4EkX
# 1oEtFnNHQlAaFJMDwchaaid2euYsfc98yBMyrQq33DH6QjxGR/Ism/MLbAy70YHK
# GO0qtKGE4ciCZHe0Fxe1zNJiTLy/LLARg79/haMbMulAWWTN9jYqdOdKVh6+4ktJ
# m7+Cz5AD4ePXUa07KLuNlOYIPlzvvsBzn4yxGAb1o3AtG3ehC2zar0pCLlJ7pWsl
# JcyrxlTVJqjx1jvS3sKmonQD9wIHN4Qb/BVQ2kp0vy+XDR4FgRWdoaDKdUDbNG2U
# qltQBelCbIVRLGNa2Jj2Z8Fbzv/oWg1b5uEdhI0lT84deYjnX5bBKluobr0p/FR/
# TyQ9mMMWhB14ZHkSdhc1qjfRnyA4OCq2By52QzYrgRMyP6ks
# SIG # End signature block
