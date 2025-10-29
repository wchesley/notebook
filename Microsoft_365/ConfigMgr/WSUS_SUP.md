# ConfigMgr & WSUS - Software Update Point (SUP)

ConfigMgr can manage WSUS that is either on the same machine or accessible over the network. ConfigMgr can then be used to distribute and manage windows updates with finer control than WSUS can provide. 

## Overview

Ensure that WSUS role is installed on the ConfigMgr server. 

This Site System is a site-wide option. It’s supported to install this role on a Central Administration Site, child Primary Site, stand-alone Primary Site and Secondary Site.

When your hierarchy contains a Central Administration Site, install a Software Update Point and synchronizes with Windows Server Update Services (WSUS) before you install a SUP at any child’s Primary Site.

When you install a Software Update Point at a child Primary Site, configure it to synchronize with the SUP at the Central Administration Site.

## Setup

Start by adding the **Software Update Point** role to the ConfigMgr server. 

- Open the SCCM console
- Navigate to **Administration** / **Site Configuration** / **Servers and Site System Roles**
- Right-click your **Site System** and click **Add Site System Roles**
- On the General tab of the 'Add Site System Roles Wizard, click **Next**
- Configure proxy information if you use one, else click **Next**
- On the Site System Role tab, select Software Update Point, click **Next**
- On the Software Update Point tab, select WSUS is configured to use ports 8530 and 8531, click Next
- On the Proxy and Account Settings tab, specify your credentials if necessary, click Next
- On the Synchronization Source tab, specify if you want to synchronize from Microsoft Update or an upstream source. Refer to the Site System Placement section if you’re unsure. For a stand-alone Primary Site, select Synchronize from Microsoft Update, click Next
- On the Synchronization Schedule tab, check the Enable synchronization on a schedule checkbox and select your desired schedule. 1 day is usually enough but it can be lowered if you’re synchronizing Endpoint Protection definition files, click Next
- On the Supersedence Rules tab, select Immediately expire a superseded software update, click Next
- On the Classifications tab, select your organization needs, click Next
- On the Products tabs, select the products that you want to manage using SCCM, click Next
- On the Languages tab, select the desired language, click Next
- On the Summary tab, review your settings, click Next, wait for the setup to complete and click Close

## Verification

- `ConfigMgrSetup\Logs\SUPSetup.log` -Provides information about the software update point installation. When the software update point installation completes, Installation was successful is written to this log file
- `ConfigMgrSetup\Logs\WCM.log` – Provides information about the software update point configuration and connecting to the WSUS server for subscribed update categories, classifications, and languages
- `ConfigMgrSetup\Logs\WSUSCtrl.log` – Provides information about the configuration, database connectivity, and health of the WSUS server for the site
- `ConfigMgrSetup\Logs\Wsyncmgr.log` – Provides information about the software updates synchronization process

## Perform Initial SUP Synchronization

Software updates synchronization is the process of retrieving the 
software updates metadata that meets the criteria that you configure. 
Software updates are not displayed in the Configuration Manager console 
until you synchronize software updates.

Here is how you perform the initial software update synchronization after you install SUP role in SCCM.

- First of all launch the SCCM console.
- Go to **Software Library** > **Overview** > **Software Updates** > **All Software Updates**.
- On the top ribbon, click **Synchronize Software Updates**.

Perform Initial SUP Synchronization

![Perform Initial SUP Synchronization](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap19.jpg)

On the confirmation box, click **Yes**.

Perform Initial SUP Synchronization

![Perform Initial SUP Synchronization](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap20.jpg)

When you run the initial SUP sync, it tries to sync categories but 
notice what happens. If you open wsyncmgr.log file, it tells you that **Request filter does not contain any known categories or classifications**. Hence sync will do nothing.

At this point, let the sync complete. If you see the line “**Done synchronizing SMS with WSUS Server**” it means the SUP sync is complete.

wsyncmgr.log file

![wsyncmgr.log file](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap21.jpg)

```
sync: SMS synchronizing categories	SMS_WSUS_SYNC_MANAGER
sync: SMS synchronizing categories, processed 0 out of 355 items (0%)
sync: SMS synchronizing categories, processed 355 out of 355 items (100%)
sync: SMS synchronizing categories, processed 355 out of 355 items (100%)
WARNING: Request filter does not contain any known classifications. Sync will do nothing.
WARNING: Request filter does not contain any known categories. Sync will do nothing.
Done synchronizing SMS with WSUS Server

```

## Enable SUP Classifications and Products

After the initial WSUS Sync is complete, let’s enable the classifications and products under software update point role.

In the Configuration Manager console, navigate to **Administration** > **Overview** > **Site Configuration** > **Sites**. Select the site, right click and click **Configure Site Components** > **Software Update Point**.

Software Update Point Properties

![Software Update Point Properties](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap22.jpg)

On the Software Update Point component properties box, select **Classifications** tab. Enable the ones that you require. In this example, I am selecting **Critical Updates** and **Security Updates**.

Enable SUP Classifications

![Enable SUP Classifications](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap23.jpg)

Next, click **Products** tab and select the products. In this example I am selecting Windows 10 product. Once you are done with selections, click **Apply** and **OK**.

Enable SUP Products

![Enable SUP Products](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap24.jpg)

After you select Classifications and Products, you must run the 
software update point synchronization again. Only then you will see the 
updates for selected products appearing in the console.

Open the **wsyncmgr.log** file and you will notice the 
updates synchronization begins. Based on the products and 
classifications that you select, it takes time for the process to 
complete.

SCCM SUP Synchronization

![SCCM SUP Synchronization](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap25.jpg)

During the sync process, you may not find any updates listed under All Software Updates.

![SCCM SUP Role](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap26.jpg)

Once the SUP synchronization is complete, notice the updates listed under Software Updates.

Windows 10 Updates

![Windows 10 Updates](https://www.prajwaldesai.com/wp-content/uploads/2020/03/Install-Software-Update-Point-in-Configuration-Manager-Snap27.jpg)