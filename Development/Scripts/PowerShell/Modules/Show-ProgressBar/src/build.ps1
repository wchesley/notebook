$module = "ShowProgressBarCmdlet"
Push-Location $PSScriptRoot

dotnet build $PSScriptRoot -o $PSScriptRoot\Output\$module\bin
Copy-Item "$PSScriptRoot\*" "$PSScriptRoot\Output\$module" -Recurse -Force

Import-Module "$PSScriptRoot\Output\$module\$module.psm1" -Force