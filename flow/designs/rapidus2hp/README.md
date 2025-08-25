# Rapidus Environment Setup

## Clone Rapidus Repo from Private GH

The ORFS-specific files for the Rapidus platform are stored separately in the private rapidus repo. Clone out the repo into a separate directory and then set PLATFORM_HOME to point to it:

```
cd rapidus_platform_dir_goes_here
git clone git@github.com:The-OpenROAD-Project-private/rapidus
export PLATFORM_HOME=`pwd`/rapidus_platform_dir_goes_here/rapidus
```

For more information, check out (http://github.com/The-OpenROAD-Project-private/rapidus)

