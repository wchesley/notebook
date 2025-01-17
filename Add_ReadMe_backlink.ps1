#requires -version 5
<#
.SYNOPSIS
  ReadMe Backlink Adder
.DESCRIPTION
  Add a backlink to the README.md file in all markdown files in a directory and its subdirectories.
.PARAMETER <rootReadme>
  rootReadme
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
    Script was written so that it can be used to add a backlink to the README.md file in all markdown files in a directory and its subdirectories.

    Add-ReadMeBackLink -rootReadme "C:\Users\Walker\Documents\GitHub\MyProject"
#>

#-------------------------- [Initialisations] --------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'
# Trap Error & Exit: 
trap { Write-Error "Error found: $_"; break; }

#---------------------------- [Constants] -----------------------------
# Define paths
$rootReadme = "./"

#---------------------------- [Functions] -----------------------------
# Check if the provided directory exists
if (-Not (Test-Path -Path $rootReadme -PathType Container)) {
    Write-Host "Error: The specified directory '$rootReadme' does not exist." -ForegroundColor Red
    return
}

# Get all subdirectories recursively
$Directories = Get-ChildItem -Path $rootReadme -Directory -Recurse

# Include the root directory in processing
$Directories += Get-Item -Path $rootReadme
$BackLink = "[back](./README.md)"
$BackLinkTest = [regex]::Escape($BackLink)  # Escape for regex usage

$processedFiles = @()  # Array to track processed files
$processedReadmes = @() # Array to track processed README.md files

foreach ($Dir in $Directories) {
    $ReadMePath = Join-Path -Path $Dir.FullName -ChildPath 'README.md'
        
    # Skip processing the root directory's README file
    if ($Dir.FullName -eq (Resolve-Path $rootReadme).Path) {
        continue
    }

    # Check if the directory contains a README.md file
    if (Test-Path -Path $ReadMePath) {
        $MarkdownFiles = Get-ChildItem -Path $Dir.FullName -Filter '*.md' -File | Where-Object { $_.FullName -ne $ReadMePath }
            
        foreach ($MarkdownFile in $MarkdownFiles) {
            # Skip if the file has already been processed
            if ($processedFiles -contains $MarkdownFile.FullName) {
                continue
            }
            
            # Read the full content of the file
            $FileContent = Get-Content -Path $MarkdownFile.FullName -Raw
            # Check if the backlink exists anywhere in the file using regex
            if (-not ($FileContent -match "^\s*\[back\]\(./README.md\)")) {
                # Insert the backlink at the start of the file
                [System.IO.File]::WriteAllText($MarkdownFile.FullName, "$BackLink`n`n" + $FileContent)

                Write-Host "Updated $($MarkdownFile.FullName) with link to $ReadMePath" -ForegroundColor Green
                $processedFiles += $MarkdownFile.FullName
            } 
            else {
                Write-Host "File $($MarkdownFile.FullName) already contains the link." -ForegroundColor Yellow
            }
        }

        # Handle parent directory README links
        $ParentDir = $Dir.Parent
        $ReadMeExists = Test-Path -Path (Join-Path -Path $ParentDir.FullName -ChildPath 'README.md')
        
        # Skip if the parent directory doesn't have a README.md file
        if ($ParentDir -and $ReadMeExists -and -not ($processedReadmes -contains $ParentDir.FullName)) {
            $ParentReadMePath = Join-Path -Path $ParentDir.FullName -ChildPath 'README.md'
            
            # Read the full content of the parent README.md
            $ParentContent = Get-Content -Path $ParentReadMePath -Raw
            # Check if the backlink exists anywhere in the parent README.md using regex
            if (-not ($ParentContent -match "^\s*\[back\]\(../README.md\)")) {
                # Insert the backlink at the start of the parent README
                [System.IO.File]::WriteAllText($ParentReadMePath, "[back](../README.md)`n`n" + $ParentContent)

                Write-Host "Updated $ParentReadMePath with link to parent $ReadMePath" -ForegroundColor Green
                $processedReadmes += $ParentDir.FullName
            }
        }
    }
    else {
        Write-Host "Directory $($Dir.FullName) does not contain a README.md file." -ForegroundColor Red
    }
}
