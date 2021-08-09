# IP Forwarding

Created: June 29, 2021 9:44 AM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: June 29, 2021 9:45 AM

[](https://linuxconfig.org/how-to-turn-on-off-ip-forwarding-in-linux)

Check if IP Forwarding is enabled (1) or disabled (0)
`sysctl net.ipv4.ip_forward`

Enable IP Forwarding: 

`sysctl -w net.ipv4.ip_forward=1`

Disable IP Forwarding: 

`sysctl -w net.ipv4.ip_forward=0`