
param name string
param location string
param allowedPorts array

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: name
  location: location
  properties: {
    securityRules: [
      for port in allowedPorts: {
        name: 'allow-port-${port}'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '${port}'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000 + port
          direction: 'Inbound'
        }
      }
    ]
  }
}

output name string = networkSecurityGroup.name
