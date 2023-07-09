module fakeregfile_32x46
(
   rdata_out,
   raddr_in,
   ren_in,
   wdata_in,
   waddr_in,
   wen_in,
   wmask_in,
   rclk,
   wclk,
);
   parameter BITS = 46;
   parameter WORD_DEPTH = 32;
   parameter ADDR_WIDTH = 5;
   parameter corrupt_mem_on_X_p = 1;

   output reg [BITS-1:0]    rdata_out;
   input  [ADDR_WIDTH-1:0]  raddr_in;
   input                    ren_in;
   input  [BITS-1:0]        wdata_in;
   input  [ADDR_WIDTH-1:0]  waddr_in;
   input                    wen_in;
   input  [BITS-1:0]        wmask_in;
   input                    rclk;
   input                    wclk;

   reg    [BITS-1:0]        mem [0:WORD_DEPTH-1];

   integer j;

   always @(posedge wclk)
   begin
       //if ((wen_in !== 1'b1 && wen_in !== 1'b0) && corrupt_mem_on_X_p)
       if (corrupt_mem_on_X_p &&
           ((^wen_in === 1'bx) || (^waddr_in === 1'bx))
          )
       begin
          // WEN or ADDR is unknown, so corrupt entire array (using unsynthesizeable for loop)
          for (j = 0; j < WORD_DEPTH; j = j + 1)
             mem[j] <= 'x;
          $display("warning: wen_in is %b, waddr_in = %x in fakeregfile_32x46", wen_in, waddr_in);
       end
       else if (wen_in)
       begin
          mem[waddr_in] <= (wdata_in) | (mem[waddr_in]);
       end
   end

   always @(posedge rclk)
   begin
      if (ren_in)
         rdata_out <= mem[raddr_in];
      end
      else
      begin
         // Make sure read fails if ce_in is low
         rdata_out <= 'x;
      end
   end

   // Timing check placeholders (will be replaced during SDF back-annotation)
   reg notifier;
   specify
      // Delay from rclk to rdata_out
      (posedge rclk *> rdata_out) = (0, 0);

      // Timing checks
      $width     (posedge rclk,           0, 0, notifier);
      $width     (negedge rclk,           0, 0, notifier);
      $period    (posedge rclk,           0,    notifier);
      $setuphold (posedge rclk, ren_in,   0, 0, notifier);
      $setuphold (posedge rclk, raddr_in, 0, 0, notifier);
      $width     (posedge wclk,           0, 0, notifier);
      $width     (negedge wclk,           0, 0, notifier);
      $period    (posedge wclk,           0,    notifier);
      $setuphold (posedge wclk, wen_in,   0, 0, notifier);
      $setuphold (posedge wclk, waddr_in, 0, 0, notifier);
      $setuphold (posedge wclk, wdata_in, 0, 0, notifier);
   endspecify

endmodule
