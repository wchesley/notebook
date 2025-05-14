# add user

Created: June 25, 2021 9:48 PM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: June 25, 2021 9:48 PM

Legacy link: [How to Create a Sudo User on Ubuntu 18.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-create-a-new-sudo-enabled-user-on-ubuntu-18-04-quickstart)

# Introduction

###### [ref](https://phoenixnap.com/kb/create-a-sudo-user-on-debian)

The [sudo command](https://phoenixnap.com/kb/linux-sudo-command) grants elevated privileges to a regular user, enabling them to temporarily execute programs with [root permissions](https://phoenixnap.com/glossary/what-is-root-access).

**In this guide, you will learn how to create a user with sudo privileges in Debian, add a user to the sudo group, edit the sudoers file, and verify the user's sudo access.**

### Prerequisites

-   A system running Debian (this tutorial uses Debian 12).
-   Access to an account with sudo or root privileges.
-   Access to the terminal.

## Steps to Create a Sudo User on Debian

Standard user accounts are restricted from executing sensitive operations. For instance, attempting to list the _/root_ [directory](https://phoenixnap.com/glossary/what-is-a-directory) contents using the [ls command](https://phoenixnap.com/kb/linux-ls-commands) without elevated privileges results in an error:

    ls /root

![ls root terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/ls-root-without-sudo-terminal-output.png)

![ls root terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/ls-root-without-sudo-terminal-output.png)

To use **`sudo`** and gain access to elevated privileges, take the steps below.

### Step 1: Switch to the Root User

To create and modify users, you need root or sudo access. To switch to the root user, run the [su command](https://phoenixnap.com/kb/su-command-linux-examples):

    su root

![su root terminal output on Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/su-root-terminal-output.png)

![su root terminal output on Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/su-root-terminal-output.png)

### Step 2: Create a New User on Debian (adduser)

As the root user, [create a new user](https://phoenixnap.com/kb/linux-user-create) with the [adduser](https://phoenixnap.com/kb/linux-adduser) command. Append the desired user account name to the command:

    adduser username

**Note:** If you already have an account you'd like to use, skip this step and go to Step 3.

For example, add _user1_ with the command:

    adduser user1

The output looks like this:

![Debian adduser user1 terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/adduser-user1-terminal-output.png)

![Debian adduser user1 terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/adduser-user1-terminal-output.png)

To complete the process, enter the password for the user account and retype to confirm it.

![adduser user1 password terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/adduser-user1-password-terminal-output.png)

![adduser user1 password terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/adduser-user1-password-terminal-output.png)

The terminal also prompts you to change the user information. Fill in the details or hit **Enter** to leave the fields blank.

![Debian user setup terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/user-setup-terminal-output.png)

![Debian user setup terminal output](https://phoenixnap.com/kb/wp-content/uploads/2024/04/user-setup-terminal-output.png)

### Step 3: Grant Sudo Privileges

Users with root privileges can grant sudo privileges to any account. There are two ways to do this: via the [usermod](https://phoenixnap.com/kb/usermod-linux) command or by editing the sudoers [file](https://phoenixnap.com/glossary/what-is-a-file). The following text elaborates on both options.

#### Add Debian User to Sudo Group Using usermod

All sudo group users have sudo privileges. To add a user to the sudo group via the **`usermod`** command, use the following:

    usermod -aG sudo username

The command consists of the following parts:

-   **`usermod`**. Modifies a user account.
-   **`-aG`**. Tells the command to add the user to a specific group. The **`-a`** option adds a user to the group without removing it from current groups. The **`-G`** option states the group in which to add the user. In this case, these two options **always** go together.
-   **`sudo`**. The group we append to the above options. In this case, it is _sudo_, but it can be any other group.
-   **`username`**. The name of the user account you want to add to the sudo group.

For example, add _user1_ to the sudo group with:

    usermod -aG sudo user1

The command has no output. However, to verify the new Debian sudo user was added to the group, run the command:

    getent group sudo

The output lists all users in the group.

![getent group sudo terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/getent-group-sudo-terminal-output.png)

![getent group sudo terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/getent-group-sudo-terminal-output.png)

#### Edit the Sudoers File

To grant sudo privileges by editing the sudoers file, take the following steps:

1\. Access the sudoers file with:

    sudo visudo

![sudo visudo terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/sudo-visudo-terminal-output.png)

![sudo visudo terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/sudo-visudo-terminal-output.png)

2\. Go to the section called _User privilege specification_.

3. Add a user and the appropriate permissions. For example, for _user1_:

    user1 ALL=(ALL:ALL) ALL

![editing sudoers file terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/editing-sudoers-file-terminal-output.png)

![editing sudoers file terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/editing-sudoers-file-terminal-output.png)

This means user1 is allowed to run any command on any [host](https://phoenixnap.com/glossary/what-is-a-host), as any user and any group.

4. Save and exit the file.

## Test Sudo Access

To make sure the new user has sudo privileges:

1\. Switch to the user account you want to test (in this case, _user1_):

    su - user1

![su user1 terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/su-user1-terminal-output-2.png)

![su user1 terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/su-user1-terminal-output-2.png)

2\. Run any command that requires **superuser access**. For example, execute:

    sudo whoami

![sudo whoami terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/sudo-whoami-terminal-output.png)

![sudo whoami terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/sudo-whoami-terminal-output.png)

The **`sudo`** [whoami](https://phoenixnap.com/kb/whoami-linux) command outputs root because a user with elevated privileges executes it.

## How to Use Sudo on Debian

To run a command with root access, type in **`sudo`** and enter the desired command.

For example, to view details for the [root directory](https://phoenixnap.com/glossary/root-directory), run the **`ls`** tool:

    sudo ls /root

![sudo ls /root terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/sudo-ls-root-terminal-output-1.png)

![sudo ls /root terminal output Debian](https://phoenixnap.com/kb/wp-content/uploads/2024/04/sudo-ls-root-terminal-output-1.png)

Enter the password, and the terminal shows the root directory contents.

---
[back](./README.md)

