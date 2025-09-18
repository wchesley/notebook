# Enable Autoupdates (Microsoft Office)

**Description**  
Controls whether the Office automatic updates are enabled or disabled for all Office products installed by using Click-to-Run. This policy has no effect on Office products installed via Windows Installer.

**Potential risk**  
Security updates help prevent malicious attacks on Office applications. Timely application of Office updates helps ensure the security of devices and the applications running on the devices. Without these updates, devices and the applications running on those devices are more susceptible to security attacks.

### **Option 1** - Group Policy

- Set the following Group Policy:

`Computer Configuration\Administrative Templates\Microsoft Office 2016 (Machine)\Updates\Enable Automatic Updates` to the following value: `Enabled`.

### **Option 2** - Registry

- Set the following registry value: 

`HKLM\SOFTWARE\policies\Microsoft\office\16.0\common\officeupdate\enableautomaticupdates` to the following `REG_DWORD` value: `1`. 