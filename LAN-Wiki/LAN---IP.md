# LAN - IP

## Proxmox:

- 192.168.0.12 - Host

[Static IP's](LAN%20-%20IP%20b118b29724f94fc09b11d3c2d663e605/Static%20IP's%20bbf9cdbfc5d74b508328aa9979294329.csv)

### Services:

- PiHole
    - 192.168.0.21
    - WebUI: [http://pi.hole/admin](http://pi.hole/admin)

    [Overview](https://docs.pi-hole.net/)

- Grafana/InfluxDB
    - 192.168.0.100
    - Set to monitor on port 8086
        - All telegraf agents should send data here
        - Create a new influx database for each telegraf agent.
            - Get into influxDB Shell - `$ influx`
            - While in the shell: `$ create database my-new-database`
            - List all databases: `$ show databases`
    - Grafana on port 3000
        - [http://192.168.0.100:300](http://192.168.0.100:300)
        - Alerts are pushed to discord server via: Odin-discord-alerts, goes to server-shit channel. \
- Minecraft
    - 192.168.0.55
    - Set up per guide on minecrafts website
        - Working as of 10/15/2021 Both winston and I can join the server, minimal lag 
- Valheim/ByteBot
    - 192.168.0.50
    - Valheim built using: [https://gameplay.tips/guides/9765-valheim.html](https://gameplay.tips/guides/9765-valheim.html)
    - Valheim Plus: [https://www.nexusmods.com/valheim/mods/4](https://www.nexusmods.com/valheim/mods/4)
    - Config files are backed up to /home/steam/Valheim_backup
        - TODO: Back up world save
    - Container is backed up nightly(snapshot), full back up weekly
    - Valheim runs under valheim.service (service file in /home/steam/Valheim directory)
    - ByteBot runs under bytebot.service (service file in /home/steam/ByteBot)
- Nginx - Proxy
    - 192.168.0.20
    - Redirects all services to serviceName.chesley.net
    - reverse-proxy.conf must have an entry similar to this for and SSL site:

    ```
    server {

        listen 443;
        server_name jenkins.domain.com;

        ssl_certificate           /etc/nginx/cert.crt;
        ssl_certificate_key       /etc/nginx/cert.key;

        ssl on;
        ssl_session_cache  builtin:1000  shared:SSL:10m;
        ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
        ssl_prefer_server_ciphers on;

        access_log            /var/log/nginx/jenkins.access.log;

        location / {

          proxy_set_header        Host $host;
          proxy_set_header        X-Real-IP $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header        X-Forwarded-Proto $scheme;
          proxy_redirect      https://jenkins.domain.com;
        }
      }
    ```

    - Have to set a DNS record for this in pihole to access via domain name.
        - point [servicename.chesley.net](http://servicename.chesley.net) to nginx proxy IP
    - Test nginx config changes with: `service nginx configtest`
    - Apply changes with `service nginx reload`
    - Ref this link for how I set up Nginx reverse proxy w/SSL [https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-with-ssl-as-a-reverse-proxy-for-jenkins](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-with-ssl-as-a-reverse-proxy-for-jenkins)
- Plex
	- 192.168.0.119
	- web exposed on port :32400/web/index.html 
	- supposedly plex is added to apt repo? 
## ODIN

- 192.168.0.18
- Nextcloud
- Plex