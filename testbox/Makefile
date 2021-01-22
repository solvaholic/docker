#!/usr/bin/make -f

SHELL = /bin/bash
SRCDIR = ${PWD}
NAME = testbox

include ../Makefile

default: build

lint: lint-dockerfile-lint lint-super-linter
build: lint-dockerfile-lint docker-build
shell: container-shell
start: container-start
stop: container-stop
