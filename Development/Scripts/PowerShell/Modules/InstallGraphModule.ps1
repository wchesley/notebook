<#
.SYNOPSIS
    Installs the Microsoft Graph PowerShell module if not already installed.

.DESCRIPTION
    This function checks for the presence of the Microsoft Graph PowerShell module and installs it if not found.
    Once Graph module has been installed, the users and calendar cmdlets will be imported for use.

.EXAMPLE
    Install-GraphModule
#>
function InstallGraphModule {
    try {
        if(Get-PackageProvider | Where-Object {$_.Name -eq "NuGet"}) {
            Write-Information "NuGet provider is already installed."
        }
        else {
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Set-PSRepository -Name 'PSGallery' -SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted
        Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force -Confirm:$false -Scope CurrentUser
        Write-Host "Graph module installed successfully."
    }
    catch {
        Write-Error "Failed to install module 'Microsoft.Graph': $_"
        exit 1
    }
}