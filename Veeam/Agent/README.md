[back](../README.md)

# Veeam Agents

Veeam has agents for all 3 major operating systems, Linux, Mac and Windows. 

# Scratch

### Agent Install error (From VBR)

`4/8/2025 8:11:05 AM Failed Unable to install backup agent: failed to connect to <IP_ADDRESS> Error: Known agent <HOSTNAME> have the same bios uuid 5491c694-f71f-1820-1101-181107000000 but different connection point <IP_ADDRESS>.`

When reinstalling a Veeam Agent to the same computer from the same VBR server, you might run into this error. The solution is actually DNS...I had put in the IP address of the machine and needed to use the HOSTNAME instead. doing that resolved the issue. 

Xml output of Veeam agent exporter, converted to C# Class: 

```csharp
// using System.Xml.Serialization;
// XmlSerializer serializer = new XmlSerializer(typeof(ExecutionResult));
// using (StringReader reader = new StringReader(xml))
// {
//    var test = (ExecutionResult)serializer.Deserialize(reader);
// }

[XmlRoot(ElementName="UserProfilesBackupOptions")]
public class UserProfilesBackupOptions { 

	[XmlAttribute(AttributeName="SelectedFolderTypes")] 
	public int SelectedFolderTypes; 

	[XmlAttribute(AttributeName="SelectedSpecialFolders")] 
	public int SelectedSpecialFolders; 

	[XmlAttribute(AttributeName="ExcludeRoamingProfiles")] 
	public bool ExcludeRoamingProfiles; 

	[XmlAttribute(AttributeName="ExcludeTemporaryProfiles")] 
	public bool ExcludeTemporaryProfiles; 

	[XmlAttribute(AttributeName="ExcludeCorruptedProfiles")] 
	public bool ExcludeCorruptedProfiles; 
}

[XmlRoot(ElementName="EpDiskFilter")]
public class EpDiskFilter { 

	[XmlElement(ElementName="IncludeMasks")] 
	public object IncludeMasks; 

	[XmlElement(ElementName="ExcludeMasks")] 
	public object ExcludeMasks; 

	[XmlElement(ElementName="UserProfilesBackupOptions")] 
	public UserProfilesBackupOptions UserProfilesBackupOptions; 

	[XmlAttribute(AttributeName="BackupMode")] 
	public int BackupMode; 

	[XmlAttribute(AttributeName="BackupSystemState")] 
	public bool BackupSystemState; 

	[XmlAttribute(AttributeName="BackupUserFolders")] 
	public bool BackupUserFolders; 

	[XmlAttribute(AttributeName="PartialConfig")] 
	public bool PartialConfig; 

	[XmlAttribute(AttributeName="BackupAllUsbDrives")] 
	public bool BackupAllUsbDrives; 

	[XmlAttribute(AttributeName="ExcludeSystemState")] 
	public bool ExcludeSystemState; 

	[XmlAttribute(AttributeName="ExcludeOneDriveFolders")] 
	public bool ExcludeOneDriveFolders; 
}

[XmlRoot(ElementName="SourceInfo")]
public class SourceInfo { 

	[XmlElement(ElementName="EpDiskFilter")] 
	public EpDiskFilter EpDiskFilter; 
}

[XmlRoot(ElementName="ServerCredentials")]
public class ServerCredentials { 

	[XmlAttribute(AttributeName="UserName")] 
	public string UserName; 

	[XmlAttribute(AttributeName="Password")] 
	public string Password; 
}

[XmlRoot(ElementName="TargetInfo")]
public class TargetInfo { 

	[XmlElement(ElementName="ServerCredentials")] 
	public ServerCredentials ServerCredentials; 

	[XmlAttribute(AttributeName="Type")] 
	public int Type; 

	[XmlAttribute(AttributeName="ServerName")] 
	public string ServerName; 

	[XmlAttribute(AttributeName="ServerPort")] 
	public int ServerPort; 

	[XmlAttribute(AttributeName="RemoteRepositoryName")] 
	public string RemoteRepositoryName; 

	[XmlAttribute(AttributeName="GateList")] 
	public string GateList; 

	[XmlAttribute(AttributeName="AgentDeletedRetentionEnable")] 
	public bool AgentDeletedRetentionEnable; 

	[XmlAttribute(AttributeName="AgentDeletedRetentionRetainDays")] 
	public int AgentDeletedRetentionRetainDays; 

	[XmlAttribute(AttributeName="DriveName")] 
	public string DriveName; 

	[XmlAttribute(AttributeName="RelativePath")] 
	public string RelativePath; 
}

[XmlRoot(ElementName="Encryption")]
public class Encryption { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 

	[XmlElement(ElementName="Key")] 
	public Key Key; 
}

[XmlRoot(ElementName="StorageInfo")]
public class StorageInfo { 

	[XmlElement(ElementName="Encryption")] 
	public Encryption Encryption; 

	[XmlAttribute(AttributeName="CompressionLevel")] 
	public int CompressionLevel; 

	[XmlAttribute(AttributeName="BlockSize")] 
	public int BlockSize; 
}

[XmlRoot(ElementName="RetentionInfo")]
public class RetentionInfo { 

	[XmlAttribute(AttributeName="RetentionType")] 
	public int RetentionType; 

	[XmlAttribute(AttributeName="RestorePointsCount")] 
	public int RestorePointsCount; 
}

[XmlRoot(ElementName="ImmutabilityInfo")]
public class ImmutabilityInfo { 

	[XmlAttribute(AttributeName="ImmutabilityEnabled")] 
	public bool ImmutabilityEnabled; 

	[XmlAttribute(AttributeName="ImmutabilityPeriod")] 
	public int ImmutabilityPeriod; 
}

[XmlRoot(ElementName="CacheInfo")]
public class CacheInfo { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 
}

[XmlRoot(ElementName="Credentials")]
public class Credentials { 

	[XmlAttribute(AttributeName="UserName")] 
	public object UserName; 

	[XmlAttribute(AttributeName="Password")] 
	public object Password; 
}

[XmlRoot(ElementName="Backup")]
public class Backup { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 

	[XmlAttribute(AttributeName="Expirable")] 
	public bool Expirable; 

	[XmlAttribute(AttributeName="BackupMinutes")] 
	public int BackupMinutes; 

	[XmlAttribute(AttributeName="ExpireDays")] 
	public int ExpireDays; 
}

[XmlRoot(ElementName="Sql")]
public class Sql { 

	[XmlElement(ElementName="Credentials")] 
	public Credentials Credentials; 

	[XmlElement(ElementName="Backup")] 
	public Backup Backup; 

	[XmlAttribute(AttributeName="Mode")] 
	public int Mode; 
}

[XmlRoot(ElementName="Oracle")]
public class Oracle { 

	[XmlElement(ElementName="Credentials")] 
	public Credentials Credentials; 

	[XmlElement(ElementName="Backup")] 
	public Backup Backup; 

	[XmlAttribute(AttributeName="Mode")] 
	public int Mode; 

	[XmlAttribute(AttributeName="LifetimeHours")] 
	public int LifetimeHours; 

	[XmlAttribute(AttributeName="SizeGB")] 
	public int SizeGB; 

	[XmlAttribute(AttributeName="AccountType")] 
	public int AccountType; 
}

[XmlRoot(ElementName="SharePoint")]
public class SharePoint { 

	[XmlElement(ElementName="Credentials")] 
	public Credentials Credentials; 
}

[XmlRoot(ElementName="Script")]
public class Script { 

	[XmlElement(ElementName="Credentials")] 
	public Credentials Credentials; 

	[XmlAttribute(AttributeName="Mode")] 
	public int Mode; 

	[XmlAttribute(AttributeName="PreFreezePath")] 
	public object PreFreezePath; 

	[XmlAttribute(AttributeName="PostThawPath")] 
	public object PostThawPath; 
}

[XmlRoot(ElementName="Applications")]
public class Applications { 

	[XmlElement(ElementName="Credentials")] 
	public Credentials Credentials; 

	[XmlElement(ElementName="Sql")] 
	public Sql Sql; 

	[XmlElement(ElementName="Oracle")] 
	public Oracle Oracle; 

	[XmlElement(ElementName="SharePoint")] 
	public SharePoint SharePoint; 

	[XmlElement(ElementName="Script")] 
	public Script Script; 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 

	[XmlAttribute(AttributeName="ProcessTransactionLogs")] 
	public bool ProcessTransactionLogs; 
}

[XmlRoot(ElementName="String")]
public class String { 

	[XmlAttribute(AttributeName="value")] 
	public string Value; 
}

[XmlRoot(ElementName="ExcludedFolders")]
public class ExcludedFolders { 

	[XmlElement(ElementName="String")] 
	public List<String> String; 
}

[XmlRoot(ElementName="Indexing")]
public class Indexing { 

	[XmlElement(ElementName="IncludedFolders")] 
	public object IncludedFolders; 

	[XmlElement(ElementName="ExcludedFolders")] 
	public ExcludedFolders ExcludedFolders; 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 

	[XmlAttribute(AttributeName="Type")] 
	public int Type; 
}

[XmlRoot(ElementName="GuestInfo")]
public class GuestInfo { 

	[XmlElement(ElementName="Applications")] 
	public Applications Applications; 

	[XmlElement(ElementName="Indexing")] 
	public Indexing Indexing; 
}

[XmlRoot(ElementName="DailyInfo")]
public class DailyInfo { 

	[XmlAttribute(AttributeName="Time")] 
	public DateTime Time; 

	[XmlAttribute(AttributeName="Kind")] 
	public int Kind; 

	[XmlAttribute(AttributeName="Days")] 
	public string Days; 
}

[XmlRoot(ElementName="SyntheticFull")]
public class SyntheticFull { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 
}

[XmlRoot(ElementName="ActiveFull")]
public class ActiveFull { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 
}

[XmlRoot(ElementName="HealthCheck")]
public class HealthCheck { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 
}

[XmlRoot(ElementName="HealthCheckOptions")]
public class HealthCheckOptions { 

	[XmlAttribute(AttributeName="EnableSimpleObjectStorageRecheck")] 
	public bool EnableSimpleObjectStorageRecheck; 
}

[XmlRoot(ElementName="Compact")]
public class Compact { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 
}

[XmlRoot(ElementName="RetryInfo")]
public class RetryInfo { 

	[XmlAttribute(AttributeName="Enabled")] 
	public bool Enabled; 

	[XmlAttribute(AttributeName="Times")] 
	public int Times; 

	[XmlAttribute(AttributeName="TimeoutMinutes")] 
	public int TimeoutMinutes; 
}

[XmlRoot(ElementName="ScheduleInfo")]
public class ScheduleInfo { 

	[XmlElement(ElementName="DailyInfo")] 
	public DailyInfo DailyInfo; 

	[XmlElement(ElementName="SyntheticFull")] 
	public SyntheticFull SyntheticFull; 

	[XmlElement(ElementName="ActiveFull")] 
	public ActiveFull ActiveFull; 

	[XmlElement(ElementName="HealthCheck")] 
	public HealthCheck HealthCheck; 

	[XmlElement(ElementName="HealthCheckOptions")] 
	public HealthCheckOptions HealthCheckOptions; 

	[XmlElement(ElementName="Compact")] 
	public Compact Compact; 

	[XmlElement(ElementName="RetryInfo")] 
	public RetryInfo RetryInfo; 

	[XmlAttribute(AttributeName="RunManually")] 
	public bool RunManually; 

	[XmlAttribute(AttributeName="ResumeMissedBackup")] 
	public bool ResumeMissedBackup; 

	[XmlAttribute(AttributeName="EjectRemovableStorageOnceBackupIsCompleted")] 
	public bool EjectRemovableStorageOnceBackupIsCompleted; 

	[XmlAttribute(AttributeName="AtLogOff")] 
	public bool AtLogOff; 

	[XmlAttribute(AttributeName="AtLock")] 
	public bool AtLock; 

	[XmlAttribute(AttributeName="AtStorageAttach")] 
	public bool AtStorageAttach; 

	[XmlAttribute(AttributeName="UseBackupWindow")] 
	public bool UseBackupWindow; 

	[XmlAttribute(AttributeName="Version")] 
	public int Version; 

	[XmlAttribute(AttributeName="LimitBackupsFrequency")] 
	public bool LimitBackupsFrequency; 

	[XmlAttribute(AttributeName="MaxBackupsFrequency")] 
	public int MaxBackupsFrequency; 

	[XmlAttribute(AttributeName="CompletionMode")] 
	public int CompletionMode; 

	[XmlAttribute(AttributeName="FrequencyTimeUnit")] 
	public int FrequencyTimeUnit; 

	[XmlAttribute(AttributeName="Type")] 
	public int Type; 
}

[XmlRoot(ElementName="GfsWeeklyPolicy")]
public class GfsWeeklyPolicy { 

	[XmlAttribute(AttributeName="IsEnabled")] 
	public bool IsEnabled; 

	[XmlAttribute(AttributeName="NumberOfWeeks")] 
	public int NumberOfWeeks; 

	[XmlAttribute(AttributeName="BeginTimeUtc")] 
	public DateTime BeginTimeUtc; 

	[XmlAttribute(AttributeName="DesiredTime")] 
	public int DesiredTime; 
}

[XmlRoot(ElementName="GfsMonthlyPolicy")]
public class GfsMonthlyPolicy { 

	[XmlAttribute(AttributeName="IsEnabled")] 
	public bool IsEnabled; 

	[XmlAttribute(AttributeName="NumberOfMonths")] 
	public int NumberOfMonths; 

	[XmlAttribute(AttributeName="BeginTimeUtc")] 
	public DateTime BeginTimeUtc; 

	[XmlAttribute(AttributeName="DesiredTime")] 
	public int DesiredTime; 
}

[XmlRoot(ElementName="GfsYearlyPolicy")]
public class GfsYearlyPolicy { 

	[XmlAttribute(AttributeName="IsEnabled")] 
	public bool IsEnabled; 

	[XmlAttribute(AttributeName="NumberOfYears")] 
	public int NumberOfYears; 

	[XmlAttribute(AttributeName="BeginTimeUtc")] 
	public DateTime BeginTimeUtc; 

	[XmlAttribute(AttributeName="DesiredTime")] 
	public int DesiredTime; 
}

[XmlRoot(ElementName="GfsPolicy")]
public class GfsPolicy { 

	[XmlElement(ElementName="GfsWeeklyPolicy")] 
	public GfsWeeklyPolicy GfsWeeklyPolicy; 

	[XmlElement(ElementName="GfsMonthlyPolicy")] 
	public GfsMonthlyPolicy GfsMonthlyPolicy; 

	[XmlElement(ElementName="GfsYearlyPolicy")] 
	public GfsYearlyPolicy GfsYearlyPolicy; 

	[XmlAttribute(AttributeName="IsEnabled")] 
	public bool IsEnabled; 
}

[XmlRoot(ElementName="GfsPolicyInfo")]
public class GfsPolicyInfo { 

	[XmlElement(ElementName="GfsPolicy")] 
	public GfsPolicy GfsPolicy; 
}

[XmlRoot(ElementName="StatisticsInfo")]
public class StatisticsInfo { 

	[XmlAttribute(AttributeName="AverageDuration")] 
	public DateTime AverageDuration; 

	[XmlAttribute(AttributeName="TotalSize")] 
	public double TotalSize; 

	[XmlAttribute(AttributeName="LastPointSize")] 
	public double LastPointSize; 
}

[XmlRoot(ElementName="JobInfo")]
public class JobInfo { 

	[XmlElement(ElementName="SourceInfo")] 
	public SourceInfo SourceInfo; 

	[XmlElement(ElementName="TargetInfo")] 
	public TargetInfo TargetInfo; 

	[XmlElement(ElementName="StorageInfo")] 
	public StorageInfo StorageInfo; 

	[XmlElement(ElementName="RetentionInfo")] 
	public RetentionInfo RetentionInfo; 

	[XmlElement(ElementName="ImmutabilityInfo")] 
	public ImmutabilityInfo ImmutabilityInfo; 

	[XmlElement(ElementName="CacheInfo")] 
	public CacheInfo CacheInfo; 

	[XmlElement(ElementName="GuestInfo")] 
	public GuestInfo GuestInfo; 

	[XmlElement(ElementName="ScheduleInfo")] 
	public ScheduleInfo ScheduleInfo; 

	[XmlElement(ElementName="GfsPolicyInfo")] 
	public GfsPolicyInfo GfsPolicyInfo; 

	[XmlElement(ElementName="StatisticsInfo")] 
	public StatisticsInfo StatisticsInfo; 

	[XmlAttribute(AttributeName="CryptType")] 
	public int CryptType; 

	[XmlAttribute(AttributeName="CryptId")] 
	public string CryptId; 

	[XmlAttribute(AttributeName="ConfigId")] 
	public string ConfigId; 

	[XmlAttribute(AttributeName="JobName")] 
	public string JobName; 

	[XmlAttribute(AttributeName="JobDesc")] 
	public object JobDesc; 

	[XmlAttribute(AttributeName="PolicyJobName")] 
	public object PolicyJobName; 

	[XmlAttribute(AttributeName="JobMode")] 
	public int JobMode; 

	[XmlAttribute(AttributeName="IsDisabledByPolicy")] 
	public bool IsDisabledByPolicy; 
}

[XmlRoot(ElementName="Key")]
public class Key { 

	[XmlAttribute(AttributeName="Hint")] 
	public object Hint; 

	[XmlAttribute(AttributeName="Password")] 
	public string Password; 
}

[XmlRoot(ElementName="Header")]
public class Header { 

	[XmlAttribute(AttributeName="Subject")] 
	public string Subject; 

	[XmlAttribute(AttributeName="From")] 
	public string From; 

	[XmlAttribute(AttributeName="To")] 
	public string To; 
}

[XmlRoot(ElementName="Conditions")]
public class Conditions { 

	[XmlAttribute(AttributeName="Success")] 
	public bool Success; 

	[XmlAttribute(AttributeName="Warning")] 
	public bool Warning; 

	[XmlAttribute(AttributeName="Failure")] 
	public bool Failure; 
}

[XmlRoot(ElementName="Smtp")]
public class Smtp { 

	[XmlElement(ElementName="Credentials")] 
	public Credentials Credentials; 

	[XmlAttribute(AttributeName="Server")] 
	public string Server; 

	[XmlAttribute(AttributeName="Port")] 
	public int Port; 

	[XmlAttribute(AttributeName="SecureConnection")] 
	public bool SecureConnection; 
}

[XmlRoot(ElementName="EmailReport")]
public class EmailReport { 

	[XmlElement(ElementName="Header")] 
	public Header Header; 

	[XmlElement(ElementName="Conditions")] 
	public Conditions Conditions; 

	[XmlElement(ElementName="Smtp")] 
	public Smtp Smtp; 

	[XmlAttribute(AttributeName="Notification")] 
	public bool Notification; 
}

[XmlRoot(ElementName="Throttling")]
public class Throttling { 

	[XmlAttribute(AttributeName="LimitBandwith")] 
	public bool LimitBandwith; 

	[XmlAttribute(AttributeName="SpeedLimit")] 
	public int SpeedLimit; 

	[XmlAttribute(AttributeName="SpeedUnit")] 
	public int SpeedUnit; 

	[XmlAttribute(AttributeName="DisableBackupOverMeteredConnection")] 
	public bool DisableBackupOverMeteredConnection; 

	[XmlAttribute(AttributeName="RestrictVPNConnections")] 
	public bool RestrictVPNConnections; 

	[XmlAttribute(AttributeName="RestrictWiFiNetworks")] 
	public bool RestrictWiFiNetworks; 
}

[XmlRoot(ElementName="ApplicationSettings")]
public class ApplicationSettings { 

	[XmlElement(ElementName="EmailReport")] 
	public EmailReport EmailReport; 

	[XmlElement(ElementName="Throttling")] 
	public Throttling Throttling; 

	[XmlAttribute(AttributeName="CryptType")] 
	public int CryptType; 

	[XmlAttribute(AttributeName="CryptId")] 
	public string CryptId; 

	[XmlAttribute(AttributeName="CheckUpdates")] 
	public bool CheckUpdates; 

	[XmlAttribute(AttributeName="DisableScheduledBackups")] 
	public bool DisableScheduledBackups; 

	[XmlAttribute(AttributeName="DisableControlPanelNotification")] 
	public bool DisableControlPanelNotification; 

	[XmlAttribute(AttributeName="ThrottleBackupActivity")] 
	public bool ThrottleBackupActivity; 

	[XmlAttribute(AttributeName="ShowBackupDuration")] 
	public bool ShowBackupDuration; 

	[XmlAttribute(AttributeName="DisableWakeupTimers")] 
	public bool DisableWakeupTimers; 

	[XmlAttribute(AttributeName="LockDownMode")] 
	public bool LockDownMode; 

	[XmlAttribute(AttributeName="ServiceProviderMode")] 
	public bool ServiceProviderMode; 

	[XmlAttribute(AttributeName="LastCheckForUpdates")] 
	public DateTime LastCheckForUpdates; 

	[XmlAttribute(AttributeName="LogoText")] 
	public string LogoText; 

	[XmlAttribute(AttributeName="EnableUserFlr")] 
	public bool EnableUserFlr; 
}

[XmlRoot(ElementName="Data")]
public class Data { 

	[XmlElement(ElementName="JobInfo")] 
	public List<JobInfo> JobInfo; 

	[XmlElement(ElementName="ApplicationSettings")] 
	public ApplicationSettings ApplicationSettings; 
}

[XmlRoot(ElementName="ExecutionResult")]
public class ExecutionResult { 

	[XmlElement(ElementName="Data")] 
	public Data Data; 

	[XmlElement(ElementName="AmMessages")] 
	public object AmMessages; 

	[XmlAttribute(AttributeName="Version")] 
	public string Version; 
}

```