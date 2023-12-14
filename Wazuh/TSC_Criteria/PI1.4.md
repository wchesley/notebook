# Processing Integrity - PI 1.4

The trust service criteria for additional criteria for processing integrity PI1.4 is a set of guidelines that outline the requirements for ensuring the completeness and integrity of the processed data of an entity. It states: "The entity implements policies and procedures to make available or deliver output completely, accurately, and timely in accordance with specifications to meet the entity’s objectives.". The following actions are performed to achieve this:

- Protect output: Output is protected when stored or delivered, or both, to prevent theft, destruction, corruption, or deterioration that would prevent output from meeting specifications.

- Distribute output only to intended parties: Output is distributed or made available only to intended parties.

- Distribute output completely and accurately: Procedures are in place to provide for the completeness, accuracy, and timeliness of distributed output.

- Create and maintain records of system output activities: Records of system output activities are created and maintained completely and accurately in a timely manner.

## Use case: Detecting file changes using the Wazuh File Integrity Monitoring module

This use case shows how Wazuh helps meet the processing integrity PI1.4 requirement by monitoring and reporting file changes using the FIM module. In this scenario, we show how you can configure the Wazuh agent on a Ubuntu 22.04 endpoint to detect changes in the `critical_folder` directory.

### Ubuntu endpoint

1. Switch to the root user:

`sudo su`

2. Create the directory `critical_folder` in the `/root` directory:

`mkdir /root/critical_folder`

3. Create the file `special_data.txt` in the `/root/critical_folder` directory and add some content:
```bash
touch /root/critical_folder/special_data.txt
echo "The content in this file must maintain integrity" >> /root/critical_folder/special_data.txt
```

4. Add the following configuration to the existing `<syscheck>` block of the Wazuh agent configuration file `/var/ossec/etc/ossec.conf`:

```xml
<syscheck>
  <directories realtime="yes" check_all="yes" report_changes="yes">/root/critical_folder</directories>
</syscheck>
```

5. Restart the Wazuh agent to apply the changes:

`systemctl restart wazuh-agent`

6. Modify the file by changing the content of special_data.txt from The content in this file must maintain integrity to A change has occurred:

```bash
echo "A change has occurred" > /root/critical_folder/special_data.txt
cat /root/critical_folder/special_data.txt
```

> Output:  
> A change has occurred

7. Select TSC from the Wazuh dashboard to view the alert with rule ID `550`.  
The alert is tagged with `PI1.4` and other compliance tags with requirements that intersect with this use case.