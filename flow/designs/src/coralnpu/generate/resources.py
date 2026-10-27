"""A jar of the Verilog coralnpu's black boxes load from the classpath.

The paths are the ones coralnpu's addResource calls name: its own files
at their path in its repository (hdl/verilog/rvv/...), those directly in
hdl/verilog (RstSync.sv, ClockGate.sv, Sram.v) at the root as well, and
a dependency's at external/<repository>/<path> (fpnew's, in FloatCore).
"""

import re
import sys
import zipfile

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
        jar.write(path, rest)
        if rest.count("/") == 2:
            jar.write(path, rest.split("/")[-1])
