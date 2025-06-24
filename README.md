Azure Virtual Machine Infrastructure
An Azure Bicep Infrastructure as Code (IaC) project for deploying Windows Server virtual machines with secure network configuration and Azure Bastion access.
🏗️ Architecture Overview
This project deploys a complete Azure infrastructure stack including:

Windows Server 2019 Virtual Machine with premium SSD storage
Virtual Network (VNet) with dedicated subnets for VM and Bastion
Azure Bastion for secure RDP access without exposing VM to internet
Network Security Group (NSG) with configured security rules
Public IP Address for Bastion connectivity

Architecture Diagram
mermaidgraph TB
    subgraph "Azure Subscription"
        subgraph "Resource Group"
            subgraph "Virtual Network (10.0.0.0/16)"
                subgraph "VM Subnet (10.0.1.0/24)"
                    VM[🖥️ Windows Server 2019<br/>Standard_D2ds_v4<br/>Premium SSD]
                    NIC[📡 Network Interface<br/>Private IP: Dynamic]
                end
                
                subgraph "AzureBastionSubnet (10.0.2.0/26)"
                    BASTION[🔐 Azure Bastion<br/>Secure RDP Access]
                end
            end
            
            PIP[🌐 Public IP Address<br/>Static IP<br/>Standard SKU]
            NSG[🛡️ Network Security Group<br/>Allow RDP (3389)]
            KV[🔑 Azure Key Vault<br/>Admin Password Storage]
        end
    end
    
    USER[👤 User<br/>Browser/Portal]
    INTERNET[🌍 Internet]
    
    %% Connections
    USER --> INTERNET
    INTERNET --> PIP
    PIP --> BASTION
    BASTION -.->|Secure RDP| VM
    NIC --> VM
    NSG --> NIC
    KV -.->|Retrieve Secret| VM
    
    %% Styling
    classDef vmClass fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef networkClass fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef securityClass fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef userClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    
    class VM,NIC vmClass
    class BASTION,PIP networkClass
    class NSG,KV securityClass
    class USER userClass
Resource Flow

User connects through Azure Portal/Browser
Traffic routes through Public IP to Azure Bastion
Bastion provides secure RDP access to VM (no direct internet exposure)
VM operates within private subnet with NSG protection
Credentials securely retrieved from Key Vault during deployment

📋 Prerequisites

Azure CLI installed and configured
Azure subscription with appropriate permissions
Azure Key Vault for storing admin password securely
Bicep CLI (installed with Azure CLI 2.20.0+)

🚀 Quick Start
1. Clone the Repository
bashgit clone https://github.com/gsvibhav/Virtual-Machine.git
cd Virtual-Machine
2. Configure Parameters
Update the main.bicepparam file with your specific values:
bicepparam azAdminUserName = 'YourAdminUsername'
param azComputerName = 'YourVMName'
param azvmSize = 'Standard_D2ds_v4'  // Adjust VM size as needed
3. Deploy Infrastructure
bash# Login to Azure
az login

# Set your subscription
az account set --subscription "your-subscription-id"

# Create resource group
az group create --name "your-resource-group" --location "Central US"

# Deploy the infrastructure
az deployment group create \
  --resource-group "your-resource-group" \
  --template-file main.bicep \
  --parameters main.bicepparam
📁 Project Structure
Virtual-Machine/
├── main.bicep              # Main orchestration template
├── main.bicepparam         # Parameter file with configuration
└── modules/
    ├── vm.bicep           # Virtual Machine module
    ├── vnet.bicep         # Virtual Network and Bastion module
    └── nsg.bicep          # Network Security Group module
🔧 Configuration Details
Virtual Machine Specifications

OS: Windows Server 2019 Datacenter
Size: Standard_D2ds_v4 (2 vCPUs, 8GB RAM)
Storage: Premium SSD (Premium_LRS)
Network: Private IP with Azure Bastion access

Network Configuration

VNet Address Space: 10.0.0.0/16
VM Subnet: 10.0.1.0/24
Bastion Subnet: 10.0.2.0/26 (AzureBastionSubnet)

Security Features

Azure Bastion: Eliminates need for public IP on VM
NSG Rules: Configured for RDP access (port 3389)
Key Vault Integration: Secure password management
Automatic Updates: Enabled for Windows VM

🔐 Security Considerations
Password Management
The admin password is securely retrieved from Azure Key Vault:
bicepparam azAdminPassword = az.getSecret(
  'subscription-id',
  'resource-group',
  'key-vault-name',
  'secret-name',
  'secret-version'
)
Network Security

VM has no direct internet access (no public IP)
All remote access through Azure Bastion
NSG rules configured for necessary traffic only

📝 Parameters Reference
ParameterDescriptionDefault ValueazVMNicNameNetwork interface name${azComputerName}-nicazVNetNameVirtual network nameazbicep-dev-cus-vnetazComputerNameVM computer nameAppWorkloadazAdminUserNameVM admin usernameWindOwsAdminazvmSizeVM size/SKUStandard_D2ds_v4azStorageAccountTypeDisk storage typePremium_LRSazVMSKUWindows Server SKU2019-Datacenter
🔄 Deployment Commands
Validate Template
bashaz deployment group validate \
  --resource-group "your-resource-group" \
  --template-file main.bicep \
  --parameters main.bicepparam
Preview Changes
bashaz deployment group what-if \
  --resource-group "your-resource-group" \
  --template-file main.bicep \
  --parameters main.bicepparam
Deploy Infrastructure
bashaz deployment group create \
  --resource-group "your-resource-group" \
  --template-file main.bicep \
  --parameters main.bicepparam
🔌 Connecting to the VM

Navigate to Azure Portal
Go to your Virtual Machine resource
Click "Connect" → "Bastion"
Enter your admin credentials
Connect securely through the browser

🧹 Cleanup
To remove all deployed resources:
bashaz group delete --name "your-resource-group" --yes --no-wait
🤝 Contributing

Fork the repository
Create a feature branch (git checkout -b feature/improvement)
Commit your changes (git commit -am 'Add improvement')
Push to the branch (git push origin feature/improvement)
Create a Pull Request

📄 License
This project is open source and available under the MIT License.
📧 Support
For questions or issues, please open an issue in this repository or contact the maintainer.

Built with ❤️ using Azure Bicep
