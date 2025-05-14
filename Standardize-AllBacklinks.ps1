#Requires -Version 5.1
<#
.SYNOPSIS
    Ensures standardized backlinks in Markdown files based on their type:
    - README.md files (non-root): First line should be '[back](../README.md)' if a parent README.md exists.
    - Other .md files: Should contain '[back](./README.md)' if a local README.md exists (appended if missing).
    Outputs a summary and a table of any warnings. Use -Verbose for detailed logs.
.PARAMETER RepositoryPath
    The root path of your notes repository. Defaults to the current directory.
.PARAMETER FixLinks
    A switch parameter. If present, the script will attempt to add or correct
    the specified backlinks in Markdown files.
.EXAMPLE
    .\Standardize-AllBacklinks.ps1 -RepositoryPath "C:\Path\To\Your\Notes"
    Checks for standardized backlinks and outputs a summary and warning table if issues are found.
.EXAMPLE
    .\Standardize-AllBacklinks.ps1 -RepositoryPath "C:\Path\To\Your\Notes" -FixLinks -Verbose
    Checks and attempts to fix/add backlinks, with detailed verbose logging, followed by summary and warning table.
#>
param (
    [string]$RepositoryPath = (Get-Location).Path,
    [switch]$FixLinks
)

$ErrorActionPreference = 'Stop'

Write-Host "`n--- Standardize Backlinks Script v1.1.0 ---" -ForegroundColor Green
Write-Host "Working With Repository Path: $RepositoryPath" -ForegroundColor Cyan

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

$warningsLog = [System.Collections.Generic.List[object]]::new()
$fixedCount = 0
$processedMdFileCount = 0
$warningLoggedCount = 0

Write-Verbose "Starting standardized backlink check for all files..."

foreach ($file in $allFiles) {
    Write-Verbose "Processing file: $($file.FullName)"

    # --- Case A: File IS README.md ---
    if ($file.Name -eq "README.md") {
        $processedMdFileCount++
        if ($file.DirectoryName -eq $rootPath) {
            Write-Verbose "Skipping root README.md: $($file.FullName) (no parent to link to with '../README.md')."
            continue
        }

        $expectedLinkReadme = "[back](../README.md)"
        $parentOfReadmeDirInfo = Get-Item $file.DirectoryName | Select-Object -ExpandProperty Parent
        if (-not $parentOfReadmeDirInfo) {
            $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "README: Parent Dir Inaccessible"; Details = "Could not determine parent directory for $($file.DirectoryName)." })
            $warningLoggedCount++
            continue
        }
        $parentReadmePath = Join-Path -Path $parentOfReadmeDirInfo.FullName -ChildPath "README.md"

        if (-not (Test-Path $parentReadmePath -PathType Leaf)) {
            Write-Verbose "Parent directory README ('$parentReadmePath') does not exist for '$($file.FullName)'. Standard first-line link '$expectedLinkReadme' is NOT required for this README.md."
            $currentFirstLineContent = (Get-Content -Path $file.FullName -TotalCount 1 -ErrorAction SilentlyContinue)
            $actualFirstLine = if ($currentFirstLineContent -is [array] -and $currentFirstLineContent.Count -gt 0) { $currentFirstLineContent[0] } elseif ($currentFirstLineContent -is [string]) { $currentFirstLineContent } else { "" }
            if ($actualFirstLine -eq $expectedLinkReadme) {
                $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "README: Erroneous Parent Link"; Details = "Has '$expectedLinkReadme' on first line, but parent README '$parentReadmePath' does NOT exist. Consider removal." })
                $warningLoggedCount++
            }
            continue
        }

        $fileContentRaw = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $fileContentRaw -and $file.Length -gt 0) {
            $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "README: Content Read Error"; Details = "Could not read content. File might be locked or have encoding issue." })
            $warningLoggedCount++
            continue
        }
        $lines = $fileContentRaw -split '\r?\n'
        $firstLine = if ($lines.Count -gt 0) { $lines[0] } else { "" }

        if ($firstLine -eq $expectedLinkReadme) {
            Write-Verbose "Correct backlink ('$expectedLinkReadme') found on the first line of: $($file.FullName)"
        } else {
            $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "README: Incorrect First Line"; Details = "First line is: '$firstLine'. Expected: '$expectedLinkReadme' (as parent README exists)." })
            $warningLoggedCount++
            if ($FixLinks) {
                try {
                    $newContent = if ([string]::IsNullOrEmpty($fileContentRaw)) { $expectedLinkReadme } elseif ($lines.Count -eq 1 -and $lines[0] -eq $firstLine) { $expectedLinkReadme } else { $lines[0] = $expectedLinkReadme; $lines -join "`n" }
                    Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline:$false -Force
                    Write-Verbose "[FIXED] First line of '$($file.FullName)' set to '$expectedLinkReadme'."
                    $fixedCount++
                } catch {
                    $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "README: Fix Failed"; Details = "Failed to fix first line: $($_.Exception.Message)" })
                    $warningLoggedCount++
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
            if ($null -ne $fileContentForCheck -and $fileContentForCheck -match "[\[]back[\]][(]\s*(?:\./)?README\.md\s*[)]") {
                $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "File: Erroneous Local Link"; Details = "Contains link like '$expectedLinkNonReadme', but local README '$localReadmePath' does NOT exist." })
                $warningLoggedCount++
            }
            continue
        }

        $fileContentRaw = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $fileContentRaw -and $file.Length -gt 0) {
            $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "File: Content Read Error"; Details = "Could not read content. File might be locked or have encoding issue." })
            $warningLoggedCount++
            continue
        }
        $linkRegex = "\[back\]\(\s*(?:\./)?README\.md\s*\)"
        if ($fileContentRaw -match $linkRegex) {
            Write-Verbose "Backlink matching '$expectedLinkNonReadme' pattern found in: $($file.FullName)"
        } else {
            $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "File: Missing Local Link"; Details = "Link pattern '$expectedLinkNonReadme' MISSING (and should be present, as local README exists)." })
            $warningLoggedCount++
            if ($FixLinks) {
                try {
                    $linkToAdd = if ([string]::IsNullOrWhiteSpace($fileContentRaw)) { $expectedLinkNonReadme } else { "`n`n---`n$expectedLinkNonReadme`n" }
                    Add-Content -Path $file.FullName -Value $linkToAdd -Encoding UTF8
                    Write-Verbose "[FIXED] Appended backlink '$expectedLinkNonReadme' to: $($file.FullName)"
                    $fixedCount++
                } catch {
                    $warningsLog.Add([PSCustomObject]@{ File = $file.FullName; Issue = "File: Fix Failed"; Details = "Failed to append backlink: $($_.Exception.Message)" })
                    $warningLoggedCount++
                }
            }
        }
    # --- Case C: File IS NOT README.md AND NOT a .md file ---
    } else {
        Write-Verbose "Skipping direct Markdown backlink check/modification for non-Markdown file: $($file.FullName) (Type: $($file.Extension))."
    }
}

Write-Verbose "Backlink check processing complete. Generating summary..."

# --- Output Warning Table and Summary ---
if ($warningsLog.Count -gt 0) {
    Write-Host "`n--- ISSUES AND WARNINGS LOG (Standardize Backlinks) ---" -ForegroundColor Yellow
    $warningsLog | Format-Table -AutoSize -Wrap
    Write-Host "Refer to the table above for specific files and issues found." -ForegroundColor Yellow
} else {
    Write-Host "`nNo issues or warnings detected regarding standardized backlinks." -ForegroundColor Green
}

Write-Output "`n--- Summary: Standardized Backlink Check ---"
Write-Output "Total files scanned: $($allFiles.Count)"
Write-Output "Markdown files processed for links: $processedMdFileCount"
Write-Output "Total issues/warnings logged in table: $warningLoggedCount"
if ($FixLinks) {
    Write-Output "Links fixed/added in Markdown files: $fixedCount"
}