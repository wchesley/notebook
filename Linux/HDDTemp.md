# HDDTemp

Created: July 9, 2021 4:11 PM
Created By: Walker Chesley
Last Edited By: Walker Chesley
Last Edited Time: July 9, 2021 4:12 PM

Ran into a weird bug that I don't recall seeing before when deploying HDDTemp onto the new proxmox server. 
Fixed it with the following: 

vi /etc/default/hddtemp

# hddtemp network daemon switch. If set to true, hddtemp will listen for incoming connections.

set RUN_DAEMON="false" => RUN_DAEMON="true"
:wq

then 'service hddtemp restart/start'
it works on my ubuntu 16.04 laptop

pulled from: [https://github.com/brndnmtthws/conky/issues/57](https://github.com/brndnmtthws/conky/issues/57)