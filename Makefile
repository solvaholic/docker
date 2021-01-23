#!/usr/bin/make -f

# Provide default values for variables
SHELL ?= /bin/bash
NAME ?= unknown
IMAGE ?= solvaholic/${NAME}
IMAGE_VER ?= local
IMAGE_TAG ?= ${IMAGE}:${IMAGE_VER}
SRCDIR ?= ${PWD}

# Set $_U to override the image's default user, for example:
# 	make container-shell _U=root

# Parameters for Docker commands
PNAME = --name ${NAME}
PUSER = $(if ${_U},--user ${_U},)

# Recipes
lint-dockerfile-lint:
	@echo "Checking container image policies..."
	@docker run --rm -it -v $(PWD):/root/ \
		projectatomic/dockerfile-lint:latest \
		dockerfile_lint --rulefile .dockerfile_lint/all.yml
	@echo "Container image policies checked!"

lint-super-linter:
	@echo "Linting all the things..."
	@docker run --rm \
		-e VALIDATE_DOCKERFILE=false \
		-e VALIDATE_ENV=false \
		-e RUN_LOCAL=true \
		-v "$(realpath ${SRCDIR})":"/tmp/lint":ro \
		github/super-linter
	@echo "All the things linted!"

docker-build:
	@echo "Building ${IMAGE_TAG} image..."
	@docker build \
		--build-arg image_version="${IMAGE_VER}" \
		-t ${IMAGE_TAG} ${SRCDIR}
	@echo "${IMAGE_TAG} image built!"
	@docker images ${IMAGE_TAG}

container-shell:
	@echo "Running interactive ${NAME} shell..."
	@docker exec -it ${PUSER} ${NAME} ${SHELL} 2>/dev/null || \
		docker run -it --rm ${PNAME} ${PUSER} ${IMAGE_TAG}
	@echo "Interactive ${NAME} shell finished!"

container-start:
	@echo "Starting detached ${NAME} container..."
	@docker run -dt --rm ${PNAME} ${PUSER} ${IMAGE_TAG}
	@echo "Detached ${NAME} container started!"
	@docker ps

container-stop:
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
