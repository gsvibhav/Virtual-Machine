using './main.bicep'

param azVMNicName = '${azComputerName}-nic'
param azVNetName = 'azbicep-dev-cus-vnet'
param azSubnets = [
  {
    Name: '${azVNetName}-vm'
    addressPrefix: '10.0.1.0/24'
  }
  {
    Name: 'AzureBastionSubnet'
    addressPrefix: '10.0.2.0/26'
  }
]

param azPublicIP = '${azComputerName}-IP'
param azNSGname = '${azComputerName}-nsg'
param azAdminPassword = az.getSecret(
  'c22406fc-dc85-4cc8-972f-ed18384cd693',
  'azbicep-dev-eastus-rg1',
  'az-bicep-keyvlt01',
  'azAdminPassword',
  'e14e79f54999473d9d5b80101ab29763'
)
param azAdminUserName = 'WindOwsAdmin'
param azComputerName = 'AppWorkload'
param azStorageAccountType = 'Premium_LRS'
param azVMSKU = '2019-Datacenter'
param azWindows2019VM = 'Windows2019VM'
param azvmSize = 'Standard_D2ds_v4'
param azAzureBastion = '${azVNetName}-bastion'
