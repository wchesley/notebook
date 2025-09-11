[back](./README.md)

# O365 Deployment

This article is intended for admins using ODT with admin rights on client devices. Admin rights can be obtained either through a software deployment tool or by allowing users to install with admin rights. For a more streamlined approach to deploying and managing Microsoft 365 Apps, Microsoft Intune or Microsoft Configuration Manager are recommended. 

You can generate O365 `Autounattend.xml` files from [here](https://config.office.com/deploymentsettings).

## Step 1: Create shared folders for installation files

Because you're deploying Microsoft 365 Apps from a local source, you have to create folders to store the installation files. Create one parent folder and two child folders, one for the Current Channel sources, and one for the Monthly Enterprise Channel sources.

Create the following folders:
- `\\Server\Share\Microsoft365Apps`: Stores the ODT and the configuration files that define how to download and deploy Office.
- `\\Server\Share\Microsoft365Apps\Current`: Stores the Microsoft 365 Apps installation files from Current Channel.
- `\\Server\Share\Microsoft365Apps\MonthlyEnterprise`: Stores the Microsoft 365 Apps installation files from Monthly Enterprise Channel.

These folders include all the installation files you need to deploy.

Assign Read permissions for your users. To install Microsoft 365 Apps from a shared folder, users need Read permission for the folder, so you should assign Read permission to everyone.

## Step 2: Download the Office Deployment Tool

Download the latest version of the ODT from the [Microsoft Download Center](https://www.microsoft.com/download/details.aspx?id=49117) to `\\Server\Share\Microsoft365Apps`.

After downloading the file, run the self-extracting executable file, which contains the Office Deployment Tool executable (setup.exe) and sample configuration files.

## Step 3: Create a configuration file for Current Channel

To download and deploy Microsoft 365 Apps to the first group, you use a configuration file with the ODT. To create the configuration file, we recommend using the Office Customization Tool.

1. Go to Office Customization Tool and configure the desired settings for your Microsoft 365 Apps installation. We recommend the following options:  
   - Products and releases: Microsoft 365 Apps. You can also include Visio and Project if you plan to deploy those apps to all devices.
   - Update channel: Choose Current Channel
   - Language: Include all the language packs you plan to deploy.
   - Installation: Select Local Source, and type `\\Server\Share\Microsoft365Apps\Current` for the source path. To silently install Office for your users, choose Off for Show installation to user.
   - Update and upgrade: To update your client devices automatically, choose Office Content Delivery Network CDN and Automatically check for updates. Choose to Uninstall any MSI versions of Office, including Visio and Project. You can also choose to install the same language as any removed MSI versions of Office.
   - Licensing and activation: To silently install Microsoft 365 Apps for your users, choose On for Automatically accept the Microsoft Software License Terms.
   - Application preferences: Define any settings you want to enable, including VBA macro notifications, default file locations, and default file formats
2. When you complete the configuration, select Export in the upper right of the page, and then save the file as configuration-cc.xml in the `\\Server\Share\Microsoft365Apps` folder.

## Step 4: Deploy to the Current Channel group

To deploy Microsoft 365 Apps, you provide commands that users can run from their client computers, or you incorporate these commands into your installation automation. The commands run the ODT in configure mode and with a reference to the appropriate configuration file, which defines which version of Microsoft 365 Apps to install on the client computer. Users who run these commands must have local admin privileges and read permissions to the share (`\\Server\share\Microsoft365Apps`).

From the client computers for the Current Channel group, run the following command from a command prompt with admin privileges:

`\\Server\Share\Microsoft365Apps\setup.exe /configure`
`\\Server\Share\Microsoft365Apps\configuration-cc.xml`

> Most organizations use this command as part of a batch file, script, or other process that automates the deployment. In those cases, you can run the script under elevated permissions, so the users won't need to have admin privileges on their computers.

After you run the command, the Microsoft 365 Apps installation should start immediately. If you run into problems, make sure you have the newest version of the ODT and your configuration file and command reference the correct locations. You can also troubleshoot issues by reviewing the log file in the %temp% and `C:\Windows\Temp` folder.

---

## Example `Autounattend.xml`

For more examples and a list of all available options see [Configuration options for office deployment tool](https://learn.microsoft.com/en-us/microsoft-365-apps/deploy/office-deployment-tool-configuration-options). To generate a new `AutoUnattend.xml` file, [use microsofts online tool](https://config.office.com/deploymentsettings)  

```xml
<Configuration ID="3f0b4606-54f7-4e0b-b293-6eb88396a51e">
  <Info Description="Silent install of O365 apps for AutoInc" />
  <Add OfficeClientEdition="64" Channel="MonthlyEnterprise">
    <Product ID="O365ProPlusEEANoTeamsRetail">
      <Product ID="O365ProPlusEEANoTeamsRetail">
      <Language ID="en-us" />
      <Language ID="MatchPreviousMSI" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OutlookForWindows" />
      <ExcludeApp ID="PowerPoint" />
      <ExcludeApp ID="Publisher" />
      <ExcludeApp ID="Bing" />
    </Product>
  </Add>
  <Property Name="SharedComputerLicensing" Value="0" />
  <Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
  <Property Name="DeviceBasedLicensing" Value="0" />
  <Property Name="SCLCacheOverride" Value="0" />
  <Updates Enabled="TRUE" />
  <RemoveMSI />
  <AppSettings>
    <Setup Name="Company" Value="CompanyNameHere" />
  </AppSettings>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
```