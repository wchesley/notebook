[back](./README.md)
# Group Policy

Group Policy enables configuration and settings management of user and computer settings on computers running Windows Server and Windows Client operating systems. In addition to using Group Policy to define configurations for groups of users and client computers, you can also use Group Policy to help manage server computers, by configuring many server-specific operational and security settings.


## What is a Group Policy

Group policy can represent policy settings in the locally in the file system or in Active Directory Domain Services. When used with Active Directory, Group Policy settings are contained in a Group Policy Object (GPO). A GPO is a virtual collection of policy settings, security permissions, and scope of management (SOM) that you can apply to users and computers in Active Directory. A GPO has a unique name, such as a GUID. Clients evaluate GPO settings using the hierarchical nature of Active Directory.

Policy settings are divided into policy settings that affect a computer and policy settings that affect a user. Computer-related policies specify system behavior, application settings, security settings, assigned applications, and computer startup and shutdown scripts. User-related policies specify system behavior, application settings, security settings, assigned and published applications, user logon and logoff scripts, and folder redirection. Computer settings override user-related settings.

To create Group Policy, an administrator can use the Local Group Policy Editor (`gpedit.msc`), which can be a stand-alone tool and the settings stored locally. We recommend that you use the Group Policy Object Editor as an extension to an Active Directory-related MMC snap-in. The Group Policy Object Editor allows you to link GPOs to selected Active Directory sites, domains, and organizational units (OUs). Linking applies the policy settings in the GPO to the users and computers in those Active Directory objects. GPOs are stored in both Active Directory and in the SYSVOL folder on each domain controller.

[](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview#how-group-policy-works)

## How Group Policy works

For computers, Group Policy is applied when the computer starts. For users, Group Policy is applied at sign in. This initial processing of policy can also be referred to as a foreground policy application.

The foreground application of Group Policy can be synchronous or asynchronous. In synchronous mode, the computer doesn't complete the system start until computer policy is applied successfully. The user logon process doesn't complete until user policy is applied successfully. In asynchronous mode, if there are no policy changes that require synchronous processing, the computer can complete the start sequence before the application of computer policy is complete. The shell can be available to the user before the application of user policy is complete. The system then periodically applies (refreshes) Group Policy in the background. During a refresh, policy settings are applied asynchronously.

To learn more about how Group Policies work, see [Group Policy Processing](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-processing).

[](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview#what-is-an-organizational-unit-ou)

## What is an Organizational Unit (OU)

An OU is the lowest-level Active Directory container to which you can assign Group Policy settings. Typically, you assign most GPOs at the OU level, so make sure that your OU structure supports your Group Policy-based client-management strategy. You might also apply some Group Policy settings at the domain level, particularly password policies. Few policy settings are applied at the site level. A well-designed OU structure that reflects the administrative structure of your organization and takes advantage of GPO inheritance simplifies the application of Group Policy. For example, a well-designed OU structure can prevent duplicating certain GPOs so that you can apply these GPOs to different parts of the organization. If possible, create OUs to delegate administrative authority and to help implement Group Policy.

OU design requires balancing requirements for delegating administrative rights independent of Group Policy needs, and the need to scope the application of Group Policy. You can create OUs within a domain and delegate administrative control for specific OUs to particular users or groups. By using a structure in which OUs contain homogeneous objects, such as either user or computer objects but not both, you can easily disable those sections of a GPO that don't apply to a particular type of object. This approach to OU design reduces complexity and improves the speed at which Group Policy is applied. GPOs linked to the higher layers of the OU structure are inherited by default for OUs at the lower layer, reducing the need to duplicate GPOs or to link a GPO to multiple containers.

# Guides 

## How to determine which Group Policies have been applied to a Windows PC for a particular user

<sub>From <a href="https://portal.microfocus.com/s/article/KM000012465?language=en_US">Microfocus</a></br>also see: <a href="https://serverfault.com/questions/883244/gpresult-error-the-user-does-not-have-rsop-data-fails-as-domain-admin">Serverfault</a></sub>

This technical article provides some basic steps to use to determine which Group Policies have been applied to a Windows PC for a particular user.

#### Situation

How to determine which Group Policies have been applied to a Windows PC for a particular user.

#### Resolution

### Capture information

1\. Open an elevated Command Prompt.   (Requires Administrator Rights on the PC system)  
  
2\. Navigate to the users My Documents folder  
    (typically C:\\Users\\<username>\\Documents).  
  
3\. Type the command  “gpresult /H GPReport.html” and press the ENTER key.  
    (where GPReport.html is the name of the output file)   
  
4\. Open the generated html file in a web browser.  
  
5\. You can see both the local and domain applied GPOs.  
    (press the “show” button to get some further details)  
  
6\. Note the name and location of the applied Group Policy Objects.

###   
View Group Policy Details

1\. Remote Desktop into the appropriate Domain controller    
    (this requires Domain Admin rights which a typical user will not have).  
  
2\. Go to the Windows Control Panel.  
  
3\. Open Administrative Tools.  
  
4\. Select Group Policy Management.  
  
5\. Using the information gathered in step 6 above, examine the policies that are applied to the user.  
    Select the “Settings” tab to see the Group Policies defined.  
    (expand the settings and click on the “show” buttons to see details of the specific Policies)

### Alternate

Using server fault answer: 

es, it can be done without doing a interactive login, although you need to know a user that has actually done an interactive login on that computer. In your case, UserA would do it. Then, from an elevated prompt:

    gpresult /user UserA /scope computer /r
    

Also, from a remote computer:

    gpresult /s RemoteComputer /user UserA /scope computer /r
    

I really don't get why you need to specify a user when using `/scope computer`, but this is how it works...


#### Additional Information

Additional information about the gpresult command:

[https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/gpresult](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/gpresult)

