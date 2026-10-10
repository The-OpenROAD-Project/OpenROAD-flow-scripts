// A 16 x 8 register file with two read ports and two write ports,
// behavioural, as RTL writes one. With AUTO_MEMORIES_REGFILES naming its
// spec the flow never synthesises this module: OpenROAD's
// generate_regfile builds it of placed standard cells instead.
module RegFile(
  input         clock,
  input  [3:0]  io_r0_addr,
  output [7:0]  io_r0_data,
  input  [3:0]  io_r1_addr,
  output [7:0]  io_r1_data,
  input         io_w0_en,
  input  [3:0]  io_w0_addr,
  input  [7:0]  io_w0_data,
  input         io_w1_en,
  input  [3:0]  io_w1_addr,
  input  [7:0]  io_w1_data
);
  reg [7:0] mem [0:15];
  always @(posedge clock) begin
    if (io_w0_en) mem[io_w0_addr] <= io_w0_data;
    if (io_w1_en) mem[io_w1_addr] <= io_w1_data;
  end
  assign io_r0_data = mem[io_r0_addr];
  assign io_r1_data = mem[io_r1_addr];
endmodule

// The parent: registers around the file and some logic of its own.
// Bit 0 of the file is never read, so its column is dead logic the flow
// removes after the file dissolves into its cells.
module regfile_top(
  input         clock,
  input  [3:0]  ra0, ra1, wa0, wa1,
  input  [7:0]  wd0, wd1,
  input         we0, we1,
  output [7:0]  rd0, rd1,
  output [7:0]  sum
);
  reg [3:0] ra0_q, ra1_q, wa0_q, wa1_q;
  reg [7:0] wd0_q, wd1_q;
  reg       we0_q, we1_q;
  wire [7:0] d0, d1;
  always @(posedge clock) begin
    ra0_q <= ra0; ra1_q <= ra1; wa0_q <= wa0; wa1_q <= wa1;
    wd0_q <= wd0; wd1_q <= wd1; we0_q <= we0; we1_q <= we1;
  end
  RegFile u_rf(
    .clock(clock),
    .io_r0_addr(ra0_q), .io_r0_data(d0),
    .io_r1_addr(ra1_q), .io_r1_data(d1),
    .io_w0_en(we0_q), .io_w0_addr(wa0_q), .io_w0_data(wd0_q),
    .io_w1_en(we1_q), .io_w1_addr(wa1_q), .io_w1_data(wd1_q)
  );
  reg [6:0] rd0_q, rd1_q, sum_q;
  always @(posedge clock) begin
    rd0_q <= d0[7:1]; rd1_q <= d1[7:1]; sum_q <= d0[7:1] + d1[7:1];
  end
  assign rd0 = {rd0_q, 1'b0};
  assign rd1 = {rd1_q, 1'b0};
  assign sum = {sum_q, 1'b0};
endmodule
