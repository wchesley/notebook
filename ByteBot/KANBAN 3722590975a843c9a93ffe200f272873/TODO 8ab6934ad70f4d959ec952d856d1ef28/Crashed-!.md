# Crashed?!

Assign: Walker Chesley
Status: Completed

- Somewhere we crashed reading the log file, discord service remained up but logs were down. Happened sometime between April 27th and May 1st. I only noticed when I died in game and no message was sent. Didn't update with Halfdan joining the game either. Nothing of note in journalctl. Attempting to redirect stdout to log file to debug this further.
- May 3, 2021 Updated ExecStart in service file to include stdout redirect to text file in /tmp/bytebot.log, Didn't see that file get immediatly created when I was home for lunch, pending further investigation. Initial thoughts are that it didn't work, and I'll have to write a shell script to wrap the program in and launch from that.
-