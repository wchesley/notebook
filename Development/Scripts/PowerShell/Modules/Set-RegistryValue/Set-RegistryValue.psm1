<# 
.SYNOPSIS
    Set a registry value idempotently.
.DESCRIPTION
    Sets a registry value only if it does not already exist or is different from the desired value.
.PARAMETER Path
    The registry path where the value should be set.
.PARAMETER Name
    The name of the registry value to set.
.PARAMETER Value
    The desired value for the registry key.
.PARAMETER PropertyType
    The type of the registry value (e.g., DWORD, String).
.INPUTS
    None
.OUTPUTS
    None
.EXAMPLE
    Set-RegistryValueIdempotent -Path 'HKLM:\Software\MyApp' -Name 'Setting' -Value 1 -PropertyType 'DWORD'
.NOTES
    Version: 1.0
    Author: Walker Chesley
    Created: 2025-09-10
    Modified: 2025-09-10
    Change Log: 
    - Initial release
#>
function Set-RegistryValueIdempotent {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(ValueFromPipeline=$true)]
        $Value,
        [string]$PropertyType = 'DWORD'
    )
    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    $current = $null
    try {
        $current = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    } catch {}
    if ($null -eq $current -or $current -ne $Value) {
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $PropertyType -Force | Out-Null
    }
}
Export-ModuleMember -Function Set-RegistryValueIdempotent