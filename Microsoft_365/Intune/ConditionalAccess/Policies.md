<sub>[back](./README.md)</sub>

- [Policies](#policies)
    - [Device Code Auth Flow](#device-code-auth-flow)
    - [Require MFA for Admins](#require-mfa-for-admins)
- [References](#references)

# Policies

Modern security extends beyond an organization's network perimeter to include user and device identity. Organizations now use identity-driven signals as part of their access control decisions. Microsoft Entra Conditional Access brings signals together, to make decisions, and enforce organizational policies. Conditional Access is Microsoft's Zero Trust policy engine taking signals from various sources into account when enforcing policy decisions.

Conditional Access policies at their simplest are if-then statements: if a user wants to access a resource, then they must complete an action. For example: If a user wants to access an application or service like Microsoft 365, then they must perform multifactor authentication to gain access.

Admins are faced with two primary goals:

- Empower users to be productive wherever and whenever
- Protect the organization's assets

Use Conditional Access policies to apply the right access controls when needed to keep your organization secure and don't interfere with productivity.

### Device Code Auth Flow

> [!NOTE]
> To bolster security posture, Microsoft recommends blocking or restricting device code flow wherever possible.

```json
{
  "displayName": "GLOBAL - 1020 - BLOCK - Device Code Auth Flow",
  "state": "enabledForReportingButNotEnforced",
  "conditions": {
    "platforms": null,
    "userRiskLevels": [],
    "clientApplications": null,
    "times": null,
    "deviceStates": null,
    "users": {
      "includeGuestsOrExternalUsers": null,
      "includeGroups": [],
      "excludeGuestsOrExternalUsers": null,
      "includeUsers": [
        "All"
      ],
      "excludeUsers": [],
      "excludeGroups": [
        "Excluded from Conditional Access",
        "Excluded from Device Code Auth Flow Block"
      ],
      "excludeRoles": [],
      "includeRoles": []
    },
    "devices": null,
    "locations": null,
    "authenticationFlows": {
      "transferMethods": "deviceCodeFlow,authenticationTransfer"
    },
    "clientAppTypes": [
      "all"
    ],
    "applications": {
      "applicationFilter": null,
      "excludeApplications": [],
      "includeUserActions": [],
      "includeApplications": [
        "All"
      ],
      "includeAuthenticationContextClassReferences": []
    },
    "signInRiskLevels": []
  },
  "grantControls": {
    "operator": "OR",
    "builtInControls": [
      "block"
    ],
    "customAuthenticationFactors": [],
    "termsOfUse": [],
    "authenticationStrength": null
  },
  "sessionControls": null,
  "templateId": null
}
```

### Require MFA for Admins

```json
{
	"@odata.context": "https://graph.microsoft.com/beta/$metadata#identity/conditionalAccess/policies/$entity",
	"id": "35e08dc6-a055-400d-abf7-f2c81756432b",
	"templateId": null,
	"displayName": "CA4:Require MFA for admins",
	"createdDateTime": "2025-06-07T19:27:53.9045247Z",
	"modifiedDateTime": "2025-12-03T15:48:41.5131543Z",
	"state": "enabled",
	"deletedDateTime": null,
	"partialEnablementStrategy": null,
	"sessionControls": null,
	"conditions": {
		"userRiskLevels": [],
		"signInRiskLevels": [],
		"clientAppTypes": [
			"all"
		],
		"platforms": null,
		"locations": null,
		"times": null,
		"deviceStates": null,
		"devices": null,
		"clientApplications": null,
		"applications": {
			"includeApplications": [
				"All"
			],
			"excludeApplications": [],
			"includeUserActions": [],
			"includeAuthenticationContextClassReferences": [],
			"applicationFilter": null
		},
		"users": {
			"includeUsers": [],
			"excludeUsers": [
				"03964b9d-0dcb-4b7f-af02-14fa67f45046",
				"8c3c5f27-6f2a-4832-b88b-d152aad47a45",
				"5827ab16-6f10-4399-a64e-b4d1864291b6",
				"e56c85c5-a017-44f4-87ba-e1b650cddcab",
				"7ffbff26-6f20-45d5-a670-16f589decea4"
			],
			"includeGroups": [],
			"excludeGroups": [],
			"includeRoles": [
				"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3",
				"c4e39bd9-1100-46d3-8c65-fb160da0071f",
				"b0f54661-2d74-4c50-afa3-1ec803f12efe",
				"158c047a-c907-4556-b7ef-446551a6b5f7",
				"b1be1c3e-b65d-4f19-8427-f6fa0d97feb9",
				"29232cdf-9323-42fd-ade2-1d097af3e4de",
				"62e90394-69f5-4237-9190-012177145e10",
				"729827e3-9c14-49f7-bb1b-9608f156bbb8",
				"966707d0-3269-4727-9be2-8c3a10f19b9d",
				"7be44c8a-adaf-4e2a-84d6-ab2649e08a13",
				"194ae4cb-b126-40b2-bd5b-6091b380977d",
				"f28a1f50-f6e7-4571-818b-6a12f2af6b6c",
				"fe930be7-5e62-47db-91af-98c3a49a38b1",
				"0526716b-113d-4c15-b2c8-68e3c22b9f80",
				"fdd7a751-b60b-444a-984c-02652fe8fa1c",
				"4d6ac14f-3453-41d0-bef9-a3e0c569773a",
				"2b745bdf-0803-4d80-aa65-822c4493daac",
				"11648597-926c-4cf3-9c36-bcebb0ba8dcc",
				"e8611ab8-c189-46e8-94e1-60213ab1f814",
				"f023fd81-a637-4b56-95fd-791ac0226033",
				"69091246-20e8-4a56-aa4d-066075b2a7a8"
			],
			"excludeRoles": [],
			"includeGuestsOrExternalUsers": null,
			"excludeGuestsOrExternalUsers": null
		}
	},
	"grantControls": {
		"operator": "OR",
		"builtInControls": [
			"mfa"
		],
		"customAuthenticationFactors": [],
		"termsOfUse": [],
		"authenticationStrength@odata.context": "https://graph.microsoft.com/beta/$metadata#identity/conditionalAccess/policies('35e08dc6-a055-400d-abf7-f2c81756432b')/grantControls/authenticationStrength/$entity",
		"authenticationStrength": null
	}
}
```

# References

- [Daniel Chronlund Blog](https://danielchronlund.com/2020/11/26/azure-ad-conditional-access-policy-design-baseline-with-automatic-deployment-support/)