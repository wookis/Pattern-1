param vnetName string
param subnetName string
param addressPrefix string
param delegationService string = ''
param privateEndpointNetworkPolicies string = ''

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefixes: [addressPrefix]
    delegations: delegationService != ''
      ? [
          {
            name: 'delegation'
            properties: {
              serviceName: delegationService
            }
          }
        ]
      : []
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies != '' ? privateEndpointNetworkPolicies : null
  }
}

output subnetName string = subnet.name
output subnetId string = subnet.id
