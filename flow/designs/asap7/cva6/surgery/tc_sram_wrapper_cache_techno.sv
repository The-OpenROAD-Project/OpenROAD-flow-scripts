module tc_sram_wrapper_cache_techno #(
  parameter int unsigned NumWords     = 32'd1024, // Number of Words in data array
  parameter int unsigned DataWidth    = 32'd128,  // Data signal width
  parameter int unsigned ByteWidth    = 32'd8,    // Width of a data byte
  parameter int unsigned NumPorts     = 32'd2,    // Number of read and write ports
  parameter int unsigned Latency      = 32'd1,    // Latency when the read data is available
  parameter              SimInit      = "none",   // Simulation initialization
  parameter              BYTE_ACCESS  = 1,
  parameter bit          PrintSimCfg  = 1'b0,     // Print configuration
  parameter int unsigned AddrWidth = (NumWords > 32'd1) ? $clog2(NumWords) : 32'd1,
  parameter int unsigned BeWidth   = (DataWidth + ByteWidth - 32'd1) / ByteWidth, // ceil_div
  parameter type         addr_t    = logic [AddrWidth-1:0],
  parameter type         data_t    = logic [DataWidth-1:0],
  parameter type         be_t      = logic [BeWidth-1:0]
) (
  input  logic                 clk_i,
  input  logic                 rst_ni,
  input  logic  [NumPorts-1:0] req_i,
  input  logic  [NumPorts-1:0] we_i,
  input  addr_t [NumPorts-1:0] addr_i,
  input  data_t [NumPorts-1:0] wdata_i,
  input  be_t   [NumPorts-1:0] be_i,
  output data_t [NumPorts-1:0] rdata_o
);
  // SYNTH_VERILOG_SURGERY (asap7/cva6/surgery.py): a single-port SRAM with
  // byte enables behind the techno cut, for the shapes cv32a65x uses.
  if (NumPorts != 1 || Latency != 1 || ByteWidth != 8 || NumWords != 64
      || !(DataWidth == 256 || DataWidth == 25)) begin : gen_surgery_shape
    $error("cva6 surgery: tc_sram_wrapper_cache_techno rewritten for 1 port, latency 1, 64 words of 256 or 25 bits");
  end
  if (DataWidth == 256) begin : gen_data
    cva6_icache_data_sram i_sram (
        .clk(clk_i), .cs(req_i[0]), .we(we_i[0]), .addr(addr_i[0]),
        .wdata(wdata_i[0]), .be(be_i[0]), .rdata(rdata_o[0]));
  end else begin : gen_tag
    cva6_icache_tag_sram i_sram (
        .clk(clk_i), .cs(req_i[0]), .we(we_i[0]), .addr(addr_i[0]),
        .wdata(wdata_i[0]), .be(be_i[0]), .rdata(rdata_o[0]));
  end
endmodule
