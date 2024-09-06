# OpenROAD-flow-scripts and Bazel integration

`bazel-orfs` is a Bazel package containing the definitions and logic governing the build process of ORFS designs.
The module uses the `openroad/orfs` docker image to extract the flow scripts with dependencies, builds the Bazel environment around them and defines the methods of calling the ORFS Makefiles with selected designs.

## Run examples

`flow/BUILD.bazel` contains definitions for various flows to serve as examples.

It is recommended to run the utility [Bazelisk](https://github.com/bazelbuild/bazelisk) to manage the version of `bazel` installed on the system.
Details on installation can be found in the `bazel-orfs` [README](https://github.com/The-OpenROAD-Project/bazel-orfs?tab=readme-ov-file#requirements)

The flow can be ran with the following call structure:

```bash
bazel build <target_name>_<stage_name>
```

For example, to run the stage `final`, along with all the dependent stages, call:
```bash
bazel build gcd_final
```

Details on usage and defining of the flows are presented in the Usage section of the `bazel-orfs` [README](https://github.com/The-OpenROAD-Project/bazel-orfs?tab=readme-ov-file#usage)

## Dependency version management

In the flow scipts, the `bazel-orfs` version is defined as

```starlark
bazel_dep(name = "bazel-orfs")
git_override(
    module_name = "bazel-orfs",
    commit = "<Hash of the default bazel-orfs commit>",
    remote = "https://github.com/The-OpenROAD-Project/bazel-orfs.git",
)
```
However, as the referenced documentation shows, the git-based dependency can be overridden with a local repository.
First, remove the `git_override` call entirely and replace it with a `local_path_override` call following this convention:

```starlark
local_path_override(
  module_name = "bazel-orfs",
  path = "/replace/with/path/to/local/orfs/repository"
)
```

`bazel-orfs` sets a default version of the docker image used to create the Bazel environment.
This selection can be overridden by a following snippet inserted below the `bazel-orfs` declaration and override.

```starlark
orfs = use_extension("@bazel-orfs//:extension.bzl", "orfs_repositories")
orfs.default(
    image = "tag-name",
    sha256 = "the-hash",
)
```

Substitute `tag-name` with the tag of the version needed and `the-hash` with the digest corresponding to the selected tag (without the `sha256:` prefix).

