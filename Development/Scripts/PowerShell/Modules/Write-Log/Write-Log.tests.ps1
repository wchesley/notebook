# Write-Log.Tests.ps1
# Pester tests for the Write-Log PowerShell module

# Import the module
Import-Module "./Write-Log.psm1" -Force

Describe 'Write-Log Function' {
    $testMessage = "Test message"
    $datePattern = '\[\d{2}-\d{2}-\d{4} \d{2}:\d{2}:\d{2}\] - '

    Context 'When Level is Information' {
        It 'Should log with Write-Information and correct format' {
            $output = Write-Log -Message "Test message" -Level Information
            $output | Should -Match "$datePattern$testMessage"
        }
        It 'Should accept Info as Level' {
            $output = & { Write-Log -Message "Test message" -Level Info }
            $output | Should -Match "$datePattern$testMessage"
        }
    }

    Context 'When Level is Warning' {
        It 'Should log with Write-Warning and correct format' {
            $output = & { Write-Log -Message "Test message" -Level Warning } 2>&1
            $output | Should -Match "$datePattern$testMessage"
        }
        It 'Should accept Warn as Level' {
            $output = & { Write-Log -Message "Test message" -Level Warn } 2>&1
            $output | Should -Match "$datePattern$testMessage"
        }
    }

    Context 'When Level is Error' {
        It 'Should log with Write-Error and correct format' {
            $output = & { Write-Log -Message "Test message" -Level Error } 2>&1
            $output | Should -Match "$datePattern$testMessage"
        }
        It 'Should accept Err as Level' {
            $output = & { Write-Log -Message "Test message" -Level Err } 2>&1
            $output | Should -Match "$datePattern$testMessage"
        }
    }

    Context 'When Level is not specified' {
        It 'Should log with Write-Host and correct format' {
            $output = & { Write-Log -Message "Test message"} | Out-String
            $output | Should -Match "$datePattern$testMessage"
        }
    }

    Context 'Parameter Aliases' {
        It 'Should accept msg alias for Message' {
            $output = & { Write-Log -msg "Test message"-Level Information } 3>&1
            $output | Should -Match "$datePattern$testMessage"
        }
        It 'Should accept m alias for Message' {
            $output = & { Write-Log -m "Test message"-Level Information } 3>&1
            $output | Should -Match "$datePattern$testMessage"
        }
        It 'Should accept lvl alias for Level' {
            $output = & { Write-Log -Message "Test message"-lvl Warning } 2>&1
            $output | Should -Match "$datePattern$testMessage"
        }
        It 'Should accept l alias for Level' {
            $output = & { Write-Log -Message "Test Error message" -l Error } 
            $output | Should -Match "$datePattern$testMessage"
        }
    }

    Context 'Parameter Validation' {
        It 'Should throw if Message is missing' {
            { Write-Log -Message ""} | Should -Throw "Cannot bind argument to parameter 'Message' because it is an empty string."
        }
    }
}