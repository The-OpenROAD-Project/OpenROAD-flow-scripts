# Git Quickstart (forks)

If you are working from your **own fork**, you must fork both this repository **and** the
`OpenROAD` submodule. Otherwise `git submodule` will still point to the upstream
`The-OpenROAD-Project/OpenROAD` and builds in your fork will fail.

## Fork + clone

1. Fork **OpenROAD-flow-scripts**.
2. Fork **OpenROAD** (the tools submodule).
3. Clone your ORFS fork with submodules:
   ```bash
   git clone --recursive https://github.com/<you>/OpenROAD-flow-scripts.git
   cd OpenROAD-flow-scripts
   ```

## Point the submodule at your OpenROAD fork

Run these once in your clone:

```bash
git submodule set-url tools/OpenROAD https://github.com/<you>/OpenROAD.git
git submodule update --init --recursive
```

## Keep both forks in sync

```bash
git remote add upstream https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts.git
git remote add upstream-or https://github.com/The-OpenROAD-Project/OpenROAD.git
git fetch upstream upstream-or

# Update ORFS
git checkout master
git pull upstream master

# Update OpenROAD submodule to upstream
git submodule update --remote tools/OpenROAD
git push origin master
```

With this setup, `git clone --recursive <your-orfs-fork>` will work, and the submodule
will track your OpenROAD fork by default.
