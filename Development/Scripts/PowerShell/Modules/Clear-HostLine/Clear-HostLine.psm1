function Clear-HostLine {
    <#
    .SYNOPSIS
        Clears a specified number of lines from the console.
    .DESCRIPTION
        This function clears the specified number of lines from the console output, starting from the current cursor position and moving upwards.
    .PARAMETER Count
        The number of lines to clear. Default is 1.
    .EXAMPLE
        Clear-HostLine -Count 5
        This command will clear the last 5 lines from the console output.
    .NOTES
        Author: Walker Chesley
        Created: 2025-09-26
        Modified: 2025-09-10
        Version: 1.0.1
        Additional Information: This function is designed to enhance console output management in PowerShell scripts.
        Change Log: 
            1.0.1 - Added parameter validation to ensure Count is between 1 and 256. Added logic to prevent cursor from moving to negative line numbers.
            1.0.0 - Initial creation of the function.
    #>
    Param (
        [Parameter(Position = 1)]
        [ValidateRange(1, 256)]
        [int32]$Count = 1
    )

    $CurrentLine = $Host.UI.RawUI.CursorPosition.Y
    $ConsoleWidth = $Host.UI.RawUI.BufferSize.Width

    for ($i = 1; $i -le $Count; $i++) {
        [Console]::SetCursorPosition(0, ($CurrentLine - $i))
        [Console]::Write("{0,-$ConsoleWidth}" -f " ")
    }
    $cursorPos = $CurrentLine - $Count
    if ($cursorPos -lt 0) { $cursorPos = 0 }
    [Console]::SetCursorPosition(0, $cursorPos)
}

Export-ModuleMember -Function Clear-HostLine