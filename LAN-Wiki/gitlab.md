# Gitlab

[gitlab runner](<https://techoverflow.net/2021/01/12/how-to-install-gitlab-runner-using-docker-compose/>)

relevant material from gitlab runner link: \
How to install gitlab-runner using docker-compose

First, choose a directory where the service will reside in. I recommend `/opt/gitlab-runner`.  Then create `docker-compose.yml` in said directory with this content:

```
docker-compose.yml



version: '3'



services:



gitlab-runner:



image: 'gitlab/gitlab-runner:latest'



volumes:



 - /var/run/docker.sock:/var/run/docker.sock



 - ./config:/etc/gitlab-runner



restart: unless-stopped
```

then run this command to configure the runner:

install-gitlab-runner-using-docker-compose.sh

```
docker-compose up -d
```

```
docker-compose exec -T gitlab-runner gitlab-runner register
```

It will ask you for details about the GitLab instance you want to attach to. You will find this information at `https://<your-gitlab-domain>/admin/runners`. This example is for my GitLab instance:

install-gitlab-runner-using-docker-compose.txt 📋 Copy to clipboard⇓ Download

Runtime platform arch=amd64 os=linux pid=38 revision=943fc252 version=13.7.0

Running in system-mode.

Enter the GitLab instance URL (for example, <https://gitlab.com/):>

<https://gitlab.techoverflow.net/>

Enter the registration token:

Loo2lahf9Shoogheiyae

Enter a description for the runner:

[148a53203df8]: My-Runner

Enter tags for the runner (comma-separated):

Registering runner... succeeded runner=oc-oKWMH

Enter an executor: custom, docker-ssh, shell, virtualbox, docker-ssh+machine, docker, parallels, ssh, docker+machine, kubernetes:

shell

Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!

Now, restart the runner that is running with the old config (i.e. with no gitlab instance being attached):

install-gitlab-runner-using-docker-compose.txt 📋 Copy to clipboard⇓ Download

docker-compose down

After that’s finished, you can run the script from our previous post [Create a systemd service for your docker-compose project in 10 seconds](https://techoverflow.net/2020/10/24/create-a-systemd-service-for-your-docker-compose-project-in-10-seconds/) in the directory where `docker-compose.yml` is located.

---
[back](./README.md)

