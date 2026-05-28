### Forking OpenROAD

OpenROAD-flow-scripts uses OpenROAD as a Git submodule at `tools/OpenROAD`. When you
fork OpenROAD-flow-scripts, the submodule URL in `.gitmodules` still points to the
upstream OpenROAD repository. If your contribution requires changes to OpenROAD, you
must also fork it and update the submodule remote in your local clone.

1. Fork [OpenROAD](https://github.com/The-OpenROAD-Project/OpenROAD) on GitHub.

2. After cloning your OpenROAD-flow-scripts fork recursively, update the submodule
   remote to point to your OpenROAD fork:

```shell
cd tools/OpenROAD
git remote set-url origin https://github.com/your-user-name/OpenROAD.git
git remote add upstream https://github.com/The-OpenROAD-Project/OpenROAD.git
```

3. Verify the remotes are set correctly:

```shell
git remote -v
```

