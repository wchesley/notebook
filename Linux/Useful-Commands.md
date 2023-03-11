# Useful Commands

Frequently used commands; dirty tips and tricks from stuff around the net I've needed at one point. 

## Copy files from remote server to localhost
[ref stackexchange](https://unix.stackexchange.com/questions/188285/how-to-copy-a-file-from-a-remote-server-to-a-local-machine)
```bash
scp username@ipaddress:pathtofile localsystempath

scp sadananad@ipaddress:/home/demo/public_html/myproject.tar.gz .
```

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

## Symlinks
Run man ln  in your terminal and you should see the man pages for the ln command.
```bash
LN(1)                     BSD General Commands Manual                    LN(1)

NAME
     link, ln -- make links

SYNOPSIS
     ln [-Ffhinsv] source_file [target_file]
     ln [-Ffhinsv] source_file ... target_dir
     link source_file target_file

DESCRIPTION
     The ln utility creates a new directory entry (linked file) which has the same modes as the original file.  It is
     useful for maintaining multiple copies of a file in many places at once without using up storage for the
     ``copies''; instead, a link ``points'' to the original copy.  There are two types of links; hard links and sym-
     bolic links.  How a link ``points'' to a file is one of the differences between a hard and symbolic link.

     The options are as follows:

     -F    If the target file already exists and is a directory, then remove it so that the link may occur.  The -F
           option should be used with either -f or -i options.  If none is specified, -f is implied.  The -F option
           is a no-op unless -s option is specified.

     -h    If the target_file or target_dir is a symbolic link, do not follow it.  This is most useful with the -f
           option, to replace a symlink which may point to a directory.

     -f    If the target file already exists, then unlink it so that the link may occur.  (The -f option overrides...
```