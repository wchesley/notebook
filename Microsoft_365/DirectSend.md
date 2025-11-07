<sub>[Back](./README.md)</sub>

# DirectSend in O365

## What is Direct Send?

Direct Send is a feature in Exchange Online that allows devices and applications to send emails within a Microsoft 365 tenant **without authentication**. It uses a smart host with a format like: **tenantname.mail.protection.outlook.com**

This setup is intended for internal use only. But here’s the catch: 
no authentication is required. That means attackers don’t need 
credentials, tokens, or access to the tenant — just a few publicly 
available details.

**Identifying vulnerable organizations is trivial**. Smart host addresses follow a predictable format as shown above and internal email formats (like *first.last@company.com*) are often easy to guess or scrape from public sources, social media, or previous breaches.

Once a threat actor has the domain and a valid recipient, they can 
send spoofed emails that appear to originate from inside the 
organization, without ever logging in or touching the tenant. **This simplicity makes Direct Send an attractive and low-effort vector for phishing campaigns**.

## How attackers exploit Direct Send

In the campaign observed by our forensics experts, the attacker used 
PowerShell to send spoofed emails via the smart host. Here’s an example 
PowerShell command:

```ps1
Send-MailMessage -SmtpServer company-com.mail.protection.outlook.com -To joe@company.com -From joe@company.com -Subject "New Missed Fax-msg" -Body "You have received a call! Click on the link to listen to it. Listen Now" -BodyAsHtml
```

The email appears to come from a legitimate internal address, even though it was sent by an unauthenticated external actor.

### Why this method works:

- No login or credentials are required
- The smart host (e.g., *company-com.mail.protection.outlook.com*) accepts emails from any external source
- The only requirement is that the recipient is internal to the tenant
- The “From” address can be spoofed to any internal user

Because the email is routed through Microsoft’s infrastructure and 
appears to originate from within the tenant, it can bypass traditional 
email security controls, including:

- **Microsoft’s own filtering mechanisms**, which may treat the message as internal-to-internal traffic.
- **Third-party email security solutions**, which often rely on sender reputation, authentication results, or external routing patterns to flag suspicious messages.

## Detection: What to look for

To detect this kind of abuse, you’ll need to dig into message headers and behavioral signals:

Message header indicators:

- **Received headers**: Look for external IPs sent to the smart host.
- **Authentication-Results**: Failures in SPF, DKIM, or DMARC for internal domains.
- **X-MS-Exchange-CrossTenant-Id**: Should match your tenant ID.
- **SPF record:** Look for a smart host to be present.

Behavioral indicators:

- Emails sent from a user to themselves.
- PowerShell or other command-line user agents.
- Unusual IP addresses (e.g., VPNs, foreign geolocations).
- Suspicious attachments or filenames.

### How can I separate legitimate use from abuse?

Not all Direct Send usage in emails is malicious. Some legitimate use cases include:

- Automated notifications from internal tools.
- IT scripts sending alerts or reports.
- Third-party integrations (e.g., HR or marketing platforms).

That’s why context is key — don’t assume, validate.

## Prevention: What you can do to protect your org

- Enable “[Reject Direct Send](https://techcommunity.microsoft.com/blog/exchange/introducing-more-control-over-direct-send-in-exchange-online/4408790)” in the Exchange Admin Center.
- Implement a strict DMARC policy (e.g., p=reject).
- Flag unauthenticated internal emails for review or quarantine.
- Enforcing “SPF hardfail” within Exchange Online Protection (EOP).
- Use Anti-Spoofing policies.
- Educate users on the risks associated with QR code attachments (Quishing attacks).
- It’s always recommended to enforce MFA on all users and have
Conditional Access Policies in place, in case a user’s credentials are
stolen.
- Enforce a static IP address in the SPF record to prevent unwanted
send abuse — this is recommended by Microsoft but not required

# Tracking DirectSend

To overcome this blind spot, our blog shows you how to **identify Direct Send email activities**
 in your Exchange Online environment. This will help you detect 
suspicious emails sent using the Direct Send feature before they turn 
into security incidents.

## Why is Monitoring Direct Send Email Activities Important?

The simplicity and lack of security checks in Direct Send make it 
prime way for attackers to send fake voicemail alerts, invoices, 
payments requests, often attaching PDFs or QR codes that lead to 
phishing sites designed to steal users’ Microsoft 365 credentials. In 
addition, the mail relay endpoint follows predictable patterns, and 
common internal addresses such as *‘hr@contoso.com’* are easy to 
guess, making spoofing very simple. Therefore, monitoring Direct Send 
email activities helps detect misuse and allows early action to prevent 
breaches.

## How to Detect Emails Sent Through Direct Send in Exchange Online?

Currently Microsoft is working on a dedicated report for Direct Send 
traffic, giving admins a clear overview of which messages would be 
affected if the feature is blocked. Meanwhile, you can use the following
 methods to get all emails received without an inbound connector and 
spot the ones sent via Direct Send.

- [Review historical message trace report](https://blog.admindroid.com/how-to-check-exchange-online-direct-send-email-activities/#Review-Historical-Message-Trace-Report-to-List-All-Directly-Sent-Emails)
- [Leverage message trace in Exchange Online](https://blog.admindroid.com/how-to-check-exchange-online-direct-send-email-activities/#Find-Emails-Sent-via-Direct-Send-Using-Exchange-Online-Message-Trace)
- [Use Microsoft Defender advanced hunting](https://blog.admindroid.com/how-to-check-exchange-online-direct-send-email-activities/#Leverage-Advanced-Hunting-in-Microsoft-Defender-to-Review-Direct-Send-Emails)

**Review Historical Message Trace Report to List All Directly Sent Emails**

To find emails sent via Direct Send, you can run a historical message
 trace in Exchange Online to pull up email delivery logs from the last 
90 days. To do that,

- Navigate to the [**Exchange admin center](https://admin.exchange.microsoft.com/) > Reports > Mail flow** and select **Inbound messages report** from the list.
- Next, click on the **Request report** and modify the *Start & End date* based on your requirement.
- Click the *Recipients* dropdown and choose the desired recipients to receive the inbound message report.
- Then, ensure that **Received** and **No connector** are selected under *Directions* and *Connector type* appropriately.
- Finally, set TLS version to **No TLS** and hit **Request** to receive a report on all inbound emails received without a connector to identify Direct Send emails.

![Historical message trace in Exchange Online to check Direct Send email activities](https://blog.admindroid.com/wp-content/uploads/2025/08/Inbound-message-report-1024x551.png)

You can also use the following PowerShell cmdlet to perform the 
historical message trace on all inbound emails received without a 
connector.

```powershell
Start-HistoricalSearch -ReportTitle DirectSendMessages -StartDate <MM/DD/YYYY> -EndDate <MM/DD/YYYY> -ReportType ConnectorReport -ConnectorType NoConnector -Direction Received  -TLSUsed No Tls -NotifyAddress <YourEmailAddress>
```

---

Replace the place holders *<MM/DD/YYYY>* and *<YourEmailAddress>* with appropriate values before executing the cmdlet.

![Historical message trace report using PowerShell to identify Direct Send email activities](https://blog.admindroid.com/wp-content/uploads/2025/08/ConnectorReport_Inbound-1024x141.png)

## **Find Emails Sent via Direct Send Using Exchange Online Message Trace**

To identify emails sent using Direct Send, start by retrieving all 
internal messages sent to internal users using Exchange Online Message 
Trace V2. Then, review these emails for unexpected external IP addresses
 or subjects.

Run the message trace using the following PowerShell cmdlet by 
replacing the placeholders with your domain name, desired date range, 
and report export path.

```powershell
Get-MessageTraceV2 -SenderAddress "*@<YourDomain>.com" -RecipientAddress "*@<YourDomain>.com" -StartDate <MM/DD/YYYY> -EndDate <MM/DD/YYYY> | Export-CSV <OutputCSVFilePath> -NoTypeInformation -Encoding UTF8
```

Next, verify the suspected emails using the following cmdlet.

```powershell
Get-MessageTraceV2 -MessageId "<MessageID>" | Get-MessageTraceDetailV2 | Format-List
```

---

In the results, look for the **ConnectorName** field. If
 the field shows your expected connector name, the message was delivered
 through that connector. If it’s blank or different from the expected 
connector, the email was sent via Direct Send.

Then, validate those emails’ [SPF, DKIM, and DMARC](https://blog.admindroid.com/a-guide-to-spf-dkim-and-dmarc-to-prevent-spoofing/)
 records to confirm whether it is phishing emails or legitimate 
messages. The phishing emails sent via Direct Send will typically show **SPF=Fail** or **SoftFail**, **DKIM=none**, **DMARC=fail**, as these are strong indicators of spoofing or unauthenticated senders.

**Leverage Advanced Hunting in Microsoft Defender to Review Direct Send Emails**

You can use the advanced hunting feature in the Microsoft Defender 
portal to run Kusto Query Language (KQL) queries and get detailed 
insights into Direct Send emails across your organization.

- Login to the [Microsoft Defender admin center](https://security.microsoft.com/).
- Navigate to **Investigation & response > Hunting > Advanced hunting**.
- Enter the following KQL query under the ***Query*** field.

Defender Hunting Query: 

```powershell
EmailEvents
| where Timestamp > ago(30d)
| where EmailDirection == 'Inbound' and Connectors == '' and isnotempty(SenderIPv4)
| extend AuthenticationDetails = parse_json(AuthenticationDetails)
| where AuthenticationDetails.DMARC == "fail"
| project Timestamp, RecipientEmailAddress, SenderFromAddress, Subject, NetworkMessageId, EmailDirection, Connectors, SenderIPv4
```

---

- Finally, click **Run query** to find emails received
without an inbound connector that fail the DMARC check, helping you
quickly spot Direct Send messages in Microsoft 365.

![Using Microsoft Defender Advanced hunting to find Direct Send email activities](https://blog.admindroid.com/wp-content/uploads/2025/08/advanced-hunting-in-Microsoft-defender-1024x466.png)

## **Final Thoughts**

While Microsoft 365 offers multiple ways to detect and investigate 
emails sent via Direct Send, monitoring alone is not enough to stop the 
threat. The safest approach is to proactively block Direct Send emails. [Enabling Microsoft’s Reject Direct Send feature](https://blog.admindroid.com/how-to-enable-reject-direct-send-in-microsoft-365/)
 closes this loophole by blocking any anonymous messages sent from your 
own domain to your organization’s mailboxes that are not routed through 
an inbound connector. I hope this blog helped you identify email sent 
via Direct Send for better threat protection. If anything is unclear or 
you need help, feel free to ask in the comments.