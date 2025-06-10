param azVNetName string
param azLocation string = resourceGroup().location

param subnets array

param azVMnicName string
param azPublicIP string
param azAzureBastion string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: azVNetName
  location: azLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.Name
        properties: {
          addressPrefix: subnet.addressPrefix
        }
      }
    ]
  }
}

resource BastionPublicIPaddress 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: azPublicIP
  location: azLocation
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
  sku: {
    name: 'Standard'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: azVMnicName
  location: azLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
          // publicIPAddress: {
          //   id: PublicIPaddress.id
          // }
        }
      }
    ]
  }
}

resource AzureBastion 'Microsoft.Network/bastionHosts@2024-07-01' = {
  name: azAzureBastion
  location: azLocation
  properties: {
    ipConfigurations: [
      {
        name: 'Azure-Bastion'
        properties: {
          subnet: {
            id: virtualNetwork.properties.subnets[1].id
          }
          publicIPAddress: {
            id: BastionPublicIPaddress.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
  sku: {
    name: 'Basic'
  }
}

output vNetId string = virtualNetwork.id
output vmSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', azVNetName, '${azVNetName}-vm')
output vmnicId string = nic.id
output azBastionId string = AzureBastion.id
