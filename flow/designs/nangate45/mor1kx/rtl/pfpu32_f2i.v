/////////////////////////////////////////////////////////////////////
////                                                             ////
////  pfpu32_f2i                                                 ////
////  32-bit floating point to integer converter                 ////
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

module pfpu32_f2i
(
   input             clk,
   input             rst,
   input             flush_i,  // flush pipe
   input             adv_i,    // advance pipe
   input             start_i,  // start conversion
   input             signa_i,  // input 'a' related values
   input       [9:0] exp10a_i,
   input      [23:0] fract24a_i,
   input             snan_i,   // 'a'/'b' related
   input             qnan_i,
   output reg        f2i_rdy_o,       // f2i is ready
   output reg        f2i_sign_o,      // f2i signum
   output reg [23:0] f2i_int24_o,     // f2i fractional
   output reg  [4:0] f2i_shr_o,       // f2i required shift right value
   output reg  [3:0] f2i_shl_o,       // f2i required shift left value   
   output reg        f2i_ovf_o,       // f2i overflow flag
   output reg        f2i_snan_o       // f2i signaling NaN output reg
);

  /*
     Any stage's output is registered.
     Definitions:
       s??o_name - "S"tage number "??", "O"utput
       s??t_name - "S"tage number "??", "T"emporary (internally)
  */

  // exponent after moving binary point at the end of mantissa
  // bias is also removed
  wire [9:0] s1t_exp10m = exp10a_i - 10'd150; // (- 127 - 23)

  // detect if now shift right is required
  wire [9:0] s1t_shr_t = {10{s1t_exp10m[9]}} & (10'd150 - exp10a_i);
  // limit right shift by 31
  wire [4:0] s1t_shr = s1t_shr_t[4:0] | {5{|s1t_shr_t[9:5]}};

  // detect if left shift required for mantissa
  // (limited by 15)
  wire [3:0] s1t_shl = {4{~s1t_exp10m[9]}} & (s1t_exp10m[3:0] | {4{|s1t_exp10m[9:4]}});
  // check overflow
  wire s1t_is_shl_gt8 = s1t_shl[3] & (|s1t_shl[2:0]);
  wire s1t_is_shl_eq8 = s1t_shl[3] & (~(|s1t_shl[2:0]));
  wire s1t_is_shl_ovf =
     s1t_is_shl_gt8 |
    (s1t_is_shl_eq8 & (~signa_i)) |
    (s1t_is_shl_eq8 &   signa_i & (|fract24a_i[22:0]));


  // registering output
  always @(posedge clk) begin
    if(adv_i) begin
        // input related
      f2i_snan_o  <= snan_i;
        // computation related
      f2i_sign_o  <= signa_i & (!(qnan_i | snan_i)); // if 'a' is a NaN than ouput is max. positive
      f2i_int24_o <= fract24a_i;
      f2i_shr_o   <= s1t_shr;
      f2i_shl_o   <= s1t_shl;
      f2i_ovf_o   <= s1t_is_shl_ovf;
    end // (reset or flush) / advance
  end // posedge clock

  // ready is special case
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst)
      f2i_rdy_o <= 1'b0;
    else if(flush_i)
      f2i_rdy_o <= 1'b0;
    else if(adv_i)
      f2i_rdy_o <= start_i;
  end // posedge clock
 
endmodule // pfpu32_f2i
