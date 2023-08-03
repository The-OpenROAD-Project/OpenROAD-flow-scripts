# FAQs

If you cannot find your question/answer here, please file a GitHub issue to
the appropriate repository or start a discussion.

-   Issues and bugs:
    -   OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/issues>
    -   OpenROAD with OpenROAD Flow Scripts: <https://github.com/The-OpenROAD-Project/OpenROAD/issues>
-   Discussions:
    -   OpenROAD Flow: <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts/discussions>

## How can I contribute?

Thank you for your willingness to contribute. Please see the
[Getting Involved](../contrib/GettingInvolved) guide.

## How do I update OpenROAD-flow-scripts?

Depending on how you installed OpenROAD-flow-scripts, there are different ways of updating. Regardless, here are the common first steps:

```shell
cd OpenROAD-flow-scripts
git checkout master
git pull
```

Now your local copy of ORFS should be up-to-date. The next step is to build it again with the following command: 

For WSL/docker based installation, run:
```shell
./build_openroad.sh --clean
```

For local installation, run:
```shell
./build_openroad.sh --local --clean
```

For pre-built binaries, you can run the flow after `git pull` is done.

:::{tip} 
For development purposes, it is a good practice to work on branches and leave master untouched. 
- If the branch already exists: `git checkout <BRANCH> && git merge master`
- If the branch does not exist: `git checkout -b <BRANCH> && git merge master` 
:::

## How do I update the design reference files?

See how to update using the Metrics [guide](../contrib/Metrics.md).

## How do I get better search results?

As quoted from [ReadTheDocs](https://docs.readthedocs.io/en/stable/server-side-search/syntax.html#special-queries), this documentation is powered by [Simple Query String](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-simple-query-string-query.html#) from [Elasticsearch](https://www.elastic.co/elasticsearch/). Here are some helpful patterns:

- Exact phrase search: `"global_route"`
- Prefix query: `GRT-*`, `BUF*`, `report_*`
- Fuzziness: `~N` (tilde followed by a number) after a word indicates edit distance. Helpful if the exact spelling is unknown. For example: `test~2`, `reportfilename~2`
