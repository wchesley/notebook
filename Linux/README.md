# Linux

- [Ubuntu](./Ubuntu.md)
- [Fedora](./Fedora/Fedora.md)
- [Storage (generic)](./Storage/README.md)

# Notes

Scratch notes with no home...yet...

---

## Limit passwordless sudo access to certain application

Using `visudo` or similar command to edit the sudoers file in your preferred text editor: 


`%Username  ALL=(ALL:ALL) NOPASSWD: /path/to/command`

Where `%Username` is the user who is in the sudo group and needs passwordless access to a command. `NOPASSWD` grants passwordless sudo access. Any application listed after the colon `:` in `NOPASSWD:`, in a comma separated list, will be give passwordless sudo access. 

For a full example: 

`ansible    ALL=(ALL:ALL) NOPASSWD: /usr/bin/apt`

The above line grants the user `ansible` passwordless access to the `apt` command. 

### Further limit sudo access to certain commands

If desired, you can further limit sudo access to certain commands, and even keep passwordless access to the desired sudo(root) related command(s).
 For this reason some kind of sudo restriction is needed for an account which otherwise exists only to execute e.g. /sbin/poweroff. The following lines in /etc/sudoers worked for me:

```bash
# Allow guestx user to remote poweroff
guestx ALL=(ALL) !ALL
guestx ALL=NOPASSWD: /sbin/poweroff
```

Translation: disallow all commands, then allow only the desired command (without asking for password in this case).

With this configuration sudo asks for the password and then fails for commands other than the whitelisted one:
```bash
guestx@ds:~$ sudo su -
Password: 
Sorry, user guestx is not allowed to execute '/bin/su -' as root on ds.
guestx@ds:~$ 
```

###### [Reference Link (Superuser)](https://superuser.com/questions/767415/limit-user-to-execute-selective-commands-linux)
###### [2nd Reference Link (ostechnix)](https://ostechnix.com/restrict-sudo-users-run-specific-commands/)

---