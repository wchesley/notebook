$Script:LastOutputLength = 0
function Show-ProgressBar {
    <#
    .SYNOPSIS
        Display a progress bar for long operations. This attempt to mirror the look of Winget's progress bars.
    .DESCRIPTION
        Display a progress bar for long operations. This attempt to mirror the look of Winget's progress bars.
    .PARAMETER Progress
        A value between 0.0 and 1.0 representing the progress of the operation.
    .PARAMETER Width
        The width of the progress bar, given as int, represented in characters. Default is 20 characters long.
    .INPUTS
        None
    .OUTPUTS
        String representing the progress bar.
    .EXAMPLE
        Show-ProgressBar -Progress 0.5 -Width 30
        Displays a progress bar at 50% completion with a width of 30 characters.
    .EXAMPLE
        Show-ProgressBar -Progress 0.75
        Displays a progress bar at 75% completion with the default width of 20 characters.
    .NOTES
        Version: 1.0.5
        Author: Walker Chesley
        Created: 2025-09-25
        Modified: 2026-03-26
        Change Log: 
        - Initial release
        - Updated documentation and added clamping for progress value to ensure it stays within the range of 0.0 to 1.0.
        - Added padding to the output to clear any previous longer output, ensuring the progress bar display remains clean and consistent.
        - Updated output characters to use Unicode block elements for a cleaner fill animation. 
        - Pad the output with spaces to clear any previous longer output, ensuring the progress bar display remains clean and consistent.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [double]$Progress,

        [int]$Width = 20
    )

    # Clamp progress to the range [0.0, 1.0]
    if($Progress -lt 0.0) { $Progress = 0.0 }
    if($Progress -gt 1.0) { $Progress = 1.0 }
    
    $filledChar = [char]0x2588 # █
    $emptyChar = [char]0x2592  # ▒
    
    $filledSteps = [System.Math]::Floor($Progress * $Width)
    $emptySteps = $Width - $filledSteps

    # Build the bar string
    $bar = "$("$filledChar" * $filledSteps)$("$emptyChar" * $emptySteps)"
    
    # Pad output with spaces to clear any previous longer output
    if($bar.Length -lt $Script:LastOutputLength) {
        $bar = $bar.PadRight($Script:LastOutputLength, ' ')
    }
    
    $Script:LastOutputLength = $bar.Length
    return "$bar"
}

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
Export-ModuleMember -Function Show-ProgressBar