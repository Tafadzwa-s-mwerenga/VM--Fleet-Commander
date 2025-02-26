// Parameters
param prefix string = 'vmfleet'
param environment string = 'dev'
param location string = 'southafricanorth'
param vmSize string = 'Standard_B2s'
param vmCount int = 2
param adminUsername string = 'tafadzwa'

@secure()
param adminPassword string

// Resource Group Module (Deployed at Subscription Scope)
module resourceGroup './modules/resourceGroup.bicep' = {
  name: '${prefix}-${environment}-resourceGroup'
  scope: subscription() // Fix scope to subscription
  params: {
    name: '${prefix}-${environment}-rg'
    location: location
  }
}

// Virtual Network Module
module virtualNetwork './modules/virtualNetwork.bicep' = {
  name: '${prefix}-${environment}-virtualNetwork'
  scope: resourceGroup(resourceGroup.outputs.name) // Reference the correct resource group
  params: {
    name: '${prefix}-${environment}-vnet'
    location: location
    addressPrefix: '10.1.0.0/16'
    subnetPrefix: '10.1.0.0/24'
  }
}

// Network Security Group Module
module networkSecurityGroup './modules/networkSecurityGroup.bicep' = {
  name: '${prefix}-${environment}-networkSecurityGroup'
  scope: resourceGroup(resourceGroup.outputs.name) // Reference the correct resource group
  params: {
    name: '${prefix}-${environment}-nsg'
    location: location
    allowedPorts: [
      22
      80
    ]
  }
}

// Virtual Machines Module
module virtualMachines './modules/virtualMachine.bicep' = {
  name: '${prefix}-${environment}-virtualMachines'
  scope: resourceGroup(resourceGroup.outputs.name) // Reference the correct resource group
  params: {
    vmSize: vmSize
    vmCount: vmCount
    adminUsername: adminUsername
    adminPassword: adminPassword
    location: location
    vnetName: virtualNetwork.outputs.name
    subnetName: 'default'
    nsgName: networkSecurityGroup.outputs.name
  }
}
