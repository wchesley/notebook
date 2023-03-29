# Collabora Online With Nextcloud
 - Mostly followed [guide from linuxbabe](https://www.linuxbabe.com/cloud-storage/integrate-collabora-online-server-nextcloud-ubuntu)

I did not set mine up in Docker. Collabora runs in it's own VM behind Nginx. Collabora provides a guide on intallation here: https://www.collaboraoffice.com/code/linux-packages/. They also outline Nginx reverse proxy config here: https://sdk.collaboraonline.com/docs/installation/Proxy_settings.html#reverse-proxy-with-nginx-webserver

## Installing New fonts: 
- [Ref Nextcloud forums](https://help.nextcloud.com/t/installing-new-fonts-in-collabora/22758)
- [Ref Coudtron forums](https://forum.cloudron.io/topic/2834/adding-fonts-to-nextcloud-collabora)
- [loosely, very loosely ref collabora docs](https://sdk.collaboraonline.com/docs/installation/Fonts.html)

Essentially there are a few mehtods of doing this, one is from Nextcloud webUI, you can upload fonts there. Under Administration - Office - Fonts. This didn't work for me...but did put fonts on the collabora server, couldn't use them in documents though.  
Uploaded files to collabora server, unzip them if needed. You're looking for a `.tff` file(s). Copy these files into the following directories: 
- `/usr/share/fonts/truetype/` 
  - recommend to create a folder for the specific font you are adding
- `/opt/cool/systemplate/usr/share/fonts/truetype`
- `/opt/collabora/share/fonts`

Ensure that files are readable and under same onwership as rest of files in the same or similar directories. I rean into an issue after unzipping a file that had no permissions, gave it `755` and it became detected by collabora. 

Finally after fonts and permissions are set, restart collabora services, `systemctl restart coolwsd`