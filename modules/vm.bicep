param azWindows2019VM string
param azLocation string = resourceGroup().location
param azvmSize string
param azComputerName string
param azAdminUserName string
@secure()
param azAdminPassword string
param azStorageAccountType string
param azVMSKU string
param azVMNicId string

resource windowsVM 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: azWindows2019VM
  location: azLocation
  properties: {
    hardwareProfile: {
      vmSize: azvmSize
    }
    osProfile: {
      computerName: azComputerName
      adminUsername: azAdminUserName
      adminPassword: azAdminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: azVMSKU
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: azStorageAccountType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: azVMNicId
        }
      ]
    }
  }
}
