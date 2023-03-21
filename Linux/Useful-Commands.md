# Useful Commands

Frequently used commands; dirty tips and tricks from stuff around the net I've needed at one point. 

## Copy files from remote server to localhost
[ref stackexchange](https://unix.stackexchange.com/questions/188285/how-to-copy-a-file-from-a-remote-server-to-a-local-machine)
```bash
scp username@ipaddress:pathtofile localsystempath

scp sadananad@ipaddress:/home/demo/public_html/myproject.tar.gz .
```
## Run shell scripts in background: 
* [ref askubuntu](https://askubuntu.com/questions/88091/how-to-run-a-shell-script-in-background)
* [Difference between nohup, disown and &](https://unix.stackexchange.com/questions/3886/difference-between-nohup-disown-and)

Chosen answer lists three options, all of which will be outlined below. My preferred option of the three is `nohup`

epending on what you are wanting, just add a & to the end of the command

    script.sh &
    command &

If you are running it in a terminal, and you want to then close the terminal, use nohup or disown

nohup

    nohup script.sh &

disown

    script &
    disown

<h2>Difference Between nohup, disown and &</h2>
<p>Let's first look at what happens if a program is started from an interactive shell (connected to a terminal) without <code>&amp;</code> (and without any redirection). So let's assume you've just typed <code>foo</code>:</p>
<ul>
<li>The process running <code>foo</code> is created.</li>
<li>The process inherits stdin, stdout, and stderr from the shell. Therefore it is also connected to the same terminal.</li>
<li>If the shell receives a <code>SIGHUP</code>, it also sends a <code>SIGHUP</code> to the process (which normally causes the process to terminate).</li>
<li>Otherwise the shell waits (is blocked) until the process terminates or gets stopped.</li>
</ul>
<p>Now, let's look what happens if you put the process in the background, that is, type <code>foo &amp;</code>:</p>
<ul>
<li>The process running <code>foo</code> is created.</li>
<li>The process inherits stdout/stderr from the shell (so it still writes to the terminal).</li>
<li>The process in principle also inherits stdin, but as soon as it tries to read from stdin, it is halted.</li>
<li>It is put into the list of background jobs the shell manages, which means especially:
<ul>
<li>It is listed with <code>jobs</code> and can be accessed using <code>%n</code> (where <code>n</code> is the job number).</li>
<li>It can be turned into a foreground job using <code>fg</code>, in which case it continues as if you would not have used <code>&amp;</code> on it (and if it was stopped due to trying to read from standard input, it now can proceed to read from the terminal).</li>
<li>If the shell received a <code>SIGHUP</code>, it also sends a <code>SIGHUP</code> to the process. Depending on the shell and possibly on options set for the shell, when terminating the shell it will also send a <code>SIGHUP</code> to the process.</li>
</ul>
</li>
</ul>
<p>Now <code>disown</code> removes the job from the shell's job list, so all the subpoints above don't apply any more (including the process being sent a <code>SIGHUP</code> by the shell). However note that it <em>still</em> is connected to the terminal, so if the terminal is destroyed (which can happen if it was a pty, like those created by <code>xterm</code> or <code>ssh</code>, and the controlling program is terminated, by closing the xterm or terminating the <a href="http://en.wikipedia.org/wiki/Secure_Shell" rel="noreferrer">SSH</a> connection), the program will fail as soon as it tries to read from standard input or write to standard output.</p>
<p>What <code>nohup</code> does, on the other hand, is to effectively separate the process from the terminal:</p>
<ul>
<li>It closes standard input (the program will <em>not</em> be able to read any input, even if it is run in the foreground.  it is not halted, but will receive an error code or <code>EOF</code>).</li>
<li>It redirects standard output and standard error to the file <code>nohup.out</code>, so the program won't fail for writing to standard output if the terminal fails, so whatever the process writes is not lost.</li>
<li>It prevents the process from receiving a <code>SIGHUP</code> (thus the name).</li>
</ul>
<p>Note that <code>nohup</code> does <em>not</em> remove the process from the shell's job control and also doesn't put it in the background (but since a foreground <code>nohup</code> job is more or less useless, you'd generally put it into the background using <code>&amp;</code>). For example, unlike with <code>disown</code>, the shell will still tell you when the nohup job has completed (unless the shell is terminated before, of course).</p>
<p>So to summarize:</p>
<ul>
<li><code>&amp;</code> puts the job in the background, that is, makes it block on attempting to read input, and makes the shell not wait for its completion.</li>
<li><code>disown</code> removes the process from the shell's job control, but it still leaves it connected to the terminal. One of the results is that the shell won't send it a <code>SIGHUP</code>. Obviously, it can only be applied to background jobs, because you cannot enter it when a foreground job is running.</li>
<li><code>nohup</code> disconnects the process from the terminal, redirects its output to <code>nohup.out</code> and shields it from <code>SIGHUP</code>. One of the effects (the naming one) is that the process won't receive any sent <code>SIGHUP</code>. It is completely independent from job control and could in principle be used also for foreground jobs (although that's not very useful).</li>
</ul>
    

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
Can symlink mountpoints, it's how I replaced `Nextpool` on storage server. Stopped all services running off of `zfs Nextpool`, using `lsof | grep Nextpool` (plot twist, it was all docker...)  
I was then able to removed the pool, remove the folder it was at. Then create a symbolic it to new `zData` pool. `ln -s /zData /Nextpool`. Most NFS clients complained about this at first. All but the r620 needed a reboot to see updated mount point. On all servers (physical and VM) I restarted all `nfs` related services, nfs server included in that. Only the r620 picked up the change, could be because `thor` was rebooted and had updated mount point and `corosync` took over? Still had to restart nfs services to see upate. 