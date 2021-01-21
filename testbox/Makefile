#!/usr/bin/make -f

# TODO: Learn from https://gist.github.com/mouttounet/d8347e0555c1d232b7bacb881c3ef1da

SHELL = /bin/bash
NAME = testbox
IMAGE ?= solvaholic/${NAME}
IMAGE_VER ?= local
IMAGE_TAG ?= ${IMAGE}:${IMAGE_VER}

srcdir = .

default: build

lint: lint-dockerfile-lint lint-super-linter
build: lint-dockerfile-lint docker-build
shell: testbox-shell
start: testbox-start
stop: testbox-stop

lint-dockerfile-lint:
	@echo "Checking container image policies..."
	@docker run --rm -it -v $(PWD):/root/ \
		projectatomic/dockerfile-lint \
		dockerfile_lint --rulefile .dockerfile_lint/all.yml
	@echo "Container image policies checked!"

lint-super-linter:
	@echo "Linting all the things..."
	@docker run --rm \
		-e VALIDATE_DOCKERFILE=false \
		-e VALIDATE_ENV=false \
		-e RUN_LOCAL=true \
		-v "$(realpath .)":"/tmp/lint":ro \
		github/super-linter
	@echo "All the things linted!"

docker-build:
	@echo "Building ${IMAGE_TAG} image..."
	@docker build \
		--build-arg image_version="${IMAGE_VER}" \
		-t ${IMAGE_TAG} .
	@echo "${IMAGE_TAG} image built!"
	@docker images ${IMAGE_TAG}

testbox-shell:
	@echo "Running interactive ${NAME} shell..."
	@docker run -it --rm --name ${NAME} ${IMAGE_TAG} ${SHELL}
	@echo "Interactive ${NAME} shell finished!"

testbox-start:
	@echo "Starting detached ${NAME} container..."
	@docker run -dt --rm --name ${NAME} ${IMAGE_TAG} \
		'touch /keeprunning && while [ -f /keeprunning ]; \
		do sleep 30; done'
	@echo "Detached ${NAME} container started!"
	@docker ps

testbox-stop:
	@echo "Stopping ${NAME} container..."
	@docker stop "${NAME}"
	@echo "${NAME} container stopped!"
	@docker ps

inspect-labels:
	@echo "Inspecting image labels..."
	@docker inspect --format \
		" Name: {{ index .Config.Labels \"name\" }}" ${IMAGE_TAG}
	@docker inspect --format \
		" Version: {{ index .Config.Labels \"version\" }}" ${IMAGE_TAG}
	@docker inspect --format \
		" Maintainer: {{ index .Config.Labels \"maintainer\" }}" ${IMAGE_TAG}
	@echo "Image labels inspected!"