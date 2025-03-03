[back](../README.md)

# Windows

The OS everyone (seems to) love™ from Microsoft.

- [Windows](#windows)
  - [Table of Contents](#table-of-contents)
- [Notes](#notes)
  - [.msix files and how to open them](#msix-files-and-how-to-open-them)
  - [Brute-force get cli args of exe? (untested)](#brute-force-get-cli-args-of-exe-untested)
  - [Disable BitLocker automatic device encryption](#disable-bitlocker-automatic-device-encryption)
          - [source](#source)

## Table of Contents

List of Windows Documents: 

- [Command line ref](./CMD-Ref.md)
- [Using Telegraf on Windows](./Using-Telegraf-on-Windows-Blog-InfluxData.md)
- [View Domain name](./View-Domain-Name.md)
- [NFS](./windows-nfs.md)

# Notes

scratch notes that have no home yet... 

## .msix files and how to open them

These are basically a fancy wrapper around a `.zip` file, which contains all the applications data and `.xml` configuration files, which are required for installation. To view the contents of any `.msix` file, rename the file extension to `.zip` and decompress as normal. Ensure you keep a copy of the original `.msix` file or the `.zip` file if you intend to install or use the software inside. You can freely convert a `.zip` file back into it's `.msix` file by changing the extension once again. 

## Brute-force get cli args of exe? (untested)
Have a vendor executable with unknown command-line options? Don’t want to reverse-engineer? Brute force in Windows shell!

```
:: Extract strings from program
strings.exe program.exe >> strings.txt

:: Run each string as program argument
for /f %a IN (strings.txt) DO “program.exe” %a
```

## Disable BitLocker automatic device encryption

OEMs can choose to disable device encryption and instead implement their own encryption technology on a device. To disable BitLocker automatic device encryption, you can use an Unattend file and set [PreventDeviceEncryption](https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-securestartup-filterdriver-preventdeviceencryption) to True.

Alternately, you can update the **HKEY\_LOCAL\_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\BitLocker** registry key:

Value: **PreventDeviceEncryption** equal to True (1).

###### [source](https://learn.microsoft.com/en-us/windows-hardware/design/device-experiences/oem-bitlocker)