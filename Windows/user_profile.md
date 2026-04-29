<sub>[back](./README.md)</sub>

# User Profiles

## Reset User Profile

Often times a Windows user profile can become corrupted and cause issues with applications, websites, and any number of other Windows features. Fear not, there is a simple way to recreate the user profile without losing any data! By re-creating the user profile you are essentially setting the user’s file system back to its bare bones defaults.

### Step 1: Re-Create User Profile (Windows)

For the users convenience, (and your own) take a quick look at how the user has their profile set up. Have the user login. Take screen shots or take notes of the users profile; mapped network drives, mapped network printer, Task bar shortcuts, etc. You’ll need to set these up again in a few minutes.
Note: Some 3rd party software is required to be installed specifically on the users profile, so be aware of that as well.

1. Reboot the computer to release any locks on the profile.
2. Log on with an administrative account.
3. Navigate to the `C:\Users\` folder
4. Rename the user profile with the word “.old” at the end of it. Example: “username” becomes “username.old”
5. Delete these two registry keys for that user: Open regedit.exe and navigate to:
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsNT\CurrentVersion\ProfileList`
 In the “Profile Image Path” value. Find the key that lists the user name. Note the last four digits of the value. Then delete it.
Then navigate to:
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\Current Version\ProfileGuid`
Find and delete the key with the four digits from the last step.
6. Reboot the computer again.
7. Login with the users credentials.
8. Transfer data from the user’s old profile (username-old), into the user new profile (username) one folder at a time.
*Do not transfer the “AppData” Contents unless you specifically know what you are looking for. This folder is most likely housing the garbage that jacked-up the user profile in the first place.
<mark>If the user was fond of Sticky Notes, they can be found here:</mark>
`C:\Users\username\AppData\Roaming\Microsoft\Sticky Notes`
***Web Browsers such as Chrome, Firefox, etc. often time store the user data in the “AppData” folder as well. For example you may need to reach back and restore the users Google Chrome folder here:
`C:\Users\username\AppData\Local\Google\Chrome\User Data`
9. After you are sure that you have moved all the users’ data from the old profile on to the new profile. You may delete the old profile, but I never do. Just in case.
10. Another reboot may be required.
11. Have user login again. Remap any network drives, printers, task bar items and any other cosmetics from step 1.

If whatever caused you to want to rebuild the user profile in the first place is still causing issues…save yourself some time and nuke it. If you have automated your machine build process that shouldn’t be too much of a burdensome task.
Just remember to backup any active user profiles.