[back](./README.md)

# Microsoft Defender (O365/Intune)

Antivirus and EDR solution provided by microsoft. This is different from the built in Windows defender on each Windows PC. 

## MpCmdRun

You can perform various functions in Microsoft Defender Antivirus using the dedicated command-line tool mpcmdrun.exe. This utility is useful when you want to automate Microsoft Defender Antivirus tasks. You can find the utility in %ProgramFiles%\Windows Defender\MpCmdRun.exe. Run it from a command prompt.

| Command | Description |
| --- | --- |
| `-?` **or** `-h` | Displays all available options for the MpCmdRun tool. |
| `-Scan [-ScanType [<value>]] [-File <path> [-DisableRemediation] [-BootSectorScan] [-CpuThrottling]] [-Timeout <days>] [-Cancel]` | Scans for malicious software. Values for **ScanType** are:  <br/>**0** Default, according to your configuration <br/>**1** Quick scan <br/>**2** Full scan <br/>**3** File and directory custom scan. <br/>CpuThrottling runs according to policy configurations. |
| `-Trace [-Grouping #] [-Level #]` | Starts diagnostic tracing. |
| `-CaptureNetworkTrace -Path <path>` | Captures all the network input into the Network Protection service and saves it to a file at `<path>`. Supply an empty path to stop tracing. |
| `-GetFiles [-SupportLogLocation <path>]` | Collects support information. See [collecting diagnostic data](https://learn.microsoft.com/en-us/defender-endpoint/collect-diagnostic-data). |
| `-GetFilesDiagTrack` | Same as `-GetFiles`, but outputs to temporary DiagTrack folder. |
| `-RemoveDefinitions [-All]` | Restores the installed security intelligence to a previous backup copy or to the original default set. |
| `-RemoveDefinitions [-DynamicSignatures]` | Removes only the dynamically downloaded security intelligence. |
| `-RemoveDefinitions [-Engine]` | Restores the previous installed engine. |
| `-SignatureUpdate [-UNC |-MMPC]` | Checks for new security intelligence updates. |
| `-Restore  [-ListAll |[[-Name <name>] [-All] |[-FilePath <filePath>]] [-Path <path>]]` | Restores or lists quarantined items. |
| `-AddDynamicSignature [-Path]` | Loads dynamic security intelligence. |
| `-ListAllDynamicSignatures` | Lists the loaded dynamic security intelligence. |
| `-RemoveDynamicSignature [-SignatureSetID]` | Removes dynamic security intelligence. |
| `-CheckExclusion -path <path>` | Checks whether a path is excluded. |
| `-TDT [-on|-off|-default]` | Disable or Enable TDT feature or sets it to default. If no option is specified, it retrieves the current status. |
| `-OSCA` | Prints OS Copy Acceleration feature status. |
| `-DeviceControl -TestPolicyXml  <FilePath> [-Rules | -Groups]` | Validate xml policy groups and rules. |
| `-TrustCheck -File <FilePath>` | Checks trust status of a file. |
| `-ValidateMapsConnection` | Verifies that your network can communicate with the Microsoft Defender Antivirus cloud service. This command will only work on Windows 10, version 1703 or higher. |
| `-ListCustomASR` | List the custom Azure Site Recovery rules present on this device. |
| `-DisplayECSConnection` | Displays URLs that Defender Core service uses to establish connection to ECS. |
| `-HeapSnapshotConfig <-Enable\|-Disable> [-Pid <ProcessID>]` | Enable or Disable heap snapshot (tracing) configuration for process. Replace `<ProcessID>` with the actual process ID. |
| `-ResetPlatform` | Reset platform binaries back to `%ProgramFiles%\Windows Defender`. |
| `-RevertPlatform` | Revert platform binaries back to the previously installed version of the Defender platform. |