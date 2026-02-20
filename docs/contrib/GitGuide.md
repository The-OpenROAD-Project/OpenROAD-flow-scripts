# Git Quickstart

If you have reached this file on GitHub - please refer to this [link](https://openroad-flow-scripts.readthedocs.io/en/latest/contrib/GitGuide.html) for latest documentation.

### Forking OpenROAD (Required for ORFS Contributors)

> **Important:** When forking ORFS, you must also fork the OpenROAD
> repository. OpenROAD is included as a Git submodule at `tools/OpenROAD/`.
> If you only fork ORFS, the submodule still points to the original
> OpenROAD repo, which you cannot push to, and your build will fail.

#### Steps

**Step 1 — Fork both repositories on GitHub:**

- Fork ORFS: https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
- Fork OpenROAD: https://github.com/The-OpenROAD-Project/OpenROAD

**Step 2 — Clone your ORFS fork:**
```bash
git clone https://github.com/<your-username>/OpenROAD-flow-scripts.git
cd OpenROAD-flow-scripts
```

**Step 3 — Point the submodule to your OpenROAD fork:**
```bash
cd tools/OpenROAD
git remote set-url origin https://github.com/<your-username>/OpenROAD.git
cd ../..
```

**Step 4 — Verify the setup:**
```bash
git submodule update --init --recursive
```

You can now build and submit pull requests to both ORFS and OpenROAD
from your own forks.