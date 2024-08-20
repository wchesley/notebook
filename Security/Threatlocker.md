# ThreatLocker

Bootcamp 08.19 -> 08.23 10am-11:30am

EDR (Threatlocker detect) only runs after application has passed through the base threatlocker zero-trust application. 

Health Report is generated daily, download from `Health Center` in Threatlocker portal. 

Use at least 2 variables when whitelisting custom applications. Don't whitelist based on path alone as anyone can drop an exe into that directory and threatlocker will whitelist it (most likely inadvertently). 

Can create policies that apply per user rather than per machine. 