[back](../README.md)

The experience operating system to grow your business better.  
A single yet complete experience operating system (XOS) to build your own experience. https://erxes.io/

## Links

- [Plugins](./plugins.md)

## Installation on Ubuntu
 > Erxes code takes approximately 12GB storage space, make sure you have enough space in your device before going forward.

This assumes a blank slate Ubuntu 22.04 Desktop OS. 

### Dependency Setup: 

Requires Docker, docker-compose, nodejs v16, npm

```bash
# Git, NodeJS and Docker Dependencies: 
apt install git ca-certificates curl gnupg -y  
# NodeJS: 
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs
# Docker: 
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### Confirm installation via
```bash
git --version
nodejs --version
npm --version
docker --version
docker-compose --version
```

### Installation of Erxes: 

Following from Erxes guide [here](https://docs.erxes.io/quickstart/groups/ubuntu).  

1. Create an empty folder.

`mkdir example`

2. In your empty folder, where the new erxes project will be created, and it defines the database and erxes plugins to use.

`cd example`

3. Run following command in the folder.

`git clone https://github.com/erxes/erxes.git`

### Installing dependencies using docker


4. In the folder, create dock directory using following command.

```
mkdir dock
```

5. Go to the dock folder using following command.


cd dock
> ✏️ Note:  
> Run sudo nano or sudo vim command to create .yml file.

6. Create a docker-compose.yml file, then copy the following script in the newly created file.

```docker-compose
version: '3.6'
services:
mongo:
hostname: mongo
image: mongo:4.0.10
# container_name: mongo
ports:
- "27017:27017"
networks:
- erxes-net
healthcheck:
test: test $$(echo "rs.initiate().ok || rs.status().ok" | mongo --quiet) -eq 1
interval: 2s
timeout: 2s
retries: 200
command: ["--replSet", "rs0", "--bind_ip_all"]
extra_hosts:
- "mongo:127.0.0.1"
volumes:
- ./data/db:/data/db

redis:
image: 'redis'
# container_name: redis
# command: redis-server --requirepass pass
ports:
- "6379:6379"
networks:
- erxes-net

rabbitmq:
image: rabbitmq:3.7.17-management
# container_name: rabbitmq
restart: unless-stopped
hostname: rabbitmq
ports:
- "15672:15672"
- "5672:5672"
networks:
- erxes-net
# RabbitMQ data will be saved into ./rabbitmq-data folder.
volumes:
- ./rabbitmq-data:/var/lib/rabbitmq

networks:
erxes-net:
driver: bridge
```
>  Tip:   
> Please find the useful [commands](https://docs.docker.com/engine/reference/commandline/compose_images/#related-commands) when you're working on Docker

7. Run the following command in the folder where above file exists.

`sudo docker-compose up -d`

   - Confirm containers are running via `docker ps`

8. Go back to erxes folder using following command.

```
cd ../erxes
```
9. Switch a dev branch by using following command.

```
git checkout dev
```

10. In erxes folder, Install node modules by using following command.

```
yarn install
```

11. Install pm2 by using following command.

```
sudo npm install -g pm2
```

### Running erxes
---

>✋ Caution
Run erxes in erxes/cli directory

1. Run following command to change the folder.

`cd cli`

2. Install node modules in the erxes/cli directory.

`yarn install`

3. Copy `configs.json.sample`, then convert it to `configs.json.`

`cp configs.json.sample configs.json`

4. Run following command to start your erxes project.

`./bin/erxes.js dev` 

## [If your browser don't automatically jump to localhost:3000, you should check logs by using these commands.](https://docs.erxes.io/quickstart/groups/ubuntu#if-your-browser-dont-automatically-jump-to-localhost-3000-you-should-check-logs-by-using-these-commands)

> 💡 Tip  
Frequently used `pm2` commands on erxes:
> 
> - `pm2 list` - Display all processes status
> - `pm2 kill` - Will remove all processes from pm2 list
> - `pm2 logs -f` - Display all processes logs in streaming (gateway, plugin-name etc.)
> - `pm2 restart all` - Restart all processes

## Issues: 

I keep hitting an error when going to run erxes for the first time. Essentially when running `/bin/erxes.js dev` I get the following error: 

```bash
/bin/sh: 1: cd: can't cd to /home/ubuntu/erxes/erxes/packages/dashboard
(node:44331) UnhandledPromiseRejectionWarning: Error: Command failed: cd /home/ubuntu/erxes/erxes/packages/dashboard && yarn install
/bin/sh: 1: cd: can't cd to /home/ubuntu/erxes/erxes/packages/**dashboard**
```

As a temp workaround you can remove `dashboard` from the `configs.json`. See [Issue #4834](https://github.com/erxes/erxes/issues/4834). While this gets the application to build, you cannot view the web interface...

To get the dashboard from the repo: See [Issue #4867](https://github.com/erxes/erxes/issues/4867)

- In a separate temp dir, clone erxes again then: 
- `git checkout dashboard-from-plugin`
- copied the packages/dashboard dir over to my examples/erxes/packages dir and it seemed to build ok.
- Had to run `/bin/erxes.js dev --deps --bash` before things started working properly. After that, I've been running `/bin/erxes.js dev` to start the site. `pm2 kill` to end it. `pm2 restart all` for restarts, `pm2 logs -f` to watch logs. 

1. Selfhosted Erxes.io -> Marketplace doesn't work. -- Basically anytime I go to load the marketplace it just spins forever and ever, nothing noteable is written out to `pm2` logs or browser dev logs. 
