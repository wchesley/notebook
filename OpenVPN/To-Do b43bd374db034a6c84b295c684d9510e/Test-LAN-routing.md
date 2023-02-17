# Test LAN routing

Assign: Walker Chesley
Date Created: June 21, 2021 2:00 PM
Status: Completed

- [x]  Remove modem routing - Test LAN connectivity
- [x]  Remove IP forwarding - Test LAN connectivity
- [x]  Remove server push route config - Test LAN connectivity
- [ ]  

# Conclusion!

Routed subnet was NOT the way to go! per arris: 

Routed Subnet mode configuration provides the ability to attach public 
IP addressed hosts to the internal LAN ports of the Motorola ADSL 
gateway. These hosts are directly accessible from the Internet. This 
configuration disable NAT, and all hosts attached to the gateway will be
 fully exposed to the Internet. The ideal setup is:

- adding firewall, router or another NAT device to manage your internal network.
- hosting services or applications that can benefit from being directly accessible through the Internet.

IP Forwarding was removed on my laptop somehow? Need to see about making that sticky? Without this I couldn't access the VPN. 

Adjusted Server config, re-enabled `server 10.8.0.0 255.255.255.0` then moved the `push "route 192.168.0.0 255.255.255.0` line to just after it. Figured we should see the vpn 'gateway' before being pushed the LAN route. 

## WORKING SETUP:

enable IP Forwarding on CLIENT: 

- Check if enabled or not (0 is off 1 is on):
    - `sysctl -w net.ipv4.ip_forward`
- if off (0) turn on with: (might need sudo)
    - `sysctl -w net.ipv4.ip_forward=1`

Ensure LAN route is pushed to CLIENTS, in the SERVER's server.conf add this line

`push "route 192.168.0.0 255.255.255.0`