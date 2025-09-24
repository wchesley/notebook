[back](../README.md)
# Active Directory

Active Directory (AD) is a directory service developed by Microsoft that provides a centralized location for managing and organizing resources in a networked environment. It serves as a repository for storing information about user accounts, computers, groups, and other network resources.

Active Directory is designed to simplify network administration by providing a hierarchical structure and a set of services that enable administrators to manage user authentication, authorization, and access to resources efficiently.

## Links
- [DFS](./DFS-R.md)
- [Group Policy](./group_policy.md)
- [Scripts](./Scripts/README.md)


## Overview

A directory is a hierarchical structure that stores information about objects on a network. A directory service, such as Active Directory Domain Services (AD DS), provides the methods for storing directory data and making this data available to network users and administrators. For example, AD DS stores information about user accounts, such as names, passwords, phone numbers, and so on. AD DS also provides a way for authorized users on the same network to access this information.

AD DS stores information about objects on the network and makes this information easy for administrators and users to find and use. AD DS uses a structured data store as the basis for a logical, hierarchical organization of directory information.

This data store, also known as the directory, contains information about AD DS objects. These objects typically include shared resources such as servers, volumes, printers, and the network user and computer accounts. For more information about the AD DS data store, see [Directory data store](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc736627(v=ws.10)).

Security is integrated with AD DS through sign-in authentication and access control to objects in the directory. With a single network username and password, administrators can manage directory data and organization throughout their network, and authorized network users can access resources anywhere on the network. Policy-based administration eases the management of even the most complex network. For more information about AD DS security, see [Best practices for securing Active Directory](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/best-practices-for-securing-active-directory).

AD DS also includes:

-   A set of rules, the **schema**, that defines the classes of objects and attributes contained in the directory, the constraints and limits on instances of these objects, and the format of their names. For more information about the schema, see [Schema](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc756876(v=ws.10)).
    
-   A **global catalog** that contains information about every object in the directory. Users and administrators can use the catalog to find directory information regardless of the directory domain that actually contains the data. For more information about the global catalog, see [Global catalog](https://learn.microsoft.com/en-us/windows/win32/ad/global-catalog).
    
-   A **query and index mechanism**, so that objects and their properties can be published and found by network users or applications. For more information about querying the directory, see [Searching in Active Directory Domain Services](https://learn.microsoft.com/en-us/windows/win32/ad/searching-in-active-directory-domain-services).
    
-   A **replication service** that distributes directory data across a network. All domain controllers in a domain participate in replication and contain a complete copy of all directory information for their domain. Any change to directory data is replicated to all domain controllers in the domain. For more information about AD DS replication, see [Active Directory Replication Concepts](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/replication/active-directory-replication-concepts).