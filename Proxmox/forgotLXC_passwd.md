## 

# How to Reset forgotten LXC Container \
root password on Proxmox VE(PVE)

pulled from here: <https://dannyda.com/2020/12/23/how-to-reset-forgotten-lxc-container-root-password-on-proxmox-vepve/>

## The Issue

We forgot the LXC container’s password which is running on PVE, we want to reset it

## The Fix

1 Login to PVE web gui first

2 From the Datacenter view at our left hand side, find the LXC container which we want to reset password for and remember the ID of the container e.g. If we see a container named **200 (testContainer)**, 200 is its ID, testContainer is its name

3 Now start the container

4 Connect to PVE host (as root user) via SSH or open a Shell/Console from the top right corner **>_ Console** button of PVE web gui

5 Use the following command to attach our session to the LXC container

```
lxc-attach -n 200
# Replace 200 with the correct LXC container's ID
```

6 Change the password for the container

```
passwd
```

Type the new password, Press Enter key, then type the password and Press Enter key again to set the new password for the container

7 Once done, we can login to the container with the new password