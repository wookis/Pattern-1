param functionName string
param clientKey string
param keyName string

resource functionResource 'Microsoft.Web/sites@2022-03-01' existing = {
  scope: resourceGroup()
  name: functionName
}

#disable-next-line BCP081
resource functionHost 'Microsoft.Web/sites/host@2022-03-01' existing = {
  parent: functionResource
  name: 'default'
}

// 추가 지연효과를 줄 수 있으면 좋겠음. 예를 들어 생성에 오래 걸리는 자원을 depends함
// deploymentScript는 현재 policy에서 정상 작동 안함. storage account에 대한 public access 필요
// ./scripts/deploy_function_keys.sh로 별도 배포함
#disable-next-line BCP081
resource functionNameDefaultClientKey 'Microsoft.Web/sites/host/functionKeys@2018-11-01' = {
  parent: functionHost
  name: keyName
  properties: {
    value: clientKey
  }
  dependsOn: [
    functionResource
  ]
}
