#!/usr/bin/make -f

SHELL = /bin/bash
SRCDIR = ${PWD}
NAME = actions-runner

include ../Makefile

default: build

lint: lint-super-linter
build: docker-build
shell: container-shell
start: container-start
stop: container-stop
