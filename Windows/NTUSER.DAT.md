<sub>[Back](./README.md)</sub>

# NTUSER.DAT

What is NTUSER.DAT?

NTUSER.DAT is a user-specific registry hive that stores configuration information, application settings, and user behavior artifacts. It is essentially a snapshot of a user’s environment and activities.

File Location and Lifecycle:

    Found at:
        C:\Users\[Username]\NTUSER.DAT
            Normal Windows user accounts.
         C:\Windows\ServiceProfiles\*\NTUSER.DAT
            Service accounts like Local Service, Network Service, and virtual service accounts.
        C:Windows\System32\config\DEFAULT
            System account (S-1-5-18)
            HKU\S-1-5-18 is a symbolic link to HKU\.Default which loads the DEFAULT file. You can read more about it here and here.
    Loaded into memory during user logon and mapped to HKEY_USERS\{SID} (HKU) in the Windows Registry.
    Unloaded and saved back to disk at user logoff or system shutdown, though updates can occur throughout the session.

NOTE
Newer MSIX based applications often have app specific hives for NTUSER.DAT. They exist at %localappdata%\Packages\<APPID>\SystemAppData\Helium with a name of User.dat. This means artifacts can be tied back to a specific app and user.
Why it matters:

NTUSER.DAT provides crucial insight into what users did on the system — which programs they ran, what files they accessed, which folders they opened, and how they interacted with the GUI. This makes NTUSER.DAT forensics a cornerstone in both incident response and criminal investigations.
Forensic Importance
Info 	Notes
User Attribution 	As a per-user hive, each NTUSER.DAT file is uniquely tied to an individual account. This supports the identification of which specific user performed certain actions and in some cases in which application for the case of app specific registry hives.
Behavioral Analysis 	NTUSER.DAT artifacts can tell a story about how a user interacts with the system over time — how often certain apps are used, whether removable devices were accessed, or what documents were recently opened.
Malware + Persistence Analysis 	NTUSER.DAT is a prime target for malware authors to establish persistence via startup keys. It’s also useful for identifying signs of compromise where malware executes within user context.
Time-Based Correlation 	Many artifacts include timestamps that can be correlated with other forensic sources like Prefetch, AmCache, SRUM, and event logs to build a complete timeline.
User Context vs. System Context 	NTUSER.DAT reflects changes and activity initiated under the user context, as opposed to HKEY_LOCAL_MACHINE or system-wide settings. This distinction is critical for distinguishing user-driven activity from background processes.
Evidence of Intent 	Since NTUSER.DAT tracks voluntary user activity—such as typed paths, recently opened files, and executed applications—it can be especially powerful in investigations that require demonstration of intent or deliberate action.
Key Artifacts & Registry Locations
UserAssist
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist

Purpose 	Provides evidence of execution for .lnk files or PE files that have a GUI component.
Key Data 	Full path, execution count, last execution timestamp, focus time, focus count, and user initiating file execution.
Notes 	

    Interpreting UserAssist data on Windows 10+ is more difficult due to entries showing up without having been executed. Ex. Using “jump to file location” from Windows start menu.
    Registry hive owner should be interpreted as the user that initiated the process and not the user account the process ran as.
    Data will not be recorded if user opts out of Windows tracking app launches (Start_TrackProgs).
    Check out our UserAssist Forensics blog for more details on this artifact.

Example 	
RunMRU
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU

Purpose 	Provides evidence of execution for the last 26 commands typed by a user in the Windows run dialog box.
Key Data 	Exact path typed by user, command execution order, and execution time for most recent command.
Notes 	

    Data will not be recorded if user opts out of Windows tracking app launches (Start_TrackProgs).
    Command does not always show what was executed. In some instances it shows what a user accessed. Ex. The user provides a path to a document on the system. The default application associated with the file extension will need to be looked up to determine what process was executed.
    Check out our How to Investigate RunMRU blog for more details on this artifact.

Example 	
LastVisitedMRU
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU

Purpose 	Tracks application names along with the directory location of the last accessed file through a Windows common dialog.
Key Data 	Exe name, path to last accessed directory (per app), MRU order, and access time for most recently accessed folder.
Notes 	

    It’s important to note that this does not always represent the last time the folder was accessed by the application, just the last time it was accessed through the common dialog (open/save). Ex. Notepad can open a file by passing a path via command line argument or drag and drop. Neither will result in updates to this artifact.
    Check app specific hives for additional evidence (Ex. Windows notepad).
    Check out the blog OpenSaveMRU and LastVisitedMRU for more details on this artifact.

Example 	
OpenSaveMRU
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU

Purpose 	Provides evidence of data access by recording the last 20 files accessed via an Open/Save dialog per extension.
Key Data 	Full path, execution count, last execution timestamp, focus time, focus count, and user initiating file execution.
Notes 	

    Check app specific hives for additional evidence (Ex. Windows notepad).
    Check out our blog What is a Windows OpenSave MRU Artifact for more details on this artifact.

Example 	
RecentDocs
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs

Purpose 	Tracks recently accessed file/folders. The main key will record the last 150 file names accessed and then subkeys are broken up by extension and will record up to 20 file names (on newer systems).
Key Data 	File name (no path), associated .lnk file name, MRU order, and last accessed time based on most recently accessed file per MRU.
Notes 	

    The RecentDocs registry key is closely linked to the Recent files folder. Windows will automatically add .lnk files to the recent folder and update the registry key. The lnk files in the recent files folder can be used to determine the full path to the file mentioned in the registry key.
    Data will not be recorded if user opts out of Windows tracking recently accessed docs (Start_TrackDocs).
    Check out this blog for more details on the RecentDocs artifact.

Example 	
OfficeMRU
Location 	

    NTUSER.DAT\Software\Microsoft\Office\*\*\File MRU

    NTUSER.DAT\Software\Microsoft\Office\*\*\User MRU\LiveId_####\File MRU

        Used for Office 365

    NTUSER.DAT\Software\Microsoft\Office\*\*\User MRU\AD_####\File MRU

        Used for Office 365 via Azure AD account

Purpose 	Provides evidence of files accessed specifically through an office product (ex. Word, powerpoint, excel).
Key Data 	Full path, application used to open the file, and last opened time.
Notes 	Check out our blog What is a Office MRU Artifact for more details on this artifact.
Example 	
ShellBags
Location 	

    NTUSER.DAT\Software\Microsoft\Windows\Shell\BagMRU

    NTUSER.DAT\Software\Microsoft\Windows\Shell\Bags

Purpose 	Provides evidence of folder existence and in certain scenarios folder accessed. Archive file references can be found here as well.
Key Data 	Full path, if folder was accessed, user related to access, MAC timestamps for folder, and in certain scenarios first/last access time.
Notes 	

    Shellbags in NTUSER.DAT only record folders accessed over the network (network share/UNC path). The bulk of shellbag data is stored in UserClass.dat.
    Check app specific hives for additional evidence (Ex. Windows notepad).
    Check out our blog Shellbags Forensic Analysis for more details on this artifact.

Example 	
WordWheelQuery
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery

Purpose 	Provides an ordered list of search terms users have searched for in the Explorer search dialog.
Key Data 	Search string, MRU order, search time for most the recent search.
Notes 	

    Check out 4n6post writeup on WordWheelQuery for more details.

Example 	
TypedPaths
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths

Purpose 	Provides an ordered list of the last 26 paths typed into the File explorer address bar. Url1 represents the most recently typed path.
Key Data 	Full path, order in which paths were typed, and time for most recently typed path.
Notes 	

    Only paths that exist (at the time it was typed into the explorer bar) will be recorded in the key.
    Data stored in the key is the fully qualified path that the user is taken to. It does not represent what the user directly typed in. Ex. variables are resolved and shortcuts like shell:Startup are resolved.
    Data will not be recorded if the user opts out of Windows tracking app launches (Start_TrackProgs). *This does not apply to app specific registry data.*
    Check app specific hives for additional evidence (Ex. Windows notepad).
    Check out 4n6post writeup on TypedPaths for more details.

Example 	
Run and RunOnce Keys
Location 	

    HKCU\Software\Microsoft\Windows\CurrentVersion\Run

    HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce

Purpose 	Lists programs set to automatically run at user logon.
Key Data 	Command and arguments that run at user logon.
Notes 	For more information on run keys and persistence, check out MITRE T1547.001.
MountPoints2
Location 	

NTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2

Purpose 	USB devices and network shares that the user has had access to.
Key Data 	Network share path or a device volume GUID.
Notes 	

    Check app specific hives for additional evidence (Ex. Windows notepad).
    For more information on MountPoint2, check out this blog by Harlan Carvey.

Example 	
Terminal Server
Location 	

NTUSER.DAT\Software\Microsoft\Terminal Server Client\Servers

Purpose 	Outbound RDP connections.
Key Data 	Hostname, user account, MRU order, time for last RDP connection used.
Notes 	

    Servers subkey provides a list of hostname/IPs connected to via RDP along with user name hint.
    Default subkey provides MRU order in which the RDP connections were last used.
    For more information on Terminal Server Client, check out the Insider Threat Matric entry.

Example 	
Installed Apps (User Specific)
Location 	

NTUSNTUSER.DAT\Software\Microsoft\Windows\CurrentVersion\Uninstall

Purpose 	Understand what applications users have installed.
Key Data 	Command and arguments that run at user logon.
Notes 	

    These installed applications are user specific and are not installed for all users on the system. The installation directory will typically be in the users local appdata folder.
    For more information check out this blog.

Example 	

There are many other artifacts that can be parsed out of NTUSER.DAT hives such as application specific data (Ex. RMM and exfil tools). Some additional resources to find other artifacts of interest are:

    RegSeek: A repository of registry artifacts with a UI to make finding registry artifacts easier.  Do a search for “hkcu\” to find all artifacts that are user specific.
    RegRipper4: Popular registry parsing tool, by Harlan Carvey,  with an extensive list of registry parsing plugins. Search for “ntuser\.dat” to find all plugins that pull artifacts from the hive.
    RECmd:  Popular registry parsing tool, by Eric Zimmerman, with an extensive list of registry parsing artifacts scripted out. One example is Kroll_Batch with over 100 keys parsed out of the NTUSER.DAT hive.

Parsing NTUSER.DAT

There are many ways to access data in NTUSER.DAT. The key is understanding what each method is doing to ensure you do not miss any data. There are 2 main approaches to getting data from NTUSER.DAT:
Asking the System To Give You the Data
Advantage 	

    Easy to do and implement.
    Do not have to worry about missing data not committed to registry hive (either in memory or in transaction log).

Disadvantage 	

    System can lie (API hooking).
    System must be running.

Tools 	

    Windows APIs
    Powershell
    reg/regedit
    TotalReg

Parsing the Registry Hive Using an External Tool
Advantage 	

    Does not require a live system (disk analysis, live systems, folder of files, etc.).
    Threat actors cannot hook APIs to return false information.

Disadvantage 	

    Requires handling transaction logs to ensure all data is examined.
    Relies of the tools/parsing libraries to be able to parse the data correctly.

Tools 	

    Regripper: Command line tool to automate the parsing of registry artifacts. Can produce data in a timeline output format and run yara rules against registry hives. Does not handle transaction logs.
    Registry Explorer: GUI tool to explore registry hives with built book marks for popular artifacts and data viewers to parse certain artifacts.
    RECmd/RLA: Command line tool to parse registry and replay transaction logs.
    Autopsy: Open source digital forensic platform that has modules to parse many popular registry based artifacts.
    Cyber Triage: DFIR tool that automates the parsing and scoring of many artifacts including those found in registry hives.
