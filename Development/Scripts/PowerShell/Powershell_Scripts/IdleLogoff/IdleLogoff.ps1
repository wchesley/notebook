<#
.SYNOPSIS
    Logs off interactive sessions that have been idle longer than a threshold,
    but only takes action after a configured start hour (default 8 PM).

.DESCRIPTION
    Intended to be run repeatedly (e.g. every 15 minutes) by a Scheduled Task
    between 8:00 PM and midnight. Each run:
      1. Exits immediately if the current hour is before -StartHour.
      2. Parses `quser` to find every session and its idle time.
      3. Logs off (via `logoff.exe`) any session idle longer than -ThresholdMinutes.

    Must run as a principal with rights to log off other users' sessions
    (LOCAL SYSTEM works; see the Register-ScheduledTask snippet alongside
    this script).

.PARAMETER ThresholdMinutes
    Idle time in minutes before a session is logged off. Default 180 (3 hours).

.PARAMETER StartHour
    Hour (24h clock) after which the script is allowed to act. Default 20 (8 PM).

.PARAMETER ExcludeUsers
    Usernames to never log off (e.g. a service or admin account), case-insensitive.

.PARAMETER WhatIf
    Report what would happen without actually logging anyone off. Use this first
    to sanity-check parsing and thresholds on your machine before enabling for real.

.OUTPUTS
    Writes a timestamped line per session evaluated, and per logoff performed,
    to IdleLogoff.log next to this script.
#>

param(
    [int]$ThresholdMinutes = 180,
    [int]$StartHour = 20,
    [string[]]$ExcludeUsers = @(),
    [switch]$WhatIf
)

$logPath = Join-Path $PSScriptRoot "IdleLogoff.log"

function Write-Log {
    param([string]$Message)
    $line = "[{0:yyyy-MM-dd HH:mm:ss}] {1}" -f (Get-Date), $Message
    Add-Content -Path $logPath -Value $line
    Write-Output $line
}

function Convert-IdleTimeToMinutes {
    param([string]$IdleString)
    $IdleString = $IdleString.Trim()
    if ($IdleString -eq '.' -or $IdleString -eq '') {
        return 0
    }
    if ($IdleString -match '^(\d+)\+(\d{1,2}):(\d{2})$') {
        # days+hh:mm
        return ([int]$matches[1] * 24 * 60) + ([int]$matches[2] * 60) + [int]$matches[3]
    }
    if ($IdleString -match '^(\d{1,2}):(\d{2})$') {
        # hh:mm
        return ([int]$matches[1] * 60) + [int]$matches[2]
    }
    if ($IdleString -match '^\d+$') {
        # bare minutes (rare, but seen on some builds)
        return [int]$IdleString
    }
    return 0
}

$now = Get-Date
if ($now.Hour -lt $StartHour) {
    Write-Log "Before $($StartHour):00 (now $($now.ToString('HH:mm'))) - skipping."
    exit 0
}

$quserOutput = quser 2>$null
if (-not $quserOutput -or $quserOutput.Count -le 1) {
    Write-Log "No active sessions reported by quser."
    exit 0
}

# Skip the header row. Match each session line by anchoring on the fixed
# tokens (session ID, state, idle time, logon date) rather than fixed
# column widths, since quser's SESSIONNAME field is blank for disconnected
# sessions and shifts columns around.
$pattern = '^\>?(?<rest>.+?)\s+(?<id>\d+)\s+(?<state>Active|Disc)\s+(?<idle>\.|(?:\d+\+)?\d{1,2}:\d{2}|\d+)\s+(?<logon>\d{1,2}/\d{1,2}/\d{4}.*)$'

foreach ($rawLine in ($quserOutput | Select-Object -Skip 1)) {
    $line = $rawLine.TrimEnd()
    if ($line -notmatch $pattern) {
        Write-Log "Could not parse line, skipping: '$line'"
        continue
    }

    $sessionId  = $matches['id']
    $state      = $matches['state']
    $idleStr    = $matches['idle']
    $idleMin    = Convert-IdleTimeToMinutes $idleStr
    $userName   = ($matches['rest'].Trim() -split '\s+')[0]

    Write-Log "Session $sessionId user=$userName state=$state idle=$idleStr (${idleMin}m)"

    if ($ExcludeUsers -contains $userName) {
        Write-Log "  -> $userName is in -ExcludeUsers, skipping."
        continue
    }

    if ($idleMin -gt $ThresholdMinutes) {
        if ($WhatIf) {
            Write-Log "  -> WOULD log off session $sessionId ($userName), idle ${idleMin}m > ${ThresholdMinutes}m threshold. (-WhatIf, no action taken)"
        }
        else {
            Write-Log "  -> Logging off session $sessionId ($userName), idle ${idleMin}m > ${ThresholdMinutes}m threshold."
            logoff $sessionId
        }
    }
}

# SIG # Begin signature block
# MIIhZgYJKoZIhvcNAQcCoIIhVzCCIVMCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBiWwpoxGGBByQc
# unepZ1jq6+tPiUMKpfNrQQstPPbB8qCCG4QwggN9MIICZaADAgECAhAYr67jz8w+
# nEuuMXBuTW/LMA0GCSqGSIb3DQEBCwUAMEUxFTATBgoJkiaJk/IsZAEZFgVsb2Nh
# bDEXMBUGCgmSJomT8ixkARkWB2F1dG9pbmMxEzARBgNVBAMTCkFJLUNFUlQtQ0Ew
# HhcNMjQxMTIxMjEwMDAxWhcNMjkxMTIxMjExMDAxWjBFMRUwEwYKCZImiZPyLGQB
# GRYFbG9jYWwxFzAVBgoJkiaJk/IsZAEZFgdhdXRvaW5jMRMwEQYDVQQDEwpBSS1D
# RVJULUNBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw/dtusBlXvPj
# wMtQNB2Mxab7wzYg/gi0bEtM+sBY9WOMgeNY9i2sSOPGw9ZZdmIuBpfYC3TKCxD1
# XUgEfwg3Bu8RGTF2y9Lo8kBTjBdxfy2fFFyBl7DK91GhhT+PJEI4+RFvLcE9RSdd
# tDUQ5d3z8kp86yYnKq9MVWPodmpRegAjwOoe+OwF6VPtxNdNQyh+cLl1bV9pcY3X
# 2ikt4js92rk27luy4XP6sNaOjLcCctRG0cIj1t/Uw/0iuPHmwOrU4QltqZAfPMmq
# QV0oROSkT9Ja2yddgYJycNOq57+Gputur4dTPZ0tX0w/DrzQryDci9LIeVbM/3My
# N86n7e1zaQIDAQABo2kwZzATBgkrBgEEAYI3FAIEBh4EAEMAQTAOBgNVHQ8BAf8E
# BAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUx54yWNF5l8UMOq/oIpMy
# sWXvvmswEAYJKwYBBAGCNxUBBAMCAQAwDQYJKoZIhvcNAQELBQADggEBACJ9+BaI
# nxIcuWzqR2v0ltiLhAl+rDY6uTs+e07Mgz/ZGNVMKAVzcXNCR/VjlY1ddSwtUHQG
# 9RRjXnZDeGfyqmJx1ILkssPWUZYObM3rEe4aZcY03j4Zk8RNPam7rJxlgnvbiaGg
# uCTpeF+H+Dytvn6Z7nV+hayeLYr+Qw+BU13D+abqQ21kzH6Ijv5Zhi0ZhxqwkRjE
# iRTR/DBfcS1DPBToMQt5Hraqbg/a4tWNy8WnEvAA+Ttlxd/q7KwSAM3WTbehBNDP
# /+bfRIPDHlf9WzwY3fPttiJeZVvEvhcAHf2NHMI6TnddCuT6G1WEYDvyilZA8UQG
# CRB0O5n2a51mtlEwggTFMIIDraADAgECAhNCAAABD/+i5dSz8NbgAAAAAAEPMA0G
# CSqGSIb3DQEBCwUAMEUxFTATBgoJkiaJk/IsZAEZFgVsb2NhbDEXMBUGCgmSJomT
# 8ixkARkWB2F1dG9pbmMxEzARBgNVBAMTCkFJLUNFUlQtQ0EwHhcNMjYwODE3MTMz
# MzE4WhcNMjcwODE3MTMzMzE4WjAeMRwwGgYDVQQDDBMkYXV0b2luY3NpZ25pbmdj
# ZXJ0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6y2GbaUXh5fj5p9t
# ChB9tkTfoUrflAfjqJb2WNaMtyRejcpCzlJLF1OUk1x9n+zdyNNdHW+B2IKHmWNa
# ANOshYxoFhFIypWI36og+dn4PQ/7ogpfSCw1oe3mni6bJqwCvOCmqM+CKsV69e4e
# OtdMhWHBWVk2pLgg0Y5Doj1mouCK4vKx4I15J8xyC9YGDCUU5WvLrKKujMBDMhrT
# JM4kE0BzLAaP3eIUAhx4UXKBN1tBWiHj2YjIcjK1T0d4TPbA7TFOfT2Ltr5NmhTv
# qWyBNv18ZGt3kye0JEiV/T+oWs9v50eqjv0ct1BTT+4z8HV1FGjOtj2Tmj6UUpWQ
# Nei27QIDAQABo4IB0zCCAc8wPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGCNxUIg8Tb
# PYGguhOC9YUhhoyvQvmlUYFLh4+gFu7AHwIBZAIBBTATBgNVHSUEDDAKBggrBgEF
# BQcDAzAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAbBgkrBgEEAYI3FQoE
# DjAMMAoGCCsGAQUFBwMDMB0GA1UdDgQWBBRq+KMA/23isZevf+72ZLmB+Yy1KzAf
# BgNVHSMEGDAWgBTHnjJY0XmXxQw6r+gikzKxZe++azCBlwYDVR0fBIGPMIGMMIGJ
# oIGGoIGDhjNodHRwOi8vcGtpLmFpLWNlcnQuYXV0b2luYy5sb2NhbC9wa2kvQUkt
# Q0VSVC1DQS5jcmyGLWh0dHA6Ly9wa2kuYWktY2VydC5hdXRvaW5jLmNvbS9BSS1D
# RVJULUNBLmNybIYdaHR0cDovL2NybC5hdXRvaW5jLmxvY2FsL2NybGQwZQYIKwYB
# BQUHAQEEWTBXMFUGCCsGAQUFBzAChklodHRwOi8vcGtpLmFpLWNlcnQuYXV0b2lu
# Yy5sb2NhbC9wa2kvQUktQ2VydC5hdXRvaW5jLmxvY2FsX0FJLUNFUlQtQ0EuY3J0
# MA0GCSqGSIb3DQEBCwUAA4IBAQAeGKA488xpRV4cXM5DT2lGR5QBERbQHUIdF+TJ
# RPEGhJ0r1BXN4A3JBO1FESNcygDhZNG558rxkSSqdXTmoHh/k3tx0Hd4gYplrQcR
# PqXc0q0+pdjnHZ0Nkv8XkJCTnl7jrydiJqrO+u6I0ClQ2C+537zQvCJ2VROwk17W
# cv3aDUCSNGTCobaQZkO+mXYOEWhtBJCubKvc/9/Q1wyJGpxLgzaBcqml1A8GfirV
# jMWCXmoA15TW+6ecSnAMQf9xDwOR5z2gEWNuL7ec7CzuGNaYSehPCvOhEqcnADvY
# kmYHjIrF0n7oW6pGYf4SshcsS5z+OpwxwxTSeebPWCnkJGSoMIIFjTCCBHWgAwIB
# AgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0BAQwFADBlMQswCQYDVQQGEwJV
# UzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQu
# Y29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIw
# ODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYD
# VQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Y
# q3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lX
# FllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxe
# TsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbu
# yntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I
# 9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmg
# Z92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse
# 5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKy
# Ebe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwh
# HbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/
# Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwID
# AQABo4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM
# 3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDgYD
# VR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDov
# L29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+
# MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3Vy
# ZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUA
# A4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSI
# d229GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO0Cre+i1Wz/n096wwepqLsl7U
# z9FDRJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxA
# GTVGamlUsLihVo7spNU96LHc/RzY9HdaXFSMb++hUD38dglohJ9vytsgjTVgHAID
# yyCwrFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW
# /VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIGtDCCBJygAwIBAgIQDcesVwX/IZkuQEMi
# DDpJhjANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhE
# aWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwHhcNMjUwNTA3MDAwMDAwWhcNMzgwMTE0
# MjM1OTU5WjBpMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4x
# QTA/BgNVBAMTOERpZ2lDZXJ0IFRydXN0ZWQgRzQgVGltZVN0YW1waW5nIFJTQTQw
# OTYgU0hBMjU2IDIwMjUgQ0ExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEAtHgx0wqYQXK+PEbAHKx126NGaHS0URedTa2NDZS1mZaDLFTtQ2oRjzUXMmxC
# qvkbsDpz4aH+qbxeLho8I6jY3xL1IusLopuW2qftJYJaDNs1+JH7Z+QdSKWM06qc
# hUP+AbdJgMQB3h2DZ0Mal5kYp77jYMVQXSZH++0trj6Ao+xh/AS7sQRuQL37QXbD
# hAktVJMQbzIBHYJBYgzWIjk8eDrYhXDEpKk7RdoX0M980EpLtlrNyHw0Xm+nt5pn
# YJU3Gmq6bNMI1I7Gb5IBZK4ivbVCiZv7PNBYqHEpNVWC2ZQ8BbfnFRQVESYOszFI
# 2Wv82wnJRfN20VRS3hpLgIR4hjzL0hpoYGk81coWJ+KdPvMvaB0WkE/2qHxJ0ucS
# 638ZxqU14lDnki7CcoKCz6eum5A19WZQHkqUJfdkDjHkccpL6uoG8pbF0LJAQQZx
# st7VvwDDjAmSFTUms+wV/FbWBqi7fTJnjq3hj0XbQcd8hjj/q8d6ylgxCZSKi17y
# Vp2NL+cnT6Toy+rN+nM8M7LnLqCrO2JP3oW//1sfuZDKiDEb1AQ8es9Xr/u6bDTn
# YCTKIsDq1BtmXUqEG1NqzJKS4kOmxkYp2WyODi7vQTCBZtVFJfVZ3j7OgWmnhFr4
# yUozZtqgPrHRVHhGNKlYzyjlroPxul+bgIspzOwbtmsgY1MCAwEAAaOCAV0wggFZ
# MBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFO9vU0rp5AZ8esrikFb2L9RJ
# 7MtOMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQE
# AwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5j
# cnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJ
# YIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQAXzvsWgBz+Bz0RdnEwvb4LyLU0
# pn/N0IfFiBowf0/Dm1wGc/Do7oVMY2mhXZXjDNJQa8j00DNqhCT3t+s8G0iP5kvN
# 2n7Jd2E4/iEIUBO41P5F448rSYJ59Ib61eoalhnd6ywFLerycvZTAz40y8S4F3/a
# +Z1jEMK/DMm/axFSgoR8n6c3nuZB9BfBwAQYK9FHaoq2e26MHvVY9gCDA/JYsq7p
# GdogP8HRtrYfctSLANEBfHU16r3J05qX3kId+ZOczgj5kjatVB+NdADVZKON/gnZ
# ruMvNYY2o1f4MXRJDMdTSlOLh0HCn2cQLwQCqjFbqrXuvTPSegOOzr4EWj7PtspI
# HBldNE2K9i697cvaiIo2p61Ed2p8xMJb82Yosn0z4y25xUbI7GIN/TpVfHIqQ6Ku
# /qjTY6hc3hsXMrS+U0yy+GWqAXam4ToWd2UQ1KYT70kZjE4YtL8Pbzg0c1ugMZyZ
# Zd/BdHLiRu7hAWE6bTEm4XYRkA6Tl4KSFLFk43esaUeqGkH/wyW4N7OigizwJWeu
# kcyIPbAvjSabnf7+Pu0VrFgoiovRDiyx3zEdmcif/sYQsfch28bZeUz2rtY/9TCA
# 6TD8dC3JE3rYkrhLULy7Dc90G6e8BlqmyIjlgp2+VqsS9/wQD7yFylIz0scmbKvF
# oW2jNrbM1pD2T7m3XDCCBu0wggTVoAMCAQICEAqA7xhLjfEFgtHEdqeVdGgwDQYJ
# KoZIhvcNAQELBQAwaTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJ
# bmMuMUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IFRpbWVTdGFtcGluZyBS
# U0E0MDk2IFNIQTI1NiAyMDI1IENBMTAeFw0yNTA2MDQwMDAwMDBaFw0zNjA5MDMy
# MzU5NTlaMGMxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7
# MDkGA1UEAxMyRGlnaUNlcnQgU0hBMjU2IFJTQTQwOTYgVGltZXN0YW1wIFJlc3Bv
# bmRlciAyMDI1IDEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDQRqwt
# Esae0OquYFazK1e6b1H/hnAKAd/KN8wZQjBjMqiZ3xTWcfsLwOvRxUwXcGx8AUjn
# i6bz52fGTfr6PHRNv6T7zsf1Y/E3IU8kgNkeECqVQ+3bzWYesFtkepErvUSbf+EI
# YLkrLKd6qJnuzK8Vcn0DvbDMemQFoxQ2Dsw4vEjoT1FpS54dNApZfKY61HAldytx
# NM89PZXUP/5wWWURK+IfxiOg8W9lKMqzdIo7VA1R0V3Zp3DjjANwqAf4lEkTlCDQ
# 0/fKJLKLkzGBTpx6EYevvOi7XOc4zyh1uSqgr6UnbksIcFJqLbkIXIPbcNmA98Os
# kkkrvt6lPAw/p4oDSRZreiwB7x9ykrjS6GS3NR39iTTFS+ENTqW8m6THuOmHHjQN
# C3zbJ6nJ6SXiLSvw4Smz8U07hqF+8CTXaETkVWz0dVVZw7knh1WZXOLHgDvundrA
# tuvz0D3T+dYaNcwafsVCGZKUhQPL1naFKBy1p6llN3QgshRta6Eq4B40h5avMcpi
# 54wm0i2ePZD5pPIssoszQyF4//3DoK2O65Uck5Wggn8O2klETsJ7u8xEehGifgJY
# i+6I03UuT1j7FnrqVrOzaQoVJOeeStPeldYRNMmSF3voIgMFtNGh86w3ISHNm0Ia
# adCKCkUe2LnwJKa8TIlwCUNVwppwn4D3/Pt5pwIDAQABo4IBlTCCAZEwDAYDVR0T
# AQH/BAIwADAdBgNVHQ4EFgQU5Dv88jHt/f3X85FxYxlQQ89hjOgwHwYDVR0jBBgw
# FoAU729TSunkBnx6yuKQVvYv1Ensy04wDgYDVR0PAQH/BAQDAgeAMBYGA1UdJQEB
# /wQMMAoGCCsGAQUFBwMIMIGVBggrBgEFBQcBAQSBiDCBhTAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tMF0GCCsGAQUFBzAChlFodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRUaW1lU3RhbXBpbmdS
# U0E0MDk2U0hBMjU2MjAyNUNBMS5jcnQwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDov
# L2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0VGltZVN0YW1waW5n
# UlNBNDA5NlNIQTI1NjIwMjVDQTEuY3JsMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsG
# CWCGSAGG/WwHATANBgkqhkiG9w0BAQsFAAOCAgEAZSqt8RwnBLmuYEHs0QhEnmNA
# ciH45PYiT9s1i6UKtW+FERp8FgXRGQ/YAavXzWjZhY+hIfP2JkQ38U+wtJPBVBaj
# YfrbIYG+Dui4I4PCvHpQuPqFgqp1PzC/ZRX4pvP/ciZmUnthfAEP1HShTrY+2DE5
# qjzvZs7JIIgt0GCFD9ktx0LxxtRQ7vllKluHWiKk6FxRPyUPxAAYH2Vy1lNM4kze
# kd8oEARzFAWgeW3az2xejEWLNN4eKGxDJ8WDl/FQUSntbjZ80FU3i54tpx5F/0Kr
# 15zW/mJAxZMVBrTE2oi0fcI8VMbtoRAmaaslNXdCG1+lqvP4FbrQ6IwSBXkZagHL
# hFU9HCrG/syTRLLhAezu/3Lr00GrJzPQFnCEH1Y58678IgmfORBPC1JKkYaEt2Od
# Dh4GmO0/5cHelAK2/gTlQJINqDr6JfwyYHXSd+V08X1JUPvB4ILfJdmL+66Gp3CS
# BXG6IwXMZUXBhtCyIaehr0XkBoDIGMUG1dUtwq1qmcwbdUfcSYCn+OwncVUXf53V
# JUNOaMWMts0VlRYxe5nK+At+DI96HAlXHAL5SlfYxJ7La54i71McVWRP66bW+yER
# NpbJCjyCYG2j+bdpxo/1Cy4uPcU3AWVPGrbn5PhDBf3Froguzzhk++ami+r3Qrx5
# bIbY3TVzgiFI7Gq3zWcxggU4MIIFNAIBATBcMEUxFTATBgoJkiaJk/IsZAEZFgVs
# b2NhbDEXMBUGCgmSJomT8ixkARkWB2F1dG9pbmMxEzARBgNVBAMTCkFJLUNFUlQt
# Q0ECE0IAAAEP/6Ll1LPw1uAAAAAAAQ8wDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYB
# BAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAc
# BgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg4wX5
# 6CWXSeqxdG5cw4+XKLI9K/u2P3OY0GaG2T45idQwDQYJKoZIhvcNAQEBBQAEggEA
# H4LLylaMYQKR9E8FcuKNbEZ8ywD9hHYwtOtM4VAw9hK+QC8YrPSWp81qJRkMq9ag
# /ePp2vDKMTP08ERPnJqkN7JCiAX+U+WbVSWP1Qr6W3GKgVWDkqGFZyOpNB2TmEBP
# 3X3uJxm9lfuiyTsRfp0PdzWT0BsxEyYwd3nbalq3YzWLqkq2T46quBxIw5Ceqmi3
# l6yqaFfDystBMjiEOKaIKlj4ToEnW7cjDC7iGigf4LZNoYWWKufR4JN+LGb4HF3q
# q3I18hiLsbqcJHsj90g/M05ysVswch4BPVLTiXT7DgYoGvRBFpQJ6AolskMA7tI4
# l7b4lMzfYnKUk2wEXbSOlKGCAyYwggMiBgkqhkiG9w0BCQYxggMTMIIDDwIBATB9
# MGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UE
# AxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBUaW1lU3RhbXBpbmcgUlNBNDA5NiBTSEEy
# NTYgMjAyNSBDQTECEAqA7xhLjfEFgtHEdqeVdGgwDQYJYIZIAWUDBAIBBQCgaTAY
# BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjA4Mjgx
# MzU2NDBaMC8GCSqGSIb3DQEJBDEiBCDsdsI9jtxMcP9sPQvZnfAn4lMCHU9frb3O
# 5++JLaYSkTANBgkqhkiG9w0BAQEFAASCAgCDB/h9y2FIYp7HGAh0ngP//blI4okW
# wJoOM6TGARdOzC5fQm6Zmf/ezdUNmbiKVtWiq6GTx5lCTXlh2kHPJ4B7dP9x6Ax7
# Be8x10aJH7i8pL09MCWcgMXkWld5vC27ZkZYgrpCvLrsU5QqlMRYTFfXcmsYGqq7
# FYgsWTt4UatcjDaL6PVtkjOQMZidk30lr2c9LVwKdQgZo6kBDqrKGf4Dmc+p5UHh
# 8n6H3x90dnSWZGBELQmCi/BYPSkvIgWWK3t7C7VBs7pomEvjy53GLbEXsjujg4YJ
# DQJltL1gc+l9lvboE7mgL6Q3YQLbMmWfWzcrMIYMcZhMvgFhz1QwiF+A2JeF7Fcz
# Tw8LnC6ZCTW6r29327G01Q4UMil0pnjzCWJdaEVUMHQfuRP5vvO+SvS01cRuAdav
# MAXP09Mcqj77O8UlYmP9EB0H1nYSwkSlsAw1nUW/NZjmZMn84LV8p48aB1XLpy/B
# 9w0rtkF2wZN7ebCcd2cnGtuTfVTHDmt+DOwZcWI6KGvmeArkI58mKWd+boCDLEm8
# yWP4TCiJKsRkudMzhM8UKC2wY5Yt/JR9UazlF8rAwAO1jLdqbcEkeIFl3eA/ztW8
# djiUiaNkBDaMjKC/n0XWhsNob24q4fwAnfzhW7dftHS2OETj2HzsBSi3mvzIB2q4
# HYrDkCzaZMzc4Q==
# SIG # End signature block
