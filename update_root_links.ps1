#requires -version 5
<#
.SYNOPSIS
  Update Root README Links
.DESCRIPTION
  Modify the root README.md file and foreach README.md file found within it's sub directories, add a backlink to the root README.md file. Only acts on the first numbered list found in the README.md file of the directory the script is run from. 
.PARAMETER <RootDirectory>
  RootDirectory
    The root directory to start the traversal.
.INPUTS
  None
.OUTPUTS
  Backlinks appended to first line of markdown files.
.NOTES
  Version:        1.0
  Author:         Walker Chesley
  Creation Date:  01/14/2024
  Purpose/Change: Initial script development
.EXAMPLE
    Add-ReadMeBackLink
#>

#-------------------------- [Initialisations] --------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'
# Trap Error & Exit: 
trap {Write-Error "Error found: $_"; break;}

#---------------------------- [Constants] -----------------------------
$rootReadme = "./README.md"

#---------------------------- [Functions] -----------------------------

# Function to find or create the root README.md file
function Ensure-RootReadme {
    if (-not (Test-Path $rootReadme)) {
        Write-Host "No README.md found in the current directory. Creating one..." -ForegroundColor Yellow
        Set-Content -Path $rootReadme -Value "# Project Root" -Force
    }
}

# Function to find the first numbered list in a markdown file
function Get-NumberedList {
    param (
        [string]$FilePath
    )
    $lines = Get-Content -Path $FilePath
    $startIndex = $null
    $endIndex = $null

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^\d+\.\s+\[.+\]\(.+\)") {
            if (-not $startIndex) { $startIndex = $i }
            $endIndex = $i
        } elseif ($startIndex -and $endIndex -and $lines[$i] -notmatch "^\d+\.\s+\[.+\]\(.+\)") {
            break
        }
    }
    return @{ Start = $startIndex; End = $endIndex; Lines = $lines }
}

# Function to update the numbered list
function Update-ReadmeList {
    param (
        [string]$RootReadme,
        [array]$NewLinks
    )
    $listInfo = Get-NumberedList -FilePath $RootReadme
    $existingLinks = if ($listInfo['Start'] -ne $null) {
        $listInfo['Lines'][$listInfo['Start']..$listInfo['End']] -match "\[.+\]\((.+)\)"
    } else { @() }

    $allLinks = @{}
    foreach ($link in $existingLinks) {
        if ($link -match "\[(.+?)\]\((.+?)\)") {
            $allLinks[$Matches[1]] = $Matches[2]
        }
    }
    foreach ($link in $NewLinks) {
        if (-not $allLinks.ContainsKey($link.Name)) {
            $allLinks[$link.Name] = $link.Path
        }
    }

    $sortedLinks = $allLinks.GetEnumerator() | Sort-Object Key
    $newList = @()
    $i = 1
    foreach ($link in $sortedLinks) {
        $newList += "$i. [$($link.Key)]($($link.Value))"
        $i++
    }

    # Update the README
    if ($listInfo['Start'] -ne $null) {
        $listInfo['Lines'][$listInfo['Start']..$listInfo['End']] = $newList
        Set-Content -Path $RootReadme -Value $listInfo['Lines'] -Force
    } else {
        Add-Content -Path $RootReadme -Value $newList
    }
}

#---------------------------- [Main Script] ---------------------------

Ensure-RootReadme

$subdirs = Get-ChildItem -Directory
$newLinks = @()

foreach ($dir in $subdirs) {
    $subReadme = Join-Path -Path $dir.FullName -ChildPath "README.md"
    if (Test-Path $subReadme) {
        $relativePath = (Resolve-Path -Path $subReadme).Path
        $newLinks += [PSCustomObject]@{
            Name = $dir.Name
            Path = $relativePath
        }
    }
}

Update-ReadmeList -RootReadme $rootReadme -NewLinks $newLinks

Write-Host "README.md updated successfully." -ForegroundColor Green
exit $LASTEXITCODE