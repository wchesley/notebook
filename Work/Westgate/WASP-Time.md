# Wasp Time Server

Installed at Fuzzy's Radiator, on FUZ-APP-01
Installed to: `C:\Program Files (x86)\WaspTechnologies\WaspTime`
Primary User: Vanessa Isabelle
Alternate Users: None, only one user can be in the app at a time.

# Troubleshooting Wasp Time Server

## Step 1: Read the Log files

Wasp Time's error messages are not descriptive at all, least the ones shown to the end user when launching Wasp Time. Open the newest log file and scroll to the bottom, work your way up to the most recent error message to determine what is actually going wrong. It is typically one of two things: 
- Missing Time Zone Information
- Port `10002` Already in use

### Missing Time Zone Information

Typically, when you see: `The type initializer for 'WaspTime.Members' threw an exception.` - Wasp cannot read the timezone values that are set in the registry. There is a copy of valid timezones for windows 10 (32 & 64bit) in `Admin.Westgate` dowloads directory. Run the `x64` file to rewrite these values to the registry, then try to relaunch Wasp Time.

### Port `10002` Already in use

If the logs show that Wasp Time Server failed to start because port was already in use you will need to find what process is consuming that port and kill it. This can be done with a reboot but rebooting should be done as last resort as others use this server besides Wasp Time. 

1. Locate the port via powershell: 
   1. You will have to run powershell as a `SYSTEM` level user, open it from Datto Web remote to have this priviledge. 
2. Run the following command in powershell to view what process is using port `10002`
```ps1
Get-NetTCPConnection | where Localport -eq 10002 | select Localport,OwningProcess
```
3. That will output the port and process ID of the process currently using port `10002`. Make note of the Process ID as we will need it to kill that process
4. Kill the proccess via powershell: 
```ps1
taskkill /F /PID <process_ID_From_Step_2>
```
5. Start the Wasp Time server again and confirm it's working.

# Notes

Logs are in the install directory, all are text files, ie `WaspTimeServer.log`, previous logs are renamed to `log1, log2, ... logN`. All Log file are within the Wasp Time Server directory. 

Only one user can be in Wasp at a time, so please close it when you are done. 

This software is long out of support with the vendor. 