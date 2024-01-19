# Ansible Target Setup

Create ansible user:  
`useradd ansible -s /bin/bash` 

Add ansible user to sudo group:  
`usermod -aG sudo ansible`

Set a password for ansible user:  
`chpasswd ansible`

Create home directory for ansible user:   
`mkdir -p /home/ansible/.shh`

Change ownership of home directory to ansible:  
`chown -R ansible:ansible /home/ansible`

Add passwordless sudo access for ansible:  
`visudo`

- add to the end of the file: 
  - `ansible ALL=(ALL) NOPASSWD:ALL`
- Save and exit visudo

Copy over ssh key  
`ssh-copy-id ansible@123.123.123.123`

Sign in at least once with ansible account, to accept the host key if it's not already in your `known_hosts` list.
