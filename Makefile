#
# Authors:
#  - Abhimanyu Saharan <asaharan@onemindservices.com>
#

REGISTRY_HOST=docker.io
USERNAME=kryptosteam
NAME=daemon
IMAGE=$(REGISTRY_HOST)/$(USERNAME)/$(NAME)
VERSION=latest

SHELL=/bin/bash

DOCKER_BUILD_CONTEXT=.
DOCKER_FILE_PATH=Dockerfile

.PHONY: pre-build docker-build post-build build push pre-push do-push post-push

help:
	@echo 'Usage: make [TARGET]'
	@echo
	@echo 'Targets:'
	@echo ' build              builds a new version of your Docker image and tags it'
	@echo ' push               push the image to your registry'

build: pre-build docker-build post-build

pre-build:


post-build:


pre-push:


post-push:



docker-build:
	docker build $(DOCKER_BUILD_ARGS) -t $(IMAGE):$(VERSION) $(DOCKER_BUILD_CONTEXT) -f $(DOCKER_FILE_PATH)

push: pre-push do-push post-push

do-push:
	docker push $(IMAGE):$(VERSION)