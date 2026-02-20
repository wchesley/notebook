#requires -version 5
<#
.SYNOPSIS
  Get list of modified files in a specified directory that have been modified since a given date.

.DESCRIPTION
    This function retrieves a list of files in the specified directory that have been modified after the provided date. If no date is provided, it defaults to yesterday's date.

.PARAMETER DirectoryPath
    The path of the directory to search for modified files. This parameter is optional and defaults to the current directory.

.PARAMETER AsOfDate
    The date to compare the last modified time of the files against. Only files modified after this date will be returned. This parameter is optional and defaults to yesterday's date.

.NOTES
  Version:        1.0
  Author:         Walker
  Creation Date:  <Date>
  Purpose/Change: Initial script development

.EXAMPLE
  Get-FileLastModified -DirectoryPath "C:\MyFolder"

.EXAMPLE
  Get-FileLastModified -DirectoryPath "C:\MyFolder" -AsOfDate (Get-Date "2023-01-01")

.LINK
  https://github.com/wchesley/notebook
#>

function Get-FileLastModified {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$DirectoryPath = (Get-Location).Path,

        [Parameter(Mandatory = $false, Position = 1)]
        [DateTime]$AsOfDate = (Get-Date).AddDays(-1)
    )

    if (-Not (Test-Path -Path $DirectoryPath -PathType Container)) {
        Write-Error "The specified directory does not exist: $DirectoryPath"
        return
    }

    try {
        $fn = Get-ChildItem -Path $DirectoryPath -File | Where-Object { $_.LastWriteTime -gt $AsOfDate } | Sort-Object -Property LastWriteTime -Descending 
        [array]$sourceFiles = $fn.FullName
        if ($sourceFiles.Count -eq 0) {
            Write-Output "No files have been modified since $AsOfDate in the directory: $DirectoryPath"
        }
        else {
            Write-Output "Files modified since $AsOfDate in the directory: $DirectoryPath"
            $sourceFiles | ForEach-Object { Write-Output $_ }
        }
    }
    catch {
        Write-Error "An error occurred while retrieving the last modified date: $_"
    }
}

