# Veeam Service Provider Console (VSPC)

Veeam Service Provider Console is a free product that gives
service providers centralized monitoring and management
capabilities for their customers' Veeam-protected workloads,
including Microsoft 365 and public cloud workloads.
- Maintain visibility into the health and security of customers’
Veeam-protected workloads.
- Consolidate business operations such as licensing, reporting,
and billing into one centralized platform.
- Accelerate productivity with key integrations and
powerful APIs.

## Links

- [Grafana](./VSPC-Grafana/README.md)

## Veeam Service Provider Console Management Agent for Microsoft Windows

> Valid for VSPC v8.1 [ref](https://helpcenter.veeam.com/docs/vac/deployment/silent_install_agent.html?ver=81)

To install preconfigured Veeam Service Provider Console management agent 
that is already assigned to client or service provider company, use a 
command with the following syntax:

```ps1
ManagementAgent.exe [/L*v "<path_to_log>"] /qn 
[ACCEPT_THIRDPARTY_LICENSES="1"][ACCEPT_EULA="1"][ACCEPT_REQUIRED_SOFTWARE="1"][ACCEPT_LICENSING_POLICY="1"][INSTALLDIR="<path_to_installdir>"][VAC_MANAGEMENT_AGENT_TAG_NAME="<tag_name>"][VAC_AGENT_ACCOUNT_TYPE="1/2"]
[VAC_CONNECTION_ACCOUNT="<machine\account>"][VAC_CONNECTION_ACCOUNT_PASSWORD="<agent_account_password>"]
```

---

The commands have the following parameters:

| Option | Parameter | Required | Description |
| --- | --- | --- | --- |
| /L | *v logfile | No | Creates an installation log file with the verbose output.
Specify
 an existing path to the log file as the parameter value. A setup log 
file created during the previous installation is cleared.
Example: */L*v ”C:\ProgramData\Veeam\Setup\Temp\Logs\VACAgentSetup.txt”* |
| /q | n | Yes | Sets the user interface level to “no”, which means no user interaction is needed during installation. |
| ACCEPT_THIRDPARTY_LICENSES | 0/1 | Yes | Specifies
 if you want to accept the terms of the license agreement for the 3rd 
party components. Specify 1 if you want to accept the terms and proceed 
with installation.
Example: *ACCEPT_THIRDPARTY_LICENSES="1"* |
| ACCEPT_EULA | 0/1 | Yes | Specifies if you want to accept the terms of the Veeam license agreement.
Specify 1 if you want to accept the terms and proceed with installation.
Example: *ACCEPT_EULA="1"* |
| ACCEPT_LICENSING_POLICY | 0/1 | Yes | Specifies if you want to accept the terms of the Veeam licensing policy.
Specify 1 if you want to accept the terms and proceed with installation.
Example: *ACCEPT_LICENSING_POLICY="1"* |
| ACCEPT_REQUIRED_SOFTWARE | 0/1 | Yes | Specifies if you want to accept the terms of the required software license agreements.
Specify 1 if you want to accept the terms and proceed with installation.
Example: *ACCEPT_REQUIRED_SOFTWARE="1"* |
| INSTALLDIR | path | No | Installs the component to the specified location. By default, Veeam Service Provider Console uses the CommunicationAgent subfolder of the C:\Program Files\Veeam\Availability Console folder.
Example: *INSTALLDIR="C:\Veeam\"*
The component will be installed to the *C:\Veeam\CommunicationAgent*. |
| VAC_AGENT_ACCOUNT_TYPE | 1/2 | No | Specifies the type of account under which management agent service will run.
Specify 2 if you want to run management agent under a custom account.
If you do not use this parameter, management agent service will run under local System account (default value, 1).
Example: *VAC_AGENT_ACCOUNT_TYPE="2"* |
| VAC_CONNECTION_ACCOUNT | account name | No | Specifies the name of an account under which management agent service will run.
You must use this parameter if you have specified 2 for the VAC_AGENT_ACCOUNT_TYPE parameter.
Example: VAC_CONNECTION_ACCOUNT="masteragent\backupadmin" |
| VAC_CONNECTION_ACCOUNT_PASSWORD | password | No | Specifies the password of an account under which management agent service will run.
You must use this parameter if you have specified 2 for the VAC_AGENT_ACCOUNT_TYPE parameter.
Example: VAC_CONNECTION_ACCOUNT_PASSWORD="P@ssw0rd" |
| VAC_MANAGEMENT_AGENT_TAG_NAME | name | No | Specifies the custom tag for the management agent.
Example: VAC_MANAGEMENT_AGENT_TAG_NAME="alfa_company" |

Example

Suppose
 you want to install preconfigured Veeam Service Provider Console 
management agent to the service provider infrastructure:

- Installation log location: C:\ProgramData\Veeam\Setup\Temp\Logs\VACAgentSetup.txt
- No user interaction
- Path to the setup file: C:\Veeam\VAC\ManagementAgent.MyCompany.exe
- Accept 3rd party license agreement
- Accept Veeam license agreement
- Accept Veeam licensing policy
- Accept required software agreements

The
 command to install Veeam Service Provider Console management agent with
 such configuration will have the following parameters:

```ps1
"C:\Veeam\VAC\ManagementAgent.MyCompany.x64.exe"
 /qn /l*v C:\ProgramData\Veeam\Setup\Temp\Logs\VACAgentSetup.txt 
ACCEPT_THIRDPARTY_LICENSES="1" ACCEPT_EULA="1" 
ACCEPT_REQUIRED_SOFTWARE="1" ACCEPT_LICENSING_POLICY="1"
```
---

Example 2

Suppose you want to install preconfigured Veeam Service Provider Console management agent to the client infrastructure:

- Installation log location: C:\ProgramData\Veeam\Setup\Temp\Logs\VACAgentSetup.txt
- No user interaction
- Path to the setup file: C:\Veeam\VAC\ManagementAgent.TenantCompany.exe
- Accept 3rd party license agreement
- Accept Veeam license agreement
- Accept Veeam licensing policy
- Accept required software agreements
- Communication ports: default

The
 command to install Veeam Service Provider Console management agent with
 such configuration will have the following parameters:

```ps1
"C:\Veeam\VAC\ManagementAgent.TenantCompany.exe"
 /qn /l*v C:\ProgramData\Veeam\Setup\Temp\Logs\VACAgentSetup.txt 
ACCEPT_THIRDPARTY_LICENSES="1" ACCEPT_EULA="1" 
ACCEPT_REQUIRED_SOFTWARE="1" ACCEPT_LICENSING_POLICY="1"
```