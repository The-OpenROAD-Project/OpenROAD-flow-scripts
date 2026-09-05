load("//flow/designs:design.bzl", "files")

# files() rather than a bare filegroup: the globbed sources are then also
# exported as individual labels, which the config.mk parser in bazel-orfs
# needs -- nangate45/mempool_group's VERILOG_FILES names files in this
# directory one by one, and a bare filegroup makes them private to it.
# The extra sources are the headers from sibling packages that the
# include group has always carried.
files(
    "include",
    extra_srcs = [
        "//flow/designs/src/mempool_group/rtl/axi:assign.svh",
        "//flow/designs/src/mempool_group/rtl/axi:typedef.svh",
        "//flow/designs/src/mempool_group/rtl/common_cells:assertions.svh",
        "//flow/designs/src/mempool_group/rtl/common_cells:registers.svh",
        "//flow/designs/src/mempool_group/rtl/mempool:mempool.svh",
    ],
)
