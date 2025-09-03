param (
    [string]$Path = "."
)

# Validate the provided directory path
if (-not (Test-Path $Path -PathType Container)) {
    Write-Error "Invalid path: $Path"
    exit
}

# Retrieve all immediate subdirectories
$subdirs = Get-ChildItem -Path $Path -Directory

if ($subdirs.Count -eq 0) {
    Write-Output "No subdirectories found in $Path"
    exit
}

$results = @()

foreach ($subdir in $subdirs) {
    # Compute the total size of the subdirectory
    $size = (Get-ChildItem -Path $subdir.FullName -File -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $results += [PSCustomObject]@{
        Directory = $subdir.FullName
        Size      = $size
    }
}

# Sort the subdirectories by size (largest to smallest)
$sortedResults = $results | Sort-Object -Property Size -Descending

# Output the sorted results with formatted size information
foreach ($entry in $sortedResults) {
    Write-Output "Directory: $($entry.Directory)"
    Write-Output ("Size: {0:N0} bytes ({1} GB)" -f $entry.Size, ([math]::Round($entry.Size / 1GB, 2)))
    Write-Output "--------------------------------"
}