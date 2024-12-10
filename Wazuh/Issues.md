# Wazuh Issues & Solutions

Issues I've encoutered with Wazuh and the potential solutions I've found, if any. 

## Password updated on update

One or more files that contains the passwords for Wazuh might get updated if one is not careful about what is being updated. Apt is fairly good about prompting for overwrites, but users can still make mistakes. 

- Download the wazuh passwords tool
  - `curl -so wazuh-passwords-tool.sh https://packages.wazuh.com/4.9/wazuh-passwords-tool.sh`
  - version will change with wazuh version, see: https://documentation.wazuh.com/current/user-manual/user-administration/password-management.html#changing-the-password-for-single-user for an updated link.
- Change password via: 
  - `bash wazuh-passwords-tool.sh -u admin -p Secr3tP4ssw*rd`
  - In my case, the script kept complaining about not being able to create the backup. I suspect it's the use of special characters in the password arg when it's at the end of the arguement list. I went to append `-v` for more verbose output and was able to successfully update the password then. 
- After updating the password, for an all in one install you need to restart all wazuh services. 
- Despite all of the above, which follows the documentation, I still had issues with the wazuh dashboard not loading in the web gui, occasionally the service would fail to start. 
  - For starters, in the `internal_users.yml` file, there was an extra password hash for the admin user that was wrapped in double quotes. First, copy the file elsewhere should shit hit the fan, ie `/home/user/internal_users.yml.bak` then edit the file, remove the hash before the quotes, and then remove both leading and trailing quotes for the passwords hash. restart services after saving the file. 
  - Then I had issues with JVM's heap size, it was complaining about the size being too large, I increased size from 1G to 2G in `/etc/wazuh-indexer/jvm.options`. Restart services after saving file.
    - Example log message: `FATAL  {"error":{"root_cause":[{"type":"circuit_breaking_exception","reason":"[parent] Data too large, data for [<http_request>] would be [1020483488/973.2mb], which is larger than the limit of [1020054732/972.7mb], real usage: [1020483488/973.2mb], new bytes reserved: [0/0b],`
- Only then was I able to get back into wazuh dashboard AND have data present. 