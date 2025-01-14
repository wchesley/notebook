[back](./README.md)

# Powershell Template

Powershell script template, pulled from [this gist](https://gist.github.com/9to5IT/18ff0ddf706ec23be997) and my own scripts. 

```ps1
#requires -version 4
<#
.SYNOPSIS
  <Overview of script>
.DESCRIPTION
  <Brief description of script>
.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None>
.NOTES
  Version:        1.0
  Author:         Walker
  Creation Date:  <Date>
  Purpose/Change: Initial script development
.EXAMPLE
  <Example explanation goes here>
  
  <Example goes here. Repeat this attribute for more than one example>
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Param (
  #Script parameters go here
)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'

#Import Modules & Snap-ins

#----------------------------------------------------------[Declarations]----------------------------------------------------------

# Trap Error & Exit: 
trap {"Error found: $_"; break;}

#-----------------------------------------------------------[Functions]------------------------------------------------------------

<#
Function <FunctionName> {
  Param ()
  Begin {
    Write-Host '<description of what is going on>...'
  }
  Process {
    Try {
      <code goes here>
    }
    Catch {
      Write-Host -BackgroundColor Red "Error: $($_.Exception)"
      Break
    }
  }
  End {
    If ($?) {
      Write-Host 'Completed Successfully.'
      Write-Host ' '
    }
  }
}
#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Script Execution goes here

```