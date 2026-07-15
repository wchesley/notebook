# Phishing Incident Report

**Company:** AutoInc
**Classification:** Internal — Confidential
**Prepared using:** Microsoft Defender E5 • Arctic Wolf MDR • ThreatLocker
**Related document:** Incident Response Playbook: Phishing

> **How to use this template:** Complete every field. Enter `N/A` where a field does not apply and `Unknown` where information could not be determined. Replace all bracketed placeholders `[ ]`. Attach supporting evidence in the appendices.

---

## 1. Report Metadata

| Field | Detail |
|---|---|
| Incident ID | [e.g., IR-PHISH-2026-001] |
| Report title | [Short descriptive title] |
| Report status | <input type="checkbox"/> Draft  <input type="checkbox"/> Under review  <input type="checkbox"/> Final |
| Report version | [e.g., 1.0] |
| Date/time reported | [YYYY-MM-DD HH:MM TZ] |
| Date/time detected | [YYYY-MM-DD HH:MM TZ] |
| Date/time contained | [YYYY-MM-DD HH:MM TZ] |
| Date/time resolved/closed | [YYYY-MM-DD HH:MM TZ] |
| Prepared by | [Name, role] |
| Incident lead | [Name, role] |
| Reviewed/approved by | [Name, role] |
| Distribution list | [Recipients / groups] |

---

## 2. Executive Summary

Provide a concise, non-technical summary (5–10 sentences) suitable for leadership.

- **What happened:** [Brief description of the phishing incident.]
- **How it was detected:** [User report / Defender alert / Arctic Wolf escalation / ThreatLocker / other.]
- **Impact:** [Accounts, endpoints, data, financial, operational impact — or "no confirmed impact".]
- **Current status:** [Contained / Recovering / Closed.]
- **Key actions taken:** [Short summary of containment and remediation.]
- **Outstanding risk:** [Any residual risk or follow-up work.]

---

## 3. Incident Classification

| Field | Detail |
|---|---|
| Incident type | <input type="checkbox"/> Credential harvesting  <input type="checkbox"/> Malware delivery  <input type="checkbox"/> Spear phishing  <input type="checkbox"/> Whaling  <input type="checkbox"/> BEC  <input type="checkbox"/> AiTM/session-token theft  <input type="checkbox"/> Other: ______ |
| Final severity | <input type="checkbox"/> Low  <input type="checkbox"/> Medium  <input type="checkbox"/> High  <input type="checkbox"/> Critical |
| Initial severity | <input type="checkbox"/> Low  <input type="checkbox"/> Medium  <input type="checkbox"/> High  <input type="checkbox"/> Critical |
| Confirmed vs. suspected | <input type="checkbox"/> Confirmed incident  <input type="checkbox"/> Suspected/unconfirmed  <input type="checkbox"/> False positive |
| Campaign vs. targeted | <input type="checkbox"/> Broad campaign  <input type="checkbox"/> Targeted  <input type="checkbox"/> Unknown |
| Attacker objective (assessed) | [Credential theft / fraud / malware / data exfiltration / unknown] |
| Regulated/sensitive data involved | <input type="checkbox"/> Yes  <input type="checkbox"/> No  <input type="checkbox"/> Unknown — Detail: ______ |
| Related incidents | [Linked incident IDs, if any] |

---

## 4. Affected Scope

### 4.1 Affected Users / Mailboxes

| User / Mailbox | Department | Interaction (received/clicked/opened/credentials) | Account compromised? | Notes |
|---|---|---|---|---|
| [name] | [dept] | [interaction] | [Yes/No/Unknown] | [notes] |

### 4.2 Affected Endpoints

| Device name | Primary user | OS | Compromise confirmed? | Action taken (Isolate/Lockdown/Reimage) | Notes |
|---|---|---|---|---|---|
| [device] | [user] | [OS] | [Yes/No/Unknown] | [action] | [notes] |

### 4.3 Affected Systems / Applications / Data

| System / App / Data set | Type | Impact | Notes |
|---|---|---|---|
| [item] | [M365 / SaaS / file share / other] | [access / exposure / none] | [notes] |

### 4.4 Scope Summary

- Total recipients: [number]
- Recipients who interacted: [number]
- Confirmed compromised accounts: [number]
- Affected endpoints: [number]
- Business units impacted: [list]

---

## 5. Phishing Message Details

| Field | Detail |
|---|---|
| Sender display name | [display name] |
| Sender address | [address] |
| Reply-to | [address] |
| Return-path | [address] |
| Sending IP / infrastructure | [IP / host] |
| Subject line | [subject] |
| Date/time first delivered | [YYYY-MM-DD HH:MM TZ] |
| Message-ID | [message-id] |
| SPF / DKIM / DMARC result | [pass/fail/unknown] |
| Delivery location (inbox/junk/quarantine) | [location] |
| ZAP status | [succeeded/failed/N/A] |
| Detection technology | [Safe Links / URL reputation / detonation / user report / other] |
| Lure/theme | [password reset, invoice, HR, delivery, executive request, etc.] |
| Message body summary | [brief description] |

---

## 6. Indicators of Compromise (IOCs)

### 6.1 Email & Network IOCs

| Type | Value | Source | Notes |
|---|---|---|---|
| Sender address | [value] | [source] | [notes] |
| URL / domain | [value] | [source] | [notes] |
| Sending IP | [value] | [source] | [notes] |
| Redirect/final domain | [value] | [source] | [notes] |

### 6.2 File IOCs

| Filename | Hash (SHA256) | Verdict | Source | Notes |
|---|---|---|---|---|
| [filename] | [hash] | [malicious/suspicious/clean] | [VirusTotal/Defender/etc.] | [notes] |

### 6.3 Identity / Endpoint IOCs

| Type | Value | Notes |
|---|---|---|
| Suspicious sign-in IP | [value] | [notes] |
| User agent / device | [value] | [notes] |
| Mailbox rule created | [value] | [notes] |
| Process / command line | [value] | [notes] |
| OAuth app / consent grant | [value] | [notes] |

---

## 7. Incident Timeline

Record all key events in chronological order (use a consistent time zone).

| # | Date/Time (TZ) | Event / Action | Actor (person/tool) | Source / Reference |
|---:|---|---|---|---|
| 1 | [timestamp] | [Phishing email delivered] | [attacker] | [message trace] |
| 2 | [timestamp] | [Detected via ___] | [source] | [alert/ticket ID] |
| 3 | [timestamp] | [Triage started] | [analyst] | [ticket] |
| 4 | [timestamp] | [Containment action ___] | [analyst/admin] | [tool] |
| 5 | [timestamp] | [Eradication ___] | [analyst] | [tool] |
| 6 | [timestamp] | [Recovery ___] | [admin] | [tool] |
| 7 | [timestamp] | [Incident closed] | [lead] | [ticket] |

---

## 8. Detection & Analysis

### 8.1 Detection

- **Detection source:** [User report / Defender for Office 365 / Defender XDR / Arctic Wolf MDR / ThreatLocker / Identity Protection / other.]
- **Alert / incident IDs:** [Defender incident #, Arctic Wolf case #, ticket #.]
- **Initial triage findings:** [Summary of the first 15-minute triage.]

### 8.2 Investigation Summary

- **Email analysis (Defender for Office 365):** [Attack story, email entity, delivery/ZAP status, headers.]
- **Message trace / recipient enumeration:** [All recipients, delivery locations, variants.]
- **Identity investigation (Entra ID / Defender for Identity):** [Sign-in review, risky sign-ins, MFA changes, mailbox rules, OAuth grants.]
- **Endpoint investigation (Defender for Endpoint / ThreatLocker):** [Device timeline, blocked executions, process tree, hunted IOCs.]
- **Enterprise hunt (Arctic Wolf / Advanced Hunting):** [Correlated telemetry, historical matches.]
- **Root cause:** [How the attack succeeded or reached the user.]

---

## 9. Containment, Eradication & Recovery

### 9.1 Containment Actions

| Action | Tool | Performed by | Date/Time | Result |
|---|---|---|---|---|
| Disable account | Entra ID | [name] | [timestamp] | [result] |
| Revoke sessions/tokens | Entra ID | [name] | [timestamp] | [result] |
| Isolate/Lockdown endpoint | ThreatLocker / Defender | [name] | [timestamp] | [result] |
| Block sender/domain/URL | Defender / EOP | [name] | [timestamp] | [result] |

### 9.2 Eradication Actions

| Action | Tool | Performed by | Date/Time | Result |
|---|---|---|---|---|
| Purge malicious email (all mailboxes) | Defender for Office 365 | [name] | [timestamp] | [result] |
| Remove mailbox rules/forwarding | Exchange Online | [name] | [timestamp] | [result] |
| Remove malware / reimage | Defender / ThreatLocker | [name] | [timestamp] | [result] |
| Revoke OAuth grants | Entra ID | [name] | [timestamp] | [result] |

### 9.3 Recovery Actions

| Action | Tool | Performed by | Date/Time | Validation |
|---|---|---|---|---|
| Reset password | Entra ID / AD | [name] | [timestamp] | [validated?] |
| Re-register MFA | Entra ID | [name] | [timestamp] | [validated?] |
| Re-enable account | Entra ID | [name] | [timestamp] | [validated?] |
| Return endpoint to service | ThreatLocker / Defender | [name] | [timestamp] | [validated?] |

### 9.4 External Support

- **Arctic Wolf involvement:** [Escalation, managed investigation, guided remediation — case #.]
- **ThreatLocker Cyber Hero involvement:** [Any MDR actions taken.]
- **Third-party / law enforcement / vendor takedown:** [Details, if any.]

---

## 10. Impact Assessment

| Impact Area | Assessment | Detail |
|---|---|---|
| Confidentiality (data exposure) | [None/Low/Medium/High] | [detail] |
| Integrity (data/system changes) | [None/Low/Medium/High] | [detail] |
| Availability (downtime) | [None/Low/Medium/High] | [detail] |
| Financial | [None/estimated $] | [detail] |
| Operational / business | [None/Low/Medium/High] | [detail] |
| Reputational | [None/Low/Medium/High] | [detail] |
| Regulatory / compliance | [None/possible/confirmed] | [detail] |

---

## 11. Notifications & Communications

| Audience | Notified? | Date/Time | Method | Notes |
|---|---|---|---|---|
| Affected users | [Yes/No] | [timestamp] | [email/call] | [notes] |
| IT / Security leadership | [Yes/No] | [timestamp] | [method] | [notes] |
| Executive management | [Yes/No] | [timestamp] | [method] | [notes] |
| Legal / Compliance / Privacy | [Yes/No] | [timestamp] | [method] | [notes] |
| Affected customers / partners | [Yes/No] | [timestamp] | [method] | [notes] |
| Regulators / authorities | [Yes/No] | [timestamp] | [method] | [notes] |

**Regulatory/legal obligations assessed:** <input type="checkbox"/> Yes  <input type="checkbox"/> No — Detail: [ ]

---

## 12. Root Cause & Contributing Factors

- **Primary root cause:** [e.g., user entered credentials on a spoofed page; ZAP did not remove message; control gap.]
- **Contributing factors:** [Control gaps, configuration weaknesses, awareness gaps, process delays.]
- **What worked well:** [Effective detections, fast containment, good escalation.]
- **What did not work / slowed response:** [Gaps, delays, tooling/access issues.]

---

## 13. Lessons Learned & Recommendations

| # | Recommendation | Type (People/Process/Technology) | Priority | Owner | Due Date | Status |
|---:|---|---|---|---|---|---|
| 1 | [e.g., tighten Conditional Access for high-risk users] | Technology | High | [owner] | [date] | [Open/In progress/Done] |
| 2 | [e.g., targeted user awareness training] | People | Medium | [owner] | [date] | <input type="checkbox"/> |
| 3 | [e.g., tune Defender anti-phishing policy] | Technology | Medium | [owner] | [date] | <input type="checkbox"/> |
| 4 | [e.g., update playbook step ___] | Process | Low | [owner] | [date] | <input type="checkbox"/> |

---

## 14. Closure

| Closure Criteria | Met? | Notes |
|---|---|---|
| Scope fully validated | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Malicious email removed/contained | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Compromised accounts recovered | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Affected endpoints recovered/rebuilt | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| IOCs blocked or monitored | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Evidence stored | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Stakeholders informed | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Lessons learned documented | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |
| Follow-up actions assigned with owners/dates | <input type="checkbox"/> Yes  <input type="checkbox"/> No | [notes] |

**Final disposition:** 

<input type="checkbox"/> Resolved  <input type="checkbox"/> Closed  <input type="checkbox"/> Closed - False positive  <input type="checkbox"/> Transferred to [malware/ransomware/BEC] process

**Incident lead sign-off:** [Name] — [Date]
**Reviewer/approver sign-off:** [Name] — [Date]

---

## 15. Appendices

- **Appendix A — Evidence Inventory:** [List of collected evidence: email samples, headers, screenshots, logs, exports, and storage location.]
- **Appendix B — Full IOC List / Export:** [Attach or reference complete IOC export.]
- **Appendix C — Tool Outputs:** [Defender incident export, Arctic Wolf report, ThreatLocker event log, message trace, sign-in logs.]
- **Appendix D — Communications Sent:** [Copies of notifications and stakeholder updates.]
- **Appendix E — References:** [Playbook, related tickets, external references.]

---

*This report is an internal AutoInc security document and should be handled according to the organization's data classification and retention policies.*