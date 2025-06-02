[back](./README.md)

# The Elder Scrolls IV: Oblivion

While I do own both remasterd and the original verison of the game, this document will only pertain to the remasterd version of TESIV: Oblivion. 

# Modding

Mod creation and setup for Oblivion remastered. 

- [UE Viewer](https://www.gildor.org/en/projects/umodel)

## Mod Compendium

<sub>Pulled from: <a href="https://www.reddit.com/r/ElderScrolls/comments/1k6pxr8/tes_iv_oblivion_remastered_modding_compendium/">Reddit</a></sub>

1.) Engine: The game runs a mix of UE5 and the old oblivion engine. Thus you can open and mod the logic of the game with the classic construction set. (Proof: [Arena No Raiment](https://www.nexusmods.com/oblivion/mods/38561?tab=posts) Mod from Oldblivion works out of the box in remastered) A mod which includes only assets needs to be done with a pak-file with the new assets. (Proof: [The Ahegao-Shortsword Texture Mod](https://www.nexusmods.com/oblivionremastered/mods/41)) Thus new assets should be possible by a combination of an esp-mod and an pak-file with the new texture-files.

2.) PAK-Files: Umodel can be used to open the Pak-File and extract its contents. (Proof: [Umodel UE5](https://www.gildor.org/smf/index.php/topic,9195.0.html)) That way we can recreate the folder-structure for custom assets. Without a PAK-File new assets will just not spawn ingame. PAK-Mods need to be placed inside the PAKs-Folder subfolder ~mods.

3.) Hotswapping: The UE5-Engine is just a layer over the old engine. The old engine renders the whole game, then the UE5-Layer hotswaps the assets. That way the cs can be used for modding in combination with creating a modpack for the layer too.

4.) EULA/Bethesdas Stance: Eula forbids modding. (Wouldn't stop me anyway but should be in the compendium for full disclosure) Mod Support is not granted by Beth so no official modding tools are to be provided. For same reason for now you need to make a manual Load Order in Data\\Plugins.txt as there is no Modloader programmed ingame.

5.) Formats: All files inside the PAK are in the uasset-format, including asset- and voice files.

6.) Construction Set: The CS need to be downloaded [here](https://www.nexusmods.com/oblivion/mods/48493?tab=files) and placed inside the Construction Set Folder below. To create a mod with it, you need to create a folder Data in Data. (So it would look like ObvData\\Data\\Data) Then you'd need to move the esp from Data/Data to Data.

7.) Folder Paths:

PAKs: Oblivion Remastered\\OblivionRemastered\\Content\\Paks

ESP/BSAs: Oblivion Remastered\\OblivionRemastered\\Content\\Dev\\ObvData\\Data

Construction Set: Oblivion Remastered\\OblivionRemastered\\Content\\Dev\\ObvData



## Install Construction Set

<sub>pulled from: <a href="https://forums.nexusmods.com/topic/13513548-installing-oblivion-construction-set-for-oblivion-remastered/">Nexus Mod Forums</a></sub>

**STEP 1:** 

Download BSG's Oblivion construction set from [The Elder Scrolls Construction Set - the Oblivion ConstructionSet Wiki](https://cs.uesp.net/wiki/The_Elder_Scrolls_Construction_Set#The_Construction_Set_v1.2)  
  
**STEP 2:**

Navigate to \\SteamLibrary\\steamapps\\common\\Oblivion Remastered\\OblivionRemastered\\Content\\Dev\\ObvData  
  
**STEP 3:**  
  
Move the Construction Set installer into the ObvData folder and run the installer

**STEP 4:**

It will tell you that you do not have Oblivion installed and then give you an option to change the directory of the installation. Direct the installation to \\SteamLibrary\\steamapps\\common\\Oblivion Remastered\\OblivionRemastered\\Content\\Dev\\ObvData

**STEP 5:**

Navigate to \\SteamLibrary\\steamapps\\common\\Oblivion Remastered and create a new folder. Name it **Data.** When you save your .esp files, save them to this newly created Data folder. 

Note: Your .esp files will not appear in this folder. They will actually save to \\SteamLibrary\\steamapps\\common\\Oblivion Remastered\\OblivionRemastered\\Content\\Dev\\ObvData\\Data

Don't ask me how or why this works, it just does.

**STEP 6:**

Run TESConstructionSet.exe - you are now able to work directly with the files from Oblivion Remastered.  
  
**Optional:**

I also recommend downloading xEdit and [Fix NL - Copy Name from Previous Override - xEdit Script at Oblivion Remastered Nexus - Mods and community](https://www.nexusmods.com/oblivionremastered/mods/136) by MadAborModding and following his instructions on fixing the \[NL\] prefixes that will show on your custom content.

## Example: How To Edit a Race

<sub>Pulled from: <a href="https://digineaux.com/edit-a-race-in-oblivion-remastered/">here</a></sub>

### Create a new mod .esp

1.  In the top left of the window, click the load masters button
2.  We want to double click on the files we want as our master files
    -   A master file lets your mod access it’s files and must be loaded before your mod in the load order to function
    -   We only need the Oblivion.esm for this mod. But later you may want to also select some of DLCs so you have access to the spells they add
3.  After setting Oblivion.esm as our master, click ok
    -   The engine will begin loading and may take quite a while
    -   You may get some more error windows popup, you can close and ignore them
    -   The engine may freeze or stop responding, just wait a few minutes it might be just loading. Though crashes are common.
4.  Once loaded in click save
5.  Name your file whatever you want. But it’s best to avoid spaces and non alphanumeric characters.
    -   Im naming mine KillerKhajiit
6.  If that saved without the engine crashing then youv’e now technically created a mod. Though it doesn’t do anything.

### Creating a spell

We can finally get to the fun creative parts.

1.  In the object window, expand the magic tab and click on spell
2.  Look for a spell eith the editor ID: “StandardChameleon3Journeyman”
3.  Double click it so we can open it up and see how it works
    -   The effects list is whats actually applied to the target and handles the targeting and calculating the spell cost.
4.  double click the chameleon effect to see how it works
    -   Magnitude generally effects how powerful the spell is, which is implmented slighlty differently for different effects. for chameleon it determines what % of invisibile you are. For damage health it would determine how much damage per second etc..
5.  click cancel on both windows to close them without making changes
6.  Right click on any spell and select “new”
7.  In the id give it a unique memorable name you will be able to find easily
    -   do not use a number for the first character
    -   I reccomend using a shortned tag based on your user or nickname
    -   Putting an a first will ensure it sits at the top of the list
    -   ill be using dnxCamouflage as the ID
8.  Next give it a name.
    -   The user will see the name in game
    -   you may want to include the mod name in the spell name so the user knows where the effect came from, but some might consider that immersion breaking, so it’s up to you.
    -   im calling mine “Camouflage – KillerKhajiit”
9.  Set type to Ability. This is used for most passives
10.  In the effects section, right click and select new
11.  Click effect and look for Chameleon
12.  Set the range to self
13.  Set the magnitude to a value you find apropriate. Ill be using 10
14.  Click ok
15.  click ok again on the spell window
16.  Save your mod again – do this often
17.  Now find your spell in the object window list. it might be easier to click on the ability subtab of spell tab
18.  Open the race window by clicking character at the top of the screen and selecting race
19.  Select [Khajiit](https://digineaux.com/killer-khajiit/)
20.  In the specials window, lets remove their demorialize ability. You dont have to do this.
21.  Right click it and select delete
22.  now select our Camouflage ability spell and drag it into the [races](https://digineaux.com/remarkable-races/) specials window
23.  click ok to close the race window and save the mod again

### Find and install our mod

1.  Find the .esp we created
2.  Ussually it will be in `Oblivion Remastered\OblivionRemastered\Content\Dev\ObvData`\\Data. But it might be inside `Oblivion Remastered\OblivionRemastered\Content\Dev\ObvData`\\Data\\Data or the data folder in the games root directory.
3.  Move it to `Oblivion Remastered\OblivionRemastered\Content\Dev\ObvData`\\Data if needed
4.  Open Plugins.txt
5.  Add the filename to the bottom of the list. Make sure your spelling is exact

### Test the mod

1.  Cross your fingers and boot up the game
2.  start a new game
3.  Select your race but stop at the confirmation screen
4.  You might notice it mentions a different race
5.  This is a bug with the Creation Set when it modifies and creates records for the remaster
6.  Dont worry though we can fix it later
7.  Select other races and check the race emntioned on the confirmation screen until you find one that says “are you sure you want to select the race: \[NL\]Khajiit. for me it was argonian
8.  click yes
9.  You will look like the other race but mechancially you will be Khajiit
10.  this is fine as we are only testing our new spell ability.
11.  confirm the spell is working and looks right in the active magic effects tab
12.  if its rpefixed with \[NL\] thats fine
13.  You may want to screenshot it for when you publish the mod later

### Fix the \[NL\] prefix bug

[Grab](https://digineaux.com/draggable-windows-and-ui-for-unity/) the following mod and make sure to tell your users to install it as well. If it doesn’t fix the prefix, try renaming the dinput.dll to version.dll. This should work for any non vanilla records.

[https://www.nexusmods.com/oblivionremastered/mods/473?tab=posts](https://www.nexusmods.com/oblivionremastered/mods/473?tab=posts)

### Fix the wrong race bug

This will also remove the \[NL\] prefix bug on vanilla records. The Khajiit race for example is a vanilla record,

1.  Download and extract XEdit to somewhere otuside the games folder. [https://www.reddit.com/r/skyrimmods/comments/1k61ktp/xedit\_415n\_released/](https://www.reddit.com/r/skyrimmods/comments/1k61ktp/xedit_415n_released/)
2.  Rename the .exe to TES4R
3.  Get and install this script: [https://www.nexusmods.com/oblivionremastered/mods/136](https://www.nexusmods.com/oblivionremastered/mods/136)
4.  Launch TES4R.exe
5.  make sure your mod and AltarESPMain.esp are ticked and click ok
6.  Expand your mod and select all its records (you can hold shift or ctrl to select multiple).
7.  right click on any of your selected records and slect apply script
8.  in the script drop down, select 000\_full
9.  click ok
10.  Next click on your race record
11.  in the columns on the right, not that the name row is highlighted red indicating a conflict.
12.  Drag the name value from the AltarESPMain.esp column to your mods.
13.  click im abslutely sure for the warning that pops up
14.  In the top left menu save the plugin

