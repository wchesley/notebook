# Passwordless access

Created: June 25, 2021 2:40 PM

## Create Private and Public Key

On the Ansible control node, I will create an SSH using the following command.

```
ssh-keygen -t rsa -C "email@address.local"
```

Note down the locations of the files, and do not use a passphrase.

The output will look like this:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
```

Run the following two commands.

```bash
$ ssh-agent bash
$ ssh-add ~/.ssh/id_rsa
```

### I didn't get the new key working passwordlessly on my deployment of proxmox, instead I used the id_rsa.pub key generated on OS install.

## Copy SSH files

Next, I will copy the public SSH key to my host machine, which I would like to manage with Ansible.

```
ssh-copy-id -i ~/.ssh/id_rsa.pub ansible@192.168.0.x
```

## SSH to Host

I will connect to my host using SSH

```
ssh ansible@192.168.0.x
```

If I copied the file correctly, I would not be asked for a password.

## Edit Sudoers

From the host machine, I will open the following file.

```
visudo /etc/sudoers
```

At the bottom of the file, I will add the following line.

```
admin ALL=(ALL) NOPASSWD:ALL
```

The above was adapted and pulled from: 

[Use Passwordless SSH Keys with Ansible to Manage Machine - Learn IT And DevOps Daily](http://www.ntweekly.com/2020/06/14/use-passwordless-ssh-keys-with-ansible-to-manage-machine/)