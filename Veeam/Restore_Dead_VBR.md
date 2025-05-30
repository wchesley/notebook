[back](./README.md)

## Overview

This guide explains how to restore a **Veeam Backup & Replication server**[Veeam Backup & Replication server](https://www.google.com/search?q=Veeam+Backup+%26+Replication+server) to a new machine using a previously created configuration backup. This process is critical in a disaster recovery scenario where the original Veeam Backup & Replication server is lost, corrupted, or otherwise unavailable, allowing for the resumption of backup and replication operations.

You would perform this task when your primary Veeam Backup & Replication server has failed and cannot be recovered, and you have a healthy configuration backup available.

## Before you start

Before you begin restoring the Veeam Backup & Replication server, ensure:

-   You have a new server (physical or virtual) that meets the **Veeam Backup & Replication system requirements** [Veeam Backup & Replication system requirements](https://www.google.com/search?q=Veeam+Backup+%26+Replication+system+requirements). This server will host the restored Veeam instance.
-   You possess the installation media for the **same or a higher version** [Veeam Backup & Replication versions](https://www.google.com/search?q=Veeam+Backup+%26+Replication+versions) of Veeam Backup & Replication as the one that created the configuration backup. Using the exact same version is ideal.
-   You have access to the Veeam **configuration backup file** [Veeam configuration backup file location](https://www.google.com/search?q=Veeam+configuration+backup+file+location) (typically a `.bco` file located in the `VBRCatalog` folder, which should be stored on a backup repository or another secure, separate location).
-   You know the **password for the configuration backup** [Veeam encrypted configuration backup](https://www.google.com/search?q=Veeam+encrypted+configuration+backup) if it was encrypted.
-   You have the necessary administrative credentials:
    -   Local administrator rights on the new server.
    -   Domain administrator rights if the original server was domain-joined and you intend to join the new server to the same domain.
    -   Service account credentials used by Veeam services if applicable.
-   The new server has **network connectivity** [Veeam network connectivity requirements](https://www.google.com/search?q=Veeam+network+connectivity+requirements) to all necessary infrastructure components, including:
    -   Backup repositories.
    -   Managed servers (e.g., VMware vCenter Servers, Microsoft Hyper-V hosts, physical servers with Veeam Agents).
    -   DNS servers and Domain Controllers.
-   It is highly recommended, where possible, for the new server to have the **same hostname and IP address** [Veeam server hostname IP change implications](https://www.google.com/search?q=Veeam+server+hostname+IP+change+implications) as the original Veeam Backup & Replication server. This simplifies the reconnection of Veeam agents and other components. If this is not feasible, be prepared for additional reconfiguration steps post-restore.

* * *

## Restoring Veeam Backup & Replication Server

This task involves preparing a new server, installing the Veeam Backup & Replication software, and then restoring its configuration from a backup.

### 1\. Prepare the New Veeam Backup & Replication Server

1.  **Install and configure the Windows Server operating system** on the new hardware or virtual machine.
    -   Ensure it meets the prerequisites for the Veeam Backup & Replication version you are installing.
2.  **Assign network configuration.**
    -   Ideally, configure the new server with the same IP address, subnet mask, gateway, and DNS settings as the original server.
3.  **Set the hostname.**
    -   Ideally, assign the same hostname to the new server as the original server.
4.  **Join the server to the domain** (if applicable).
    -   If the original Veeam server was part of an Active Directory domain, join the new server to the same domain using the same hostname if possible.
5.  **Install all pending Windows Updates** and restart the server if required.

### 2\. Install Veeam Backup & Replication

1.  **Mount or extract the Veeam Backup & Replication ISO** file on the new server.
2.  **Run the `Setup.exe`** file from the installation media.
    -   The Veeam Backup & Replication splash screen will appear.
3.  **Click "Install Veeam Backup & Replication"**.
    -   The setup wizard will launch.
4.  **Accept the license agreement** and click **Next**.
5.  **Provide a license file** if prompted, or choose to install in Community Edition mode (if applicable and sufficient for your needs post-restore). You can also update the license after the restore. Click **Next**.
6.  **Select the program features** you want to install. At a minimum, "Veeam Backup & Replication" must be selected. Click **Next**.
7.  **System Configuration Check**: The installer will perform a system configuration check.
    -   If any required software components are missing, the installer will offer to install them automatically. Click **Install** to proceed.
    -   Once all checks pass, click **Next**.
8.  **Specify Service Account Credentials**:
    -   Choose the **LOCAL SYSTEM account** (default) or specify a user account. If the original server used a specific service account, it's a best practice to use the same account if possible, ensuring it has the necessary permissions on the new server and to the pSQL Server instance if it's remote.
    -   Click **Next**.
9.  **Select pSQL Server Instance**:
    -   Choose **Install new instance of pSQL Server (LOCAL)** if you want Veeam to install a new PostgreSQL edition on this server.
    -   Choose **Use existing instance of pSQL Server** if you have a pre-existing local or remote pSQL Server instance you wish to use.
        -   Specify the `HOSTNAME\INSTANCE` and the database name (default is `VeeamBackup`).
        -   Provide authentication credentials for the pSQL Server instance.
    -   Click **Next**.
    -   A connection test to the pSQL Server will be performed.
10.  **Confirm Installation Settings**: Review the installation and configuration settings.
    -   Note the port numbers (default: Catalog service port 9393, Veeam Backup service port 9392). Ensure these ports are open in any firewalls.
    -   Check the box "Enable generation of the default self-signed certificate" unless you plan to use a custom certificate immediately.
    -   Click **Install**.
11.  **Wait for the installation to complete**.
    -   The Veeam Backup & Replication components, including the console, will be installed.
12.  **Click Finish** once the installation is successful. Do not immediately open the console if prompted to do so by a desktop shortcut; proceed to the configuration restore first.

### 3\. Restore the Veeam Configuration Database (Optional)

> Note: if this section is skipped, you must recreate all backup jobs from the original server manually after Veeam Backup and Replication is installed. 

1.  **Open the Veeam Backup & Replication console** on the new server.
2.  If this is the very first launch after installation and before any configuration, you might be directly prompted to restore or start fresh. If so, choose the restore option. Otherwise, use the main menu.
3.  **Navigate to the main menu** by clicking the "hamburger" icon (three horizontal lines) in the top-left corner of the console.
4.  Select **Configuration Backup...**.
    -   The Configuration Backup Settings window will appear. This window normally shows the schedule and settings for _creating_ configuration backups.
5.  In the Configuration Backup Settings window, click the **Restore...** button.
    -   The Configuration Database Restore wizard will launch.
6.  **Select Restore Mode**:
    -   You will be presented with two options:
        -   **Restore**: This option restores the configuration to the current server. This is the typical choice when recovering a failed server.
        -   **Migrate**: This option allows you to restore the configuration and adapt it to a new server with potentially different settings or a different version of Veeam Backup & Replication. _For a disaster recovery scenario where the original server is gone, "Restore" is generally the appropriate choice, especially if you've tried to match hostname/IP._
    -   Select **Restore** and click **Next**.
7.  **Specify Backup Location**:
    -   Click **Browse...** and navigate to the location where your Veeam configuration backup file (`.bco`) is stored. This is likely on an external drive, a network share, or within a backup repository that you've made accessible to the new server.
    -   Select the configuration backup file and click **Open**.
    -   Click **Next**.
8.  **Specify Decryption Password**:
    -   If your configuration backup was encrypted (a Veeam best practice), the "Decrypt" step will appear.
    -   Enter the **password** used to encrypt the configuration backup.
    -   Click **Next**.
9.  **Review Backup Details**:
    -   The wizard will display details about the selected configuration backup, such as the Veeam Backup & Replication version, backup creation date, and the original server name.
    -   Verify this information is correct and click **Next**.
10.  **Target Database Settings**:
    -   The wizard will show the pSQL server instance and database name where the configuration will be restored (this should match what you configured during the Veeam installation).
    -   You typically do not need to change these settings unless there's a specific reason.
    -   Click **Next**.
11.  **Review Summary**:
    -   A summary of the restore operation will be displayed. Carefully review all the settings.
    -   The summary will indicate that Veeam services will be stopped during the restore process.
12.  **Initiate Restore**:
    -   Click **Restore** to begin the configuration database restoration.
    -   Veeam Backup & Replication will stop its services, drop the existing empty configuration database (if any), restore the database from the backup, and then restart the services.
13.  **Monitor Restore Process**:
    -   The progress of the restore operation will be displayed.
14.  **Complete Restore**:
    -   Once the restore is complete, a success message will be shown. Click **Finish**.
    -   The Veeam Backup & Replication console will now load the restored configuration.

### 4\. Post-Restore Tasks and Verification

After the configuration database is successfully restored, perform the following critical checks and tasks:

1.  **Verify Service Account**:
    -   Ensure all **Veeam services** [Veeam services list](https://www.google.com/search?q=Veeam+services+list) are running and using the correct service account, especially if domain or service account configurations have changed. Check Windows Services (`services.msc`).
2.  **Check License Status**:
    -   In the Veeam console, go to **Main Menu > License**.
    -   Verify that the license is active and valid. If the hardware ID changed significantly, you might need to obtain an updated license file from the **Veeam licensing portal** [Veeam licensing portal](https://www.google.com/search?q=Veeam+licensing+portal) and install it.
3.  **Verify Backup Repositories**:
    -   Navigate to **Backup Infrastructure > Backup Repositories**.
    -   Check the status of all repositories. If any are unavailable or show errors, investigate connectivity.
    -   You may need to **rescan** [Veeam rescan repository](https://www.google.com/search?q=Veeam+rescan+repository) repositories if passwords have changed or if there are access issues. Right-click the repository and select "Rescan".
    -   If passwords for accessing repositories were stored and are now invalid (e.g., due to SID changes if not using original hostname/domain join method), you may need to edit the repository settings and re-enter credentials.
4.  **Verify Managed Servers (Hypervisors, Physical/Cloud)**:
    -   Navigate to **Backup Infrastructure > Managed Servers**.
    -   Check the connection status to vCenter Servers, ESXi hosts, Hyper-V hosts, and any other managed servers.
    -   If there are issues, try to **rescan** the server or edit its properties to re-enter credentials or re-trust SSL certificates, especially if the Veeam server's hostname or IP address changed and couldn't be made identical to the original.
5.  **Check Backup Proxies and WAN Accelerators**:
    -   Navigate to **Backup Infrastructure > Backup Proxies** and **Backup Infrastructure > WAN Accelerators**.
    -   Ensure all proxies and WAN accelerators are online and accessible.
    -   If the Veeam B&R server itself was also a proxy, verify its components are functional.
6.  **Check Tape Infrastructure** (if applicable):
    -   Navigate to **Tape Infrastructure**.
    -   Verify connections to tape servers, libraries, and drives. You might need to rescan the tape infrastructure.
7.  **Review and Test Backup Jobs**:
    -   Navigate to **Home > Jobs > Backup** (or Replication, etc.).
    -   Examine the status and configuration of critical jobs.
    -   **Run a few test jobs**:
        -   For a backup job, consider running an **Active Full backup** [Veeam Active Full Backup](https://www.google.com/search?q=Veeam+Active+Full+Backup) for a small, non-critical VM or server to ensure the entire chain works.
        -   For replication jobs, perform a test replication and failover if feasible.
    -   Monitor these test jobs for successful completion.
8.  **Update Credentials**:
    -   If any stored credentials (e.g., for guest OS processing, application-aware processing, connections to remote systems) have become invalid due to the server change, update them through the **Main Menu > Manage Credentials** section or within the job settings themselves.
9.   **Verify Network Traffic Rules** (if changed):
    -   If you use Veeam's network traffic throttling or encryption, verify these settings are correctly restored and functional under **Main Menu > Network Traffic Rules**.
10.  **Enable and Configure Configuration Backup**:
    -   **This is crucial.** Go to **Main Menu > Configuration Backup...**.
    -   **Enable** the scheduled configuration backup.
    -   Verify the backup repository for the configuration backup is correct (ideally, not the C: drive of the Veeam server itself; use a different repository or network path).
    -   Ensure encryption is enabled and you have securely stored the new password.
    -   Set an appropriate schedule. Daily is a common best practice.
11.  **Document the Recovery**:
    -   Note any changes made during the recovery process, any new credentials, or any issues encountered and their resolutions for future reference.
12.  **Check Cloud Connect components** (if applicable):
    -   If you are a service provider or connect to one using **Veeam Cloud Connect** [Veeam Cloud Connect](https://www.google.com/search?q=Veeam+Cloud+Connect), verify all related components, gateways, and cloud repositories.

By following these steps, you should be able to successfully restore your Veeam Backup & Replication server and resume normal data protection operations.

* * *

## Restore Using Veeam Recovery Media

## See also

-   **Veeam Help Center**: [Veeam Help Center](https://www.google.com/search?q=Veeam+Help+Center) - For official Veeam documentation.
-   **KB1889: Restoring Veeam Backup & Replication Configuration to a New Server**: [Veeam KB1889](https://www.google.com/search?q=Veeam+KB1889+Restoring+Veeam+Backup+%26+Replication+Configuration+to+a+New+Server) - Specific knowledge base article. (Search for the latest version of this KB)
-   **Veeam Best Practices**: [Veeam Best Practices](https://www.google.com/search?q=Veeam+Best+Practices) - General best practices for Veeam solutions.
-   **Understanding Configuration Backups (Veeam User Guide)**: [Veeam User Guide Configuration Backup](https://www.google.com/search?q=Veeam+User+Guide+Configuration+Backup) - For conceptual details on configuration backups.
-   **Troubleshooting Veeam Restore Issues**: [Troubleshooting Veeam Restore Issues](https://www.google.com/search?q=Troubleshooting+Veeam+Restore+Issues) - For general troubleshooting tips.

