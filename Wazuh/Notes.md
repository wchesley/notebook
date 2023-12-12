# Wazuh Notes

Work notes, there's a readme on my laptop that I've not yet commited. 

# Windows changes: 

Added sysmon and a config. Sysmon is from [microsoft](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) and the config is from [olafhartong/sysmon-modular](https://github.com/olafhartong/sysmon-modular). Wazuh also provides a config using the same repo to construct theirs: https://wazuh.com/resources/blog/detecting-process-injection-with-wazuh/sysmonconfig.xml

Setup email alerts via postfix from Wazuh Server CLI, tests using CLI work and make it to my email, however I'm not seeing any alerts from Wazuh, despite having that configured. 

## Rule Alerts (Windows)

<sub>taken from: https://www.reddit.com/r/Wazuh/comments/m7wi7h/windows_events_alerts_with_wazuh/</sub>

First of all, as you say, you need to have a wazuh agent installed, and that it be connected to a wazuh manager.

Once it is correctly configured and connected, then you have to check if the manager has by default rules for the use cases that you comment.

In this repository https://github.com/wazuh/wazuh-ruleset you can find the decoders and rules that wazuh-manager has by default (all these files are being migrated to the repository wazuh/wazuh https://github.com/wazuh/wazuh).

For example, imagine that I want to generate an alert when there has been a Remote access login failure, and the event 20189 has occurred.

Looking for that eventID, I find the following rule https://github.com/wazuh/wazuh-ruleset/blob/master/rules/0620-win-generic_rules.xml#L22

In this case, there would be a rule for my use case, and since it is a level 5 rule, by default it would generate an alert (the default threshold to generate an alert is level 3).

In case it doesn't exist then I would have to create a custom rule for my use case.

Here are some useful links that show how they can be created:

- Creating decoders and rules from scratch: https://wazuh.com/blog/creating-decoders-and-rules-from-scratch/

- Sibling decoders: flexible extraction of information: https://wazuh.com/blog/sibling-decoders-flexible-extraction-of-information/

- Custom rules and decoders: https://documentation.wazuh.com/4.0/user-manual/ruleset/custom.html

- Testing decoders and rules: https://documentation.wazuh.com/4.0/user-manual/ruleset/testing.html

Once you have your rule created and you have verified that it is generating the alert, it is now possible to configure it so that the alert is also sent by email. You can do it in several ways, but if you want to force the alert to always be sent by email, then the simplest thing would be to define the sending by email in the rule declaration itself https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/index.html#force-forwarding-an-alert-by-email.

Below I provide links that can be helpful for this configuration

- Configuring email alerts: https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/index.html

- How to Send Email Notifications: https://wazuh.com/blog/how-to-send-email-notifications-with-wazuh/

- Email alerts configuration: https://documentation.wazuh.com/current/user-manual/reference/ossec-conf/email_alerts.html

- SMTP server with authentication: https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/smtp_authentication.html

