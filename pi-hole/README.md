[back](../README.md)

# Pi-Hole

## Installation on Ubuntu/Debian
- Ensure apt is updated: `sudo apt update -y && sudo apt upgrade -y`
- intall via: `curl -sSL https://install.pi-hole.net | bash` 

## Twin Holes
Adguard was being flaky about responding to local DNS names set in pi.hole despite pi.hole being it's only upstream resolver...so I replaced it with second pi-hole. Kept in sync with [Gravity-sync](https://github.com/vmstan/gravity-sync)

I now run twin LXC containers, one on each PVE node and they're syncd. took as long as downloading the OS/Pi-hole as it did to get gravity-sync running. 