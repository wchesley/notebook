[back](./README.md)

- [Veeam Agent for Windows XML Schema](#veeam-agent-for-windows-xml-schema)
    - [**Breakdown of XML Schema Elements**](#breakdown-of-xml-schema-elements)
      - [**1. `<ExecutionResult>`**](#1-executionresult)
      - [**2. `<JobInfo>` (Backup Job Configuration)**](#2-jobinfo-backup-job-configuration)
      - [**3. `<ApplicationSettings>` (Agent Configuration)**](#3-applicationsettings-agent-configuration)
    - [**Common XML Schema Variations in Veeam Agent for Windows 6**](#common-xml-schema-variations-in-veeam-agent-for-windows-6)
- [**Veeam Agent Job Configuration XML**](#veeam-agent-job-configuration-xml)
    - [**1. Job Configuration XML Schema**](#1-job-configuration-xml-schema)
  - [**2. XML Schema Breakdown**](#2-xml-schema-breakdown)
    - [**🔹 2.1 `<JobConfiguration>`**](#-21-jobconfiguration)
    - [**🔹 2.2 `<JobInfo>` (Defines General Job Properties)**](#-22-jobinfo-defines-general-job-properties)
    - [**🔹 2.3 `<SourceInfo>` (Defines What to Backup)**](#-23-sourceinfo-defines-what-to-backup)
      - [**📌 `<EpDiskFilter>` Attributes**](#-epdiskfilter-attributes)
      - [**📌 `<Drive>` Attributes**](#-drive-attributes)
      - [**📌 `<VolumeOrPartitionId>` Attributes**](#-volumeorpartitionid-attributes)
      - [**📌 `<IncludeFolders>` \& `<ExcludeFolders>`**](#-includefolders--excludefolders)
    - [**🔹 2.4 `<TargetInfo>` (Defines Backup Destination)**](#-24-targetinfo-defines-backup-destination)
    - [**🔹 2.5 `<StorageInfo>` (Configures Storage Settings)**](#-25-storageinfo-configures-storage-settings)
      - [**📌 Attributes**](#-attributes)
      - [**📌 `<Encryption>`**](#-encryption)
    - [**🔹 2.6 `<RetentionInfo>` (Defines Retention Policy)**](#-26-retentioninfo-defines-retention-policy)
    - [**🔹 2.7 `<ScheduleInfo>` (Defines Scheduling)**](#-27-scheduleinfo-defines-scheduling)
      - [**📌 `<Daily>` (Daily Backup Schedule)**](#-daily-daily-backup-schedule)
      - [**📌 `<RetryInfo>` (Retry Settings)**](#-retryinfo-retry-settings)
    - [**🔹 2.8 `<AdvancedOptions>`**](#-28-advancedoptions)
      - [**📌 `<Throttling>`**](#-throttling)
      - [**📌 `<EmailNotifications>`**](#-emailnotifications)
      - [**📌 `<Recipients>`**](#-recipients)
- [**3. Common Schema Variations**](#3-common-schema-variations)
- [**Veeam Agent Execution Result XML**](#veeam-agent-execution-result-xml)
  - [**1. Execution Result XML Schema**](#1-execution-result-xml-schema)
  - [**2. XML Schema Breakdown**](#2-xml-schema-breakdown-1)
    - [**🔹 2.1 `<ExecutionResult>` (Root Element)**](#-21-executionresult-root-element)
    - [**🔹 2.2 `<JobInfo>` (Job Metadata)**](#-22-jobinfo-job-metadata)
    - [**🔹 2.3 `<JobStatus>` (Backup Completion Status)**](#-23-jobstatus-backup-completion-status)
    - [**🔹 2.4 `<JobStats>` (Backup Execution Time Stats)**](#-24-jobstats-backup-execution-time-stats)
    - [**🔹 2.5 `<SourceStats>` (Processed Backup Data)**](#-25-sourcestats-processed-backup-data)
    - [**🔹 2.6 `<TargetStats>` (Backup Repository Storage Details)**](#-26-targetstats-backup-repository-storage-details)
    - [**🔹 2.7 `<Warnings>` (Job Warnings)**](#-27-warnings-job-warnings)
      - [**📌 `<Warning>` Attributes**](#-warning-attributes)
    - [**🔹 2.8 `<Errors>` (Job Errors)**](#-28-errors-job-errors)
      - [**📌 `<Error>` Attributes**](#-error-attributes)
    - [**🔹 2.9 `<PerformanceMetrics>` (Job Bottlenecks \& Performance)**](#-29-performancemetrics-job-bottlenecks--performance)
  - [**3. Common Schema Variations**](#3-common-schema-variations-1)
- [**Veeam Agent Application Settings XML**](#veeam-agent-application-settings-xml)
  - [**1. Application Settings XML Schema**](#1-application-settings-xml-schema)
  - [**2. XML Schema Breakdown**](#2-xml-schema-breakdown-2)
    - [**🔹 2.1 `<ApplicationSettings>` (Root Element)**](#-21-applicationsettings-root-element)
    - [**🔹 2.2 `<Logging>` (Log Configuration)**](#-22-logging-log-configuration)
    - [**🔹 2.3 `<Security>` (Access \& Encryption)**](#-23-security-access--encryption)
    - [**🔹 2.4 `<Network>` (Network Restrictions \& Bandwidth Throttling)**](#-24-network-network-restrictions--bandwidth-throttling)
      - [**📌 `<AllowedAdapters>` (List of Permitted Network Interfaces)**](#-allowedadapters-list-of-permitted-network-interfaces)
      - [**📌 `<BandwidthThrottling>` (Backup Speed Limits)**](#-bandwidththrottling-backup-speed-limits)
    - [**🔹 2.5 `<Schedule>` (Backup Job Scheduling)**](#-25-schedule-backup-job-scheduling)
    - [**🔹 2.6 `<Notifications>` (Email Alerts)**](#-26-notifications-email-alerts)
      - [**📌 `<SmtpServer>` (SMTP Configuration)**](#-smtpserver-smtp-configuration)
      - [**📌 `<Sender>` (Sender Email Address)**](#-sender-sender-email-address)
      - [**📌 `<Recipients>` (Notification Recipients)**](#-recipients-notification-recipients)
    - [**🔹 2.7 `<UpdateSettings>` (Automatic Updates)**](#-27-updatesettings-automatic-updates)
  - [**3. Common Schema Variations**](#3-common-schema-variations-2)


# Veeam Agent for Windows XML Schema

**Overview of XML Schemas in Veeam Agent for Microsoft Windows 6**

Veeam Agent for Microsoft Windows 6 employs XML files to manage and configure various aspects of its operations. These XML files are primarily categorized into two types:

1. **Input XML Files**: Utilized to import application settings and backup job configurations into Veeam Agent.
2. **Output XML Files**: Generated by Veeam Agent to export current application settings, backup job configurations, and statistical information.

**Default File Location**

By default, both input and output XML files are stored in the following directory on the machine where Veeam Agent is installed:

```

C:\ProgramData\Veeam\Endpoint\!Configuration\
```


Users have the option to specify a different location for these files if desired. citeturn0search0

**Structure of XML Files**

The XML files used by Veeam Agent are structured into three main sections:

1. **Backup Job Settings**: This section defines the configuration of backup jobs, including parameters such as backup type, target, and scheduling settings.
2. **Application Settings**: Encompasses general settings at the application level, such as update checks and notification preferences.
3. **Execution Result**: Contains information about the execution status of commands, including exit codes and notifications.

**Example of an Output XML File**

Below is an example of an output XML file generated by Veeam Agent:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ExecutionResult ExitCode='0' Version='6.3.0.177'>
    <Data>
        <JobInfo ConfigId='00000000-0000-0000-0000-000000000000' CryptId='00000000-0000-0000-0000-000000000000' CryptType='10' JobDesc='Created by VMWIN2\Administrator at 1/9/2019 2:16 AM.' JobMode='2' JobName='Backup Job' ObjectName='VMWIN2' PolicyJobName=''>
            <SourceInfo>
                <EpDiskFilter BackupAllUsbDrives='False' BackupMode='1' BackupSystemState='False' BackupUserFolders='False' PartialConfig='False'>
                    <Drive FilterType='0' IsExternaldrive='False'>
                        <VolumeOrPartitionId MountPoint='C:\' Type='1'/>
                        <IncludeFolders>
                            <String value='C:\'/>
                        </IncludeFolders>
                        <ExcludeFolders/>
                    </Drive>
                    <IncludeMasks/>
                    <ExcludeMasks/>
                    <UserProfilesBackupOptions ExcludeCorruptedProfiles='False' ExcludeTemporaryProfiles='False' ExcludeRoamingProfiles='True' SelectedSpecialFolders='1' SelectedFolderTypes='127'/>
                </EpDiskFilter>
            </SourceInfo>
            <TargetInfo DriveName='F:\' RelativePath='VeeamBackup\' Type='1'/>
            <StorageInfo BlockSize='3' CompressionLevel='5'>
                <Encryption Enabled='False'/>
            </StorageInfo>
            <RetentionInfo RetentionType='0' RestorePointsCount='10'/>
            <CacheInfo Enabled='False'/>
            <GuestInfo>
                <Applications Enabled='False' ProcessTransactionLogs='True'>
                    <Credentials Password='' UserName=''/>
                    <Sql Mode='1'>
                        <Credentials Password='' UserName=''/>
                        <Backup BackupMinutes='15' Enabled='False' Expirable='True' ExpireDays='15'/>
                    </Sql>
                    <Oracle AccountType='0' LifetimeHours='24' Mode='0' SizeGB='10'>
                        <Credentials Password='' UserName=''/>
                        <Backup BackupMinutes='15' Enabled='False' Expirable='True' ExpireDays='15'/>
                    </Oracle>
                    <SharePoint>
                        <Credentials Password='' UserName=''/>
                    </SharePoint>
                    <Script Mode='0' PostThawPath='' PreFreezePath=''>
                        <Credentials Password='' UserName=''/>
                    </Script>
                </Applications>
                <Indexing Enabled='False' Type='3'>
                    <IncludedFolders/>
                    <ExcludedFolders>
                        <String value='%windir%'/>
                        <String value='%ProgramFiles%'/>
                        <String value='%ProgramFiles (x86)%'/>
                        <String value='%ProgramW6432%'/>
                        <String value='%TEMP%'/>
                    </ExcludedFolders>
                </Indexing>
            </GuestInfo>
            <ScheduleInfo AtLock='False' AtLogOff='False' AtStorageAttach='False' CompletionMode='0' EjectRemovableStorageOnceBackupIsCompleted='False' LimitBackupsFrequency='False' ResumeMissedBackup='False' RunManually='True' UseBackupWindow='False' Version='1'>
                <SyntheticFull Enabled='False'/>
                <ActiveFull Enabled='False'/>
                <HealthCheck Enabled='False'/>
                <Compact Enabled='False'/>
                <RetryInfo Enabled='True' TimeoutMinutes='10' Times='3'/>
            </ScheduleInfo>
            <StatisticsInfo AverageDuration='00:06:06.8250000' LastPointSize='1459957760' TotalSize='13091151872'/>
        </JobInfo>
        <ApplicationSettings CheckUpdates='True' CryptId='00000000-0000-0000-0000-000000000000' CryptType='10' DisableControlPanelNotification='False' DisableScheduledBackups='False' DisableWakeupTimers='False' EnableUserFlr='False' LastCheckForUpdates='01/09/2019 04:50:40' LockDownMode='False' LogoText='Veeam Agent' ServiceProviderMode='False' ShowBackupDuration='False' ThrottleBackupActivity='True'>
            <EmailReport Notification='True'>
                <Header From='jerald.blake@veeam.com' Subject='[%JobResult%] %ComputerName% - %JobName% - %CompletionTime%' To='jerald.blake@veeam.com'/>
                <Conditions Failure='True' Success='True' Warning='True'/>
            </EmailReport>
        </ApplicationSettings>
    </Data>
</ExecutionResult>
```

---

### **Breakdown of XML Schema Elements**
Each XML file in Veeam Agent for Microsoft Windows 6 contains structured data organized under key elements. Here’s a breakdown of the most critical sections:

#### **1. `<ExecutionResult>`**
- **Attributes:**
  - `ExitCode`: Numeric exit code indicating success (`0`) or failure (`1`+).
  - `Version`: Veeam Agent version that generated the XML.

#### **2. `<JobInfo>` (Backup Job Configuration)**
- **Attributes:**
  - `ConfigId`: Unique identifier for the backup job.
  - `JobName`: Name assigned to the backup job.
  - `JobMode`: Type of backup job (e.g., full, incremental).
  - `ObjectName`: The source system being backed up.

- **Nested Elements:**
  - `<SourceInfo>`: Defines the backup scope (e.g., volumes, folders).
  - `<TargetInfo>`: Specifies where backups are stored.
  - `<StorageInfo>`: Configures block size, compression, and encryption.
  - `<RetentionInfo>`: Defines retention policies (restore points).
  - `<GuestInfo>`: Specifies application-aware processing and indexing options.
  - `<ScheduleInfo>`: Manages job scheduling, retries, and execution rules.
  - `<StatisticsInfo>`: Contains job performance data (e.g., backup size, duration).

#### **3. `<ApplicationSettings>` (Agent Configuration)**
- **Attributes:**
  - `CheckUpdates`: Enables or disables automatic updates.
  - `DisableScheduledBackups`: Controls whether scheduled backups are allowed.
  - `EnableUserFlr`: Determines if user file-level recovery (FLR) is available.

- **Nested Elements:**
  - `<EmailReport>`: Configures email notifications for job results.
    - `<Header>`: Defines sender, recipient, and email subject format.
    - `<Conditions>`: Specifies when notifications are sent (success, failure, warning).

---

### **Common XML Schema Variations in Veeam Agent for Windows 6**
Veeam provides different XML schema variations based on usage scenarios:

| **Schema Type**          | **Purpose** |
|--------------------------|------------|
| **Job Configuration XML** | Stores backup job details (sources, targets, schedules). |
| **Execution Result XML** | Logs backup job results, including success/failure details. |
| **Application Settings XML** | Contains global agent configurations, such as update settings and email notifications. |
| **Custom Policy XML** | Used in MSP environments to enforce specific backup configurations across endpoints. |


# **Veeam Agent Job Configuration XML**
The **Job Configuration XML** is a structured file used to define and manage backup jobs in **Veeam Agent for Microsoft Windows 6**. This file contains settings for **backup sources, targets, retention policies, schedules, and advanced options**.

### **1. Job Configuration XML Schema**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<JobConfiguration Version="6.3.0.177">
    <JobInfo ConfigId="00000000-0000-0000-0000-000000000000" JobName="Backup Job" JobMode="2">
        <SourceInfo>
            <EpDiskFilter BackupMode="1" BackupSystemState="True">
                <Drive FilterType="0" IsExternaldrive="False">
                    <VolumeOrPartitionId MountPoint="C:\" Type="1"/>
                    <IncludeFolders>
                        <String value="C:\UserData"/>
                    </IncludeFolders>
                    <ExcludeFolders>
                        <String value="C:\Temp"/>
                    </ExcludeFolders>
                </Drive>
            </EpDiskFilter>
        </SourceInfo>
        <TargetInfo Type="1" DriveName="F:\" RelativePath="VeeamBackups\"/>
        <StorageInfo BlockSize="3" CompressionLevel="5">
            <Encryption Enabled="False"/>
        </StorageInfo>
        <RetentionInfo RetentionType="0" RestorePointsCount="10"/>
        <ScheduleInfo RunManually="False" CompletionMode="0">
            <Daily RunDays="Monday,Wednesday,Friday" RunTime="03:00:00"/>
            <RetryInfo Enabled="True" TimeoutMinutes="10" Times="3"/>
        </ScheduleInfo>
        <AdvancedOptions>
            <Throttling Enabled="True"/>
            <EmailNotifications Enabled="True">
                <Recipients>
                    <Email value="admin@company.com"/>
                </Recipients>
            </EmailNotifications>
        </AdvancedOptions>
    </JobInfo>
</JobConfiguration>
```

---

## **2. XML Schema Breakdown**
Each section of the **Job Configuration XML** defines key parameters of the Veeam Agent backup job. Below is a structured explanation of each component:

### **🔹 2.1 `<JobConfiguration>`**
- **Root element** of the XML.
- **Attributes**:
  - `Version` → Specifies the Veeam Agent version (e.g., `6.3.0.177`).

---

### **🔹 2.2 `<JobInfo>` (Defines General Job Properties)**
- **Attributes**:
  - `ConfigId` → Unique identifier for the job.
  - `JobName` → User-defined name for the backup job.
  - `JobMode`:
    - `1` = File-level backup
    - `2` = Volume-level backup
    - `3` = Entire system backup

---

### **🔹 2.3 `<SourceInfo>` (Defines What to Backup)**
- **Contains `<EpDiskFilter>`**, which manages source selection.

#### **📌 `<EpDiskFilter>` Attributes**
| Attribute | Description |
|-----------|-------------|
| `BackupMode` | `1` (Volume-level), `2` (File-level), `3` (Entire computer) |
| `BackupSystemState` | `True` to include system state (registry, system files) |

#### **📌 `<Drive>` Attributes**
| Attribute | Description |
|-----------|-------------|
| `FilterType="0"` | Standard filter for drives |
| `IsExternaldrive="False"` | If `True`, backs up external drives |

#### **📌 `<VolumeOrPartitionId>` Attributes**
| Attribute | Description |
|-----------|-------------|
| `MountPoint="C:\"` | Specifies drive letter or mount point |
| `Type="1"` | `1` = NTFS, `2` = ReFS, `3` = FAT32 |

#### **📌 `<IncludeFolders>` & `<ExcludeFolders>`**
- **IncludeFolders**: Defines specific folders to back up.
- **ExcludeFolders**: Specifies directories to exclude.

---

### **🔹 2.4 `<TargetInfo>` (Defines Backup Destination)**
| Attribute | Description |
|-----------|-------------|
| `Type="1"` | `1` = Local drive, `2` = Network share, `3` = Cloud |
| `DriveName="F:\"` | Destination drive letter |
| `RelativePath="VeeamBackups\"` | Subdirectory path |

---

### **🔹 2.5 `<StorageInfo>` (Configures Storage Settings)**
#### **📌 Attributes**
| Attribute | Description |
|-----------|-------------|
| `BlockSize="3"` | `1` = 256KB, `2` = 512KB, `3` = 1MB |
| `CompressionLevel="5"` | `0` = None, `1` = Low, `5` = High |

#### **📌 `<Encryption>`**
| Attribute | Description |
|-----------|-------------|
| `Enabled="False"` | If `True`, backup is encrypted |

---

### **🔹 2.6 `<RetentionInfo>` (Defines Retention Policy)**
| Attribute | Description |
|-----------|-------------|
| `RetentionType="0"` | `0` = Restore points, `1` = Days |
| `RestorePointsCount="10"` | Keeps last 10 backups |

---

### **🔹 2.7 `<ScheduleInfo>` (Defines Scheduling)**
| Attribute | Description |
|-----------|-------------|
| `RunManually="False"` | If `True`, requires manual start |
| `CompletionMode="0"` | `0` = Normal, `1` = Eject media after job |

#### **📌 `<Daily>` (Daily Backup Schedule)**
- **Attributes**:
  - `RunDays="Monday,Wednesday,Friday"`
  - `RunTime="03:00:00"`

#### **📌 `<RetryInfo>` (Retry Settings)**
- **Attributes**:
  - `Enabled="True"`
  - `TimeoutMinutes="10"`
  - `Times="3"` (Retry up to 3 times)

---

### **🔹 2.8 `<AdvancedOptions>`**
#### **📌 `<Throttling>`**
| Attribute | Description |
|-----------|-------------|
| `Enabled="True"` | If `True`, limits bandwidth |

#### **📌 `<EmailNotifications>`**
| Attribute | Description |
|-----------|-------------|
| `Enabled="True"` | If `True`, sends email alerts |

#### **📌 `<Recipients>`**
- **Contains `<Email>` entries**:
  ```xml
  <Email value="admin@company.com"/>
  ```

---

# **3. Common Schema Variations**
Veeam Agent allows variations in the Job Configuration XML for different use cases:

| Use Case | Schema Variation |
|----------|----------------|
| **File-Level Backup** | `<BackupMode="2">` with `<IncludeFolders>` |
| **Entire Computer Backup** | `<BackupMode="3">`, backs up all drives |
| **Network Target** | `<TargetInfo Type="2">` with `<NetworkShare>` |
| **Cloud Storage** | `<TargetInfo Type="3">` with `<CloudBucket>` |
| **Application-Aware Processing** | `<GuestProcessing>` enabled |


# **Veeam Agent Execution Result XML**
The **Execution Result XML** is generated after each backup job execution, providing structured details on **job status, performance metrics, errors, warnings, and duration**. This file is useful for **log analysis, automation, and monitoring**.

---

## **1. Execution Result XML Schema**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ExecutionResult Version="6.3.0.177" ExitCode="0">
    <JobInfo ConfigId="00000000-0000-0000-0000-000000000000" JobName="Daily Backup" JobMode="2">
        <JobStatus IsRetry="False" State="Success" Reason="None"/>
        <JobStats StartTime="2025-03-05T03:00:00Z" EndTime="2025-03-05T03:30:00Z" Duration="1800"/>
        <SourceStats ProcessedObjects="10" ProcessedSize="5000000000" ReadSize="2500000000" TransferSize="1000000000"/>
        <TargetStats TargetName="BackupRepo1" TargetFreeSpace="100000000000" TargetUsedSpace="500000000000"/>
        <Warnings>
            <Warning Time="2025-03-05T03:10:00Z" Message="Slow read speed detected on C:\ drive."/>
        </Warnings>
        <Errors>
            <Error Time="2025-03-05T03:15:00Z" Message="Backup storage temporarily unavailable."/>
        </Errors>
        <PerformanceMetrics Throughput="500MB/s" Bottleneck="Target"/>
    </JobInfo>
</ExecutionResult>
```

---

## **2. XML Schema Breakdown**
The **Execution Result XML** consists of structured data, including **job metadata, status, performance stats, warnings, errors, and bottleneck analysis**.

### **🔹 2.1 `<ExecutionResult>` (Root Element)**
- **Attributes**:
  - `Version` → Veeam Agent version (`6.3.0.177`).
  - `ExitCode`:
    - `0` = Success
    - `1` = Warning
    - `2+` = Failure

---

### **🔹 2.2 `<JobInfo>` (Job Metadata)**
- **Attributes**:
  - `ConfigId` → Unique identifier of the job.
  - `JobName` → User-defined backup job name.
  - `JobMode`:
    - `1` = File-level backup
    - `2` = Volume-level backup
    - `3` = Entire system backup

---

### **🔹 2.3 `<JobStatus>` (Backup Completion Status)**
- **Attributes**:
  - `IsRetry="False"` → Whether this job run was a retry.
  - `State="Success"`:
    - `Success` → Job completed successfully.
    - `Warning` → Job completed with warnings.
    - `Failed` → Job failed.
  - `Reason="None"` → Error or warning reason (if applicable).

---

### **🔹 2.4 `<JobStats>` (Backup Execution Time Stats)**
- **Attributes**:
  - `StartTime="2025-03-05T03:00:00Z"` → Job start time.
  - `EndTime="2025-03-05T03:30:00Z"` → Job end time.
  - `Duration="1800"` → Total job duration (seconds).

---

### **🔹 2.5 `<SourceStats>` (Processed Backup Data)**
- **Attributes**:
  - `ProcessedObjects="10"` → Number of files/volumes processed.
  - `ProcessedSize="5000000000"` → Total size of processed data (bytes).
  - `ReadSize="2500000000"` → Actual data read (bytes).
  - `TransferSize="1000000000"` → Data transferred to backup repository (bytes).

---

### **🔹 2.6 `<TargetStats>` (Backup Repository Storage Details)**
- **Attributes**:
  - `TargetName="BackupRepo1"` → Name of the backup repository.
  - `TargetFreeSpace="100000000000"` → Free space left (bytes).
  - `TargetUsedSpace="500000000000"` → Used space (bytes).

---

### **🔹 2.7 `<Warnings>` (Job Warnings)**
- Contains **multiple `<Warning>` entries** for issues that did not cause failure.

#### **📌 `<Warning>` Attributes**
| Attribute | Description |
|-----------|-------------|
| `Time="2025-03-05T03:10:00Z"` | Timestamp of the warning |
| `Message="Slow read speed detected on C:\ drive."` | Warning message |

---

### **🔹 2.8 `<Errors>` (Job Errors)**
- Contains **multiple `<Error>` entries** for **critical failures**.

#### **📌 `<Error>` Attributes**
| Attribute | Description |
|-----------|-------------|
| `Time="2025-03-05T03:15:00Z"` | Timestamp of the error |
| `Message="Backup storage temporarily unavailable."` | Error message |

---

### **🔹 2.9 `<PerformanceMetrics>` (Job Bottlenecks & Performance)**
- **Attributes**:
  - `Throughput="500MB/s"` → Data processing speed.
  - `Bottleneck="Target"`:
    - `Source` → Read speed is the limiting factor.
    - `Network` → Data transmission speed is the issue.
    - `Target` → Write speed on the backup repository is the bottleneck.

---

## **3. Common Schema Variations**
Different **Execution Result XML** structures exist depending on job outcomes:

| Use Case | Schema Variation |
|----------|----------------|
| **Successful Backup** | `<JobStatus State="Success"/>`, `<Warnings>` absent |
| **Backup with Warnings** | `<JobStatus State="Warning"/>`, `<Warnings>` contains entries |
| **Failed Backup** | `<JobStatus State="Failed"/>`, `<Errors>` contains critical failures |
| **Job Retry** | `<JobStatus IsRetry="True"/>` |
| **Storage Full** | `<Errors>` entry: `"Target storage is full"` |
| **Slow Backup Performance** | `<PerformanceMetrics Bottleneck="Target"/>` |

|Attribute|Description|
|--:|:--|
|Domain > Expert|Backup & Recovery > Veeam Backup Specialist|
|Keywords|Veeam Agent, Application Settings XML, Backup Configuration, Job Settings, XML Schema, Automation|
|Goal|Provide a **detailed and comprehensive breakdown** of the **Application Settings XML** schema in Veeam Agent for Microsoft Windows 6, including structure, attributes, and potential variations.|
|Assumptions|User needs **fully structured XML schema** to analyze, modify, or automate Veeam Agent application settings.|
|Methodology|Extract XML schema details from Veeam documentation and real-world examples, explaining all attributes, variations, and practical implications.|

---

# **Veeam Agent Application Settings XML**
The **Application Settings XML** defines **global settings** for the Veeam Agent, including **logging, backup job scheduling, throttling, network restrictions, security policies, and notification settings**.

## **1. Application Settings XML Schema**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApplicationSettings Version="6.3.0.177">
    <Logging Level="Info" LogRetentionDays="30" MaxLogSizeMB="100"/>
    <Security RequirePassword="True" PasswordHash="A1B2C3D4E5F6G7H8I9J0K" Encryption="AES-256"/>
    <Network UseOnlyAllowedAdapters="True">
        <AllowedAdapters>
            <Adapter Name="Ethernet 1" MAC="00:1A:2B:3C:4D:5E"/>
            <Adapter Name="Wi-Fi" MAC="00:1A:2B:3C:4D:5F"/>
        </AllowedAdapters>
        <BandwidthThrottling Enabled="True" MaxRate="100Mbps"/>
    </Network>
    <Schedule>
        <BackupTime Daily="True" Time="02:00:00"/>
        <BackupTime Weekly="True" DayOfWeek="Sunday" Time="03:00:00"/>
    </Schedule>
    <Notifications EmailEnabled="True">
        <SmtpServer Address="smtp.example.com" Port="587" UseSSL="True"/>
        <Sender Email="backup-reports@example.com"/>
        <Recipients>
            <Recipient Email="admin@example.com"/>
            <Recipient Email="support@example.com"/>
        </Recipients>
    </Notifications>
    <UpdateSettings AutoUpdate="True" CheckFrequency="Weekly"/>
</ApplicationSettings>
```

---

## **2. XML Schema Breakdown**
This XML file defines **core application settings** related to logging, security, network, scheduling, notifications, and updates.

### **🔹 2.1 `<ApplicationSettings>` (Root Element)**
- **Attributes**:
  - `Version="6.3.0.177"` → Veeam Agent version.

---

### **🔹 2.2 `<Logging>` (Log Configuration)**
Defines how Veeam Agent manages logs.

- **Attributes**:
  - `Level="Info"`:
    - `Verbose` → Detailed logs
    - `Info` → Standard logs
    - `Warning` → Logs only warnings and errors
    - `Error` → Logs only errors
  - `LogRetentionDays="30"` → How long logs are kept.
  - `MaxLogSizeMB="100"` → Maximum log file size.

---

### **🔹 2.3 `<Security>` (Access & Encryption)**
Defines **password protection and encryption settings**.

- **Attributes**:
  - `RequirePassword="True"` → Enables password protection.
  - `PasswordHash="A1B2C3D4E5F6G7H8I9J0K"` → Hashed password (if enabled).
  - `Encryption="AES-256"`:
    - `None` → No encryption
    - `AES-128` → AES 128-bit encryption
    - `AES-256` → AES 256-bit encryption

---

### **🔹 2.4 `<Network>` (Network Restrictions & Bandwidth Throttling)**
Controls **allowed network adapters and backup bandwidth limits**.

- **Attributes**:
  - `UseOnlyAllowedAdapters="True"` → Restricts backup jobs to specific network adapters.

#### **📌 `<AllowedAdapters>` (List of Permitted Network Interfaces)**
Each `<Adapter>` defines a permitted network adapter.

| Attribute | Description |
|-----------|-------------|
| `Name="Ethernet 1"` | Adapter name |
| `MAC="00:1A:2B:3C:4D:5E"` | MAC address |

#### **📌 `<BandwidthThrottling>` (Backup Speed Limits)**
- **Attributes**:
  - `Enabled="True"` → Bandwidth throttling enabled.
  - `MaxRate="100Mbps"` → Maximum data transfer rate.

---

### **🔹 2.5 `<Schedule>` (Backup Job Scheduling)**
Defines **daily and weekly schedules**.

- **Attributes**:
  - `<BackupTime Daily="True" Time="02:00:00"/>` → Runs daily at 2:00 AM.
  - `<BackupTime Weekly="True" DayOfWeek="Sunday" Time="03:00:00"/>` → Runs every Sunday at 3:00 AM.

---

### **🔹 2.6 `<Notifications>` (Email Alerts)**
Controls **email notifications for backup jobs**.

- **Attributes**:
  - `EmailEnabled="True"` → Enables email notifications.

#### **📌 `<SmtpServer>` (SMTP Configuration)**
Defines the email server for notifications.

| Attribute | Description |
|-----------|-------------|
| `Address="smtp.example.com"` | SMTP server hostname |
| `Port="587"` | SMTP port |
| `UseSSL="True"` | Enables SSL encryption |

#### **📌 `<Sender>` (Sender Email Address)**
- `Email="backup-reports@example.com"` → Sender email.

#### **📌 `<Recipients>` (Notification Recipients)**
Each `<Recipient>` defines an email recipient.

| Attribute | Description |
|-----------|-------------|
| `Email="admin@example.com"` | Admin recipient |
| `Email="support@example.com"` | Support recipient |

---

### **🔹 2.7 `<UpdateSettings>` (Automatic Updates)**
Controls **automatic update policies**.

- **Attributes**:
  - `AutoUpdate="True"` → Enables automatic updates.
  - `CheckFrequency="Weekly"`:
    - `Daily` → Checks for updates daily.
    - `Weekly` → Checks for updates weekly.
    - `Monthly` → Checks for updates monthly.

---

## **3. Common Schema Variations**
Different **Application Settings XML** structures exist based on user preferences:

| Use Case | Schema Variation |
|----------|----------------|
| **Logging disabled** | `<Logging Level="Error" LogRetentionDays="0"/>` |
| **No network restrictions** | `<Network UseOnlyAllowedAdapters="False"/>` |
| **No bandwidth throttling** | `<BandwidthThrottling Enabled="False"/>` |
| **Strict security settings** | `<Security RequirePassword="True" Encryption="AES-256"/>` |
| **No automatic updates** | `<UpdateSettings AutoUpdate="False"/>` |
| **Weekly backups only** | `<Schedule><BackupTime Daily="False"/><BackupTime Weekly="True" DayOfWeek="Sunday"/></Schedule>` |
| **Custom SMTP settings** | `<SmtpServer Address="mail.example.com" Port="465" UseSSL="True"/>` |
