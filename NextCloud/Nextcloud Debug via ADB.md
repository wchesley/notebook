# Nextcloud Debug via ADB
First things first make sure adb is installed. I have a backup of the installer on /Nextpool/Projects/Walker/Personal/Installers/platform-tools_r31.03-windows.zip
Locally (windows desktop) it's not on $PATH but in C:\Users\Walker\Documents\Platform-tools
To use outside of $PATH, navigate to the directory where the adb.exe is stored and launch it via `./adb.exe`
To get a new copy of adb, download it from [google](https://developer.android.com/studio/releases/platform-tools)
[adb documentation](https://developer.android.com/studio/command-line/adb)
adb can be installed without installing Android Studio 

## Nextcloud specific Debugging
####### Copied from [here](https://github.com/nextcloud/android)
### [](https://github.com/nextcloud/android#getting-debug-info-via-logcat-mag)Getting debug info via logcat 🔍

#### [](https://github.com/nextcloud/android#with-a-linux-computer)

#### With a linux computer:

-   enable USB-Debugging in your smartphones developer settings and connect it via USB
-   open command prompt/terminal
-   enter `adb logcat | grep "$(adb shell ps | awk '/com.nextcloud.client/{print $2}')" > logcatOutput.txt` to save the output to this file

**Note:** You must have [adb](https://developer.android.com/studio/releases/platform-tools.html) installed first!

#### [](https://github.com/nextcloud/android#on-windows)

#### On Windows:

-   download and install [Minimal ADB and fastboot](https://forum.xda-developers.com/t/tool-minimal-adb-and-fastboot-2-9-18.2317790/#post-42407269)
-   enable USB-Debugging in your smartphones developer settings and connect it via USB
-   launch Minimal ADB and fastboot
-   enter `adb shell ps | findstr com.nextcloud.client` and use the second place of this output (it is the first integer, e.g. `18841`) as processID in the following command:
-   `adb logcat | findstr <processID> > %HOMEPATH%\Downloads\logcatOutput.txt` (This will produce a logcatOutput.txt file in your downloads)
-   if the processID is 18841, an example command is: `adb logcat | findstr 18841 > %HOMEPATH%\Downloads\logcatOutput.txt` (You might cancel the process after a while manually: it will not be exited automatically.)

#### [](https://github.com/nextcloud/android#on-a-device-with-root-wrench)

#### On a device (with root) 🔧

-   open terminal app _(can be enabled in developer options)_
-   get root access via "su"
-   enter `logcat -d -f /sdcard/logcatOutput.txt`
-   you will have to filter the output manually, as above approach is not working on device

or

-   use [CatLog](https://play.google.com/store/apps/details?id=com.nolanlawson.logcat) or [aLogcat](https://play.google.com/store/apps/details?id=org.jtb.alogcat)

**Note:** Your device needs to be rooted for this approach!