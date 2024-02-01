# DMZ Demilitarized Zone

The point is that the internal firewall only allows specific traffic between DMZ servers and internal servers. If a DMZ server is compromised, it will only be able to contact (f.e.) one server on one TCP port, not any server on any service.

---

[From Spiceworks](https://community.spiceworks.com/topic/400484-so-i-ve-been-asked-to-set-up-a-dmz-but-allow-access-to-the-internal-network)

Having worked and helped design DMZ networks for companies that require high levels of security, and having worked side-by-side with Sr Security Officers with high government clearances, I have come to the following conclusions:

1) Users should never directly touch content serving web servers

2) publicly accessed servers should never have direct access to internal networks or systems

3) Web servers should never directly touch Database servers

How is this achieved?

1) Reverse proxy all incoming internet requests to your various web services (HTTP,HTTPS,FTP,Mail).  Keep reverse proxies on their own subnets, separate from other web server subnets.

2) Create a middle ground network that sits between your DMZ and Internal Networks.  This network will host your business and data layers for your web architecture, which will be given access to your backend DB servers.

3) Offload your business and data layers from your web servers to dedicated business data processing servers (such as JDBC for Apache, and WCF services for IIS).  Your web servers will contact these servers through a less benign protocol, such as HTTP or HTTPS, and the applications will be coded to make SQL/MySQL calls to your internal DB servers.

In most cases, the solutions I provided here are free Open Source software.  The only exception is the WCF service used as a business layer for ISS web servers.  Everything else is open source.

---

[From r/networking](https://www.reddit.com/r/networking/comments/3vl2ff/dmz_with_communication_back_to_lan/)

Depends on the protocol being used and what kind of safetylevel you much achieve in the segmentation/isolation of that LAN.

The most simple solution is that only the DMZ-server is allowed to do the inbound connection to a specific host on the LAN.

A better solution, but not always possible, is if the LAN host is in charge of when and how the data is being fetched from the DMZ.

Then how you will allow this traffic can occur at either the simpliest way of an ACL (srcip + srcport(range) + dstip + dstport must match) to NGFW (also appid must match) to proxybased firewall (the payload will be totally reconstructed according to the protocol being used) to datadiode (only oneway communication is possible).

There are several datadiodes available, just to mention a few:

https://www.fox-it.com/datadiode/

https://www.advenica.com/en/cds/securicds-data-diode

Also when it comes to datadioes there are the more "simple" ones (basically transform the needed traffic into a UDP stream which is then pushed over a oneway fiberlink (TX at one end and RX in the other)) to more advanced ones who basically is a proxy <-> datadiode <-> proxy setup in the same box which gives that you can "emulate" bidrectional flows (even if the flow actually is strictly one way over that oneway fiberlink).

> Where `datadiode` == guarantee that data can only physically be sent in one direction. Normally in to a sensitive network (but not leaving this sensitive network since the data you dont want to leave exists on this sensitive network). 