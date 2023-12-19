# Install Mongo DB on Debian 12

Installing mongoDB on debian 12 requires libssl1.1, and in Debian 12 they’ve moved to libssl3. Attempting to install mongo on debian 12 will fail as a result. 

To resolve this, I downloaded libssl1.1 from https://packages.debian.org/bullseye/amd64/libssl1.1/download

Specifically: `curl “http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb” --output libssl1.1.deb`

Then installed that using `apt install ./libssl1.1.deb`

From there the process provided by MongoDB works as expected. 

Reference: 

- https://www.mongodb.com/docs/manual/tutorial/install-mongodb-on-debian/

- https://www.reddit.com/r/debian/comments/14hll0f/anyone_know_how_to_fix_this/

- https://forums.debian.net/viewtopic.php?t=155621