[back](./README.md)
# Windows Updates

- [Windows Updates](#windows-updates)
  - [Windows 11](#windows-11)
  - [Server](#server)
- [Update from CLI](#update-from-cli)
  - [View Update History](#view-update-history)
  - [How To Uninstall Windows Updates Using Dism](#how-to-uninstall-windows-updates-using-dism)
    - [Steps](#steps)


**Windows Update** is a [Microsoft](https://en.wikipedia.org/wiki/Microsoft "Microsoft") service for the [Windows 9x](https://en.wikipedia.org/wiki/Windows_9x "Windows 9x") and [Windows NT](https://en.wikipedia.org/wiki/Windows_NT "Windows NT") families of the [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows "Microsoft Windows") operating system, which automates downloading and installing Microsoft Windows [software updates](https://en.wikipedia.org/wiki/Software_update "Software update") over the [Internet](https://en.wikipedia.org/wiki/Internet "Internet"). The service delivers software updates for Windows, as well as the various Microsoft [antivirus products](https://en.wikipedia.org/wiki/Antivirus_software "Antivirus software"), including [Windows Defender](https://en.wikipedia.org/wiki/Windows_Defender "Windows Defender") and [Microsoft Security Essentials](https://en.wikipedia.org/wiki/Microsoft_Security_Essentials "Microsoft Security Essentials"). Since its inception, Microsoft has introduced two extensions of the service: **Microsoft Update** and **Windows Update for Business**. The former expands the core service to include other Microsoft products, such as [Microsoft Office](https://en.wikipedia.org/wiki/Microsoft_Office "Microsoft Office") and [Microsoft Expression Studio](https://en.wikipedia.org/wiki/Microsoft_Expression_Studio "Microsoft Expression Studio"). The latter is available to business editions of [Windows 10](https://en.wikipedia.org/wiki/Windows_10 "Windows 10") and permits postponing updates or receiving updates only after they have undergone rigorous testing.

## Windows 11

Windows 11 has an annual feature update cadence. Feature updates are released in the second half of the calendar year and come with 24 months of support for Home, Pro, Pro for Workstations, and Pro Education editions; 36 months of support for Enterprise and Education editions. For more information, see the  [Windows lifecycle FAQ](https://support.microsoft.com/help/13853).

Windows 11 also releases [monthly security updates](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/windows-monthly-updates-explained/ba-p/3773544) on the second Tuesday of each month. These releases are cumulative, containing all previous updates to keep devices protected and productive.

## Server 

Windows Server has two primary [release channels](https://learn.microsoft.com/en-us/windows-server/get-started/servicing-channels-comparison): the Long-Term Servicing Channel (LTSC) and the Annual Channel (AC). The LTSC provides a longer-term option focusing on a traditional lifecycle of security and quality updates. The AC provides more frequent releases, focusing on containers and microservices, so you can take advantage of innovation more quickly.

Windows Server 2025 is the current LTSC release. Windows Server, version 23H2 is the latest AC release. The focus on virtualization, container, and microservice innovation continues with [Azure Stack HCI](https://learn.microsoft.com/en-us/azure-stack/hci/), [Windows containers](https://learn.microsoft.com/en-us/virtualization/windowscontainers/), and [AKS on Azure Stack HCI](https://learn.microsoft.com/en-us/azure-stack/aks-hci/).

# Update from CLI

Using powershell to update windows requires the intallation of the `PSWindowsUpdate` module. The module can be installed with the following command: 

`Install-Module -Name PSWindowsUpdate -Force`

This module can be used to manage windows udpates from the command line, such as installing updates, viewing installed updates and uninstalling updates. 

## View Update History

> `Get-WUHistory` is apart of the `PSWindowsUpdate` module. 

To view windows update history from powershell run the following command: 

`Get-WUHistory -Last 250`

This will return the 250 most recent updates installed to the computer. Remove the `Last <number>` arguement to view the complete history. More often than not, it's more convinent to view updates without security patches as they are frequent and generate noise if they're not what we're after. To filter in/out Security Updates: 

`Get-WUHistory -last 1000 | Where-Object { $_.Title -notlike "*Security*" }`

There are native windows functions to get update history such as `Get-HotFix`. The Get-HotFix cmdlet uses the Win32_QuickFixEngineering WMI class to list hotfixes that are installed on the local computer or specified remote computers. Another alternative is to use `wmic` to query update history, this will still use the `Win32_QuickFixEngineering` WMI class, and provides the same output as `Get-HotFix`. 

```ps1
PS> Get-HotFix
Source         Description      HotFixID      InstalledBy          InstalledOn
------         -----------      --------      -----------          -----------
Server01       Update           KB4495590     NT AUTHORITY\SYSTEM  5/16/2019 00:00:00
Server01       Security Update  KB4470788     NT AUTHORITY\SYSTEM  1/22/2019 00:00:00
Server01       Update           KB4480056     NT AUTHORITY\SYSTEM  1/24/2019 00:00:00
```



## How To Uninstall Windows Updates Using Dism

Below you can find steps on how to manually remove a windows patch from an endpoint, using the DISM tool.  
  
> Note: The advantage of the DISM tool is that you can use it to remove updates. from either the Windows GUI (if Windows boots normally) or the Windows recovery environment. This is useful if Windows fails to start after an unsuccessful update installation.

### Steps

1\. Open **Command Prompt as Administrator**.

2\. First, view a list with the installed updates with the DISM command:

`dism /online /get-packages /format:table`

  
![Screenshot 2023-03-20 at 13.44.17.png](https://forums.ivanti.com/servlet/rtaImage?eid=ka1UL000000uyO5&feoid=00N1B00000B8iqE&refid=0EM4O000004byqB)  
 

3\. At the "Package Identity" column, find out the **Package Name** of the update that you want to remove. \*

_Example: To remove the "Package\_for\_KB4058702~31bf3856ad364e35~amd64~~16299.188.1.0", you need to enter that value in the next step._  
  
![Screenshot 2023-03-20 at 13.46.21.png](https://forums.ivanti.com/servlet/rtaImage?eid=ka1UL000000uyO5&feoid=00N1B00000B8iqE&refid=0EM4O000004byqu)

 

4\. Finally, type the following command to remove the desired update package and press **Enter**: \*

`dism /Online /Remove-Package /PackageName:PackageName`

_Example: To remove the "Package\_for\_KB4058702~31bf3856ad364e35~amd64~~16299.188.1.0", enter this command:_

`dism /Online /Remove-Package /PackageName:Package\_for\_KB4058702~31bf3856ad364e35~amd64~~16299.188.1.0`