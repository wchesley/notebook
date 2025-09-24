# Intune Remediations

This folder contains PowerShell scripts and supporting files designed for use with Microsoft Intune Remediation tasks. These scripts help automate the detection and resolution of common issues on managed Windows devices, improving compliance and security posture.

## Structure
- **BackupBitLockerKey/**: Scripts to detect and remediate BitLocker key backup issues.
	- `detect.ps1`: Checks for missing or improperly backed up BitLocker keys.
	- `remediate.ps1`: Attempts to resolve detected BitLocker key problems.
- **UnquotedServicePaths/**: Scripts to detect and remediate unquoted service path vulnerabilities.
	- `detect.ps1`: Identifies services with unquoted paths that may pose a security risk.
	- `remediate.ps1`: Fixes unquoted service paths to mitigate vulnerabilities.

## Usage
These scripts are intended to be deployed via Intune Remediation policies:
1. **Detection Script**: Runs first to identify devices with the targeted issue.
2. **Remediation Script**: Executes if the detection script finds a problem, attempting to fix it automatically.

## Adding New Remediations
To add a new remediation:
1. Create a new folder named after the issue.
2. Add a `detect.ps1` script to identify the issue.
3. Add a `remediate.ps1` script to resolve the issue.
4. Optionally, include supporting scripts or documentation as needed.

## Best Practices
- Test scripts thoroughly before deployment.
- Ensure scripts are idempotent and safe to run multiple times.
- Document the purpose and logic of each script for future maintenance.

---
For more information on Intune Remediations, see the [Microsoft documentation](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/remediations).
