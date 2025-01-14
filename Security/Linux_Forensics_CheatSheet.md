[back](./README.md)

# Linux Forensics Command Cheat Sheet

<sub>
<a href="https://fahmifj.github.io/series/command-cheatsheet" target="_blank">Source</a>
</sub>

A small cheat sheet for forensics and incident response on Linux systems

- [Linux Forensics Command Cheat Sheet](#linux-forensics-command-cheat-sheet)
  - [Users-related](#users-related)
  - [Processes and Networking](#processes-and-networking)
  - [Files and Folders](#files-and-folders)
  - [Persistence areas](#persistence-areas)
  - [References](#references)


## Users-related
Last login

    $ lastlog
    $ last
    

Users with login shells

    $ cat /etc/passwd | grep sh$
    

List users’ cron

    $ for user in $(cat /etc/passwd | cut -f1 -d: ); do echo $user; crontab -u $user -l; done
    
    # users with shells only
    $ for user in $(cat /etc/passwd | grep sh$ | cut -f1 -d: ); do echo $user; crontab -u $user -l; done
    

SSH authorized keys

    $ find / -type f -name authorized_keys
    

## Processes and Networking

Show process tree with username, TTY, and wide output.

    $ ps auxfww
    

Process details

    $ lsof -p [pid]
    

Show all connections don’t resolve names (IP only)

    $ lsof -i -n
    $ netstat -anp
    
    # Look for tcp only
    $ netstat -antp
    $ ss -antp
    

List all services

    $ service --status-all
    

List firewall rules

    $ iptables --list-rules
    

List all timers

    $ systemctl list-timers --all
    

Look to these file to see if the DNS has been poisoned.

    /etc/hosts
    /etc/resolv.conf
    

## Files and Folders

Show list files and folder with nano timestamp, sort by modification time (newest).

    $ ls --full-time -lt 
    

List all files that were modified on a specific date/time.

    # List files which were modified on 2021-06-16 (YYYY-MM-DD)
    $ find / -newermt "2021-06-16" -ls 2>/dev/null
    
    # List files which were modified on 2021-05-01 until 2021-05-09 (9 days ago)
    $ find / -newermt "2021-05-01" ! -newermt "2021-05-10" -ls 2>/dev/null
    
    # List files which were modified on 2021-05-01 until 2021-05-09 (9 days ago) + add filter
    $ find / -newermt "2021-05-01" ! -newermt "2021-05-10" -ls 2>/dev/null | grep -v 'filterone\|filtertwo'
    
    # List files modified between 01:00 and 07:00 on June 16 2021.
    $ find / -newermt "2021-06-16 01:00:00" ! -newermt "2021-06-16 07:00:00" -ls 2>/dev/null
    
    # List files that were accessed exactly 2 days ago.
    $ find / -atime 2 -ls 2>/dev/null
    
    # List files that were modified in the last 2 days.
    $ find / -mtime -2 -ls 2>/dev/null
    

File inspection

    $ stat [file]
    $ exiftool [file]
    

Observe changes in files

    $ find . -type f -exec md5sum {} \; | awk '{print $1}' | sort | uniq -c | grep ' 1 ' | awk '{print $2	}'
    

Look for `cap_setuid+ep` in binary capabilities

    $ getcap -r /usr/bin/
    $ getcap -r /bin/
    $ getcap -r / 2>/dev/null
    

SUID

    $ find / -type f -perm -u=s 2>/dev/null
    

Log auditing

    # 3rd party
    $ aureport --tty
    

## Persistence areas

Directories:

    /etc/cron*/
    /etc/incron.d/*
    /etc/init.d/*
    /etc/rc*.d/*
    /etc/systemd/system/*
    /etc/update.d/*
    /var/spool/cron/*
    /var/spool/incron/*
    /var/run/motd.d/*
    

Files:

    /etc/passwd
    /etc/sudoers
    /home/<user>/.ssh/authorized_keys
    /home/<user>/.bashrc
    

## References

-   [https://stackoverflow.com/questions/18339307/find-files-in-created-between-a-date-range](https://stackoverflow.com/questions/18339307/find-files-in-created-between-a-date-range)
-   [https://unix.stackexchange.com/questions/119598/as-root-how-can-i-list-the-crontabs-for-all-users](https://unix.stackexchange.com/questions/119598/as-root-how-can-i-list-the-crontabs-for-all-users)
-   [https://unix.stackexchange.com/questions/169798/what-does-newermt-mean-in-find-command](https://unix.stackexchange.com/questions/169798/what-does-newermt-mean-in-find-command)
-   [https://ippsec.rocks/](https://ippsec.rocks/)
-   [https://0xdf.gitlab.io/2021/06/05/htb-scriptkiddie.html#incron](https://0xdf.gitlab.io/2021/06/05/htb-scriptkiddie.html#incron)