[back](../README.md)

## Info

# Setup

The below setup has been directly pulled from [here](http://markliversedge.blogspot.com/2023/09/wireguard-setup-for-dummies.html). I have yet to adapt it to my setup as I don't use Dynamic DNS. 

## Step 1: Expose Wireguard VPN Server to the Internet

**Your Public IP Address**

First you will need to make sure your external IP address can be referenced from the wider internet. If you have a static IP address from your ISP then you don't need to do anything, we can just use the IP name you have been given or the IP itself.

If you have a dynamic IP address then you will need to setup dynamic DNS. For my setup I used [NoIP.com](http://noip.com/). Its pretty inexpensive at $30 a year, with auto-renewal so I don't forget it.

![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj9BqVcDiRgTQ1QBdlsMIDZP2Y0LF4IIJO6sTc5USGMgxIqVJiRGGgaObllJ6gOidCeroad5yBWAeoBwiw17Buex_s_GJ4NLLbWUGlVTb7dcpbAxspF_7Bxg5lLbtGqQKeUGwFzwpOqhmTb5ixJtQy6vxCSYuoxeVXHURLxmizHQP-jOXg-M_cx/w542-h178/NOIP.png)

I then setup my router to call out when the IP address is allocated, you should do something similar, it will look something like this:

![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjDbeZVnIOEqMJUSMh2FDtj8UwPnH-_ZMyqey3bgOqu74IAK9sKfFtJJRU-lnVyQv_vJVrV0fii06_IzJZoAoFEQJ3juhbDaQl0nUjfquUwykH6EzBplvx85Ksn0FKdz0FHoiorWjdcprbSeCh5PT25AjI-4BDl9XDRB10FwYJtuMb7YSQOXmTT/w539-h259/DDNS.png)

**Port forwarding the Wireguard UDP Port (33333)**

Secondly, you will need to make sure the packets that arrive at your router for Wireguard are forwarded on to your VPN server host. Again, this is configured in your router/ gateway/ firewall. Make sure you are configuring port forwarding not firewall rules to open up ports. It will look something like this:

![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjc_ZhHiSCU5DQXOQj-pIj4S2PaJ_kU_Pkq5oD_IKI9RQz7TcX52dfkzLOyZ1R_4fE9tAmSyHiTkbWzppT9fpwWZ4mWixEmP0pQxNH-0kK4lBq5KKLhhfTyGWpwl9GKVAJQap2jveMSG2BSNwBA_s5nJrr1o_49TJHr8Gxfj94QFXr6rCwKJgtU/w562-h272/portforward.png)

Things to be super careful about- make sure its port 33333 and UDP (not TCP) and make sure you get the local IP address of your VPN server host (at this point you should be using a static IP for it on your local lan and not DHCP).

**Check packets are arriving correctly**

Optionally we might want to check packets are arriving and being forwarded correctly. We can send packets to the internet address with [netcat](https://man.openbsd.org/nc.1) and use [tcpdump](https://www.tcpdump.org/) to see what arrives at our host. 

Install the tools with:

**$ apt install netcat-openbsd tcpdump**

Find the ethernet port on your computer, typically it will start with en, for me it is eno1:

**$ ifconfig -a**

**eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500**
**inet 192.168.1.79  netmask 255.255.255.0  broadcast 192.168.1.255**
**inet6 2a0e:3700:2039:1600:f60f:6214:d960:4b22  prefixlen 64  scopeid 0x0**
**inet6 2a0e:3700:2039:1600:b665:4926:24e1:350c  prefixlen 64  scopeid 0x0**
**inet6 2a0e:3700:2039:1600:db28:43e:eaa:6ba7  prefixlen 64  scopeid 0x0**
**inet6 fe80::c8a3:f7ca:495d:cc50  prefixlen 64  scopeid 0x20**
**inet6 2a0e:3700:2039:1600:b3e9:eff2:a416:e948  prefixlen 64  scopeid 0x0**
**ether 40:16:7e:28:0f:08  txqueuelen 1000  (Ethernet)**
**RX packets 14697147  bytes 16895383787 (16.8 GB)**
**RX errors 0  dropped 128741  overruns 0  frame 0**
**TX packets 5297570  bytes 4232323565 (4.2 GB)**
**TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0**

**device interrupt 18  memory 0xfb100000-fb120000**

Then start tcpdump to sniff incoming packets on your VPN host computer, replacing the ethernet port **eno1** below with your ethernet adaptor found in the command above (we can also use this command later to watch network activity when we have our clients running)

**$ tcpdump -i eno1 'udp port 33333'**

From another terminal we will start sending packets to the internet address, using **nc** (netcat). My internet address is a dynamic DNS address so looks something like this, you should replace **internet.ddns.net** with your own fully qualified domain name for this test.

**$ nc -vz -u internet.ddns.net 33333**

**Connection to internet.ddns.net (149.102.14.13) 33333 port [udp/*] succeeded!**

On the tcpdump window you should see some output as the packets are received on your local host computer, something like this:

**tcpdump: verbose output suppressed, use -v[v]... for full protocol decode**

**listening on eno1, link-type EN10MB (Ethernet), snapshot length 262144 bytes**

**08:58:43.621588 IP 149.102.14.13.38018 > monolith.33333: UDP, length 1**

**08:58:43.621839 IP 149.102.14.13.38018 > monolith.33333: UDP, length 1**

**08:58:44.621670 IP 149.102.14.13.38018 > monolith.33333: UDP, length 1**

**08:58:45.621813 IP 149.102.14.13.38018 > monolith.33333: UDP, length 1**

**08:58:46.621934 IP 149.102.14.13.38018 > monolith.33333: UDP, length 1**

If you have a firewall running on the local host you will need to update that to let 33333 through from the router- I will leave this to you- since it is very specific to your local configuration. 

If you do not see any output from tcpdump then something isn't quite right yet- check your router configuration again, we really need to port to be open before we start because we're gonna have challenges along the way and need to be sure data is arriving at the port correctly.

## Step 2: Setup Wireguard VPN Server

**Install the wireguard software and dependencies**

Wireguard and related tools are available as packages on Ubuntu/Debian, so fairly easy to install:

**$ apt install wireguard wireguard-tools iptables**

To check they're installed and get versions you could:

**$ wg --version**

**wireguard-tools v1.0.20210914 - https://git.zx2c4.com/wireguard-tools/**

**$ iptables --version**

**iptables v1.8.7 (nf_tables)**

I am using Ubuntu 23.04 which seems to be a good choice for wireguard, the kernel modules are built-in and there is some additional support in settings that we will look at a little later. We have installed **iptables** because is is used to manage NAT and packet forwarding in the kernel.

**Set Linux kernel port forwarding**

The wireguard server sets up a virtual adaptor wg0 to tunnel off to peers, but will receive packets on the ethernet adaptor (eno1 in my case). By default forwarding messages between networks (ethernet and wg0) is not enabled, so we need to enable it. Note it may already be set if you have used other VPN software, this is not an issue.

**$ vi /etc/sysctl.conf**

You will need to uncomment the line with **net.ipv4.ip** (remove the first # character):

**# Uncomment the next line to enable packet forwarding for IPv4**

**#net.ipv4.ip_forward=1**

So it should look like this instead:

**# Uncomment the next line to enable packet forwarding for IPv4**

**net.ipv4.ip_forward=1**

Close vi (**:wq**) and then we need to update the kernel to reflect these changes (they will be applied when we reboot, but we can make the change without restarting):

**$ sysctl -p**

And finally, to check the change has been applied correctly we can look at the current setting with:

**$ cat /proc/sys/net/ipv4/ip_forward**

**1**

You should see 1 output to show it is enabled, if you get 0 then revisit the steps as the change has not been made. 

**Create public and private keys for VPN server**

All  the configuration files for the server are stored in /etc/wireguard, so lets go there first.

**$ cd /etc/wireguard**

You will see the directory is empty, we are going to start creating files there for the server and peers as we go, for example, on my setup I have the following files in there:

**-rw------- 1 root root  353 Sep 28 12:43 dad.conf**

**-rw------- 1 root root   45 Sep 28 12:43 dad-privatekey**

**-rw-r--r-- 1 root root   45 Sep 28 12:43 dad-publickey**

**-rw------- 1 root root  353 Sep 28 12:08 harry.conf**

**-rw------- 1 root root   45 Sep 28 12:07 harry-privatekey**

**-rw-r--r-- 1 root root   45 Sep 28 12:07 harry-publickey**

**-rw------- 1 root root  353 Sep 28 13:43 mobile.conf**

**-rw------- 1 root root   45 Sep 28 13:41 mobile-privatekey**

**-rw-r--r-- 1 root root   45 Sep 28 13:41 mobile-publickey**

**-rw------- 1 root root  339 Sep 28 10:20 ollie.conf**

**-rw------- 1 root root   45 Sep 28 08:44 ollie-privatekey**

**-rw-r--r-- 1 root root   45 Sep 28 08:45 ollie-publickey**

**-rw------- 1 root root   45 Sep 28 08:07 server-privatekey**

**-rw-r--r-- 1 root root   45 Sep 28 08:07 server-publickey**

**-rw------- 1 root root 1281 Sep 28 13:42 wg0.conf**

So first thing to do is create the keys, a private one that is used by the server locally and a public one that is used by peers (clients) when they connect. Unlike other systems like OpenVPN we do not need to worry about certificate authorities and such, just two keys: private and public. Almost everything we do with wireguard is via the **wg** command, now would be a good time to look at it's [manpage](https://www.man7.org/linux/man-pages/man8/wg.8.html). 

To create the keys we need for the server:

**$ wg genkey | tee server-privatekey | wg pubkey > server-publickey**

**$ cat server-privatekey**

**4K68mdpQWdEz/FpdVuRoZYgWpQgpW63J9GFzn+iOulQ=**

**$ cat server-publickey**

**MQBiYHxAj7u8paj3L4w4uav3P/9YBPbaN4gkWn90SSs=**

**$ ls -l server-***

**-rw-r--r-- 1 root root 45 Sep 29 11:37 server-privatekey**

**-rw-r--r-- 1 root root 45 Sep 29 11:37 server-publickey**

The private key need to be carefully protected so will need to set its permissions accordingly:

**$ chmod 600 server-privatekey**

**$ ls -l server-***

**-rw------- 1 root root 45 Sep 29 11:37 server-privatekey**

**-rw-r--r-- 1 root root 45 Sep 29 11:37 server-publickey**

Note: these two files are never referenced by any part of wireguard, we include the contents into config files explicitly, but its useful to have them stored and available as we edit config files for the server and peers later in the tutorial (they're not exactly easy to type or remember !).

**Configure the VPN Server**

Ironically there isn't really a server running. Most of the work is done by kernel modules and network interfaces. When the wireguard service is up and running the only processes you're likely to see are **wg-crypt** workers threads.

Instead there is a shell script called **wg-quick** that lives in **/usr/bin** (you can go look at it in a text editor) that reads a configuration file and sets up interfaces (notably **wg0**) using the **wg** and **ip** commands. It does nearly all the heavy lifting so we don't have to. It reads from a fairly simple configuration file-- and that is what we are about to create. Note, we never directly run **wg-quick**, it is designed to be executed as part of **systemd** via the **systemctl** command.

The **wg-quick** script looks for a configuration file named after the network interface the "server" will be using. It is possible to have multiple "servers" running at the same time, so the interface names reflect that, the first server will use **wg0** and then subsequently **wg1**, **wg2** and so on. The format of the config file is fully documented in the [wg-quick manpage](https://www.man7.org/linux/man-pages/man8/wg-quick.8.html).

So we will create a new configuration file **wg0.conf,** making sure you are still in **/etc/wireguard**. We are going to setup just the server aspects at this point, we will come back to the file later to edit it and add peer (client) details.

**$ vi wg0.conf**

Below is a sample wg0.conf file, you can go ahead and cut and paste into the editor, we will then walk through the settings one by one and edit them accordingly. **TL;DR- you are probably only going to (1) change the private key to the one generated above and (2) set the right ethernet device**.

**[Interface]**

**## Local Address : A private IP address for wg0 interface.**

**Address = 10.20.10.1/24**

**ListenPort = 33333**

**## local server privatekey**

**PrivateKey =** **4K68mdpQWdEz/FpdVuRoZYgWpQgpW63J9GFzn+iOulQ=**

**## The PostUp will run when the WireGuard Server starts the virtual VPN tunnel.**

**## The PostDown rules run when the WireGuard Server stops the virtual VPN tunnel.**

**## Specify the command that allows traffic to leave the server and give the VPN clients access to the Internet.**

**PostUp = iptables -A FORWARD -i wg0 -j ACCEPT**

**PostUp = iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE**

**PostDown = iptables -D FORWARD -i wg0 -j ACCEPT**

**PostDown = iptables -t nat -D POSTROUTING -o eno1 -j MASQUERADE**

**Address** -- The IP address is for the wg0 interface, which is a tunnel- at one end is the server and at the other end is a client peer (or a number of client peers). In reality, it doesn't matter what IP network number you use just so long as it doesn't clash with your LAN IP network or use a public network address. So unless you have a good reason, 10.20.10.1 will probably be ok- it is a private network number and easy enough to remember.

**Listen Port** -- Most folks use 33333 as the wireguard port since its in a user address range, easily remembered and unlikely to clash with other VPN solutions or popular network services. You can of course change it, but bear in mind it must map to the port number we used in Step 1 above.

**PrivateKey** -- this is the local private key we generated above, you must change this and of course keep it private. It is only used in this file locally and should never be shared with peers/ clients. Go ahead and change this to the generate value we stored in the file **server-privatekey**.

**PostUp PostDown** -- These commands are issued when the interface is setup and stopped to configure network address translation and forwarding. This is of course when you stop and start the service. You will need to edit the file to reflect the name of your ethernet device we captured in step 1 above replacing all instances of **eno1** above. If you have specific needs related to NAT then you will need to update these commands, but for the general use case they should be fine. Note: these rules are required regardless of any firewall configuration you may have on the local host.

If you took the time to read the **wg-quick** man page you will notice there are other settings possible here, but to get our server up and running this will be sufficient to get us started, so write and close **vi** once this is done (**:wq**)

As before, since the file contains private keys we should make sure it is not easily read by prying eyes:

**$ chmod 600 wg0.conf**

**Start Server and ensure starts after reboot**

As this is for Ubuntu we will be setting the service to start when we boot using the relatively new systemd approach. This means we use systemctl commands to get things running. 

We can start the service using the command below. If you are new to **systemctl** the text after the **@** symbol is passed as a parameter to the command, which in this case is the **wg-quick** script. From here the **wg-quick** script knows we want to bring up the **wg0** interface and should look for a configuration file **/etc/wireguard/wg0.conf**:

**$ systemctl start wg-quick@wg0**

This will start the service and setup the interfaces and so on. You can validate this by looking at the network routing table:

**$ netstat -nr**

**Kernel IP routing table**

**Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface**

**0.0.0.0         192.168.1.254   0.0.0.0         UG        0 0          0 eno1**

**10.20.10.0      0.0.0.0         255.255.255.0   U         0 0          0 wg0**

**192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eno1**

The most notable things to check are the routes to the **10.20.10.x** network listed above via the **wg0** interface. Assuming it all looks good we can go ahead and enable the service to run on startup:

**$ systemctl enable wg-quick@wg0**

You will not see any output but now the service is up and running we can check the logs and status.

**Check server status and logs**

We can use the **wg** command to see what is happening:

**$ wg show**

**interface: wg0**

**private key: (hidden)**

**listening port: 33333**

At this point we will not see any information about the peer connections because we have not configured any yet. They will appear later. But we will be able to see the interface is up and the service is listening as we need.

Since it is also running as a service we can use standard systemd commands to look at the service status and logs (mine are shown below after I stopped, started and reloaded as I configured peers - somethiung we are going to do next.

**$ systemctl status wg-quick@wg0**

**● wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0**

**Loaded: loaded (/lib/systemd/system/wg-quick@.service; enabled; preset: enabled)**

**Active: active (exited) since Thu 2023-09-28 12:10:55 BST; 1 day 1h ago**

**Docs: man:wg-quick(8)**

**man:wg(8)**

**https://www.wireguard.com/**

**https://www.wireguard.com/quickstart/**

**https://git.zx2c4.com/wireguard-tools/about/src/man/wg-quick.8**

**https://git.zx2c4.com/wireguard-tools/about/src/man/wg.8**

**Process: 109910 ExecReload=/bin/bash -c exec /usr/bin/wg syncconf wg0 <(exec /usr/bin/wg-quick strip wg0) (>**

**Main PID: 105351 (code=exited, status=0/SUCCESS)**

**CPU: 19ms**

**Sep 28 12:10:55 monolith wg-quick[105351]: [#] wg setconf wg0 /dev/fd/63**

**Sep 28 12:10:55 monolith wg-quick[105351]: [#] ip -4 address add 10.20.10.1/24 dev wg0**

**Sep 28 12:10:55 monolith wg-quick[105351]: [#] ip link set mtu 1420 up dev wg0**

**Sep 28 12:10:55 monolith wg-quick[105351]: [#] iptables -A FORWARD -i wg0 -j ACCEPT**

**Sep 28 12:10:55 monolith wg-quick[105351]: [#] iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE**

**Sep 28 12:10:55 monolith systemd[1]: Finished wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0.**

**Sep 28 12:45:59 monolith systemd[1]: Reloading wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0...**

**Sep 28 12:45:59 monolith systemd[1]: Reloaded wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0.**

**Sep 28 13:42:40 monolith systemd[1]: Reloading wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0...**

**Sep 28 13:42:40 monolith systemd[1]: Reloaded wg-quick@wg0.service - WireGuard via wg-quick(8) for wg0.**

So we have a server running, but since there are no peers (clients) configured its not going to do much. We are however now ready to configure some clients so lets get to that.

## Step 3: Setup client connections

Although in my requirements I am setting up several clients, we will just setup one and run through some of the differences at the client end in step 4.

**Setup client keys**

Firstly we need to generate public and private keys for the client, just as we did for the server, so we will repeat the process, but I will spare you all the file management steps:

**$ wg genkey | tee client-privatekey | wg pubkey > client-publickey**

**$ cat client-privatekey client-pubkey**

**sAnZ4LQQ0UCv8id7jOB6zB5mITWltwUnfcWGbfH09m4=**

**IXW+O1L0OXs3dIGk55wOUIjvcWlQthuO84XS+rNB5Ac=**

**Setup VPN server for a new client** 

We're now going to re-edit the wg0.conf file to add details for this client peer:

**$ vi wg0.conf**

Lets add the following lines to the end of the file:

**[Peer]**

**# one client which will be setup to use 10.20.10.2 IP**

**PublicKey =** **IXW+O1L0OXs3dIGk55wOUIjvcWlQthuO84XS+rNB5Ac=**

**AllowedIPs = 10.20.10.2/32**

You will need to set the public key to the value just generated.

The AllowedIPs entry means what IP addresses do we accept from this Peer (client)- if a network packet arrives from this peer via the **wg0** interface the source IP address is checked- if it is not in this list it is dropped. This is our way of ensuring we only process packets that come directly from our peer. But we need to make sure the peer gets this IP address when we configure it (which we will do shortly). It will need to be set for every peer.

At this point we have configured our local VPN service at 10.20.10.1 and a remote peer can connect using the 10.20.10.2 IP address.

**Update the VPN service by reloading the config file**

We do not need to restart the wireguard service when we add peers, since existing clients may be connected it would be pretty poor to drop connections every time we add a peer. So instead we can use the reload primitive via systemctl:

**$ systemctl reload wg-quick@wg0**

**$ wg show**

**interface: wg0**

**private key: (hidden)**

**listening port: 33333**

**peer: IXW+O1L0OXs3dIGk55wOUIjvcWlQthuO84XS+rNB5Ac=**

**allowed ips: 10.20.10.2/32**

You can see from the status output that the service supports a peer connection, but it is not active and has never been active. So now we need to go ahead and setup the client.

## Step 4: Setup clients

**Create client config file**

So now, finally, we get to configure a client- we will create it locally and then share with the users (either as a qrcode or emailing the file). So as ever, open with vi:

**$ vi client.conf**

The file is a lot simpler for clients, and will look like this:

**[Interface]**

**## Local Address : A private IP address for wg0 interface.**

**Address = 10.20.10.2/24**

**ListenPort = 33333**

**DNS = 8.8.8.8**

**## local client privateky**

**PrivateKey = sAnZ4LQQ0UCv8id7jOB6zB5mITWltwUnfcWGbfH09m4=**

**[Peer]**

**# remote server public key**

**PublicKey = MQBiYHxAj7u8paj3L4w4uav3P/9YBPbaN4gkWn90SSs=**

**Endpoint = internet.ddns.net:33333**

**AllowedIPs = 0.0.0.0/0**

You can go ahead and cut and paste this into the client config file, but will need to make some changes to reflect your local configuration, notably:

**Interface address** - this should match the address we assigned above and will change as we configure more and more clients.

**Interface DNS** - we need to configure the wireguard client's DNS service carefully, this will be dependant on local policy but for me, when I'm connected to a VPN I prefer to use the google nameservers. You can start with this setting and adapt to your needs once things are up and running.

EDIT 30th Oct 2023: since writing this post I [setup a pihole server on my wireguard host](https://www.wundertech.net/how-to-install-pi-hole-on-ubuntu/), so now I set the DNS address to 10.20.10.1. This is particularly cool on my mobile since it is now permanently connected over VPN and will get ad blocking DNS all the time. It has transformed web browsing on my phone.

**Interface PrivateKey** - this will be the value we saved away in client-privatekey file above.

**Peer PublicKey** - this will be the server's public key we generated right at the beginning and stored in the server-publickey file.

**Peer Endpoint** - this is the IP address or DNS name for your internet presence we exposed in step 1. The client will connect here to initiate a connection when the client user activates the VPN.

**Peer AllowedIPs** - like with the server, this is the IP addresses we will accept from the peer. But in the case of the client we will accept any IP address- this is because we are going to route all traffic over this connection and will therefore need to accept everything we get back. Typically the wireguard client for mobile and desktop OSes has additional options to control what traffic is routed over the connection (e.g. local IP addresses are not routed). We will see this when we install and setup the client device next.

Once you're done exit vi and change persmissions on the file as before. But bear in mind we are likely to want to email the file to the desktop user next so they can use it to configure their client (Windows, MacOS, Android, iOS etc).

**Install and setup client device**

There are wireguard clients on the MacApp Store, Google Play Store and you can download installers from the [wireguard](https://www.wireguard.com/install/) site directly as well. Additionally Ubuntu now has VPN client configuration built-in from 23.04. I'm going to walk through the setup on Mac, but the same rules apply for other platforms.

**Open client and configure the connection**

Once the MacOS client is installed you can open it and it will offer a screen to import a tunnel from file:

![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEisW-_4ba9hvTe4oIHrAPjc1Fc7ePDoXnCTpSlbdbPpxr-0yeJJ4MAVvwf2H_H_Cb-c6AHsur9wnItd0KHIG00st-ce8r1kjLuRUWgyVHOEr9J3MqvYrUd-EfhO7fLc7Q-EzJrUX0pfmbNcKiYxucF1I_z-RjudgvDKLvrfeYsfe9JCtI3_MD9t/w448-h266/import.png)

As you can see I emailed the client.conf file we generated above and put it on the desktop. Once I clicked on the import from file button and selected the file no other action is required. The VPN tunnel is now configured and ready to activate and test.

![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgRbp0XNeaMQQYc340BjcyRkR29kVNGZBcHuS-W3PvE36B98JT6YAkzHhxBo32ls-Z_atWPQOQWIFUREO5uxILYq3PDqy30AP8bw_-2B-6YsTWrH0dOndceSRS6oc3dY1FwGVdzA7PT8QkCb_ydHKifH44TfswmAVakiYMSJCKkyWSdQBo3YQPt/w424-h324/imported.png)

Each client has slightly different features, for example the MacOS client has an on-demand option that will start a VPN whenever you are on wi-fi or ethernet as well as excluding private IP addresses from the connection. 

**Generating QR codes**

One last point on client configuration before we connect and test, for mobile devices it is generally possible to configure via a qrcode. To do this we need to install qrencode:

**$ apt install qrencode**

And to generate a QR code we can configure a mobile with we:

**$ qrencode -t ansiutf8 -r "client.conf"**

And we should see something like this, which you can point the mobile camera at during wireguard configuration:

[](https://blogger.googleusercontent.com/img/a/AVvXsEiX0dwO4vIGLkGU14zmKAdx5SMV0d2GrFkiR9AWEWsDgsIKzpEM8CLzmTu5mrmkaNFWjCMN1gYAjDsyb2sxHfHT-Tp-JEwYH8mCnxWCFOD2qOBcL8_59GBIK3Ob7w2Bw6-KT6C2rD374PRaicrwBMkVpkwT9pO9YhfyOuAl7-Y3EY1d6DdUaO8T=w561-h428)

## Step 5: Test Connection

Finally we can test the connection and see what gives- so before pressing activate or connect on the client, we should set up tcpdump to watch the traffic on our VPN. In this case its relatively straight foward for us, just watch everything on the wireguard network interface:

**$ tcpdump -i wg0**

Once we connect we should see lots of traffic going over the connection, if we see nothing then no connection has been made. You should see something like this:

**tcpdump: verbose output suppressed, use -v[v]... for full protocol decode**

**listening on wg0, link-type RAW (Raw IP), snapshot length 262144 bytes**

**15:38:50.803866 IP 10.20.10.4.60551 > dns.google.domain: 38426+ A? apple.com. (27)**

**15:38:50.803929 IP 10.20.10.4.50828 > dns.google.domain: 9554+ A? www.apple.com. (31)**

**15:38:50.803929 IP 10.20.10.4.52687 > dns.google.domain: 58057+ A? api.apple-cloudkit.com. (40)**

**15:38:50.803929 IP 10.20.10.4.60887 > dns.google.domain: 61897+ A? gateway.icloud.com. (36)**

**15:38:50.803929 IP 10.20.10.4.52561 > dns.google.domain: 64893+ Type65? 41-courier.push.apple.com. (43)**

**15:38:50.803929 IP 10.20.10.4.55106 > dns.google.domain: 65364+ A? 41-courier.push.apple.com. (43)**

**15:38:50.803929 IP 10.20.10.4.49730 > dns.google.domain: 47041+ A? 1-courier.sandbox.push.apple.com. (50)**

**15:38:50.803929 IP 10.20.10.4.62802 > dns.google.domain: 7850+ A? 1-courier.push.apple.com. (42)**

**15:38:50.804316 IP 10.20.10.4.51822 > dns.google.domain: 63184+ Type65? p118-fmfmobile.icloud.com. (43)**

**15:38:50.804317 IP 10.20.10.4.59572 > dns.google.domain: 62002+ A? p118-fmfmobile.icloud.com. (43)**

**15:38:50.808718 IP dns.google.domain > 10.20.10.4.60551: 38426 1/0/0 A 17.253.144.10 (43)**

**15:38:50.809010 IP dns.google.domain > 10.20.10.4.60887: 61897 2/0/0 CNAME gateway.fe.apple-dns.net., A 17.250.81.68 (90)**

and as a final check, we can use the wireguard utility to look at the status of all our connections:

**$ wg show**

You should see something like this:

**interface: wg0**

**public key: MQBiYHxAj7u8paj3L4w4uav3P/9YBPbaN4gkWn90SSs=**

**private key: (hidden)**

**listening port: 33333**

**peer: IXW+O1L0OXs3dIGk55wOUIjvcWlQthuO84XS+rNB5Ac=**

**endpoint: xx.xx.xx.xx:33333**

**allowed ips: 10.20.10.2/32**

**latest handshake: 6 minutes, 37 seconds ago**

**transfer: 8.46 MiB received, 426.76 MiB sent**

And with that, we're all done- you can go ahead and add more clients till you're done.
