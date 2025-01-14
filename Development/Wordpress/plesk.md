[back](./README.md)

# Plesk

Plesk is designed to help IT specialists manage web, DNS, mail and other services through a comprehensive and user-friendly GUI. Plesk is a hosting control panel, an intermediary between system services and users. For example, when a user creates a website through the Plesk GUI, Plesk propagates this request to a web server, either Apache or IIS, and the latter adds a new virtual host to the system. This method of administering all system services from a single web interface reduces maintenance costs and gives administrators more flexibility and control.

- [Documentation](https://docs.plesk.com/en-US/obsidian/)
- [Update PHP Settings](https://docs.plesk.com/en-US/obsidian/administrator-guide/website-management/websites-and-domains/hosting-settings/web-scripting-settings/php-settings.70742/)


## Restarting Plesk

If you experience problems with Plesk, for example, malfunctioning of a service, you can try to resolve them by restarting Plesk or the administrative web server sw-cp-server. Also, a restart is necessary to apply configuration changes that cannot be made while Plesk is running.

To restart Plesk, run the following command:

`/etc/init.d/psa restart`

To restart sw-cp-server, run the following command:

`/etc/init.d/sw-cp-server restart`

