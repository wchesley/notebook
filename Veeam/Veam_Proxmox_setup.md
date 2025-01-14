[back](./README.md)

# Veeam to Proxmox Setup

> Note: 
> If you want to add a Proxmox VE **cluster** to backup infrastructure, consider this: 
> - Each node of the cluster must be added to backup infrastrucutre separately
> - The name of the cluster cannot be changed in Proxmox VE admin portal after added to backup infrastructure. 

## 1. Launch New Proxmox VE Server Wizard

1. Open Veeam Backup & Replication Console and sign into it. 
2. In the VBR Console, open the **Backup Infrastructure** view.
3. In the inventory pane, select **Managed Servers.**