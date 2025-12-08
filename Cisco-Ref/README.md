<sub>[back](../README.md)</sub>

# Cisco

[Cisco Commands Cheat Sheet](https://www.netwrix.com/cisco_commands_cheat_sheet.html)

[Commands list](./Page-3.md)

[SIP](./SIP.md)

## Snippits

### View all MAC addresses

View all MAC addresses: `show mac address-table`

`grep`\\`findstr` equivalent: `include` ie. `show mac address-table | include cc8.bb3`

### Chain Commands: Bounce port

Commands can be chained together with `;` separating each command: 

`enable; config t; int gi1/0/14; shut; sleep 5; no shut; end;`

Where the sleep command will pause execution to allow the port to fully shut and then come back online. 