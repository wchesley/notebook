# Ubuntu Homepage
Landing page for my Ubuntu notes

18.04
20.04
21.04

upgrade without prompting reboot of services: `sudo NEEDRESTART_MODE=a apt-get dist-upgrade --yes` can also edit `/etc/needrestart/needrestart.conf` and change `#$nrconf{restart} = 'i';` (interacive mode) to `$nrconf{restart} = 'a';` (if we want to restart the services automatically)
- see [askubuntu](https://askubuntu.com/questions/1367139/apt-get-upgrade-auto-restart-services)