# PVE Setup

Generalized guide to setting up Proxmox VE post-install. All actions, unless specified otherwise, are performed as the `root` user. 

## Firewall Setup

### Create IP Set

* Under `Datacenter > Firewall`, click drop down arrow and select `IPSet`.  
* Create `IPSet` in lefthand column, fill in `Name` and `Comment` fields as appropriate to your environment. Click 'OK' when ready. 
* Select (highlight) your new IPSet, and in the right hand `IP/CIDR` column, click 'Add'.
* Fill in your network IP information in IP/CIDR format, eg. `192.168.0.0/24`
* Repeat this process for each subnet your PVE host will interface with.

### Create Security Groups

* Under `Datacenter > Firewall`, click the drop down arrow and select `Security Group`. 
* Click `Create`, set the `Name` and `Comment` fields as appropriate to your environment. 
* Select (highlight) your Security Group, and in the right hand `Rules` Column, click 'Add'. 
* Create rules to allow SSH, HTTP & HTTPS from your IP Set(s) using the built-in macros.
  * You may expand upon rules from here as needed. This is considered a baseline ruleset for PVE host and VMs. 

## Add Security Groups to Firewall

* Under `Datacenter > Firewall`. Select `Firewall`.
* Click `Insert: Security Group` at the top. 
* Add your security groups as needed and select `Enable` when adding each one. 

## Users setup

### Create User Groups

* Under `Datacenter > Permissions`, click the dropdown arrow and select `Groups`
* For a general setup, create a group for SuperAdmins, Admins and Users. 

### Create Users

* Under `Datacenter > Permissions`, click the dropdown arrow and select `Users`. 
* Create a user account for each user of the PVE system. Typical naming scheme is First Initial, Last name for username. Be sure to set users email address, First and Last name fields. 
  * As `root` you can set Two Factor Auth for other users. 
* Add each user to their appropriate group. 

### Set Groups Permissions

* Under `Datacenter > Permissions`, Select `Permissions`
* Click `Add`, select root `/` as the path. Select your group and assign it a Role.
  * Assign Superadmin to PVEAdmin
  * Assign Admin to Administrator
  * Assign Users to PVEVMUsers 
  * You can view each Role's ability under `Datacenter > Permissions > Roles`.

### Set PVE as Default Authentication Realm

* Under `Datacenter > Permissions > Realms`. 
* Select `PVE`, then click `Edit`. 
* Select Default and (optionally) enforce TFA (Two Factor Authentication) for the `pve` realm. 

## Storage

Storage configuration will be highly specific to each PVE host or cluster. See [Storage](./Storage.md) for some notes on this. 

## Email Alerts

Mostly for forgotton passwords, and backup notifications. See [Email Alerts](./Email-Alerts.md) for setup information using gmail. 

## Two Factor Authentication Setup

See [2FA Setup](./2FA_Setup.md)