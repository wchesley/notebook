[back](./README.md)

## Overview

This guide explains how to create [Veeam Recovery Media](https://www.google.com/search?q=Veeam+Recovery+Media+creation) using a Veeam Backup & Replication server and then how to use that media to perform a [bare-metal recovery (BMR)](https://www.google.com/search?q=Veeam+Bare+Metal+Recovery) of a Windows system. This process is essential when a system is unbootable due to operating system corruption, hardware failure, or other disasters, allowing you to restore the entire system from a Veeam backup.

You would create Veeam Recovery Media proactively to prepare for potential system failures. You would use the Recovery Media when a protected machine (which could include the Veeam Backup & Replication server itself, if it was backed up as a full system) cannot start and needs a full restoration.

## Before you start

### For Creating Veeam Recovery Media:

Before you create the Veeam Recovery Media, ensure:

-   **Veeam Backup & Replication Installation**: A functional Veeam Backup & Replication server (version 11 or later for native PostgreSQL support) is installed and configured with [PostgreSQL](https://www.google.com/search?q=Veeam+PostgreSQL+support) as its configuration database.
-   **Console Access**: You have access to the Veeam Backup & Replication console with sufficient permissions.
-   **Storage for Media**: A USB flash drive (recommended, size depends on included drivers but typically 1GB is sufficient, larger if adding many custom drivers), or sufficient disk space if creating an ISO file. Ensure the USB drive can be formatted.
-   **Required Drivers** (Optional but Recommended): Collect any critical [storage controller drivers](https://www.google.com/search?q=Windows+PE+storage+drivers) or [network adapter drivers](https://www.google.com/search?q=Windows+PE+network+drivers) for the hardware of the machine(s) you intend to recover. While Veeam Recovery Media includes many common drivers, specific or newer hardware might require additional ones.
-   **Windows Assessment and Deployment Kit (ADK)**: The Veeam Backup & Replication server where you create the recovery media needs components from the Windows ADK. If not already present, the Veeam Recovery Media creation wizard can download and install them, or you can install them manually beforehand. [Windows ADK for Veeam](https://www.google.com/search?q=Windows+ADK+for+Veeam). This should be installed by default.

### For System Restoration using Veeam Recovery Media:

Before you begin the system restoration process, ensure:

-   **Veeam Recovery Media**: The bootable Veeam Recovery Media (USB drive or ISO) that you created.
-   **System Backup**: A valid Veeam backup of the system you intend to restore. This backup must have been created by a Veeam agent-based backup job (Veeam Agent for Microsoft Windows, managed by Veeam Backup & Replication or standalone) or a VM backup if restoring to different hardware.
-   **Backup Accessibility**:
    -   The backup files are accessible. This could be on a portable storage device, a network share, or a [Veeam backup repository](https://www.google.com/search?q=Veeam+backup+repository+types).
    -   If accessing a repository managed by your Veeam Backup & Replication server, ensure network connectivity to this server or the repository location from the recovery environment.
-   **Target Hardware**: The physical or virtual machine onto which you will restore the system.
-   **BIOS/UEFI Configuration**: The target machine's BIOS/UEFI is configured to boot from the Veeam Recovery Media (USB or ISO).
-   **Licensing**: For restoring agent-based backups, ensure you have the necessary Veeam licensing. The recovery media itself works, but restoring certain backup types might be license-dependent.
-   **Network Connectivity** (Recommended): An active network connection on the target machine for accessing backups stored on network shares or Veeam repositories, and for potentially downloading drivers if needed.

* * *

## Creating Veeam Recovery Media

This task describes how to generate bootable recovery media from your Veeam Backup & Replication console.

1.  **Open the Veeam Backup & Replication console**.
2.  **Navigate to Recovery Media Creation Tool**:
    -   Click the main menu icon (three horizontal lines or "hamburger" menu) in the top-left corner.
    -   Go to **Tools**.
    -   Select **Create Recovery Media**.
        -   This launches the Veeam Recovery Media creation wizard.
3.  **Recovery Media Type**:
    -   Choose the kind of recovery media you want to create:
        -   **ISO file**: Creates a bootable ISO image.
        -   **Bootable USB drive**: Writes directly to a connected USB flash drive.
    -   Click **Next**.
4.  **Image Type**:
    -   Select the operating system for the recovery environment. For Windows systems, choose **Windows**.
    -   Click **Next**.
5.  **Removable Storage Device**:
    -   Select the target USB drive from the list of detected devices.
    -   Acknowledge that the selected USB drive will be formatted.
    -   Click **Next**.
6.  **Hardware Drivers**:
    -   This step allows you to include additional hardware drivers:
        -   **Include hardware drivers from this computer**: Useful if creating the media on a machine similar to the one you might recover.
        -   **Include the following additional hardware drivers (recommended)**: Check this box to add specific drivers. Click **Add...** to browse for `.inf` files for your storage controllers, network adapters, or other critical hardware. This is highly recommended for ensuring compatibility with diverse hardware.
    -   Click **Next**.
7.  **Network Settings**:
    -   Configure default network settings for the recovery environment:
        -   **Enable automatic network configuration (DHCP)**: Recommended if your network supports DHCP.
        -   **Configure network settings manually**: Allows you to pre-configure a static IP address, subnet mask, gateway, and DNS servers.
    -   Click **Next**.
8.  **Ready to Create**:
    -   Review the summary of the selected options.
    -   Click **Create** to start the recovery media generation process.
        -   The wizard will download Windows ADK components if necessary, build the Windows PE image, inject drivers, and write to the ISO file or USB drive. This can take some time.
9.  **Process Completion**:
    -   Once the process is complete, click **Finish**.
    -   Safely eject the USB drive if created, or note the location of the ISO file. Store the recovery media in a safe and accessible place.

* * *

## Restoring a System using Veeam Recovery Media

This task outlines the steps to recover a Windows system using the Veeam Recovery Media.

1.  **Boot from Veeam Recovery Media**:
    -   Insert the bootable USB drive into the target machine or connect the ISO image (if using a VM).
    -   Start or restart the machine and enter its BIOS/UEFI setup to change the boot order, ensuring it boots from the Veeam Recovery Media.
    -   The machine will boot into the **Veeam Recovery Environment**.
2.  **Welcome Screen**:
    -   The Veeam Recovery Environment will load. You may see options for language or keyboard layout.
    -   The main menu will typically offer tools like "Bare Metal Recovery," "Manual Restore," "Load Driver," "Command Prompt," etc.
3.  **Select "Bare Metal Recovery"**.
    -   This option is used for restoring an entire system image.
4.  **Backup Location**:
    -   Specify where the backup files are located:
        -   **Network storage**: Choose this if your backups are on a network share or in a Veeam backup repository.
            -   You'll need to configure network settings if DHCP didn't work or if static IP is required. Click **Network Settings** or a similar option if needed.
            -   Select **Veeam backup repository**.
                -   Enter the address (hostname or IP) of your Veeam Backup & Replication server or the gateway server for your Cloud Connect repository.
                -   Provide credentials to access the Veeam server/repository.
                -   The recovery environment will connect and list available backups.
            -   Select **Network share**.
                -   Enter the UNC path to the network share (e.g., `\\server\share`) and credentials if required.
        -   **Local storage**: Choose this if your backup files are on a locally attached drive (e.g., an external USB HDD). Browse to select the backup metadata file (`.vbm`).
    -   Click **Next**.
5.  **Select Computer and Restore Point**:
    -   If connected to a Veeam repository, select the computer (backup job or specific machine) whose backup you want to restore.
    -   Choose the desired **restore point** (date and time) from the available options.
    -   Click **Next**.
6.  **Restore Mode**:
    -   Choose the restore mode:
        -   **Entire computer**: Restores all volumes included in the backup. This is typical for BMR.
        -   **System volumes only**: Restores only the volumes required for the operating system to boot.
        -   **Manual restore (advanced)**: Allows you to select specific volumes and customize disk mapping extensively.
    -   For most BMR scenarios, **Entire computer** is appropriate.
    -   Click **Next**.
7.  **Disk Mapping** (This step is crucial):
    -   The wizard will attempt to map the backed-up disk partitions to the disks available on the target hardware.
    -   **Review the automatic mapping carefully.**
    -   If the target hardware has different disk sizes or configurations, you may need to **adjust the mapping manually**. Click on a disk or volume to change its target location or resize partitions (if supported and space allows).
    -   Ensure the system/boot volume is being restored to an appropriate disk.
    -   If critical drivers for your storage controller were not loaded initially, you might need to use the "Load Driver" option (often available from a tools menu or by returning to the main recovery environment screen) to load drivers so the target disks become visible.
    -   Click **Next** after confirming the disk mapping.
8.  **Ready to Restore**:
    -   Review the summary of the restore operation, including the source backup, restore point, and disk mapping.
    -   Optionally, you can select "Verify restore point before recovery" for added assurance, though it extends the restore time.
9.  **Initiate Restore**:
    -   Click **Restore** (or **Start**) to begin the data restoration process.
    -   The progress will be displayed. This can take a significant amount of time depending on the backup size and hardware speed.
10.  **Finalize Restore**:
     - Once the restore is complete, a success message will be shown.
     - You may be prompted to reboot the computer. Remove the Veeam Recovery Media.
     - Click **Finish** or **Reboot**.
11.  **Post-Restore Verification**:
     - Allow the system to boot into the restored Windows operating system.
     - **Log in** and verify system functionality.
     - **Check drivers**: Ensure all hardware devices have correctly installed drivers. If not, install them manually.
     - **Verify applications** and data.
     - **Reconnect to the network** and test connectivity.
     - **Re-establish backup jobs** if you restored the Veeam B&amp;R server itself and the configuration was part of the bare-metal backup. If you restored a client machine, it should reconnect to the VBR server as per its agent settings.

* * *

## See also

-   [Veeam Help Center - Creating Veeam Recovery Media](https://www.google.com/search?q=Veeam+Help+Center+Create+Recovery+Media)
-   [Veeam Help Center - Bare Metal Recovery](https://www.google.com/search?q=Veeam+Help+Center+Bare+Metal+Recovery)
-   [Veeam Agent Management Guide](https://www.google.com/search?q=Veeam+Agent+Management+Guide) (Relevant for backups created by managed agents)
-   [Veeam Knowledge Base](https://www.google.com/search?q=Veeam+Knowledge+Base) (For troubleshooting specific issues)
-   [Microsoft Windows PE ADK](https://www.google.com/search?q=Microsoft+Windows+PE+ADK) (For understanding the underlying recovery environment technology)

