[back](../README.md)

```ps1
import-module Veeam.Backup.PowerShell

$tenants = Get-VBRCloudTenant

$report = @()

foreach ($tenant in $tenants)
{
    $repoName = $tenant.Resources.Repository.Name
    $tenantName = $tenant.Name
    $tenantQuota = $tenant.Resources.RepositoryQuota
    $tenantUsedSpace = $tenant.Resources.UsedSpace
    $tenantSpacePercent = $tenant.Resources.UsedSpacePercentage

    $report += [PSCustomObject]@{
        Tenant = $tenantName
    }

}
```
