# Server Migration

Column: https://support.plex.tv/articles/201370363-move-an-install-to-another-system/

My god what a cluster that doc is, you have to jump between several pages to get it all done... 

Install plex on new server. 

wget from latest version on [https://www.plex.tv/media-server-downloads/](https://www.plex.tv/media-server-downloads/)

then `sudo dpkg -i plexFileJustDownloaded` 

Stop auto empty trash after library scan on old server. 

Stop plex service on old server. `systemctl stop plexmediaserver` 

backup plex data `tar -czvf plexbackup.tar.gz /var/lib/plexmediaserver/Library/Application Support/Plex Media Server` 

copy this data to new plex server `scp plexbackup.tar.gz username@newplexhostip:/tmp` 

stop plex on new server `systemctl stop plexmediaserver` 

untar backup to new plex server `tar -xzvf projects.tar.gz -C /var/lib/plexmediaserver/Library/Application Support/Plex Media Server` 

give plex ownership of the new files `chown -R plex:plex /var/lib/plexmediaserver/Library/Application Support/Plex Media Server` 

start plex service on new server, `systemctl start plexmediaserver` 

Logout and back in if you were already logged into new server, then go into each library and point them to the new location on the new server.