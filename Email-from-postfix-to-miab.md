# Email from postfix to Mail in a Box
largely pulled from [here](https://www.linode.com/docs/guides/postfix-smtp-debian7/)  
Originally found [here](https://discourse.mailinabox.email/t/how-to-send-email-from-miab-using-an-external-smtp-relay/4248/4)
Created: 11/1/2021
Author: Walker Chesley

## Install Postfix: 
Update apt first  
`sudo apt update && sudo apt upgrade -y`  
Add postfix: 
`sudo apt install libsasl2-modules postfix`  
When prompted from postfix installation, select `internet site`  
System mail name will be your Fully qualified domain name (FQDN) `mail.example.com`  

## Configure SMTP Username and Password
Usernames and passwords are stored in the `/etc/postfix/sasl_passwd` file. In this section, you add your external mail provider credentials to the `sasl_passwd` Postfix configuration file.

1. Create or open the `sasl_passwd` file at `/etc/postfix/sasl_paswd`
	1. Within the file, add the mail server URL:portnumber username:password as so:  `mail.example.com:465 username:password`
2. Create a Hash database file for Postfix using the `postmap` command. This command creates a new file named `sasl_passwd.db` in the `/etc/postfix/` directory.
	1. `sudo postmap /etc/postfix/sasl_passwd`  
3. Secure the password files: 
	1. `sudo chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db`
	2. `sudo chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db`  


## Postfix Configuration 
Lastly Postfix needs a few final tweaks to it's configuration to get things working. Open `/etc/postfix/main.cf` in your preferred text editor and add or edit the following: 
1. Change (typically): `relayhost = mail.example.com:465` Specify our relay host. 
2. Add to the end of `main.cf`: 
```bash
# enable SASL authentication
smtp_sasl_auth_enable = yes
# disallow methods that allow anonymous authentication.
smtp_sasl_security_options = noanonymous
# where to find sasl_passwd
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
# Enable STARTTLS encryption
smtp_use_tls = yes
# where to find CA certificates
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
```
3. Restart postfix for changes to take effect: `sudo service postfix restart`


## Testing Postfix Config: 
Can do one of two ways, I am most familiar with `mail` command, but postfix offers `sendmail` as well. 

### Mailutils
Install mailutils:  
`sudo apt install mailutils`  
Send mail with:  
``` bash
echo  “body of your email” | mail -s “This is a subject” - a “From: you@example.com” recipient@elsewhere.com
```

### Sendmail
Start command with sendmail destination@example.com and press enter, Enter the From: field, Subject: and body, each separated by enter. When finished with the body, hit enter and type `ctrl+d`
``` bash
sendmail recipient@elsewhere.com
From: you@example.com
Subject: Test mail
This is a test email
```

---
[back](./README.md)

