# Backblaze B2

ZFS pool Nextpool/Photos backed up nightly via [rclone-cron.sh](http://rclone-cron.sh) (rclone sync) to backblaze b2
Initial transfer of data was 30gb
~~Cron backups have not been verified! Wasn't working properly, rclone config was set up under user account and not root, yet was being run from root account. deleted root cron entry and moved it to user account. Still needs to verify if it runs properly or not. 6/22/2021 Believe that cron is working as expected, nextcloud was not properly syncing phones after ssl cert change, that has been fixed. ~~
 7/15/2021 Nextcloud sync is broken again... 'Connection Error' is all it states, Want to see if I can get more info over [adb](https://developer.android.com/studio/command-line/adb)

Set up was used following this: [https://dev.to/hunterparks/backing-up-files-to-backblaze-b2-with-rclone](https://dev.to/hunterparks/backing-up-files-to-backblaze-b2-with-rclone)

Exerpt from link: 

# Backing up Your Files

### Step 1 - Set Up a Backblaze B2 Account

While Rclone supports many different cloud providers (see their website [here](https://rclone.org/overview/)), I will be using [B2](https://www.backblaze.com/b2/cloud-storage.html) from [Backblaze](https://www.backblaze.com/).
 Follow the instructions on the B2 website to setup your B2 account and 
get your API key - this key will allow you to access you B2 account 
through Rclone.

### Step 2 - Install Rclone

Rclone will need to be installed on the computer you are using to 
store your files. If you are not using the same hardware I am, please 
install the Rclone version that will work for your computer. Visit the 
Rclone [downloads](https://rclone.org/downloads/) page to find the installer for your computer. If you are following my hardware choice, select the ARM - 32 Bit installer. Finally, follow the [installation instructions](https://rclone.org/install/) on the Rclone website to properly install Rclone on your computer.

### Step 3 - Connect Rclone to Backblaze B2

1. Run `rclone config`.
2. Press `n` to create a new remote.
3. Specify a name to reference this remote in commands. For my purposes, I chose `remote`.
4. Press `2` then hit `enter` to select Backblaze B2.
5. Enter your Backblaze Account ID then hit `enter`.
This will look something like `123456789abc`.
6. Enter your Backblaze Application Key then hit `enter`.
This will look something like `0123456789abcdef0123456789abcdef0123456789`.
7. Leave Endpoint blank then hit `enter`.
8. Press `y` then hit `enter` to save configuration.

For more information, please visit the [Rclone B2](https://rclone.org/b2/) website.

### Step 4 - Configure Encryption in Rclone

1. Run `rclone config`.
2. Press `n` to create an encrypted container.
3. Specify a name to reference this container in commands. For my purposes, I chose `secret`.
4. Press `5` then hit `enter` to select crypt.
5. Enter `<REMOTE_NAME>:<B2_BUCKET_NAME>` then hit `enter` to select the previously made remote.
For my purpose, this is `remote:backup` where `backup` is the name of my B2 bucket.
6. Type `standard` for encrypted file names.
7. Choose a passphrase or generate one.
It is important that you remember your passphrase - you will not be able to decrypt your backups without it.
8. Choose a salt or generate one.
It is important that you remember your salt - you will not be able to decrypt your backups without it.
9. Press `y` to confirm the configuration and press `q` to close Rclone.

### Step 5 - Backing up Your Files

Now, when wanting to backup a folder to BackBlaze, type the following command:

```
rclone sync /path/to/folder secret:

```

This line takes all of your files in the folder path and uploads them
 to your Backblaze B2 bucket. For me, I write the following line:

```
rclone sync Backup/ secret

```

**Note**: There are two options for uploading to the cloud. While I use `sync`, you can also use `copy`. Here are the differences:

- `Sync` will mirror the folder path exactly from your local
filesystem to Backblaze. This deletes files in the destination that have been removed from the source.
- `Copy` will copy files from your local filesystem to Backblaze where deleted files will NOT be deleted from Backblaze.

If you have a lot of files to upload that could take a long time, use
 the following command so that output is recorded to a file and the 
upload will not get killed if you log out:

```
setsid [command] --log-file /path/to/file.log &>/dev/null

```

where `[command]` is the command you used above.

### Step 6 - Backup Automation

The following set of commands will setup your computer to run an automatic backup of your files.

1. Run `crontab -e`
2. At the end of the file, add the following command:

```
0 * * * * /usr/bin/setsid /usr/sbin/rclone sync /path/to/folder secret: &>/dev/null

```

1. Save and exit your crontab file.

**Note**: You can add an output log file by using the `--log-file` parameter found in step 5. Additionally, you can also choose between the `sync` and `copy` rclone modes.

### Step 7 - Restoring Your Files

To obtain you files from Backblaze, you will need to configure rclone
 on a new machine or you will need to move to a different location of 
your uploading computer. It can be helpful to backup you configuration 
files to make it easier to restore. Once your configuration is correct, 
run the following command:

`rclone sync secret: /path/to/folder`

---
[back](./README.md)

