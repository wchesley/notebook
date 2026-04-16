# Printers & Powershell

Aside from `Get-Printer`, there are several options via powershell with wich printers can be managed. 

> [!CAUTION]
> Take care with the **context** with which you manage printers. Powershell will display printers based on the current user **context** that powershell is running under. User A will see different printers than User B. 

Using `Get-CimInstance` will provide more deatils on printers and their status than `Get-Printer` will. For example: 

```ps1
Get-CimInstance Win32_Printer -Filter "Name = 'Lexmark MX310 Series'"
Name             ShareName            SystemName           PrinterState         PrinterStatus       Location           
----             ---------            ----------           ------------         -------------       --------           
Lexmark MX310...                      PCTERM07420          2                    1
```

Where both `PrinterState` and `PrinterStatus` values have the following definitions.     This property is inherited from [CIM_LogicalDevice](https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/cim-logicaldevice).

- Other (1)
- Unknown (2)
- Running/Full Power (3)
  - Running or Full Power
- Warning (4)
- In Test (5)
  - Not Applicable (6)
- Power Off (7)
- Off Line (8)
- Off Duty (9)
- Degraded (10)
- Not Installed (11)
- Install Error (12)
- Power Save - Unknown (13)
  - The device is known to be in a power save mode, but its exact status is unknown.
- Power Save - Low Power Mode (14)
  - The device is in a power save state but still functioning, and may exhibit degraded performance.
- Power Save - Standby (15)
  - The device is not functioning, but could be brought to full power quickly.
- Power Cycle (16)
- Power Save - Warning (17)
  - The device is in a warning state, though also in a power save mode.
- Paused (18)
  - The device is paused.
- Not Ready (19)
  - The device is not ready.
- Not Configured (20)
  - The device is not configured.
- Quiesced (21)
  - The device is quiet.


`Get-CimInstance` can also be used to send a test page to a printer: 

```ps1
Get-CimInstance Win32_Printer -Filter "Name = 'PrinterName'" | Invoke-CimMethod -MethodName printtestpage
```

If printer information is known, printers can also be added via powershell using `Add-Printer`, this works for local and network printers. Printer ports and drivers can also be added via `Add-PrinterPort` and `Add-PrinterDriver` respectively. Inverse commands (Remove) are available as well as Get commands for each as well. 

```ps1
Add-Printer
    [-DriverName] <String>
    [-Name] <String>
    -PortName <String>
    [-Comment <String>]
    [-Datatype <String>]
    [-UntilTime <UInt32>]
    [-KeepPrintedJobs]
    [-Location <String>]
    [-SeparatorPageFile <String>]
    [-ComputerName <String>]
    [-Shared]
    [-ShareName <String>]
    [-StartTime <UInt32>]
    [-PermissionSDDL <String>]
    [-PrintProcessor <String>]
    [-Priority <UInt32>]
    [-Published]
    [-RenderingMode <RenderingModeEnum>]
    [-DisableBranchOfficeLogging]
    [-BranchOfficeOfflineLogSizeMB <UInt32>]
    [-WorkflowPolicy <WorkflowPolicyEnum>]
    [-CimSession <CimSession[]>]
    [-ThrottleLimit <Int32>]
    [-AsJob]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

Add local printer port: 

```ps1
Add-PrinterPort
    [-Name] <String>
    [-ComputerName <String>]
    [-CimSession <CimSession[]>]
    [-ThrottleLimit <Int32>]
    [-AsJob]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

Add TCP printer port: 

```ps1
Add-PrinterPort
    [-Name] <String>
    [-PrinterHostAddress] <String>
    [-ComputerName <String>]
    [-PortNumber <UInt32>]
    [-SNMP <UInt32>]
    [-SNMPCommunity <String>]
    [-CimSession <CimSession[]>]
    [-ThrottleLimit <Int32>]
    [-AsJob]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

Add Printer Driver: 

```ps1
Add-PrinterDriver
    [-Name] <String>
    [[-InfPath] <String>]
    [-PrinterEnvironment <String>]
    [-ComputerName <String>]
    [-CimSession <CimSession[]>]
    [-ThrottleLimit <Int32>]
    [-AsJob]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```