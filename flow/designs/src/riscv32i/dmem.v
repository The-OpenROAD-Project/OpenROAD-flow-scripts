//------------------------------------------------
// dmem.v
// James E. Stine
// February 1, 2018
// Oklahoma State University
// ECEN 4243
// Harvard Architecture Data Memory (Big Endian)
//------------------------------------------------

module dmem (
   input clk,      
   input r_w,
   input [31:0] mem_addr,
   input [31:0] mem_data,
   output reg [31:0] mem_out
);

   reg [1:0] sel_mem;
   reg [3:0] ctrl_mem;
   reg [31:0] inter_dmem;
   
   always @* begin
      ctrl_mem = (mem_addr[31:30] == 2'b10) ? 4'b1000 :
                 (mem_addr[23:22] == 2'b10) ? 4'b0100 :
                 (mem_addr[15:14] == 2'b10) ? 4'b0010 :
                 4'b0001;
      
      if (!r_w) begin
         inter_dmem = 32'h0;
      end else begin
         inter_dmem = mem_data;
      end
   end
   
   fakeram7_256x32 dmem0 (
      .clk(clk),
      .addr_in(mem_addr[7:0]),
      .ce_in(ctrl_mem[0]),
      .we_in(ctrl_mem[0] & r_w),
      .wd_in(mem_data),
      .rd_out(inter_dmem[31:0])
   );
   
   fakeram7_256x32 dmem1 (
      .clk(clk),
      .addr_in(mem_addr[15:8]),
      .ce_in(ctrl_mem[1]),
      .we_in(ctrl_mem[1] & r_w),
      .wd_in(mem_data),
      .rd_out(inter_dmem[63:32])
   );
   
   fakeram7_256x32 dmem2 (
      .clk(clk),
      .addr_in(mem_addr[23:16]),
      .ce_in(ctrl_mem[2]),
      .we_in(ctrl_mem[2] & r_w),
      .wd_in(mem_data),
      .rd_out(inter_dmem[95:64])
   );
   
   fakeram7_256x32 dmem3 (
      .clk(clk),
      .addr_in(mem_addr[31:24]),
      .ce_in(ctrl_mem[3]),
      .we_in(ctrl_mem[3] & r_w),
      .wd_in(mem_data),
      .rd_out(inter_dmem[127:96])
   );
   
   always @* begin
      sel_mem = (mem_addr[31:30] == 2'b10) ? 2'b11 :
                (mem_addr[23:22] == 2'b10) ? 2'b10 :
                (mem_addr[15:14] == 2'b10) ? 2'b01 :
                2'b00;
   
      case (sel_mem)
	2'b00: mem_out = inter_dmem3;
	2'b01: mem_out = inter_dmem2;
	2'b10: mem_out = inter_dmem1;
	2'b11: mem_out = inter_dmem0;
      endcase // case (sel_mem)
   end

endmodule // mem
