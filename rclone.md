# Rclone 
https://rclone.org/ 

Tool I use for backups to local exHDD and Backblaze B2 instance. 

typical usage for my is just `rclone sync /source /destination -P --transfers 16`
Where `-P` Shows progress and `--transfers 16` uses 16 threads(uploads) for the task. 