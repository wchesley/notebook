# Portainer
To upgrade to the latest version of Portainer Server, use the following commands to stop then remove the old version. Your other applications/containers will not be removed. Essentially delete the old version of Portainer and bring in a new one. [Portainer upgrade docker docs](https://docs.portainer.io/start/upgrade/docker)

`docker stop portainer`
`docker rm portainer`

Then pull down the newest image of Portainer: 

`docker pull portainer/portainer-ce:latest`

Start Portainer with the following: 

`docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest`
