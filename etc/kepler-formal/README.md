# kepler-formal

To bump kepler-formal, change the version in `MODULE.bazel`.

`build_openroad.sh --local` installs kepler-formal into
`tools/install/kepler-formal/bin/kepler-formal` from this folder:

```shell
cd etc/kepler-formal
bazelisk run //:install -- "$(pwd)/../../tools/install/kepler-formal"
```

ORFS is not a Bazel project. This folder only pins kepler-formal; the
install is kepler-formal's own `//:install` target.

## How this maps to `DependencyInstaller.sh`

`DependencyInstaller.sh` downloads a pinned CMake from Kitware when the
one the OS ships is too old, and checks it against a checksum. Bazel
does the same for kepler-formal and every library it needs, from the
[Bazel Central Registry](https://registry.bazel.build/), which keeps the
URL, the checksum and the build file of each version:

| `DependencyInstaller.sh`, `build_openroad.sh` | Here |
| --- | --- |
| oneTBB and capnproto from the OS, or built from a pinned tarball | `bazel_dep` versions in kepler-formal's `MODULE.bazel` |
| A pinned CMake when the OS's is too old | bazelisk runs the Bazel named in `.bazelversion` |
| `gcc-toolset-13` on EL8, because GCC 8 is too old | A pinned clang is downloaded on x86-64 Linux; elsewhere the host compiler is used, `gcc-toolset-13` on EL8, which Yosys still needs |
| `tools/kepler-formal` and the submodules inside it | The version in `MODULE.bazel`; sources are checked against their checksums and cached in `~/.cache/bazel` |
| An RPATH that points at the install's `lib/` | The binary finds its libraries next to itself, in `bin/kepler-formal.runfiles/` |
