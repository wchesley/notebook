# Email alerts through Gmail: 

> Note:  
> I noticed when sending via gmail & postfix that only the address specified in `ossec.conf` was getting email alerts, despite the Wazuh GUI stating otherwise.

## Create a Recipeient Group

- Login to Wazuh Web UI
- Expand navigation menu (three lines, top left of screen)
- Select Notifications
- Choose "Email Recipient Groups" in the left hand menu
- Create a new group, give it a name and description. 
- Add all email addresses you'd like to receive alerts to in the "emails" field. If yours is not present in the list, just type it out and press enter, Wazuh will create it for you. 
- Save when your done and remain in the Notifications page. 

## Create an Email Sender: 

- Still under notifications, select "Email Senders" from the left hand menu. It should be just above "Email recipient groups"
- Give your sender a name that represents the email account sending the email. 
- email addresses will contain the email address used to send the message. 
- Wazuh does not to SMTP authentication natively, we will have to use `postfix` for this instead. 
- Set the Host to `localhost`
- Set the port to `25`
- Set Encryption method to `TLS`

## Configure Postfix to send email on our behalf: 

- Wazuh has a guide on this here: https://documentation.wazuh.com/current/user-manual/manager/manual-email-report/smtp-authentication.html. Though the contents are also covered here. 
- Log into the Wazuh server via SSH with a root-enabled account. ie. you can use `sudo`. 
- Install postfix and dependencies: 
  - `apt-get update && apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules`
- Append the following lines to the end of `/etc/postfix/main.cf`
  - This file wasn't explicitly present when I last installed postfix, instead I had a `main.cf.proto` which is the example `main.cf` file. Rename this file to `main.cf` via `cp /etc/postfix/main.cf.proto /etc/postfix/main.cf`
  
```conf
relayhost = [smtp.gmail.com]:587
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
smtp_use_tls = yes
```
- Set the sender email address and password. Replace USERNAME and PASSWORD with your own data.

```bash
echo [smtp.gmail.com]:587 USERNAME@gmail.com:PASSWORD > /etc/postfix/sasl_passwd

postmap /etc/postfix/sasl_passwd

chmod 400 /etc/postfix/sasl_passwd
```

> Note: The password must be an **App Password**. App Passwords can only be used with accounts that have **2-Step Verification** turned on. 

- Secure the password DB file.

```bash
chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db

chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
```

- Restart the postfix service (this needs to happen anytime there are changes to `main.cf`)

```bash
systemctl restart postfix
```

- Run the following command to test the postfix configuration. Replace `you@example.com` with your email address. Check, then, that you receive this test email. 

```bash
echo "Test mail" | mail -s "Test Postfix" -r "nessus.westgatecomputers@gmail.com" wchesley@westgatecomputers.com
```

> See `main mail` for more info on `mail` and it's arguements 

> If you've received the test message from postfix you may proceed to the next step. If you've not received the email, check `/var/log/mail.log` to see what might have gone wrong. 

- Configure email notifications in the Wazuh server `/var/ossec/etc/ossec.conf` file as follows:

```xml
<global>
  <email_notification>yes</email_notification>
  <smtp_server>localhost</smtp_server>
  <email_from>USERNAME@gmail.com</email_from>
  <email_to>you@example.com</email_to>
</global>
```

- Finally, Restart the Wazuh manager to apply the changes.

```bash
systemctl restart wazuh-manager
```

## Create Notification Channel

Back in the Wazuh Web UI, under notifications again. This time chose the top most option, `channels`
- Click `Create Channel` in the top right. 
- Give your channel a name and accurate description
- Under configuration, change the channel type to `email` and leave `SMTP Sender` selected. 
- SMTP Sender will be the Email Sender you created earlier. 
- Default Recipients is the recipient group you created earlier. 
- Click 'Send Test Message' at the bottom right of the page to confirm email alerts are working properly. 
