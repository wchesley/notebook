#Requires -Version 5.1
<#
.SYNOPSIS
    Audits README.md files for a '## Links' section. This section should contain
    Markdown list item links to all local files and subdirectories (to their README.md).
    Outputs a summary and a table of any warnings with conditional coloring for certain issues.
    Use -Verbose for detailed logs.
.PARAMETER RepositoryPath
    The root path of your notes repository. Defaults to the current directory.
.EXAMPLE
    .\Audit-ReadmeLinksSection-Colored.ps1 -RepositoryPath "C:\Path\To\Your\Notes"
    Audits README.md files and outputs a summary and potentially colored warning table if issues are found.
.EXAMPLE
    .\Audit-ReadmeLinksSection-Colored.ps1 -RepositoryPath "C:\Path\To\Your\Notes" -Verbose
    Audits README.md files with detailed verbose logging, followed by summary and potentially colored warning table.
#>
param (
    [string]$RepositoryPath = (Get-Location).Path
)

$ErrorActionPreference = 'SilentlyContinue' 

Write-Host "`n--- README '## Links' Section Audit Script v1.0.3 ---" -ForegroundColor Green
Write-Host "Working With Repository Path: $RepositoryPath" -ForegroundColor Cyan

try {
    $rootPath = (Resolve-Path $RepositoryPath).Path
} catch {
    Write-Error "Repository path '$RepositoryPath' not found or invalid."
    return
}

$allReadmes = Get-ChildItem -Path $rootPath -Recurse -Filter "README.md" -File | Where-Object { $_.FullName -notlike "*\.git*" }

if (-not $allReadmes) {
    Write-Output "No README.md files found to audit in '$rootPath'."
    return
}

$warningsLog = [System.Collections.Generic.List[object]]::new()
$warningLoggedCount = 0

$linksSectionHeading = "## Links"
$anyNextHeadingRegex = '^\s*#+\s+.*'

Write-Verbose "Starting README.md '## Links' section audit..."

foreach ($readme in $allReadmes) {
    Write-Verbose "`n--- Auditing README: $($readme.FullName) ---"
    $readmeContent = Get-Content -Path $readme.FullName -Raw
    
    if ($null -eq $readmeContent -and $readme.Length -gt 0) {
        $warningsLog.Add([PSCustomObject]@{ File = $readme.FullName; Issue = "Content Read Error"; Details = "Could not read content. File might be locked or have encoding issue." })
        $warningLoggedCount++
        continue
    }
    if ([string]::IsNullOrWhiteSpace($readmeContent) -and $readme.Length -eq 0) {
        Write-Verbose "README is empty: $($readme.FullName)"
    }

    $currentDir = $readme.DirectoryName
    $localFiles = Get-ChildItem -Path $currentDir -File -Exclude $readme.Name | Where-Object { $_.FullName -notlike "*\.git*" }
    $localDirs = Get-ChildItem -Path $currentDir -Directory | Where-Object { $_.FullName -notlike "*\.git*" }

    $linksSectionIndex = -1
    $readmeLines = $readmeContent -split '\r?\n'
    for ($i = 0; $i -lt $readmeLines.Length; $i++) {
        if ($readmeLines[$i].Trim() -eq $linksSectionHeading) {
            $linksSectionIndex = $i
            break
        }
    }

    if ($linksSectionIndex -eq -1) {
        $details = "'$linksSectionHeading' heading was not found."
        if ($localFiles.Count -gt 0 -or $localDirs.Count -gt 0) {
            $details += " Local files/dirs exist which should be listed."
        }
        $warningsLog.Add([PSCustomObject]@{ File = $readme.FullName; Issue = "Links Section: Not Found"; Details = $details })
        $warningLoggedCount++
    } else {
        Write-Verbose "'$linksSectionHeading' section FOUND in '$($readme.FullName)' at line $($linksSectionIndex + 1)."
        $sectionEndIndex = $readmeLines.Length
        for ($i = $linksSectionIndex + 1; $i -lt $readmeLines.Length; $i++) {
            if ($readmeLines[$i] -match $anyNextHeadingRegex) {
                $sectionEndIndex = $i; break
            }
        }
        $linksSectionActualLines = if (($linksSectionIndex + 1) -lt $sectionEndIndex) { $readmeLines[($linksSectionIndex + 1)..($sectionEndIndex - 1)] } else { @() }

        if ($linksSectionActualLines.Count -eq 0 -and ($localFiles.Count -gt 0 -or $localDirs.Count -gt 0)) {
            $warningsLog.Add([PSCustomObject]@{ File = $readme.FullName; Issue = "Links Section: Empty"; Details = "'$linksSectionHeading' section is empty, but local items exist." })
            $warningLoggedCount++
        }

        foreach ($file in $localFiles) {
            $fileName = $file.Name
            $escapedFileName = [System.Text.RegularExpressions.Regex]::Escape($fileName)
            $fileLinkPattern = "^\s*-\s+\[.*?\]\s*\(\s*(?:\./)?${escapedFileName}\s*\)\s*$"
            $foundInSec = $false; foreach($line in $linksSectionActualLines){ if($line -match $fileLinkPattern){ $foundInSec = $true; break } }
            if ($foundInSec) {
                Write-Verbose "  Link to local file '$fileName' FOUND in '$linksSectionHeading' section."
            } else {
                $warningsLog.Add([PSCustomObject]@{ File = $readme.FullName; Issue = "Links Section: Missing File Link"; Details = "Link to local file '$fileName' MISSING or not in standard list format within '$linksSectionHeading'." })
                $warningLoggedCount++
            }
        }

        foreach ($dir in $localDirs) {
            $dirName = $dir.Name
            $escapedDirName = [System.Text.RegularExpressions.Regex]::Escape($dirName)
            $dirLinkPattern = "^\s*-\s+\[.*?\]\s*\(\s*(?:\./)?${escapedDirName}/README\.md\s*\)\s*$"
            $foundInSec = $false; foreach($line in $linksSectionActualLines){ if($line -match $dirLinkPattern){ $foundInSec = $true; break } }
            if ($foundInSec) {
                Write-Verbose "  Link to subdirectory '$($dirName)/README.md' FOUND in '$linksSectionHeading' section."
            } else {
                $warningsLog.Add([PSCustomObject]@{ File = $readme.FullName; Issue = "Links Section: Missing SubDir Link"; Details = "Link to subdir '$($dirName)/README.md' MISSING or not in standard list format within '$linksSectionHeading'." })
                $warningLoggedCount++
            }
        }
    }
}
Write-Verbose "'## Links' section audit processing complete. Generating summary..."

# --- Output Warning Table and Summary ---
if ($warningsLog.Count -gt 0) {
    Write-Host "`n--- ISSUES AND WARNINGS LOG (README '## Links' Section Audit) ---" -ForegroundColor Yellow

    # Define ANSI escape codes
    $Esc = "$([char]27)"
    
    $AnsiYellowText = "${Esc}[93m"  # Bright Yellow text (ANSI code for SGR parameter 93)
    $AnsiBlueText = "${Esc}[94m"    # Bright Blue text (ANSI code for SGR parameter 94)
    $AnsiReset = "${Esc}[0m"        # Reset all attributes

    # Create a new list of objects where the 'Issue' property is modified with ANSI color codes, default to no color: 
    $displayWarningsLog = foreach ($logEntry in $warningsLog) {
        $coloredIssue = $logEntry.Issue 
        if ($logEntry.Issue -eq "Links Section: Not Found") {
            $coloredIssue = "$AnsiYellowText$($logEntry.Issue)$AnsiReset"
        } elseif ($logEntry.Issue -eq "Links Section: Missing SubDir Link") {
            $coloredIssue = "$AnsiBlueText$($logEntry.Issue)$AnsiReset"
        }
        # To add more colors for other issues, add more elseif blocks here. For example:
        # elseif ($logEntry.Issue -eq "Links Section: Missing File Link") {
        #     $coloredIssue = "${Esc}[91m$($logEntry.Issue)$AnsiReset" # Bright Red
        # }

        # Output a new object with the potentially colored 'Issue' field.
        # Other fields (File, Details) remain as they are.
        [PSCustomObject]@{
            File    = $logEntry.File
            Issue   = $coloredIssue
            Details = $logEntry.Details
        }
    }
    
    Write-Host "Color Legend (requires ANSI-compatible console like Windows Terminal):"
    Write-Host " - " -NoNewline; Write-Host "Issue text in Yellow:" -ForegroundColor Yellow -NoNewline; Write-Host " 'Links Section: Not Found'"
    Write-Host " - " -NoNewline; Write-Host "Issue text in Blue:" -ForegroundColor Blue -NoNewline; Write-Host " 'Links Section: Missing SubDir Link'"

    $displayWarningsLog | Format-Table -AutoSize -Wrap
} else {
    Write-Host "`nNo issues or warnings detected regarding '## Links' sections in README files." -ForegroundColor Green
}

Write-Output "`n--- Summary: README '## Links' Section Audit ---"
Write-Output "Total README files audited: $($allReadmes.Count)"
Write-Output "Total issues/warnings logged in table: $warningLoggedCount"