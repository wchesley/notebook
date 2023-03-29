# Nextcloud
Currently running 22.0 w/MariaDB & Redis & APCu. Currently only MariaDB is on separate LXC container.

## Setup: 
- [Setup guide](./Setup-Guide-(what-I-followed-on-init-setup).md)
  - Needs updating I'm sure....
- [Collabora](./collabora-online.md)

## Troubleshooting: 
- [Debug via ADB](./Nextcloud%20Debug%20via%20ADB.md)

## Issues: 

- Log into Nextcloud on Hannah's phone using HER account. 

## Resolved: 
- MariaDB 10.6 complains about innodb_read_only_compression, need to turn it off so Nextcloud can work properly. Haven't yet found a way to do this from container, but in the container CLI I can log into mysql CLI and run `SET GLOBAL innodb_read_only_compressed=off;` and it starts working again. 
- Previously had an issue with android and it's autoupload of photos, issue was resolved by removing the use of TLSv1.2 in the ssl conf for apache2. 
- [Auto upload - Android](./Auto-Upload%20Android.md)