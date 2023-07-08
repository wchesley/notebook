# How to Deploy

## Table of Contents: 
- [LXC](##LXC)
- [Minecraft](##Minecraft)

## LXC
Clone Gold LXC Container
Change Hardware to fit desired app/service to be deployed on the LXC. Minecraft currently has 4Gb RAM, 2 Cores, and 8gb disk. 
Change the IP address assigned to the LXC .100+ is preferable.  
Add IP to list of LAN ip's   
Create ansible service user (see [ansible target setup](../Ansible-Ref/Ansible-Target-Setup.md))    
Add the new LXC to the nightlly and weekly backups in proxmox. Game servers get special priviledge after all. 

## Minecraft:

[Tutorials/Setting up a server](https://minecraft.gamepedia.com/Tutorials/Setting_up_a_server#Configuring_the_environment)

Ensure Java OpenJDK is installed. Verify with `java --version`. If it's installed output will look like the following: 

```bash
openjdk 17.0.7 2023-04-18
OpenJDK Runtime Environment (build 17.0.7+7-Ubuntu-0ubuntu122.04.2)
OpenJDK 64-Bit Server VM (build 17.0.7+7-Ubuntu-0ubuntu122.04.2, mixed mode, sharing)
```

If Java is not installed, the current minimum requirement for Minecraft 1.20.x is openjdk 17. On Debian it's installed via: 

`sudo apt install openjdk-17-jre-headless`

Currently Minecraft is set to run on startup, it has a service created for it, should it not start, or need to be restarted: `systemctl restart/start minecraft.service` 

Server.jar file is in the `/root/minecraft` directory. Start it directly with: `java -jar minecraft_server.jar --nogui`. Starting this way will require you to keep the terminal open. I've opted for the service file to ensure the server is started on boot. All the service file does is run a bash script (`start_server.sh`) to start the minecraft server. 

### Minecraft service & bash file

`start_server.sh` -- Bash script starting minecraft server: 

```bash
#!/bin/sh
cd "$(dirname "$0")"
exec java -Xms1G -Xmx1G -jar server.jar --nogui
```

Systemctl service file: 

```service
[Unit]
Description=Minecraft service
Wants=network.target
After=syslog.target network-online.target

[Service]
Restart=on-failure
RestartSec=10
User=root
WorkingDirectory=/root/minecraft

ExecStart=/root/minecraft/start_server.sh

[Install]
WantedBy=multi-user.target
```

> If you've never created a systemd service file, see [How to create the systemd service file](../Linux/systemd.md). 