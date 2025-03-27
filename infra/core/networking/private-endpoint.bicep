param location string
param vnetName string
param endpointSubnetId string
param resourceName string
param resourceType string
param privateDnsZoneName string
param groupId string
param prefix string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: 'ed-${prefix}'
  location: location
  properties: {
    subnet: {
      id: endpointSubnetId
    }
    customNetworkInterfaceName: 'nic-${prefix}'
    privateLinkServiceConnections: [
      {
        name: 'ed-${prefix}'
        properties: {
          privateLinkServiceId: resourceId(
            subscription().subscriptionId,
            resourceGroup().name,
            resourceType,
            resourceName
          )
          groupIds: [
            groupId
          ]
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: 'vn-links-${prefix}'
  parent: privateDnsZone
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: vnet.id
    }
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-03-01' = {
  name: 'dnszonegroups-${prefix}'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: replace(privateDnsZoneName, '.', '-')
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
