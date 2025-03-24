[back](./README.md)

# Windows Agent Install

**Installing Windows Agents**

To make the Agent deployment process more robust, we introduced a new installation package.

We
 still support the MSI installation package, but we recommend you use 
the new installer for a better installation experience and success 
rates. The new installation package is an MSI installer run by a 
SentinelOneInstaller.exe executable.

Use this new file to install Windows Agent 22.1 and later.

To upgrade a Windows Agent to version 22.1 and later with the new installation package, see [Updating Windows Agents](https://usea1-pax8-03.sentinelone.net/docs/en/updating-windows-agents.html).

To install the Windows Agent in a cloud environment, see [Installing the Windows Agent with Systems Manager](https://usea1-pax8-03.sentinelone.net/docs/en/installing-the-windows-agent-with-systems-manager.html).

The new installation package is GA in Windows Agent version 22.1 GA.

### Important

There are some changes in the installer arguments format between `SentinelInstaller.exe` (the old package) and `SentinelOneInstaller.exe` (the new package). Review your deployment scripts to identify if any change is required.

For Windows Agent 22.1 and above, `SentinelInstaller.exe` (the old package) will be replaced by `SentinelOneInstaller.exe` (the new package).

Prerequisites:

- Make sure you have [all requirements](https://usea1-pax8-03.sentinelone.net/docs/en/agent-requirements-on-windows.html) before you start the installation.
    
    The installation requires a user role with Administrator permissions.
    
- [Download the Installation Package](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4597147381673633212904357094).
- [Get the Site or Group Token](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4597147078825633212897259782).

The command to install, upgrade, and downgrade an Agent is the same. The Agent package and its version determine if it will install, upgrade, or downgrade the Agent.

The installer runs a series of tests on the endpoint to see if the installation will succeed. For details, see [Tests Run by the Installer on Endpoints Before Installing the Agent](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4665755208244833336933697585).

[Download the Installation Package](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4597147381673633212904357094_body)

1. See available installation packages in In the Sentinels toolbar, click Packages..
2. Download the latest **SentinelOneInstaller** Windows installer package.
**Important**
Make sure you use the file named **SentinelOneInstaller.exe** (the new installer) and not **SentinelInstaller.exe** (the old installer).
Make sure the Access Level  of the package includes the Site that the Agent will go to.
Best Practice: Download the file to the local endpoint.

1. 1.
    
    See available installation packages in In the Sentinels toolbar, click Packages..
    
2. 2.
    
    Download the latest **SentinelOneInstaller** Windows installer package.
    
    ### Important
    
    Make sure you use the file named **SentinelOneInstaller.exe** (the new installer) and not **SentinelInstaller.exe** (the old installer).
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-338ea41d-9fe6-057d-4914-3dbbe7393588.png)
    
    Make sure the Access Level  of the package includes the Site that the Agent will go to.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-a35264ea-5d11-c0c5-6b95-3e97beaaea97.png)
    
    Best Practice: Download the file to the local endpoint.
    

![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-338ea41d-9fe6-057d-4914-3dbbe7393588.png)

![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-a35264ea-5d11-c0c5-6b95-3e97beaaea97.png)

[Get the Site or Group Token](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4597147078825633212897259782_body)

Get
 the Site token or Group token. The token registers the Agent with a 
Site. If you use a Site token, the Agent goes to the Default Group of 
the Site. (If there are dynamic groups, the Agent can be pulled into a 
dynamic group.) If you use a Group token, the Agent goes to the Site and
 to the Group with that token.

You can use a Group Token for a **Manual Group** (previously a *Static Group*) or a **Pinned Group**. You cannot add Agents to a Dynamic Group. Agents are moved to Dynamic Groups from Manual Groups, if they match the conditions of the group.

To get the Site Token:

1. At the top left of the Console, click the arrow to open the Scopes panel and select a scope. Select one Site. If you are in any other scope, the Site Token does not show.
2. In the sidebar, click Sentinels. Endpoints opens.
3. In the Sentinels toolbar, click Site Info.
4. In the Site Token section, click Copy.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-ea7d271b-aca3-a06b-380b-79d5c5ba22f4.png)
    

To get a Group Token:

1. At the top left of the Console, click the arrow to open the Scopes panel and select a scope.
    
    You must select one Static Group.
    
2. In the sidebar, click Sentinels. Endpoints opens.
3. In the Sentinels toolbar, click Group Info.
4. In the Group Token section, click Copy.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-47aeffef-9fe8-8a64-4205-67f310703bb2.png)
    

[Install the Agent By Double-Clicking the File: Versions 22.2+](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4581075129518433069507791479_body)

**Objective:** Install SentinelOne Windows Agent on a local endpoint by double-clicking the installation file.

### Note

This option is available only for Agent versions 22.2+.

1. Go to the folder where you downloaded the new installation package.
2. Double-click the installation file.
3. Follow the instructions of the wizard.
4. Enter the Site or Group Token and click **Install**.
5. Wait for the process to complete.

1. 1.
    
    Go to the folder where you downloaded the new installation package.
    
2. 2.
    
    Double-click the installation file.
    
3. 3.
    
    Follow the instructions of the wizard.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-0ed8dfca-4a87-5239-8edc-d164b713b969.png)
    

![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-0ed8dfca-4a87-5239-8edc-d164b713b969.png)

1. 4.
    
    Enter the Site or Group Token and click **Install**.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-c43a36b7-31e6-ed5c-b37b-8a6464b8c8f8.png)
    

![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-c43a36b7-31e6-ed5c-b37b-8a6464b8c8f8.png)

1. 5.
    
    Wait for the process to complete.
    

[Install the Agent From the Local Command Line or a Deployment Tool: Versions 22.2+](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm483307779282074_body)

**Objective:** Install SentinelOne Windows Agent on a local endpoint from the local Command Line (CMD) or with a deployment tool such as GPO, SCCM, or Tanium.

### Note

This option is available only for Agent versions 22.2+.

1. Log in to one of these:
    ◦ A deployment tool with an administrator account.
**Note**
For instructions on how to upgrade a Windows Agent with SCCM using a PowerShell script, see [Upgrading Agents with SCCM Using a PowerShell Script](https://usea1-pax8-03.sentinelone.net/docs/en/upgrading-agents-with-sccm-using-a-powershell-script.html).
    ◦ The command prompt on a local endpoint. In Windows Start or Search, enter **CMD** > right-click **Command Prompt**, and select **Run as administrator**.
    ◦ PowerShell
2. Go to the folder where you downloaded the new installation package.
Example:

`cd C:\Users\adminWin\Downloads`

1. 1.
    
    Log in to one of these:
    
    - ◦
        
        A deployment tool with an administrator account.
        
        ### Note
        
        For instructions on how to upgrade a Windows Agent with SCCM using a PowerShell script, see [Upgrading Agents with SCCM Using a PowerShell Script](https://usea1-pax8-03.sentinelone.net/docs/en/upgrading-agents-with-sccm-using-a-powershell-script.html).
        
    - ◦
        
        The command prompt on a local endpoint. In Windows Start or Search, enter **CMD** > right-click **Command Prompt**, and select **Run as administrator**.
        
    - ◦
        
        PowerShell
        
- A deployment tool with an administrator account.
    
    ### Note
    
    For instructions on how to upgrade a Windows Agent with SCCM using a PowerShell script, see [Upgrading Agents with SCCM Using a PowerShell Script](https://usea1-pax8-03.sentinelone.net/docs/en/upgrading-agents-with-sccm-using-a-powershell-script.html).
    
- The command prompt on a local endpoint. In Windows Start or Search, enter **CMD** > right-click **Command Prompt**, and select **Run as administrator**.
- PowerShell
1. 2.
    
    Go to the folder where you downloaded the new installation package.
    
    Example:
    
    `cd C:\Users\adminWin\Downloads`
    

Install the Agent:

- From CMD run:
    
    `*SentinelOneInstaller.exe* [-a *installer_arguments*] -t *site_Token or group_Token*`
    

Example:

`SentinelOneInstaller_windows_64bit_v22_2_1_200.exe -t a1b2c3d4e5f6g7h8i9a1b2c3d4e5f6g7h8i9`

From PowerShell run:

`./*SentinelOneInstaller.exe* [-a *installer_arguments*] -t *site_Token or group_Token*`

Example:

`./SentinelOneInstaller_windows_64bit_v22_2_1_200.exe -t a1b2c3d4e5f6g7h8i9a1b2c3d4e5f6g7h8i9`

Where:

- `*SentinelOneInstaller.exe*` is the full package name.
- `a *installer_arguments*` : Installer arguments are optional. For a list of installer arguments, see [Installer Arguments](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm483293799503508).
    
    If
     there is a web proxy between the endpoints and the Console, you must 
    use the installer arguments to configure the proxy for the Agent in the 
    installation command. To configure a proxy after the Agent is installed,
     you must [use sentinelctl](https://usea1-pax8-03.sentinelone.net/docs/en/configuring-a-proxy-server-for-windows-agents.html).
    
- `t *site_Token or group_Token*` is the site token or group token.
    
    ### Important
    
    If you add the `-q` parameter you must use the `-t` parameter and enter the token.
    
    If you do not use `-q` parameter, the `-t` parameter is optional in this step of the procedure. If you do not enter the token now, you must add it into the UI later.
    
- q, --qn
    
    Optional unless you use a deployment tool to install theAgent (then it is mandatory).
    
    Quiet
     mode. The installer does not show the status of the upgrade as it 
    progresses, and does not automatically show a return code when the 
    upgrade completes.
    
    ### Important
    
    If you use the `-q` or `--qn` parameter, you must also use the `-t` parameter and enter the token.
    
    Example syntax:
    
    `SentinelOneInstaller.exe -t site_Token -q`
    
- Optional.Automatically reboot the endpoint when one of these exit codes would have been returned after the installation:Optional.Add to clean the Agent (remove previous installation directories and the
current Agent) without installing a new version of the Agent.To use `c` (clean only), you must:Optional.Syntax: `k *passphrase*` where `*passphrase*` is the Agent or Account passphrase, needed to validate privileges.The Agent or Account passphrase to validate privileges.
    - b, --reboot_on_need
        
        Optional.
        
        Automatically reboot the endpoint when one of these exit codes would have been returned after the installation:
        
        - 100: The uninstall of the previous Agent succeeded. Reboot the endpoint to continue with the installation of the new Agent.
        - 103: Reboot is required to uninstall the previous Agent and install the new Agent.
        - 104: Reboot is already required by a previous run of the installer.
    - 
    - 
    - 
    - c, --clean_only
        
        Optional.
        
        Add
         to clean the Agent (remove previous installation directories and the 
        current Agent) without installing a new version of the Agent.
        
        To use `-c` (clean only), you must:
        
        - Use `t` (site token), AND
        - Use either `k` with the Agent or Account passphrase, or the Confirm Local Upgrade action.
    - 
    - 
    - k, --key
        
        Optional.
        
        Syntax: `-k *passphrase*` where `*passphrase*` is the Agent or Account passphrase, needed to validate privileges.
        
        The Agent or Account passphrase to validate privileges.
        
- Follow the instructions of the wizard.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-0ed8dfca-4a87-5239-8edc-d164b713b969.png)
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-7972b8f7-500c-5bfb-483b-e2b1a4935844.png)
    
- If you added `t *site_Token or group_Token*` to the command, the token already appears in the UI. Click **Install**.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-f2615d79-1b16-395b-4449-5e983f5db2d6.png)
    
    If you did not add `-t *site_Token or group_Token*` to the command, enter the Site or Group Token and click **Install**.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-c43a36b7-31e6-ed5c-b37b-8a6464b8c8f8.png)
    
- Wait for the process to complete. Click **Finish**.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-188273e1-dd06-97ad-0ff2-fc46df1fcacc.png)
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-9a6c5e07-5bea-3b62-b5a3-eebcee67e277.png)
    
- If more Agent capabilities will be enabled after you reboot the endpoint, a notification appears.
    
    You do NOT have to reboot the endpoint.
    
    ![](https://usea1-pax8-03.sentinelone.net/docs/en/image/uuid-7d5bccdb-51b6-d6a2-751f-a1b26fb1ca90.png)
    
    Optional: Click Yes to automatically reboot the endpoint.
    
    ### Note
    
    If you are installing version 23.4.1 or later, this notification does not appear, and rebooting the endpoint is not necessary.
    
- Get the return code.
    - The return code is in the `C:\windows\temp` directory, in `SC-exit-code.txt` or `SC-after-reboot-exit-code.txt`. Open the most recently edited file.
    - If you ran the tool from CMD, run:
        
        `start /wait SentinelOneInstaller.exe -t "..."
        echo %errorlevel%`
        

If you ran the tool from PowerShell (elevated), run:

`.\SentinelOneInstaller.exe -t "..." | Out-Host
$LastExitCode`

If you ran the tool from PowerShell (non-elevated), run

`$p = Start-Process .\SentinelOneInstaller.exe -PassThru -Wait -ArgumentList '-t "..."'
$p.ExitCode`

- If the tool is run from PowerShell (non-elevated), the command line arguments must be specified with the -ArgumentList, see[documentation for PowerShell](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.4#example-7-specifying-arguments-to-the-process).
    - Note
        
        If the tool is run from PowerShell (non-elevated), the command line arguments must be specified with the -ArgumentList, see[documentation for PowerShell](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.4#example-7-specifying-arguments-to-the-process).
        
- Find your return code (also called exit code) in [Return Codes After Installing or Updating Windows Agents](https://usea1-pax8-03.sentinelone.net/docs/en/return-codes-after-installing-or-updating-windows-agents.html) and follow the instructions in the **Next Step** column.
- Validate that a new version is installed.
    
    1. From the endpoint, go to the SentinelOne Agent directory:
    
    `cd "c:\Program Files\SentinelOne\Sentinel Agent *version*"`
    
    1. 1.
        
        From the endpoint, go to the SentinelOne Agent directory:
        
        `cd "c:\Program Files\SentinelOne\Sentinel Agent *version*"`
        

Example:

`cd "c:\Program Files\SentinelOne\Sentinel Agent 22.2.3.402"`

Run this sentinelctl command:

`sentinelctl status`

Look at the **Monitor Build id** in the output to validate that a new version of the Agent is installed and the Agent is loaded and running.

Example output:

`Disable State: Not disabled by the user
SentinelMonitor is loaded
Self-Protection status: On
Monitor Build id: 22.2.3.402+a1b2c3d4e5f6g7h8i9-Release.x64
SentinelAgent is loaded
SentinelAgent is running as PPL
Mitigation policy: quarantineThreat`

[Install the Agent From the Local Command Line or a Deployment Tool: Version 22.1](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm483301739122594_body)

**Objective:** Install SentinelOne Windows Agent on a local endpoint from the local Command Line (CMD) or with a deployment tool such as GPO, SCCM, or Tanium.

1. Log in to one of these:
    ◦ A deployment tool with an administrator account.
**Note**
For instructions on how to upgrade a Windows Agent with SCCM using a PowerShell script, see [Upgrading Agents with SCCM Using a PowerShell Script](https://usea1-pax8-03.sentinelone.net/docs/en/upgrading-agents-with-sccm-using-a-powershell-script.html).
    ◦ The command prompt on a local endpoint. In Windows Start or Search, enter **CMD** > right-click **Command Prompt**, and select **Run as administrator**.
    ◦ PowerShell
2. Go to the folder where you downloaded the new installation package.
Example:

`cd C:\Users\adminWin\Downloads`

1. 1.
    
    Log in to one of these:
    
    - ◦
        
        A deployment tool with an administrator account.
        
        ### Note
        
        For instructions on how to upgrade a Windows Agent with SCCM using a PowerShell script, see [Upgrading Agents with SCCM Using a PowerShell Script](https://usea1-pax8-03.sentinelone.net/docs/en/upgrading-agents-with-sccm-using-a-powershell-script.html).
        
    - ◦
        
        The command prompt on a local endpoint. In Windows Start or Search, enter **CMD** > right-click **Command Prompt**, and select **Run as administrator**.
        
    - ◦
        
        PowerShell
        
- A deployment tool with an administrator account.
    
    ### Note
    
    For instructions on how to upgrade a Windows Agent with SCCM using a PowerShell script, see [Upgrading Agents with SCCM Using a PowerShell Script](https://usea1-pax8-03.sentinelone.net/docs/en/upgrading-agents-with-sccm-using-a-powershell-script.html).
    
- The command prompt on a local endpoint. In Windows Start or Search, enter **CMD** > right-click **Command Prompt**, and select **Run as administrator**.
- PowerShell
1. 2.
    
    Go to the folder where you downloaded the new installation package.
    
    Example:
    
    `cd C:\Users\adminWin\Downloads`
    

Install the Agent:

- From CMD run:
    
    `*SentinelOneInstaller.exe* [-a *installer_arguments*] --dont_fail_on_config_preserving_failures -t *site_Token or group_Token*`
    

Example:

`SentinelOneInstaller_windows_64bit_v22_1_2_210.exe --dont_fail_on_config_preserving_failures -t a1b2c3d4e5f6g7h8i9a1b2c3d4e5f6g7h8i9`

From PowerShell run:

`./*SentinelOneInstaller.exe* [-a *installer_arguments*] --dont_fail_on_config_preserving_failures -t *site_Token or group_Token*`

Example:

`./SentinelOneInstaller_windows_64bit_v22_1_2_210.exe --dont_fail_on_config_preserving_failures -t a1b2c3d4e5f6g7h8i9a1b2c3d4e5f6g7h8i9`

- Where:
    - `*SentinelOneInstaller.exe*` is the full package name.
    - `a *installer_arguments*` : Installer arguments are optional. For a list of installer arguments, see [Installer Arguments](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm483293799503508).
        
        If
         there is a web proxy between the endpoints and the Console, you must 
        use the installer arguments to configure the proxy for the Agent in the 
        installation command. To configure a proxy after the Agent is installed,
         you must [use sentinelctl](https://usea1-pax8-03.sentinelone.net/docs/en/configuring-a-proxy-server-for-windows-agents.html).
        
    - -dont_fail_on_config_preserving_failures
        
        The
         installer will always try to preserve the configuration. If you add 
        this parameter, it will not stop on failure if it cannot preserve the 
        previous Agent configuration.
        
        ### Important
        
        This parameter is mandatory for version 22.1 but optional for versions 22.2+.
        
    - `t *site_Token or group_Token*` is the site token or group token.
    - b, --reboot_on_need
        
        Optional.
        
        Automatically reboot the endpoint when required to continue with the installation.
        
    - c, --clean_only
        
        Optional.
        
        Add
         to clean the Agent (remove previous installation directories and the 
        current Agent) without installing a new version of the Agent.
        
        To use `-c` (clean only), you must:
        
        - Use `t` (site token), AND
        - Use either `k` with the Agent or Account passphrase, or the Confirm Local Upgrade action.
    - k, --key
        
        Optional.
        
        Syntax: `-k *passphrase*` where `*passphrase*` is the Agent or Account passphrase, needed to validate privileges.
        
        The Agent or Account passphrase to validate privileges.
        
- Wait for the process to complete.
- Get the return code.
    - The return code is in the `C:\windows\temp` directory, in `SC-exit-code.txt` or `SC-after-reboot-exit-code.txt`. Open the most recently edited file.
    - Alternatively,
        
        If you ran the tool from CMD, run:
        
        `echo %errorlevel%`
        

If you ran the tool from PowerShell, run:

`$LastExitCode`

- Find your return code (also called exit code) in [Return Codes After Installing or Updating Windows Agents](https://usea1-pax8-03.sentinelone.net/docs/en/return-codes-after-installing-or-updating-windows-agents.html) and follow the instructions in the **Next Step** column.
- Validate that a new version is installed.
    
    1. From the endpoint, go to the SentinelOne Agent directory:
    
    `cd "c:\Program Files\SentinelOne\Sentinel Agent *version*"`
    
    1. 1.
        
        From the endpoint, go to the SentinelOne Agent directory:
        
        `cd "c:\Program Files\SentinelOne\Sentinel Agent *version*"`
        

Example:

`cd "c:\Program Files\SentinelOne\Sentinel Agent 22.2.3.402"`

Run this sentinelctl command:

`sentinelctl status`

Look at the **Monitor Build id** in the output to validate that a new version of the Agent is installed and the Agent is loaded and running.

Example output:

`Disable State: Not disabled by the user
SentinelMonitor is loaded
Self-Protection status: On
Monitor Build id: 22.2.3.402+a1b2c3d4e5f6g7h8i9-Release.x64
SentinelAgent is loaded
SentinelAgent is running as PPL
Mitigation policy: quarantineThreat`

[Installer Arguments](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm483293799503508_body)

- If you use any of the installer arguments [in this table](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_informaltable-idm483294355728284), add the flag `a` before the installer argument and wrap the argument with quotation marks (" "). After the flag `a` you may add the equals character (=), but you do not have to.
    
    Example:
    
    `SentinelOneInstaller_windows_64bit_v22_2_1_200.exe -t MY_TOKEN -a "VDI=true AGENT_LOGGING=true"`
    

or

`SentinelOneInstaller_windows_64bit_v22_2_1_200.exe -t MY_TOKEN -a="VDI=true AGENT_LOGGING=true"`

If
 an argument should contain quotation marks (" "), for example 
CUSTOMER_ID="Customer Identifier string", add three quotation marks.

Example:

`SentinelOneInstaller_windows_64bit_v22_2_1_200.exe -a "CUSTOMER_ID="""123321""""`

- Do not add `/NORESTART`. It will not affect the installation. By default, installing the Agent does not reboot the endpoint.
- Regarding SentinelOneInstaller and Quiet mode:
    - In Agent 22.1, Quiet mode is not supported. Do not add `/QUIET` because it will not affect the installation. Version 22.1 does not support the parameters `q` or `-qn`.
    - In Agents 22.2+ Quiet mode is supported but it is NOT the default. To run the installer in quiet mode add `q` or `-qn`. Do not add `/QUIET` because it will not affect the installation.

Optional Installer Arguments

| Optional Arguments | Description |
| --- | --- |
| SERVER_PROXY=*mode* | Set a proxy server between the Agent and its Management.
**Important**
For Windows Agents: If there is a web proxy between the endpoints and the Console, we recommend you [configure the proxy](https://usea1-pax8-03.sentinelone.net/docs/en/configuring-a-proxy-server-for-windows-agents.html)  for the Windows Agent in the installation command. If you did not configure a proxy, the Agent is already installed, and there is no connection between the Agent and the Management Console, see [*How to Fix Never Connected Agents*](https://usea1-pax8-03.sentinelone.net/docs/en/how-to-fix-never-connected-agents.html)
Agent in the installation command. If you did not configure a proxy, the Agent is already installed, and there is no connection between the Agent and the Management Console, see [*How to Fix Never Connected Agents*](https://usea1-pax8-03.sentinelone.net/docs/en/how-to-fix-never-connected-agents.html).
**Mode valid values:**
• `auto` = use the Windows LAN settings (PAC file)
• `system` = use **Other** proxy (not from OS) configured in the local Agent
• `user`,*fallback*[:*port*] = user mode on Windows
• `http://`*{IP  `| FQDN}:[`port*] |
| AGENT_LOGGING={true | false} | Disable Agent logging. |
| INSTALL_PATH_DATA="*drive:*\*path*" | Customize the path for Agent database, logs, and large data files.Requirements
• The path must be in English, 150 characters or less.
• The path must be a fixed drive (it cannot be a USB or other removable media), and it must be NTFS.
• If the path is not on the System drive, it must have at least 4 GB free space.
(Supported from Agent versions 3.6) |
| SERVER_PROXY_CREDENTIALS=*user:pass* | Set credentials to authenticate with the Management proxy. |
| IOC_PROXY=*mode* | Set a proxy server between the Agent and the Deep Visibility™ EDR data server. 
**Mode valid values:**
• `single` = use the same proxy for Management and for Deep Visibility™
• `auto` = use the Windows LAN settings (PAC file)
• `system` = use **Other** proxy (not from OS) configured in the local Agent
• `user`,*fallback*[:*port*] = user mode on Windows
• `http://`*{IP  `| FQDN}:[`port*] |
| IOC_PROXY_CREDENTIALS=*username:password* | Set the username and password to authenticate with the Deep Visibility™ proxy. |
| FORCE_PROXY={true | false} | Prevent fallback to direct communication if the proxy is not available.
Important! If the Management proxy or the Deep Visibility™ proxy is configured with `user` mode, do not use Force Proxy. |
| WSC={true | false} | Set the Agent installation to disable (true) or not disable (false) Windows Defender. |
| CUSTOMER_ID="*Customer Identifier string*" | Add a user-defined Identifier string to the endpoint.
Syntax:

`SentinelOneInstaller.exe -a "CUSTOMER_ID="""Customer Identifier string""""` |

| VDI={true | false} | Install on Virtual Desktop Infrastructure or VMs with a Golden (Master) Image.
**Important:** This property is NOT recommended for all VM installation types. See [Installing Windows Agents on VM or VDI](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents-on-vm-or-vdi.html) for when this property is recommended. |
| --- | --- |

[Tests Run by the Installer on Endpoints Before Installing the Agent](https://usea1-pax8-03.sentinelone.net/docs/en/installing-windows-agents.html#UUID-1d30b56d-0ff8-1f26-023f-8219fddab745_sidebar-idm4665755208244833336933697585_body)

After
 you run the installation package, before the installation starts, the 
installer runs a series of tests on the endpoint to see if the 
installation will succeed.

- The endpoint has enough disk space and RAM (greater than 1 GB) to run the installation.
- The endpoint Admin has the required permissions.
- Operating System is Windows 7 SP1 and above.
- File system:
    - Agent data directory must be a fixed NTFS drive.
    - If the Agent data directory is the default drive, 2 GB on the system drive is required. Otherwise, 4 GB on the data drive and 500 MB on the system drive are required.
- Program Files and Windows directory must reside on the same drive letter.
Changing the location of Program Files is not supported by Microsoft.
See Microsoft KB933700.
- Microsoft
KB2533623 (Insecure library loading could allow remote code execution)
must be installed. After installation of the update, you need to restart your computer and begin the Agent installation process again.
- SHA256 code signing support - Microsoft KB3033929 - Security Update for Windows must be installed.
- Existence and Integrity of cryptographic services and databases under Windows CryptSvc.

## Return Codes After Installing or Updating Windows Agents

These return codes (also called exit codes) are returned after you try to install, upgrade, or downgrade the Windows Agent 22.1 or later using the SentinelOneInstaller.exe installation package.

| Value | Scenario | Status | Detailed Status | Description | Next Step |
| --- | --- | --- | --- | --- | --- |
| 0 | Install or Upgrade | Completed | Installation/Upgrade completed | Complete success. Uninstall and re-install were triggered, but the installation completed successfully. | Continue with the procedure. Validate that a new version of the Agent is installed. |
| 12 | Upgrade | Completed | Upgrade completed | Complete success. Uninstall and re-install were not triggered. | Continue with the procedure. Validate that a new version of the Agent is installed. |
| 100 | Upgrade | Pending User Action | Upgrade is pending on reboot | The uninstall of the previous Agent succeeded. Reboot the endpoint to continue with the installation of the new Agent. | Reboot the endpoint. |
| 101 | Upgrade | Pending User Action | Upgrade is pending on reboot | Reboot is required to continue with the installation. | Reboot the endpoint. |
| 103 | Upgrade | Pending User Action | Upgrade is pending on reboot | Reboot is required to uninstall the previous Agent and install the new Agent. | Reboot the endpoint. |
| 104 | Upgrade | Pending User Action | Upgrade is pending on reboot | Reboot is already required by a previous run of the installer. | Reboot the endpoint. |
| 200 | Local Uninstall | Pending User Action | Uninstall is pending on reboot | Cleaning (remove previous installation directories and the current Agent) will be done after reboot.
This return code can be returned only when using the `clean_only` (`-c`) flag. | Reboot the endpoint. |
| 201 | Special Flow |  |  | Failed taking diagnostics. | Contact Support. |
| 202 | Special Flow |  |  | Health check deleted old directories successfully. |  |
| 203 | Special Flow |  |  | Health check deleted old directories successfully. | Reboot the endpoint to complete the cleaning. |
| 204 |  |  |  | Internal use only. | Nothing. |
| 205 | Install or Upgrade | Canceled | Installation/Upgrade aborted | Aborted by the user (from the endpoint). | Nothing. |
| 206 | Install or Upgrade | Canceled | Installation/Upgrade canceled | Handled by command line parser. Example: You passed the wrong argument. | Nothing. |
| 1000 | Upgrade | Canceled | Agent has the same version | Upgrade canceled. Cannot continue with the upgrade. An Agent with the same or higher version is already installed on the endpoint. | Nothing. No upgrade is necessary. |
| 1001 | Downgrade | Canceled | Agent cannot be downgraded | Downgrade canceled. The version you are trying to downgrade to is too old. | Reboot the endpoint. |
| 1002 | Install or Upgrade | Canceled | Another installer is already running. | Installation or upgrade canceled. Another installer is already running. | Wait for the previous running to finish. |
| 1003 | Install or Upgrade | Canceled | Another installer is already running. | Installation or upgrade canceled. Another MSI installer is already running. | Finish the other MSI installer. |
| 1004 | Upgrade | Not relevant | Upgrade canceled | Upgrade canceled. The arguments given to the Installer (using -a or -- installer arguments) are invalid. | Check the installer arguments. |
| 1005 | Upgrade | Not relevant | Upgrade canceled | Upgrade Canceled, the passphrase provided is invalid. | Provide the correct passphrase or contact Support. |
| 1006 | Upgrade | Not relevant | Upgrade canceled | Internal use only. | Contact Support. |
| 1009 | Install | Failed | Installation aborted | Windows Task Scheduler folders `\Sentinel` and/or `\SentinelOne` are inaccessible. For example, if a Task Scheduler task exists at this path. | Delete the existing `\Sentinel` and/or `\SentinelOne` folders, or ensure they are accessible (for example, delete the problematic task), then run the installer again. |
| 2000 | Install or Upgrade | Failed | Installation failed - unexpected error | General failure. Logs and diagnostic data will help you understand this issue, and will be sent automatically to the SentinelOne Cloud. | Collect logs and contact support to troubleshoot. |
| 2001 | Upgrade | Failed | Installation failed | Upgrade failed. Cannot proceed with the uninstall and re-install. | Collect logs and contact support to troubleshoot. |
| 2002 | Install or Upgrade | Failed | Installation failed | Installation failed or upgrade failed. The previous Agent was uninstalled but the installation of the new Agent failed. | Collect logs and contact support to troubleshoot. |
| 2003 | Upgrade | Failed | Installation failed | Failed to uninstall the old Agent. | Collect logs and contact support to troubleshoot. |
| 2004 | Upgrade, or use the `-c` parameter | Failed | Installation failed | Retry in Safe Mode. | If you ran the tool without a passphrase (`-k`) , rerun the tool with the passphrase. If you get this error code again, [reboot the endpoint into Windows Safe Mode](https://support.microsoft.com/en-us/help/12376/windows-10-start-your-pc-in-safe-mode) and try again. |
| 2005 | Upgrade | Failed | Installation failed | Upgrade authentication error. Failed to get upgrade approval from the Management. | Make sure the upgrade was approved and the endpoint has an internet connection to the Management. |
| 2006 | Upgrade | Failed | Installation failed | Configuration not found. Unable to proceed with the upgrade. | Collect logs and contact support to troubleshoot. |
| 2007 | Upgrade | Failed | Installation failed - unexpected error | The upgrade failed. The installer faced an unexpected error. Cannot proceed with the uninstall and re-install. | Reboot the endpoint. If that does not help, contact Support. |
| 2008 | Install or Upgrade | Failed | Installation failed | Missing site token. | Try again with the site token. From the command line, add the parameter `-t *<site_token>*`. |
| 2009 | Upgrade | Failed | Installation failed | Failed to retrieve the Agent UID. | Upgrade the Agent again with the parameter `--dont_preserve_agent_uid` or contact Support.
**Note:** If you are uninstalling and reinstalling the same Agent version, you might need to reboot the endpoint before you attempt to reinstall the Agent. |
| 2010 | Upgrade | Not relevant | Upgrade failed | Interactive desktop required. | Run the upgrade in Quiet mode. Upgrade the Agent again with the parameter `-q` or `--qn`.
These parameters are available for Agent versions 22.2+. |
| 2011 | Install or Upgrade | Failed | Installation failed | The installer is not signed correctly. | Download a new installer and verify the certificates are up to date. See [How To Solve an Invalid Signature Error](https://usea1-pax8-03.sentinelone.net/docs/en/how-to-solve-an-invalid-signature-error.html). |
| 2012 | Upgrade | Failed | Installation failed | Could not determine the currently installed Agent version. | Upgrade the Agent again with the parameter `--force` or contact Support. |
| 2013 | Install or Upgrade | Failed | Installation failed | Insufficient system resources. |  |
| 2014 | Install or Upgrade | Failed | Installation failed | Extract resources general failure. | Collect logs and contact support to troubleshoot. |
| 2015 | Install or Upgrade | Failed | Installation failed | System requirements not met. | Read the requirement shown in the message. |
| 2016 | Install or Upgrade | Failed | Installation failed | Microsoft KB2533623 is not installed. | Windows 7 with KB2533623 or a newer OS is required. Upgrade and restart your Windows and try again. |
| 2017 | Install or Upgrade | Failed | Installation failed | Failed to load DLLs safely. | Collect logs and contact support to troubleshoot. |
| 2018 | Downgrade | Failed | Installation failed | Downgrade failed. | Collect logs and contact support to troubleshoot. |
| 2019 | Upgrade | Failed | Installation failed | Upgrade authentication error. Failed to get upgrade approval from the Management. | Make sure the upgrade was approved and the endpoint has an internet connection to the Management. |
| 2020 | Install or Upgrade | Failed | Installation failed | Not enough space on the system drive. | Free space on the disk and try again. |
| 2021 | Upgrade | Failed | Installation failed | Upgrade authentication error. Failed to get upgrade approval from the Management. | Make sure the upgrade was approved and the endpoint has an internet connection to the Management. |
| 2022 | Install | Failed | Installation failed | Unable to create an App Container. | Collect logs and contact support to troubleshoot. |
| 2023 | Upgrade | Failed | Installation failed | Not enough space on the system drive. | Free space on the disk and try again. |
| 2024 | Upgrade | Failed | Upgrade failed | Cannot open signed message file. | Contact Support. |
| 2025 | Upgrade | Failed | Upgrade failed | Offline signed message authentication error. | Contact Support. |
| 2026 | Upgrade | Failed | Installation failed | ISAPI filter removal process failed. | If the upgrade fails, collect logs and contact support to troubleshoot. |
| 2027 | Install or Upgrade | Completed | Upgrade failed | The Agent was installed and is in Disabled mode. |  |
| 2028 | Upgrade | Completed | Upgrade failed | The Agent was upgraded and the new Agent is in Disabled mode. |  |
| 2029 | Install or Upgrade |  |  | Failed to create a working directory under `%WINDIR%\Temp`. | Verify that the path exists and that you have sufficient privileges. |
| 2030 | Install or Upgrade |  |  | The installer failed to open one of the files under its own working directory. | Verify that third-party tools are disabled. |
| 2031 | Upgrade | Failed | Upgrade aborted | Windows Task Scheduler folders `\Sentinel` and/or `\SentinelOne` are inaccessible and could not be removed automatically. For example, if a Task Scheduler task exists at this path. | Delete the existing `\Sentinel` and/or `\SentinelOne` folders, or ensure they are accessible (for example, delete the problematic task), then run the installer again. |
| 2032 | Install or Upgrade |  |  | The SentinelOne Installer log could not be opened. |  |
| 999950 | Upgrade | Scheduled |  | The Update Timing is set to According to Maintenance Window or custom time range, and the Agent will update in the next available window. | Optional:
 Make sure the maintenance windows are set correctly in Upgrade Policy. 
To run the upgrade immediately, cancel the scheduled upgrade. Then 
select **Actions > Update Agent**, and in Update Timing, select Immediately. |
| 9999300 | Upgrade | In Progress |  | Waiting for the endpoint to be online. | Wait for the whole upgrade process to complete. |
| 9999301 | Upgrade | In Progress |  | In Queue. Waiting for resources to be available. For example, Maximum concurrent downloads setting is reached, so Agents must wait. | Wait for the whole upgrade process to complete. |
| 9999302 | Upgrade |  |  | No maintenance window or custom time range is configured. | Set one or more maintenance windows, or a custom time range, in Upgrade Policy. Update Timing is set to According to Maintenance Window or a custom time range, and the Agent will update in the next available window. |
| 9999400 | Upgrade | In Progress |  | Command sent. Only for Agents before 4.1 that do not support the new status reporting. |  |
| 9999401 | Upgrade | In Progress |  | Download started. Wait for the whole upgrade process to complete. |  |
| 9999402 | Upgrade | In Progress |  | Download finished. Wait for the whole upgrade process to complete. |  |
| 9999403 | Upgrade | In Progress |  | Installation of new version started. Wait for the whole upgrade process to complete. |  |
| 9999500 | Upgrade | Canceled |  | The task was canceled. |  |
| 9999501 | Upgrade | Canceled |  | The task was canceled. |  |
| 9999502 | Upgrade | Canceled |  | The task was canceled. |  |
| 99992500 | Install or Upgrade | Failed |  | Download failed. The download process could not complete. | Check your network connection and try again. |
| 99992501 | Install or Upgrade | Failed |  | Installation failed. Invalid package type. | Use a different package type to upgrade this Agent, for example MSI and not EXE.
OR
Configure a network share to grab certificate updates in firewalled and offline scenarios (see Microsoft instructions). See [How To Solve an Invalid Signature Error](https://usea1-pax8-03.sentinelone.net/docs/en/how-to-solve-an-invalid-signature-error.html). |
| 99992502 | Install or Upgrade | Failed |  | Installation failed. Corrupt package. | Download the package from the Management Console again. |
| 99992503 | Install or Upgrade | Failed |  | Installation failed. Invalid signature. | Download the package from the Management Console again. |
| 99992504 | Install or Upgrade | Failed |  | Installation failed. File not found. | Make sure that the file exists in the path you specified for the upgrade file. |
| 99992505 | Install or Upgrade | Failed |  | Installation failed. Unexpected error. |  |
| 99992506 | Install or Upgrade | Failed |  | Unknown status. |  |
| 9999600 | Upgrade | Expired |  | If the Agent
 version change task is in progress for 30 minutes with no update 
received from the endpoint, the task is marked as Expired to make the 
resources available. | Make
 sure the endpoint can communicate with the Management. When the 
endpoint sends an update, the task will change automatically from 
Expired to the current state. |
| 9999601 | Upgrade | Expired |  | The endpoint is decommissioned. |  |

| Value | Scenario | Status | Detailed Status | Description | Next Step |
| --- | --- | --- | --- | --- | --- |
| 0 | Install or Upgrade | Completed | Installation/Upgrade completed | Complete success. Uninstall and re-install were triggered, but the installation completed successfully. | Continue with the procedure. Validate that a new version of the Agent is installed. |
| 12 | Upgrade | Completed | Upgrade completed | Complete success. Uninstall and re-install were not triggered. | Continue with the procedure. Validate that a new version of the Agent is installed. |
| 100 | Upgrade | Pending User Action | Upgrade is pending on reboot | The uninstall of the previous Agent succeeded. Reboot the endpoint to continue with the installation of the new Agent. | Reboot the endpoint. |
| 101 | Upgrade | Pending User Action | Upgrade is pending on reboot | Reboot is required to continue with the installation. | Reboot the endpoint. |
| 103 | Upgrade | Pending User Action | Upgrade is pending on reboot | Reboot is required to uninstall the previous Agent and install the new Agent. | Reboot the endpoint. |
| 104 | Upgrade | Pending User Action | Upgrade is pending on reboot | Reboot is already required by a previous run of the installer. | Reboot the endpoint. |
| 200 | Local Uninstall | Pending User Action | Uninstall is pending on reboot | Cleaning (remove previous installation directories and the current Agent) will be done after reboot.
This return code can be returned only when using the `clean_only` (`-c`) flag. | Reboot the endpoint. |
| 201 | Special Flow |  |  | Failed taking diagnostics. | Contact Support. |
| 202 | Special Flow |  |  | Health check deleted old directories successfully. |  |
| 203 | Special Flow |  |  | Health check deleted old directories successfully. | Reboot the endpoint to complete the cleaning. |
| 204 |  |  |  | Internal use only. | Nothing. |
| 205 | Install or Upgrade | Canceled | Installation/Upgrade aborted | Aborted by the user (from the endpoint). | Nothing. |
| 206 | Install or Upgrade | Canceled | Installation/Upgrade canceled | Handled by command line parser. Example: You passed the wrong argument. | Nothing. |
| 1000 | Upgrade | Canceled | Agent has the same version | Upgrade canceled. Cannot continue with the upgrade. An Agent with the same or higher version is already installed on the endpoint. | Nothing. No upgrade is necessary. |
| 1001 | Downgrade | Canceled | Agent cannot be downgraded | Downgrade canceled. The version you are trying to downgrade to is too old. | Reboot the endpoint. |
| 1002 | Install or Upgrade | Canceled | Another installer is already running. | Installation or upgrade canceled. Another installer is already running. | Wait for the previous running to finish. |
| 1003 | Install or Upgrade | Canceled | Another installer is already running. | Installation or upgrade canceled. Another MSI installer is already running. | Finish the other MSI installer. |
| 1004 | Upgrade | Not relevant | Upgrade canceled | Upgrade canceled. The arguments given to the Installer (using -a or -- installer arguments) are invalid. | Check the installer arguments. |
| 1005 | Upgrade | Not relevant | Upgrade canceled | Upgrade Canceled, the passphrase provided is invalid. | Provide the correct passphrase or contact Support. |
| 1006 | Upgrade | Not relevant | Upgrade canceled | Internal use only. | Contact Support. |
| 1009 | Install | Failed | Installation aborted | Windows Task Scheduler folders `\Sentinel` and/or `\SentinelOne` are inaccessible. For example, if a Task Scheduler task exists at this path. | Delete the existing `\Sentinel` and/or `\SentinelOne` folders, or ensure they are accessible (for example, delete the problematic task), then run the installer again. |
| 2000 | Install or Upgrade | Failed | Installation failed - unexpected error | General failure. Logs and diagnostic data will help you understand this issue, and will be sent automatically to the SentinelOne Cloud. | Collect logs and contact support to troubleshoot. |
| 2001 | Upgrade | Failed | Installation failed | Upgrade failed. Cannot proceed with the uninstall and re-install. | Collect logs and contact support to troubleshoot. |
| 2002 | Install or Upgrade | Failed | Installation failed | Installation failed or upgrade failed. The previous Agent was uninstalled but the installation of the new Agent failed. | Collect logs and contact support to troubleshoot. |
| 2003 | Upgrade | Failed | Installation failed | Failed to uninstall the old Agent. | Collect logs and contact support to troubleshoot. |
| 2004 | Upgrade, or use the `-c` parameter | Failed | Installation failed | Retry in Safe Mode. | If you ran the tool without a passphrase (`-k`) , rerun the tool with the passphrase. If you get this error code again, [reboot the endpoint into Windows Safe Mode](https://support.microsoft.com/en-us/help/12376/windows-10-start-your-pc-in-safe-mode) and try again. |
| 2005 | Upgrade | Failed | Installation failed | Upgrade authentication error. Failed to get upgrade approval from the Management. | Make sure the upgrade was approved and the endpoint has an internet connection to the Management. |
| 2006 | Upgrade | Failed | Installation failed | Configuration not found. Unable to proceed with the upgrade. | Collect logs and contact support to troubleshoot. |
| 2007 | Upgrade | Failed | Installation failed - unexpected error | The upgrade failed. The installer faced an unexpected error. Cannot proceed with the uninstall and re-install. | Reboot the endpoint. If that does not help, contact Support. |
| 2008 | Install or Upgrade | Failed | Installation failed | Missing site token. | Try again with the site token. From the command line, add the parameter `-t *<site_token>*`. |
| 2009 | Upgrade | Failed | Installation failed | Failed to retrieve the Agent UID. | Upgrade the Agent again with the parameter `--dont_preserve_agent_uid` or contact Support.
**Note:** If you are uninstalling and reinstalling the same Agent version, you might need to reboot the endpoint before you attempt to reinstall the Agent. |
| 2010 | Upgrade | Not relevant | Upgrade failed | Interactive desktop required. | Run the upgrade in Quiet mode. Upgrade the Agent again with the parameter `-q` or `--qn`.
These parameters are available for Agent versions 22.2+. |
| 2011 | Install or Upgrade | Failed | Installation failed | The installer is not signed correctly. | Download a new installer and verify the certificates are up to date. See [How To Solve an Invalid Signature Error](https://usea1-pax8-03.sentinelone.net/docs/en/how-to-solve-an-invalid-signature-error.html). |
| 2012 | Upgrade | Failed | Installation failed | Could not determine the currently installed Agent version. | Upgrade the Agent again with the parameter `--force` or contact Support. |
| 2013 | Install or Upgrade | Failed | Installation failed | Insufficient system resources. |  |
| 2014 | Install or Upgrade | Failed | Installation failed | Extract resources general failure. | Collect logs and contact support to troubleshoot. |
| 2015 | Install or Upgrade | Failed | Installation failed | System requirements not met. | Read the requirement shown in the message. |
| 2016 | Install or Upgrade | Failed | Installation failed | Microsoft KB2533623 is not installed. | Windows 7 with KB2533623 or a newer OS is required. Upgrade and restart your Windows and try again. |
| 2017 | Install or Upgrade | Failed | Installation failed | Failed to load DLLs safely. | Collect logs and contact support to troubleshoot. |
| 2018 | Downgrade | Failed | Installation failed | Downgrade failed. | Collect logs and contact support to troubleshoot. |
| 2019 | Upgrade | Failed | Installation failed | Upgrade authentication error. Failed to get upgrade approval from the Management. | Make sure the upgrade was approved and the endpoint has an internet connection to the Management. |
| 2020 | Install or Upgrade | Failed | Installation failed | Not enough space on the system drive. | Free space on the disk and try again. |
| 2021 | Upgrade | Failed | Installation failed | Upgrade authentication error. Failed to get upgrade approval from the Management. | Make sure the upgrade was approved and the endpoint has an internet connection to the Management. |
| 2022 | Install | Failed | Installation failed | Unable to create an App Container. | Collect logs and contact support to troubleshoot. |
| 2023 | Upgrade | Failed | Installation failed | Not enough space on the system drive. | Free space on the disk and try again. |
| 2024 | Upgrade | Failed | Upgrade failed | Cannot open signed message file. | Contact Support. |
| 2025 | Upgrade | Failed | Upgrade failed | Offline signed message authentication error. | Contact Support. |
| 2026 | Upgrade | Failed | Installation failed | ISAPI filter removal process failed. | If the upgrade fails, collect logs and contact support to troubleshoot. |
| 2027 | Install or Upgrade | Completed | Upgrade failed | The Agent was installed and is in Disabled mode. |  |
| 2028 | Upgrade | Completed | Upgrade failed | The Agent was upgraded and the new Agent is in Disabled mode. |  |
| 2029 | Install or Upgrade |  |  | Failed to create a working directory under `%WINDIR%\Temp`. | Verify that the path exists and that you have sufficient privileges. |
| 2030 | Install or Upgrade |  |  | The installer failed to open one of the files under its own working directory. | Verify that third-party tools are disabled. |
| 2031 | Upgrade | Failed | Upgrade aborted | Windows Task Scheduler folders `\Sentinel` and/or `\SentinelOne` are inaccessible and could not be removed automatically. For example, if a Task Scheduler task exists at this path. | Delete the existing `\Sentinel` and/or `\SentinelOne` folders, or ensure they are accessible (for example, delete the problematic task), then run the installer again. |
| 2032 | Install or Upgrade |  |  | The SentinelOne Installer log could not be opened. |  |
| 999950 | Upgrade | Scheduled |  | The Update Timing is set to According to Maintenance Window or custom time range, and the Agent will update in the next available window. | Optional:
 Make sure the maintenance windows are set correctly in Upgrade Policy. 
To run the upgrade immediately, cancel the scheduled upgrade. Then 
select **Actions > Update Agent**, and in Update Timing, select Immediately. |
| 9999300 | Upgrade | In Progress |  | Waiting for the endpoint to be online. | Wait for the whole upgrade process to complete. |
| 9999301 | Upgrade | In Progress |  | In Queue. Waiting for resources to be available. For example, Maximum concurrent downloads setting is reached, so Agents must wait. | Wait for the whole upgrade process to complete. |
| 9999302 | Upgrade |  |  | No maintenance window or custom time range is configured. | Set one or more maintenance windows, or a custom time range, in Upgrade Policy. Update Timing is set to According to Maintenance Window or a custom time range, and the Agent will update in the next available window. |
| 9999400 | Upgrade | In Progress |  | Command sent. Only for Agents before 4.1 that do not support the new status reporting. |  |
| 9999401 | Upgrade | In Progress |  | Download started. Wait for the whole upgrade process to complete. |  |
| 9999402 | Upgrade | In Progress |  | Download finished. Wait for the whole upgrade process to complete. |  |
| 9999403 | Upgrade | In Progress |  | Installation of new version started. Wait for the whole upgrade process to complete. |  |
| 9999500 | Upgrade | Canceled |  | The task was canceled. |  |
| 9999501 | Upgrade | Canceled |  | The task was canceled. |  |
| 9999502 | Upgrade | Canceled |  | The task was canceled. |  |
| 99992500 | Install or Upgrade | Failed |  | Download failed. The download process could not complete. | Check your network connection and try again. |
| 99992501 | Install or Upgrade | Failed |  | Installation failed. Invalid package type. | Use a different package type to upgrade this Agent, for example MSI and not EXE.
OR
Configure a network share to grab certificate updates in firewalled and offline scenarios (see Microsoft instructions). See [How To Solve an Invalid Signature Error](https://usea1-pax8-03.sentinelone.net/docs/en/how-to-solve-an-invalid-signature-error.html). |
| 99992502 | Install or Upgrade | Failed |  | Installation failed. Corrupt package. | Download the package from the Management Console again. |
| 99992503 | Install or Upgrade | Failed |  | Installation failed. Invalid signature. | Download the package from the Management Console again. |
| 99992504 | Install or Upgrade | Failed |  | Installation failed. File not found. | Make sure that the file exists in the path you specified for the upgrade file. |
| 99992505 | Install or Upgrade | Failed |  | Installation failed. Unexpected error. |  |
| 99992506 | Install or Upgrade | Failed |  | Unknown status. |  |
| 9999600 | Upgrade | Expired |  | If the Agent
 version change task is in progress for 30 minutes with no update 
received from the endpoint, the task is marked as Expired to make the 
resources available. | Make
 sure the endpoint can communicate with the Management. When the 
endpoint sends an update, the task will change automatically from 
Expired to the current state. |
| 9999601 | Upgrade | Expired |  | The endpoint is decommissioned. |  |

Was this helpful?