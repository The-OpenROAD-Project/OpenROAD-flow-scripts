.PHONY: init

clearcache:
	@echo "Cleaning python cache"
	@find . -type d -name __pycache__ -exec rm -r {} \+

init:
	@echo "Installing python environment"
	@./installer.sh

reqs:
	@echo "Compiling requirements"
	@rm -f requirements.txt
	@.venv/bin/pip-compile --output-file=requirements.txt requirements.in

test:
	@echo "Running tests"