[back](./README.md)

# Wazuh Agents

## Upgrade Agents


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

There is no built in way to do so, but from [this github issue](https://github.com/wazuh/wazuh/issues/3710), below is a bash based workaround to update all outdated agents in one command: 

```bash
/var/ossec/bin/agent_upgrade -l | awk '$1 ~ /^[0-9]+$/ {print "Starting upgrade on agent " $1; system("/var/ossec/bin/agent_upgrade -a " $1)}'
```

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

