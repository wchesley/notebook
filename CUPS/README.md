# CUPS Printing Server
* [Cups Docs](ttp://www.cups.org/documentation.html)
* [RHEL CUPS setup and config guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_using_a_cups_printing_server/configuring-printing_configuring-and-using-a-cups-printing-server)
* [Canon D1300 Driver Downloads Page](https://www.usa.canon.com/support/p/imageclass-d1320)

I run with a Canon D1300 image class printer, hosts will need it's driver installed inorder to print with it. There is an ansible playbook setup to handle this that already has the driver with it. 

Printer is at 192.168.0.90
CUPS Server is at 192.168.0.91:631
* Ubuntu 22.04 LXC hosts the CUPS server. 