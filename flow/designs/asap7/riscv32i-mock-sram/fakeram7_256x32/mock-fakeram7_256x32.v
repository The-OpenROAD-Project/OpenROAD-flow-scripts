// See platforms/asap7/verilog/fakeram7_256x32.v for the original file
//
// Has been modified such that there are only 4 rows in the SRAM, and
// all the address bits are in used by xor'ing them together to get
// a 2-bit index
module fakeram7_256x32
(
   rd_out,
   addr_in,
   we_in,
   wd_in,
   clk,
   ce_in
);
   parameter BITS = 32;
   parameter WORD_DEPTH = 256;
   parameter ADDR_WIDTH = 8;
   parameter corrupt_mem_on_X_p = 1;

   output reg [BITS-1:0]    rd_out;
   input  [ADDR_WIDTH-1:0]  addr_in;
   input                    we_in;
   input  [BITS-1:0]        wd_in;
   input                    clk;
   input                    ce_in;

   integer j;

   reg [BITS-1:0] mem [0:3];  // Change WORD_DEPTH to 4
   reg [1:0] index;

   always @(posedge clk)
   begin
      if (ce_in)
      begin
         // Calculate 2-bit index by XORing all address bits together
         index <= addr_in[0] ^ addr_in[1] ^ addr_in[2] ^ addr_in[3] ^ addr_in[4] ^ addr_in[5] ^ addr_in[6] ^ addr_in[7];

         if (we_in)
         begin
            // Use the 2-bit index to access the array
            mem[index] <= wd_in;
         end
         else
         begin
            // Use the 2-bit index to access the array
            rd_out <= mem[index];
         end
      end
   end

endmodule
