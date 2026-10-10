"""SYNTH_VERILOG_SURGERY for coralnpu: the snapshot made a synthesis build.

A hack. CoreMiniAxi.sv is firtool's output for CoreMiniAxi with every
file of the build concatenated, each behind a marker line

    // ----- 8< ----- FILE "<path>" ----- 8< -----

and among them firtool's verification layers, `verification/...`: the
layer bind files and the *_Verification_Assert modules they bind into
the core. A layer is opt-in: a build includes a layer's files only to
enable it, and a synthesis build does not. This removes every
`verification/` file, which is the snapshot as firtool writes it without
layers enabled, and checks that nothing left names a verification
module or binds one.

Each TCM SRAM, Sram_512x128 and Sram_2048x128, keeps its array inside a
wrapper: a registered read address and a byte-masked write around
`mem`. AUTO_MEMORIES converts a memory that is a module of its own with
firtool's memory ports (R0_addr, W0_mask, ...), which is what Chisel
emits for a SyncReadMem, so each wrapper becomes an instance of
Sram_<depth>x128_mem, that module, with one read-write port as the
wrapper has (one address, `write` the mode): a read, `enable` without
`write`, returns the word at that address on the next cycle; a write
writes the bytes `wmask` selects. The wrapper registers the read address
only on a read, so its output holds the word last read until the next
read; firtool's leaves the output undefined on a cycle after no read,
and nothing reads it then (Chisel's SRAM takes the data the cycle after
a read).

The snapshot is recognised by its markers and each wrapper by its text,
token for token, comments and whitespace aside: anything else stops the
build. Every other file is copied unchanged.
"""

import argparse
import os
import re
import sys

MARKER = re.compile(r'^// ----- 8< ----- FILE "([^"]+)" ----- 8< -----$', re.M)


SRAM_TEMPLATE = "module Sram_{D}x128( input clock, input enable, input write, input [{AM1}:0] addr, input [127:0] wdata, input [15:0] wmask, output [127:0] rdata ); `ifdef USE_ASAP7 wire [127:0] nwmask; genvar i; generate for (i = 0; i < 16; i++) begin assign nwmask[8*i +: 8] = {8{wmask[i]}}; end endgenerate fakeram_{D}x128 u_asap7_sram ( .rd_out(rdata), .addr_in(addr), .wd_in(wdata), .we_in(write), .ce_in(enable), .clk(clock) ); `else reg [127:0] mem [0:{DM1}]; reg [{AM1}:0] raddr; assign rdata = mem[raddr]; `ifndef SYNTHESIS task randomMemoryAll; for (int i = 0; i < 128; i++) begin for (int j = 0; j < {D}; j++) begin mem[i][j] = $random; end end endtask initial begin randomMemoryAll; end `endif always @(posedge clock) begin for (int i = 0; i < 16; i++) begin if (enable & write & wmask[i]) begin mem[addr][i*8 +: 8] <= wdata[8*i +: 8]; end end if (enable & ~write) begin raddr <= addr; end end `endif endmodule"

SRAM_DEPTHS = (512, 2048)


def norm(text):
    text = re.sub(r"//[^\n]*", "", text)
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return " ".join(text.split())


def sram_expected(depth):
    a = depth.bit_length() - 1
    return (
        SRAM_TEMPLATE.replace("{D}", str(depth))
        .replace("{DM1}", str(depth - 1))
        .replace("{AM1}", str(a - 1))
    )


def sram_replacement(depth):
    a = depth.bit_length() - 1
    return f"""module Sram_{depth}x128(
  input          clock,
  input          enable,
  input          write,
  input  [{a - 1}:0]   addr,
  input  [127:0] wdata,
  input  [15:0]  wmask,
  output [127:0] rdata
);
  // SYNTH_VERILOG_SURGERY (asap7/coralnpu/surgery.py): the array as a
  // memory module of firtool's convention, which AUTO_MEMORIES converts.
  Sram_{depth}x128_mem mem (
    .RW0_addr(addr), .RW0_en(enable), .RW0_clk(clock), .RW0_wmode(write),
    .RW0_wdata(wdata), .RW0_rdata(rdata), .RW0_wmask(wmask)
  );
endmodule

module Sram_{depth}x128_mem(
  input  [{a - 1}:0]   RW0_addr,
  input          RW0_en,
  input          RW0_clk,
  input          RW0_wmode,
  input  [127:0] RW0_wdata,
  output [127:0] RW0_rdata,
  input  [15:0]  RW0_wmask
);
  reg [127:0] Memory [0:{depth - 1}];
  reg _RW0_ren_d0;
  reg [{a - 1}:0] _RW0_raddr_d0;
  integer i;
  always @(posedge RW0_clk) begin
    _RW0_ren_d0 <= RW0_en & ~RW0_wmode;
    _RW0_raddr_d0 <= RW0_addr;
    if (RW0_en & RW0_wmode)
      for (i = 0; i < 16; i = i + 1)
        if (RW0_wmask[i])
          Memory[RW0_addr][i*8 +: 8] <= RW0_wdata[i*8 +: 8];
  end
  assign RW0_rdata = _RW0_ren_d0 ? Memory[_RW0_raddr_d0] : 128'bx;
endmodule"""


def make_sram_seams(text, path):
    for depth in SRAM_DEPTHS:
        name = "Sram_%dx128" % depth
        found = list(
            re.finditer(r"^module\s+%s\(.*?^endmodule\b" % name, text, re.M | re.S)
        )
        if len(found) != 1:
            fail("%s defines %s %d times, not once" % (path, name, len(found)))
        m = found[0]
        if norm(m.group(0)) != sram_expected(depth):
            fail("%s in %s is not the SRAM wrapper this rewrite knows" % (name, path))
        text = text[: m.start()] + sram_replacement(depth) + text[m.end() :]
    return text


READS = 8
WRITES = 6
MASKED = (1, 2, 3)


def regfile_rf_module():
    ports = ["  input clock", "  input reset"]
    for k in range(READS):
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
        for k in range(READS)
    )
    return """
// SYNTH_VERILOG_SURGERY (asap7/coralnpu/surgery.py --regfile): Regfile's
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
            r"^(\s*wire\s+\[31:0\]\s+rwdata_%d\s*=)(.*?);\n" % k, mod, re.M | re.S
        )
        if not m:
            fail("Regfile: no rwdata_%d" % k)
        got = " ".join(m.group(2).split())
        tails = ["_rf_rdata_%d" % k, "rdata_%d_value_5_0" % k]
        if not any(got == rwdata_expected(k, t) for t in tails):
            fail("Regfile: rwdata_%d is not the bypass this rewrite knows" % k)
        mod = (
            mod[: m.start()]
            + "%s\n    _wt_%d ? _wt_%d_data : _rf_rdata_%d;\n" % (m.group(1), k, k, k)
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
        # The simulation-only initial values (`ifndef SYNTHESIS).
        mod = re.sub(r"^\s*regfile_%d = [^;]*;\n" % n, "", mod, flags=re.M)

    left = re.findall(r"\bregfile_\d+\b", mod)
    if left:
        fail("Regfile still names %s" % left[0])
    head = re.search(r"^module Regfile\(.*?\);\n", mod, re.S | re.M)
    if not re.search(r"^\s*input\s+clock,\s*$", head.group(0), re.M) or not re.search(
        r"^\s*reset,\s*$", head.group(0), re.M
    ):
        fail("Regfile's ports are not clock and reset first")
    decls = "".join("  wire [31:0] _rf_rdata_%d;\n" % k for k in range(READS))
    mod, wt = make_write_through(mod)
    decls += wt
    mod = mod[: head.end()] + decls + mod[head.end() :]
    end = mod.rindex("endmodule")
    mod = mod[:end] + regfile_instance() + mod[end:]
    return text[: m.start()] + mod + text[m.end() :] + regfile_rf_module()


def fail(msg):
    sys.exit("coralnpu surgery: " + msg)


def strip_layers(text, path):
    """text without its verification/ files."""
    marks = list(MARKER.finditer(text))
    out = []
    pos = 0
    removed = []
    for i, m in enumerate(marks):
        end = marks[i + 1].start() if i + 1 < len(marks) else len(text)
        if m.group(1).startswith("verification/"):
            out.append(text[pos : m.start()])
            pos = end
            removed.append(m.group(1))
    out.append(text[pos:])
    if not removed:
        fail("%s holds no verification/ files" % path)
    text = "".join(out)
    left = re.findall(r"^\s*bind\b|\w+_Verification_\w+", text, re.M)
    if left:
        fail("%s still names %s after the layers are removed" % (path, left[0]))
    return text, removed


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--out-dir", required=True)
    p.add_argument(
        "--regfile",
        action="store_true",
        help="also move Regfile's storage into Regfile_rf",
    )
    p.add_argument("files", nargs="+")
    a = p.parse_args()
    done = 0
    for path in a.files:
        with open(path) as f:
            text = f.read()
        if MARKER.search(text):
            text, removed = strip_layers(text, path)
            text = make_sram_seams(text, path)
            if a.regfile:
                text = make_regfile_seam(text, path)
            print(
                "coralnpu surgery: %s: removed %d verification files"
                % (os.path.basename(path), len(removed))
            )
            done += 1
        with open(os.path.join(a.out_dir, os.path.basename(path)), "w") as f:
            f.write(text)
    if done != 1:
        fail("the snapshot found in %d files, not one" % done)


if __name__ == "__main__":
    main()
