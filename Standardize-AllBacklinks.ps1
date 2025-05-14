#Requires -Version 5.1
<#
.SYNOPSIS
    Ensures standardized backlinks in Markdown files based on their type:
    - README.md files (non-root): First line should be '[back](../README.md)' if a parent README.md exists.
    - Other .md files: Should contain '[back](./README.md)' if a local README.md exists (appended if missing).
.PARAMETER RepositoryPath
    The root path of your notes repository. Defaults to the current directory.
.PARAMETER FixLinks
    A switch parameter. If present, the script will attempt to add or correct
    the specified backlinks in Markdown files.
.EXAMPLE
    .\Standardize-AllBacklinks.ps1 -RepositoryPath "C:\Path\To\Your\Notes"
    Checks for standardized backlinks in all Markdown files.
.EXAMPLE
    .\Standardize-AllBacklinks.ps1 -RepositoryPath "C:\Path\To\Your\Notes" -FixLinks -Verbose
    Checks and attempts to fix/add backlinks in Markdown files, with verbose output.
#>
param (
    [string]$RepositoryPath = (Get-Location).Path,
    [switch]$FixLinks 
)

$ErrorActionPreference = 'Stop' 

try {
    $rootPath = (Resolve-Path $RepositoryPath).Path
} catch {
    Write-Error "Repository path '$RepositoryPath' not found or invalid."
    return
}

$allFiles = Get-ChildItem -Path $rootPath -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notlike "*\.git*" }

if (-not $allFiles) {
    Write-Output "No files found in '$rootPath' (excluding .git)."
    return
}

$fixedCount = 0
$warningCount = 0
$processedMdFileCount = 0

Write-Output "Starting standardized backlink check for all files..."

foreach ($file in $allFiles) {
    Write-Verbose "Processing file: $($file.FullName)"

    # --- Case A: File IS README.md ---
    if ($file.Name -eq "README.md") {
        $processedMdFileCount++
        # Skip the root README.md of the repository
        if ($file.DirectoryName -eq $rootPath) {
            Write-Verbose "Skipping root README.md: $($file.FullName) (no parent to link to with '../README.md')."
            continue
        }

        $expectedLinkReadme = "[back](../README.md)"
        
        $parentOfReadmeDirInfo = Get-Item $file.DirectoryName | Select-Object -ExpandProperty Parent
        if (-not $parentOfReadmeDirInfo) { # Should exist if not root README.md
             Write-Warning "Could not determine parent directory for $($file.DirectoryName). Skipping backlink check for $($file.Name)."
             $warningCount++
             continue
        }
        $parentReadmePath = Join-Path -Path $parentOfReadmeDirInfo.FullName -ChildPath "README.md"

        if (-not (Test-Path $parentReadmePath -PathType Leaf)) {
            Write-Verbose "Parent directory README ('$parentReadmePath') does not exist for '$($file.FullName)'. Standard first-line link '$expectedLinkReadme' is NOT required for this README.md."
            
            $currentFirstLineContent = (Get-Content -Path $file.FullName -TotalCount 1 -ErrorAction SilentlyContinue)
            $actualFirstLine = if ($currentFirstLineContent -is [array] -and $currentFirstLineContent.Count -gt 0) { $currentFirstLineContent[0] } elseif ($currentFirstLineContent -is [string]) { $currentFirstLineContent } else { "" }

            if ($actualFirstLine -eq $expectedLinkReadme) {
                 Write-Warning "File '$($file.FullName)' (a README.md) has '$expectedLinkReadme' on its first line, but its designated parent README ('$parentReadmePath') does not exist. This link might be erroneous and should likely be removed."
                 $warningCount++
                
            }
            continue 
        }

        # Parent README exists, so the current README *should* have the link on its first line.
        $fileContentRaw = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $fileContentRaw -and $file.Length -gt 0) {
            Write-Warning "Could not read content from README.md: $($file.FullName). It might be locked or have an encoding issue."
            $warningCount++
            continue
        }
        
        $lines = $fileContentRaw -split '\r?\n' # Handles \n and \r\n
        $firstLine = if ($lines.Count -gt 0) { $lines[0] } else { "" }

        if ($firstLine -eq $expectedLinkReadme) {
            Write-Verbose "Correct backlink ('$expectedLinkReadme') found on the first line of: $($file.FullName)"
        } else {
            Write-Warning "First line of '$($file.FullName)' (a README.md) is NOT '$expectedLinkReadme' (and should be, as parent README exists)."
            Write-Warning "  Current first line: '$firstLine'"
            $warningCount++
            if ($FixLinks) {
                try {
                    $newContent = ""
                    if ([string]::IsNullOrEmpty($fileContentRaw)) {
                        $newContent = $expectedLinkReadme
                    } elseif ($lines.Count -eq 1 -and $lines[0] -eq $firstLine) { 
                        # Handle files with one line:
                        $newContent = $expectedLinkReadme 
                    } else { # File has multiple lines, or first line was not the backlink. 
                        $lines[0] = $expectedLinkReadme # Replace the first line
                        $newContent = $lines -join "`n"
                    }
                    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline:$false -Force
                    Write-Host "[FIXED] First line of '$($file.FullName)' set to '$expectedLinkReadme'."
                    $fixedCount++
                } catch {
                    Write-Error "Failed to fix first line of '$($file.FullName)': $($_.Exception.Message)"
                }
            }
        }

    # --- Case B: File IS NOT README.md (but IS a .md file) ---
    } elseif ($file.Extension -eq ".md") {
        $processedMdFileCount++
        $expectedLinkNonReadme = "[back](./README.md)"
        $localReadmePath = Join-Path -Path $file.DirectoryName -ChildPath "README.md"

        if (-not (Test-Path $localReadmePath -PathType Leaf)) {
            Write-Verbose "Local README ('$localReadmePath') does not exist in the same directory as '$($file.FullName)'. Link '$expectedLinkNonReadme' is NOT required for this file."
            
            $fileContentForCheck = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
            if ($null -ne $fileContentForCheck -and $fileContentForCheck -match "[\[]back[\]][(]\s*(?:\./)?README\.md\s*[)]") { # Check if link is present erroneously
                 Write-Warning "File '$($file.FullName)' contains a link like '$expectedLinkNonReadme', but the local README ('$localReadmePath') it would point to does not exist. This link might be erroneous."
                 $warningCount++
            }
            continue
        }

        $fileContentRaw = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $fileContentRaw -and $file.Length -gt 0) {
            Write-Warning "Could not read content from file: $($file.FullName). It might be locked or have an encoding issue."
            $warningCount++
            continue
        }

        $linkRegex = "\[back\]\(\s*(?:\./)?README\.md\s*\)"

        if ($fileContentRaw -match $linkRegex) {
            Write-Verbose "Backlink matching '$expectedLinkNonReadme' pattern found in: $($file.FullName)"
        } else {
            Write-Warning "Backlink matching '$expectedLinkNonReadme' pattern MISSING in: $($file.FullName) (and should be present, as local README exists)."
            $warningCount++
            if ($FixLinks) {
                try {
                    # Determine what to add: just the link, or with separators if content exists
                    $linkToAdd = if ([string]::IsNullOrWhiteSpace($fileContentRaw)) {
                                     $expectedLinkNonReadme 
                                 } else { 
                                     "`n`n---`n$expectedLinkNonReadme`n"
                                 }
                    Add-Content -Path $file.FullName -Value $linkToAdd -Encoding UTF8
                    Write-Host "[FIXED] Appended backlink '$expectedLinkNonReadme' to: $($file.FullName)"
                    $fixedCount++
                } catch {
                    Write-Error "Failed to append backlink to '$($file.FullName)': $($_.Exception.Message)"
                }
            }
        }
    # --- Case C: File IS NOT README.md AND NOT a .md file (e.g., images, other types) ---
    } else {
        Write-Verbose "Skipping direct Markdown backlink check/modification for non-Markdown file: $($file.FullName) (Type: $($file.Extension))."
    
    }
}

Write-Output "`n--- Standardized Backlink Check Complete ---"
Write-Output "Total files scanned: $($allFiles.Count)"
Write-Output "Markdown files processed for links: $processedMdFileCount"
Write-Output "Warnings issued (e.g., missing/incorrect links, potential issues): $warningCount"
if ($FixLinks) {
    Write-Output "Links fixed/added in Markdown files: $fixedCount"
}