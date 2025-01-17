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

#-------------------------- [Initialisations] -------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'
# Trap Error & Exit: 
trap {Write-Error "Error found: $_"; break;}

#---------------------------- [Constants] -----------------------------
# Define paths
#$rootReadme = "README.md"

#---------------------------- [Functions] -----------------------------

# Define the root README.md file path
$rootReadme = "README.md"

# Ensure the root README.md file exists
if (-Not (Test-Path $rootReadme)) {
    Write-Error "Root README.md not found at $rootReadme."
    exit
}

# Read the entire content of the root README.md
$rootContent = Get-Content -Path $rootReadme -Raw

# Regex pattern to identify the entire numbered list block
$numberedListPattern = "(?ms)^(\s*1\.\s.*?(?:\n\s*\d+\.\s.*?)*)(\n+|$)"

# Match the numbered list
$listMatch = [regex]::Match($rootContent, $numberedListPattern)

if (-Not $listMatch.Success) {
    Write-Error "No valid numbered list found in the root README.md."
    exit
}

# Extract the content before and after the numbered list
$header = $rootContent.Substring(0, $listMatch.Index).TrimEnd()
$footer = $rootContent.Substring($listMatch.Index + $listMatch.Length).TrimStart()

# Find all immediate subdirectories with README.md files
$subDirectories = Get-ChildItem -Path . -Directory | Where-Object {
    Test-Path "$($_.FullName)\README.md"
}

# Generate the updated numbered list
$newLinks = @()
$i = 1
foreach ($dir in $subDirectories) {
    # Relative path for Markdown links
    $relativePath = (Resolve-Path "$($dir.FullName)\README.md" -Relative).TrimStart(".\")
    $newLinks += "$i. [$($dir.Name)]($relativePath)"
    $i++
}

# Join the new numbered list into Markdown format
$newListMarkdown = $newLinks -join "`n"

# Combine the header, new list, and footer
$updatedContent = @($header, $newListMarkdown, $footer) -join "`n`n"

# Check if the content has changed
if ($updatedContent -ne $rootContent) {
    try {
        Set-Content -Path $rootReadme -Value $updatedContent -Encoding UTF8
        Write-Host "Root README.md has been successfully updated."
    } catch {
        Write-Error "Failed to update README.md: $_"
    }
} else {
    Write-Host "No changes detected. README.md remains unchanged."
}
