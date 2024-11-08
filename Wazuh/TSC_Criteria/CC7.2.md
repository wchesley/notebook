### CC7.2 Requirements

> The entity monitors system components and the operation of those components for anomalies that are indicative of malicious acts, natural disasters, and errors affecting the entity’s ability to meet its objectives; anomalies are analyzed to determine whether they represent security events.

Moving on to CC7.2, we start getting into the classic subject of log monitoring, detection and response. This is another area where we see a bit of variation from client to client as risk is something that needs to be considered when determining how to address these requirements. Don’t forget that these measures will need to address both the application and infrastructure layer of your system.

-   **Implements Detection Policies, Procedures, and Tools** – Before you can start on your security log monitoring adventure, you should start by determining exactly what you need to log. This often takes some brainstorming amongst the various stakeholders to figure out the types of actions that could indicate a potential security issue that needs to be escalated for review. Once you’ve figured those out, you can go shopping for tools (whether they are ones you have, ones baked into your cloud provider or ones you shell out some cash for) that are able to assist you in implementing the log monitoring strategy.
-   **Design Detection Measures** – When you’re working on your security logging strategy, you should make sure that you’ve minimally considered the following elements of things that are important to you:
    -   Compromise of physical barriers
    -   Authorized people carrying out unauthorized actions
    -   Use of compromised identification and authentication credentials
    -   Unauthorized access that comes from outside your organization
    -   Compromise of external authorized parties
    -   Connection or implementation of unauthorized hardware or software
-   **Implements Filters to Analyze Anomalies** – As part of your security logging strategy and tooling, you’ll want to include requirements related to filtering and automated analysis, as quite frankly, that security engineer is not going to be reading billions of lines of logs every day. This can be met several ways – you could get a SIEM product setup that performs correlation and escalates based upon specific rules and risk or you could configure the tools you’re using to use thresholds and filters before alerting you (i.e. CloudWatch alarms).
-   **Monitors Detection Tools for Effective Operation** – Once you’ve got all of your logging gadgets set up, you should ensure there is a process to monitor the alerts that the system is generating. For example, if your logging strategy says that anytime event X occurs, a ticket should be opened and a resolution documented, you’ll want to make sure that is happening, being documented, and the tickets are being closed in a timely manner.

