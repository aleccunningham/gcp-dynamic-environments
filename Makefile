# Container information
IMAGE = ""
REPO = "grc.io/$(PROJECT_IMAGE)/$(IMAGE)"
VERSION := "eval (git rev-parse --short HEAD)"
# Google Cloud Platform variables
CRED_FILE = "creds/registry.json"
AUTH_GCLOUD := "eval ( gcloud auth activate-service-account --key-file $(CRED_FILE) )"

# HELP
# This will output the help for each task
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build the container
	docker build -t $(IMAGE) .

tag: ## Generate container tags
	@echo 'Tagging $(IMAGE) with git SHA'
	docker tag $(IMAGE) $(REPO)/$(IMAGE):$(VERSION)

submit: tag ## Trigger GCP Container Builder
	@echo 'Building using build-steps.yaml'
	gcloud container builds submit . --config=build-steps.yaml

auth: ## Authenticate for GCP registry
	@eval $(AUTH_GCLOUD)

version: ## Output the current version
	@echo $(VERSION)
