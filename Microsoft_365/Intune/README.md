# Microsoft Intune Overview

Microsoft Intune is a cloud-based service that focuses on mobile device management (MDM) and mobile application management (MAM). It enables organizations to manage the devices and applications employees use to access corporate data, ensuring security and compliance while supporting productivity.

## Links

- [Filters](./Filters.md)
- [Remediations](./Remediations/README.md)
- [Compliance](./Compliance/README.md)

## Key Features

- **Device Management**: Enroll and manage Windows, macOS, iOS, and Android devices. Apply security policies, configure settings, and monitor compliance.
- **Application Management**: Deploy, update, and manage applications on user devices. Control access to corporate resources and data within apps.
- **Conditional Access**: Integrate with Azure Active Directory to enforce access controls based on device compliance and user identity.
- Compliance Policies: Define and enforce rules for device health, security settings, and software updates.
- Remediation: Automate detection and remediation of common security issues (e.g., BitLocker key backup, unquoted service paths).
- Reporting: Monitor device status, compliance, and security posture through dashboards and reports.

## Typical Use Cases

- Securing corporate data on personal and company-owned devices.
- Enforcing security baselines and compliance requirements.
- Automating remediation of vulnerabilities and misconfigurations.
- Managing software deployment and updates across diverse device fleets.

## Folder Structure

- [Compliance](./Compliance/README.md): Scripts and policies for device compliance management.
- [Remediations](./Remediations/README.md): Automated solutions for common security issues (e.g., BitLocker key backup, unquoted service paths).

# Getting Started

1. Set up Intune in the Microsoft Endpoint Manager admin center.
2. Enroll devices and assign users.
3. Configure compliance and security policies.
4. Deploy applications and monitor device health.
5. Use provided scripts and documentation for custom compliance and remediation tasks.

## References
- [Microsoft Intune Documentation](https://learn.microsoft.com/en-us/intune/intune-service/fundamentals/what-is-intune)
- [Microsoft Endpoint Manager](https://learn.microsoft.com/en-us/intune/endpoint-manager-overview)
