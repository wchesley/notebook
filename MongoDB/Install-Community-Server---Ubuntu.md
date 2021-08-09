# Install Community Server - Ubuntu

Created: April 13, 2021 9:40 AM

[Install MongoDB Community Edition on Ubuntu - MongoDB Manual](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)

## Errors During Install:

- No directory /data/db
    - Have to make one or point `/etc/mongod.conf` to a different directory, Ubuntu default is /`var/lib/mongodb`
- Cannot start Mongo: Exit Code 14
    - Permissions issue, need to adjust two things:
    - `chown -R mongodb:mongodb /var/lib/mongodb`
    - `chown mongodb:mongodb /tmp/mongodb-27017.sock`
    - Pulled from:

    [Mongodb exited with code 14 - The easiest way to fix the error](https://bobcares.com/blog/mongodb-exited-with-code-14/)