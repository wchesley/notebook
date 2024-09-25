# Dotnet Deployment

Notes regarding deploying .NET based applications

# General

To build for release run the following command: 

`dotnet build -c Release -o ./bin/Publish`

# ASP.NET Core

Using Kestrel as web server and run web app as windows service.  

## Project Setup

You will have to add the nuget package: `Microsoft.Hosting.Extensions.WindowsServices` to your startup projects `.csproj` file. Version at the time of this writing is `8.0.0` (Date: 08/01/2024).

In your source code: Create a new class to interface with windows service lifecycle. Essentially, give windows a way to communicate with the application to control starting, stopping restarting the app from `services.msc`. 

Example: 

```csharp
public class WindowsService : Microsoft.Extensions.Hosting.BackgroundService
{
    private readonly ILogger<WindowsService> _logger;
    public WindowsService(ILogger<WindowsService> logger)
    {
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Westgate Web Windows Service is starting");
        await Task.Yield();
        while (!stoppingToken.IsCancellationRequested)
        {
            await Task.Delay(1000, stoppingToken);
        }
        _logger.LogInformation("Westgate Web Windows Service is stopping");
    }
}
```

Then inject the Windows Service into the application (in `program.cs`): 

```csharp
//Run as hosted Windows service: 
builder.Services.AddWindowsService(opt => opt.ServiceName = "WestgateWeb");
builder.Services.AddHostedService<WindowsService>();
```

## Windows Setup

Once the application is setup, we can create the account and service in Windows. 

First, create a service account to run the application under. 
- Prefix the account name with `svc_` to denote it's a service account, append the application name to the end, ie `svc_WestgateWeb`
- Grant this account the most minimal permissions needed to run the application. Typically this is read, write and read & execute to the directory that the application lives under. 
- Generate a random password of at least 22 characters, at least one capital and lowercase letter, a number and special character, do not use words that appear in the dictionary, do not use sequentially repeating characters of any kind (ie. no `ee`, `ii`, `11`, `!!`, but `1!1` is acceptable as it's not the same characters back to back).
- Grant this account permission to run as a service. Microsoft has a guide written out for this [here](https://learn.microsoft.com/en-us/system-center/scom/enable-service-logon?view=sc-om-2022). There is also a script that handles this process [here](../Scripts/GrantLogonAsService.md)

Open PowerShell and use the `New-Service` command to create a service for the application to run under. An example command run for FUZ-WEB-APP server (Production server): 

```ps1
New-Service -Name "FuzzyWeb" -BinaryPathName "C:\Users\Public\FuzzysWebProduction\FuzzyWeb.exe --contentRoot C:\Users\Public\FuzzysWebProduction"  -Credential "FUZ-WEB-APP\svc_FuzzyWeb" -Description "Fuzzy Web application service" -DisplayName "FuzzyWeb" -StartupType Automatic
```

The Service Name must match the `ServiceName` defined in your application else your service will fail to start via `services.msc`. You can still directly launch the application with its `.exe`

## SSL Certificate 

Public facing deployments are outside the scope of this document, instead you will generate a self-signed certificate and install that to users' machines via group policy. 

-	To generate the certificate for the application open PowerShell and run the following commands: 
```ps1
$date = Get-Date
$certExpireDate = $date.AddYears(5)
New-SelfSignedCertificate -DnsName 'app.fuzradiator.com' -CertStoreLocation 'Cert:\LocalMachine\Root' -NotBefore $certExpireDate
```

This sets the certs name to `app.fuzradiator.com` and stores it in the local machines trusted root store. Confirm in Microsoft Management Console (`mmc`) that the certificate has been added to the Trusted Root Certifications. 

### Kestrel Configuration

Once you have your valid SSL certificate, open your `appsettings.Production.json` file and either add or confirm the following settings match the SSL certificate created in the previous section. 

```json
/* Excerpt from appsettings.Production.json */
  "Kestrel": {
    "Endpoints": {
      "Http": {
        "Url": "http://*:80"
      },
      "HttpsInlineCertStore": {
        "Url": "https://*:443",
        "Certificate": {
          "Subject": "app.fuzradiator.com",
          "Store": "Root",
          "Location": "LocalMachine",
          "AllowInvalid": "false"
        }
      }
    },
/* Remaining appsetings.Production.json info here */
```

This is a minimal example, and Kestrel does not have to be configued from any `.json` file if so desired. Microsoft's documentation for Kestrel configuration is located [here](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel/endpoints?view=aspnetcore-8.0)

## Confirm Deployment

You should have some predefined criteria as to what a successful deployment looks like, but at the most basic; ensure the app runs as expected. Start by running the app directly from powershell as both your user account and the service account. This ensures that permissions are correctly set for the service account and it can run the app. Read, and then re-read the terminal output if the application fails to start, this will tell you exactly what, where and why things went wrong, if they go wrong at all. 

Once you've confirmed you can run the application under its service account, launch `services.msc` and start the service you created for this. Then double check the application runs and functions as expected before notifying users that the app is live or has been updated. 