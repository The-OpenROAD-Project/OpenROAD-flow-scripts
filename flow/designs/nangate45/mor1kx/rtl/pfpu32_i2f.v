/////////////////////////////////////////////////////////////////////
////                                                             ////
////  pfpu32_i2f                                                 ////
////  32-bit integer to floating point converter                 ////
////                                                             ////
////  Author: Andrey Bacherov                                    ////
////          avbacherov@opencores.org                           ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2014 Andrey Bacherov                          ////
////                    avbacherov@opencores.org                 ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

`include "mor1kx-defines.v"

module pfpu32_i2f
(
   input             clk,
   input             rst,
   input             flush_i,  // flush pipe
   input             adv_i,    // advance pipe
   input             start_i,  // start conversion
   input      [31:0] opa_i,
   output reg        i2f_rdy_o,       // i2f is ready
   output reg        i2f_sign_o,      // i2f signum
   output reg  [3:0] i2f_shr_o,
   output reg  [4:0] i2f_shl_o,
   output reg [31:0] i2f_fract32_o
);

  /*
     Any stage's output is registered.
     Definitions:
       s??o_name - "S"tage number "??", "O"utput
       s??t_name - "S"tage number "??", "T"emporary (internally)
  */

  // signum of input
  wire s1t_signa = opa_i[31];
  // magnitude (tow's complement for negative input)
  wire [31:0] s1t_fract32 =
      (opa_i ^ {32{s1t_signa}}) + {31'd0,s1t_signa};
  // normalization shifts
  reg [3:0] s1t_shrx;
  reg [4:0] s1t_shlx;
  // shift goal:
  // 23 22                    0
  // |  |                     |
  // h  fffffffffffffffffffffff
  // right shift
  always @(s1t_fract32[31:24]) begin
    casez(s1t_fract32[31:24])  // synopsys full_case parallel_case
      8'b1???????:  s1t_shrx = 4'd8;
      8'b01??????:  s1t_shrx = 4'd7;
      8'b001?????:  s1t_shrx = 4'd6;
      8'b0001????:  s1t_shrx = 4'd5;
      8'b00001???:  s1t_shrx = 4'd4;
      8'b000001??:  s1t_shrx = 4'd3;
      8'b0000001?:  s1t_shrx = 4'd2;
      8'b00000001:  s1t_shrx = 4'd1;
      8'b00000000:  s1t_shrx = 4'd0;
    endcase
  end
  // left shift
  always @(s1t_fract32[23:0]) begin
    casez(s1t_fract32[23:0])  // synopsys full_case parallel_case
      24'b1???????????????????????:  s1t_shlx = 5'd0; // hidden '1' is in its plase
      24'b01??????????????????????:  s1t_shlx = 5'd1;
      24'b001?????????????????????:  s1t_shlx = 5'd2;
      24'b0001????????????????????:  s1t_shlx = 5'd3;
      24'b00001???????????????????:  s1t_shlx = 5'd4;
      24'b000001??????????????????:  s1t_shlx = 5'd5;
      24'b0000001?????????????????:  s1t_shlx = 5'd6;
      24'b00000001????????????????:  s1t_shlx = 5'd7;
      24'b000000001???????????????:  s1t_shlx = 5'd8;
      24'b0000000001??????????????:  s1t_shlx = 5'd9;
      24'b00000000001?????????????:  s1t_shlx = 5'd10;
      24'b000000000001????????????:  s1t_shlx = 5'd11;
      24'b0000000000001???????????:  s1t_shlx = 5'd12;
      24'b00000000000001??????????:  s1t_shlx = 5'd13;
      24'b000000000000001?????????:  s1t_shlx = 5'd14;
      24'b0000000000000001????????:  s1t_shlx = 5'd15;
      24'b00000000000000001???????:  s1t_shlx = 5'd16;
      24'b000000000000000001??????:  s1t_shlx = 5'd17;
      24'b0000000000000000001?????:  s1t_shlx = 5'd18;
      24'b00000000000000000001????:  s1t_shlx = 5'd19;
      24'b000000000000000000001???:  s1t_shlx = 5'd20;
      24'b0000000000000000000001??:  s1t_shlx = 5'd21;
      24'b00000000000000000000001?:  s1t_shlx = 5'd22;
      24'b000000000000000000000001:  s1t_shlx = 5'd23;
      24'b000000000000000000000000:  s1t_shlx = 5'd0;
    endcase
  end


  // registering output
  always @(posedge clk) begin
    if(adv_i) begin
        // computation related
      i2f_sign_o    <= s1t_signa;
      i2f_shr_o     <= s1t_shrx;
      i2f_shl_o     <= s1t_shlx;
      i2f_fract32_o <= s1t_fract32;
    end // advance
  end // posedge clock

  // ready is special case
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst)
      i2f_rdy_o <= 1'b0;
    else if(flush_i)
      i2f_rdy_o <= 1'b0;
    else if(adv_i)
      i2f_rdy_o <= start_i;
  end // posedge clock

endmodule // pfpu32_i2f
