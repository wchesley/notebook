# Increment Version Number

Powershell script to automatically increment .NET projects version number based on a start date and current date. Calculates current build version as number of days between start and current date. Major and Minor version are to be set and incremented by hand. 

Powershell script: 

```ps1
#!/usr/bin/env pwsh
# Read the csproj file
$content = Get-Content 'FuzzyWeb.csproj'
$csproj = [xml]$content

$initialVersion = $csproj.Project.PropertyGroup.Version
Write-Host "Initial Version: " $initialVersion

$spliteVersion = $initialVersion -Split "\."
Write-Host "Major:" $spliteVersion[0]
#Get the build number (number of days since January 1, 2000)
$baseDate = [datetime]"11/01/2023"
$currentDate = $( Get-Date )
$interval = (NEW-TIMESPAN -Start $baseDate -End $currentDate)
$buildNumber = $interval.Days

#Final version number
$finalBuildVersion = "$( $spliteVersion[0] ).$( $spliteVersion[1] ).$( $buildNumber )"
$csproj.Project.PropertyGroup.Version = $finalBuildVersion;
$csproj.Save("FuzzyWeb.csproj");

"v$finalBuildVersion" | Out-File -FilePath "current_version.txt"
Write-Host "Major.Minor.Build"
Write-Host "Final build number: " $finalBuildVersion
```

`.csproj` file: 

```xml
<PropertyGroup>
  <Version>0.13.385</Version>
</PropertyGroup>

<!--

... Truncated csproj file ... 

 Automatically run script as pre-build action:
 -->

<Target Name="PreBuild" BeforeTargets="PreBuildEvent" Condition="$([MSBuild]::IsOSPlatform('Windows'))">
    <Exec Command="powershell.exe -File $(ProjectDir)IncrementBuildNumber.ps1" />
</Target>
```

With the script and project file combination, the build number gets incremented on each build, saved to the csproj file, each new day the project is built. 