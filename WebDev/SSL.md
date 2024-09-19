# SSL

## Generate self-signed cert (Linux)

using openssl: 

```bash
# interactive
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365

# non-interactive and 10 years expiration
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"
```

## Generate self-signed cert (Windows/Powershell)

using Powershell: 

```ps1
$today = Get-Date
$after = $today.AddYears(10)
$certificate = New-SelfSignedCertificate -DnsName "app.fuzradiator.com" -CertStoreLocation "Cert:\LocalMachine\My" `
-KeySpec "KeyExchange" -KeyUsage "DigitalSignature," "KeyEncipherment" `
-Type "SSLServerAuthentication" -NotAfter $after `
-Subject "CN=app.fuzradiator.com, OU=IT, O=Fuzzy's Radiator, L=Borger, S=Texas, C=US" `
-Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
-HashAlgorithm "SHA256" -KeyLength 2048
```

## Code Signing Certs

When I last did this (at work), we had an Active Directory server with the CA role already installed to it. 

I created a new code-signing template and requested it from my local machine. Then moved it to my Dev VM as a `pfx` file.

I'm still not 100% sure if this will work with things like SentinelOne or ThreatLocker wiht a cert signed by an Active Directory Certificate Authority. The only other option is to acquire a publicly signed certificate from a well-known CA like Comodo or Digicert. 

### .NET Core

.NET Core cannot use `.pfx` files for code signing. In looking online everywhere seemed to say that `sn.exe` is the solution to this. I wasn't able to find it already on my system, but I was able to get it working from `Visual Studio`'s developer console. 

To convert `pfx` to `pub` (public key):  
`sn.exe -p private.pfx public.pub`

From here, I added the public key to the code repository and set every project in the solution to use that cert for signing. I had some trouble with CI/CD pipeline not reading or finding the file. Well the file is not included in build output nor git repo (and rightly so). Updated tests script to copy the `.pub` file into the correct directories on the self-hosted github runner. 

### Powershell

> #### Note:
> This section assumes that you have already imported your code signing cert to `CERT:\CurrentUser\My`

Locate your cert in powershell: 

- List all certs:  
  ```ps1
  Get-ChildItem Cert:\CurrentUser\My
  ```
- Locate your certificate, typically easiest to find by it's `Subject` name, but if you cannot locate it in powershell, use `mmc.exe`'s certificate snap in to locate your cert and confirm it's thumbprint. 
- There are two ways to assign your certificate to a variable
  - `$cert = (Get-ChildItem -Path Cert:\LocalMachine\My -CodeSigningCert) [4]`
    - Where 4 is the index of your cert in the list output by the earlier `Get-ChildItem` command. The index starts counting at `0`!
  - `$cert = Cert:\CurrentUser\My\THUMBPRINT`
    - Use the thumbprint of your cert directly. 
- Now that we have our code signing cert stored in the `$cert` variable we can use it to sign powershell scripts: 
  ```ps1
  Set-AuthenticodeSignature -FilePath PATH_TO_SCRIPT.ps1 -Certificate $cert
  ```
- The script signature is appended to the end of the of the powershell script given in the command. You can confirm the signature by opening the file or running `cat PATH_TO_SCRIPT.ps` to see the output of signing the script. 
