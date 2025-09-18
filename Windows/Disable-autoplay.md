# Disable Autoplay for all drives

### **Option 1** - Group Policy

- Set the following group policy: 

`Computer Configuration\Policies\Administrative Templates\Windows Components\AutoPlay Policies\Turn off Autoplay` to the following value: `Enabled\All drives`

### **Option 2** - Registry

- Set the following registry value: 
  
`HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun` to the following `REG_DWORD` value: `255`

# Disable Autoplay for non-volume devices

### **Option 1**

- Set the following Group Policy:

*Computer
 Configuration\Policies\Administrative Templates\Windows 
Components\AutoPlay Policies\Disallow Autoplay for non-volume devices*

To the following value: *Enabled*

### **Option 2**

- Follow these steps to apply an Intune policy:

1. Go to the  [**Devices-> Configuration profiles**](https://intune.microsoft.com/#blade/Microsoft_Intune_DeviceSettings/DevicesMenu/configurationProfiles)
2. To update an **existing policy:**
    - Click on the policy name in the list
    - In the navigation bar, click on **Properties**
    - Next to **Configuration settings** click on **Edit**
    - Go to step #4
3. If you’d like to create a **new policy**, click on the **Create Policy** button
    - in the side panel, choose:
        - **Platform:** Windows 10 and later
        - **Profile Type:** Administrative Templates
    - Click on **Create** button
    - Proceed to step #4
4. In the **Configuration settings** wizard step, set the following:
    - Set Computer Configuration-> Windows Components-> AutoPlay Policies-> **Disallow Autoplay for non-volume devices** to **Enabled**
5. Complete all remaining wizard steps, review and **Save** policy

### **Option 3**

- Set the following registry value:

*HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer\NoAutoplayfornonVolume*

To the following REG_DWORD value: *1*