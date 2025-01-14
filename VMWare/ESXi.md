[back](./README.md)

# VMWare ESXi

## Overview

The core of the vSphere product suite is the hypervisor called ESXi. A hypervisor is a piece of software that creates and runs virtual machines. Hypervisors are divided into two groups:

    Type 1 hypervisors – also called bare metal hypervisors, Type 1 hypervisors run directly on the system hardware. A guest operating-system runs on another level above the hypervisor. VMware ESXi is a Type 1 hypervisor that runs on the host server hardware without an underlying operating system.
    Type 2 hypervisors – hypervisors that run within a conventional operating-system environment, and the host operating system provides I/O device support and memory management. Examples of Type 2 hypervisors are VMware Workstation and Oracle VirtualBox .

ESXi provides a virtualization layer that abstracts the CPU, storage, memory and networking resources of the physical host into multiple virtual machines. That means that applications running in virtual machines can access these resources without direct access to the underlying hardware. VMware refers to the hypervisor used by VMware ESXi as vmkernel. vmkernel receives requests from virtual machines for resources and presents the requests to the physical hardware.

ESXi is supported on Intel processors (Xeon and above) and AMD Opteron processors. ESXi includes a 64-bit VMkernel and hosts with 32-bit-only processors are not supported. However, both 32-bit and 64-bit guest operating systems are supported. ESXi supports up to 4,096 virtual processors per host, 320 logical CPUs per host, 512 virtual machines per host and up 4 TB of RAM per host.

ESXi can be installed on a hard disk, USB device, or SD card. It has an ultralight footprint of approximately 144 MB for increased security and reliability.

## Links

- [Installation & Configuration](./ESXi_Installation.md)