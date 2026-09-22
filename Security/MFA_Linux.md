<sub>[back](./README.md)</sub>

# MFA for Linux
<sub>Pulled from RedHat's Blog [source](https://www.redhat.com/en/blog/mfa-linux)</sub>

With the rising number of breaches and password compromises, we need as many security layers as possible. One way to achieve added security is by adding an extra layer of authentication. _Multi-factor authentication_ (MFA) is a method of requiring more than one credential to prove your identity.

## What is MFA?

Usually, when you sign in to an account or device, you are asked for a username and password. When you SSH into a Linux machine, you may be asked for an [SSH key pair](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s2-ssh-configuration-keypairs?intcmp=701f20000012ngPAAQ). Multi-factor authentication requires users to provide more than one piece of information to authenticate successfully to an account or Linux host. The additional information may be a one-time password (OTP) sent to your cell phone via SMS or credentials from an app like [Google Authenticator](https://support.google.com/accounts/answer/1066447?co=GENIE.Platform%3DAndroid&hl=en), Twilio Authy, or FreeOTP.

[Pluggable Authentication Modules](https://www.redhat.com/sysadmin/pluggable-authentication-modules-pam) (PAM) are the authentication mechanism used in Linux. In this article, we use the Google PAM module to enable MFA so users can log in by using [time-based one-time password](https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm) (TOTP) codes.

## Implement the Google Authentication module

First, install the Google Authentication module on a Linux machine. To do so, open a Terminal window and run the following command:

```plaintext
$ sudo dnf install google-authenticator -y
```

Next, configure `google-authenticator` to generate OTP codes. Run the following command to begin the configuration process:

```plaintext
$ sudo google-authenticator
```

This tool asks a series of questions. For most of these questions, answer yes (**y**), unless you need something other than the default.

```plaintext
Do you want authentication tokens to be time-based (y/n) y
```

[![Google Authenticator QR code](https://www.redhat.com/rhdc/managed-files/sysadmin/2020-07/Picture1_0.png)](https://www.redhat.com/rhdc/managed-files/sysadmin/2020-07/Picture1_0.png)

This generates a QR code on the screen, a secret key, and recovery codes. Using an authenticator app like Google Authenticator on a smartphone, scan the QR code generated from the above command. Answer the rest of the questions to complete the process.

```plaintext
Do you want me to update your "/home/user/.google_authenticator" file? (y/n) y

Do you want to disallow multiple uses of the same authentication token? This restricts you to one login about every 30s, but it increases your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, a new token is generated every 30 seconds by the mobile app. In order to compensate for possible time-skew between the client and the server, we allow an extra token before and after the current time.[...] Do you want to do so? (y/n) y

If the computer that you are logging into isn't hardened against brute-force login attempts, you can enable rate-limiting for the authentication module. By default, this limits attackers to no more than three login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```

## Configure SSH to prompt for the OTP code

Edit a couple of SSH configuration files to ask for an OTP code as a second-factor authentication.

Using your favorite text editor, open `/etc/pam.d/sshd` for editing:

```plaintext
$ sudo vi /etc/pam.d/sshd
```

Add the following lines of configuration:

```plaintext
auth required pam_google_authenticator.so nullok
```

This line of configuration enables PAM to use the Google Authenticator PAM module, which we installed in the previous step.

With the `nullok` entry on the line, SSH will not require an OTP code for users on the machine that are not configured for MFA. Completely remove this option to force every user to use MFA on this system.

Next, comment out the following line to disable password authentication for logins:

```plaintext
#auth substack password-auth
```

Save and close the file.

In the next step, modify the SSH configuration to display the prompt for the OTP code after the successful SSH key pair authentication.

Using your favorite text editor open `/etc/ssh/sshd_config` for editing:

```plaintext
$ sudo vi /etc/ssh/sshd_config
```

Find and comment out the line **ChallengeResponseAuthentication no** and add a new configuration line **ChallengeResponseAuthentication yes**. This line lets SSH ask for a **Challenge Response**. In our case, the response is an OTP code after a successful SSH key-based authentication. Here is the line:

```plaintext
#ChallengeResponseAuthentication no

ChallengeResponseAuthentication yes
```

Finally, let SSH know to ask for _both_ an SSH key and a verification code to authenticate us. SSH checks for an SSH key pair (**publickey**) and then the OTP code (**keyboard-interactive**). At the bottom of the file, add:

```plaintext
AuthenticationMethods publickey,keyboard-interactive
```

To enable SSH key pair and OTP authentication for only a specific user, add something like this instead:

```plaintext
Match user <username>

           AuthenticationMethods publickey,keyboard-interactive
```

Save the file and exit. Restart the SSH service to let the changes take effect:

```plaintext
$ sudo systemctl restart sshd
```

## Test the configuration

Let's test out our set up. Open a Terminal window, and SSH into the Linux host. You are asked for an OTP code from the authenticator app.

To be asked for a password alongside an SSH key pair and OTP code, then open the `/etc/pam.d/ssd` file for editing and uncomment this line:

```plaintext
auth substack password-auth
```

Next, open `/etc/ssh/sshd_config` file for editing and add one more authentication method:

```plaintext
AuthenticationMethods publickey,password publickay,keyboard-interactive
```

Restart SSH after making these changes.

## Wrap up

With MFA, we add another authentication layer, making our systems more secure. In addition to traditional username and password-based authentication, we use more secure methods like an SSH key pair and TOTP (Google Authenticator) to log into the system. By implementing these measures, we improve system security and make Linux devices harder to break into.