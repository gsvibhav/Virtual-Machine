param azVMNicName string
param azVNetName string
param azSubnets array
param azPublicIP string
param azNSGname string
param azAzureBastion string

@secure()
param azAdminPassword string
param azAdminUserName string
param azComputerName string
param azStorageAccountType string
param azVMSKU string
param azWindows2019VM string
param azvmSize string

module VirtualNetwork 'modules/vnet.bicep' = {
  params: {
    azVMnicName: azVMNicName
    azVNetName: azVNetName
    subnets: azSubnets
    azPublicIP: azPublicIP
    azAzureBastion: azAzureBastion
  }
}

module NetworkSecurityGroup 'modules/nsg.bicep' = {
  params: {
    azNSGname: azNSGname
  }
}

module WindowsVirtualMachine 'modules/vm.bicep' = {
  params: {
    azAdminPassword: azAdminPassword
    azAdminUserName: azAdminUserName
    azComputerName: azComputerName
    azStorageAccountType: azStorageAccountType
    azVMNicId: VirtualNetwork.outputs.vmnicId
    azVMSKU: azVMSKU
    azWindows2019VM: azWindows2019VM
    azvmSize: azvmSize
  }
}
