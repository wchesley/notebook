# Boot the System - Linux

Ref: [LPIC-1 v5, Exam 101, Objective 101.2](https://wiki.lpi.org/wiki/LPIC-1_Objectives_V5.0#101.2_Boot_the_system) 
Topic: 101 System Architecture  
Weight: 3  
Objective: 101.2 Boot the System  
**Key Knowledge Areas:**
- Provide common commmands to the boot loader and options to the kernal at boot time
- Demonstrate knowledge of the boot sequence from BIOS/UEFI to boot completion. 
- Understanding of SysVinit and systemd. 
  - Awareness of Upstart
- Check boot events in the log files
  
**Partial list of the used files, terms and utilities:** 

- dmesg
- journalctl
- BIOS
- UEFI
- bootloader
- kernal
- initramfs
- init
- SysVinit
- systemd
---
# Table of Contents: 
- [Boot the System - Linux](#boot-the-system---linux)
- [Table of Contents:](#table-of-contents)
- [Summary](#summary)
- [Introduction](#introduction)
  - [BIOS or UEFI](#bios-or-uefi)
    - [BIOS](#bios)
    - [UEFI](#uefi)
  - [Bootloader](#bootloader)
  - [System Initialization](#system-initialization)
  - [Initialization Inspection](#initialization-inspection)
- [Guided Exercises](#guided-exercises)
  - [Explorational Exercises:](#explorational-exercises)


# Summary

This lesson covers the boot sequence in a standard Linux system. Proper knowledge of how the boot process of a Linux system works helps prevent errors that can make the system inaccessible. The lesson goes through the following topic areas:  
• How BIOS and UEFI boot methods differ.  
• Typical system initialization stages.  
• Recovering boot messages.  
The commands and procedures addressed are:  
• Common kernel parameters.  
• Commands to read boot messages: `dmesg` and `journalctl`.  

# Introduction

In order to control the machine, the operating system’s main component — the kernel — must be loaded by a program called a bootloader, which itself is loaded by a pre-installed firmware such as BIOS or UEFI. The bootloader can be customized to pass parameters to the kernel, such as which partition contains the root filesystem or in which mode the operating system should execute. Once loaded the kernel continues the boot process identifying and configuring the hardware. Lastly, the kernel calls the utility responsible for starting and managing the system’s services

## BIOS or UEFI

### BIOS 

The **BIOS**, short for *Basic Input/Output System*, is a program stored in a non-volatile memory chip attached to the motherboard, executed every time the computer is powered on. This type of program is called *firmware* and its storage location is separate from the other storage devices the system may have. The BIOS assumes that the first 440 bytes in the first storage device — following the order defined in the BIOS configuration utility — are the first stage of the
bootloader (also called bootstrap). The first 512 bytes of a storage device are named the **MBR** (Master Boot Record) of storage devices using the standard DOS partition schema and, in addition
to the first stage of the bootloader, contain the partition table. If the MBR does not contain the correct data, the system will not be able to boot, unless an alternative method is employed. 

Generally speaking, the pre-operating steps to boot a system equipped with BIOS are:
1. The **POST** (power-on self-test) process is executed to identify simple hardware failures as soon
as the machine is powered on.
2. The **BIOS** activates the basic components to load the system, like video output, keyboard and
storage media.
3. The **BIOS** loads the first stage of the *bootloader* from the MBR (the first 440 bytes of the first
device, as defined in the **BIOS** configuration utility).
4. The first stage of the *bootloader* calls the second stage of the *bootloader*, responsible for presenting boot options and loading the kernel.

### UEFI

The UEFI, short for *Unified Extensible Firmware Interface*, differs from BIOS in some key points. As the BIOS, the UEFI is also a *firmware*, but it can identify partitions and read many filesystems found in them. The UEFI does not rely on the MBR, taking into account only the settings stored in its non-volatile memory (NVRAM) attached to the motherboard. These definitions indicate the
location of the UEFI compatible programs, called EFI applications, that will be executed automatically or called from a boot menu. EFI applications can be bootloaders, operating system selectors, tools for system diagnostics and repair, etc. They must be in a conventional storage device partition and in a compatible filesystem. The standard compatible filesystems are FAT12, FAT16 and FAT32 for block devices and ISO-9660 for optical media. This approach allows for the implementation of much more sophisticated tools than those possible with BIOS.

The partition containing the EFI applications is called the *EFI System Partition* or just ESP. This partition must not be shared with other system filesystems, like the root filesystem or user data filesystems. The EFI directory in the ESP partition contains the applications pointed to by the entries saved in the NVRAM.

Generally speaking, the pre-operating system boot steps on a system with UEFI are:
1. The POST (power-on self-test) process is executed to identify simple hardware failures as soon
2. The UEFI activates the basic components to load the system, like video output, keyboard and
storage media.
3. UEFI’s firmware reads the definitions stored in NVRAM to execute the pre-defined EFI
application stored in the ESP partition’s filesystem. Usually, the pre-defined EFI application is a
bootloader.
4. If the pre-defined EFI application is a bootloader, it will load the kernel to start the operating
system.

The UEFI standard also supports a feature called *Secure Boot*, which only allows the execution of signed EFI applications, that is, EFI applications authorized by the hardware manufacturer. This feature increases the protection against malicious software, but can make it difficult to install operating systems not covered by the manufacturer’s warranty.

## Bootloader

The most popular bootloader for Linux in the x86 architecture is GRUB (*Grand Unified Bootloader*). As soon as it is called by the BIOS or by the UEFI, GRUB displays a list of operating systems available to boot. Sometimes the list does not appear automatically, but it can be invoked by pressing `Shift` while GRUB is being called by BIOS. In UEFI systems, the `Esc` key should be used instead.


From the GRUB menu it is possible to choose which one of the installed kernels should be loaded and to pass new parameters to it. Most kernel parameters follow the pattern option=value. Some of the most useful kernel parameters are:  

**acpi**  
Enables/disables ACPI support. acpi=off will disable support for ACPI.  
**init**  
Sets an alternative system initiator. For example, `init=/bin/bash` will set the Bash shell as the initiator. This means that a shell session will start just after the kernel boot process.  
**systemd.unit**  
Sets the *systemd* target to be activated. For example, systemd.unit=graphical.target. Systemd also accepts the numerical runlevels as defined for SysV. To activate the runlevel 1, for example, it is only necessary to include the number 1 or the letter S (short for “single”) as a kernel parameter.  
**mem**  
Sets the amount of available RAM for the system. This parameter is useful for virtual machines so as to limit how much RAM will be available to each guest. Using `mem=512M` will limit to 512 megabytes the amount of available RAM to a particular guest system.  
**maxcpus**  
Limits the number of processors (or processor cores) visible to the system in symmetric multi-processor machines. It is also useful for virtual machines. A value of `0` turns off the support for multi-processor machines and has the same effect as the kernel parameter nosmp. The parameter `maxcpus=2` will limit the number of processors available to the operating system to two.  
**quiet**  
Hides most boot messages.  
**vga**  
Selects a video mode. The parameter `vga=ask` will show a list of the available modes to choose from.  
**root**  
Sets the root partition, distinct from the one pre-configured in the bootloader. For example, `root=/dev/sda3`.  
**rootflags**  
Mount options for the root filesystem.  
**ro**  
Makes the initial mount of the root filesystem read-only.  
**rw**  
Allows writing in the root filesystem during initial mount.  

Changing the kernel parameters is not usually required, but it can be useful to detect and solve operating system related problems. Kernel parameters must be added to the file `/etc/default/grub` in the line `GRUB_CMDLINE_LINUX` to make them persistent across reboots. A new configuration file for the bootloader must be generated every time `/etc/default/grub` changes, which is accomplished by the command `grub-mkconfig -o /boot/grub/grub.cfg`. Once the operating system is running, the kernel parameters used for loading the current session are available for reading in the file /proc/cmdline.

## System Initialization

Apart from the kernal, the operatin system depends on other components that provide the expected features. Many of these components are loaded during the system initialization process, varrying from simple shell scripts to more complex service programs. Services, aka *daemons*, may be active all the time as they can be responsible for intrinsic aspects of the operating system, ie. networking.service. Scripts are one off and short lived, begin and end during system init process. 

> Strictly speaking, the operating system is just the kernel and its components which control the hardware and manages all processes. It is common, however, to use the term “operating system” more loosely, to designate an entire group of distinct programs that make up the software environment where the user can perform the basic computational tasks.

It is also convenient for a system administrator to be able to activate a particular set of daemons, depending on the circumstances. It should be possible, for example, to run just a minimum set of services in order to perform system maintenance tasks, or run a more secure environment. 

The initialization of the OS starts when the bootloader loads the kernal into RAM. Then, the kernal will take charge of the CPU and will start to detect and setup fundamental aspects of the OS, like basic hardware configuration and memory addressing. 

The Kernal will then open the *initramfs (Initial RAM filesystem)*. The initramfs is an archive containing a filesystem used as a temporary root filesystem during the boot process. The main purpose of an initramfs file is to provide the required modules so the kernal can access the "real" root filesystem of the OS. 

As soon as the root filesystem is available, the kernal will mount all filesystems configured in `/etc/fstab` and then will execute the first program, a utility named `init`. The `init` program is responsible for running all initialization scripts and system daemons. There are distinct implementations of such system initiators apart from the traditional `init`, like `systemd` and `Upstart`. Once the init program is loaded the initramfs is removed from RAM. 

**SysV standard**  
A service manager based on the SysVinit standard controls which daemons and resources will be available by employing the concept of *runlevels*. Runlevels are numbered `0` to `6` and are designed by the distribution maintainers to fulfill specific purposes. The only runlevel definitions shared between all distributions are the runlevels `0`, `1` and `6`

**systemd**  
systemd is a modern system and services manager with a compatibility layer for the SysV commands and runlevels. systemd has a concurrent structure, employs sockets and D-Bus for service activation, on-demand daemon execution, process monitoring with cgroups, snapshot support, system session recovery, mount point control and a dependency-based service control. In recent years most major Linux distributions have gradually adopted systemd as their default system manager.

**Upstart**  
Upstart was used by Ubuntu and tried to speed up boot process through parallelizing the loading process of system services, Ubuntu gave way to systemd instead. 

## Initialization Inspection

Errors can occur during the boot process, but they might not be critical enought to stop the boot process. Notwithstanding, these errors may compromise the exected behaviour of the system. All errors result in messages that can be used for future investigations, as they contain valuable information about how and when they ocured. Even with no error messages, the info generated from boot process can be useful for tuning and configuration purposes. 

The memory space where the kernal stores its messages, including boot messages, is called the *kernal ring buffer*. The messages are kept in the kernal ring buffer even when they are not displayed during the initialization process, ie when an animation is shown instead. Kernal ring buffer will lose all messages when the system is turned off or by executing the command `dmesg --clear`. Without options, command `dmesg` displays the current messages in the kernal ring buffer. 

```bash
$ dmesg
[ 5.262389] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[ 5.449712] ip_tables: (C) 2000-2006 Netfilter Core Team
[ 5.460286] systemd[1]: systemd 237 running in system mode.
[ 5.480138] systemd[1]: Detected architecture x86-64.
[ 5.481767] systemd[1]: Set hostname to <torre>.
[ 5.636607] systemd[1]: Reached target User and Group Name Lookups.
[ 5.636866] systemd[1]: Created slice System Slice.
[ 5.637000] systemd[1]: Listening on Journal Audit Socket.
[ 5.637085] systemd[1]: Listening on Journal Socket.
[ 5.637827] systemd[1]: Mounting POSIX Message Queue File System...
[ 5.638639] systemd[1]: Started Read required files in advance.
[ 5.641661] systemd[1]: Starting Load Kernel Modules...
[ 5.661672] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[ 5.694322] lp: driver loaded but no devices found
[ 5.702609] ppdev: user-space parallel port driver
[ 5.705384] parport_pc 00:02: reported by Plug and Play ACPI
[ 5.705468] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[ 5.800146] lp0: using parport0 (interrupt-driven).
[ 5.897421] systemd-journald[352]: Received request to flush runtime journal from PID 1
```

This is a truncated example as `dmesg` is often hundredes of lines long. the numeric values at the beginning of each line are the amount of seconds relative to when kernal load begins. 

In systems based on systemd, command `journalctl` will show the initialization messages with options `-b, --boot, -k` or `--dmesg`. Command `journal --list-boots` shows a list of boot number relative to the current boot, their ID hash and timestamps of first, and last corresponding messages. Command `journalctl -xeu postfix` will display all messages related to the service `postfix` since the current boot. 

In all operating systems, everything is a file. Error and log files by convention are stored in `/var/log`. Since `systemd`'s logs aren't plain text, `journalctl` is required to read them. Options `-D` or `--directory` of command `journalctl` can be used to read log messages in directories other than `var/log/journal`. Which is default systemd log messager location. 

# Guided Exercises

1. On a machine equipped with a BIOS firmware, where is the bootstrap binary located?
   1. Within the first 440 bytes of the first storage device selected in the BIOS configuration. 
2. UEFI firmware supports extended features provided by external programs, called EFI applications. These applications, however, have their own special location. Where on the system would the EFI aplications be located? 
   1. Within the defined `ESP` directory. 
3. Bootloaders allow the passing of custom kernal parameters before loading it. Suppose the system is unable to boot due to a misinformed root filesystem location. How would the correct root filesystem, located at `/dev/sda3`, be given as a paramter to the kernal? 
   1. set the parameter as `root=/dev/sda3` in the grub configuration. 
4. The boot process of a Linux machine ends up with the following message:  
`ALERT! /dev/sda3 does not exist. Dropping to a shell!`  
What is the likely cause of this problem?  

    1. The drive `/dev/sda` either doesn't exist itself, or `/dev/sda3` does not exist within the disk. 

## Explorational Exercises: 

1. The bootloader will present a list of operating systems to choose from when more than one operating system is installed on the machine. However, a newly installed operating system can overwrite the MBR of the hard disk, erasing the first stage of the bootloader and making the other operating system inaccessible. Why would this not happen on a machine equipped with a UEFI firmware?
   1. UEFI firmware does not rely on, or use a `MBR` when calling the bootloader.
2. What is a common consequence of installing a custom kernel without providing an appropriate initramfs image?
   1. The bootloader will fail to boot the system and either display an error message or drop to a shell. 
3. The initialization log is hundreds of lines long, so the output of dmesg command is often piped to a pager command — like command less — to facilitate the reading. What dmesg option will automatically paginate its output, eliminating the need to use a pager command explicitly?
   1. `-H` or `--human` will call the pager. 
4. A hard drive containing the entire filesystem of an offline machine was removed and attached to a working machine as a secondary drive. Assuming its mount point is `/mnt/hd`, how would `journalctl` be used to inspect the contents of the journal files located at `/mnt/hd/var/log/journal/`?
   1. the command `journalctl -D /mnt/hd/var/log/journal` will read the log files from the second disk.



---
[back](./README.md)

