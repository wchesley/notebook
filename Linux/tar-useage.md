# tar useage

Created: June 27, 2021 8:50 PM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: May 26, 2022 4:36pm

[Create Tar archive](https://www.cyberciti.biz/faq/how-to-create-tar-gz-file-in-linux-using-command-line/)

Most common: 

### Create tar archive: 
`tar -czvf projects.tar.gz $HOME/projects/` where first is name of new archive, and second is directory to compress

### Extract tar: 

`tar -xzvf projects.tar.gz -C /tmp/` the -C flag points this to a directory

### Extract tar without creating a new directory: 

`tar xvf group.tar --strip-components 1` 
Pulled from: https://stackoverflow.com/questions/30253463/extract-tar-file-without-creating-folder on 5/26/2022 

### Extracting tar.gz File from stdin

If you are extracting a compressed tar.gz file by reading the archive from stdin (usually through a pipe), you need to specify the decompression option. The option that tells tar to read the archives through gzip is `-z`.

In the following example we are downloading the [Blender](https://www.blender.org/) sources using the `wget` command and pipe its output to the `tar` command:

```
wget -c https://download.blender.org/source/blender-2.80.tar.gz -O - | sudo tar -xz
```

If you don’t specify a decompression option, `tar` will indicate which option you should use:

```output
tar: Archive is compressed. Use -z option
tar: Error is not recoverable: exiting now
```
Pulled from: https://linuxize.com/post/how-to-extract-unzip-tar-gz-file/ 5/26/2022

