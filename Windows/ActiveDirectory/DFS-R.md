[back](./README.md)
# Distributed File System (DFS)

<sub>From <a href="https://learn.microsoft.com/en-us/windows/win32/dfs/distributed-file-system-dfs-functions">Microsoft</a></sub>

The Distributed File System (DFS) functions provide the ability to logically group shares on multiple servers and to transparently link shares into a single hierarchical namespace. DFS organizes shared resources on a network in a treelike structure.

DFS supports stand-alone DFS namespaces, those with one host server, and domain-based namespaces that have multiple host servers and high availability. The DFS topology data for domain-based namespaces is stored in Active Directory. The data includes the DFS root, DFS links, and DFS targets.

Each DFS tree structure has one or more root targets. The root target is a host server that runs the DFS service. A DFS tree structure can contain one or more DFS links. Each DFS link points to one or more shared folders on the network. You can add, modify and delete DFS links from a DFS namespace. When you remove the last target associated with a DFS link, DFS deletes the DFS link in the DFS namespace. (In earlier documentation, DFS links were called junction points.)

A DFS link can point to one or more shared folders; the folders are called targets. When users access a DFS link, the DFS server selects a set of targets based on a client's site information. The client accesses the first available target in the set. This helps to distribute client requests across the possible targets and can provide continued accessibility for users even when some servers fail.

An application can use the DFS functions to:

    Add a DFS link to a DFS root.
    Create or remove stand-alone and domain-based DFS namespaces.
    Add targets to an existing DFS link.
    Remove a DFS link from a DFS root.
    Remove a target from a DFS link.
    View and configure information about DFS roots and links.

For a list of the DFS functions, see Distributed File System Functions.

For a list of the DFS structures, see Distributed File System Structures.

Targets on computers that are running Microsoft Windows can be published in a DFS namespace. You can also publish any non-Microsoft shares for which client redirectors are available in a DFS namespace. However, unlike a share that is published on a server that is running Windows Server, they cannot host a DFS root or provide referrals to other DFS targets.

DFS uses the Windows Server file replication service to copy changes between replicated targets. Users can modify files stored on one target, and the file replication service propagates the changes to the other designated targets. The service preserves the most recent change to a document or files.

## Setup

<sub>From <a href="https://www.reddit.com/r/sysadmin/comments/3somms/wrote_a_quick_and_dirty_guide_on_dfsr_for_my/">Reddit</a></sub>

This guide is for Windows Server 2012 and R2, but the same basic steps will work on 2008 and 2008 R2 and even SBS.

1.  From Server Manager, add Roles and Features. The Role you want is under File and Storage Services → File and iSCSI Services → DFS Replication. It will also pull the DFS Management Tools as a pre-requisite. Install it. This should not require a restart.
    
2.  Run DFS Management from Administrative Tools.
    
3.  From the DFS Management display, choose New Replication Group.
    
4.  The Replication Group type may vary depending on your use case, but this guide will choose Multipurpose.
    
5.  Name the group and verify all servers involved are in the domain.
    
6.  Add your servers to the replication group. Note there can be more than two servers involved.
    
7.  Choose Full Mesh unless you're doing something sneaky with one-way replication. It's a good idea on paper but buggy in practice.
    
8.  The replication interval can be left at continuous unless there's a compelling reason to schedule it. The initial file copy will use full bandwidth regardless so unless you're constantly dealing with massive files there's little overhead in choosing continuous replication.
    
9.  Choose the server that has the files you need copied to the other members as the Primary member. This is a meaningless distinction after the initial replication is done.
    
10.  The Folders to Replicate section is obviously the most important part to this. Consider having a folder on the new server like Server Shares with the individual shares inside if you're moving away from an old server. They do not have to have the same folder structure on both ends. When you think you're done, verify all the available shares on the primary server and that they're all either included in the replication scope or not needed.
    
11.  You will have to set the local path for each share individually. Note that if you are using a Server Shares folder, you will need to manually specify the subfolder to be used. Aiming them all at C:\\Server Shares\\ won't work. If you choose to make it read-only, you are essentially creating one-way replication. If you ever forget about this it will drive you insane trying to fix it so leave it off without an exceptionally good reason.
    
12.  Review the settings. Note that NTFS Permissions will be copied over, but sharing permissions will not. These replicated folders will not be shared until you do it manually. This could be used to your advantage in the right scenario. Hit Create when everything looks good.
    
13.  If any of the shares are larger than 4GB, you may not be done. There is a staging quota of 4GB by default on each replicating folder, and if that quota is exceeded you will see excessive disk time, and slower copying time. The rule of thumb is the staging quota should be equal to or greater than the combined size of the 32 largest files on the primary member's folder. If you need to increase the staging quota size, you can go to your new Replication group under Replication, choose the primary member's folder, right click it and go to Properties. Under Staging, you can increase the quota.
    
14.  Check the Event log periodically as it will alert you if the quota is underprovisioned. (Applications and Services Log → DFS Replication)
    
15.  If you're done with replication, e.g., you were using it for data migration, you need to disable the connection. If you simply empty the shares on one server, DFS will sync the delete to the partner servers. Under the replication group, go to Connections, choose the servers you wish to disable, and choose Disable from the action bar.
    
## Namespaces

DFS (Distributed File System) Namespaces is a role service in Windows Server that enables you to group shared folders located on different servers into one or more logically structured namespaces. This makes it possible to give users a virtual view of shared folders, where a single path leads to files located on multiple servers.

1. Launch DFS management console
2. Right click on `Namespaces` and select `New Namespace` to launch the creation wizard
   1. Select the PC that is the master host of the files.  
   2. Name your namespace: The name is arbitrary, however should be named after the function or purpose of the namespace.
   3. If your files/folders already exist and just need to be added to the namespace, select `Edit Settings` on the `Namespace Name and Settings` step of the wizard. Change the `Local path of shared folder` to your file share directory. You do **not** have to set `Shared folder permissions` in this case as DFS will detect the existing permissions and use them instead. 
   4. Proceed to select the Namespace type, typically left at default value. 
3. Once `Namespace` has been created, right click on it and select `New Folder`. This folder serve as the place holder for shares in the Namespace. 
4. Add your remote and local share directories to the Namespace folder. 
   1. You can optionally setup replicaiton here, if it's not already set up then you should set it up now. If replication was setup before the Namespace was created, the namespace will complain that it is not being replicated however, when you try to set up replication for the Namespace it will fail because the directory is already apart of a replication group. 
5. Note the new path for the Namespace share. In the format of `\\domain.co\Namespace\Folder`.
6. Update GPO's, scripts and documentation to use this new share address. When using this share, DFS will automatically select the file share with the best connection to the user. 

## Commands

This command shows retrieves pending updates between two computers that participate in DFS-R file replication service. 

```ps1
PS C:\> Get-DfsrBacklog -SourceComputerName "MyServer" -GroupName "G01" -FolderName "Folder"

Identifier                  : {DCE7FC28-5584-4D5D-BC84-2BD9D53CC5FC}-v538
Flags                       : 5
Attributes                  : 32
GlobalVersionSequenceNumber : {DCE7FC28-5584-4D5D-BC84-2BD9D53CC5FC}-v538
UpdateSequenceNumber        : 71575496
ParentId                    : {997D8F76-1207-49D7-85C9-DED015105A2F}-v1
FileId                      : 562949953495210
Volume                      : \\.\C:
Fence                       : 3
Clock                       : 130078672846368199
CreateTime                  : 3/15/2013 5:28:04 PM
UpdateTime                  : 3/15/2013 5:28:04 PM
FileHash                    : 173b51c11257a2eb 8c05884560fcfd1d
FileName                    : file.exe
FullPathName                : c:\folder\file.exe
Index                       : 1
ReplicatedFolderName        : folder
Replicated Folder Id        : 997d8f76-1207-49d7-85c9-ded015105a2f
```

#### **2\. Get-DfsrState:**

This command shows you the current replication state of DFS-R in regard to its DFS replication group partners.  

```ps1
PS C:\> Get-DfsrState -ComputerName "Server" | Format-Table FileName,UpdateState,Inbound,Source* -Auto -Wrap

FileName                   UpdateState Inbound SourceComputerName
--------                   ----------- ------- ------------------
ntfrs - Copy.exe             Scheduled    True SRV02
ntdsai - Copy.dll            Scheduled    True SRV02
NlsLexicons0046 - Copy.dll   Scheduled    True SRV02
NlsLexicons000a - Copy.dll Downloading    True SRV02
occache - Copy.dll           Scheduled    True SRV02
NlsModels0011 - Copy.dll     Scheduled    True SRV02
NlsLexicons0007 - Copy.dll   Scheduled    True SRV02
NlsLexicons000f - Copy.dll Downloading    True SRV02
NlsLexicons003e - Copy.dll   Scheduled    True SRV02
NlsLexicons0045 - Copy.dll   Scheduled    True SRV02
NlsData001a - Copy.dll     Downloading    True SRV02
ntlanui2 - Copy.dll          Scheduled    True SRV02
```
