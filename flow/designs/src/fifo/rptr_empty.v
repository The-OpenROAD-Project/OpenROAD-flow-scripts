module rptr_empty #(
    parameter ADDRSIZE = 4
) (
    output reg rempty,
    output [ADDRSIZE-1:0] raddr,
    output reg [ADDRSIZE : 0] rptr,
    input [ADDRSIZE : 0] rq2_wptr,
    input rinc,
    rclk,
    rrst_n
);
  reg [ADDRSIZE:0] rbin;
  wire [ADDRSIZE:0] rgraynext, rbinnext;
  //-------------------
  // GRAYSTYLE2 pointer
  //-------------------
  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) {rbin, rptr} <= 0;
    else {rbin, rptr} <= {rbinnext, rgraynext};
  // Memory read-address pointer (okay to use binary to address memory)
  assign raddr = rbin[ADDRSIZE-1:0];
  assign rbinnext = rbin + (rinc & ~rempty);
  assign rgraynext = (rbinnext >> 1) ^ rbinnext;
  //---------------------------------------------------------------
  // FIFO empty when the next rptr == synchronized wptr or on reset
  //---------------------------------------------------------------
  assign rempty_val = (rgraynext == rq2_wptr);
  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) rempty <= 1'b1;
    else rempty <= rempty_val;
endmodule
