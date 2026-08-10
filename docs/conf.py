# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
import docutils
import os
import re

# -- Project information -----------------------------------------------------

project = "OpenROAD Flow"
copyright = "The Regents of the University of California, 2021"
author = "OpenROAD Team"


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    "sphinx.ext.autodoc",
    "sphinx.ext.ifconfig",
    "sphinx.ext.mathjax",
    "sphinx.ext.napoleon",
    "sphinx.ext.todo",
    "sphinx_external_toc",
    "sphinx_copybutton",
    "myst_parser",
    "sphinxcontrib.mermaid",
    "sphinx_llm.txt",
]

myst_enable_extensions = [
    "amsmath",
    "colon_fence",
    "deflist",
    "dollarmath",
    "html_admonition",
    "html_image",
    "replacements",
    "smartquotes",
    "substitution",
    "tasklist",
    "html_image",
]

external_toc_path = "toc.yml"

# Add any paths that contain templates here, relative to this directory.
templates_path = ["_templates"]

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
source_suffix = [".md"]

# The master toctree document.
master_doc = "index2.md"

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = [
    "_build",
    # The Makefile's actual BUILDDIR ("build", not the Sphinx-default "_build")
    # and any local virtualenv -- without these, a second build treats its own
    # previous output and installed packages' bundled images as source pages.
    "build",
    ".venv*",
    "venv",
    # Verbatim copies of OpenROAD files; conf.py splices them into ORFS pages
    # rather than publishing them directly. See docs/_vendor/openroad/README.md.
    "_vendor",
    "Thumbs.db",
    ".DS_Store",
    "**/LICENSE",
    "**/LICENSE.md",
    "README.md",
    "docs/releases/PostAlpha2.1BranchMethodology.md",
    "main",
    "index.md",
    "contrib/GitGuideAdapter.md",
]

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = None


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = "sphinx_book_theme"

html_theme_options = {
    "repository_url": "https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts",
    "repository_branch": "master",
    "show_navbar_depth": 2,
    "use_issues_button": True,
    "use_download_button": True,
    # list for more fine-grained ordering of icons
    "icon_links": [
        {
            "name": "The OpenROAD Project",
            "url": "https://theopenroadproject.org/",
            "icon": "fa-solid fa-globe",
        },
        {
            "name": "Twitter",
            "url": "https://twitter.com/OpenROAD_EDA",
            "icon": "fa-brands fa-twitter",
        },
        {
            "name": "Email",
            "url": "mailto:openroad@ucsd.edu",
            "icon": "fa-solid fa-envelope",
        },
        {
            "name": "GitHub",
            "url": "https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts",
            "icon": "fa-brands fa-github",
        },
        {
            "name": "Stars",
            "url": "https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/stargazers",
            "icon": "https://img.shields.io/github/stars/The-OpenROAD-Project/OpenROAD-flow-scripts",
            "type": "url",
        },
    ],
}

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".


# Files copied verbatim from the OpenROAD repository at the SHA that the
# tools/OpenROAD submodule pins. They are checked in, so this build performs no
# network access -- matching the intent of the hash-pinned requirements_lock.txt.
# Refresh them with REFRESH_CMD; docs/scripts/check_vendored_docs.py asserts
# they are still in sync with the submodule pointer.
VENDOR_DIR = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "_vendor", "openroad"
)
REFRESH_CMD = "python3 docs/scripts/refresh_openroad_docs.py"

# Holds one extracted section of OpenROAD's docs/index.md, not the whole page.
SUPPORTED_OS_FILE = "index-SupportedOS.md"


def read_vendored(fname):
    """Read a file vendored from the OpenROAD repository."""
    path = os.path.join(VENDOR_DIR, fname)
    try:
        with open(path, "r") as f:
            return f.read()
    except OSError as error:
        raise RuntimeError(
            "Cannot read the vendored OpenROAD file '%s': %s. "
            "Regenerate the vendored files with: %s" % (path, error, REFRESH_CMD)
        ) from error


def swap_prefix(file, old, new):
    with open(file, "r") as f:
        lines = f.read()
    lines = lines.replace(old, new)
    with open(file, "wt") as f:
        f.write(lines)


def setup(app):
    import shutil

    # symlink does not work for ORFS because of long recursive file links
    shutil.copy("../README.md", "mainREADME.md")
    swap_prefix("mainREADME.md", "```mermaid", "```{mermaid}\n:align: center\n")

    # Adapt the vendored OpenROAD GitGuide for ORFS: rename references and
    # inject ORFS-specific submodule forking instructions from
    # GitGuideAdapter.md.
    content = read_vendored("GitGuide.md")
    content = content.replace(
        "user/Build.md", "../index.md#build-or-installing-orfs-dependencies"
    )
    # Rename OpenROAD -> OpenROAD-flow-scripts, but leave the GitHub
    # organisation name ("The-OpenROAD-Project") and anything that already
    # carries the "-flow-scripts" suffix alone. Equivalent to the previous
    # blanket replace + "The-OpenROAD-flow-scripts" self-patch, without
    # corrupting those two forms.
    content = re.sub(
        r"(?<!The-)OpenROAD(?!-flow-scripts)", "OpenROAD-flow-scripts", content
    )

    gitguide_anchor = "## Creating a branch"
    if gitguide_anchor not in content:
        raise RuntimeError(
            "Could not find the heading '%s' in '%s' (vendored from "
            "The-OpenROAD-Project/OpenROAD:docs/contrib/GitGuide.md). That is "
            "where ORFS splices in contrib/GitGuideAdapter.md. Upstream most "
            "likely renamed the heading: re-vendor with `%s`, then update the "
            "anchor here and in docs/scripts/check_vendored_docs.py."
            % (gitguide_anchor, os.path.join(VENDOR_DIR, "GitGuide.md"), REFRESH_CMD)
        )
    with open("contrib/GitGuideAdapter.md", "r") as f:
        adapter_content = f.read()
    content = content.replace(gitguide_anchor, adapter_content + "\n" + gitguide_anchor)
    with open("contrib/GitGuide.md", "w") as f:
        f.write(content)

    # Create a copy of the index.md file
    shutil.copy("index.md", "index2.md")

    # OpenROAD's supported-OS table. The vendored file holds only that one
    # section of OpenROAD's docs/index.md -- the heading followed by the body
    # spliced in below -- so the section is extracted at vendoring time by
    # refresh_openroad_docs.py, not here. Demote the heading to #### so it
    # nests under ORFS's own "### Setup".
    start_pattern = "## Supported Operating Systems"
    section = read_vendored(SUPPORTED_OS_FILE)
    if not section.startswith(start_pattern):
        raise RuntimeError(
            "'%s' does not start with '%s'. It is vendored from "
            "The-OpenROAD-Project/OpenROAD:docs/index.md and must contain that "
            "section and nothing else. Upstream most likely renamed the "
            "heading: re-vendor with `%s`, then update this anchor here and in "
            "docs/scripts/check_vendored_docs.py."
            % (
                os.path.join(VENDOR_DIR, SUPPORTED_OS_FILE),
                start_pattern,
                REFRESH_CMD,
            )
        )
    extracted_content = "\n#### Supported Operating Systems" + section[
        len(start_pattern) :
    ]

    # Find insert position
    with open("index2.md", "r") as f:
        existing_content = f.read()
    insert_anchor = "### Setup"
    match = re.search(re.escape(insert_anchor), existing_content)
    if match is None:
        raise RuntimeError(
            "Could not find the heading '%s' in 'docs/index.md'; that is where "
            "OpenROAD's supported-OS table is spliced in. Restore the heading, "
            "or update the anchor here and in "
            "docs/scripts/check_vendored_docs.py." % insert_anchor
        )
    with open("index2.md", "w") as f:
        insert_position = match.end() + 1
        before_insert = existing_content[:insert_position]
        after_insert = existing_content[insert_position:]

        # Combine the parts with the extracted content
        updated_content = before_insert + extracted_content + after_insert

        f.write(updated_content)

    # Manpage page, vendored from OpenROAD's src/utl/README.md
    with open("Manpage.md", "w") as f:
        f.write(read_vendored("utl-README.md"))
