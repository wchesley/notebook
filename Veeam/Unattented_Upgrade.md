# Veeam Unattended Upgrade 

When using Veeam Service Provider console you can manage veeam agents and back up & replication servers from a single pane of glass. Including schedueling jobs, udating, or uninstalling veeam agents. 

You will have to install the VSPC agent onto the remote machine. 

## Unattended Upgrade File

Below is an example `xml` file from Veeam for unattended updates

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattendedInstallationConfiguration bundle="VBR" mode="upgrade">
  <!--[Required] Parameter 'mode' defines installation mode that silent install should operate in-->
  <!--Supported values: install/upgrade/uninstall-->

  <!--Note: unused [Optional] parameters should be removed from the answer file-->

  <properties>

    <!--License agreements-->
    <!--Specify parameters to accept all the license agreements during silent installation or upgrade-->

    <!--[Required] Parameter ACCEPT_EULA specifies if you want to accept the Veeam license agreement. Specify '1' to accept the license agreement and proceed with installation or upgrade-->
    <!--Supported values: 0/1-->
    <property name="ACCEPT_EULA" value="1" />

    <!--[Required] Parameter ACCEPT_LICENSING_POLICY specifies if you want to accept Veeam licensing policy. Specify '1' to accept the licensing policy and proceed with installation or upgrade-->
    <!--Supported values: 0/1-->
    <property name="ACCEPT_LICENSING_POLICY" value="1" />

    <!--[Required] Parameter ACCEPT_THIRDPARTY_LICENSES specifies if you want to accept all the 3rd party licenses used. Specify '1' to accept the license agreements and proceed with installation or upgrade-->
    <!--Supported values: 0/1-->
    <property name="ACCEPT_THIRDPARTY_LICENSES" value="1" />

    <!--[Required] Parameter ACCEPT_REQUIRED_SOFTWARE specifies if you want to accept all the required software licenses. Specify '1' to accept the license agreements and proceed with installation or upgrade-->
    <!--Supported values: 0/1-->
    <property name="ACCEPT_REQUIRED_SOFTWARE" value="1" />

    <!--License file-->
    <!--Specify path to a license file and autoupdate option-->

    <!--[Optional] Parameter VBR_LICENSE_FILE specifies a full path to the license file. If you do not specify this parameter(or leave it empty value), Veeam Backup & Replication will be installed using current license file. To install Community Edition it must be set to 0-->
    <!--Supported values: file path/0(to install CE)-->
    <!--property name="VBR_LICENSE_FILE" value="" /-->

    <!--[Optional] Parameter VBR_LICENSE_AUTOUPDATE specifies if you want to update license automatically(enables usage reporting). If you do not specify this parameter, autoupdate will be enabled. For Community Edition and NFR it must be set to 1. For licenses without license ID information it must be set to 0-->
    <!--Supported values: 0/1-->
    <property name="VBR_LICENSE_AUTOUPDATE" value="1" />

    <!--Service account-->

    <!--[Optional] Parameter VBR_SERVICE_PASSWORD specifies a password for the account under which the Veeam Backup Service is running. Required during upgrade if service account is not LocalSystem account-->
    <!--Make sure you keep the answer file in a safe location whenever service account password is added to the answer file-->
    <!--Supported values: password in plain text-->
    <!--property name="VBR_SERVICE_PASSWORD" value="" hidden="1"/-->

    <!--Database configuration-->
    <!--Specify database server installation options and required configuration parameters for Veeam Backup & Replication database-->

    <!--[Optional] Parameter VBR_SQLSERVER_PASSWORD specifies a password to connect to the SQL server in the native authentication mode-->
    <!--Make sure you keep the answer file in a safe location whenever SQL server account password is added to the answer file-->
    <!--Supported values: password in plain text-->
    <!--property name="VBR_SQLSERVER_PASSWORD" value="" hidden="1"/-->

    <!--Automatic update settings-->
    <!--Specify Veeam B&R autoupdate settings-->

    <!--[Optional] Parameter VBR_AUTO_UPGRADE specifies if you want Veeam Backup & Replication to automatically upgrade existing components in the backup infrastructure. If you do not specify this parameter, Veeam Backup & Replication will not upgrade out of date components automatically-->
    <!--Supported values: 0/1-->
    <property name="VBR_AUTO_UPGRADE" value="1" />

  </properties>
</unattendedInstallationConfiguration>
```