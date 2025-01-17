#requires -version 5
<#
.SYNOPSIS
  ReadMe Backlink Adder
.DESCRIPTION
  Add a backlink to the README.md file in all markdown files in a directory and its subdirectories.
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
    Script was written so that it can be used to add a backlink to the README.md file in all markdown files in a directory and its subdirectories.

    Add-ReadMeBackLink -RootDirectory "C:\Users\Walker\Documents\GitHub\MyProject"
#>

#-------------------------- [Initialisations] --------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'
# Trap Error & Exit: 
trap {Write-Error "Error found: $_"; break;}

#-----------------------------------------------------------[Functions]------------------------------------------------------------
# Define the function for checking and inserting links
Function Add-ReadMeBackLink {
    param (
        [string]$RootDirectory
    )

    # Check if the provided directory exists
    if (-Not (Test-Path -Path $RootDirectory -PathType Container)) {
        Write-Host "Error: The specified directory '$RootDirectory' does not exist." -ForegroundColor Red
        return
    }

    # Get all subdirectories recursively
    $Directories = Get-ChildItem -Path $RootDirectory -Directory -Recurse

    # Include the root directory in processing
    $Directories += Get-Item -Path $RootDirectory
    $BackLink = "[back](./README.md)"
    $BackLinkTest = "*$BackLink*";

    foreach ($Dir in $Directories) 
    {
        $ReadMePath = Join-Path -Path $Dir.FullName -ChildPath 'README.md'
        
        # Check if the directory contains a README.md file
        if (Test-Path -Path $ReadMePath) 
        {
            $MarkdownFiles = Get-ChildItem -Path $Dir.FullName -Filter '*.md' -File | Where-Object { $_.FullName -ne $ReadMePath }
            
            foreach ($MarkdownFile in $MarkdownFiles) 
            {
                $FirstLine = Get-Content -Path $MarkdownFile.FullName -TotalCount 1

                if ($FirstLine -notlike $BackLinkTest) 
                {
                    $FileContent = [System.IO.File]::ReadAllText($MarkdownFile.FullName)

                    [System.IO.File]::WriteAllText($MarkdownFile.FullName, "$BackLink`n`n" + $FileContent)

                    Write-Host "Updated $($MarkdownFile.FullName) with link to $ReadMePath" -ForegroundColor Green
                } 
                else 
                {
                    Write-Host "File $($MarkdownFile.FullName) already contains the link." -ForegroundColor Yellow
                }
            }

            # Handle parent directory README links
            $ParentDir = $Dir.Parent
            $ReadMeExists = Test-Path -Path (Join-Path -Path $ParentDir.FullName -ChildPath 'README.md')
            if ($ParentDir -and $ReadMeExists) 
            {
                $ParentReadMePath = Join-Path -Path $ParentDir.FullName -ChildPath 'README.md'
                $FirstLine = Get-Content -Path $ReadMePath -TotalCount 1

                if ($FirstLine -notlike "*[back](../README.md)*") 
                {
                    $FileContent = [System.IO.File]::ReadAllText($ReadMePath)

                    [System.IO.File]::WriteAllText($ReadMePath, "[back](../README.md)`n`n" + $FileContent)

                    Write-Host "Updated $ReadMePath with link to parent $ParentReadMePath" -ForegroundColor Green
                }
            }
        } else {
            Write-Host "Directory $($Dir.FullName) does not contain a README.md file." -ForegroundColor Red
        }
    }
}