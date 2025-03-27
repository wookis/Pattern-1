#!/bin/bash

WAIT_TIME=${WAIT_TIME:-300}

echo "Loading azd environment values..."
AZD_ENV_VARS=$(azd env get-values --output json)

RESOURCE_GROUP=$(echo "$AZD_ENV_VARS" | jq -r '.AZURE_RESOURCE_GROUP')
FUNCTION_APP_NAME=$(echo "$AZD_ENV_VARS" | jq -r '.FUNCTION_APP_NAME')
FUNCTION_KEY=$(echo "$AZD_ENV_VARS" | jq -r '.FUNCTION_KEY')

DEPLOY_BICEP_PATH="./infra/core/host/function-clientkeys.bicep"

echo "Wait $WAIT_TIME seconds ... waiting to avoid the cold start of the function app."
for ((i=1; i<=WAIT_TIME; i++)); do
    sleep 1
done
echo "deploying function keys ..."

az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "$DEPLOY_BICEP_PATH" \
  --parameters keyName="ClientKey" clientKey="$FUNCTION_KEY" functionName="$FUNCTION_APP_NAME"
