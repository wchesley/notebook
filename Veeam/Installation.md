[back](./README.md)

# VBR Installation v12

Free tier v12 limitations: 10 Workloads limit, NO tech support, NO malware detection, NO object storage and NO backup testing.

Direct download links (as of 01/07/2025)
Veeam 12.3 download URL: https://download2.veeam.com/VDPP/v12/VeeamDataPlatform_v12.3_20241212.iso
Veeam Agent 6.3.0.177 download URL: https://download2.veeam.com/VAW/v6/VeeamAgentWindows_6.3.0.177.zip

## Hardware Requirements

| Specification | Requirement | 
| --- |--- |
| Hardware | CPU: x86_64 (min 4 cores) |
| | Memory: 4Gb + 500MB for each concurrent Job | 
| | Disk Space: 5Gb for Veeam, 4.5 Gb for .NET framework 4.7.2, 10Gb per 100 VM's, Additional free space for instant recovery cache folder (non-persistent data, at least 100Gb recommended). At least 10Gb for storing logs (this varies based on environment) | 
| | Network: 1Gbps+ for LAN, 1Mbps+ for WAN, WAN supports high latency and "reasonably" unstable links |  
| OS | 64-bit version of Windows Server (2016-2022) | 
| | Microsoft Windows 11 (versions 21H2, 22H2, 23H2 (VBR-v12.1+)) |
| | Microsoft Windows 10 (from version 1909 to version 22H2) | 
| | Microsoft Windows 10 LTS (versions LTSB 1607, LTSC 1809, LTSC 2021) | 
| Configuration Database | PostgresSQL 15.x (included with VBR 12.11 setup)
| | Microsoft SQL Server 2012-2022 | 
| Software |     Microsoft .NET Framework 4.7.2 |
| | Microsoft ASP.NET Core Shared Framework 6.0.29
| | Microsoft Edge WebView2 Runtime 123.0.2420.81 (not installed for Microsoft Windows Server 2012 and 2012 R2 due to the version incompatibility)
| | Microsoft PowerShell 5.1
| | Microsoft Report Viewer Redistributable 2015
| | Microsoft SQL Server System CLR Types (both for SQL Server and PostgreSQL installations)
| | Microsoft Universal C Runtime
| | Microsoft Visual C++ 2015-2019 Redistributable 14.29.30037
| | Microsoft Windows Desktop Runtime 6.0.29

## Installation 

Server should be setup prior to installation. Per best practices, OS and Veeam should be on separate drives, with an optional 3rd drive for the Catalog. The Catalog drive is only needed in environments with 100 VM's or more. 

1. Mount the VBR v12 ISO to the server, open it and run `setup.exe` to start VBR installation process. 
2. Click on Install Veeam Backup & Replication
3. Accept License agreement
4. Provide your license file, accept defaults and click next for free edition
5. Installer checks for missing components, promts to install anything that is missing
6. Post component installation, at the 'ready to install' screen, click `Customize Settings` 
7. Select service account created to run VBR, service account should be local admin on VBR server, if Config Database runs on a different machine, the service account needs login credentials for it as well. Service account needs full NTFS permissions to the catalog folder. 
8. Select database installation, I prefer postgreSQL but MSSQL is a valid option too. Choices made here will vary by environment, ie if database is installed on same machine as VBR or a separate machine. 
9. Select/Confirm installation locations of Veeam. 
10. Accept default port configuration
11. You will be directed back to the 'ready to install' screen, confirm your choices and click `install` when ready. 

## Configuration (VmWare)

- **Repository Server**: Server that gets use for storing the backup files
- **Proxy Server**: The server(s) that perform all the backup tasks
- **VMware vCenter Credentials**: vCenter server not required as standalone ESXi hosts are supported (if licensed in VMware). 

The first launch of Veeam Backup & Recovery will land you directly in the `Inventory` tab with `Virtual Infrastructure` in focus. This screen is where we will be adding the Virtual Center so you can start backing up your VM's. Click `Add Server` option to begin. You will then be prompted to select what kind of server you wish to add, choose `VMware vSphere` and then either `vShpere` or `vCloud Director`. 

For most cases, you will use `vSphere` unless `vCloud Director` (SDDC?) is deployed. After selecting `vSphere` you are prompted for two things: 

- DNS or IP address of vCenter server (DNS is preffered)
- Credentials for vCenter, can be local vCenter account or domain joined account. 

Once credentials are accepted, you will see your vCenter server listed under Virtual Infrastructure section of the console and you can browse the hosts and VM's. 

Next you will add a `Proxy Server`. This will, again, vary based on environment, by default the VBR server also acts as the `Proxy Server`. Per best practices, you should have at least one separate `Proxy Server` and disable the `Proxy Server` on the VBR installation. 

The next component required is the `Repository Server`, which is the location where VBR will store the backup files. By default, VBR creates a default repository on the largest drive of the VBR server. There are several options for a `Repository Server`: 

- Direct Attached Storage
- Network Attached Storage
- Deduplicating storage appliance 
- Object storage (S3)

First 3 options are `block storage`, last one is `object storage`, which with v12 can now be used for backups directly as well as be a part of a scale-out backup repository as any of the tiers (performance, capacity and archive) for offloading data.

`Direct to Object` is a new feature of VBR v12, allowing on prem or cloud based object storage (S3) to be used for backups directly. You cannot mix vendors in object storage, so if you're on AWS all object storage must also be there. 

### Proxy Servers - Configuration and Optimization

`Proxy Servers` are the work horse of Veeam, they do all the heavy lifting for backup and restoration jobs. It is critical they are setup per best practices. 

When creating a `Proxy Server` Veeam B&R will install two components: 

- Veeam Installer Service: This gets used to check the server and upgrade software as required. 
- Veeam Data Mover: This is the processing engine for the proxy server and does all the required tasks. 

`Proxy Server` uses one of three different `transport modes` to retrieve data during backup. In order by most effecient: 

- `Direct Storage Access`: The proxy is placed in the same network as your storage arrays and can retrieve data directly. 
- `Virtual Appliance`: This mode mounts the VMDK files to the proxy server for what we typically call `Hot-Add Mode` to backup server data. 
- `Network`: This is the least effecient mode, but will be used when the previous two methods are unavailable. It moves data through your network stack, strongly recommended against using 1Gb networks, and instead use at least 10Gb. 

In addition to these standard transport modes, which are provided natively for VMware environments, Veeam provides two others: `Backup from Storage Snapshots` and `Direct NFS`. These provide storage specific transport options for NFS and storage systems that integrate directly with Veeam (Proxmox Backup Server coming Soon™).

Aside from transport, the Proxy Server performs: 

- Retrieving the VM data from storage
- Compressing data during backup
- Deduplicating data blocks so that only one copy is stored
- Encrypting data in transit and at rest
- Sending the data to the backup repository (backup job), or another backup proxy server (replication job)

Veeam has a formula for calculating resources required by a proxy server: 

- `D`: Source Data in MB
- `W`: Backup Window in seconds
- `T`: Trhoughput in MB/s = `D/W`
- `CR`: Change Rate (how often does the data change? How much is changing per day)
- `CF`: Cores required for a full backup = `T/100`
- `CI`: Cores required for an incremental backup = `(T * CR)/25`

Based on the formula above, we can use the following data sample to perform calculations: 

- 500 VM's
- 100 TB of data
- 8 Hr backup window
- 10% Change rate

Using this data set, we can perform the following calculations: 

We can use the numbers we calculated to dermine the required amount of cores needed to run both full and incremental backups to meet our defined SLA. 

Considering that you require 2GB of RAM for each task, you need a VM with 36 vCPU's and 72GB of RAM. Sizing may seem considerable but so is the sample data set, In reality this will vary widely based on each environment. 

Should you use a physical machine as the proxy, you should have a server with a 2-10 core CPU. Using the sample data you would require two physical machines. 

If using VM's for a proxy, you should cap the vCPU size at 8 and add as many proxies as needed for your environment. Using the sample data set, you would need 5 VM's working as proxy servers. 

# Veeam Agent Installation (Silent)

## Installation
<sub>[ref](https://helpcenter.veeam.com/docs/agentforwindows/userguide/installation_unattended.html?ver=60#)
</sub>

To install Veeam Agent for Microsoft Windows version 6.3, use a command with the following syntax:

<path\_to\_exe> /silent /accepteula /acceptthirdpartylicenses /acceptlicensingpolicy /acceptrequiredsoftware

where <path\_to\_exe> — path to the Veeam Agent for Microsoft Windows installation file.

Veeam Agent for Microsoft Windows uses the following codes to report about the installation results:

-   1000 — Veeam Agent for Microsoft Windows has been successfully installed.
-   1001 — prerequisite components required for Veeam Agent for Microsoft Windows have been installed on the machine. Veeam Agent for Microsoft Windows has not been installed. The machine needs to be rebooted.
-   1002 — Veeam Agent for Microsoft Windows installation has failed.
-   1004 — migration to SQLite database has failed.
-   1101 — Veeam Agent for Microsoft Windows has been installed. The machine needs to be rebooted.


### VSPC Mode

Loginto VSPC console

Navigate to the `Discovery` tab on the right nav bar. 

Select `Download Management Agent`.

Fill in the form for the company we are deploying the agent to. 

Generate and download the link. Our VSPC is not available on the internet so the .exe will need to be moved to the client machine via another means. For example, Datto Agent Browser, manage files on device, upload to `C:\Temp`. Then user powershell to silently install the agent.

Suppose you want to install preconfigured Veeam Service Provider Console management agent to the service provider infrastructure:

-   Installation log location: C:\\ProgramData\\Veeam\\Setup\\Temp\\Logs\\VACAgentSetup.txt

-   No user interaction
-   Path to the setup file: C:\\Veeam\\VAC\\ManagementAgent.MyCompany.exe
-   Accept 3rd party license agreement
-   Accept Veeam license agreement

-   Accept Veeam licensing policy
-   Accept required software agreements

The command to install Veeam Service Provider Console management agent with such configuration will have the following parameters:

```ps1
"C:\Veeam\VAC\ManagementAgent.MyCompany.x64.exe" /qn /l*v C:\ProgramData\Veeam\Setup\Temp\Logs\VACAgentSetup.txt ACCEPT_THIRDPARTY_LICENSES="1" ACCEPT_EULA="1" ACCEPT_REQUIRED\_SOFTWARE="1" ACCEPT_LICENSING\_POLICY="1"
```

Alternative means of execution: 
```ps1
Start-Process -Wait -FilePath C:\Temp\ManagementAgent.Precision_Excavation_Remote.exe -ArgumentList "/qn /L*v C:\Temp\VeeamMgmtSetupLog.txt ACCEPT_THIRDPARTY_LICENSES='1' ACCEPT_EULA='1' ACCEPT_REQUIRED_SOFTWARE='1' ACCEPT_LICENSING_POLICY='1'" -PassThru
```