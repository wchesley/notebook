[back](./README.md)

# Wazuh Agents

- [Wazuh Agents](#wazuh-agents)
  - [Upgrade Agents](#upgrade-agents)
    - [Manual](#manual)
      - [Upgrading Wazuh agents on Windows systems](#upgrading-wazuh-agents-on-windows-systems)
    - [Remote](#remote)
      - [Update all agents in one command:](#update-all-agents-in-one-command)
  - [Removing agents (manager)](#removing-agents-manager)
    - [Viewing disconnected agents](#viewing-disconnected-agents)
  - [Manage Agent from Agent](#manage-agent-from-agent)
    - [No WazuhSvc](#no-wazuhsvc)
    - [Silent Agent update](#silent-agent-update)


## Upgrade Agents

### Manual

#### Upgrading Wazuh agents on Windows systems

Follow these steps to upgrade Wazuh agents locally on Windows systems. If you want to perform a remote upgrade, check the [Remote agent upgrade](https://documentation.wazuh.com/current/user-manual/agent/agent-management/remote-upgrading/upgrading-agent.html) section to learn more.

> Note
> 
> To perform the agent upgrade, administrator privileges are required.

1.  Download the latest [Windows installer](https://packages.wazuh.com/4.x/windows/wazuh-agent-4.10.1-1.msi).
    
2.  Run the Windows installer by using the command line interface (CLI) or the graphical user interface (GUI).
    

To upgrade the Wazuh agent from the command line, run the installer using Windows PowerShell or the command prompt. The `/q` argument is used for unattended installations.

1.  > \# .\\wazuh-agent-4.10.1-1.msi /q
    
    Open the installer and follow the instructions to upgrade the Wazuh agent.
    
    > ![Windows agent setup Window](https://documentation.wazuh.com/current/_images/windows1.png)
    

> Note
>
> When upgrading agents from versions earlier than 4.x, make sure that the communication protocol is compatible. Up to that point, UDP was the default protocol and it was switched to TCP for later versions. Edit the agent configuration file `ossec.conf` to update the [protocol](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/client.html#server-protocol) or make sure that your Wazuh manager accepts [both protocols](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/remote.html#manager-protocol).

### Remote

[Remote Agent Upgrade Docs](https://documentation.wazuh.com/current/user-manual/agent/agent-management/remote-upgrading/upgrading-agent.html)

From the Wazuh Manager (your wazuh server if all in one deployment, cluster config not covered here)

You will need `root`/`sudo` access. 

1. `cd` into `/var/ossec/bin`
2. Run `./agent_upgrade -l`
   1. This will list all out dated agents
3. Upgrade by running: `agent_control -a 001`
   1. Where `001` is the `id` of the agent to upgrade
4. Confirm upgrade status with `agent_control -i 001`

#### Update all agents in one command: 

There is no built in way to do so, but from [this github issue](https://github.com/wazuh/wazuh/issues/3710), below is a bash based workaround to update all outdated agents in one command: 

```bash
/var/ossec/bin/agent_upgrade -l | awk '$1 ~ /^[0-9]+$/ {print "Starting upgrade on agent " $1; system("/var/ossec/bin/agent_upgrade -a " $1)}'
```

Alternatively, Wazuh has several ansible playbooks that cover wazuh deployments [on their github](https://github.com/wazuh/wazuh-ansible)

## Removing agents (manager)

From management server, `/var/ossec/bin` there is a script called `manage_agents`

```
Wazuh v4.9.2 - Wazuh Inc. (info@wazuh.com)
http://www.wazuh.com
  manage_agents -[Vhlj] [-a <ip> -n <name>] [-F sec] [-e id] [-r id] [-i id] [-f file]
    -V          Version and license message.
    -h          This help message.
    -j          Use JSON output.
    -l          List available agents.
    -L          Disable agents limit.
    -a <ip>     Add new agent.
    -n <name>   Name for new agent.
    -e <id>     Extracts key for an agent (Manager only).
    -r <id>     Remove an agent (Manager only).
    -i <key>    Import authentication key (Agent only).
    -R <sec>    Replace agents that were registered at least <sec> seconds.
    -D <sec>    Replace agents that were disconnected at least <sec> seconds.
    -f <file>   Bulk generate client keys from file (Manager only).
                <file> contains lines in IP,NAME format.
```

### Viewing disconnected agents

```
/var/ossec/bin/agent_control -ln

Wazuh agent_control. List of available agents:
   ID: 005, Name: Receiving, IP: any, Disconnected
   ID: 010, Name: AppleBench, IP: any, Disconnected
   ID: 012, Name: WGDCOhOne, IP: any, Disconnected

List of agentless devices:

root@wgc-wazuh:/var/ossec/bin# ./manage_agents -r 005



****************************************
* Wazuh v4.9.2 Agent manager.          *
* The following options are available: *
****************************************
   (A)dd an agent (A).
   (E)xtract key for an agent (E).
   (L)ist already added agents (L).
   (R)emove an agent (R).
   (Q)uit.
Choose your action: A,E,L,R or Q:
Available agents:
   <List of Agents here>
Provide the ID of the agent to be removed (or '\q' to quit): 005
Confirm deleting it?(y/n): y
Agent '005' removed.

manage_agents: Exiting.
```

Running the command this way does not prompt the user for confirmation. Double check the agent ID you are about to remove before running this command. 

## Manage Agent from Agent

Sometimes managing an agent requires a manual touch on the agent itself. 

### No WazuhSvc

If the Wazuh service isn't present on the machine but wazuh is installed. You can recreate the service from the `wazuh-agent.exe`. The file is located in `C:\Program Files (x86)\ossec-agent\` directory and should be invoked from admin powershell. CLI help output for the `wazuh-agent.exe` is as follows: 

```ps1
[ADMIN]:PS C:\Program Files (x86)\ossec-agent> .\wazuh-agent.exe /?

Wazuh wazuh-agent v4.10.1 .
Available options:
        /?                This help message.
        -h                This help message.
        help              This help message.
        install-service   Installs as a service
        uninstall-service Uninstalls as a service
        start             Manually starts (not from services)
```

### Silent Agent update

Begin by manually moving the update file to the machine. Then from admin powershell run: `C:\Path\to\Agent\wazuh_agent_v4.10.1.msi /q` for quiet update of agent. 