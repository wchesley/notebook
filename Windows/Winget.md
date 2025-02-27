# Winget

`winget` - Windows package manager. 

## Run `winget` as `NT AUTHORITY/SYSTEM`

```ps1
#Query for directory most updated winget.exe is stored in
$wingetdir = (Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe" | Sort-Object -Property Path | Select-Object -Last 1)
#Output directory
Write-Host "cd to directory: $wingetdir"
#navigate to directory containing winget.exe
cd $wingetdir
```

### Update all apps with updates available: 

```ps1
# Provided you've run the above code and powershell is in the $wingetdir directory. 
.\winget.exe upgrade --all --silent --accept-package-agreements --accept-source-agreements
```