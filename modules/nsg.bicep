param azNSGname string
param azLocation string = resourceGroup().location

var nsg_rules = [
  {
    name: 'Allowport3389'
    properties: {
      description: 'Allows Inbound traffic on port 3389'
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '3389'
      sourceAddressPrefix: 'Internet'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 100
      direction: 'Inbound'
    }
  }
]

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: azNSGname
  location: azLocation
  properties: {
    securityRules: nsg_rules
  }
}
