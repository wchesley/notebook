[back](./README.md)

# Powershell Template

Powershell script template, pulled from [this gist](https://gist.github.com/9to5IT/18ff0ddf706ec23be997), [TheSysAdminChannel](https://thesysadminchannel.com/powershell-template/) and my own scripts. 

```ps1
#requires -version 5
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

.LINK
  https://github.com/wchesley/notebook
#>

#----------------------------- [Parameters] ---------------------------

[CmdletBinding()]
Param (
  #Script parameters go here
  [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,
    Position = 0
  )]
  [string[]] $TemplateParameter
)

#-------------------------- [Initialisations] -------------------------

# Set Error Actions: 
$ErrorView = 'NormalView'
$ErrorActionPreference = 'Stop'

#Import Modules & Snap-ins

#--------------------------- [Declarations] ---------------------------

# Trap Error & Exit: 
trap {"Error found: $_"; break;}

#---------------------------- [Functions] -----------------------------

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

#---------------------------- [Main Script] ---------------------------

#Script Execution goes here

```