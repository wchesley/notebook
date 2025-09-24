# Intune Custom Compliance

This directory contains resources for implementing Microsoft Intune Custom Compliance policies, including a PowerShell script (`AutoincCompliance.ps1`) and a JSON compliance scheme (`ComplianceScheme.json`).

## Overview
Custom compliance policies in Intune allow organizations to evaluate device compliance using custom scripts and logic, beyond the built-in compliance settings. This is useful for scenarios where you need to check for specific configurations, registry values, or other requirements not natively supported by Intune.

## Files
- **AutoincCompliance.ps1**: PowerShell script that performs compliance checks on the device. The script should output a JSON object indicating compliance status and any additional information required by Intune.
- **ComplianceScheme.json**: Defines the compliance rules, expected output format, and mapping for the custom compliance policy. This file is referenced when configuring the policy in Intune.

## How to Set Up Intune Custom Compliance

### 1. Prepare Your Script and JSON
- Ensure your PowerShell script outputs a JSON object with the required properties (e.g., `IsCompliant`, `AdditionalInfo`).
- Define your compliance rules and output mapping in the JSON file.

### 2. Upload Script and JSON to Intune
- In the Microsoft Endpoint Manager admin center, go to **Devices > Compliance policies > Scripts**.
- Click **Add** and upload your PowerShell script.
- Provide the required parameters and configure the script settings (e.g., run frequency, user/system context).

### 3. Create a Custom Compliance Policy
- Go to **Devices > Compliance policies > Policies**.
- Click **Create Policy** and select **Custom Compliance**.
- Reference your uploaded script and JSON scheme.
- Configure the compliance settings and assign the policy to the desired device groups.

### 4. Monitor Compliance
- Devices will run the script as per the configured schedule.
- Compliance results are reported back to Intune and can be viewed in the admin center.

## Notes
- Scripts must be designed to run silently and efficiently, returning only the required output.
- The JSON scheme must match the output structure of your script.
- Administrative privileges may be required for some checks.
- Test your script and policy on a small group of devices before broad deployment.

## References
- [Microsoft Docs: Custom compliance settings in Intune](https://learn.microsoft.com/en-us/mem/intune/protect/compliance-policy-create-custom)
- [Intune PowerShell script requirements](https://learn.microsoft.com/en-us/mem/intune/apps/intune-management-extension)

---
For questions or improvements, open an [issue](https://github.com/wchesley/autoinc_Powershell/issues) on github, contact the script author ([Walker Chesley](mailto:walker.chesley@autoinc.com)) or your Intune administrator.