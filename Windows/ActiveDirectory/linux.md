# Linux with Active Directory

Notes on linux within an Active Directory environment. 

## Add Linux to Active Directory Domain

You will need either a Debian (apt) or RHEL (yum,dnf) based distro with sudo access.  
Administrator credentials for the active directory domain.

### Setup linux machine

For servers & workstations, ensure the hostname is on the AD domain. For example, if my Fedora laptop's hostname is set to `laptop01`, and I'm joining it to my `acme.`domain, the hostname would need to be updated to `laptop01.acme.domain`.

Confirm the current hostname with the `hostname` command. Change the hostname with the `hostnamectl` command like so: 

```
sudo hostnamectl set-hostname laptop01.acme.domain
```

Use either `hostname` or `hostnamectl` command to confirm the hostname has updated. 

#### Update DNS

The linux PC's DNS will need to be able to resolve the domain name. This can be quickly tested by pinging your domain controller's hostname, ie `dc01.acme.com`. If you do **not** get a response *or* it responds with the wrong IP, you will need to update your DNS settings. 

#### Ubuntu (via Netplan)

Ubuntu 17.10 and later versions use `netplan` for network configuration. Configuration files are located in `/etc/netplan/` and are written in YAML format.

1.  **Identify the Configuration File**: Locate the relevant `.yaml` file in `/etc/netplan/`. The filename may vary (e.g., `01-netcfg.yaml`, `50-cloud-init.yaml`).
    
2.  **Edit the File**: Open the file with a text editor using `sudo`. Modify the `nameservers` section for the desired network interface. If setting a static IP, you must also define addresses and a gateway.
    
    **Example Static Configuration:**
    
        network:
          version: 2
          ethernets:
            enp0s3:
              dhcp4: no
              addresses: [10.0.1.15/24]
              gateway4: 10.0.1.1
              nameservers:
                addresses: [8.8.8.8, 1.1.1.1]
        
    
    **Example DHCP Configuration (Overriding DNS):**
    
        network:
          version: 2
          ethernets:
            enp0s3:
              dhcp4: true
              nameservers:
                addresses: [8.8.8.8, 1.1.1.1]
        
    
3.  **Apply Changes**: To apply the configuration, run the following command:
    
        sudo netplan apply
        
    

#### Fedora (via nmcli)

Fedora utilizes NetworkManager for network configuration, which can be controlled via the `nmcli` command-line tool.

1.  **Identify Connection Name**: First, list the active network connections to identify the name of the one you wish to modify.
    
        nmcli connection show
        
    
    Note the name from the `NAME` column (e.g., `enp1s0`).
    
2.  **Modify DNS Settings**: Use the `nmcli connection modify` command to set the new DNS servers. Replace `[Connection Name]` with the name identified in the previous step. The `ipv4.ignore-auto-dns yes` setting prevents DHCP from overriding your custom DNS servers.
    
        sudo nmcli connection modify [Connection Name] ipv4.dns "8.8.8.8 1.1.1.1"
        sudo nmcli connection modify [Connection Name] ipv4.ignore-auto-dns yes
        
    
3.  **Reactivate Connection**: Apply the changes by taking the connection down and then bringing it back up.
    
        sudo nmcli connection down [Connection Name] && sudo nmcli connection up [Connection Name]
        
#### Verification

After applying changes on either distribution, you can verify the new DNS settings by checking the contents of `/etc/resolv.conf` or by using the `resolvectl status` command.

### Add Linux to Active Directory Domain

The actual joining of the domain is fairly simple, for Debian users there are a few prerequisites to install first: 

```bash
# Debian/Ubuntu only
sudo apt -y install realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
```

Use `realm` to discover and then join the domain: 

```
sudo realm discover acme.com
```

If your domain requires packages that were not already installed, install them now. Fedora users will have them install automatically when they join the domain. 

Join the linux machine to the domain: 

```
sudo realm join -U domain_admin acme.com
```

Enter your domain administrator credentials when prompted and press enter. When finished; use `realm list` to confirm you've joined the domain. 