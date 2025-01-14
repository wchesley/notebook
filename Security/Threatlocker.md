[back](./README.md)

# ThreatLocker

Bootcamp 08.19 -> 08.23 10am-11:30am

EDR (Threatlocker detect) only runs after application has passed through the base threatlocker zero-trust application. 

Health Report is generated daily, download from `Health Center` in Threatlocker portal. 

Use at least 2 variables when whitelisting custom applications. Don't whitelist based on path alone as anyone can drop an exe into that directory and threatlocker will whitelist it (most likely inadvertently). 

Can create policies that apply per user rather than per machine. 

Storage Control as FIM: There's no option to ignore files of certain type or directory? It seems to be all or nothing. 

## Certificates

It's best to whitelist applications by their certificate. For custom code though, it'll need to be signed by a trusted 3rd party CA. I had attempted to use our own AD CA for a cert but it still shows as untrusted. 

ThreatLocker KB article [here](https://threatlocker.kb.help/unverified-certificates/) 

## Things to watch out for

After approving an application that was run from a terminal, you will have to refresh the terminal session before ThreatLocker will allow it to run again, despite the pop-up appearing stating that the application was approved and you can run it again. In fact, running the app from ThreatLocker's pop-up window will just open the script (in this case) as a text file rather than execute it as a powershell script.

- For bash terminals refresh via `source ~/.bash_rc`
- For Powershell/Windows Terminal, refresh via `. $profile`