[back](../README.md)
# Docker
Docker: an open-source project that automates the deployment of software applications inside containers by providing an additional layer of abstraction and automation of OS-level virtualization on Linux.

- [Docker](#docker)
  - [Links](#links)
  - [List of running apps:](#list-of-running-apps)
  - [Docker Reference:](#docker-reference)
      - [Remove unused images:](#remove-unused-images)
      - [List Containers:](#list-containers)
  - [Move Docker to new drive/location](#move-docker-to-new-drivelocation)
    - [Issues](#issues)

## Links
- [Portainer](./Portainer.md)
- [Docker Compose](./Docker-Compose.md)


## List of running apps: 
1. ~~[Photoprism](https://github.com/photoprism/photoprism)~~
2. [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx)
   1. Webserver (Django?)
   2. Database (PostgreSQL)
   3. Redis
3. [Portainer](https://www.portainer.io/)
4. ~~[Maybe self host my price scraper?](https://aerokube.com/selenoid/latest/)~~
	1. pull it off of heroku, convert to docker container or LXC in proxmox. 
	2. Might have to do some updating for it to use the selenoid feature
5. [Gitlab Runner](https://docs.gitlab.com/runner/)
6. [MariaDB 10.5](https://hub.docker.com/_/mariadb)
   1. Nextcloud's Database


## Docker Reference: 
[Docker-CLI Docs](https://docs.docker.com/engine/reference/commandline/cli/)

#### Remove unused images: 
`docker image prune`
- append `-a` to remove all images not referenced by a container. `docker image prune -a` or `docker system prune`.

#### List Containers: 
`docker container ls`
Shows all running containers, append `-a` to show all containers `docker contianer ls -a`  
Can also list containers and their status with `docker ps`

## Move Docker to new drive/location
Docker stores all data in /var/lib/docker by default. I was running out of disk space on that drive and wanted to move docker to my raid 10 array, where I have 4tb of storage ready to go. I mostly followed [this](https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux) guide from linuxconfig.org.  

To begin, kill the docker processes:  
- `systemctl stop docker.service`
- `systemctl stop docker.socket`

Next, edit the docker service (systemd) file at `/lib/systemd/system/docker.service`

Edit the ExecStart command, by default it looks like this: 
- `ExecStart=/usr/bin/dockerd -H fd://` 

Edit the line by putting a `-g` and the new desired location of your Docker directory. When you’re done making this change, you can save and exit the file.  
- `ExecStart=/usr/bin/dockerd -g /new/path/docker -H fd://`    

If you haven’t already, create the new directory where you plan to move your Docker files to.
- `mkdir -p /new/path/docker`

Copy current dockerfiles over to new directory, rsync is great for this  
- `sudo rsync -aqxP /var/lib/docker/ /new/path/docker`  

Reload the system daemon and start docker
- `systemctl daemon-reload`
- `systemctl start docker`

To ensure all is well, run the `ps` command and check that dockers running in the new directory:  
- `ps aux | grep -i docker | grep -v grep` 

### Issues

I moved from ex4 to zfs file system, you have to update docker's storage driver to accomodate this. Edit or create `/etc/docker/daemon.json` (I had to create this file).  
Open the file and add the following:  
```json
{
  "storage-driver": "zfs"
}
```  
Save the file and resart docker (better yet do this while docker is off). `systemctl restart docker`  
Confirm changes with `docker info | grep "Storage Driver:"`

Despite all the images and container files being present in the new directory, docker didn't see them as valid. Starting my `docker-compose` based containers all pulled new images. Thankfully paperless-ngx saw it's old container and picked it right up.  
I canont recall how I set up nextcloud's db container, it must have been through a docker command, but even when I told docker the containters name or ID, it refused to start it, claimed it didn't exist. The db volume was some junk name, sorted through those then made a copy of the volume with a good name, NextCloud-DB.  
I created a new container of mariadb 10.5, mounted this old volume to it and it picked it right up. Just watch your casing, I had fun with that...  
To get a pre-existing volume into a new container, you have to specify it's external in the docker-compose file:  
```yaml
services:
  frontend:
    image: node:lts
    volumes:
      - myapp:/home/node/app
volumes:
  myapp:
    external: true
```

Further trouble was found when attempting a dump of the database for backup purposes.  
backup was ran as so:  
`sudo docker exec mariaDB-nextcloud sh -c 'exec mariadb-dump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > /Nextpool/Docker/Containers/nextcloud-all-databases.sql`  
Error: `mariadb-dump: Got error: 1728: "Cannot load from mysql.proc. The table is probably corrupted." When using LOCK TABLES`  
I thought it was because nextcloud was using the db, but I stopped it and had the same error, so I googled and and landed [here](https://serverfault.com/questions/361838/mysql-cannot-load-from-mysql-proc-the-table-is-probably-corrupted). My case was not as extreme as this, I just needed to run a repair on mysql.proc:  
`REPAIR TABLE mysql.proc;`