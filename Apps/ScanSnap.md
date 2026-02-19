<sub>[back](./README.md)</sub>

# ScanSnap

Helper program to scan documents into a device from the scanner over network or USB connections. 

## Associated processes

From: [SuperUser: Where does ScanSnap store temporary PDF's?](https://superuser.com/questions/1852489/where-does-fujitsu-scansnap-home-stored-unsaved-pdfs)  
ScanSnap (`SshRegister.exe`) writes PDFs temporarily to the following folder:

`%LocalAppData%\Temp\ScanSnap Home\SshRegisterConnection\`  
i.e. `C:\Users\<user>\AppData\Local\Temp\ScanSnap Home\SshRegisterConnection\...`

