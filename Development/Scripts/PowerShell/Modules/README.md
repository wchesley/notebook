# AutoInc Modules

Modules, scripts and functions designed to be reused across multiple scripts. Please refer to each modules `help` for more information on the modules purpose, arguments and behaviors. 

## Avaliable Modules

- [Write-Log](./Write-Log/about_WriteLog.help.txt)

## Installation

These modules can be installed in two different ways: 

### Option 1: 

Import these modules directly from the company PDQ repository where they reside. For example, to import the `Write-Log` module: 

```ps1
Import-Module -Name "\\autoinc.local\UpdateRepository\PDQ_Installs\PowerShell Scripts\Modules\Write-Log"
```

This requries the PC to have network access to, and read permissions on this shared directory. 

### Option 2: 

Copy the desired module's folder into the users file system and import the module(s) using the path method listed in **Option 1** but point to the path the module(s) reside on the local file system: 

```ps1
Import-Module -Name "C:\Support\Modules\Write-Log"
```

This option can also be used as a pre-requisit step in PDQ deploy for adding modules required by another script. 

## Development

Each new module (`.psm1`) file should be placed within it's own directory with it's associated `about_<Module_Name>.help.txt` file and it's PowerShell manifest (`.psd1`) files. 