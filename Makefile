#.DEFAULT_GOAL := start
SHELL=/bin/bash
NOW = $(shell date +"%Y%m%d%H%M%S")
UID = $(shell id -u)
PWD = $(shell pwd)
PYTHON=$(shell which python3.10)

.PHONY: help
help: ## prints all targets available and their description
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: start
start: ## how to start develop
	@echo "************  How start develop ************"
	@echo "1. For create virtual environment:"
	@echo "python3.10 -m venv venv"
	@echo ""
	@echo "2. To start virtual dev environment:"
	@echo "source venv/bin/activate"
	@echo ""
	@echo "3. Install all dependencies:"
	@echo "make all-dependencies"
	@echo ""
	@echo "4. To exit of dev environment:"
	@echo "deactivate"
	@echo ""

.PHONY: install
install: venv app-dependencies dev-dependencies ## Create venv and install all dependencies

.PHONY: dev-dependencies
dev-dependencies: venv pyproject.toml ## Install development dependencies
	(. venv/bin/activate; \
	pip install -U pip poetry; \
	poetry install)

.PHONY: venv app-dependencies
app-dependencies: pyproject.toml ## Install application dependencies
	(. venv/bin/activate; \
	pip install -U pip poetry; \
	poetry install --no-dev)

.PHONY: lint
lint: ## check source code for style errors
	(. venv/bin/activate; \
	flake8 . && black . --check; \
    )

.PHONY: format
format: ## automatic source code formatter following a strict set of standards
	isort . --sp .isort.cfg && black .

.PHONY: venv
venv:  ## creates a virtualenv if does not exist and activates it
	@if [[ "${PYTHON_VERSION}" != "${PY_VER}" ]]; then \
       echo "You need Python ${PY_VER}. Detected ${PYTHON_VERSION}"; exit 1; \
    fi
		test -d venv || ${PYTHON} -m venv venv # setup a python3 virtualenv

.PHONY: install-hooks
install-hooks: ## installs git hooks in your local machine
	cp .pre-commit .git/hooks/pre-commit

.PHONY: flake-report
flake-report: ## flake8 Dashboards
	@echo "Generating flake8 report, please wait..."
	- flake8 --format=dashboard --outputdir=flake-report --title="Callid Project"
	open flake-report/index.html

.PHONY: unit-tests
unit-tests: ## Run all unit tests
	@echo "************ Unit Tests ************"
	coverage run -m unittest discover -s tests/unit
	coverage report

.PHONY: integration-tests
integration-tests: ## Search and execute all integration tests
	@echo "************ Integration Tests ************"
	coverage run -m unittest discover -s tests/integration
	coverage report

.PHONY: tests
tests: unit-tests integration-tests ## Run unit and integration tests

.PHONY: coverage-report
coverage-report: ## coverage report of all tests
	(. venv/bin/activate; \
	coverage run -m unittest discover; \
	coverage html; \
	open htmlcov/index.html; \
	)

