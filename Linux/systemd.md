# Systemd

## Create custom service file
Let’s create a file called `/etc/systemd/system/rot13.service`: 

> The service file must live in `/etc/systemd/system/` I prefer to create mine in the directory of the application then link it to this directory. 

```
[Unit]
Description=ROT13 demo service
After=network.target
StartLimitIntervalSec=0[Service]
Type=simple
Restart=always
RestartSec=1
User=centos
ExecStart=/usr/bin/env php /path/to/server.php

[Install]
WantedBy=multi-user.target
```

You’ll need to:

- set your actual username after User=
- set the proper path to your script in ExecStart=

That’s it. We can now start the service:

`$ systemctl start rot13`

And automatically get it to start on boot:

`$ systemctl enable rot13`

### Going further

Now that your service (hopefully) works, it may be important to dive a bit deeper into the configuration options, and ensure that it will always work as you expect it to.
Starting in the right order

You may have wondered what the `After=` directive did. It simply means that your service must be started after the network is ready. If your program expects the MySQL server to be up and running, you should add:

`After=mysqld.service`

#### Restarting on exit

By default, systemd does not restart your service if the program exits for whatever reason. This is usually not what you want for a service that must be always available, so we’re instructing it to always restart on exit:

`Restart=always`

You could also use on-failure to only restart if the exit status is not 0.

By default, systemd attempts a restart after 100ms. You can specify the number of seconds to wait before attempting a restart, using:

`RestartSec=1`

#### Avoiding the trap: the start limit

I personally fell into this one more than once. By default, when you configure Restart=always as we did, systemd gives up restarting your service if it fails to start more than 5 times within a 10 seconds interval. Forever.

There are two `[Unit]` configuration options responsible for this:

```
StartLimitBurst=5
StartLimitIntervalSec=10
```

The `RestartSec` directive also has an impact on the outcome: if you set it to restart after 3 seconds, then you can never reach 5 failed retries within 10 seconds.

The simple fix that always works is to set `StartLimitIntervalSec=0`. This way, systemd will attempt to restart your service forever.

It’s a good idea to set `RestartSec` to at least 1 second though, to avoid putting too much stress on your server when things start going wrong.

As an alternative, you can leave the default settings, and ask systemd to restart your server if the start limit is reached, using `StartLimitAction=reboot`.

---
[back](./README.md)

