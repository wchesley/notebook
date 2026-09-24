<sub>[back](./README.md)</sub>

# SQL Server Management Studio (SSMS)

SQL Server Management Studio (SSMS) is an integrated environment for managing any SQL infrastructure. Use SSMS to access, configure, manage, administer, and develop platforms that use the Microsoft SQL Database Engine, including SQL Server, Azure SQL Database, SQL database in Microsoft Fabric, Azure SQL Managed Instance, SQL Server on Azure Virtual Machines, and others.

SSMS provides a single comprehensive utility that combines a broad group of graphical tools with many rich script editors to provide access to SQL Server for developers and database administrators of all skill levels.

## Installation

The latest release of SQL Server Management Studio 22 that is hosted on Microsoft servers. To install this version, select the following link, which downloads a stub installer, or _bootstrapper_, to your _Downloads_ folder.

**[Download the SQL Server Management Studio 22 installer](https://aka.ms/ssms/22/release/vs_SSMS.exe)**

### GUI Install: 

Double click `vs_SSMS.exe` to begin installation, will require admin permissions to install. Follow the prompts provided to install SSMS. 

### CLI Silent Install: 

You will still need `vs_SSMS.exe` to install SSMS silently, the following applies to SSMS 22 installer: 

```ps1
C:\Path\To\Installer> ./vs_SSMS.exe --quiet --noreboot --force
```

For a full list of CLI params for `vs_SSMS` see [here](https://learn.microsoft.com/en-us/ssms/install/command-line-parameters)

## Uninstall

For SSMS versions older than 21 you can uninstall via `Add or Remove Programs`. If you still have the `SSMS-Setup-ENU.exe` you can use that to silently uninstall like so: 

```ps1
SSMS-Setup-ENU.exe /uninstall /quiet /norestart
```

For SSMS versions 21 and newer use the Visual Studio installer to uninstall. For GUI, run the installer, select the old version, under modify; choose uninstall. To silently uninstall: 

```ps1
"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\setup.exe" uninstall --installPath "C:\Program Files\Microsoft SQL Server Management Studio 21\Release" --quiet --norestart
```