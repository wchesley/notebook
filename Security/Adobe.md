<sub>[back](./README.md)</sub>

# Adobe - Hardening and Security Recommendations

## Disable Flash on Adobe Reader DC

Set a registry value to determine if Adobe Reader will render Flash content. Flash is an unsecure, outdated, and no longer supported technology with many known vulnerabilities, it is recommended to avoid using it.

Set the following registry value:
`HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bEnableFlash`
To the following `REG_DWORD` value: `0`

## Disable JavaScript on Adobe Reader DC

Set a registry value to determine if Adobe Reacer will allow JavaScript execution. JavaScript could potentially be used by attackers to manipulate users or to execute undesired code locally.

Set the following registry value:
`HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bDisableJavaScript`
To the following `REG_DWORD` value: `1`