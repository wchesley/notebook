<#
.SYNOPSIS
  Exports Outlook calendar events to an .ics file.

.DESCRIPTION
  This script connects to the Outlook application and exports calendar events
  to a specified .ics file. It allows for filtering by start date and can
  force overwrite existing files.

.PARAMETER ExportPath
  The file path where the .ics file will be saved.

.PARAMETER StartDate
  The start date for filtering calendar events.

.PARAMETER Force
  If specified, will overwrite existing .ics files without prompt.

.INPUTS
  None

.OUTPUTS
  Calendar events in .ics format saved to the specified file path.

.NOTES
  Version:        1.4
  Author:         Walker
  Creation Date:  August 15, 2025
  Purpose/Change: Fix getting outlook COM object in remote sessions.

.EXAMPLE
  .\ExportOutlookCal.ps1 -ExportPath "C:\Support\Calendar.ics" -StartDate "2024-01-01"

  This example exports calendar events to the specified .ics file starting from the given date.


.EXAMPLE
    .\ExportOutlookCal.ps1 -ExportPath "C:\Support\Calendar.ics" -StartDate "2024-01-01" -Force
    
    This example exports calendar events to the specified .ics file, forcing overwrite if the file already exists.

.EXAMPLE
    .\ExportOutlookCal.ps1
    
    This example exports calendar events to a user-specific .ics file in the Support directory using the default start date of "2024-01-01". If the file already exists, it will not overwrite it unless the -Force parameter is specified.

.LINK
  https://github.com/wchesley/notebook
#>


[CmdletBinding()]
Param (
    [Parameter(Mandatory = $false)]
    [string]$ExportPath = "C:\Support\$env:USERNAME.ics",

    [Parameter(Mandatory = $false)]
    [datetime]$StartDate = "2024-01-01",

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# Start Outlook function
# This function checks if Outlook is running and starts it if not.
function Start-Outlook {
    $Outlook = Get-Process -Name "OUTLOOK" -ErrorAction SilentlyContinue
    if ($Outlook) {
        Write-Host "Outlook is already running."
        return
    }

    # Try to find Outlook executable for multiple Office versions
    $officePaths = @(
        "C:\\Program Files (x86)\\Microsoft Office\\root\\Office16\\OUTLOOK.EXE",
        "C:\\Program Files\\Microsoft Office\\root\\Office16\\OUTLOOK.EXE",
        "C:\\Program Files (x86)\\Microsoft Office\\Office16\\OUTLOOK.EXE",
        "C:\\Program Files\\Microsoft Office\\Office16\\OUTLOOK.EXE",
        "C:\\Program Files (x86)\\Microsoft Office\\Office15\\OUTLOOK.EXE",
        "C:\\Program Files\\Microsoft Office\\Office15\\OUTLOOK.EXE"
    )
    $found = $false
    foreach ($path in $officePaths) {
        if (Test-Path -Path $path) {
            Write-Host "Starting Outlook from $path ..."
            Start-Process $path
            $found = $true
            break
        }
    }
    if (-not $found) {
        Write-Warning "Outlook executable not found. Please start Outlook manually."
    }
}

# Ensure Outlook is closed before export
Write-Host "Checking if Outlook is running..."
$OutlookProcess = Get-Process -Name "OUTLOOK" -ErrorAction SilentlyContinue
if ($OutlookProcess) {
    Write-Host "Outlook is running, Closing for calendar export..."
    try {
        Stop-Process -Name "OUTLOOK" -Force
        Start-Sleep -Seconds 5
        $OutlookClosed = Get-Process -Name "OUTLOOK" -ErrorAction SilentlyContinue
        if ($OutlookClosed) {
            Write-Error "Failed to close Outlook. Please close it manually and try again."
            exit 1
        }
        Write-Host "Outlook closed successfully."
    } catch {
        Write-Error "Error closing Outlook: $_"
        exit 1
    }
} else {
    Write-Host "Outlook is not running, proceeding with calendar export."
}

# Ensure export directory exists
if ($ExportPath -notlike "*.ics") {
    Write-Error "ExportPath must end with .ics extension."
    Start-Outlook
    exit 1
}
$exportDir = Split-Path -Path $ExportPath -Parent
if (-not (Test-Path -Path $exportDir)) {
    try {
        New-Item -Path $exportDir -ItemType Directory -Force | Out-Null
    } catch {
        Write-Error "Failed to create export directory: $_"
        Start-Outlook
        exit 1
    }
}

# Check if file already exists (idempotency)
if ((Test-Path $ExportPath) -and -not $Force) {
    Write-Host "Calendar already exported to $ExportPath. Use -Force to overwrite." -BackgroundColor Yellow
    Start-Outlook
    exit 0
}
elseif ($Force) {
    Write-Host "Force export enabled. Removing existing file at $ExportPath"
    Remove-Item $ExportPath -Force -ErrorAction SilentlyContinue
    if (-not (Test-Path $ExportPath)) {
        New-Item -Path $ExportPath -ItemType File -Force | Out-Null
        Write-Host "New file created."
    }
}
elseif (-not (Test-Path $ExportPath)) {
    Write-Host "Existing .ics file not found. Creating new export file at $ExportPath"
    New-Item -Path $ExportPath -ItemType File -Force | Out-Null
}

Write-Host "Exporting calendar to $ExportPath"

# Ensure Outlook is available
try {
    $Outlook = New-Object -ComObject Outlook.Application
}
catch {
    Write-Error "Outlook is not installed or accessible: $_"
    Start-Outlook
    exit 1
}

# Access default calendar folder
try {
    $Namespace = $Outlook.GetNamespace("MAPI")
    $Calendar = $Namespace.GetDefaultFolder([Microsoft.Office.Interop.Outlook.OlDefaultFolders]::olFolderCalendar)
}
catch {
    Write-Error "Unable to access Outlook calendar: $_"
    Start-Outlook
    exit 1
}

# Create .ics file and fill it with calendar items:
try {
    $CalendarItems = $Calendar.Items
    $CalendarItems.IncludeRecurrences = $true
    $CalendarItems.Sort("[Start]")

    # Restrict items to the desired date range
    $FilteredItems = @()
    foreach ($Item in $CalendarItems) {
        if ($Item -is [Microsoft.Office.Interop.Outlook.AppointmentItem]) {
            if ($Item.Start -ge $StartDate) {
                $FilteredItems += $Item
            }
        }
    }

    $StreamWriter = New-Object System.IO.StreamWriter($ExportPath, $false)
    $StreamWriter.WriteLine("BEGIN:VCALENDAR")
    $StreamWriter.WriteLine("VERSION:2.0")
    $StreamWriter.WriteLine("PRODID:-//Outlook Export Script//EN")

    foreach ($Item in $FilteredItems) {
        $Start = $Item.Start.ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
        $End = $Item.End.ToUniversalTime().ToString("yyyyMMddTHHmmssZ")
        $StreamWriter.WriteLine("BEGIN:VEVENT")
        $StreamWriter.WriteLine("SUMMARY:$($Item.Subject)")
        $StreamWriter.WriteLine("DTSTART:$Start")
        $StreamWriter.WriteLine("DTEND:$End")
        $StreamWriter.WriteLine("LOCATION:$($Item.Location)")
        $StreamWriter.WriteLine("DESCRIPTION:$($Item.Body)")
        $StreamWriter.WriteLine("END:VEVENT")
    }

    $StreamWriter.WriteLine("END:VCALENDAR")
    $StreamWriter.Close()

    Write-Host "Calendar exported successfully to $ExportPath" -BackgroundColor Green
}
catch {
    Write-Error "Failed to export calendar: $_"
    exit 1
}

Start-Outlook