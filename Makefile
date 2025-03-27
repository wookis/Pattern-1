SHELL := /bin/bash
export LC_ALL=C

.PHONY: help
.DEFAULT_GOAL := help

AZURE_ENV_FILE := $(shell azd env list --output json | jq -r '.[] | select(.IsDefault == true) | .DotEnvPath')

ENV_FILE := .env
ifeq ($(filter $(MAKECMDGOALS),config clean),)
	ifneq ($(strip $(wildcard $(ENV_FILE))),)
		ifneq ($(MAKECMDGOALS),config)
			include $(ENV_FILE)
			export
		endif
	endif
endif

include $(AZURE_ENV_FILE)

help: ## 💬 This help message :)
	@grep -E '[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-23s\033[0m %s\n", $$1, $$2}'

ci: lint unittest unittest-frontend functionaltest ## 🚀 Continuous Integration (called by Github Actions)

lint: ## 🧹 Lint the code
	@echo -e "\e[34m$@\e[0m" || true
	@poetry run flake8 code

build-frontend: ## 🏗️ Build the Frontend webapp
	@echo -e "\e[34m$@\e[0m" || true
	@cd code/frontend && npm install && npm run build

python-test: ## 🧪 Run Python unit + functional tests
	@echo -e "\e[34m$@\e[0m" || true
	@poetry run pytest -m "not azure" $(optional_args)

unittest: ## 🧪 Run the unit tests
	@echo -e "\e[34m$@\e[0m" || true
	@poetry run pytest -vvv -m "not azure and not functional" $(optional_args)

unittest-frontend: build-frontend ## 🧪 Unit test the Frontend webapp
	@echo -e "\e[34m$@\e[0m" || true
	@cd code/frontend && npm run test

functionaltest: ## 🧪 Run the functional tests
	@echo -e "\e[34m$@\e[0m" || true
	@poetry run pytest code/tests/functional -m "functional"

uitest: ## 🧪 Run the ui tests in headless mode
	@echo -e "\e[34m$@\e[0m" || true
	@cd tests/integration/ui && npm install && npx cypress run --env ADMIN_WEBSITE_NAME=$(ADMIN_WEBSITE_NAME),FRONTEND_WEBSITE_NAME=$(FRONTEND_WEBSITE_NAME)

docker-compose-up: ## 🐳 Run the docker-compose file
	@cd docker && AZD_ENV_FILE=$(AZURE_ENV_FILE) docker-compose up

# Entra ID 확인 필요하나,  접근 권한 없음 
azd-login: ## 🔑 Login to Azure with azd and a SPN
	@echo -e "\e[34m$@\e[0m" || true
	@azd auth login --client-id ${AZURE_CLIENT_ID} --client-secret ${AZURE_CLIENT_SECRET} --tenant-id ${AZURE_TENANT_ID}

deploy: azd-login ## 🚀 Deploy everything to Azure
	@echo -e "\e[34m$@\e[0m" || true
	@azd env new ${AZURE_ENV_NAME}
	@azd env set AZURE_APP_SERVICE_HOSTING_MODEL code --no-prompt
	@azd provision --no-prompt
	@azd deploy web --no-prompt
	@azd deploy function --no-prompt
	@azd deploy adminweb --no-prompt

destroy: azd-login ## 🧨 Destroy everything in Azure
	@echo -e "\e[34m$@\e[0m" || true
	@azd down --force --purge --no-prompt


# 동작 안함
# make provision-container AZURE_ENV_NAME=prod APP_NAME=mycustomapp
# provision-container: ## 🚀 Deploy apps with container to Azure
# 	@echo -e "\e[34m$@\e[0m" || true
# 	@export AZURE_ENV_NAME=${AZURE_ENV_NAME}
# 	@[ -z "$(AZURE_ENV_NAME)" ] && export AZURE_ENV_NAME="dev" || true
# 	@[ -z "$(APP_NAME)" ] && export APP_NAME=app-$(tr -dc 'a-z0-9' < /dev/urandom | fold -w 4 | head -n 1) || true
# 	@echo "🔹 Using AZURE_ENV_NAME=$(AZURE_ENV_NAME)"
# 	@echo "🔹 Using APP_NAME=$(APP_NAME)"
# 	@azd env new $(AZURE_ENV_NAME)
# 	@azd env set APP_NAME $(APP_NAME)
# 	@azd provision
# 	@chmod +x ./scripts/deploy_function_keys.sh
# 	@WAIT_TIME=240 ./scripts/deploy_function_keys.sh
#
