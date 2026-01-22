<sub>[back](../README.md)</sub>

# Microsoft Configuration Manager (MCM, MECM, SCCM)

*Applies to: Configuration Manager (current branch)* Formerly known as System Center Configuration Manager (SCCM). Also known as Microsoft Endpoint Configuration Manager (MECM) or just ConfigMgr. These documents primarly refer to MCM as ConfigMgr. 

## Links

- [Installation & Configuration](./ConfigMgr.md)
  - [Install & Config Checklist](./ConfigMgr_Checklist.md)
- [ConfigMgr Updates](./ConfigMgr_Updates.md)
  - [ConfigMgr Update Reset Tool](./ConfigMgr_UpdateResetTool.md)
- [Logs](./Logs.md)
- [Content Cleanup](./ContentCleanup.md)
- [Windows Error Codes](../../Windows/Error-Codes.md)

## **Introduction**

Use Configuration Manager to help you with the following systems management activities:

- Increase IT productivity and efficiency by reducing manual tasks and letting you focus on high-value projects.
- Maximize hardware and software investments.
- Empower user productivity by providing the right software at the right time.

Configuration Manager helps you deliver more effective IT services by enabling:

- Secure and scalable deployment of applications, software updates, and operating systems.
- Real-time actions on managed devices.
- Cloud-powered analytics and management for on-premises and internet-based devices.
- Compliance settings management.
- Comprehensive management of servers, desktops, and laptops.

Configuration Manager extends and works alongside many Microsoft 
technologies and solutions. For example, Configuration Manager 
integrates with:

- Microsoft Intune to co-manage a wide variety of mobile device platforms
- Microsoft Azure to host cloud services to extend your management services
- Windows Server Update Services (WSUS) to manage software updates
- Certificate Services
- Exchange Server and Exchange Online
- Group Policy
- DNS
- Windows Automated Deployment Kit (Windows ADK) and the User State Migration Tool (USMT)
- Windows Deployment Services (WDS)
- Remote Desktop and Remote Assistance

Configuration Manager also uses:

- Active Directory Domain Services and Microsoft Entra ID for
security, service location, configuration, and to discover the users and devices that you want to manage.
- Microsoft SQL Server as a distributed change management database—and integrates with SQL Server Reporting Services (SSRS) to produce reports to monitor and track management activities.
- Site system roles that extend management functionality and use the web services of Internet Information Services (IIS).
- Delivery Optimization, Windows Low Extra Delay Background Transport
(LEDBAT), Background Intelligent Transfer Service (BITS), BranchCache,
and other peer caching technologies to help manage content on your
networks and between devices.

To be successful with Configuration Manager in a production 
environment, thoroughly plan and test the management features. 
Configuration Manager is a powerful management application, with the 
potential to affect every computer in your organization. When you deploy
 and manage Configuration Manager with careful planning and 
consideration of your business requirements, Configuration Manager can 
reduce your administrative overhead and total cost of ownership.

## **User interfaces**

### **The Configuration Manager console**

After you install Configuration Manager, use the Configuration 
Manager console to configure sites and clients, and to run and monitor 
management tasks. This console is the main point of administration, and 
lets you manage multiple sites.

You can install the Configuration Manager console on additional 
computers, and restrict access and limit what administrative users can 
see in the console by using Configuration Manager role-based 
administration.

For more information, see [Use the Configuration Manager console](https://learn.microsoft.com/en-us/intune/configmgr/core/servers/manage/admin-console).

## **Software Center**

### **Software Center** is an application that's installed 
when you install the Configuration Manager client on a Windows device. 
Users use Software Center to request and install software that you 
deploy. Software Center lets users do the following actions:

- Browse for and install applications, software updates, and new OS versions
- View their software request history
- View device compliance against your organization's policies

You can also show custom tabs in Software Center to meet additional business requirements.

For more information, see the [Software Center user guide](https://learn.microsoft.com/en-us/intune/configmgr/core/understand/software-center).