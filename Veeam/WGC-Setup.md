# Veeam Setup - Westgate Computers

1. Install Veeam Backup and Replication to target server
   1. Ideally, Veeam should be the only thing installed to this server and it's only job is to run VBR. 
2. Accept most defaults when installing VBR except for the following
   1. Ensure use of PostgreSQL as the database, default since VBR 12
   2. Ensure Westgates License is used when installing VBR.
      1. VBR will prompt you to use community edition, sign in with veeam or browse for local file. Upload the Westgate Veeam license (Found in ProPartner portal or WG-DC sharepoint (Datacenter Documentation/Veeam/Licenses))
3. Add the computers to be backed up to VBR inventory
   1. Open VBR console
   2. Select `Physical Infrastructure` or `Virutal Infrastructure` depending on the machines being backed up. Most will be `Physical Infrastructure` unless running a hypervisor. 
   3. Create a protection group for the computers that are being backed up. 
      1. Name it after the site name plus `Protection Group` ie. `St Marys Protection Group`
   4. Add all of the machines that need to be backed up. Typically this is just the servers, but will vary from site to site. 
      1. For sites with Active Directory, use the Westgate account for backups. 
      2. For sites without Active Directory, create a dedicated account named `svc_veeam` to run Veeam under. 
4. Add the local NAS as backup repository to Veeam
   1. Open VBR console
   2. Select `Backup Infrastructure` in lower left of VBR console window
   3. Select `Backup Repositories` from the list in the middle left of VBR console window
   4. Select `Add Repository` from top ribbon menu
      1. Add NAS as SMB share
      2. Name the repository as `SiteName - Local` to denote it's for local backups. ie. `St Marys - Local`
      3. Add the shared folder of the NAS as `\\Ip.Addr.Of.NAS\VeeamBackups`
      4. Use the `backups` credentials in ITGlue to access this share
      5. Leave the remaining options at their defaults and continue through the wizard until completion
5. Add Data Center Cloud Repository to VBR
   1. Select `Backup Infrastructure` in VBR Console
   2. Select `Service Providers` from the middle left hand column of VBR console
   3. Click on `Add Service Provider` we have credentials for this already
   4. The Service Provider address is `vcc.wg-dc.com`
   5. Credentials for this are stored in Keeper or Veeam Service Provider Console. When in doubt, VSPC is the source of truth and you should update the password there, then update it in Keeper. 
      1. **No spaces in login name! **
6. Configure Backup Jobs
   1. Select `Inventory` in VBR console's lower left menu
   2. Right click on your protection group and click add to job -> windows job -> new job
   3. Configure the local backup job to run at 5pm, or just after customers close of business
      1. Name the job as `Sitename - local` ie. `St Marys Local`
      2. Store 7 restore points for local backups
      3. Ensure backup repository is set to site's local NAS
   4. Repeat process for off site backups
      1. Name the job as `Sitename - Offsite` ie. `St Marys Offsite`
      2. Store 14 restore points for offsite backups
      3. Ensure backup repository is set to Data Center's repository (added in step 5).

## Troubleshooting

Sentinel One will get in the way if this is a new deployment of VBR. Disable the agent on S1 prior to running the first backup job so that Veeam can enable `DC SAFEBOOT` mode on the machine. 

Example Error message:  
`9/11/2024 4:15:31 PM :: Error: Failed to enable DC SafeBoot mode Cannot execute [SetIntegerElement] method of [\\DC\root\wmi:BcdObject.Id="{3b9804b7-1375-11ef-9853-c45ab1c5811a}",StoreFilePath=""]. COM error:  Code: 0xd0000022`

Solution was found [here](https://forums.veeam.com/veeam-agent-for-windows-f33/veeam-support-case-03618764-t60205.html) though it's burried in the responses. Basically someone got with S1 support to create a Veeam group and added their servers to it. Disabling the agent on a temporary basis works too. 