# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     =
BUILDDIR      = build
# Read the Docs builds with 3.12 (see .readthedocs.yaml); override if you want
# a specific interpreter locally.
PYTHON        ?= python3

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Create a local virtualenv and install the hash-pinned doc-build dependencies.
venv:
	$(PYTHON) -m venv .venv
	.venv/bin/pip install -r requirements_lock.txt

.PHONY: help Makefile venv

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	rm -f main
	./revert-links.py

checklinks:
	$(SPHINXBUILD) -b linkcheck "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo
	@echo "Check finished. Report is in $(BUILDDIR)."
	rm -f main
	./revert-links.py
