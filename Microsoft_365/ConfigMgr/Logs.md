<sub>[back](./README.md)</sub>

- [SCCM Log File Reference](#sccm-log-file-reference)
  - [Locating log files](#locating-log-files)
  - [Client log files](#client-log-files)
    - [**Client operations**](#client-operations)
    - [**Client installation**](#client-installation)
    - [**Client for Mac computers**](#client-for-mac-computers)
  - [Server log files](#server-log-files)
    - [**Site server and site systems**](#site-server-and-site-systems)
    - [**Site server installation**](#site-server-installation)
    - [**Data warehouse service point**](#data-warehouse-service-point)
    - [**Fallback status point**](#fallback-status-point)
    - [**Management point**](#management-point)
    - [**Service connection point**](#service-connection-point)
    - [**Software update point**](#software-update-point)
    - [**Log files by functionality**](#log-files-by-functionality)
    - [**Application management**](#application-management)
    - [**Packages and programs**](#packages-and-programs)
    - [**Asset Intelligence**](#asset-intelligence)
    - [**Backup and recovery**](#backup-and-recovery)
    - [**Certificate enrollment**](#certificate-enrollment)
    - [**Client notification**](#client-notification)
    - [**Cloud management gateway**](#cloud-management-gateway)


# SCCM Log File Reference

In Configuration Manager, client and site server components record process information in individual log files. You can use the information in these log files to help you troubleshoot issues that might occur. By default, Configuration Manager enables logging for client and server components.

## Locating log files

Configuration Manager and dependent components store log files in 
various locations. These locations depend on the process that creates 
the log file and the configuration of your environment.

The following locations are the defaults. If you customized the 
installation directories in your environment, the actual paths may vary.

- Client: `C:\Windows\CCM\logs`
- Server: `C:\Program Files\Microsoft Configuration Manager\Logs`
- Management point: `C:\SMS_CCM\Logs`
- Configuration Manager console: `C:\Program Files (x86)\Microsoft Endpoint Manager\AdminConsole\AdminUILog`
- IIS: `C:\inetpub\logs\logfiles\w3svc1`

## Client log files

The following sections list the log files related to client operations and client installation.

### **Client operations**

The following table lists the log files located on the Configuration Manager client.

| Log name | Description |
| --- | --- |
| ADALOperationProvider.log | Information about client authentication token requests with Azure Active Directory (Azure AD) Authentication Library (ADAL). (Replaced by CcmAad.log starting in version 2107) |
| ATPHandler.log | Records details about handling ATP Onboarding and policies. |
| BitLockerManagementHandler.log | Records information about BitLocker management policies. |
| CAS.log | The Content Access service. Maintains the local package cache on the client. |
| Ccm32BitLauncher.log | Records actions for starting applications on the client marked *run as 32 bit*. |
| CcmEval.log | Records Configuration Manager client status evaluation activities and details for components that are required by the Configuration Manager client. |
| CcmEvalTask.log | Records the Configuration Manager client status evaluation activities that are initiated by the evaluation scheduled task. |
| CcmExec.log | Records activities of the client and the SMS Agent Host service. This log file also includes information about enabling and disabling wake-up proxy. |
| CcmMessaging.log | Records activities related to communication between the client and management points. |
| CCMNotificationAgent.log | Records activities related to client notification operations. |
| Ccmperf.log | Records activities related to the maintenance and capture of data related to client performance counters. |
| CcmRestart.log | Records client service restart activity. |
| CCMSDKProvider.log | Records activities for the client SDK interfaces. |
| ccmsqlce.log | Records activities for the built-in version of SQL Server Compact Edition (CE) that the client uses. This log is typically only used when you enable debug logging, or there's a problem with the component. The client health task (ccmeval) usually self-corrects problems with this component. |
| CcmUsrCse.log | Records details during user sign on for folder redirection policies. |
| CCMVDIProvider.log | Records information for clients in a virtual desktop infrastructure (VDI). |
| CertEnrollAgent.log | Records information for Windows Hello for Business. Specifically 
communication with the Network Device Enrollment Service (NDES) for 
certificate requests using the Simple Certificate Enrollment Protocol 
(SCEP). |
| CertificateMaintenance.log | Maintains certificates for Active Directory Domain Services and management points. |
| CIAgent.log | Records details about the process of remediation and compliance for compliance settings, software updates, and application management. |
| CIDownloader.log | Records details about configuration item definition downloads. |
| CIStateStore.log | Records changes in state for configuration items, such ascompliance settings, software updates, and applications. |
| CIStore.log | Records information about configuration items, such as compliance settings, software updates, and applications. |
| CITaskMgr.log | Records tasks for each application and deployment type, such as content download and install or uninstall actions. |
| ClientAuth.log | Records signing and authentication activity for the client. |
| ClientIDManagerStartup.log | Creates and maintains the client GUID and identifies tasks during client registration and assignment. |
| ClientLocation.log | Records tasks that are related to client site assignment. |
| ClientServicing.log | Records information for client deployment state messages during auto-upgrade and client piloting. |
| CMBITSManager.log | Records information for Background Intelligent Transfer Service (BITS) jobs on the device. |
| CMHttpsReadiness.log | Records the results of running the Configuration Manager HTTPS Readiness Assessment Tool. This tool checks whether computers have a public key infrastructure (PKI) client authentication certificate that can be used with Configuration Manager. |
| CmRcService.log | Records information for the remote control service. |
| CoManagementHandler.log | Use to troubleshoot co-management on the client. |
| ComplRelayAgent.log | Records information for the co-management workload for compliance policies. |
| ContentTransferManager.log | Schedules the Background Intelligent Transfer Service (BITS) or Server Message Block (SMB) to download or access packages. |
| DataTransferService.log | Records all BITS communication for policy or package access. |
| DCMAgent.log | Records high-level information about the evaluation, conflict reporting, and remediation of configuration items and applications. |
| DCMReporting.log | Records information about reporting policy platform results into state messages for configuration items. |
| DcmWmiProvider.log | Records information about reading configuration item synclets from WMI. |
| DeltaDownload.log | Records information about the download of express updates and updates downloaded using Delivery Optimization. |
| Diagnostics.log | Records the status of client diagnostic actions. |
| EndpointProtectionAgent | Records information about the installation of the System Center Endpoint Protection client and the application of antimalware policy to that client. |
| execmgr.log | Records details about packages and task sequences that run on the client. |
| ExpressionSolver.log | Records details about enhanced detection methods that are used when verbose or debug logging is turned on. |
| ExternalEventAgent.log | Records the history of Endpoint Protection malware detection and events related to client status. |
| FileBITS.log | Records all SMB package access tasks. |
| FileSystemFile.log | Records the activity of the Windows Management Instrumentation (WMI) provider for software inventory and file collection. |
| FSPStateMessage.log | Records the activity for state messages that are sent to the fallback status point by the client. |
| InternetProxy.log | Records the network proxy configuration and use activity for the client. |
| InventoryAgent.log | Records activities of hardware inventory, software inventory, and heartbeat discovery actions on the client. |
| InventoryProvider.log | More details about hardware inventory, software inventory, and heartbeat discovery actions on the client. |
| LocationCache.log | Records the activity for location cache use and maintenance for the client. |
| LocationServices.log | Records the client activity for locating management points, software update points, and distribution points. |
| MaintenanceCoordinator.log | Records the activity for general maintenance tasks for the client. |
| Mifprovider.log | Records the activity of the WMI provider for Management Information Format (MIF) files. |
| mtrmgr.log | Monitors all software metering processes. |
| PolicyAgent.log | Records requests for policies made by using the Data Transfer Service. |
| PolicyAgentProvider.log | Records policy changes. |
| PolicyEvaluator.log | Records details about the evaluation of policies on client computers, including policies from software updates. |
| PolicyPlatformClient.log | Records the process of remediation and compliance for all providers located in \Program Files\Microsoft Policy Platform, except the file provider. |
| PolicySdk.log | Records activities for policy system SDK interfaces. |
| Pwrmgmt.log | Records information about enabling or disabling and configuring the wake-up proxy client settings. |
| PwrProvider.log | Records the activities of the power management provider (PWRInvProvider) hosted in the WMI service. On all supported versions of Windows, the provider enumerates the current settings on computers during hardware inventory and applies power plan settings. |
| SCClient_<*domain*>@<*username*>_1.log | Records the activity in Software Center for the specified user on the client computer. |
| SCClient_<*domain*>@<*username*>_2.log | Records the historical activity in Software Center for the specified user on the client computer. |
| Scheduler.log | Records activities of scheduled tasks for all client operations. |
| SCNotify_<*domain*>@<*username*>_1.log | Records the activity for notifying users about software for the specified user. |
| SCNotify_<*domain*>@<*username*>_1-<*date_time*>.log | Records the historical information for notifying users about software for the specified user. |
| Scripts.log | Records the activity of when Configuration Manager scripts run on the client. |
| SensorWmiProvider.log | Records the activity of the WMI provider for the endpoint analytics sensor. |
| SensorEndpoint.log | Records the execution of endpoint analytics policy and upload of client data to the site server. |
| SensorManagedProvider.log | Records the gathering and processing of events and information for endpoint analytics. |
| setuppolicyevaluator.log | Records configuration and inventory policy creation in WMI. |
| SleepAgent_<*domain*>@SYSTEM_0.log | The main log file for wake-up proxy. |
| SmsClientMethodProvider.log | Records activity for sending client schedules. For example, with the Send Schedule tool or other programmatic methods. |
| smscliui.log | Records use of the Configuration Manager client in Control Panel. |
| SrcUpdateMgr.log | Records activity for installed Windows Installer applications that are updated with current distribution point source locations. |
| StateMessageProvider.log | Records information for the component that sends state messages from the client to the site. |
| StatusAgent.log | Records status messages that are created by the client components. |
| SWMTRReportGen.log | Generates a use data report that is collected by the metering agent. This data is logged in Mtrmgr.log. |
| UserAffinity.log | Records details about user device affinity. |
| UserAffinityProvider.log | Technical details from the component that tracks user device affinity. |
| VirtualApp.log | Records information specific to the evaluation of Application Virtualization (App-V) deployment types. |
| Wedmtrace.log | Records operations related to write filters on Windows Embedded clients. |
| wakeprxy-install.log | Records installation information when clients receive the client setting option to turn on wake-up proxy. |
| wakeprxy-uninstall.log | Records information about uninstalling wake-up proxy when clients receive the client setting option to turn off wake-up proxy, if wake-up proxy was previously turned on. |

### **Client installation**

The following table lists the log files that contain information 
related to the installation of the Configuration Manager client.

| Log name | Description |
| --- | --- |
| ccmsetup.log | Records ccmsetup.exe tasks for client setup, client upgrade, and client removal. Can be used to troubleshoot client installation problems. |
| ccmsetup-ccmeval.log | Records ccmsetup.exe tasks for client status and remediation. |
| CcmRepair.log | Records the repair activities of the client agent. |
| client.msi.log | Records setup tasks done by client.msi. Can be used to troubleshoot client installation or removal problems. |
| ClientServicing.log | Records information for client deployment state messages during auto-upgrade and client piloting. |

### **Client for Mac computers**

The Configuration Manager client for Mac computers records information in the following log files on the Mac computer:

| Log name | Details | Location |
| --- | --- | --- |
| CCMClient-<*date_time*>.log | Records activities that are related to the Mac client operations, including application management, inventory, and error logging. | `/Library/Application Support/Microsoft/CCM/Logs` |
| CCMAgent-<*date_time*>.log | Records information that is related to client operations, including user sign in and sign out operations, and Mac computer activity. | `~/Library/Logs` |
| CCMNotifications-<*date_time*>.log | Records activities that are related to Configuration Manager notifications displayed on the Mac computer. | `~/Library/Logs` |
| CCMPrefPane-<*date_time*>.log | Records activities related to the Configuration Manager preferences dialog box on the Mac computer, which includes general status and error logging. | `~/Library/Logs` |

The log file **SMS_DM.log** on the site system server 
also records communication between Mac computers and the management 
point that is set up for mobile devices and Mac computers.

## Server log files

The following sections list log files that are on the site server or that are related to specific site system roles.

### **Site server and site systems**

The following table lists the log files that are on the Configuration Manager site server and site system servers.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| adctrl.log | Records enrollment processing activity. | Site server |
| ADForestDisc.log | Records Active Directory Forest Discovery actions. | Site server |
| adminservice.log | Records actions for the SMS Provider administration service REST API | Computer with the SMS Provider |
| ADService.log | Records account creation and security group details in Active Directory. | Site server |
| adsgdis.log | Records Active Directory Group Discovery actions. | Site server |
| adsysdis.log | Records Active Directory System Discovery actions. | Site server |
| adusrdis.log | Records Active Directory User Discovery actions. | Site server |
| BusinessAppProcessWorker.log | Records processing for Microsoft Store for Business apps. | Site server |
| ccm.log | Records activities for client push installation. | Site server |
| CertMgr.log | Records certificate activities for intrasite communication. | Site system server |
| chmgr.log | Records activities of the client health manager. | Site server |
| Cidm.log | Records changes to the client settings by the Client Install Data Manager (CIDM). | Site server |
| colleval.log | Records details about when collections are created, changed, and deleted by the Collection Evaluator. | Site server |
| compmon.log | Records the status of component threads monitored for the site server. | Site system server |
| compsumm.log | Records Component Status Summarizer tasks. | Site server |
| ComRegSetup.log | Records the initial installation of COM registration results for a site server. | Site system server |
| dataldr.log | Records information about the processing of MIF files and hardware inventory in the Configuration Manager database. | Site server |
| ddm.log | Records activities of the discovery data manager. | Site server |
| despool.log | Records incoming site-to-site communication transfers. | Site server |
| distmgr.log | Records details about package creation, compression, delta replication, and information updates. It can also include other activities from the distribution manager component. For example, installing a distribution point, connection attempts, and installing components. For more information on other functionality that uses this log, see [Service connection point](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/hierarchy/log-files#BKMK_WITLog) and [OS deployment](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/hierarchy/log-files#BKMK_OSDLog). | Site server |
| EPCtrlMgr.log | Records information about the syncing of malware threat information from the Endpoint Protection site system role server with the Configuration Manager database. | Site server |
| EPMgr.log | Records the status of the Endpoint Protection site system role. | Site system server |
| EPSetup.log | Provides information about the installation of the Endpoint Protection site system role. | Site system server |
| EnrollSrv.log | Records activities of the enrollment service process. | Site system server |
| EnrollWeb.log | Records activities of the enrollment website process. | Site system server |
| ExternalNotificationsWorker.log | Records the queue and activities for notifications to external systems like Azure Logic Apps. | Site server |
| fspmgr.log | Records activities of the fallback status point site system role. | Site system server |
| hman.log | Records information about site configuration changes, and about the publishing of site information in Active Directory Domain Services. | Site server |
| Inboxast.log | Records the files that are moved from the management point to the corresponding INBOXES folder on the site server. | Site server |
| inboxmgr.log | Records file transfer activities between inbox folders. | Site server |
| inboxmon.log | Records the processing of inbox files and performance counter updates. | Site server |
| invproc.log | Records the forwarding of MIF files from a secondary site to its parent site. | Site server |
| migmctrl.log | Records information for Migration actions that involve migration 
jobs, shared distribution points, and distribution point upgrades. | Top-level site in the Configuration Manager hierarchy, and each child primary site. In a multi-primary site hierarchy, use the log file that is created at the central administration site. |
| mpcontrol.log | Records the registration of the management point. Records the availability of the management point every 10 minutes. | Site system server |
| mpfdm.log | Records the actions of the management point component that moves client files to the corresponding INBOXES folder on the site server. | Site system server |
| mpMSI.log | Records details about the management point installation. | Site server |
| MPSetup.log | Records the management point installation wrapper process. | Site server |
| netdisc.log | Records Network Discovery actions. | Site server |
| NotiCtrl.log | Application request notifications. | Site server |
| ntsvrdis.log | Records the discovery activity of site system servers. | Site server |
| Objreplmgr | Records the processing of object change notifications for replication. | Site server |
| offermgr.log | Records advertisement updates. | Site server |
| offersum.log | Records the summarization of deployment status messages. | Site server |
| OfflineServicingMgr.log | Records the activities of applying updates to operating system image files. | Site server |
| outboxmon.log | Records the processing of outbox files and performance counter updates. | Site server |
| PerfSetup.log | Records the results of the installation of performance counters. | Site system server |
| PkgXferMgr.log | Records the actions of the SMS_Executive component that is responsible for sending content from a primary site to a remote distribution point. | Site server |
| policypv.log | Records updates to the client policies to reflect changes to client settings or deployments. | Primary site server |
| rcmctrl.log | Records the activities of database replication between sites in the hierarchy. | Site server |
| replmgr.log | Records the replication of files between the site server components and the Scheduler component. | Site server |
| ResourceExplorer.log | Records errors, warnings, and information about running Resource Explorer. | Computer that runs the Configuration Manager console |
| RESTPROVIDERSetup.log | Installation of the SMS Provider administration service REST API | Computer with the SMS Provider |
| ruleengine.log | Records details about automatic deployment rules for the identification, content download, and software update group and deployment creation. | Site server |
| SCCMReporting.log | Records details about RBAC checks and resource loads when reports are run. | Site system server |
| schedule.log | Records details about site-to-site job and file replication. | Site server |
| sender.log | Records the files that transfer by file-based replication between sites. | Site server |
| sinvproc.log | Records information about the processing of software inventory data to the site database. | Site server |
| sitecomp.log | Records details about the maintenance of the installed site components on all site system servers in the site. | Site server |
| sitectrl.log | Records site setting changes made to site control objects in the database. | Site server |
| sitestat.log | Records the availability and disk space monitoring process of all site systems. | Site server |
| SMS_AZUREAD_DISCOVERY_AGENT.log | Log file for Microsoft Entra user and user group discovery. | Site server |
| SMS_BUSINESS_APP_PROCESS_MANAGER.log | Log file for component that synchronizes apps from the Microsoft Store for Business. | Site server |
| SMS_DataEngine.log | Log file for management insights. | Site server |
| SMS_ISVUPDATES_SYNCAGENT.log | Log file for synchronization of third-party software updates. | Top-level software update point in the Configuration Manager hierarchy. |
| SMS_MESSAGE_PROCESSING_ENGINE.log | Log file for the message processing engine, which the site uses to 
process results for client actions. For example, run scripts and 
CMPivot. | Site server |
| SMS_OrchestrationGroup.log | Log file for orchestration groups | Site server |
| SMS_PhasedDeployment.log | Log file for phased deployments | Top-level site in the Configuration Manager hierarchy |
| SMS_REST_PROVIDER.log | Service health state for the SMS Provider administration service REST API, including certificate information | Computer with the SMS Provider |
| SmsAdminUI.log | Records Configuration Manager console activity. | Computer that runs the Configuration Manager console |
| smsbkup.log | Records output from the site backup process. | Site server |
| smsdbmon.log | Records database changes. | Site server |
| SMSENROLLSRVSetup.log | Records the installation activities of the enrollment web service. | Site system server |
| SMSENROLLWEBSetup.log | Records the installation activities of the enrollment website. | Site system server |
| smsexec.log | Records the processing of all site server component threads. | Site server or site system server |
| SMSFSPSetup.log | Records messages generated by the installation of a fallback status point. | Site system server |
| SMSProv.log | Records WMI provider access to the site database. | Computer with the SMS Provider |
| srsrpMSI.log | Records detailed results of the reporting point installation process from the MSI output. | Site system server |
| srsrpsetup.log | Records results of the reporting point installation process. | Site system server |
| statesys.log | Records the processing of state system messages. | Site server |
| statmgr.log | Records the writing of all status messages to the database. | Site server |
| swmproc.log | Records the processing of metering files and settings. | Site server |

### **Site server installation**

The following table lists the log files that contain information related to site installation.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| ConfigMgrPrereq.log | Records prerequisite component evaluation and installation activities. | Site server |
| ConfigMgrSetup.log | Records detailed output from the site server setup. | Site Server |
| ConfigMgrSetupWizard.log | Records information related to activity in the Setup Wizard. | Site Server |
| SMS_BOOTSTRAP.log | Records information about the progress of launching the secondary site installation process. Details of the actual setup process are contained in ConfigMgrSetup.log. | Site Server |
| smstsvc.log | Records information about the installation, use, and removal of a Windows service. Windows uses this service to test network connectivity and permissions between servers. It uses the computer account of the server that creates the connection. | Site server and site system server |

### **Data warehouse service point**

The following table lists the log files that contain information related to the data warehouse service point.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| DWSSMSI.log | Records messages generated by the installation of a data warehouse service point. | Site system server |
| DWSSSetup.log | Records messages generated by the installation of a data warehouse service point. | Site system server |
| Microsoft.ConfigMgrDataWarehouse.log | Records information about data synchronization between the site database and the data warehouse database. | Site system server |

### **Fallback status point**

The following table lists the log files that contain information related to the fallback status point.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| FspIsapi | Records details about communications to the fallback status point from mobile device legacy clients and client computers. | Site system server |
| fspMSI.log | Records messages generated by the installation of a fallback status point. | Site system server |
| fspmgr.log | Records activities of the fallback status point site system role. | Site system server |

### **Management point**

The following table lists the log files that contain information related to the management point.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| CcmIsapi.log | Records client messaging activity on the endpoint. | Site system server |
| CCM_STS.log | Records activities for authentication tokens, either from Microsoft Entra ID or site-issued client tokens. | Site system server |
| ClientAuth.log | Records signing and authentication activity. | Site system server |
| MP_CliReg.log | Records the client registration activity processed by the management point. | Site system server |
| MP_Ddr.log | Records the conversion of XML.ddr records from clients, and then copies them to the site server. | Site system server |
| MP_Framework.log | Records the activities of the core management point and client framework components. | Site system server |
| MP_GetAuth.log | Records client authorization activity. | Site system server |
| MP_GetPolicy.log | Records policy request activity from client computers. | Site system server |
| MP_Hinv.log | Records details about the conversion of XML hardware inventory 
records from clients and the copy of those files to the site server. | Site system server |
| MP_Location.log | Records location request and reply activity from clients. | Site system server |
| MP_OOBMgr.log | Records the management point activities related to receiving an OTP from a client. | Site system server |
| MP_Policy.log | Records policy communication. | Site system server |
| MP_RegistrationManager.log | Records activities related to client registration, such as validating certificates, CRL, and tokens. | Site system server |
| MP_Relay.log | Records the transfer of files that are collected from the client. | Site system server |
| MP_RelayMsgMgr.log | Records how the management point handles incoming client messages, such as for scripts or CMPivot. | Site system server |
| MP_Retry.log | Records hardware inventory retry processes. | Site system server |
| MP_Sinv.log | Records details about the conversion of XML software inventory 
records from clients and the copy of those files to the site server. | Site system server |
| MP_SinvCollFile.log | Records details about file collection. | Site system server |
| MP_Status.log | Records details about the conversion of XML.svf status message files
 from clients and the copy of those files to the site server. | Site system server |
| mpcontrol.log | Records the registration of the management point. Records the availability of the management point every 10 minutes. | Site server |
| mpfdm.log | Records the actions of the management point component that moves 
client files to the corresponding INBOXES folder on the site server. | Site system server |
| mpMSI.log | Records details about the management point installation. | Site server |
| MPSetup.log | Records the management point installation wrapper process. | Site server |
| UserService.log | Records user requests from Software Center, retrieving/installing user-available applications from the server. | Site system server |

### **Service connection point**

The following table lists the log files that contain information related to the service connection point.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| CertMgr.log | Records certificate and proxy account information. | Site server |
| CollectionAADGroupSyncWorker.log | Log file for synchronization of collection membership results to Microsoft Entra ID. | Computer with the service connection point |
| SMS_AZUREAD_DISCOVERY_AGENT.log | Starting 2303, log file for synchronization of collection membership results to Microsoft Entra ID. | Computer with the service connection point |
| CollEval.log | Records details about when collections are created, changed, and deleted by the Collection Evaluator. | Primary site and central administration site |
| Cloudusersync.log | Records license enablement for users. | Computer with the  service connection point |
| Dataldr.log | Records information about the processing of MIF files. | Site server |
| ddm.log | Records activities of the discovery data manager. | Site server |
| Distmgr.log | Records details about content distribution requests. | Top-level site server |
| Dmpdownloader.log | Records details about downloads from Microsoft, such as site updates. | Computer with the service connection point |
| Dmpuploader.log | Records detail related to uploading database changes to Microsoft. | Computer with the service connection point |
| EndpointConnectivityCheckWorker.log | Records detail related to checks for important internet endpoints. | Computer with the service connection point |
| hman.log | Records information about message forwarding. | Site server |
| WsfbSyncWorker.log | Records information about the communication with the Microsoft Store for Business. | Computer with the service connection point |
| objreplmgr.log | Records the processing of policy and assignment. | Primary site server |
| PolicyPV.log | Records policy generation of all policies. | Site server |
| outgoingcontentmanager.log | Records content uploaded to Microsoft. | Computer with the service connection point |
| ServiceConnectionTool.log | Records details about use of the [service connection tool](https://learn.microsoft.com/en-us/intune/configmgr/core/servers/manage/use-the-service-connection-tool) based on the parameter you use. Each time you run the tool, it replaces any existing log file. | Same location as the tool |
| Sitecomp.log | Records details of service connection point installation. | Site server |
| SmsAdminUI.log | Records Configuration Manager console activity. | Computer that runs the Configuration Manager console |
| SMS_CLOUDCONNECTION.log | Records information about cloud services. | Computer with the service connection point |
| Smsprov.log | Records activities of the SMS Provider. Configuration Manager console activities use the SMS Provider. | Computer with the SMS Provider |
| SrvBoot.log | Records details about the service connection point installer service. | Computer with the service connection point |
| Statesys.log | Records the processing of mobile device management messages. | Primary site and central administration site |
| UXAnalyticsUploadWorker.log | Records data upload to the service for endpoint analytics. | Computer with the service connection point |

### **Software update point**

The following table lists the log files that contain information related to the software update point.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| objreplmgr.log | Records details about the replication of software updates notification files from a parent site to child sites. | Site server |
| PatchDownloader.log | Records details about the process of downloading software updates 
from the update source to the download destination on the site server. | When you manually download updates, this file is in your `%temp%` directory on the computer where you use the console. For automatic deployment rules, if the Configuration Manager client is installed on the site server, this file is on the site server in `%windir%\CCM\Logs`. |
| ruleengine.log | Records details about automatic deployment rules for the identification, content download, and software update group and deployment creation. | Site server |
| SMS_ISVUPDATES_SYNCAGENT.log | Log file for synchronization of third-party software updates. | Top-level software update point in the Configuration Manager hierarchy. |
| SUPSetup.log | Records details about the software update point installation. When the software update point installation completes, **Installation was successful** is written to this log file. | Site system server |
| WCM.log | Records details about the software update point configuration and connections to the WSUS server for subscribed update categories, classifications, and languages. | Site server that connects to the WSUS server |
| WSUSCtrl.log | Records details about the configuration, database connectivity, and health of the WSUS server for the site. | Site system server |
| wsyncmgr.log | Records details about the software updates sync process. | Site system server |
| WUSSyncXML.log | Records details about the Inventory Tool for the Microsoft Updates sync process. | Client computer configured as the sync host for the Inventory Tool for Microsoft Updates |

### **Log files by functionality**

The following sections list log files related to Configuration Manager functions.

### **Application management**

The following table lists the log files that contain information related to application management.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| AppIntentEval.log | Records details about the current and intended state of applications, their applicability, whether requirements were met, deployment types, and dependencies. | Client |
| AppDiscovery.log | Records details about the discovery or detection of applications on client computers. | Client |
| AppEnforce.log | Records details about enforcement actions (install and uninstall) taken for applications on the client. | Client |
| AppGroupHandler.log | Records detection and enforcement information for application groups | Client |
| BusinessAppProcessWorker.log | Records processing for Microsoft Store for Business apps. | Site server |
| Ccmsdkprovider.log | Records the activities of the application management SDK. | Client |
| colleval.log | Records details about when collections are created, changed, and deleted by the Collection Evaluator. | Site system server |
| WsfbSyncWorker.log | Records information about the communication with the Microsoft Store for Business. | Computer with the service connection point |
| NotiCtrl.log | Application request notifications. | Site server |
| PrestageContent.log | Records details about the use of the ExtractContent.exe tool on a remote, prestaged distribution point. This tool extracts content that has been exported to a file. | Site system server |
| SettingsAgent.log | Enforcement of specific applications, records orchestration of 
application group evaluation, and details of co-management policies. | Client |
| SMS_BUSINESS_APP_PROCESS_MANAGER.log | Log file for component that synchronizes apps from the Microsoft Store for Business. | Site server |
| SMS_CLOUDCONNECTION.log | Records information about cloud services. | Computer with the service connection point |
| SMS_ImplicitUninstall.log | Records events from the implicit uninstall background worker process. | Site server |
| SMSdpmon.log | Records details about the distribution point health monitoring scheduled task that is configured on a distribution point. | Site server |
| SoftwareCenterSystemTasks.log | Records activities related to Software Center prerequisite component validation. | Client |
| TSDTHandler.log | For the task sequence deployment type. It logs the process from app enforcement (install or uninstall) to the launch of the task sequence. Use it with AppEnforce.log and smsts.log. | Client |

### **Packages and programs**

The following table lists the log files that contain information related to deploying packages and programs.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| colleval.log | Records details about when collections are created, changed, and deleted by the Collection Evaluator. | Site server |
| execmgr.log | Records details about packages and task sequences that run. | Client |

### **Asset Intelligence**

The following table lists the log files that contain information related to Asset Intelligence.

| Log Name | Description | Computer with log file |
| --- | --- | --- |
| AssetAdvisor.log | Records the activities of Asset Intelligence inventory actions. | Client |
| aikbmgr.log | Records details about the processing of XML files from the inbox for updating the Asset Intelligence catalog. | Site server |
| AIUpdateSvc.log | Records the interaction of the Asset Intelligence sync point with the cloud service. | Site system server |
| AIUSMSI.log | Records details about the installation of the Asset Intelligence sync point site system role. | Site system server |
| AIUSSetup.log | Records details about the installation of the Asset Intelligence sync point site system role. | Site system server |
| ManagedProvider.log | Records details about discovering software with an associated 
software identification tag. Also records activities related to hardware
 inventory. | Site system server |
| MVLSImport.log | Records details about the processing of imported licensing files. | Site system server |

### **Backup and recovery**

The following table lists log files that contain information related 
to backup and recovery actions, including site resets, and changes to 
the SMS Provider.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| ConfigMgrSetup.log | Records information about setup and recovery tasks when Configuration Manager recovers a site from backup. | Site server |
| Smsbkup.log | Records details about the site backup activity. | Site server |
| smssqlbkup.log | Records output from the site database backup process when SQL Server is installed on a server that isn't the site server. | Site database server |
| Smswriter.log | Records information about the state of the Configuration Manager VSS writer that is used by the backup process. | Site server |

### **Certificate enrollment**

The following table lists the Configuration Manager log files that 
contain information related to certificate enrollment. Certificate 
enrollment uses the certificate registration point and the Configuration
 Manager Policy Module on the server that's running the Network Device 
Enrollment Service (NDES).

| Log name | Description | Computer with log file |
| --- | --- | --- |
| CertEnrollAgent.log | Records client communication with NDES for certificate requests using the Simple Certificate Enrollment Protocol (SCEP). | Windows Hello for Business client |
| Crp.log | Records enrollment activities. | Certificate registration point |
| Crpctrl.log | Records the operational health of the certificate registration point. | Certificate registration point |
| Crpsetup.log | Records details about the installation and configuration of the certificate registration point. | Certificate registration point |
| Crpmsi.log | Records details about the installation and configuration of the certificate registration point. | Certificate registration point |
| NDESPlugin.log | Records challenge verification and certificate enrollment activities. | Configuration Manager Policy Module and the Network Device Enrollment Service |

Along with the Configuration Manager log files, review the Windows 
Application logs in Event Viewer on the server running the Network 
Device Enrollment Service and the server hosting the certificate 
registration point. For example, look for messages from the **NetworkDeviceEnrollmentService** source.

You can also use the following log files:

- IIS log files for Network Device Enrollment Service: **%SYSTEMDRIVE%\inetpub\logs\LogFiles\W3SVC1**
- IIS log files for the certificate registration point: **%SYSTEMDRIVE%\inetpub\logs\LogFiles\W3SVC1**
- Network Device Enrollment Policy log file: **mscep.log**
    
    Note
    
    This file is located in the folder for the NDES account profile, for 
    example, in C:\Users\SCEPSvc. For more information about how to enable 
    NDES logging, see the [Enable Logging](https://social.technet.microsoft.com/wiki/contents/articles/9063.active-directory-certificate-services-ad-cs-network-device-enrollment-service-ndes.aspx#Enable_Logging) section of the NDES wiki.
    

### **Client notification**

The following table lists the log files that contain information related to client notification.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| bgbmgr.log | Records details about site server activities related to client notification tasks and processing online and task status files. | Site server |
| BGBServer.log | Records the activities of the notification server, such as client-server communication and pushing tasks to clients. Also records information about the generation of online and task status files to be sent to the site server. | Management point |
| BgbSetup.log | Records the activities of the notification server installation wrapper process during installation and uninstallation. | Management point |
| bgbisapiMSI.log | Records details about the notification server installation and uninstallation. | Management point |
| BgbHttpProxy.log | Records the activities of the notification HTTP proxy as it relays 
the messages of clients using HTTP to and from the notification server. | Client |
| CcmNotificationAgent.log | Records the activities of the notification agent, such as client-server communication and information about tasks received and dispatched to other client agents. | Client |

### **Cloud management gateway**

The following table lists the log files that contain information related to the cloud management gateway.

| Log name | Description | Computer with log file |
| --- | --- | --- |
| CloudMgr.log | Records details about deploying the cloud management gateway service, ongoing service status, and use data associated with the service. To configure the logging level, edit the **Logging level** value in the following registry key: `HKLM\SOFTWARE\ Microsoft\SMS\COMPONENTS\ SMS_CLOUD_ SERVICES_MANAGER` | The *installdir* folder on the primary site server or CAS. |
| CMGSetup.log [Note 1](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/hierarchy/log-files#bkmk_note1) | Records details about the second phase of the cloud management gateway deployment (local deployment in Azure). To configure the logging level, use the setting **Trace level** (**Information** (Default), **Verbose**, **Error**) on the **Azure portal\Cloud services configuration** tab. | The **%approot%\logs** on your Azure server, or the SMS/Logs folder on the site system server |
| CMGService.log [Note 1](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/hierarchy/log-files#bkmk_note1) | Records details about the cloud management gateway service core 
component in Azure. To configure the logging level, use the setting **Trace level** (**Information** (Default), **Verbose**, **Error**) on the **Azure portal\Cloud services configuration** tab. | The **%approot%\logs** on your Azure server, or the SMS/Logs folder on the site system server |
| SMS_Cloud_ProxyConnector.log | Records details about setting up connections between the cloud management gateway service and the cloud management gateway connection point. | Site system server |
| CMGContentService.log [Note 1](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/hierarchy/log-files#bkmk_note1) | When you enable a CMG to also serve content from Azure storage, this log records the details of that service. | The **%approot%\logs** on your Azure server, or the SMS/Logs folder on the site system server |

- For troubleshooting deployments, use **CloudMgr.log** and **CMGSetup.log**
- For troubleshooting service health, use **CMGService.log** and **SMS_Cloud_ProxyConnector.log**.
- For troubleshooting client traffic, use **CMGService.log** and **SMS_Cloud_ProxyConnector.log**.