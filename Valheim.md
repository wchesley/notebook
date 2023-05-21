# Valheim & Valheim Plus
LAN server IP: 10.0.0.55
Port: 2456
Public IP is dynamic, ByteBot can tell you the IP if you have permission within my discord server. 

Server files live within Steam user's home directory on server: /home/steam/Valheim

Steam lives in root directory at `~/.steam` 

>Before updating the server, make a backup of the world. Saves are located at `/home/root/.config/unity3d/IronGate/Valheim/worlds`, backup this directory to `/home/steam/Valheim_backup/`. 

Update the server with `steamcmd +login anonymous +force_install_dir /home/steam/Valheim +app_update 896660 +quit`

Bash script to update valheim plus: 
pseudo code: 
- check for and download new release of Valheim Plus on github. 
- If there's a new release, download it
- Copy current valheim Plus config located at: /home/steam/Valheim/BepInEx/config/valheim_plus.cfg
- extract new Valheim plus to valheim server dir
- update current_version.txt with new version number. 
- replace old valheim plus config (allegedly they won't overwrite the file? needs testing... )
- restart valheim server service


https://gist.github.com/gvenzl/1386755861fb42db492276d3864a378c
https://github.com/valheimPlus/ValheimPlus/releases
https://github.com/valheimPlus/ValheimPlus/issues/163
https://www.google.com/search?client=firefox-b-1-d&q=cp+overwrite+no+prompt 