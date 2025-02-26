targetScope = 'subscription'

@description('The name of the resource group to create.')
param name string

@description('The location of the resource group.')
param location string

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
}

// optional //

@description('The name of the created resource group.')
output name string = resourceGroup.name
