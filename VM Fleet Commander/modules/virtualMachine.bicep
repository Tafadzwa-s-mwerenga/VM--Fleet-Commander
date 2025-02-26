param vmSize string
param vmCount int
param adminUsername string
param location string
param vnetName string
param subnetName string
param nsgName string


@secure()
param adminPassword string


resource virtualMachines 'Microsoft.Compute/virtualMachines@2021-07-01' = [for i in range(0, vmCount): {
  name: 'vm-${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'vm-${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', 'nic-${i}')
        }
      ]
    }
  }
}]

// Network Interfaces for VMs
resource networkInterfaces 'Microsoft.Network/networkInterfaces@2021-05-01' = [for i in range(0, vmCount): {
  name: 'nic-${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', nsgName)
    }
  }
}]
