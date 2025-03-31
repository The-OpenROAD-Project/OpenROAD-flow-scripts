.PHONY: reqs
reqs: 
	@rm -f requirements.txt
	@rm -f requirements-test.txt
	@uv pip compile --output-file=requirements.txt pyproject.toml --upgrade
	@uv pip compile --output-file=requirements-dev.txt pyproject.toml --extra dev --upgrade
	@uv sync --all-extras
