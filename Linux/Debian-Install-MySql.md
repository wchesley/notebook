# Install MySQL on Debian 12

> Always visit the [MySQL APT repository page](https://dev.mysql.com/downloads/repo/apt/) to verify and download the latest script version.

1. Get the apt deb package: 

```bash
wget https://dev.mysql.com/get/mysql-apt-config_0.8.35-1_all.deb
```

2. Install `lsb-release` and `gnupg` as dependencies. These are in the native apt repositories. 
3. Install the deb package and follow the install prompts: 

```bash
sudo dpkg -i ./mysql-apt-config_0.8.35-1_all.deb 
```
- For the installation prompts: 
   -   Keep MySQL Server & Cluster selected and press Enter to save changes.
   -   Select your desired MySQL server version. For example, `mysql-8.0` and press Enter to apply the version repository information.
   -   Press Down on your keyboard, select **OK** and press Enter to apply the MySQL repository information on your server.

4. Update apt `sudo apt update -y`
5. Install `mysql-server` via apt `sudo apt install mysql-server -y`
- For the installation prompts: 
   -   Enter a new `root` database user password when prompted and press Enter.
        ` Enter root password:`
   -   Enter the password again and press Enter to apply changes. 
    `Re-enter root password:`

6. Confirm mysql installation by viewing version number: 

```bash
mysql --version
```