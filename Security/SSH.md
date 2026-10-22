<sub>[back](./README.md)</sub>

# SSH Security

Notes on SSH and hardening it. 

## Disable algorithms (Server)

The below information was pulled from [ServerFault](https://serverfault.com/questions/758673/how-to-disable-diffie-hellman-group1-sha1-for-ssh)

In OpenSSH 7.6 if you want to remove one or more options and leave the remaining defaults you can add the following line to `/etc/ssh/sshd_config`:

```
KexAlgorithms -diffie-hellman-group1-sha1,ecdh-sha2-nistp256
```

Note the `-` at the start of the comma separated list. The above line would disable diffie-hellman-group1-sha1 and ecdh-sha2-nistp256.

This is detailed further in man `sshd_config` under `KexAlgorithms`:

```
If the specified value begins with a ‘-’ character, then the specified methods (including
wildcards) will be removed from the default set instead of replacing them.
```

One final note, after making any changes to `/etc/ssh/sshd_config` always verify them using `sshd -t` before restarting sshd.

As an alternative to editing the `/etc/ssh/sshd_config` directly, you can create a separate `.conf` file under the `/etc/ssh/sshd_config.d` directory. The name of the file is arbitrary but should reflect the changes you are making, ie `sshd_disabled_algorithms.conf`. This way you can keep those changes separated from the main `sshd_config` file and have only the disabled/enabled algorithms listed here, ie `KexAlgorithms -diffie-hellman-group1-sha1`