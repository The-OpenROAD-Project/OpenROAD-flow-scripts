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
import requests

# -- Project information -----------------------------------------------------

project = 'OpenROAD Flow'
copyright = 'The Regents of the University of California, 2021'
author = 'OpenROAD Team'


# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.ifconfig',
    'sphinx.ext.mathjax',
    'sphinx.ext.napoleon',
    'sphinx.ext.todo',
    'sphinx_external_toc',
    'sphinx_copybutton',
    'myst_parser',
    'sphinxcontrib.mermaid'
]

myst_enable_extensions = [
    'amsmath',
    'colon_fence',
    'deflist',
    'dollarmath',
    'html_admonition',
    'html_image',
    'replacements',
    'smartquotes',
    'substitution',
    'tasklist',
    'html_image',
]

external_toc_path = 'toc.yml'

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
source_suffix = ['.md']

# The master toctree document.
master_doc = 'index'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = [
    '_build',
    'Thumbs.db',
    '.DS_Store',
    '**/LICENSE',
    '**/LICENSE.md',
    'README.md',
    'docs/releases/PostAlpha2.1BranchMethodology.md',
    'main',
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
            "url": "mailto:openroad@eng.ucsd.edu",
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

def get_file_from_url(url, fname):
    r = requests.get(url)
    with open(fname, 'wb') as f:
        f.write(r.content)

def swap_prefix(file, old, new):
    with open(file, 'r') as f:
        lines = f.read()
    lines = lines.replace(old, new)
    with open(file, 'wt') as f:
        f.write(lines)

def setup(app):
    import shutil
    
    # symlink does not work for ORFS because of long recursive file links
    shutil.copy('../README.md', 'mainREADME.md')
    swap_prefix('mainREADME.md', '```mermaid', '```{mermaid}\n:align: center\n')   

    url = 'https://raw.githubusercontent.com/The-OpenROAD-Project/OpenROAD/master/docs/contrib/GitGuide.md'
    get_file_from_url(url, 'contrib/GitGuide.md') 

    # edit OpenROAD to OpenROAD-flow-scripts for GitGuide
    with open('contrib/GitGuide.md', 'r') as f:
        content = f.read()

    content = content.replace('user/Build.md', '../index.md#build-or-installing-orfs-dependencies')
    content = content.replace('OpenROAD', 'OpenROAD-flow-scripts')
    content = content.replace('The-OpenROAD-flow-scripts', 'The-OpenROAD')
    with open('contrib/GitGuide.md', 'w') as f:
        f.write(content)
