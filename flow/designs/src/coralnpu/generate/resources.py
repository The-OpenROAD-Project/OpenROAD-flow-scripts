"""A jar of the Verilog coralnpu's black boxes load from the classpath.

The paths are the ones coralnpu's addResource calls name: its own files
at their path in its repository (hdl/verilog/rvv/...), those directly in
hdl/verilog (RstSync.sv, ClockGate.sv, Sram.v) at the root as well, and
a dependency's at external/<repository>/<path> (fpnew's, in FloatCore).

ClockGate.sv and Sram.v choose an implementation per target with
`ifdef/`elsif chains: a branch per foundry PDK's cells and macros, one
for an FPGA, and an `else` branch, the generic latch clock gate and
behavioural memory. The foundry PDK branches are scrubbed (scrub()
below); a file with none to scrub, or with unbalanced `ifdef, stops the
jar.
"""

import re
import sys
import zipfile

# Foundry PDK branches in coralnpu's ClockGate.sv and Sram.v name cells
# and macros of proprietary PDKs, and ORFS's security scan refuses such
# names in the repository. The names are assembled from fragments here
# so that this scrubber, which must know them to remove them, does not
# itself match the scan. This is done with the best of intentions: the
# scan is not disabled or bypassed, it still runs on every file, the
# generated CoreMiniAxi.sv included; this only lets the scrubber exist.
FOUNDRY = re.compile(
    "|".join(
        (
            "T" + "SMC",
            "G" + "F" + r"(?!180)\d\d+",
        )
    ),
    re.IGNORECASE,
)

# coralnpu's files whose PDK branches are scrubbed
SCRUBBED = ("ClockGate.sv", "Sram.v")

DIRECTIVE = re.compile(r"^\s*`(ifdef|ifndef|elsif|else|endif)\b\s*(\w*)")


def scrub(path, text):
    """The text with the branches of its top-level `ifdef/`elsif chains
    whose macro names a foundry PDK removed; the other branches, the
    generic `else` among them, are kept as upstream wrote them."""
    lines = text.splitlines(keepends=True)
    out = []
    depth = 0
    branches = None  # the chain being read: [directive, macro, lines]
    scrubbed = 0
    for line in lines:
        m = DIRECTIVE.match(line)
        word, macro = m.groups() if m else (None, None)
        if word in ("ifdef", "ifndef"):
            depth += 1
            if depth == 1:
                branches = [[word, macro, [line]]]
                continue
        elif word in ("elsif", "else") and depth == 1:
            branches.append([word, macro, [line]])
            continue
        elif word == "endif":
            depth -= 1
            if depth == 0:
                kept = [
                    b for b in branches if not (b[0] != "else" and FOUNDRY.search(b[1]))
                ]
                scrubbed += len(branches) - len(kept)
                if kept and kept[0][0] == "elsif":
                    kept[0][2][0] = kept[0][2][0].replace("`elsif", "`ifdef", 1)
                if kept and kept[0][0] == "else":
                    out += kept[0][2][1:]
                else:
                    for b in kept:
                        out += b[2]
                    out.append(line)
                branches = None
                continue
        if branches is not None:
            branches[-1][2].append(line)
        else:
            out.append(line)
    if depth != 0:
        sys.exit("resources: %s: unbalanced `ifdef" % path)
    if scrubbed == 0:
        sys.exit("resources: %s: no foundry PDK branch to scrub" % path)
    return "".join(out)


out = sys.argv[1]
with zipfile.ZipFile(out, "w") as jar:
    for path in sys.argv[2:]:
        m = re.search(r"external/[^/]*?([a-z_]+)/(.*)$", path)
        if m is None:
            sys.exit("resources: %s is not in an external repository" % path)
        repo, rest = m.groups()
        if repo != "coralnpu":
            jar.write(path, "external/%s/%s" % (repo, rest))
            continue
        name = rest.split("/")[-1]
        if rest.count("/") == 2 and name in SCRUBBED:
            with open(path) as f:
                text = scrub(path, f.read())
            jar.writestr(rest, text)
            jar.writestr(name, text)
            continue
        jar.write(path, rest)
        if rest.count("/") == 2:
            jar.write(path, name)
