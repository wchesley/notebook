# VBR Installation v12

Free tier v12 limitations: 10 Workloads limit, NO tech support, NO malware detection, NO object storage and NO backup testing.

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

