# Telegraf Deployment

Created: April 8, 2021 4:32 PM
Tags: Guide, URL

Pulled from: 

[Monitor Everything! Mass deployment of Cloud Insights agents using Ansible](https://cloud.netapp.com/blog/ci-blg-monitor-everything-mass-deployment-of-cloud-insights-agents-using-ansible)

## Installing and configuring Telegraf through Ansible

Before continuing, if you haven’t already, you should install Ansible from the [website](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Lets cover some basic Ansible terms:

**Inventory:** A group of hosts or systems in your infrastructure to apply Ansible commands against.**Playbooks:** YAML files that express configurations.**Role:** A set of configuration tasks (i.e. Install a product, mysql, telegraf, etc).**Ansible Galaxy:** A public hub that maintains and serves Ansible Roles.

To install the Telegraf agent, we will use the Ansible role “sbaerlocher.telegraf”. The role will handle the installation and running of the agent. To retrieve the role for use we use ansible galaxy:

```

```

```
ansible-galaxy install sbaerlocher.telegraf
```

Let’s create a simple playbook to to install Telegraf and replace 
some items in the configuration, using localhost as an example:

```

```

```
   - hosts: localhost

     roles:
       - { role: sbaerlocher.telegraf }
     tasks:
       - name: Copy telegraf conf file
         copy:
           src: telegraf.conf
           dest: /etc/telegraf/telegraf.conf

       - name: Update hostname in config file
         replace:
           path: /etc/telegraf/telegraf.conf
          regexp: '\$NODE_UUID'
           replace: ""

       - name: Update OS in config file
         replace:
           path: /etc/telegraf/telegraf.conf
           regexp: '\$NODE_OS'
           replace: ""

       - name: Update ip in config file
         replace:
           path: /etc/telegraf/telegraf.conf
           regexp: '\$HOSTIP'
           replace: ""
```

Let’s cover this playbook line by line:

Our inventory is shown by “hosts” which is set to localhost only for this exampleWe are enforcing the Telegraf role “sbaerlocher.telegraf”A task is used to copy the Telegraf configuration file to the default locationThen we have 3 tasks to replace variables that the installer script would have replaced with host specific valuesTo deploy it, we use the command:

```

```

```
   ansible-playbook playbook.yml
```