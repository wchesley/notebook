[back](../README.md)

# ThreatLocker

## Links

- [Policy Order of Operations](./Policy_Order_Of_Operation.md)

## Notes

Bootcamp 08.19 -> 08.23 10am-11:30am

EDR (Threatlocker detect) only runs after application has passed through the base threatlocker zero-trust application. 

Health Report is generated daily, download from `Health Center` in Threatlocker portal. 

Use at least 2 variables when whitelisting custom applications. Don't whitelist based on path alone as anyone can drop an exe into that directory and threatlocker will whitelist it (most likely inadvertently). 

Can create policies that apply per user rather than per machine. 

Storage Control as FIM: There's no option to ignore files of certain type or directory? It seems to be all or nothing. 

## Certificates

It's best to whitelist applications by their certificate. For custom code though, it'll need to be signed by a trusted 3rd party CA. ~~I had attempted to use our own AD CA for a cert but it still shows as untrusted~~. So long as the certificate is used within your own domain and is trusted by your CA, threatlocker will allow you to approve by certificate. 

ThreatLocker KB article [here](https://threatlocker.kb.help/unverified-certificates/) 

## Things to watch out for

After approving an application that was run from a terminal, you will have to refresh the terminal session before ThreatLocker will allow it to run again, despite the pop-up appearing stating that the application was approved and you can run it again. In fact, running the app from ThreatLocker's pop-up window will just open the script (in this case) as a text file rather than execute it as a powershell script.

- For bash terminals refresh via `source ~/.bash_rc`
- For Powershell/Windows Terminal, refresh via `. $profile`
  
Rules and Polices are read in order of smallest to largest, so a polciy set at place `-19` will take precedene over a policy at place `0`. 

When ringfencing a new application, place the ringfence into monitor only mode for at least a week, then review any blocks and allow accordingly. 

Realtime unified audit (Ran from threatlocker agent on users machine), while it provides a great place to view actively blocked files, in real-time vs the 5min delay for web portal's unified audit, has one major drawback. You can only view blocked files as they apply to your current user context. If two users are logged into a machine, user A and user B, if user A views their 'Real Time Unified Audit' they will not see any threatlocker actions taken against User B. Per Say user A is a tech assisting User B, any action performed by User B will not appear in real time unified audit as viewed by user A. 

### Migrate ThreatLocker to new machine - Cloned machine

When cloning an old machine to a new machine with ThreatLocker installed there are a few things to do before cloning the machine. 

> Ensure "Tamper Protection" is disabled before starting this process.

Before cloning, perform the following actions on the original machine: 

- Stop all ThreatLocker services. 
- Delete `C:\Program Files\ThreatLocker\pk.dat`
- Delete the following registry keys from `HKLM\SOFTWARE\ThreatLocker`
  - `ComputerAuthKey`
  - `ComputerId`

Do not re-enable any threatlocker services on the original machine. Only enable them on the new machine once cloning is complete. If you reboot the old machine, you will need to reperform the steps above, including disabling Tamper Protection mode. 

### Copying Application Policies between Organizations

When copying application policies or definitions between organizations, save them to the new organization first, else the policies don't copy in properly. This issue was given to me second hand and I haven't had a chance to confirm it yet. 
