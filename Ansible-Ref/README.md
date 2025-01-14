[back](../README.md)

# Ansible 
Ansible is an agentless automation tool that you install on a single host (referred to as the control node).

From the control node, Ansible can manage an entire fleet of machines
 and other devices (referred to as managed nodes) remotely with SSH, 
Powershell remoting, and numerous other transports, all from a simple 
command-line interface with no databases or daemons required. 

[Docs are here](https://docs.ansible.com/)

## Table of Contents: 
1. [Ansible Target Setup](./Ansible-Target-Setup)
2. [Ansible Git](./Git)
3. [Deploy Telegraf](./Telegraf-Deployment)
4. [Ubuntu Installation](./Ubuntu-Debian-Installation)

## [Installing and upgrading Ansible with pipx](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id11)
On some systems, it may not be possible to install Ansible with `pip`, due to decisions made by the operating system developers. In such cases, `pipx` is a widely available alternative.

These instructions will not go over the steps to install `pipx`; if those instructions are needed, please continue to the [pipx installation instructions](https://pypa.github.io/pipx/installation/) for more information.

### [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id12)

Use `pipx` in your environment to install the full Ansible package:

```
pipx install --include-deps ansible

```

You can install the minimal `ansible-core` package:

```
pipx install ansible-core

```

Alternately, you can install a specific version of `ansible-core`:

```
pipx install ansible-core==2.12.3

```

### [Upgrading Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id13)
To upgrade an existing Ansible installation to the latest released version:

```
pipx upgrade --include-injected ansible

```

### [Installing Extra Python Dependencies](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id14)

To install additional python dependencies that may be needed, with the example of installing the `argcomplete` python package as described below:

```
pipx inject ansible argcomplete

```

Include the `--include-apps`
 option to make apps in the additional python dependency available on 
your PATH. This allows you to execute commands for those apps from the 
shell.

```
pipx inject --include-apps ansible argcomplete

```

## [Installing and upgrading Ansible with pip](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#id15)

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