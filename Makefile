ORG=blacktop
NAME=go-dev
VERSION?=$(shell cat VERSION)

all: build size

.PHONY: dockerfile
dockerfile: ## Update Dockerfiles
	@sed -i.bu 's/FROM golang:[0-9.]\{5\}-alpine/FROM golang:$(VERSION)-alpine/' Dockerfile

build: dockerfile ## Build docker image
ifeq "$(VERSION)" "ubuntu"
	docker build -f Dockerfile.ubuntu -t $(ORG)/$(NAME):ubuntu .
else
	docker build -t $(ORG)/$(NAME):$(VERSION) .
endif

.PHONY: size
size: ## Update docker image size in README.md
	sed -i.bu 's/docker%20image-.*-blue/docker%20image-$(shell docker images --format "{{.Size}}" $(ORG)/$(NAME):$(VERSION)| cut -d' ' -f1)-blue/' README.md

.PHONY: run
run: ## Run docker image
	@echo "===> Running $(ORG)/$(NAME):$(VERSION)..."
	@docker run --init -it --rm -e GOPATH=/mygo -v $(GOPATH):/mygo $(ORG)/$(NAME):$(VERSION)

.PHONY: ssh
ssh: ## SSH into docker image
ifeq "$(VERSION)" "ubuntu"
	docker run -ti --rm $(ORG)/$(NAME):ubuntu
else
	docker run -ti --rm $(ORG)/$(NAME):$(VERSION)
endif

.PHONY: push
push: build ## Push docker image to docker registry
	@echo "===> Pushing $(ORG)/$(NAME):$(VERSION) to docker hub..."
	@docker push $(ORG)/$(NAME):$(VERSION)

clean: ## Clean docker image and stop all running containers
	docker-clean stop
	docker rmi $(ORG)/$(NAME):$(VERSION) || true
	docker rmi $(ORG)/$(NAME):ubuntu || true

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
