# Kill Stuck VM or LXC

#### You will need: 

* VMID (Virtual Machine ID) of stuck VM or LXC. 
  * This is the series of number next to the VM or LXC name in Web UI. 

Sometimes VMs or LXC's get stuck, mostly they can be killed with stop in the Web UI, but sometimes things get stuck and stop won't do the trick. 

* SSH into Proxmox host
* Find the VM by it's ID
  * `ps aux | grep "/usr/bin/kvm -id VMID"`
* Once we find the PID we kill the process using the command.
  * `kill -9 PID`