# Powershell

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