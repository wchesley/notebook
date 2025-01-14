[back](./README.md)

# Local configuration (ossec.conf)

The `ossec.conf` file is the main configuration file on the Wazuh manager, and it also plays an important role on the agents. It is located at `/var/ossec/etc/ossec.conf` both in the manager and agent on Linux machines. On Windows agents, we can find it at `C:\Program Files (x86)\ossec-agent\ossec.conf`.
 It is recommended to back up this file before making changes to it. A 
configuration error may prevent Wazuh services from starting up.

The `ossec.conf`
 file is in XML format, and all of its configuration options are nested 
in their appropriate section of the file. In this file, the outermost 
XML tag is `<ossec_config>`. There can be more than one `<ossec_config>` tag.

Here is an example of the proper location of the *alerts* configuration section:

`<ossec_config>
    <alerts>
        <!--
        alerts options here
        -->
    </alerts>
</ossec_config>`

The `agent.conf` file is very similar to `ossec.conf` but `agent.conf` is used to centrally distribute configuration information to agents. See more [here](https://documentation.wazuh.com/current/user-manual/reference/centralized-configuration.html).

Wazuh can be installed in two ways: as a manager by using the 
"server/manager" installation type and as an agent by using the "agent" 
installation type.

| Configuration sections | Supported installations |
| --- | --- |
| [active-response](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/active-response.html) | manager, agent |
| [agentless](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/agentless.html) | manager |
| [agent-upgrade](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/agent-upgrade.html) | manager, agent |
| [alerts](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/alerts.html) | manager |
| [auth](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/auth.html) | manager |
| [client](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/client.html) | agent |
| [client-buffer](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/client-buffer.html) | agent |
| [cluster](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/cluster.html) | manager |
| [commands](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/commands.html) | manager |
| [database-output](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/database-output.html) | manager |
| [email-alerts](https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/email-alerts.html) | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/fluent-forward.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/global.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/github-module.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/integration.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/labels.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/localfile.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/logging.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/ms-graph-module.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/office365-module.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/remote.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/reports.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/rootcheck.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/rule-test.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/ruleset.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/sca.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/socket.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/syscheck.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/syslog-output.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/task-manager.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/vuln-detector.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wazuh-db-config.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-agent-key-polling.html | manager |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-s3.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-azure-logs.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-ciscat.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-command.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-docker.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-openscap.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-osquery.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/wodle-syscollector.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/gcp-pubsub.html | manager, agent |
| https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/gcp-bucket.html | manager, agent |

All of the above sections must be located within the top-level `<ossec_config>` tag. In the case of adding another `<ossec_config>` tag, it may override the values set on the previous tag.