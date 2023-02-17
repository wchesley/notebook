# How to Deploy

## Table of Contents: 
- [LXC](##LXC)
- [VM](##VM)
- [Minecraft](##Minecraft)

## LXC
Clone Gold LXC Container
Change Hardware to fit desired app/service to be deployed on the LXC
Change the IP address assigned to the LXC .100+ is preferable 
Add the new LXC to the weekly [backup plan](obsidian://open?vault=obsidian_notes&file=Proxmox%20ab737cd368cf448a90eae5dc95040787%2FProxmox-Backup)
## Minecraft:

[Tutorials/Setting up a server](https://minecraft.gamepedia.com/Tutorials/Setting_up_a_server#Configuring_the_environment)

Ensure Java OpenJDK is installed. Verify with `java --version`

Currently Minecraft is set to run on startup, it has a service created for it, should it not start, or need to be restarted: `systemctl restart/start minecraft.service` 

Server.jar file is in the `/home` directory. Start it directly with: `java -jar minecraft_server.jar --nogui`