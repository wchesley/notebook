<sub>[Back](./README.md)</sub>

# Windows Events

Windows Events are detailed records of system, security, and application activities stored by the operating system to aid in troubleshooting, monitoring, and auditing. Accessed via the Event Viewer tool (`eventvwr.msc`), these logs categorize data into Critical, Error, Warning, and Information levels to help identify root causes of failures or potential security breaches.

> [!NOTE]
> For a full list of windows events see [here](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/). This list is **not** managed or maintained by Microsoft. It **is** managed by a 3rd party.  

## Use Windows Event Viewer Review as an alternative to the attack surface
reduction rules reporting page in the Microsoft Defender portal

To review apps that would be blocked, open Event Viewer and filter 
for Event ID 1121 in the Microsoft-Windows-Windows Defender/Operational 
log. The following table lists all network protection events.

| Event ID | Description |
| --- | --- |
| 5007 | Event when settings are changed |
| 1121 | Event when an attack surface reduction rule fires in block mode |
| 1122 | Event when an attack surface reduction rule fires in audit mode |

## Logon Events

| Event ID | Description |
| --- | --- |
| 4625 | Failed Logon attempt | 
| 4648 | A logon was attempted using explicit credentials | 
| 4672 | Special Privileges assigned to new logon |
| 4740 | User account was locked out | 
| 4771 | Kerberos pre-auth failure |  
| 4774 | An account was mapped for logon | 
| 4775 | An account could not be mapped for logon | 
| 4776 | NTLM auth failure | 

## Event Details

<details>
    <summary>4771</summary>
    <p>This event is logged on domain controllers only and only failure instances of this event are logged.</p>
    <p>At the beginning of the day when a user sits down at his or her workstation and enters his domain username and password, the workstation contacts a local DC and requests a TGT. If the username and password are correct and the user account passes status and restriction checks, the DC grants the TGT and logs event ID  4768 (authentication ticket granted).</p>
    <p>If the ticket request fails Windows will either log this event, failure 4771, or 4768 if the problem arose during "pre-authentication".  In Windows Kerberos, password verification takes place during pre-authentication.</p>
    <p>The User field for this event (and all other events in the Audit account logon event category) doesn't help you determine who the user was; the field always reads N/A. Rather look at the Account Information: fields, which identify the user who logged on and the user account's DNS suffix. The User ID field provides the SID of the account. </p>
    <p>Windows logs other instances of event ID 4768 when a computer in the domain needs to authenticate to the DC typically when a workstation boots up or a server restarts. In these instances, you'll find a computer name in the User Name and fields. Computer generated kerberos events are always identifiable by the $ after the computer account's name.</p>
    <h4>Result Codes:</h4>
    <table>
        <tbody>
            <tr>
                <td valign="bottom"><b>Result code</b></td>
                <td valign="bottom"><b>Kerberos RFC description</b></td>
                <td valign="bottom"><b>Notes on common failure codes</b></td>
            </tr>
            <tr>
                <td valign="bottom">0x1</td>
                <td valign="bottom">Client's entry in database has expired</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x2</td>
                <td valign="bottom">Server's entry in database has expired</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x3</td>
                <td valign="bottom">Requested protocol version # not supported</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x4</td>
                <td valign="bottom">Client's key encrypted in old master key</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x5</td>
                <td valign="bottom">Server's key encrypted in old master key</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x6</td>
                <td valign="bottom">Client not found in Kerberos database</td>
                <td valign="bottom">Bad user name, or new computer/user account has not replicated to DC yet</td>
            </tr>
            <tr>
                <td valign="bottom">0x7</td>
                <td valign="bottom">Server not found in Kerberos database</td>
                <td valign="bottom">&nbsp;New computer account has not replicated yet or computer is pre-w2k</td>
            </tr>
            <tr>
                <td valign="bottom">0x8</td>
                <td valign="bottom">Multiple principal entries in database</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x9</td>
                <td valign="bottom">The client or server has a null key</td>
                <td valign="bottom">&nbsp;administrator should reset the password on the account</td>
            </tr>
            <tr>
                <td valign="bottom">0xA</td>
                <td valign="bottom">Ticket not eligible for postdating</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0xB</td>
                <td valign="bottom">Requested start time is later than end time</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0xC</td>
                <td valign="bottom">KDC policy rejects request</td>
                <td valign="bottom">Workstation restriction</td>
            </tr>
            <tr>
                <td valign="bottom">0xD</td>
                <td valign="bottom">KDC cannot accommodate requested option</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0xE</td>
                <td valign="bottom">KDC has no support for encryption type</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td>0xF</td>
                <td>KDC has no support for checksum type</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x10</td>
                <td>KDC has no support for padata type</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x11</td>
                <td>KDC has no support for transited type</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x12</td>
                <td>Clients credentials have been revoked</td>
                <td>Account disabled, expired,&nbsp;locked out, logon hours.</td>
            </tr>
            <tr>
                <td>0x13</td>
                <td>Credentials for server have been revoked</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x14</td>
                <td>TGT has been revoked</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x15</td>
                <td>Client not yet valid - try again later</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x16</td>
                <td>Server not yet valid - try again later</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x17</td>
                <td>Password has expired</td>
                <td>The user’s password has expired.</td>
            </tr>
            <tr>
                <td>0x18</td>
                <td>Pre-authentication information was invalid</td>
                <td>Usually means bad password</td>
            </tr>
            <tr>
                <td>0x19</td>
                <td>Additional pre-authentication required*</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x1F</td>
                <td>Integrity check on decrypted field failed</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>0x20</td>
                <td>Ticket expired</td>
                <td>Frequently logged by computer accounts</td>
            </tr>
            <tr>
                <td>0x21</td>
                <td>Ticket not yet valid</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x21</td>
                <td valign="bottom">Ticket not yet valid</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x22</td>
                <td valign="bottom">Request is a replay</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x23</td>
                <td valign="bottom">The ticket isn't for us</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x24</td>
                <td valign="bottom">Ticket and authenticator don't match</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x25</td>
                <td valign="bottom">Clock skew too great</td>
                <td valign="bottom">Workstation’s clock too far out of sync with the DC’s</td>
            </tr>
            <tr>
                <td valign="bottom">0x26</td>
                <td valign="bottom">Incorrect net address</td>
                <td valign="bottom">&nbsp;IP address change?</td>
            </tr>
            <tr>
                <td valign="bottom">0x27</td>
                <td valign="bottom">Protocol version mismatch</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x28</td>
                <td valign="bottom">Invalid msg type</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x29</td>
                <td valign="bottom">Message stream modified</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x2A</td>
                <td valign="bottom">Message out of order</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x2C</td>
                <td valign="bottom">Specified version of key is not available</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x2D</td>
                <td valign="bottom">Service key not available</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x2E</td>
                <td valign="bottom">Mutual authentication failed</td>
                <td valign="bottom">&nbsp;may be a memory allocation failure</td>
            </tr>
            <tr>
                <td valign="bottom">0x2F</td>
                <td valign="bottom">Incorrect message direction</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x30</td>
                <td valign="bottom">Alternative authentication method required*</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x31</td>
                <td valign="bottom">Incorrect sequence number in message</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x32</td>
                <td valign="bottom">Inappropriate type of checksum in message</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x3C</td>
                <td valign="bottom">Generic error (description in e-text)</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
            <tr>
                <td valign="bottom">0x3D</td>
                <td valign="bottom">Field is too long for this implementation</td>
                <td valign="bottom">&nbsp;</td>
            </tr>
        </tbody>
    </table>
</details>