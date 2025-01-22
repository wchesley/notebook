[back](./README.md)

# Signtool

SignTool is a command-line tool that digitally signs files, verifies the signatures in files, removes the signatures from files, and time stamps files. For information about why signing files is important, see [Introduction to code signing](https://learn.microsoft.com/en-us/windows/win32/seccrypto/cryptography-tools).

SignTool is available as part of the [Windows Software Development Kit (SDK)](https://developer.microsoft.com/windows/downloads/windows-sdk). The tool is installed in the `\Bin` folder of the Windows SDK installation path, for example: `C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\signtool.exe`.

## Using Signtool

<sub>
For complete Signtool syntax see <a href="./Signtool_Syntax.md">here</a>
</sub>
  

The following command signs the file named MyControl.exe using a [_certificate_](https://learn.microsoft.com/en-us/windows/win32/secgloss/c-gly) stored in a Personal Information Exchange (PFX) file:

    SignTool sign /f **MyCert**.pfx MyControl.exe

The following command signs the file using a certificate stored in a password-protected PFX file:

    SignTool sign /f **MyCert**.pfx /p **MyPassword** MyControl.exe

> Note  
> **Ensure that you properly protect the password.**

The following command signs and time stamps the file:

    SignTool sign /f **MyCert**.pfx /t http://timestamp.digicert.com MyControl.exe

> Note
>
>For information about time stamping a file after it has already been signed, see [Adding Time Stamps to Previously Signed Files](https://learn.microsoft.com/en-us/windows/win32/seccrypto/adding-time-stamps-to-previously-signed-files).

The following command signs the file using a certificate located in the My store with a subject name of My Company Publisher:

    SignTool sign /n "**My Company Publisher**" MyControl.exe

The following command signs an ActiveX control and provides information that is displayed by Internet Explorer when the user is prompted to install the control:

    SignTool sign /f **MyCert**.pfx /d "**My Product Name**" /du **"https://www.example.com/myproductinfo.html"** MyControl.exe

The following command signs the file using a certificate whose [_private key_](https://learn.microsoft.com/en-us/windows/win32/secgloss/p-gly) information is protected by a hardware cryptography module. For example purposes, assume that the certificate called "My High-Value Certificate," has a private key installed in a hardware cryptography module, and the certificate is properly installed.

    SignTool sign /n "**My High-Value Certificate**" MyControl.exe

The following command signs the file using a certificate whose [_private key_](https://learn.microsoft.com/en-us/windows/win32/secgloss/p-gly) information is protected by a hardware cryptography module. A computer store is specified for the [_certification authority_](https://learn.microsoft.com/en-us/windows/win32/secgloss/c-gly) (CA) store.

    SignTool sign /n "**My High Value Certificate**" /sm /s CA MyControl.exe

The following command signs the file using a certificate stored in a file. The private key information is protected by a hardware cryptography module, and the [_cryptographic service provider_](https://learn.microsoft.com/en-us/windows/win32/secgloss/c-gly) (CSP)and [_key container_](https://learn.microsoft.com/en-us/windows/win32/secgloss/k-gly) are specified by name. This command is useful if the certificate is not properly installed.

    SignTool sign /f **HighValue**.cer /csp "**Hardware Cryptography Module**" /k **HighValueContainer** MyControl.exe

[SignTool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool) returns command line text that states the result of the signing operation. Additionally, SignTool returns an exit code of zero for successful execution, one for failed execution, and two for execution that completed with warnings.

For information about verifying a file's signature, see [Using SignTool to Verify a File Signature](https://learn.microsoft.com/en-us/windows/win32/seccrypto/using-signtool-to-verify-a-file-signature). For information about adding a time stamp if the file has already been signed, see [Adding Time Stamps to Previously Signed Files](https://learn.microsoft.com/en-us/windows/win32/seccrypto/adding-time-stamps-to-previously-signed-files). For additional information about [SignTool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool), see [SignTool](https://learn.microsoft.com/en-us/windows/win32/seccrypto/signtool).

### Real-world Example

This is pulled from a deployment script I wrote. A working example of getting the `signtool.exe` from where it resides on the development machine's filesystem, then signing all `Project` `.dll` and `.exe` files. The use of the `/a` flag tells `signtool` to use the first available code signing cert it can find within the cert store.  

```ps1
# Sign the release:
# Get Signtool path and exe: 
$signtoolPath = "C:\Program Files (x86)\Microsoft SDKs\ClickOnce\SignTool\signtool.exe"

# Sign files in Publish directory
try{
  Write-Host "Signing files in Publish directory..." -ForegroundColor Green
  Set-Location -Path "C:\Users\Administrator\source\repos\Project\src\bin\Publish"
  & $signtoolPath sign /a /tr "http://timestamp.digicert.com" /fd SHA256 .\Project*.dll
  & $signtoolPath sign /a /tr "http://timestamp.digicert.com" /fd SHA256 .\Project*.exe
  Write-Host "Files signed successfully. Removing old archive and creating new archive..." -ForegroundColor Green
}
catch{
  Write-Error "Error signing files. Please ensure signtool is installed and in the correct path, or that you have a valid signing cert available.\nExpected path is: $signtoolPath\nError: $_" -ForegroundColor Red
  exit $LASTEXITCODE
}
```