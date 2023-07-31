# Email Alerts

Created: April 12, 2021 10:57 PM

Not a direct application to proxmox, but I was able to adapt this to my needs: 

[How to Configure Postfix to Send Mail Using Gmail and Google Apps on Debian or Ubuntu](https://www.linode.com/docs/guides/configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/)

From the forum: 

**Guide**

1. Install the authentication library:

    `apt-get install libsasl2-modules`

2. If Gmail has 2FA enabled, go to [App Passwords](https://security.google.com/settings/security/apppasswords) and generate a new password just for Proxmox
3. Create a password file:

    `nano /etc/postfix/sasl/sasl_passwd`

4. Insert your login details:

    `[smtp.gmail.com]:587 youremail@gmail.com:yourpassword`

5. Save the password file
6. Create a database from the password file:

    `postmap hash:/etc/postfix/sasl_passwd`

7. Protect the text password file:

    `chmod 600 /etc/postfix/sasl_passwd`

8. Edit the postfix configuration file:

    `nano /etc/postfix/main.cf`

9. Add/change the following (certificates can be found in `/etc/ssl/certs/`):

```
relayhost = smtp.gmail.com:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt
```

10. Reload the updated configuration:

    `postfix reload`

**Testing**

`echo "test message" | mail -s "test subject" ama.w.chesley@gmail.com`