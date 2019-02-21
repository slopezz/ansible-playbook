.PHONY: update build run run-vault tag-latest push help
.DEFAULT_GOAL := help


NAME       = ansible-playbook
NAMESPACE  = slopezz
VERSION    = 2.7.6

ANSIBLE_PLAYBOOK_EXECUTION ?= --version
ANSIBLE_VAULT_EXECUTION    ?= --version

IMAGE_NAME   := $(NAMESPACE)/$(NAME)

MKFILE_PATH  := $(abspath $(lastword $(MAKEFILE_LIST)))
THISDIR_PATH := $(patsubst %/,%,$(abspath $(dir $(MKFILE_PATH))))
PROJECT_PATH := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

update: build push

build: ## Build ansible-playbook image
	docker build -f $(THISDIR_PATH)/Dockerfile -t $(IMAGE_NAME):$(VERSION) $(PROJECT_PATH)

run: build ## Run ansible-playbook image
	docker run --rm -it \
	-v $(PROJECT_PATH):/ansible/playbooks \
	$(IMAGE_NAME):$(VERSION) \
	$(ANSIBLE_PLAYBOOK_EXECUTION)

run-vault: build ## Run ansible-vault with ansible-playbook image
	docker run --rm -it \
	-v $(PROJECT_PATH):/ansible/playbooks \
	--entrypoint ansible-vault \
	$(IMAGE_NAME):$(VERSION) \
        $(ANSIBLE_VAULT_EXECUTION)

tag-latest: ## Tag ansible-playbook image as latest
	docker tag $(IMAGE_NAME):$(VERSION) $(NAMESPACE)/$(NAME):latest

push: tag-latest ## Push ansible-playbook image
	docker push $(IMAGE_NAME) 

# Check http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
