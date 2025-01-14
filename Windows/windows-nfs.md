[back](./README.md)

# Windows NFS
Complete the following steps for _Windows 10 Enterprise_

1.  Open **Start > Control Panel > Programs**.
2.  Select **Turn Windows features on or off**.
3.  Select **Services for NFS**.
4.  Click **OK**.
5.  Enable write permissions for the anonymous user as the default options only grant read permissions when mounting a UNIX share using the anonymous user.
    
    To grant write permissions, make a change to the Windows registry by performing the following steps:
    
    1.  Open `regedit` by typing it in the search box and pressing **Enter**.
    2.  Create a new **New DWORD (32-bit) Value** inside the `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ClientForNFS\CurrentVersion\Default` folder named `AnonymousUid` and `AnonymousGid` and assign the UID and GID found on the UNIX directory as shared by the NFS system.
    
6.  Restart the NFS client or reboot the machine to apply the changes.
7.  Mount the cluster and map it to a drive using the Map Network Drive tool or from the command line.
    
    ```
    mount -o anon <server_ip>:/path/to/shared/folder Z:
    ```