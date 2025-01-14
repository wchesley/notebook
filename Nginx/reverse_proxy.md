[back](./README.md)

# Nginx Reverse Proxy
- [http_proxy_module](./http_proxy_module_copy.md)

## General
Unless stated otherwise, all HTTP requests are forced to HTTPS like so: 
```nginx
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        server_name _;
        return 301 https://$host$request_uri;
}
```

## Proxmox behing Nginx Reverse Proxy
- [PVE Docs](https://pve.proxmox.com/wiki/Web_Interface_Via_Nginx_Proxy)
- [PVE Forum post/tutorial](https://forum.proxmox.com/threads/using-nginx-as-reverse-proxy-externally.116127/)

My current setup looks like the following: 
```nginx
server {
    listen 443 ssl http2;
    server_name pve.chesley.cc; 
    # With SSL via Let's Encrypt
    ssl_certificate           /etc/letsencrypt/live/chesley.cc/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chesley.cc/privkey.pem; 
#    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols  TLSv1.3;
    ssl_ciphers "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
    ssl_prefer_server_ciphers off;

    access_log            /var/log/nginx/pve.access.log;
    error_log             /var/log/nginx/pve.error.log;
    proxy_redirect off;
    location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_buffering off;
        client_max_body_size 0;
        proxy_connect_timeout  3600s;
        proxy_read_timeout  3600s;
        proxy_send_timeout  3600s;
        send_timeout  3600s;
        proxy_pass "https://192.168.0.112:8006";
    }

}
```
## Nextcloud behind Nginx Reverse Proxy

Nextcloud `config.php` (excerp):
```php
'trusted_domains' => 
  array (
    0 => 'nc.example.com',
  ),
  'trusted_proxies' => 
  array (
    0 => '10.10.10.1',
  ),
  'overwrite.cli.url' => 'https://nc.example.com',
  'overwriteprotocol' => 'https',
  'forwarded_for_headers' => ['HTTP_X_FORWARDED', 'HTTP_FORWARDED_FOR'],
  ```
My Nextcloud Nginx config (local):
```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
 
    server_name chesleyfamily.com www.chesleyfamily.com;
    ssl_certificate           /etc/letsencrypt/live/chesleyfamily.com/fullchain.pem;
    ssl_certificate_key       /etc/letsencrypt/live/chesleyfamily.com/privkey.pem;

    ssl on;
    ssl_session_cache  builtin:1000  shared:SSL:10m;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    client_max_body_size 5G;

    access_log            /var/log/nginx/nextcloud.access.log;
    error_log             /var/log/nginx/nextcloud.error.log;
    location / {
        # app2 reverse proxy settings follow
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_ssl_server_name on;
        proxy_pass "https://192.168.0.118";
    }
    location /.well-known/carddav {
        return 301 $scheme://$host/remote.php/dav;
}
    location /.well-known/caldav {
        return 301 $scheme://$host/remote.php/dav;
}
    resolver 192.168.0.21;
}
```

Nextcloud Nginx config (cloud):
```nginx
server {
    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    server_name chesleyfamily.com www.chesleyfamily.com;
    add_header Strict-Transport-Security "max-age=63072000" always;
    client_max_body_size 100M;    
    location / {
        proxy_pass https://38.50.229.135;
        proxy_ssl_trusted_certificate /etc/nginx/ssl/selfsignedNextcloud.crt;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    location /.well-known/carddav {
        return 301 $scheme://$host/remote.php/dav;
}
    location /.well-known/caldav {
        return 301 $scheme://$host/remote.php/dav;
}
    
        ssl_certificate /etc/letsencrypt/live/chesleyfamily.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/chesleyfamily.com/privkey.pem; # managed by Certbot
include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
```

## Plex Behind Nginx Reverse Proxy
- [adapted from here](https://www.plexopedia.com/plex-media-server/general/plex-nginx-reverse-proxy/)

```nginx
    server {
        listen 80;
        server_name plex.mydomain.com;

        return 301 https://$http_host$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name plex.mydomain.com;

        # path to fullchain.pem on local machine
        ssl_certificate [path to fullchain.pem]/fullchain.pem;

        # path to privkey.pem
        ssl_certificate_key [path to privkey.pem]/privkey.pem;

        set $plex https://127.0.0.1:32400;

        gzip on;
        gzip_vary on;
        gzip_min_length 1000;
        gzip_proxied any;
        gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
        gzip_disable "MSIE [1-6]\.";

        # Forward real ip and host to Plex
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        #When using ngx_http_realip_module change $proxy_add_x_forwarded_for to '$http_x_forwarded_for,$realip_remote_addr'
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
        proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
        proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

        # Websockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";

        # Buffering off send to the client as soon as the data is received from Plex.
        proxy_redirect off;
        proxy_buffering off;

        location / {
            proxy_pass $plex;
        }               
    }
```

## Collabora Nginx Reverse Proxy 
- [Collabora Docs](https://sdk.collaboraonline.com/docs/installation/Proxy_settings.html)
- [Collabora with Nextcloud (linuxbabe)](https://www.linuxbabe.com/cloud-storage/integrate-collabora-online-server-nextcloud-ubuntu)
<h2>Reverse proxy with Nginx webserver<a class="headerlink" href="#reverse-proxy-with-nginx-webserver" title="Permalink to this headline"></a></h2>
<section id="reverse-proxy-settings-in-nginx-config-ssl">
<h3>Reverse proxy settings in Nginx config (SSL)<a class="headerlink" href="#reverse-proxy-settings-in-nginx-config-ssl" title="Permalink to this headline"></a></h3>
<p>Add a new <code class="docutils literal notranslate"><span class="pre">server</span></code> block to your Nginx config for <code class="docutils literal notranslate"><span class="pre">collaboraonline.example.com</span></code>.</p>
<p>In <code class="docutils literal notranslate"><span class="pre">coolwsd.xml</span></code> the corresponding setting is <code class="docutils literal notranslate"><span class="pre">ssl.enable=true</span></code>.</p>
<div class="highlight-nginx notranslate"><div class="highlight"><pre><span></span><span class="linenos"> 1</span><span class="k">server</span><span class="w"> </span><span class="p">{</span>
<span class="linenos"> 2</span><span class="w"> </span><span class="kn">listen</span><span class="w">       </span><span class="mi">443</span><span class="w"> </span><span class="s">ssl</span><span class="p">;</span>
<span class="linenos"> 3</span><span class="w"> </span><span class="kn">server_name</span><span class="w">  </span><span class="s">collaboraonline.example.com</span><span class="p">;</span>
<span class="linenos"> 4</span>
<span class="linenos"> 5</span>
<span class="linenos"> 6</span><span class="w"> </span><span class="kn">ssl_certificate</span><span class="w"> </span><span class="s">/path/to/certificate</span><span class="p">;</span>
<span class="linenos"> 7</span><span class="w"> </span><span class="kn">ssl_certificate_key</span><span class="w"> </span><span class="s">/path/to/key</span><span class="p">;</span>
<span class="linenos"> 8</span>
<span class="linenos"> 9</span>
<span class="linenos">10</span><span class="w"> </span><span class="c1"># static files</span>
<span class="linenos">11</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/browser</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">12</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">https://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">13</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">14</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">15</span>
<span class="linenos">16</span>
<span class="linenos">17</span><span class="w"> </span><span class="c1"># WOPI discovery URL</span>
<span class="linenos">18</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/hosting/discovery</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">19</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">https://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">20</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">21</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">22</span>
<span class="linenos">23</span>
<span class="linenos">24</span><span class="w"> </span><span class="c1"># Capabilities</span>
<span class="linenos">25</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/hosting/capabilities</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">26</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">https://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">27</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">28</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">29</span>
<span class="linenos">30</span>
<span class="linenos">31</span><span class="w"> </span><span class="c1"># main websocket</span>
<span class="linenos">32</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="p">~</span><span class="w"> </span><span class="sr">^/cool/(.*)/ws$</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">33</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">https://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">34</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Upgrade</span><span class="w"> </span><span class="nv">$http_upgrade</span><span class="p">;</span>
<span class="linenos">35</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Connection</span><span class="w"> </span><span class="s">"Upgrade"</span><span class="p">;</span>
<span class="linenos">36</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">37</span><span class="w">   </span><span class="kn">proxy_read_timeout</span><span class="w"> </span><span class="s">36000s</span><span class="p">;</span>
<span class="linenos">38</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">39</span>
<span class="linenos">40</span>
<span class="linenos">41</span><span class="w"> </span><span class="c1"># download, presentation and image upload</span>
<span class="linenos">42</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="p">~</span><span class="w"> </span><span class="sr">^/(c|l)ool</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">43</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">https://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">44</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">45</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">46</span>
<span class="linenos">47</span>
<span class="linenos">48</span><span class="w"> </span><span class="c1"># Admin Console websocket</span>
<span class="linenos">49</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/cool/adminws</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">50</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">https://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">51</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Upgrade</span><span class="w"> </span><span class="nv">$http_upgrade</span><span class="p">;</span>
<span class="linenos">52</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Connection</span><span class="w"> </span><span class="s">"Upgrade"</span><span class="p">;</span>
<span class="linenos">53</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">54</span><span class="w">   </span><span class="kn">proxy_read_timeout</span><span class="w"> </span><span class="s">36000s</span><span class="p">;</span>
<span class="linenos">55</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">56</span><span class="p">}</span>
</pre></div>
</div>
</section>
<section id="reverse-proxy-settings-in-nginx-config-ssl-termination">
<h3>Reverse proxy settings in Nginx config (SSL termination)<a class="headerlink" href="#reverse-proxy-settings-in-nginx-config-ssl-termination" title="Permalink to this headline"></a></h3>
<p>Add a new <code class="docutils literal notranslate"><span class="pre">server</span></code> block to your Nginx config for <code class="docutils literal notranslate"><span class="pre">collaboraonline.example.com</span></code>. Basically the configuration is the same as above, but in this case we have HTTP-only connection between the proxy and the Collabora Online server.</p>
<p>In <code class="docutils literal notranslate"><span class="pre">coolwsd.xml</span></code> the corresponding setting is <code class="docutils literal notranslate"><span class="pre">ssl.enable=false</span></code> and <code class="docutils literal notranslate"><span class="pre">ssl.termination=true</span></code>.</p>
<div class="highlight-nginx notranslate"><div class="highlight"><pre><span></span><span class="linenos"> 1</span><span class="k">server</span><span class="w"> </span><span class="p">{</span>
<span class="linenos"> 2</span><span class="w"> </span><span class="kn">listen</span><span class="w">       </span><span class="mi">443</span><span class="w"> </span><span class="s">ssl</span><span class="p">;</span>
<span class="linenos"> 3</span><span class="w"> </span><span class="kn">server_name</span><span class="w">  </span><span class="s">collaboraonline.example.com</span><span class="p">;</span>
<span class="linenos"> 4</span>
<span class="linenos"> 5</span>
<span class="linenos"> 6</span><span class="w"> </span><span class="kn">ssl_certificate</span><span class="w"> </span><span class="s">/path/to/certificate</span><span class="p">;</span>
<span class="linenos"> 7</span><span class="w"> </span><span class="kn">ssl_certificate_key</span><span class="w"> </span><span class="s">/path/to/key</span><span class="p">;</span>
<span class="linenos"> 8</span>
<span class="linenos"> 9</span>
<span class="linenos">10</span><span class="w"> </span><span class="c1"># static files</span>
<span class="linenos">11</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/browser</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">12</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">http://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">13</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">14</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">15</span>
<span class="linenos">16</span>
<span class="linenos">17</span><span class="w"> </span><span class="c1"># WOPI discovery URL</span>
<span class="linenos">18</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/hosting/discovery</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">19</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">http://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">20</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">21</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">22</span>
<span class="linenos">23</span>
<span class="linenos">24</span><span class="w"> </span><span class="c1"># Capabilities</span>
<span class="linenos">25</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/hosting/capabilities</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">26</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">http://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">27</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">28</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">29</span>
<span class="linenos">30</span>
<span class="linenos">31</span><span class="w"> </span><span class="c1"># main websocket</span>
<span class="linenos">32</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="p">~</span><span class="w"> </span><span class="sr">^/cool/(.*)/ws$</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">33</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">http://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">34</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Upgrade</span><span class="w"> </span><span class="nv">$http_upgrade</span><span class="p">;</span>
<span class="linenos">35</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Connection</span><span class="w"> </span><span class="s">"Upgrade"</span><span class="p">;</span>
<span class="linenos">36</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">37</span><span class="w">   </span><span class="kn">proxy_read_timeout</span><span class="w"> </span><span class="s">36000s</span><span class="p">;</span>
<span class="linenos">38</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">39</span>
<span class="linenos">40</span>
<span class="linenos">41</span><span class="w"> </span><span class="c1"># download, presentation and image upload</span>
<span class="linenos">42</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="p">~</span><span class="w"> </span><span class="sr">^/(c|l)ool</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">43</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">http://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">44</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">45</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">46</span>
<span class="linenos">47</span>
<span class="linenos">48</span><span class="w"> </span><span class="c1"># Admin Console websocket</span>
<span class="linenos">49</span><span class="w"> </span><span class="kn">location</span><span class="w"> </span><span class="s">^~</span><span class="w"> </span><span class="s">/cool/adminws</span><span class="w"> </span><span class="p">{</span>
<span class="linenos">50</span><span class="w">   </span><span class="kn">proxy_pass</span><span class="w"> </span><span class="s">http://127.0.0.1:9980</span><span class="p">;</span>
<span class="linenos">51</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Upgrade</span><span class="w"> </span><span class="nv">$http_upgrade</span><span class="p">;</span>
<span class="linenos">52</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Connection</span><span class="w"> </span><span class="s">"Upgrade"</span><span class="p">;</span>
<span class="linenos">53</span><span class="w">   </span><span class="kn">proxy_set_header</span><span class="w"> </span><span class="s">Host</span><span class="w"> </span><span class="nv">$http_host</span><span class="p">;</span>
<span class="linenos">54</span><span class="w">   </span><span class="kn">proxy_read_timeout</span><span class="w"> </span><span class="s">36000s</span><span class="p">;</span>
<span class="linenos">55</span><span class="w"> </span><span class="p">}</span>
<span class="linenos">56</span><span class="p">}</span>
</pre></div>
</div>
</section>


