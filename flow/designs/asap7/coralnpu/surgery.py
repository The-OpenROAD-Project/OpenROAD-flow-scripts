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
    p.add_argument("files", nargs="+")
    a = p.parse_args()
    done = 0
    for path in a.files:
        with open(path) as f:
            text = f.read()
        if MARKER.search(text):
            text, removed = strip_layers(text, path)
            text = make_sram_seams(text, path)
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
