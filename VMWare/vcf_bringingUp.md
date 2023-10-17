<h1 id="vmware-cloud-foundation-and-completed-bring-up">VMware Cloud Foundation and Completed Bring-Up</h1>
<p>VMware Cloud Foundation is a hybrid cloud platform combining the features of VMware vSphere, VMware vSAN, VMware NSX-T Data Center, vSphere with Tanzu, and VMware vRealize Suite. You manage VMware Cloud Foundation by using SDDC Manager and tools that might already be familiar to you as an administrator, such as the vSphere Client.</p>
<p><strong>Management Domain</strong><br><img src="/ui/assets/markdown/bringup-page/management-domain.svg" alt="The core components of the management domain are SDDC Manager, vCenter Server, ESXi, NSX-T Data Center, and vSAN. Additional solutions can be based on vRealize Suite." title="Management Domain"></p>
<p><strong>Enhanced Linked Mode</strong><br><img src="/ui/assets/markdown/bringup-page/enhanced-linked-mode.svg" alt="All workload domains in a VMware Cloud Foundation instances are connected to the same vCenter Single Sign-on domain and are in Enhanced Linked Mode." title="Enhanced Linked Mode"></p>
<h4 id="completed-bring-up">Completed Bring-Up</h4>
<p>The bring-up automation workflow has deployed a default workload domain, called the management domain, and has configured vCenter Server and a vCenter Single Sign-On domain, vSAN, NSX-T Data Center, SDDC Manager, and associated vSphere constructs to provide an initial standard platform for you to build your new hybrid cloud platform upon.</p>
<p><strong>VMware Cloud Foundation Detailed Architecture</strong><br><img src="/ui/assets/markdown/bringup-page/completed-bringup.svg" alt="completed-brinup.svg" title="VMware Cloud Foundation Detailed Architecture"></p>
<h4 id="learn-more">Learn More</h4>

<h1 id="common-terms-to-keep-in-mind">Common Terms to Keep in Mind</h1>
<h5 id="workload-domain">Workload Domain</h5>
<p>A policy-based resource container with specific availability and performance attributes that combines vSphere, storage (vSAN, NFS, VMFS on FC, or vVols) and networking (NSX-T Data Center) into a single consumable entity. A workload domain can be created, expanded, and deleted as part of the SDDC lifecycle operations. It can contain clusters of physical hosts with a corresponding vCenter Server instance to manage them. The vCenter Server and NSX Manager instances for a workload domain are physically located in the management domain.</p>
<h5 id="management-domain">Management Domain</h5>
<p>A cluster of physical hosts that contains the virtual machines of management components, such as vCenter Server, NSX-T Data Center, SDDC Manager, and so on.</p>
<h5 id="vi-workload-domain">VI Workload Domain</h5>
<p>One or more vSphere clusters that contain customer workloads. VMware Cloud Foundation scales and manages the lifecycle of each VI workload domain independently of the other domains. A VMware Cloud Foundation instance scales to 14 VI workload domains.</p>
<h5 id="bring-up">Bring-Up</h5>
<p>Deployment and initial configuration of a new VMware Cloud Foundation system. During the bring-up process, the management domain is created and the VMware Cloud Foundation software stack is deployed on the management domain.</p>
<h5 id="sddc-manager">SDDC Manager</h5>
<p>A software components that provisions, manages, and monitors the logical and physical resources of a VMware Cloud Foundation system. SDDC Manager provides a UI, administrator tools, and API for further automation within your organization.</p>
<h5 id="principal-storage">Principal Storage</h5>
<p>Required for every cluster. It contains the data of the virtual machines in this cluster. For the management domain, only vSAN principal storage is supported. For a VI workload domain, you set the principal storage when creating the domain or when adding a cluster to the domain. You cannot change the storage after the cluster is created.</p>
<h5 id="supplemental-storage">Supplemental Storage</h5>
<p>Added domain capacity to host more VMs or store supporting data, such as backups. You can add or remove supplemental storage to management or VI workload domain clusters after their creation.</p>
<h4 id="learn-more">Learn More</h4>

<h1 id="vmware-cloud-foundation-backup-strategy">VMware Cloud Foundation Backup Strategy</h1>
<p>Backing up management components ensures that you can keep your environment operational if a data loss or failure occurs. The logical constructs in VMware Cloud Foundation are created and controlled by the SDDC Manager appliance. The automation features of the platform depend on the availability of these constructs.</p>
<p><strong>Backup of Core Management Components</strong><br><img src="/ui/assets/markdown/backup-strategy-page/backup-core-management.svg" alt="You back up the core management components on an SFTP server." title="Backup of Core Management Components"></p>
<p><strong>Backup of Core Management Components and vRealize Suite</strong><br><img src="/ui/assets/markdown/backup-strategy-page/backup-core-management-with-vrealize.svg" alt="You back up the core management components on an SFTP server, and the additional vRealize Suite components on a system compliant with vSphere Storage API - Data Protection." title="Backup of Core Management Components and vRealize Suite"></p>
<h4 id="sddc-manager">SDDC Manager</h4>
<p>This component implements the logic, UI, and API to monitor and manage VMware Cloud Foundation components such as workload domains, capacity, and ESXi hosts. Back up this appliance to protect the cloud platform inventory and object status. You can use both image-based backups by using VMware vSphere Storage APIs - Data Protection and file-based backups to an external SFTP server.</p>
<h4 id="nsx-t-data-center">NSX-T Data Center</h4>
<p>By default, backups of SDDC Manager and NSX-T Data Center are stored in the SDDC Manager appliance. Change the destination of the backups to an external SFTP server.</p>
<h4 id="vcenter-server">vCenter Server</h4>
<p>Each workload domain is associated with one vCenter Server instance. ​Back up vCenter Server for full protection of the domain's inventory in addition to the inventory backup of SDDC Manager. Use the native tools provided with vCenter Server to perform file-level backups using the same external SFTP server as SDDC Manager and NSX-T Data Center.</p>
<h4 id="integration-with-your-maintenance-policy">Integration with Your Maintenance Policy</h4>
<p>If you accommodate VMware Cloud Foundation in the backup and restore policy in your organization, you protect the management components of the platform according to established best practices and schedule that satisfy the requirements of your business. Schedule backups outside infrastructure changes to ensure no automation workflows are running. </p>
<h4 id="learn-more">Learn More</h4>

<h1 id="vmware-cloud-foundation-operational-design-considerations">VMware Cloud Foundation Operational Design Considerations</h1>
<p>To comply with the automation model in VMware Cloud Foundation, you perform most operations in SDDC Manager. You interact with a management component directly only in a few cases.</p>
<p><strong>Operation Distribution according to Operation Scale</strong><br><img src="/ui/assets/markdown/operational-design-page/operation-distribution.svg" alt="operation-distribution.svg" title="Operation Distribution according to Scale"></p>
<h4 id="operational-strategy-for-vi-admins">Operational Strategy for VI Admins</h4>
<p>Use VMware Cloud Foundation for automation and consistency at scale in your organization. SDDC Manager contains the inventory of VMware Cloud Foundation and the automation workflows for the entire platform. Secure and maintain this system for a continuous service. SDDC Manager supports automated and standardized infrastructure changes, such as changing compute or storage capacity.  Although you can perform these changes in the products native user interface, the inventory and workflow object status in SDDC Manager might not be updated. This discrepancy might impact future automation tasks and result in an unexpected behavior. Perform day-to-day management of virtual machines directly on the workload domain vCenter Server but use SDDC Manager for infrastructure operations with a large scope.</p>
<h4 id="considerations-for-experienced-vi-admins">Considerations for Experienced VI Admins</h4>
<p>VMware Cloud Foundation is designed to support a prescribed set of configuration options according to the best practices for hybrid clouds.</p>
<p>Each VMware Cloud Foundation version has a Bill of Materials (BOM) that has been tested for interoperability and support and is described in detailed in the release notes.</p>
<p>Avoid performing manual infrastructure changes because they might cause unexpected behaviour or negatively impact the automation features. Use the automation workflows in the UI or API of SDDC Manager to perform Day-2 operations on the platform, such as host replacement, domain expansion and upgrade.</p>
<p>You can use additional license bundles for workload automation and monitoring by using vRealize Suite and vSphere with Tanzu.</p>
<h4 id="learn-more">Learn More</h4>
