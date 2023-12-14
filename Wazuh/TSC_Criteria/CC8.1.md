# Common Criteria 8.1

The TSC common criteria CC8.1 provides a comprehensive and well-recognized technique for evaluating the security of IT products and systems. CC 8.1 defines a set of security requirements and evaluation procedures for IT products, such as software, hardware, and systems, that are intended to be used in a security context. The objective of CC 8.1 is to provide a standardized, objective, and repeatable evaluation process for IT products and to facilitate the development of secure IT products and systems. It states that: “*The entity authorizes, designs, develops or acquires, configures, documents, tests, approves, and implements changes to infrastructure, data, software, and procedures to meet its objectives*”. The end goal of the common criteria 8.1 is to provide assurance to users of IT products that the product has been independently evaluated and meets a high level of security.

## Use case: Monitoring packages installed on an Ubuntu endpoint

Wazuh helps meet the TSC common criteria CC8.1 requirement by providing several modules such as SCA, vulnerability detector, and active response. This use case shows how Wazuh can be used to view installed packages on an Ubuntu 22.04 endpoint.

To carry out this use case, set up a Wazuh server and an Ubuntu 22.04 endpoint with the Wazuh agent installed and connected to the Wazuh server.

1. Upgrade the Ubuntu endpoint to trigger the installation of packages:

`sudo apt upgrade`

2. Select Security events from your Wazuh dashboard.

3. Ensure the Ubuntu endpoint is selected.

4. Filter for rule ID 2902.

Wazuh contributes to the CC8.1 requirement by maintaining an accurate and up-to-date record of the software installed on each monitored agent. This information is vital for understanding the overall system configuration, tracking licenses, and ensuring compliance. Wazuh also integrates with vulnerability assessment tools and databases to identify known vulnerabilities associated with specific software packages. By cross-referencing the package inventory with vulnerability information, Wazuh highlights potential security weaknesses. This information allows organizations to prioritize patching or mitigating vulnerable packages, reducing the risk of exploitation.