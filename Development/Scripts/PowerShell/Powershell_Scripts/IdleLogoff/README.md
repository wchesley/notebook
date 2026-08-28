<sub>[back](../README.md)</sub>

# Idle Log Off

Script to log off users that have been logged into and not active on a PC for a given amount of time.

[IdleLogoff.ps1](./IdleLogoff.ps1) is meant to be run repeatedly (e.g. every 15 minutes) via a Scheduled Task
during an evening window (default 8 PM - midnight). On each run it checks every interactive session's idle
time via `quser` and logs off any session that has been idle longer than the configured threshold.

## How it works

Each run of the script:

1. Exits immediately if the current hour is before `-StartHour`.
2. Runs `quser` and parses the output to find every session (active or disconnected), its username, and its
   idle time.
3. Skips any username listed in `-ExcludeUsers`.
4. Logs off (via `logoff.exe`) any remaining session idle longer than `-ThresholdMinutes`.

Every session evaluated, and every logoff performed (or that would be performed under `-WhatIf`), is written
to `IdleLogoff.log` next to the script.

## Functions

| Function | Description |
| --- | --- |
| `Write-Log` | Writes a timestamped line to both the console and `IdleLogoff.log`. |
| `Convert-IdleTimeToMinutes` | Converts a `quser` idle time string (`.`, `mm`, `hh:mm`, or `days+hh:mm`) into a total number of minutes. |

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `-ThresholdMinutes` | int | `180` | Idle time in minutes before a session is logged off. |
| `-StartHour` | int | `20` | Hour (24h clock) after which the script is allowed to act. The script exits with no action before this hour. |
| `-ExcludeUsers` | string[] | `@()` | Usernames to never log off (e.g. a service or admin account). Case-insensitive. |
| `-WhatIf` | switch | off | Reports what would happen without actually logging anyone off. Use this to sanity-check parsing and thresholds before enabling for real. |

## Requirements

The script calls `logoff.exe` against sessions that may belong to other users, so it must run as a principal
with rights to log off other users' sessions. Running the Scheduled Task as `LOCAL SYSTEM` satisfies this.

## Setup

### Option A: Local Scheduled Task (single machine)

1. Copy `IdleLogoff.ps1` to a stable location on the target machine (e.g. `C:\Scripts\IdleLogoff\`).
2. Register a Scheduled Task to run it every 15 minutes, as `SYSTEM`, so it can act throughout the 8 PM -
   midnight window:

   ```powershell
   $action = New-ScheduledTaskAction -Execute 'powershell.exe' `
       -Argument '-NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\IdleLogoff\IdleLogoff.ps1"'

   $trigger = New-ScheduledTaskTrigger -Once -At 8pm `
       -RepetitionInterval (New-TimeSpan -Minutes 15) `
       -RepetitionDuration (New-TimeSpan -Hours 4)

   $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest

   Register-ScheduledTask -TaskName 'IdleLogoff' -Action $action -Trigger $trigger -Principal $principal
   ```

3. Adjust `-ThresholdMinutes`, `-StartHour`, and `-ExcludeUsers` in the task's `-Argument` as needed for the
   machine, e.g.:

   ```
   -File "C:\Scripts\IdleLogoff\IdleLogoff.ps1" -ThresholdMinutes 120 -ExcludeUsers 'svc_backup','admin'
   ```

### Option B: Group Policy (multiple machines)

To roll this out to an OU of machines instead of registering the task by hand on each one, deploy the script
and the scheduled task through Group Policy Preferences (GPP):

1. Create (or choose) a GPO scoped to the OU containing the target computers, e.g. `IdleLogoff Policy`.
2. **Deploy the script file** — under `Computer Configuration > Preferences > Windows Settings > Files`, add
   a new File item:
   - Action: `Update`
   - Source file: a network path readable by computer accounts, e.g.
     `\\<server>\<share>\IdleLogoff\IdleLogoff.ps1`
   - Destination file: `C:\Scripts\IdleLogoff\IdleLogoff.ps1`
3. **Deploy the scheduled task** — under
   `Computer Configuration > Preferences > Control Panel Settings > Scheduled Tasks`, add a new
   **Scheduled Task (At least Windows 7)** item mirroring Option A:
   - Action: `Create` (or `Replace` on subsequent edits)
   - General tab: Name `IdleLogoff`; run as `NT AUTHORITY\SYSTEM`; check **Run whether user is logged on or
     not** and **Run with highest privileges**.
   - Actions tab: Program `powershell.exe`, arguments
     `-NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\IdleLogoff\IdleLogoff.ps1" -ThresholdMinutes 180 -ExcludeUsers 'svc_backup'`
     (adjust parameters as needed).
   - Triggers tab: Daily, start time `8:00:00 PM`, repeat task every `15 minutes` for a duration of `4
     hours`.
4. Ensure the GPO is linked to the correct OU and that computer accounts have read access to the network
   share used in step 2.
5. Force a policy refresh on a test machine (`gpupdate /force`) and confirm the file and Scheduled Task were
   created before rolling out further.

## Running

Test first with `-WhatIf` to confirm parsing and thresholds behave as expected without logging anyone off:

```powershell
.\IdleLogoff.ps1 -WhatIf
```

Once verified, run without `-WhatIf` (or let the Scheduled Task run it) to actually log off idle sessions:

```powershell
.\IdleLogoff.ps1 -ThresholdMinutes 180 -StartHour 20 -ExcludeUsers 'svc_backup'
```

## Logging

Every run appends timestamped entries to `IdleLogoff.log` in the same directory as the script, covering:

- Runs skipped because it's before `-StartHour`.
- Runs with no active sessions reported.
- Any `quser` line that couldn't be parsed.
- Each session evaluated (session ID, username, state, idle time).
- Each exclusion, and each logoff (or would-be logoff under `-WhatIf`).
