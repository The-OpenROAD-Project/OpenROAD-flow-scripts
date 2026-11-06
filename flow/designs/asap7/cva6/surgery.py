"""SYNTH_VERILOG_SURGERY for cva6: the I-cache RAMs behind the techno cut.

cva6's sram_cache puts its RAMs behind tc_sram_wrapper_cache_techno, the
techno cut a technology's SRAM goes behind, and upstream fills it with
pulp's generic tc_sram, a model with port arrays and a read latency that
no SRAM macro has. This keeps the wrapper's parameters and ports and puts
a single-port SRAM with byte enables behind it, one module per shape
cv32a65x uses, for AUTO_MEMORIES to make a macro of: the I-cache data,
64 x 256 (32 byte enables), and the tag, 64 x 25 (4 byte enables, the
last of them 1 bit, as tc_sram's). An elaboration-time $error stops any
other shape.

An SRAM is not tc_sram: tc_sram's read data follows the last read
address, through idle cycles and writes, and a single-port SRAM reads
the address it is given and holds while idle. cva6_icache uses read
data only in a cycle after a read, or after idle cycles with no write
since the read, so the two return the same data whenever it is used.

The Verilog is in surgery/, next to this script:

- tc_sram_wrapper_cache_techno.upstream.sv: the module as upstream has it.
  The module found in VERILOG_FILES must match it token for token,
  comments and whitespace aside, or the build stops.
- tc_sram_wrapper_cache_techno.sv: what replaces it.
- cva6_icache_data_sram.sv, cva6_icache_tag_sram.sv: the two SRAMs,
  appended after the replacement.

Every other file is copied unchanged.
"""

import argparse
import os
import re
import sys

RESOURCES = os.path.join(os.path.dirname(os.path.abspath(__file__)), "surgery")
MODULE = "tc_sram_wrapper_cache_techno"


def resource(name):
    with open(os.path.join(RESOURCES, name), encoding="utf-8") as f:
        return f.read()


def tokens(text):
    """The Verilog text without comments, whitespace collapsed."""
    text = re.sub(r"//[^\n]*", "", text)
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return " ".join(text.split())


def fail(message):
    sys.exit("cva6 surgery: " + message)


def replace_module(path, text, upstream, replacement):
    """Return `text` with MODULE replaced, and whether it was found."""
    found = list(
        re.finditer(r"^module\s+%s\b.*?^endmodule\b" % MODULE, text, re.M | re.S)
    )
    if len(found) > 1:
        fail("%s defines %s %d times" % (path, MODULE, len(found)))
    if not found:
        return text, False
    module = found[0]
    if tokens(module.group(0)) != tokens(upstream):
        fail(
            "%s in %s is not the one in surgery/%s.upstream.sv;"
            " upstream changed it, update the surgery" % (MODULE, path, MODULE)
        )
    return text[: module.start()] + replacement + text[module.end() :], True


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("files", nargs="+")
    args = parser.parse_args()

    upstream = resource(MODULE + ".upstream.sv")
    replacement = "\n\n".join(
        resource(name).rstrip("\n")
        for name in (
            MODULE + ".sv",
            "cva6_icache_data_sram.sv",
            "cva6_icache_tag_sram.sv",
        )
    )

    replaced_in = []
    for path in args.files:
        with open(path, encoding="utf-8") as f:
            text = f.read()
        text, replaced = replace_module(path, text, upstream, replacement)
        if replaced:
            replaced_in.append(path)
        out = os.path.join(args.out_dir, os.path.basename(path))
        with open(out, "w", encoding="utf-8") as f:
            f.write(text)

    if len(replaced_in) != 1:
        fail("%s found in %d files, not one" % (MODULE, len(replaced_in)))


if __name__ == "__main__":
    main()
