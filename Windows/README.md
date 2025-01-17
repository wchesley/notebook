[back](../README.md)

# Windows

The OS everyone (seems to) love™ from Microsoft.

- [Windows](#windows)
  - [Table of Contents](#table-of-contents)
- [Notes](#notes)
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