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

