# Set up new company in Veeam Service Provider Console

Brief overview on how to setup a new company in VSPC. 

1. Sign into Veeam Service Provider console: https://vscp.ip:1280
2. Navigate to `Companies` in the left hand menu.
3. Click `New` at the top of the `Companies` page. 
4. Specify the following fields at a minimum for `Company Info`
   1. Company Name
   2. Login Alias (if company name is more than one word or has any special characters/spaces)
   3. Country
      1. After Selecting Country you may specify the State/Region. Set this to where the company is located. 
5. Click `Next`
6. Company Type: `Native` & click `Next
7. Specify Username, Password and set Site to `WGDC`.
   1. Save the username and password to Keeper, under `DC Accounts` and `DC Customers`. Choose the companies folder and add the credentials there; Create the folder if it does not exist already. 
8. Click `Next` to go to `Services`
9. Enable the following: 
   1.  Backup Agents Management
   2.  Backup Servers Management
   3.  Backup Resources
10. Click `Next` to go to `Billing`
    1.  Unless told otherwise, set billing to `Default Subscription Plan`
11. Click `Next` to go to `Bandwidth`
    1.  Do not change any settings here unless explicitly told to do so
12. Click `Next` to go to `Multi-Factor Authentication`
    1.  Leave the default setting enabled for `Enforce MFA for local users`
13. Click `Next` to go to `Notification`
    1.  Do not modify any settings
14. Click `Next` to go to `Summary`
    1.  Review the information you have entered and confirm everything is correct. 
15. Click `Finish` when you're ready to create the new Company. 

## Afterwards

When complete, you will need to setup backups on the client end to use the cloud repository. You will need the VSPC login credentials created in the previous steps to complete client side setup. Please see [VBR](./WGC-Setup.md) or [Agent](./WGC-Agent-Setup.md) setup guides for details on setting up either VBR server or installing Veeam agent for backup governance. 