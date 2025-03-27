metadata description = 'Creates a virtual network subnets.'
param name string
param location string = resourceGroup().location
param tags object = {}
param addressPrefix string

// https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-private-endpoints?tabs=arm-bicep
resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
  }
}

output id string = vnet.id
output name string = vnet.name
