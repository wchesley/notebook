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