# setup.py
from setuptools import setup, find_packages

setup(
    name='autotuner',
    version='0.1',
    package_dir={'': 'src'},
    packages=find_packages(where='src'),
    install_requires=[
        # List your dependencies here
    ],
    entry_points={
        'console_scripts': [
            # Define any command-line scripts here
        ],
    },
    author='The OpenROAD Team',
    author_email='openroad@eng.ucsd.edu',
    description='Autotuner Utilities for ORFS',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url='https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts',  # Replace with your repository URL
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.8',
)
