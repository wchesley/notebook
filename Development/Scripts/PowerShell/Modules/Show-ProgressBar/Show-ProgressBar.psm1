function Show-ProgressBar {
<# 
.SYNOPSIS
    Display a progress bar for long operations. This attempt to mirror the look of Docker's progress bars.
.DESCRIPTION
    Display a progress bar for long operations. This attempt to mirror the look of Docker's progress bars.
    The bar uses Braille characters to represent progress in a visually appealing way.
.PARAMETER Progress
    A value between 0.0 and 1.0 representing the progress of the operation.
.PARAMETER Width
    The width of the progress bar in characters. Default is 40.
.INPUTS
    None
.OUTPUTS
    String representing the progress bar.
.EXAMPLE
    Show-ProgressBar -Progress 0.5 -Width 30
    Displays a progress bar at 50% completion with a width of 30 characters.
.EXAMPLE
    Show-ProgressBar -Progress 0.75
    Displays a progress bar at 75% completion with the default width of 40 characters.
.NOTES
    Version: 1.0.0
    Author: Walker Chesley
    Created: 2025-09-25
    Modified: 2025-09-25
    Change Log: 
    - Initial release
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [double]$Progress,

        [int]$Width = 40
    )

    if ($Progress -lt 0.0 -or $Progress -gt 1.0) {
        throw "Progress must be a value between 0.0 and 1.0"
    }

    # Define the Braille patterns for the bar
    $fullBlock = '⣿'
    # Array of characters that fill bottom-to-top, then left-to-right
    $partialBlocks = @('⡀', '⡄', '⡆', '⡇', '⣇', '⣧', '⣷')

    # Calculate the number of discrete sub-steps across the entire bar width
    $totalSubsteps = $Width * 8
    $filledSubsteps = [System.Math]::Round($Progress * $totalSubsteps)

    # Calculate the number of full blocks and the state of the partial block
    $numFullBlocks = [int]($filledSubsteps / 8)
    $numPartialSubsteps = $filledSubsteps % 8

    # Build the bar string
    $bar = $fullBlock * $numFullBlocks

    # Add the partial block if progress is not a multiple of a full block
    if ($numPartialSubsteps -gt 0 -and $numFullBlocks -lt $Width) {
        # PowerShell arrays are 0-indexed, so subtract 1
        $bar += $partialBlocks[$numPartialSubsteps - 1]
    }
    
    # Create the final string with padding and brackets
    $paddedBar = $bar.PadRight($Width)
    return "[$paddedBar]"
}

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
Export-ModuleMember -Function Show-ProgressBar