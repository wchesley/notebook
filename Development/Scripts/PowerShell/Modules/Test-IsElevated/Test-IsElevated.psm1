<# 
.SYNOPSIS
    Test if the current PowerShell session is running with elevated (administrator) privileges.
.DESCRIPTION
    This function checks if the current user has administrative rights in the PowerShell session.
.PARAMETER None
    No parameters are required for this function.
.INPUTS
    None
.OUTPUTS
    Boolean value indicating whether the session is elevated.
.EXAMPLE
    Test-IsElevated
    This command will return $true if the session is running with elevated privileges, otherwise it will return $false.
.NOTES
    Version: 1.0.0
    Author: Walker Chesley
    Created: 2025-09-30
    Modified: 2025-09-30
    Change Log: 
    - Initial release
#>

function Test-IsElevated {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object System.Security.Principal.WindowsPrincipal($id)
    if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
    { Write-Output $true }
    else
    { Write-Output $false }
}
Export-ModuleMember -Function Test-IsElevated