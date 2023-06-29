# FAQs

If you cannot find your question/answer here, please file a GitHub issue to
the appropriate repository or start a discussion.

-   Issues and bugs:
    -   OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues>
    -   OpenROAD with OpenROAD Flow Scripts: <https://github.com/The-OpenROAD-Project/OpenROAD/issues/>
-   Discussions:
    -   OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/discussions>

## How can I contribute?

Thank you for your willingness to contribute. Please see the
[Getting Involved](../contrib/GettingInvolved) guide.

## How do I update OpenROAD-flow scripts?

Depending on how you installed OpenROAD-flow-scripts, there are different ways of updating. Regardless, here are the common first steps:

```
cd OpenROAD-flow-scripts
git checkout master
git pull
```

Now your local copy of ORFS should be up-to-date. The next step is to build it again with the following command: 

For WSL/docker based installation, run:
```
./build_openroad.sh --clean
```

For local installation, run:
```
./build_openroad.sh --local --clean
```

For pre-built binaries, you can run the flow after `git pull` is done.

> **TIP**: For development purposes, it is a good practice to work on branches and leave master untouched. 
> To update your branch, simply run `git checkout <BRANCH>; git merge master`
## How do I update the design reference files?

See how to update the Metrics [here](../contrib/Metrics.md).
