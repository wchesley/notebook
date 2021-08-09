# tar useage

Created: June 27, 2021 8:50 PM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: June 27, 2021 8:51 PM

[](https://www.cyberciti.biz/faq/how-to-create-tar-gz-file-in-linux-using-command-line/)

Most common: 

Create tar archive: 
`tar -czvf projects.tar.gz $HOME/projects/` where first is name of new archive, and second is directory to compress

Extract tar: 

`tar -xzvf projects.tar.gz -C /tmp/` the -C flag points this to a directory