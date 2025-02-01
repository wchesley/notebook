# Docker-compose
[docker-compose documentation](https://docs.docker.com/compose/)

### Deploying with Docker-compose
Typical you will deploy production apps with `docker-compose up -d`

If having issues you can chose to keep console output from docker by removing the `-d` flag. 

You can increase the verbosity of dockers output by adding `-V`  as an arguement. 


### Chosing where a volume is stored on disk
##### See [this Stackoverflow post](https://stackoverflow.com/questions/34513938/replicate-docker-volume-create-name-data-command-on-docker-compose-yml/35675553#35675553)
#### 1. Use the Local driver
First of all you must be using a version 2 Compose file (or above) to use the new specifications for creating and using named volumes. The [Compose File Reference](https://docs.docker.com/compose/compose-file/#version-2) includes all you need to know, including examples.

To summarize:

 - Add version: '2' to the top of docker-compose.yml.
- Place service units under a services: key.
- Place volume units under a volumes: key.
- When referring to a named volume from a service unit, specify volumename:/path where volumename is the name given under the volumes: key (in the example below it is dbdata) and /path is the location inside the container of the mounted volume (e.g., /var/lib/mysql).

Here's a minimal example that creates a named volume dbdata and references it from the db service.

```yml
version: '2'
services:
  db:
    image: mysql
    volumes:
      - dbdata:/var/lib/mysql
volumes:
  dbdata:
    driver: local
```
#### 2. Name the volume
###### See [this stackoverflow post](https://stackoverflow.com/questions/36387032/how-to-set-a-path-on-host-for-a-named-volume-in-docker-compose-yml)

With the `local` volume driver comes the ability to use arbitrary mounts; by using a bind mount you can achieve exactly this.

For setting up a named volume that gets mounted into /srv/db-data, your docker-compose.yml would look like this:

```yml
version: '2'
services:
  db:
    image: mysql
    volumes:
      - dbdata:/var/lib/mysql
volumes:
  dbdata:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/srv/db-data'
```

I have not tested it with the version 2 of the compose file format, but https://docs.docker.com/compose/compose-file/compose-versioning/#version-2 does not indicate, that it should not work.

I've also not tested it on Windows...


## Updating docker compose containers

Manually, you can log into the docker host, navigate to the directory with your `compose.yml` file and run: 

```bash
docker compose down && docker compose pull && docker compose up -d && docker image prune -af
```

This command series will stop the current compose container(s), pull updated image(s) foreach image needing an update. Once new images are pulled, restart the compose container(s) and detach the console from them (`-d` flag). Lastly, clean up any unused docker images. The last step is optional but should be run semi-regularly else unused images will consume space on your drive. 