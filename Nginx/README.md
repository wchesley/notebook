# Nginx
Nginx is a web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache. The software was created by Igor Sysoev and publicly released in 2004. Nginx is free and open-source software, released under the terms of the 2-clause BSD license.
- [open source docs](https://nginx.org/en/docs/)
- [Ansible playbook to install nginx](https://code.chesleyfamily.com/wchesley/ansible-playbooks)

## Reverse proxy
For my lab, Nginx is primarily a [reverse proxy](https://nginx.org/en/docs/http/ngx_http_proxy_module.html), though it's slowly becoming my default webserver as I've been working with it more than apache here recently. An example of one of my locally hosted sites reverse proxy config is as follows: 
```nginx
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
 
    server_name $NAME.chesley.cc;

    ssl_certificate           /etc/letsencrypt/live/chesley.cc/fullchain.pem;
    ssl_certificate_key       /etc/letsencrypt/live/chesley.cc/privkey.pem;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
    ssl on; 

    # GitLab needs backwards compatible ciphers to retain compatibility with Java IDEs
    ssl_ciphers "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 5m;

    access_log            /var/log/nginx/$NAME.access.log;
    error_log             /var/log/nginx/$NAME.error.log;
    location / {
        # app2 reverse proxy settings follow
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_ssl_server_name on;
        proxy_pass "http://server-ip:optionalPort";
    }
}
```

> SSL Specific configuration for just about any service can be generated from Mozilla: https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=modern&openssl=1.1.1k&ocsp=false&guideline=5.6

Some sites require a more specific configuration, [see the full reverse proxy page for more](./reverse_proxy.md)

## Webserver