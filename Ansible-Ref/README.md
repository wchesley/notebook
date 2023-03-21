# Ansible 
Infrastructure as code, open source tool from redhat
docs [here](https://docs.ansible.com/)

## Table of Contents: 
1. [Ansible Target Setup](./Ansible-Target-Setup)
2. [Ansible Git](./Git)
3. [Deploy Telegraf](./Telegraf-Deployment)
4. [Ubuntu Installation](./Ubuntu-Debian-Installation)

## Passing extra variables to playbook
- [RHEL How to pass extra variables to an Ansible playbook](https://www.redhat.com/sysadmin/extra-variables-ansible-playbook)

The use of the `--extra-vars` parameter and modifying the Ansible playbook to take a variable (e.g., nodes) when declaring your hosts. The following example illustrates it:
```yml
- hosts: "{{ nodes }}"
  vars_files:
    - vars/main.yml
  roles:
    - { role: geerlingguy.apache }
```
To pass a value to nodes, use the `--extra-vars` or `-e` option while running the Ansible playbook, as seen below. 

`# ansible-playbook myplaybook.yaml --extra-vars "nodes=webgroup”`
## Or

`# ansible-playbook myplaybook.yaml --extra-vars "nodes=appgroup”`

This ensures you avoid accidental running of the playbook against hardcoded hosts. If the Ansible playbook fails to specify the hosts while running, Ansible will throw an error and stop, saying no value for nodes.