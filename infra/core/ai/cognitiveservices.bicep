metadata description = 'Creates an Azure Cognitive Services instance.'
param name string
param location string = resourceGroup().location
param tags object = {}
@description('The custom subdomain name used to access the API. Defaults to the value of the name parameter.')
param customSubDomainName string = name
param deployments array = []
param kind string = 'OpenAI'
param managedIdentity bool = false

@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'
param sku object = {
  name: 'S0'
}

param allowedIpRules array = []
// param networkAcls object = empty(allowedIpRules)
//  ? {
//   defaultAction: 'Allow'
// }
//  : {
//   ipRules: allowedIpRules
//   defaultAction: 'Deny'
// }

param networkAcls object = {
  defaultAction: 'Deny'
  ipRules: length(allowedIpRules) > 0 ? allowedIpRules : null
}

resource account 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  properties: {
    customSubDomainName: customSubDomainName
    publicNetworkAccess: publicNetworkAccess
    networkAcls: networkAcls
  }
  sku: sku
  identity: {
    type: managedIdentity ? 'SystemAssigned' : 'None'
  }
}

@batchSize(1)
resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = [
  for deployment in deployments: {
    parent: account
    name: deployment.name
    properties: {
      model: deployment.model
      // Responsible AI (RAI) 정책을 지정하는 속성. content safety 추가 검토 필요하여 반영 안함
      // raiPolicyName: contains(deployment, 'raiPolicyName') ? deployment.raiPolicyName : null
    }
    sku: deployment.?sku ?? {
      name: 'Standard'
      capacity: 20
    }
  }
]

output endpoint string = account.properties.endpoint
output identityPrincipalId string = managedIdentity ? account.identity.principalId : ''
output id string = account.id
output name string = account.name
output location string = location
