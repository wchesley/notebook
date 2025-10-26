[back](../README.md)
# GhostCMS

Typescript based headless CMS platform. 

## Change process type

Switch between running a 'local' process or using systemd to manage the process. 

```bash
ghost config --process local
ghost restart
ghost config --process systemd
ghost restart
```

Restart ghost in between each change. 