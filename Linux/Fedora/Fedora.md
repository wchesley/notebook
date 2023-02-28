# Fedora
Currently have my Laptop and Winston's PC on Fedora 36 & 35 respectively 

## Notes: 
- [Upgrade Fedora to next Major Version](./Upgrade_Fedora_Release.md)
- 

## Add users to "sudo" group
For RHEL distro's, the "sudo" group is different than Debian, it's called wheel here. 

`sudo usermod -aG wheel <username>`

remove sudo access to a user: 

`sudo gpasswd -d senthil wheel`

## Discord install
Method 1: Installing Discord via RPM Fusion Repository

Discord can be installed by adding the nonfree RPM Fusion repository, which is the preferred method of most Fedora users, since updating is easy and the application starts up faster than the Flatpak version.

Open a terminal and use the following command to add the RPM-fusion non-free repository:

    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

Once you’re done with it, update the repository list (should not be needed but just for the sake of it):

    sudo dnf update

Then install Discord via DNF command like this:

    sudo dnf install discord

If asked, confirm GPG keys: 

![discord_gpg_key_image](https://itsfoss.com/content/images/wordpress/2021/11/authorize-gpg-key-1-800x573.png)