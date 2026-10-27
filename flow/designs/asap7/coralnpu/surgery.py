"""SYNTH_VERILOG_SURGERY for coralnpu: the register files given modules.

The two register files keep their words as separate registers, with no
array for yosys to infer. Regfile's 31 words move into Regfile_rf and
FRegfile's 32 into FRegfile_rf, modules of their own that
AUTO_MEMORIES_REGFILES has generate_ram build (Regfile_rf.regfile and
FRegfile_rf.regfile). Each keeps its scoreboard, bypasses and read
gating as they were.

Each register file is recognised by its text, token for token, comments
and whitespace aside: anything else stops the build. Everything else is
copied unchanged.
"""

import argparse
import os
import re
import sys

# Regfile's eight read ports, its debug read and its six write ports;
# write ports 1, 2, 3 and 5 are masked by their io_writeMask_N_valid.
READS = 8
DEBUG = READS
WRITES = 6
MASKED = (1, 2, 3, 5)


def regfile_rf_module():
    ports = ["  input clock", "  input reset"]
    for k in range(READS + 1):
        ports += ["  input [4:0] raddr%d" % k, "  output [31:0] rdata%d" % k]
    for p in range(WRITES):
        ports += [
            "  input [4:0] waddr%d" % p,
            "  input [31:0] wdata%d" % p,
            "  input we%d" % p,
        ]
    hit = lambda p: "(we%d && waddr%d == i)" % (p, p)
    any_hit = " || ".join(hit(p) for p in range(WRITES))
    data = " | ".join("(%s ? wdata%d : 32'd0)" % (hit(p), p) for p in range(WRITES))
    reads = "\n".join(
        "  assign rdata%d = raddr%d == 5'd0 ? 32'd0 : mem[raddr%d];" % (k, k, k)
        for k in range(READS + 1)
    )
    return """
// SYNTH_VERILOG_SURGERY (asap7/coralnpu/surgery.py): Regfile's
// storage, behavioural; AUTO_MEMORIES_REGFILES replaces it. Word 0 reads
// zero and keeps nothing; writes of one word in one cycle are ORed, as
// Regfile's data_N are; every word resets to zero while reset is high.
module Regfile_rf (
%s
);
  reg [31:0] mem [1:31];
  integer i;
  always @(posedge clock or posedge reset) begin
    if (reset) begin
      for (i = 1; i < 32; i = i + 1) mem[i] <= 32'd0;
    end else begin
      for (i = 1; i < 32; i = i + 1)
        if (%s)
          mem[i] <= %s;
    end
  end
%s
endmodule
""" % (",\n".join(ports), any_hit, data, reads)


def regfile_instance():
    conns = ["    .clock(clock)", "    .reset(reset)"]
    for k in range(READS):
        conns += [
            "    .raddr%d(io_readAddr_%d_addr)" % (k, k),
            "    .rdata%d(_rf_rdata_%d)" % (k, k),
        ]
    conns += [
        "    .raddr%d(io_debugBusPort_idx)" % DEBUG,
        "    .rdata%d(_rf_rdata_%d)" % (DEBUG, DEBUG),
    ]
    for p in range(WRITES):
        we = "io_writeData_%d_valid" % p
        if p in MASKED:
            we += " & ~io_writeMask_%d_valid" % p
        conns += [
            "    .waddr%d(io_writeData_%d_bits_addr)" % (p, p),
            "    .wdata%d(io_writeData_%d_bits_data)" % (p, p),
            "    .we%d(%s)" % (p, we),
        ]
    return "  Regfile_rf rf (\n%s\n  );\n" % ",\n".join(conns)


def addr_is(port_expr, word):
    if word == 31:
        return "(&%s)" % port_expr
    return "%s == 5'h%X" % (port_expr, word)


def port_we(p):
    we = "io_writeData_%d_valid" % p
    if p in MASKED:
        we += " & ~io_writeMask_%d_valid" % p
    return we


def write_through(k):
    """Port k's read of a word being written: compares of the write
    ports' addresses, not a select over every word's decoded data."""
    lines = []
    for p in range(WRITES):
        lines.append(
            "  wire _wt_%d_%d = %s & io_writeData_%d_bits_addr == io_readAddr_%d_addr"
            " & (|io_readAddr_%d_addr);\n" % (k, p, port_we(p), p, k, k)
        )
    lines.append(
        "  wire _wt_%d = %s;\n"
        % (k, " | ".join("_wt_%d_%d" % (k, p) for p in range(WRITES)))
    )
    lines.append(
        "  wire [31:0] _wt_%d_data =\n    %s;\n"
        % (
            k,
            "\n    | ".join(
                "(_wt_%d_%d ? io_writeData_%d_bits_data : 32'h0)" % (k, p, p)
                for p in range(WRITES)
            ),
        )
    )
    return "".join(lines)


def rwdata_expected(k, tail):
    dname = lambda n: "data" if n == 1 else "data_%d" % (n - 1)
    cond = ["io_readAddr_%d_addr == 5'h0" % k]
    cond += [
        "_wdata_%d_value_%d_T & (|_writeValid_%d_T)" % (k, n, n) for n in range(1, 31)
    ]
    cond += ["(&io_readAddr_%d_addr) & (|_writeValid_31_T)" % k]
    data = [
        "(_wdata_%d_value_%d_T ? %s : 32'h0)" % (k, n, dname(n)) for n in range(1, 31)
    ]
    data += ["((&io_readAddr_%d_addr) ? data_30 : 32'h0)" % k]
    return "%s ? %s : %s" % (" | ".join(cond), " | ".join(data), tail)


def make_write_through(mod):
    """Each read port's bypass, a select by read address over the 31
    words' decoded write data (data_N), as a compare of the read address
    with each write port's: the same function (a read of x0 is zero, the
    ports that write the word are ORed), and data_N is left to nothing."""
    decls = []
    for k in range(READS):
        m = re.search(
            r"^(\s*readDataBits_%d <=)(\s*io_readAddr_%d_addr == .*?);\n" % (k, k),
            mod,
            re.M | re.S,
        )
        got = m and " ".join(m.group(2).split())
        if got != rwdata_expected(k, "rdata_%d" % k):
            fail(
                "Regfile: readDataBits_%d's bypass is not the one this rewrite knows"
                % k
            )
        mod = (
            mod[: m.start()]
            + "%s\n          _wt_%d ? _wt_%d_data : rdata_%d;\n" % (m.group(1), k, k, k)
            + mod[m.end() :]
        )
        decls.append(write_through(k))
    return mod, "".join(decls)


def make_regfile_seam(text, path):
    found = list(re.finditer(r"^module Regfile\(.*?^endmodule\b", text, re.M | re.S))
    if len(found) != 1:
        fail("%s defines Regfile %d times, not once" % (path, len(found)))
    m = found[0]
    mod = m.group(0)

    def wire(name):
        hits = re.findall(
            r"^\s*wire\s+(?:\[\d+:\d+\]\s+)?%s\s*=\s*(.*?);" % re.escape(name),
            mod,
            re.M | re.S,
        )
        if len(hits) != 1:
            fail("Regfile: wire %s defined %d times" % (name, len(hits)))
        return " ".join(hits[0].split())

    # Reads: the address compares, then each port's select over the words.
    for k in range(READS):
        for n in range(1, 31):
            got = wire("_wdata_%d_value_%d_T" % (k, n))
            if got != addr_is("io_readAddr_%d_addr" % k, n):
                fail("Regfile: _wdata_%d_value_%d_T is %s" % (k, n, got))
        terms = [
            r"\(_wdata_%d_value_%d_T \? regfile_%d : 32'h0\)" % (k, n, n)
            for n in range(1, 31)
        ]
        terms.append(r"\(\(&io_readAddr_%d_addr\) \? regfile_31 : 32'h0\)" % k)
        sel = re.compile(r"\s*\|\s*".join(terms))
        hits = list(sel.finditer(mod))
        if len(hits) != 1:
            fail(
                "Regfile: read port %d's select over the words found %d times"
                % (k, len(hits))
            )
        mod = mod[: hits[0].start()] + "_rf_rdata_%d" % k + mod[hits[0].end() :]
    terms = [
        r"\(io_debugBusPort_idx == 5'h%X \? regfile_%d : 32'h0\)" % (n, n)
        for n in range(1, 31)
    ]
    terms.append(r"\(\(&io_debugBusPort_idx\) \? regfile_31 : 32'h0\)")
    hits = list(re.finditer(r"\s*\|\s*".join(terms), mod))
    if len(hits) != 1:
        fail("Regfile: the debug read's select found %d times" % len(hits))
    mod = mod[: hits[0].start()] + "_rf_rdata_%d" % DEBUG + mod[hits[0].end() :]

    # Writes: each word's data is the OR over the ports that write it.
    for n in range(1, 32):
        dname = "data" if n == 1 else "data_%d" % (n - 1)
        terms = re.fullmatch(
            r"\s*".join(
                [
                    r"\((\w+) \? io_writeData_%d_bits_data : 32'h0\)" % p
                    for p in range(WRITES)
                ]
            ).replace(r"\)\s*\(", r"\)\s*\|\s*\("),
            wire(dname),
        )
        if not terms:
            fail("Regfile: %s is not the OR of the six write ports" % dname)
        conds = list(terms.groups())
        if wire("_writeValid_%d_T" % n) != "{%s}" % ", ".join(conds):
            fail("Regfile: _writeValid_%d_T is not {%s}" % (n, ", ".join(conds)))
        for p, c in enumerate(conds):
            want = "io_writeData_%d_valid & %s" % (
                p,
                addr_is("io_writeData_%d_bits_addr" % p, n),
            )
            if p in MASKED:
                want += " & ~io_writeMask_%d_valid" % p
            if wire(c) != want:
                fail("Regfile: %s is %s, not %s" % (c, wire(c), want))
        removals = [
            r"^\s*reg\s+\[31:0\]\s+regfile_%d;\n" % n,
            r"^\s*regfile_%d <= 32'h0;\n" % n,
            r"^\s*if \(\|_writeValid_%d_T\)\s*regfile_%d <= %s;\n" % (n, n, dname),
        ]
        for r in removals:
            hits = list(re.finditer(r, mod, re.M))
            if len(hits) != 1:
                fail("Regfile: /%s/ matched %d times" % (r.strip(), len(hits)))
            mod = mod[: hits[0].start()] + mod[hits[0].end() :]
        # The simulation-only initial values (`ifdef ENABLE_INITIAL_REG_).
        mod = re.sub(r"^\s*regfile_%d = [^;]*;\n" % n, "", mod, flags=re.M)

    left = re.findall(r"\bregfile_\d+\b", mod)
    if left:
        fail("Regfile still names %s" % left[0])
    head = re.search(r"^module Regfile\(.*?\);\n", mod, re.S | re.M)
    if not re.search(r"^\s*input\s+clock,\s*$", head.group(0), re.M) or not re.search(
        r"^\s*reset,\s*$", head.group(0), re.M
    ):
        fail("Regfile's ports are not clock and reset first")
    decls = "".join("  wire [31:0] _rf_rdata_%d;\n" % k for k in range(READS + 1))
    mod, wt = make_write_through(mod)
    decls += wt
    mod = mod[: head.end()] + decls + mod[head.end() :]
    end = mod.rindex("endmodule")
    mod = mod[:end] + regfile_instance() + mod[end:]
    return text[: m.start()] + mod + text[m.end() :] + regfile_rf_module()


FIELDS = (("mantissa", 23), ("exponent", 8), ("sign", 1))
FREAD_PORTS = 3


def fnorm(text):
    return " ".join(text.split())


def make_fregfile_seam(text, path):
    """FRegfile's 32 words as fields, mantissa, exponent and sign, moved
    into FRegfile_rf: 32 x 32 (sign, exponent, mantissa from the top), four
    reads (the three read ports and the bus port), two writes of which
    write port 0 wins a word both write (FRegfile_rf's last port), every
    word reset to zero while reset is high. FRegfile keeps the rest as it
    was: the read ports' valid gating and the scoreboard."""
    found = list(re.finditer(r"^module FRegfile\(.*?^endmodule\b", text, re.M | re.S))
    if len(found) != 1:
        fail("%s defines FRegfile %d times, not once" % (path, len(found)))
    m = found[0]
    mod = m.group(0)
    head_end = mod.index("\n);\n") + 4
    head, body = mod[:head_end], mod[head_end:]
    regs = re.findall(r"^\s*reg\s+(?:\[(\d+):0\]\s+)?(\w+);", body, re.M)
    want = [
        (str(w - 1) if w > 1 else "", "fregfile_%d_%s" % (n, f))
        for n in range(32)
        for f, w in FIELDS
    ] + [("31", "scoreboard")]
    if regs != want:
        fail(
            "FRegfile: its registers are not the fields and scoreboard this surgery knows"
        )
    nb = fnorm(body)
    for n in range(32):
        v = "valid_0" if n == 0 else "valid_0_%d" % n

        def hit(port):
            # firtool writes the last word's compare as an AND reduction
            if n == 31:
                return "(&io_write_ports_%d_addr)" % port
            return "io_write_ports_%d_addr == 5'h%X" % (port, n)

        if fnorm("wire %s = io_write_ports_0_valid & %s;" % (v, hit(0))) not in nb:
            fail("FRegfile: %s is not the decode this surgery knows" % v)
        block = "if (%s | io_write_ports_1_valid & %s) begin " % (v, hit(1))
        block += " ".join(
            "fregfile_%d_%s <= %s ? io_write_ports_0_data_%s : io_write_ports_1_data_%s;"
            % (n, f, v, f, f)
            for f, _ in FIELDS
        )
        block += " end"
        if fnorm(block) not in nb:
            fail("FRegfile: word %d's write is not the one this surgery knows" % n)
        for f, w in FIELDS:
            if fnorm("fregfile_%d_%s <= %d'h0;" % (n, f, w)) not in nb:
                fail("FRegfile: word %d's %s does not reset to zero" % (n, f))
    for g, f, w in (
        ("_GEN", "mantissa", 23),
        ("_GEN_0", "exponent", 8),
        ("_GEN_1", "sign", 1),
    ):
        typ = "wire [31:0][%d:0] %s =" % (w - 1, g) if w > 1 else "wire [31:0] %s =" % g
        cat = ", ".join("{fregfile_%d_%s}" % (n, f) for n in range(31, -1, -1))
        if fnorm("%s {%s};" % (typ, cat)) not in nb:
            fail("FRegfile: %s is not the word select this surgery knows" % g)
    for k in range(FREAD_PORTS):
        for g, f, w in (("_GEN", "mantissa", 23), ("_GEN_0", "exponent", 8)):
            want_rd = (
                "assign io_read_ports_%d_data_%s = io_read_ports_%d_valid ? %s[io_read_ports_%d_addr] : %d'h0;"
                % (k, f, k, g, k, w)
            )
            if fnorm(want_rd) not in nb:
                fail(
                    "FRegfile: read port %d's %s is not the read this surgery knows"
                    % (k, f)
                )
        if (
            fnorm(
                "assign io_read_ports_%d_data_sign = io_read_ports_%d_valid & _GEN_1[io_read_ports_%d_addr];"
                % (k, k, k)
            )
            not in nb
        ):
            fail("FRegfile: read port %d's sign is not the read this surgery knows" % k)
    bus = (
        "assign io_busPort_data_0 = "
        "{_GEN_1[io_busPortAddr], _GEN_0[io_busPortAddr], _GEN[io_busPortAddr]};"
    )
    if fnorm(bus) not in nb:
        fail("FRegfile: the bus port is not the read this surgery knows")
    score = (
        "scoreboard <= {32{~io_pipelineFlush}} & scoreboard "
        "& ~((io_write_ports_0_valid ? 32'h1 << io_write_ports_0_addr : 32'h0) "
        "| (io_write_ports_1_valid ? 32'h1 << io_write_ports_1_addr : 32'h0)) "
        "| io_scoreboard_set;"
    )
    if fnorm(score) not in nb:
        fail("FRegfile: the scoreboard is not the one this surgery knows")
    rd = []
    addrs = ["io_read_ports_%d_addr" % k for k in range(FREAD_PORTS)] + [
        "io_busPortAddr"
    ]
    for k in range(4):
        rd.append("  wire [31:0] _frf_rdata_%d;\n" % k)
    new = head + "".join(rd)
    new += (
        "  // surgery.py: FRegfile's words, moved into FRegfile_rf\n"
        "  FRegfile_rf rf (\n"
        "    .clock(clock),\n"
        "    .reset(reset),\n"
        + "".join(
            "    .raddr%d(%s),\n    .rdata%d(_frf_rdata_%d),\n" % (k, a, k, k)
            for k, a in enumerate(addrs)
        )
        + "    .waddr0(io_write_ports_1_addr),\n"
        "    .wdata0({io_write_ports_1_data_sign, io_write_ports_1_data_exponent, io_write_ports_1_data_mantissa}),\n"
        "    .we0(io_write_ports_1_valid),\n"
        "    .waddr1(io_write_ports_0_addr),\n"
        "    .wdata1({io_write_ports_0_data_sign, io_write_ports_0_data_exponent, io_write_ports_0_data_mantissa}),\n"
        "    .we1(io_write_ports_0_valid)\n"
        "  );\n"
        "  reg  [31:0] scoreboard;\n"
        "  always @(posedge clock or posedge reset) begin\n"
        "    if (reset) begin\n"
        "      scoreboard <= 32'h0;\n"
        "    end\n"
        "    else begin\n"
        "      scoreboard <=\n"
        "        {32{~io_pipelineFlush}} & scoreboard\n"
        "        & ~((io_write_ports_0_valid ? 32'h1 << io_write_ports_0_addr : 32'h0)\n"
        "            | (io_write_ports_1_valid ? 32'h1 << io_write_ports_1_addr : 32'h0))\n"
        "        | io_scoreboard_set;\n"
        "    end\n"
        "  end\n"
    )
    for k in range(FREAD_PORTS):
        new += (
            "  assign io_read_ports_%d_data_mantissa = io_read_ports_%d_valid ? _frf_rdata_%d[22:0] : 23'h0;\n"
            "  assign io_read_ports_%d_data_exponent = io_read_ports_%d_valid ? _frf_rdata_%d[30:23] : 8'h0;\n"
            "  assign io_read_ports_%d_data_sign = io_read_ports_%d_valid & _frf_rdata_%d[31];\n"
            % (k, k, k, k, k, k, k, k, k)
        )
    new += (
        "  assign io_scoreboard = scoreboard;\n"
        "  assign io_busPort_data_0 = _frf_rdata_3;\n"
        "endmodule"
    )
    rf = (
        "\n\n// FRegfile's storage, moved out of FRegfile by surgery.py:\n"
        "// 32 x 32 (sign, exponent, mantissa), four combinational reads, two\n"
        "// writes, the later port (write port 0 of FRegfile) winning a word\n"
        "// both write, every word reset to zero while reset is high.\n"
        "module FRegfile_rf(\n"
        "  input         clock,\n"
        "  input         reset,\n"
        + "".join(
            "  input  [4:0]  raddr%d,\n  output [31:0] rdata%d,\n" % (k, k)
            for k in range(4)
        )
        + "  input  [4:0]  waddr0,\n  input  [31:0] wdata0,\n  input         we0,\n"
        "  input  [4:0]  waddr1,\n  input  [31:0] wdata1,\n  input         we1\n"
        ");\n"
        "  reg [31:0] mem [0:31];\n"
        + "".join("  assign rdata%d = mem[raddr%d];\n" % (k, k) for k in range(4))
        + "  integer i;\n"
        "  always @(posedge clock or posedge reset) begin\n"
        "    if (reset) begin\n"
        "      for (i = 0; i < 32; i = i + 1) mem[i] <= 32'h0;\n"
        "    end else begin\n"
        "      if (we0) mem[waddr0] <= wdata0;\n"
        "      if (we1) mem[waddr1] <= wdata1;\n"
        "    end\n"
        "  end\n"
        "endmodule\n"
    )
    return text[: m.start()] + new + text[m.end() :] + rf


def fail(msg):
    sys.exit("coralnpu surgery: " + msg)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--out-dir", required=True)
    p.add_argument("files", nargs="+")
    a = p.parse_args()
    done = 0
    for path in a.files:
        with open(path, encoding="utf-8") as f:
            text = f.read()
        if re.search(r"^module Regfile\(", text, re.M):
            text = make_regfile_seam(text, path)
            text = make_fregfile_seam(text, path)
            done += 1
        with open(
            os.path.join(a.out_dir, os.path.basename(path)), "w", encoding="utf-8"
        ) as f:
            f.write(text)
    if done != 1:
        fail("the register files found in %d files, not one" % done)


if __name__ == "__main__":
    main()
