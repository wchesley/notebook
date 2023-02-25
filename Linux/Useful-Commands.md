# Useful Commands

Frequently used commands; dirty tips and tricks from stuff around the net I've needed at one point. 

## Change default shell of Ubuntu: 

* [pulled from stackoverflow](https://superuser.com/questions/46748/how-do-i-make-bash-my-default-shell-on-ubuntu)

Use:

    chsh

Enter your password and state the path to the shell you want to use.

For Bash that would be /bin/bash. For Zsh that would be /usr/bin/zsh.


## Get Process ID (PID) of shell script
```bash
process_id=`/bin/ps -fu $USER| grep "ABCD" | grep -v "grep" | awk '{print $2}'`
```
Also, I wasn't running much under my user account, just running `ps` showed me the script `full_backup.sh` in a small list. 
```bash
root@heimdall:/home/wchesley/Documents/svc-backup# ps
    PID TTY          TIME CMD
 965767 pts/0    00:00:00 sudo
 965806 pts/0    00:00:00 su
 965807 pts/0    00:00:00 bash
2229738 pts/0    00:00:00 full_backup.sh
2232745 pts/0    00:01:46 rsync
2232746 pts/0    00:00:27 rsync
2232747 pts/0    00:01:54 rsync
2306554 pts/0    00:00:00 ps
```
## Dry-Run of rm command
- [Found on Stackoverflow, cause where else are any good fixes found?](https://unix.stackexchange.com/questions/7056/how-do-you-do-a-dry-run-of-rm-to-see-what-files-will-be-deleted)

Say you want to run:

    rm -- *.txt

You can just run:

        echo rm -- *.txt

or even just:

    echo *.txt

to see what files `rm` would delete, because it's the shell expanding the `*.txt`, not `rm`.

The only time this won't help you is for `rm -r`.

If you want to remove files and directories recursively, then you could use `find` instead of `rm -r`, e.g.

    find . -depth -name "*.txt" -print

then if it does what you want, change the `-print` to `-delete`:

    find . -depth -name "*.txt" -delete

(`-delete` implies `-depth`, we're still adding it as a reminder as recommended by the GNU find manual).