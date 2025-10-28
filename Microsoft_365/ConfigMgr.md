# Deploying and Configuring Microsoft Configuration Manager (Current Branch) in a Hybrid Cloud Environment

This comprehensive guide provides step-by-step instructions to **deploy and configure Microsoft Configuration Manager (ConfigMgr/SCCM) Current Branch** in a hybrid cloud environment. We cover the entire process from a lab setup through a pilot (beta) deployment and finally to full production, in line with best practices for phased rollouts. The guide includes integration with **Active Directory** (AD) and **SQL Server**, and explains how to enable co-management with **Microsoft Entra ID** (formerly Azure AD) and **Intune** for cloud integration. Maintenance and operational tasks are also outlined to ensure your Configuration Manager environment runs smoothly after deployment.

- [Deploying and Configuring Microsoft Configuration Manager (Current Branch) in a Hybrid Cloud Environment](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)
  - [Planning and Prerequisites](#planning-and-prerequisites)
  - [Step-by-Step Deployment in a Lab Environment (Phase 1)](#step-by-step-deployment-in-a-lab-environment-phase-1)
  - [Integrating Entra ID and Intune for Co-Management](#integrating-entra-id-and-intune-for-co-management)
  - [Pilot Deployment (Phase 2): Rolling out to a Beta Group](#pilot-deployment-phase-2-rolling-out-to-a-beta-group)
  - [Full Production Deployment (Phase 3)](#full-production-deployment-phase-3)
  - [Ongoing Maintenance and Management](#ongoing-maintenance-and-management)
  - [Conclusion](#conclusion)

> Note: There is an optional checklist that follows this document [here](./ConfigMgr_Checklist.md)

## Planning and Prerequisites

Successful Configuration Manager deployment in a hybrid environment requires careful planning and preparation. **Infrastructure prerequisites** must be met on the server side, and certain configurations in Active Directory and SQL Server are required before installation. The table below summarizes key prerequisites and preparatory steps:


**Key Prerequisites and Preparations:**

| Component | Requirements / Actions |
| --- | --- |
| **Server OS** | Windows Server (2016 or later) for the site server. Ensure the OS is fully updated and supported by ConfigMgrComplete SCCM Installation Guide and Configuration. Install server roles/features like IIS, and .NET Framework (4.8 recommended). |
| **Active Directory** | AD **schema must be extended** for Configuration Manager (one-time per forest)Publishing and the Active Directory schema - Configuration Manager .... Use **extadsch.exe** from the ConfigMgr installation media to add new classes/attributesPublishing and the Active Directory schema - Configuration Manager .... Next, **create the System Management container** in AD and grant the site server’s computer account Full Control on itPublishing and the Active Directory schema - Configuration Manager ...+1. |
| **SQL Server** | Install a supported SQL Server (e.g., SQL Server 2019/2022) for the ConfigMgr site database. **Set the SQL instance and DB collation to *SQL_Latin1_General_CP1_CI_AS***, which is required by ConfigMgr. Allocate proper storage for the database and logs (follow SQL best practices such as using separate disks for DB files and logsComplete SCCM Installation Guide and Configuration). Ensure the SQL Server memory and CPU are sized for your expected client count. |
| **SCCM Service Accounts** | Create necessary domain accounts: e.g., a domain user for the SQL Server service (if not using local system) and accounts for Client Push installation, Network Access Account, etcComplete SCCM Installation Guide and Configuration. Add the site server’s machine account to the local Administrators on the SQL Server if remote, and ensure the site server computer account has permissions on the AD container as above. |
| **Windows ADK** | Download and install the **Windows Assessment and Deployment Kit (ADK)** (matching your Windows 10/11 version) and the WinPE add-on on the site server. The ADK is required for Operating System Deployment support (WinPE boot images) in ConfigMgr. |
| **Network and Firewall** | Assign a static IP to the site server and ensure reliable network connectivity. If firewalls are enabled, open required ports (e.g., SQL Server port 1433, ConfigMgr ports) on the site server and SQL ServerComplete SCCM Installation Guide and Configuration. Ensure name resolution (DNS) is working for all servers. |
| **Intune & Entra ID** | Obtain appropriate licenses: ConfigMgr co-management requires an Intune subscription and Entra ID P1/P2 (often included in EMS licenses)Tutorial: Enable co-management for existing clients <br/> Configuration: Set up **Microsoft Entra Connect** to synchronize identities between on-prem AD and Entra IDTutorial: Enable co-management for existing clients <br/> Configuration: This will enable **Hybrid Entra Join** for domain-joined computers (so devices exist in Entra ID and can be managed by Intune) |
| **WSUS** (optional) | The Windows Server Update Services are a required prerequisite for Config Manager. <br/> This role must be installed before Config Manager can be installed. This can be installed via `Add Roles and Features` in Server Manager. |
| **IIS** | <p>Internet Information Service is a required prerequisite and must be installed prior to Configuration Manager installation. This can be installed via `Add Roles and Features` in Server Manager. <br/>If planning on using HTTPS for client communications in Config Manager, enable HTTPS bindings in IIS and install a valid SSL certificate to the IIS server.</p> |
| **PKI** (If using Https for clients)| You can use any PKI to create, deploy, and manage most certificates in Configuration Manager. For client certificates that Configuration Manager enrolls on mobile devices and Mac computers, they require use of Active Directory Certificate Services. Ref: [PKI planning guide](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/security/plan-for-certificates#pki-client-certificate-selection). [Example of PKI Deployment](https://learn.microsoft.com/en-us/intune/configmgr/core/plan-design/network/example-deployment-of-pki-certificates#BKMK_webserver2008_cm2012).  |

Once these steps are completed, you can proceed with the Configuration Manager installation in a lab setting.

## Step-by-Step Deployment in a Lab Environment (Phase 1)  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>

In the lab phase, you'll perform a full installation of Configuration Manager on a controlled environment. This allows you to validate the setup process and ensure all components work before touching production data. Typically, the lab setup involves installing a stand-alone **Primary Site** (which will also be your primary site for production, migrated later or reinstalled in prod as needed). Below are the major steps:

**1. Extend Active Directory Schema and Prepare AD for ConfigMgr:**  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>

- Run the schema extension tool **`extadsch.exe`** from the ConfigMgr installation media (`SMSSETUP\BIN\X64\extadsch.exe`) using an account that is Schema Admin. 
  - This updates the schema with ConfigMgr classes. Verify it succeeded by checking **ExtADSch.log** on the root of C: (it should report "Successfully extended the Active Directory schema."). 
- Next, create the **System Management** container in AD (using ADSI Edit or Active Directory Users and Computers). 
  - In ADSI Edit, connect to the Domain naming context, and under the **System** container, create a new **Container** object named "System Management". Then right-click this container, go to **Security**, and give the site server’s computer account **Full Control** on "This object and all descendant objects". This lets ConfigMgr publish site information in AD, so clients can find it.Publishing and the Active Directory schema - Configuration Manager ...

**2. Install and Configure SQL Server:**  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>

- On the designated SQL Server (which can be the same as the site server for a simpler lab setup), install SQL Server using the required collation. 
  - **Important:** ensure the SQL instance **collation is `SQL_Latin1_General_CP1_CI_AS`** (the default for English US installs) because ConfigMgr setup will check for this prerequisite. If the collation is wrong, ConfigMgr will not install. 
  - If the SQL is local on the site server, it’s generally recommended for lab and even production for better performance (SCCM and SQL communicate frequently, and local installation can yield better throughput). 
- During SQL setup, enable the **SQL Server Reporting Services** feature if planning to use reporting. 
- After SQL install, configure the following: 
  - Enable the SQL Server Browser (if using named instance), and 
  - Ensure the service accounts are set properly (using the domain account if you created one for SQL service). ConfigMgr cannot run using a local account or NT AUTHORITY accounts, it must be set to a service, domain or user account.  
  - Set SQL server index memory allotment, change from 0 to 4096
  - Verify the firewall on the SQL server allows incoming on TCP 1433 (and 1434/UDP for browser if needed).
  - Verify the SQL server instance is listening on network addresses: 
    - Launch SQL Configuration Manager
    - Navigate to your SQL instance
    - Edit TCP/IP settings
      - Enable IP's as needed for your environment. Most commonly, localhost and current IP address of server. 
    - Disable use of dynamic ports (delete the 0 that is present), 
    - Set TCP port for SQL instance to 1433 (default).

**3. Install the ConfigMgr Primary Site (Lab):**  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>

With AD and SQL ready, run **Configuration Manager Setup** (launch `Splash.hta` or `Setup.exe` from the ConfigMgr media (`Setup.exe` is located within ConfigMgr media's location at `<Extracted Location>\cd.retail.LN\SMSSETUP\BIN\X64`)) on the site server. During the installation wizard:

- **Prerequisite Check**: The setup will prompt to run the prerequisite checker. Ensure all checks pass (including WSUS SDK, ADK availability, Windows roles, etc.). Common prerequisites include having .NET Framework installed and the Windows ADK installed for Deployment Tools and WinPE.
  - You can run `prereqchk.exe` prior to installation to ensure the PC meets the Prerequisites. `prereqchk.exe` is located in the extraced ConfigMgr files, `<Extracted Location>\cd.retail.LN\SMSSETUP\BIN\X64`
  - If prerequisite checks fail, the logs will have more detailed information on the cause of failure. Logs are located at `C:\ConfigMgrSetup.log`, scroll to the end of the file for the failure reason and most recent log lines. 
- **Site Configuration**: Choose **“Install a Configuration Manager Primary Site”** (since this is a new stand-alone primary). Assign a **Site Code** (three letters) and a site name. Select the **installation path** (ensure adequate disk space).
  - Site code must be 3 letters, no more, no less. 
- **SQL Server**: Provide the SQL Server name (and instance if not default) and confirm the SQL DB name (default CM_). The wizard will detect if the collation is correct.
- **Communications**: You can start with HTTP client communication for simplicity in a lab. If you plan to use HTTPS (PKI) or **Enhanced HTTP**, configure the PKI certificates or enable enhanced HTTP in site settings after installation.
  - For HTTPS, IIS must be configured to use HTTPS and have a valid SSL certificate. Doesn't require 3rd party validation, as long as the client machines trust the cert or CA. 
- **Intune/Entra Integration**: In the wizard’s cloud services page, you can skip **Cloud Attach** for now and configure co-management after the site is up. This is covered in more detail later: ([link](#integrating-entra-id-and-intune-for-co-management)). 
- **Client Settings**: Accept defaults (these can be changed later).
- Complete the installation and let ConfigMgr install all components. This can take some time as it sets up the database, site services, and initial configurations. Give it at least 20 minutes once installation starts. The process can still fail at this point, view the logs to determine the cause of failure. 

Once installation finishes, verify in the ConfigMgr **Console** that all site roles are installed (Administration > Site Configuration > Servers and Site System Roles). By default, the site server will have at least: **Site Server, Site Database Server, Management Point, and Distribution Point** roles. The **Management Point (MP)** allows client communication with the server, and the **Distribution Point (DP)** hosts content (applications, packages, OS images, updates, etc.) for clients. In a single-server setup, these roles are on the same machine.

**4. Post-Install Configuration in Lab:**  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>

After installation, perform basic configurations:

- In the ConfigMgr Console, configure **Discovery Methods** (Administration > Hierarchy Configuration > Discovery Methods) to enable Active Directory discovery for users, groups and devices as needed, so your domain clients can be discovered. Also enable the Active Directory Forest Discovery to populate boundaries from AD sites/subnets if your lab is domain-joined.
- Set up **Boundary Groups** for your network so that clients are associated with the correct site and DP. In a simple lab, you might define the AD site or IP subnet as a boundary and add it to a boundary group with the site server as a content source.
- If you plan to deploy the ConfigMgr **client to lab machines**, configure the **Client Push** account (Administration > Site Configuration > Sites > Client Installation Settings > Client Push Installation). Add the domain account that has local admin rights on client machines.
- To install clients manually launch powershell or CMD then navigate to  `\\<ConfigMgr_FQDN>\SMS_<SITE_CODE>\Client`  and execute `ccmsetup.exe`. A full list of manual install options can be found [here](https://learn.microsoft.com/en-us/intune/configmgr/core/clients/deploy/deploy-clients-to-windows-computers#BKMK_Manual). In most cases, the default options are all that is needed. 
- Optionally, **integrate WSUS** with ConfigMgr: install the WSUS role on the site server (or another server) and configure Software Update Point in ConfigMgr to handle patch management.
  - Configure **Software update point** (if WSUS installed), **Distribution point** (ensure it has the packages like client installation files, boot images distributed), etc., as needed.

At this stage, you should have a functional ConfigMgr primary site in the lab. Test deploying the ConfigMgr **client agent** to a few lab Windows 10/11 machines (using Client Push or manual install) and ensure they register with the site and appear in Devices in the console. This validates that basic site communications, management point, and client functionality are working.

## Integrating Entra ID and Intune for Co-Management  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>

> This section is highly dependant on your Intune setup. This section assumes that you have a new and clean Intune tenant with no devices joined yet. 

> [!WARNING]
> This feature still uses internet explorer for the login process. Even with IE disabled and Edge put in it's place. 

With ConfigMgr running in the lab, the next step is to integrate it with cloud services to support the hybrid environment (Entra ID cloud sync and Intune). **Co-management** allows devices to be managed by both ConfigMgr and Intune concurrently, enabling a gradual move of workloads to Intune while keeping ConfigMgr for other tasks. To set up co-management, you need to ensure devices are **Hybrid Azure AD (Entra ID) joined** and then enable co-management in the ConfigMgr console. [ref:NinjaOne:configure-co-management-between-sccm-and-intune](https://www.ninjaone.com/blog/configure-co-management-between-sccm-and-intune/)

**1. Configure Hybrid Entra Join for Devices:**  
If not already configured by your Azure AD Connect sync, run the **Microsoft Entra Connect** tool and go through **Configure Device Options** to enable **Hybrid Azure AD Join** for your on-prem domain devices. You will need to provide Entra ID global admin credentials during this process. In the Entra Connect wizard, opt to **configure hybrid join** for Windows devices (Windows 10 or later). This process sets the necessary **Service Connection Point (SCP)** in AD for device registration. After enabling, your domain-joined Windows 10/11 clients will *automatically register in Entra ID* (showing as Hybrid Azure AD joined) whenever they connect (this requires the device be able to contact Azure AD). 
> [!NOTE] 
> If your lab clients are already domain-joined and Entra Connect is syncing, they should start appearing in the Entra ID tenant (you can verify a test client by running `dsregcmd /status` on it and checking **AzureAdJoined** status). [ref:NinjaOne:configure-co-management-between-sccm-and-intune](https://www.ninjaone.com/blog/configure-co-management-between-sccm-and-intune/)

**2. Set Up Intune Auto-Enroll and ConfigMgr Client Registration:**  
In the Azure portal, navigate to **Microsoft Entra ID > Mobility (MDM and MAM) > Microsoft Intune**. Configure **MDM user scope** to include the groups of users that will be auto-enrolled to Intune (for a pilot, you might set this to a specific AAD group; ultimately likely to All users for full deployment). This setting ensures that when a device is Hybrid Entra joined and has ConfigMgr client, it will auto-enroll into Intune MDM.
Next, in the ConfigMgr Console, enable the client setting for **Automatically register new Windows 10/11 domain-joined devices with Microsoft Entra ID** = Yes (found under `Administration > Client Settings > Default Settings > Cloud Services` section). This configures ConfigMgr agent to perform the AAD registration. Also verify the **Enable Automatic Client Enrollment** setting for co-management is turned **on** (this is configured during co-management setup but depends on Intune MDM scope being set to some/all as above).

**3. Enable Co-Management (Cloud Attach) in ConfigMgr:**  
Since ConfigMgr 2107+, you can easily enable co-management via the **Cloud Attach** wizard. In the ConfigMgr console, go to **Administration > Cloud Services > Co-management** (or **Cloud Attach**). Launch the **Configure Cloud Attach** wizard. Sign in with your Intune admin (Entra ID global admin) credentials when prompted to authorize ConfigMgr with Entra ID. You have two main choices for enrollment. [ref:NinjaOne:configure-co-management-between-sccm-and-intune](https://www.ninjaone.com/blog/configure-co-management-between-sccm-and-intune/)

- **All devices**: Enroll all ConfigMgr-managed devices into Intune.
- **Pilot**: Enroll only a specific **pilot collection** of devices into Intune first.How to Configure Co-Management Between SCCM and Intune | NinjaOne

For a phased approach, select **Pilot** and choose a **Device Collection** in ConfigMgr that represents your pilot group (e.g., a collection of a few dozen Windows 10/11 devices or just IT department machines). ConfigMgr will then register an app in Entra ID and establish a connection to Intune. You can also enable **Endpoint Analytics** and **Tenant Attach** during this wizard (tenant attach allows seeing ConfigMgr devices in Intune portal and performing actions). Complete the wizard to start the co-management enrollment.

**4. Verify Co-Management Status:**  
After a while, devices in your pilot collection should show as "Co-managed" in the ConfigMgr console (Devices view has a column for Co-Management). In Intune’s Devices list, they will appear as MDM enrolled. You can verify on a client by checking the ConfigMgr **Control Panel applet** (Co-management tab) or running `dsregcmd /status` (look for MDM URL pointing to Intune). Also, in ConfigMgr console under **Devices**, the **Entra ID** column should show "Hybrid Azure AD" and **Device Online from Microsoft Intune** column data if tenant attach is enabled. [ref:NinjaOne:configure-co-management-between-sccm-and-intune](https://www.ninjaone.com/blog/configure-co-management-between-sccm-and-intune/)

At this stage, on pilot devices you have dual management: ConfigMgr and Intune. By default, when co-management is first enabled, all workloads are still managed by ConfigMgr (Intune is in a see-only mode). The next step is to gradually shift certain **workloads** to Intune, if desired, as part of the cloud integration (for example, you might move Compliance Policies or Windows Update policies to Intune while keeping application deployment in ConfigMgr). This can be done in **Administration > Cloud Services > Co-Management Properties**, by switching workloads to Pilot Intune or Intune. For now, keep workloads on ConfigMgr until you validate client stability.

## Pilot Deployment (Phase 2): Rolling out to a Beta Group  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>


With the infrastructure setup proven in the lab and co-management configured, the next phase is a **pilot deployment** in your real environment. The pilot (or beta) group should be a small subset of your production environment – for example, IT staff machines or a particular department – ideally comprising both Windows 10, Windows 11, and a few Windows Server (if servers will be client-managed) to represent your mix of clients. The goal is to observe ConfigMgr in action under real conditions and to catch any issues before full deployment.

Key considerations and steps for the Pilot phase:

- **Use a Phased Approach:** Deploy the ConfigMgr **client agent** to pilot machines first. You can use ConfigMgr’s built-in **Client Push** method, or if devices are Hybrid AAD joined, you could even test Intune deploying the client (though typically client push or manual install via script/GPO is used). Ensure the pilot clients appear in ConfigMgr and are healthy (Client = Yes, Active). Monitor their status and verify they continue to receive updates/software either from ConfigMgr or Intune as appropriate.
- **Pilot Collection and Co-Management:** If you configured co-management with a Pilot collection in the lab step, ensure that your pilot devices are included in that ConfigMgr collection. This way, they will automatically be enrolled to Intune via co-management. **It's important to test co-management on a pilot group before integrating all devices** into Intune. Watch for any policy conflicts on pilot devices (e.g., if both Intune and SCCM try to manage Windows Update, ensure only one is actually doing it by shifting workloads or disabling one side to avoid conflict).How to Configure Co-Management Between SCCM and Intune | NinjaOne
- **Functional Testing:** In the pilot phase, test the core ConfigMgr functionalities with the pilot users:
    - **Application Deployment**: Deploy a test application or update to pilot clients via ConfigMgr to ensure content distribution via Distribution Point is working and clients can install software.
    - **Software Updates**: If using ConfigMgr for updates, do a trial run of patch deployment or ensure Intune update policies (if that workload is moved) are effective.
    - **Compliance Settings/Configuration Items**: If you have any, test on pilot devices.
    - **Inventory and Reporting**: Verify that hardware/software inventory from pilot clients is being collected and that you can run reports.
- **Gather Feedback & Monitor**: Have pilot users report any odd behavior. In the ConfigMgr console, use the **Monitoring** workspace to check for errors:
    - **Site Status**: All components should be green (running).
    - **Component Status** and logs: monitor critical components like MP, SUP, etc. Check client logs on pilot machines (`CCM*.log`) for any errors.
    - **Intune Portal**: Check that pilot devices show up correctly and there are no duplicate entries or errors.
- **Adjust Configurations if Needed**: The pilot may reveal necessary adjustments. For example, you might find you need to create additional boundary groups or adjust network bandwidth settings. ConfigMgr has features like **Phased Deployments** which automatically sequence deployments to pilot then broader collections; you could leverage this for packages or task sequences in production . For instance, test a phased deployment of an application where Phase 1 = pilot collection, Phase 2 = broad collection, and verify it behaves as expected.

If the pilot phase is successful (clients are healthy, receiving policies, and no major issues are encountered), you can proceed to plan the production rollout. Typically, a pilot might run for a few weeks to ensure monthly patching cycles, etc., work correctly.

> [!TIP] 
> It’s advisable to keep the pilot/beta **collection** even as you move to production – future updates or new features can first be deployed to the pilot collection (a subset of users) before broad deployment, as a continuous safety mechanism.

## Full Production Deployment (Phase 3)  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>


The final phase is to extend the Configuration Manager deployment to all intended clients in the production environment, managing the mix of Windows 10, Windows 11, and Windows Server machines. Given that you have validated in pilot, the production rollout should be methodical and possibly staged:

- **Waves of Deployment**: If managing a large number of clients (ie. > 100), consider deploying in waves (by department, geography, or device type). This can be handled by targeting client push or Intune enrollment (co-management) in batches. You might use **ConfigMgr collections** to represent these groups and track deployment progress. ConfigMgr’s **phased deployment** feature can help automate rolling out a software or update in multiple phases, but the client installation itself can also be sequenced manually.
- **Scaling Infrastructure**: Ensure your ConfigMgr infrastructure is scaled for production:
    - If you have branch offices or large user bases in multiple locations, deploy additional **Distribution Points** in those locations to serve content locally and reduce WAN usage. After adding DPs, organize them into **distribution point groups** and assign to boundary groups as needed.Manage distribution points - Configuration Manager | Microsoft Learn+1
    - Double-check the **Boundary Groups** in ConfigMgr to cover all subnets or AD sites where clients reside, and associate the appropriate site systems (DPs, MPs) with those groups so clients know where to get content.
    - If you need to manage internet-based clients directly with ConfigMgr (instead of via Intune), consider deploying a **Cloud Management Gateway (CMG)**. The CMG service in Azure allows ConfigMgr clients to communicate with the site when off the corporate network. In a co-management scenario, many client functions can be handled by Intune when off-network, but CMG would be needed for things still managed by ConfigMgr (optional if all roaming clients will use Intune for those workloads).
- **Intune Workloads and Transition**: Decide which workloads (if any) you will switch over to Intune management in production. Common approach:
    - Initially, keep most workloads on ConfigMgr (so it remains the authority for software deployment, updates, compliance).
    - Over time, possibly shift specific workloads to Intune via the co-management slider. For example, you might move **Compliance Policies** and **Conditional Access** to Intune (since Entra ID conditional access works with Intune compliance). You might also pilot moving **Windows Update for Business** to Intune (which would switch Windows Update management from ConfigMgr to Intune). Each switch can be done first for a pilot collection (Intune Pilot) then for All.
    - The decision on workloads depends on your cloud strategy; ConfigMgr Current Branch allows flexibility to **“flip the switch”** for each feature to either SCCM or Intune.Tutorial: Enable co-management for existing clients - Configuration ...+1
- **User Communication**: Inform end users if there are any visible changes during the transition. Generally, ConfigMgr client installation is silent, and co-management is transparent to users. However, if Intune is taking over certain aspects (like the Windows Updates UX might change slightly if moved to WUfB), prepare documentation or support for those cases.
- **Security and Access**: If not already, this is a good time to implement role-based administration in ConfigMgr (if multiple admins will manage it) and to ensure least privilege on service accounts. For cloud integration, monitor the Entra ID application permissions that ConfigMgr created during Cloud Attach (found in Azure AD App registrations) – this app should be treated securely.

Once fully in production, ConfigMgr (along with Intune) will be managing all your Windows clients. Both on-prem and cloud-based management capabilities are active, giving you a **flexible hybrid management** solution: you can use ConfigMgr for fine-grained on-prem control and Intune for modern management scenarios like conditional access, Autopilot (if you choose to use it for new devices, Autopilot can enroll devices directly to Intune co-managed with ConfigMgr).

**Verification in Production:** After all clients are on-boarded, perform a thorough check:

- All devices appear in the ConfigMgr console and in Intune (with no large gaps or duplicates).
- Policies (from either ConfigMgr or Intune) are applying to devices as expected.
- Software distributions reach all intended clients (monitor Deployment status in ConfigMgr).
- Reporting: run reports or PowerBI dashboards to ensure data (like hardware inventory, software metering) is coming in for the new clients.

Finally, decommission any old management tool if this is a new adoption (for example, if you were using another system before). Also plan to keep the lab environment if possible, to test future updates.

---

## Ongoing Maintenance and Management  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>


Deploying ConfigMgr is only the beginning – maintaining the health and performance of the system is an ongoing task. Microsoft Configuration Manager includes several **built-in maintenance tasks** and it requires regular operational oversight. Here we outline **daily, weekly, and monthly** maintenance tasks that are recommended to keep your ConfigMgr environment optimal. Many of these tasks can be automated or set on schedules within ConfigMgr or via scripts.

| Frequency | Maintenance Tasks & Description |
| --- | --- |
| **Daily** | **Monitor Site Server Health:** Check the ConfigMgr site server’s basic health – CPU, memory, and disk usage. SQL Server (if local) will typically be the heaviest resource consumer; ensure it’s not starved for memory or disk I/O. <br/> Verify there is sufficient free disk space on drives (especially where the SQL database, SQL logs, and Content Library reside). <br/> **Check Site Status:** In the ConfigMgr console, go to **Monitoring > System Status > Site Status** and confirm all components show Status = OK (green). If any component has an error, investigate by viewing messages and checking the corresponding log (e.g., distmgr.log for distribution point issues). <br/> **Review Distribution & Deployment:** Under **Monitoring > Distribution Status > Content Status**, ensure content distributions are successful (no packages stuck in error). Also check **Monitoring > Deployments** for any failed deployments that might need attention.  <br/> **Client Health:** Go to **Monitoring > Client Status > Client Health Dashboard** to see an overview of client health metrics. If many clients are inactive or unhealthy, troubleshoot connectivity or client service issues on those machines. <br/>  **Backup Site Server:** Ensure the **Backup Site Server** maintenance task is running daily (default is every night). This built-in task backs up the ConfigMgr database and critical files. Verify in **Administration > Site Configuration > Sites > Site Maintenance** that it’s enabled and check the backup log (`Smsbkup.log`) for success. Also make sure the backup files are copied to a secure off-server location by your broader backup system. <br/> **Check WSUS and ADR Sync:** If using Software Update Point, verify that the WSUS sync has recently succeeded (Monitoring > Software Update Point Synchronization Status) and no sync errors are reported. Confirm Automatic Deployment Rules (if any for patching) ran and created deployments (check RuleEngine.log for errors). |
| **Weekly** | **Cleanup and Performance:** Remove or archive old logs and unnecessary files. IIS logs on the site server (for MP and DP) can grow large; implement a routine to delete or archive old IIS logs to free space. Also consider purging older **Content Library** data if you have orphaned content (there are tools/scripts for this). <br/> **Review Database**: Check the SQL Server **database size** and growth. Ensure there is enough free space on the disk for the CM database to expand, and that **index maintenance** is happening. ConfigMgr has a maintenance task for re-indexing; ensure tasks like **Rebuild Indexes** and **Site Clean-up** (e.g., Delete Aged Reports, Delete Aged Discovery Data) are enabled on a schedule that suits your data retention needsMaintenance tasks - Configuration Manager | Microsoft Learn+1. Typically, the default schedules are fine, but verify they ran (see last run time in Site Maintenance). <br/> **Backup Cleanup:** Back up important logs (SMSBKUP, Event Viewer logs) and then clear or truncate them as appropriate to prevent them from consuming too much spaceMaintenance tasks - Configuration Manager | Microsoft Learn. For instance, you might back up the Windows Event Logs of the site server weekly.  <br/> **Defragment and Optimize:** If not using SSDs, defragment disks on the site server and SQL server periodicallyMaintenance tasks - Configuration Manager | Microsoft Learn. Also ensure Windows Maintenance (like any scheduled tasks for disk cleanup) are functioning. |
| **Monthly / Patch Cycle** | **Apply Updates to ConfigMgr and OS:** Microsoft releases ConfigMgr Current Branch updates a few times per year. Plan to apply ConfigMgr hotfixes or version upgrades (e.g., upgrading from version 2303 to 2307) during a monthly maintenance window. Always test updates in the lab environment first. Similarly, apply Windows Updates to the servers hosting ConfigMgr roles.  <br/> **WSUS Maintenance:** Perform WSUS database maintenance monthly. This includes running WSUS cleanup wizard (can be done via ConfigMgr console or PowerShell) to declutter update metadata, and re-indexing the WSUS database. This prevents the WSUS content and metadata from slowing down patching. <br/> **Review Collections and Task Sequences:** Over time, collections and deployments can accumulate. Remove unused collections (especially query-based collections that can slow evaluation) and delete or disable any outdated task sequences or deployments (e.g., old OSD deployments that are no longer needed). <br/> **Password Rotation:** If any service accounts (for client push, network access, etc.) have passwords that change periodically, update them in ConfigMgr as needed (Administration > Security > Accounts). Also, update any expiring certificates if using PKI. <br/> **Disaster Recovery Drills:** At least monthly or quarterly, try a **backup recovery test**. Use the site backup to restore the ConfigMgr site in a isolated environment to ensure your backups are validMaintenance tasks - Configuration Manager | Microsoft Learn. Document the recovery process and adjust if any steps are found missing. |

Your maintenance plan may vary based on your environment size and specific features in use, but the above gives a baseline. Configuration Manager’s own maintenance tasks (accessible in the console under Site Maintenance) include several automated jobs (like old data cleanup) – review these and adjust schedules if your business requires longer data retention. **Regular monitoring and maintenance will keep ConfigMgr running efficiently** and prevent issues such as database bloat or log drives filling up, which can disrupt services.Maintenance tasks - Configuration Manager | Microsoft Learn+1

## Conclusion  
<sub>[Back to top](#deploying-and-configuring-microsoft-configuration-manager-current-branch-in-a-hybrid-cloud-environment)</sub>


Deploying Microsoft Configuration Manager in a hybrid cloud setup requires a solid foundation in on-premises best practices combined with cloud integration steps. By following a **phased approach—lab validation, pilot rollout, and production deployment—you minimize risk** and ensure the ConfigMgr environment is stable and meets organizational needs before wider release. In this guide, we covered the end-to-end process:

- Setting up prerequisites like server OS configuration, extending Active Directory schema for ConfigMgr, preparing SQL Server with the correct collation, and installing necessary tools (Windows ADK).
- Step-by-step installation and configuration of a ConfigMgr Primary Site in a lab, including post-install tasks and verification.
- Integration with cloud services: configuring Hybrid Microsoft Entra ID join, Intune auto-enrollment, and enabling co-management so devices can be managed by both ConfigMgr and Intune in a complementary way.
- Executing a pilot deployment to a beta group, using their feedback and system monitoring to ensure everything works as expected in a real environment with Windows 10/11/Server clients.
- Scaling out to full production, including considerations for additional site system roles (distribution points for content, etc.), boundary management, and gradually transitioning workloads to Intune where it makes sense for modern management.
- Ongoing maintenance tasks and best practices for daily, weekly, and monthly routines, to keep the ConfigMgr environment healthy (monitoring site health, backing up the database, cleaning up as needed, and planning for recovery).

By adhering to this guide, you’ll implement a robust **Microsoft Endpoint Configuration Manager** solution that leverages both on-premises and cloud capabilities. ConfigMgr will provide powerful software deployment, update management, and inventory control, while co-management with Intune and Entra ID will allow cloud-based features like conditional access and remote user support. This hybrid strategy future-proofs your device management by enabling a path to cloud management alongside your existing processes.How to Configure Co-Management Between SCCM and Intune | NinjaOne

With the system in production, continue to update and refine it – stay current with ConfigMgr version updates (as new Current Branch releases come out a few times each year), and adjust co-management workloads as your organization shifts more toward cloud management. The result is a flexible, well-managed endpoint environment spanning across on-premises and cloud, meeting the needs of both IT administrators and end users. 