# Configuration Manager Deployment Checklist (Hybrid Cloud Environment)

To be used with [ConfigMgr](./ConfigMgr.md) document.

## Phase 1: Lab Environment Setup

### Infrastructure Preparation

- [ ]  Prepare Windows Server (2016 or later) for site server
- [ ]  Install required Windows roles/features (IIS, .NET Framework 4.8, BITS, etc.)
- [ ]  Assign static IP and ensure DNS resolution
- [ ]  Open required firewall ports (e.g., TCP 1433 for SQL, ConfigMgr ports)

### Active Directory Configuration

- [ ]  Extend AD schema using extadsch.exe
- [ ]  Verify schema extension via ExtADSch.log
- [ ]  Create "System Management" container in AD
- [ ]  Delegate Full Control to site server’s computer account on the container

### SQL Server Setup

- [ ]  Install supported SQL Server version (e.g., 2019/2022)
- [ ]  Use collation: SQL*Latin1*General*CP1*CI_AS
- [ ]  Enable SQL Server Browser (if using named instance)
- [ ]  Configure service accounts and permissions
- [ ]  Open SQL ports (TCP 1433, UDP 1434 if needed)

### Additional Tools

- [ ]  Install Windows ADK (matching Windows version)
- [ ]  Install WinPE add-on
- [ ]  Install WSUS role (optional, for Software Update Point)

### Configuration Manager Installation

- [ ]  Launch Splash.hta or Setup.exe from ConfigMgr media
- [ ]  Run prerequisite checker and resolve any issues
- [ ]  Choose “Install a Configuration Manager Primary Site”
- [ ]  Provide Site Code and Site Name
- [ ]  Configure SQL Server and database settings
- [ ]  Choose HTTP or Enhanced HTTP (PKI optional)
- [ ]  Complete installation and verify site roles

### Post-Install Configuration

- [ ]  Enable AD Discovery Methods (User, System, Forest)
- [ ]  Create Boundary Groups and assign site systems
- [ ]  Configure Client Push Installation settings
- [ ]  Distribute client installation package to Distribution Point
- [ ]  Deploy client to lab machines and verify registration

---

## Phase 2: Cloud Integration and Co-Management

### Entra ID and Intune Setup

- [ ]  Configure Microsoft Entra Connect for Hybrid Join
- [ ]  Verify device registration using dsregcmd /status
- [ ]  Set MDM user scope in Entra ID > Mobility > Intune
- [ ]  Enable auto-enrollment for domain-joined devices

### ConfigMgr Cloud Attach

- [ ]  Launch Cloud Attach wizard in ConfigMgr console
- [ ]  Authenticate with Entra ID global admin
- [ ]  Choose Pilot collection for co-management
- [ ]  Enable Endpoint Analytics and Tenant Attach (optional)
- [ ]  Verify co-managed status in ConfigMgr and Intune

---

## Phase 3: Pilot Deployment

### Pilot Group Rollout

- [ ]  Identify pilot users/devices (Windows 10/11/Server)
- [ ]  Add devices to co-management pilot collection
- [ ]  Deploy ConfigMgr client to pilot devices
- [ ]  Monitor client health and registration

### Functional Testing

- [ ]  Test application deployment
- [ ]  Test software update deployment
- [ ]  Verify inventory and reporting
- [ ]  Monitor site and component status

---

## Phase 4: Full Production Rollout

### Production Deployment

- [ ]  Plan deployment waves (by department/site)
- [ ]  Deploy additional Distribution Points (if needed)
- [ ]  Update Boundary Groups and site system associations
- [ ]  Monitor client onboarding and health

### Workload Transition

- [ ]  Decide which workloads to shift to Intune
- [ ]  Use co-management slider to move workloads (e.g., Compliance, Updates)
- [ ]  Monitor for policy conflicts and resolve

---

## Ongoing Maintenance

### Daily Tasks

- [ ]  Monitor site server health (CPU, memory, disk)
- [ ]  Check Site Status and Component Status
- [ ]  Review Distribution and Deployment status
- [ ]  Verify Client Health Dashboard
- [ ]  Confirm Backup Site Server task ran successfully
- [ ]  Check WSUS sync and ADR status

### Weekly Tasks

- [ ]  Clean up IIS logs and old files
- [ ]  Review SQL database growth and indexing
- [ ]  Archive and truncate logs
- [ ]  Defragment disks (if not SSD)

### Monthly Tasks

- [ ]  Apply ConfigMgr and OS updates
- [ ]  Run WSUS cleanup and re-index
- [ ]  Review and clean up collections and task sequences
- [ ]  Rotate service account passwords (if applicable)
- [ ]  Test backup recovery process

---

Let me know if you'd like this checklist exported into a spreadsheet or formatted for documentation templates.