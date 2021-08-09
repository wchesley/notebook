# apt-add-repository not working!

Created: June 24, 2021 11:24 AM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: June 24, 2021 11:26 AM

Ran into an issue when trying to install packer on ProxmoxVE. `apt-add-repository` didn't exist on the system! Fix is outlined here: [https://dannyda.com/tag/sudo-add-apt-repository-command-not-found/](https://dannyda.com/tag/sudo-add-apt-repository-command-not-found/)
And fix is isolated here: 

## The Fix

Execute following command to install “add-apt-repository” package

```
sudo apt-get install software-properties-common
```

Update the system

```
sudo apt-get update
```

Add the ppa repository again which we want to add in the first place

```
sudo add-apt-repository ppa:.....
```

Then install the app from ppa, if that is our intention

```
sudo apt install <appname>
```