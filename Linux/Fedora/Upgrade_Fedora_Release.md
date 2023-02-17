# Upgrade Fedora Release
Pulled from: https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/

1.  To update your Fedora release from the command-line do:
    
    ```bash
    sudo dnf upgrade --refresh
    ```
    
    and reboot your computer.
    
    **Important:** Do not skip this step. System updates are required to receive signing keys of higher-versioned releases, and they often fix problems related to the upgrade process.
    
2.  Install the dnf-plugin-system-upgrade package if it is not currently installed:
    
    ```bash
    sudo dnf install dnf-plugin-system-upgrade
    ```
    
3.  Download the updated packages:
    
    ```bash
    sudo dnf system-upgrade download --releasever=36
    ```
    
    Change the `--releasever=` number if you want to upgrade to a different release. Most people will want to upgrade to the latest stable release, which is `36`, but in some cases, such as when you’re currently running an older release than `35`, you may want to upgrade just to Fedora `35`. System upgrade is only officially supported and tested over 2 releases at most (e.g. from `34` to `36`). If you need to upgrade over more releases, it is recommended to do it in several smaller steps ([read more](https://docs.fedoraproject.org/en-US/quick-docs/dnf-system-upgrade/#sect-how-many-releases-can-i-upgrade-across-at-once)).
    
    You can also use `37` to upgrade to a [Branched](https://fedoraproject.org/wiki/Releases/Branched) release, or `rawhide` to upgrade to [Rawhide](https://fedoraproject.org/wiki/Releases/Rawhide). Note that neither of these two are stable releases. For details about the upgrade process and common issues related to those two releases, please look at appropriate sections on aforelinked pages.
    
4.  If some of your packages have unsatisfied dependencies, the upgrade will refuse to continue until you run it again with an extra `--allowerasing` option. This often happens with packages installed from third-party repositories for which an updated repositories hasn’t been yet published. Study the output very carefully and examine which packages are going to be removed. None of them should be essential for system functionality, but some of them might be important for your productivity.
    
5.  When the new GPG key is imported, you are asked to verify the key’s fingerprint. Refer to [https://getfedora.org/security](https://getfedora.org/security) to do so.
    
    -   In case of unsatisfied dependencies, you can sometimes see more details if you add `--best` option to the command line.
        
    -   If you want to remove/install some packages manually before running `dnf system-upgrade download` again, it is advisable to perform those operations with `--setopt=keepcache=1` dnf command line option. Otherwise the whole package cache will be removed after your operation, and you will need to download all the packages once again.
        
    
6.  Trigger the upgrade process. This will reboot your machine (immediately!, without a countdown or confirmation, so close other programs and save your work) into the upgrade process running in a console terminal:
    
    ```bash
    sudo dnf system-upgrade reboot
    ```
    
7.  Once the upgrade process completes, your system will reboot a second time into the updated release version of Fedora.