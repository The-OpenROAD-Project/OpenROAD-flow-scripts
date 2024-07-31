//////////////////////////////////////////////////////////////////////
//                                                                  //
//    pfpu32_muldiv                                                 //
//                                                                  //
//    This file is part of the mor1kx project                       //
//    https://github.com/openrisc/mor1kx                            //
//                                                                  //
//    Description                                                   //
//    combined multiplier/divisor pipeline for                      //
//    single precision floating point numbers                       //
//                                                                  //
//    Author(s):                                                    //
//          Andrey Bacherov, avbacherov@opencores.org               //
//                                                                  //
//////////////////////////////////////////////////////////////////////
//                                                                  //
//  Copyright (C) 2015                                              //
//                                                                  //
//  This source file may be used and distributed without            //
//  restriction provided that this copyright statement is not       //
//  removed from the file and that any derivative work contains     //
//  the original copyright notice and the associated disclaimer.    //
//                                                                  //
//    THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY           //
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED       //
//  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       //
//  FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR          //
//  OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,             //
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES        //
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE       //
//  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR            //
//  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF      //
//  LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT      //
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT      //
//  OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             //
//  POSSIBILITY OF SUCH DAMAGE.                                     //
//////////////////////////////////////////////////////////////////////

`include "mor1kx-defines.v"

module pfpu32_muldiv
(
   input             clk,
   input             rst,
   input             flush_i,  // flushe pipe
   input             adv_i,    // advance pipe
   input             start_i,  // start
   input             is_div_i, // 1: division, 0: multiplication
   // input 'a' related values
   input             signa_i,
   input       [9:0] exp10a_i,
   input      [23:0] fract24a_i,
   input             infa_i,
   input             zeroa_i,
   // input 'b' related values
   input             signb_i,
   input       [9:0] exp10b_i,
   input      [23:0] fract24b_i,
   input             infb_i,
   input             zerob_i,
   // 'a'/'b' related
   input             snan_i,
   input             qnan_i,
   input             anan_sign_i,
   // MUL/DIV common outputs
   output reg        muldiv_rdy_o,       // ready
   output reg        muldiv_sign_o,      // signum
   output reg  [9:0] muldiv_shr_o,       // do right shift in align stage
   output reg        muldiv_shl_o,       // do left shift in align stage
   output reg  [9:0] muldiv_exp10sh0_o,  // exponent for no shift in align
   output reg [27:0] muldiv_fract28_o,   // fractional with appended {r,s} bits
   output reg        muldiv_inv_o,       // invalid operation flag
   output reg        muldiv_inf_o,       // infinity output reg
   output reg        muldiv_snan_o,      // signaling NaN output reg
   output reg        muldiv_qnan_o,      // quiet NaN output reg
   output reg        muldiv_anan_sign_o, // signum for output nan
   // DIV additional outputs
   output reg        div_op_o,           // operation is division
   output reg        div_sign_rmnd_o,    // signum of reminder for IEEE compliant rounding
   output reg        div_dbz_o           // div division by zero flag
);

  /*
     Any stage's output is registered.
     Definitions:
       s??o_name - "S"tage number "??", "O"utput
       s??t_name - "S"tage number "??", "T"emporary (internally)
  */


  /* Stage #1: pre-operation stage */


    // detection of some exceptions
  wire s0t_inv = is_div_i ? ((zeroa_i & zerob_i) | (infa_i & infb_i)) : // div: 0/0, inf/inf -> invalid operation; snan output
                            ((zeroa_i & infb_i) | (zerob_i & infa_i));  // mul: 0 * inf -> invalid operation; snan output
    // division by zero
  wire s0t_dbz   = is_div_i & (~zeroa_i) & (~infa_i) & zerob_i;
    //   inf input
  wire s0t_inf_i = infa_i | (infb_i & (~is_div_i)); // for DIV only infA is used

    // force intermediate results to zero
  wire s0t_opc_0 = zeroa_i | zerob_i | (is_div_i & (infa_i | infb_i));

  // count leading zeros
  reg [4:0] s0t_nlza;
  always @(fract24a_i) begin
    casez(fract24a_i) // synopsys full_case parallel_case
      24'b1???????????????????????: s0t_nlza =  0;
      24'b01??????????????????????: s0t_nlza =  1;
      24'b001?????????????????????: s0t_nlza =  2;
      24'b0001????????????????????: s0t_nlza =  3;
      24'b00001???????????????????: s0t_nlza =  4;
      24'b000001??????????????????: s0t_nlza =  5;
      24'b0000001?????????????????: s0t_nlza =  6;
      24'b00000001????????????????: s0t_nlza =  7;
      24'b000000001???????????????: s0t_nlza =  8;
      24'b0000000001??????????????: s0t_nlza =  9;
      24'b00000000001?????????????: s0t_nlza = 10;
      24'b000000000001????????????: s0t_nlza = 11;
      24'b0000000000001???????????: s0t_nlza = 12;
      24'b00000000000001??????????: s0t_nlza = 13;
      24'b000000000000001?????????: s0t_nlza = 14;
      24'b0000000000000001????????: s0t_nlza = 15;
      24'b00000000000000001???????: s0t_nlza = 16;
      24'b000000000000000001??????: s0t_nlza = 17;
      24'b0000000000000000001?????: s0t_nlza = 18;
      24'b00000000000000000001????: s0t_nlza = 19;
      24'b000000000000000000001???: s0t_nlza = 20;
      24'b0000000000000000000001??: s0t_nlza = 21;
      24'b00000000000000000000001?: s0t_nlza = 22;
      24'b000000000000000000000001: s0t_nlza = 23;
      24'b000000000000000000000000: s0t_nlza =  0; // zero rezult
    endcase
  end // nlz for 'a'

  // count leading zeros
  reg [4:0] s0t_nlzb;
  always @(fract24b_i) begin
    casez(fract24b_i) // synopsys full_case parallel_case
      24'b1???????????????????????: s0t_nlzb =  0;
      24'b01??????????????????????: s0t_nlzb =  1;
      24'b001?????????????????????: s0t_nlzb =  2;
      24'b0001????????????????????: s0t_nlzb =  3;
      24'b00001???????????????????: s0t_nlzb =  4;
      24'b000001??????????????????: s0t_nlzb =  5;
      24'b0000001?????????????????: s0t_nlzb =  6;
      24'b00000001????????????????: s0t_nlzb =  7;
      24'b000000001???????????????: s0t_nlzb =  8;
      24'b0000000001??????????????: s0t_nlzb =  9;
      24'b00000000001?????????????: s0t_nlzb = 10;
      24'b000000000001????????????: s0t_nlzb = 11;
      24'b0000000000001???????????: s0t_nlzb = 12;
      24'b00000000000001??????????: s0t_nlzb = 13;
      24'b000000000000001?????????: s0t_nlzb = 14;
      24'b0000000000000001????????: s0t_nlzb = 15;
      24'b00000000000000001???????: s0t_nlzb = 16;
      24'b000000000000000001??????: s0t_nlzb = 17;
      24'b0000000000000000001?????: s0t_nlzb = 18;
      24'b00000000000000000001????: s0t_nlzb = 19;
      24'b000000000000000000001???: s0t_nlzb = 20;
      24'b0000000000000000000001??: s0t_nlzb = 21;
      24'b00000000000000000000001?: s0t_nlzb = 22;
      24'b000000000000000000000001: s0t_nlzb = 23;
      24'b000000000000000000000000: s0t_nlzb =  0; // zero result
    endcase
  end // nlz of 'b'


  // pre-norm stage outputs
  //   input related
  reg s0o_inv, s0o_inf_i,
      s0o_snan_i, s0o_qnan_i, s0o_anan_i_sign;
  //   computation related
  reg        s0o_is_div;
  reg        s0o_opc_0;
  reg        s0o_signc;
  reg  [9:0] s0o_exp10a;
  reg [23:0] s0o_fract24a;
  reg  [4:0] s0o_shla;
  reg  [9:0] s0o_exp10b;
  reg [23:0] s0o_fract24b;
  reg  [4:0] s0o_shlb;
  // DIV additional outputs
  reg        s0o_dbz;
  // registering
  always @(posedge clk) begin
    if(adv_i) begin
        // input related
      s0o_inv         <= s0t_inv;
      s0o_inf_i       <= s0t_inf_i;
      s0o_snan_i      <= snan_i;
      s0o_qnan_i      <= qnan_i;
      s0o_anan_i_sign <= anan_sign_i;
        // computation related
      s0o_is_div   <= is_div_i;
      s0o_opc_0    <= s0t_opc_0;
      s0o_signc    <= signa_i ^ signb_i;
      s0o_exp10a   <= exp10a_i;
      s0o_fract24a <= fract24a_i;
      s0o_shla     <= s0t_nlza;
      s0o_exp10b   <= exp10b_i;
      s0o_fract24b <= fract24b_i;
      s0o_shlb     <= s0t_nlzb;
        // DIV additional outputs
      s0o_dbz   <= s0t_dbz;
    end // push pipe
  end

  // route ready through side back
  reg s0o_ready;
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst)
      s0o_ready <= 0;
    else if(flush_i)
      s0o_ready <= 0;
    else if(adv_i)
      s0o_ready <= start_i;
  end // posedge clock


  // left-shift the dividend and divisor
  wire [23:0] s1t_fract24a_shl = s0o_fract24a << s0o_shla;
  wire [23:0] s1t_fract24b_shl = s0o_fract24b << s0o_shlb;
  
  // force result to zero
  wire [23:0] s1t_fract24a = s1t_fract24a_shl & {24{~s0o_opc_0}};
  wire [23:0] s1t_fract24b = s1t_fract24b_shl & {24{~s0o_opc_0}};

  // exponent
  wire [9:0] s1t_exp10mux =
    s0o_is_div ? (s0o_exp10a - {5'd0,s0o_shla} - s0o_exp10b + {5'd0,s0o_shlb} + 10'd127) :
                 (s0o_exp10a - {5'd0,s0o_shla} + s0o_exp10b - {5'd0,s0o_shlb} - 10'd127);
  
  // force result to zero
  wire [9:0] s1t_exp10c = s1t_exp10mux & {10{~s0o_opc_0}};


  // Goldshmidt division iterations control
  reg [10:0] itr_state; // iteration state indicator
  // iteration characteristic points:
  //   quotient is computed
  wire itr_rndQ = itr_state[10];
  //   iteration in progress
  wire itr_Proc = |itr_state;
  // iteration control state machine
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst)
      itr_state <= 11'd0;
    else if(flush_i)
      itr_state <= 11'd0;
    else if(adv_i & s0o_ready & s0o_is_div)
      itr_state <= 11'd1;
    else if(adv_i)
      itr_state <= {itr_state[9:0],1'b0};
  end // posedge clock

  // Multiplication operation flag
  wire s1t_is_mul = s0o_ready & (~s0o_is_div);


  // stage #1 outputs
  //   input related
  reg s1o_inv, s1o_inf_i,
      s1o_snan_i, s1o_qnan_i, s1o_anan_i_sign;
  //   computation related
  reg        s1o_opc_0;
  reg        s1o_signc;
  reg [9:0]  s1o_exp10c;
  reg [23:0] s1o_fract24a;
  reg [23:0] s1o_fract24b;
  // DIV additional outputs
  reg        s1o_dbz;
  //   registering
  always @(posedge clk) begin
    if(adv_i & ~itr_Proc) begin
        // input related
      s1o_inv         <= s0o_inv;
      s1o_inf_i       <= s0o_inf_i;
      s1o_snan_i      <= s0o_snan_i;
      s1o_qnan_i      <= s0o_qnan_i;
      s1o_anan_i_sign <= s0o_anan_i_sign;
        // computation related
      s1o_opc_0    <= s0o_opc_0;
      s1o_signc    <= s0o_signc;
      s1o_exp10c   <= s1t_exp10c;
      s1o_fract24a <= s1t_fract24a;
      s1o_fract24b <= s1t_fract24b;
        // DIV additional outputs
      s1o_dbz <= s0o_dbz;
    end // advance pipe
  end // posedge clock

  // ready is special case
  reg s1o_mul_ready;
  reg s1o_div_ready;
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst) begin
      s1o_mul_ready <= 1'b0;
      s1o_div_ready <= 1'b0;
    end else if(flush_i) begin
      s1o_mul_ready <= 1'b0;
      s1o_div_ready <= 1'b0;
    end else if(adv_i) begin
      s1o_mul_ready <= s1t_is_mul;
      s1o_div_ready <= itr_rndQ;
    end
  end // posedge clock


  /* Stage #2: 1st part of multiplier */


  // rigt shift value
  // variants:
  wire [9:0] s2t_shrx =
    // negative exponent sum: (-e+1) = (~e + 2)
    //   (!) takes 1x.xx case into account automatically
    s1o_exp10c[9] ? ((~s1o_exp10c) + 10'd2) :
    // (a) zero exponent sum (denorm. result potentially)
    //   (!) takes 1x.xx case into account automatically
    // (b) normal case
    //   (!) 1x.xx case is processed in next stage
                    {9'd0, (~(|s1o_exp10c) & ~s1o_opc_0)};


  // Support Goldshmidt iteration
  // initial estimation of reciprocal
  wire [8:0] itr_recip9b;
  arecip_lut u_arlut
  (
    .b_i(s1o_fract24b[22:16]),
    .r_o(itr_recip9b)
  );
  // support case: b==1
  wire b_eq_1 = s1o_fract24b[23] & (~(|s1o_fract24b[22:0]));
  // reciprocal with restored leading 01
  wire [10:0] itr_recip11b = b_eq_1 ?  11'b10000000000 :
                                      {2'b01,itr_recip9b};

  // the subsequent two stages multiplier operates with 32-bit inputs
  // 25-bits: fractionals (quotient is in range 0.5 to 1)
  //  1-bit : rounding bit
  //  6-bits: guard (due to truncations of intermediate results)

  // intermediate results:
  //   updated divisor (D) is rounded up while all other intermediate values
  //   are just truncated in according with directed rounding analysed in:
  //     Guy Even, Peter-M.Seidel, Warren E.Ferguson
  //     "A parametric error analysis of Goldschmidt’s division algorithm"
  wire itr_rndD = itr_state[3] | itr_state[6];
  wire itr_rndDvsr;
  //   align resulting quotient to support subsequent IEEE-compliant rounding
  wire [25:0] itr_res_qtnt26; // rounded quotient
  //   Updated quotient or divisor
  wire [32:0] itr_qtnt33;
  //   'F' (2-D) or 'Reminder'
  wire [32:0] itr_rmnd33;


  // control for multiplier's input 'A'
  //   the register also contains quotient to output
  wire itr_uinA = s1t_is_mul   |
                  itr_state[0] | itr_state[3] | 
                  itr_state[6] | itr_rndQ;
  // multiplexer for multiplier's input 'A'
  wire [31:0] itr_mul32a =
     s1t_is_mul   ? {s1t_fract24a,8'd0}   :
     itr_state[0] ? {itr_recip11b,21'd0}  :
     itr_rndQ     ? {itr_res_qtnt26,6'd0} : // truncate by 2^(-n-1)
                     itr_rmnd33[31:0];
  // register of multiplier's input 'A'
  reg [15:0] s1o_mul16_al;
  reg [15:0] s1o_mul16_ah;
  // registering
  always @(posedge clk) begin
    if(adv_i & itr_uinA) begin
      s1o_mul16_al <= itr_mul32a[15: 0];
      s1o_mul16_ah <= itr_mul32a[31:16];
    end
  end // posedge clock


  // control for multiplier's input 'B'
  wire itr_uinB = s1t_is_mul   |
                  itr_state[0] | itr_state[1] |
                  itr_state[3] | itr_state[4] |
                  itr_state[6] | itr_state[7] |
                  itr_rndQ;
  // multiplexer for multiplier's input 'B'
  wire [31:0] itr_mul32b =
     s1t_is_mul               ? {s1t_fract24b,8'd0} :
    (itr_state[0] | itr_rndQ) ? {s1o_fract24b,8'd0} :
     itr_state[1]             ? {s1o_fract24a,8'd0} :
                                 itr_qtnt33[31:0];
  // register of multiplier's input 'B'
  reg [15:0] s1o_mul16_bl;
  reg [15:0] s1o_mul16_bh;
  always @(posedge clk) begin
    if(adv_i & itr_uinB) begin
      s1o_mul16_bl <= itr_mul32b[15: 0];
      s1o_mul16_bh <= itr_mul32b[31:16];
    end
  end // posedge clock

  // stage #2 outputs
  //   input related
  reg s2o_inv, s2o_inf_i,
      s2o_snan_i, s2o_qnan_i, s2o_anan_i_sign;
  // DIV additional outputs
  reg        s2o_dbz;
  reg [23:0] s2o_fract24a;
  //   computation related
  reg        s2o_opc_0;
  reg        s2o_signc;
  reg  [9:0] s2o_exp10c;
  reg  [9:0] s2o_shrx;
  reg        s2o_is_shrx;
  //   multipliers
  reg [31:0] s2o_fract32_albl;
  reg [31:0] s2o_fract32_albh;
  reg [31:0] s2o_fract32_ahbl;
  reg [31:0] s2o_fract32_ahbh;
  //   registering
  always @(posedge clk) begin
    if(adv_i) begin
        // input related
      s2o_inv         <= s1o_inv;
      s2o_inf_i       <= s1o_inf_i;
      s2o_snan_i      <= s1o_snan_i;
      s2o_qnan_i      <= s1o_qnan_i;
      s2o_anan_i_sign <= s1o_anan_i_sign;
        // DIV additional outputs
      s2o_dbz      <= s1o_dbz;
      s2o_fract24a <= s1o_fract24a;
        // computation related
      s2o_opc_0   <= s1o_opc_0;
      s2o_signc   <= s1o_signc;
      s2o_exp10c  <= s1o_exp10c;
      s2o_shrx    <= s2t_shrx;
      s2o_is_shrx <= (|s2t_shrx);
        // multipliers
      s2o_fract32_albl <= s1o_mul16_al * s1o_mul16_bl;
      s2o_fract32_albh <= s1o_mul16_al * s1o_mul16_bh;
      s2o_fract32_ahbl <= s1o_mul16_ah * s1o_mul16_bl;
      s2o_fract32_ahbh <= s1o_mul16_ah * s1o_mul16_bh;
    end // advance pipe
  end // posedge clock

  // ready is special case
  reg s2o_mul_ready;
  reg s2o_div_ready;
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst) begin
      s2o_mul_ready <= 1'b0;
      s2o_div_ready <= 1'b0;
    end else if(flush_i) begin
      s2o_mul_ready <= 1'b0;
      s2o_div_ready <= 1'b0;
    end else if(adv_i) begin
      s2o_mul_ready <= s1o_mul_ready;
      s2o_div_ready <= s1o_div_ready;
    end
  end // posedge clock


  /* Stage #3: 2nd part of multiplier */


  // 2nd stage of multiplier
  wire [47:0] s3t_fract48;
  assign s3t_fract48 = {s2o_fract32_ahbh,  16'd0} +
                       {16'd0, s2o_fract32_ahbl} +
                       {16'd0, s2o_fract32_albh} +
                       {32'd0, s2o_fract32_albl[31:16]};
                       
  // multiplier shift right value
  wire [9:0] s3t_shrx = s2o_is_shrx ? s2o_shrx : {9'd0,s3t_fract48[47]};

  // stage #3 outputs (for division support)
  
  // full product
  reg [32:0] s3o_mul33o; // output
  reg        s3o_mul33s; // sticky
  //   registering
  always @(posedge clk) begin
    if(adv_i) begin
      s3o_mul33o <= s3t_fract48[47:15];
      s3o_mul33s <= (|s3t_fract48[14:0]) | (|s2o_fract32_albl[15:0]);
    end
  end // posedge clock

  // For pipelinization of division final stage
  //   input related
  reg s3o_inv, s3o_inf_i,
      s3o_snan_i, s3o_qnan_i, s3o_anan_i_sign;
  //   DIV computation related
  reg        s3o_dbz;
  reg [23:0] s3o_fract24a;
  reg        s3o_opc_0;
  reg        s3o_signc;
  reg  [9:0] s3o_exp10c;
  reg  [9:0] s3o_shrx;
  reg        s3o_is_shrx;
  // registering
  always @(posedge clk) begin
    if(adv_i) begin
        // input related
      s3o_inv         <= s2o_inv;
      s3o_inf_i       <= s2o_inf_i;
      s3o_snan_i      <= s2o_snan_i;
      s3o_qnan_i      <= s2o_qnan_i;
      s3o_anan_i_sign <= s2o_anan_i_sign;
        // DIV computation related
      s3o_dbz      <= s2o_dbz;
      s3o_fract24a <= s2o_fract24a;
      s3o_opc_0    <= s2o_opc_0;
      s3o_signc    <= s2o_signc;
      s3o_exp10c   <= s2o_exp10c;
      s3o_shrx     <= s2o_shrx;
      s3o_is_shrx  <= s2o_is_shrx;
    end // advance pipe
  end // @clock
  
  // stage 3 ready makes sense for division only
  reg s3o_div_ready;
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst)
      s3o_div_ready <= 1'b0;
    else if(flush_i)
      s3o_div_ready <= 1'b0;
    else if(adv_i)
      s3o_div_ready <= s2o_div_ready;
  end // posedge clock


  // Feedback from multiplier's output with various rounding tecqs.
  //   +2^(-n-2) in case of rounding 1.xxx qutient
  wire itr_rndQ1xx =   s3o_mul33o[31];
  //   +2^(-n-2) in case of rounding 0.1xx qutient
  wire itr_rndQ01x = (~s3o_mul33o[31]);
  //   rounding mask:
  wire [32:0] itr_rndM33 = // bits [6],[5] ... [0]
    { 26'd0,(itr_rndQ & itr_rndQ1xx),(itr_rndQ & itr_rndQ01x), // round resulting quotient
       4'd0,(itr_rndD & s3o_mul33s) };                         // round intermediate divisor
  //   rounding
  assign itr_qtnt33 = s3o_mul33o + itr_rndM33;


  // compute 2's complement or reminder (for sticky bit detection)
  // binary point position is located just after bit [30]
  wire [32:0] itr_AorT33 =
    s3o_div_ready ? {1'b0,s3o_fract24a,8'd0} : // for reminder
                    {32'h80000000,1'b0};       // for two's complement

  // 'Reminder' / Two's complement
  assign itr_rmnd33 = itr_AorT33 - itr_qtnt33;

  // Auxiliary flags:
  //  - truncated reminder isn't zero
  wire s4t_rmnd33_n0  = |itr_rmnd33;
  //  - rounded quotient is exact
  wire s4t_qtnt_exact = ~(s4t_rmnd33_n0 | s3o_mul33s);
  //  - signum of final reminder
  wire s4t_sign_rmnd  = itr_rmnd33[32] | ((~s4t_rmnd33_n0) & s3o_mul33s);


  // Additionally store 26-bit of non-rounded (_raw_) and rounded (_res_) quotients.
  // It is used for rounding in cases of denormalized result.
  // Stiky bit is forced to be zero.
  // The value are marked by stage #2 output
  // raw
  reg [25:0] s3o_raw_qtnt26;
  // rounded
  reg [25:0] s3o_res_qtnt26;
  assign     itr_res_qtnt26 = {itr_qtnt33[31:7],itr_qtnt33[6] & itr_rndQ01x};
  // latching
  always @(posedge clk ) begin
    if(itr_rndQ) begin
      s3o_raw_qtnt26 <= s3o_mul33o[31:6];
      s3o_res_qtnt26 <= itr_res_qtnt26;
    end
  end
  
  // Possible left shift computation.
  // In fact, as the dividend and divisor was normalized
  //   and the result is non-zero
  //   the '1' is maximum number of leading zeros in the quotient.
  wire s4t_nlz = ~s3o_res_qtnt26[25];
  // left shift flag and corrected exponent
  wire s4t_shlx =
      // shift isn't needed (includes zero result)
    (~s4t_nlz)            ? 1'b0 :
      // normalization is possible / denormalized and zero cases
    (s3o_exp10c >  10'd1) ? 1'b1 : 1'b0;

  // check if quotient is denormalized
  wire s4t_denorm = s3o_is_shrx |
                    ((~s3o_is_shrx) & (~s4t_shlx) & s4t_nlz);
  // Select quotient for subsequent align and rounding
  // The rounded (_res_) quotient is used:
  //   - for normalized result
  //   - exact result
  //   - non-exact but lesser than infinity precision result
  wire [25:0] s4t_qtnt26 =
    ( (~s4t_denorm) | s4t_qtnt_exact |
      ((~s4t_qtnt_exact) & (~s4t_sign_rmnd)) ) ? s3o_res_qtnt26 :
                                                 s3o_raw_qtnt26;


  // output
  always @(posedge clk) begin
    if(adv_i) begin
        // input related
      muldiv_inv_o       <= s3o_div_ready ? s3o_inv : s2o_inv;
      muldiv_inf_o       <= s3o_div_ready ? s3o_inf_i : s2o_inf_i;
      muldiv_snan_o      <= s3o_div_ready ? s3o_snan_i : s2o_snan_i;
      muldiv_qnan_o      <= s3o_div_ready ? s3o_qnan_i : s2o_qnan_i;
      muldiv_anan_sign_o <= s3o_div_ready ? s3o_anan_i_sign : s2o_anan_i_sign;
        // computation related
      muldiv_sign_o     <= s3o_div_ready ? s3o_signc : s2o_signc;
      muldiv_shr_o      <= s3o_div_ready ? s3o_shrx : s3t_shrx;
      muldiv_shl_o      <= s3o_div_ready & s4t_shlx;          // makes sense for DIV only
      muldiv_exp10sh0_o <= s3o_div_ready ? s3o_exp10c : s2o_exp10c;
      muldiv_fract28_o  <= s3o_div_ready ?
                           {1'b0,s4t_qtnt26,~s4t_qtnt_exact} :      // quotient
                           {s3t_fract48[47:21],|s3t_fract48[20:0]}; // product
        // DIV additional outputs
      div_op_o        <= s3o_div_ready;
      div_sign_rmnd_o <= s3o_div_ready & s4t_sign_rmnd;
      div_dbz_o       <= s3o_div_ready & s3o_dbz;
    end // advance pipe
  end // posedge clock

  // ready is special case
  always @(posedge clk `OR_ASYNC_RST) begin
    if (rst)
      muldiv_rdy_o <= 0;
    else if(flush_i)
      muldiv_rdy_o <= 0;
    else if(adv_i)
      muldiv_rdy_o <= s2o_mul_ready | s3o_div_ready;
  end // posedge clock

endmodule // pfpu32_muldiv


// initial reciprocal approximation
module arecip_lut
(
  input      [6:0] b_i,
  output reg [8:0] r_o
);
  always @(b_i) begin
    case(b_i) // synopsys full_case parallel_case
      7'd0   : r_o = 9'd508;
      7'd1   : r_o = 9'd500;
      7'd2   : r_o = 9'd492;
      7'd3   : r_o = 9'd485;
      7'd4   : r_o = 9'd477;
      7'd5   : r_o = 9'd470;
      7'd6   : r_o = 9'd463;
      7'd7   : r_o = 9'd455;
      7'd8   : r_o = 9'd448;
      7'd9   : r_o = 9'd441;
      7'd10  : r_o = 9'd434;
      7'd11  : r_o = 9'd428;
      7'd12  : r_o = 9'd421;
      7'd13  : r_o = 9'd414;
      7'd14  : r_o = 9'd408;
      7'd15  : r_o = 9'd401;
      7'd16  : r_o = 9'd395;
      7'd17  : r_o = 9'd389;
      7'd18  : r_o = 9'd383;
      7'd19  : r_o = 9'd377;
      7'd20  : r_o = 9'd371;
      7'd21  : r_o = 9'd365;
      7'd22  : r_o = 9'd359;
      7'd23  : r_o = 9'd353;
      7'd24  : r_o = 9'd347;
      7'd25  : r_o = 9'd342;
      7'd26  : r_o = 9'd336;
      7'd27  : r_o = 9'd331;
      7'd28  : r_o = 9'd326;
      7'd29  : r_o = 9'd320;
      7'd30  : r_o = 9'd315;
      7'd31  : r_o = 9'd310;
      7'd32  : r_o = 9'd305;
      7'd33  : r_o = 9'd300;
      7'd34  : r_o = 9'd295;
      7'd35  : r_o = 9'd290;
      7'd36  : r_o = 9'd285;
      7'd37  : r_o = 9'd280;
      7'd38  : r_o = 9'd275;
      7'd39  : r_o = 9'd271;
      7'd40  : r_o = 9'd266;
      7'd41  : r_o = 9'd261;
      7'd42  : r_o = 9'd257;
      7'd43  : r_o = 9'd252;
      7'd44  : r_o = 9'd248;
      7'd45  : r_o = 9'd243;
      7'd46  : r_o = 9'd239;
      7'd47  : r_o = 9'd235;
      7'd48  : r_o = 9'd231;
      7'd49  : r_o = 9'd226;
      7'd50  : r_o = 9'd222;
      7'd51  : r_o = 9'd218;
      7'd52  : r_o = 9'd214;
      7'd53  : r_o = 9'd210;
      7'd54  : r_o = 9'd206;
      7'd55  : r_o = 9'd202;
      7'd56  : r_o = 9'd198;
      7'd57  : r_o = 9'd195;
      7'd58  : r_o = 9'd191;
      7'd59  : r_o = 9'd187;
      7'd60  : r_o = 9'd183;
      7'd61  : r_o = 9'd180;
      7'd62  : r_o = 9'd176;
      7'd63  : r_o = 9'd172;
      7'd64  : r_o = 9'd169;
      7'd65  : r_o = 9'd165;
      7'd66  : r_o = 9'd162;
      7'd67  : r_o = 9'd158;
      7'd68  : r_o = 9'd155;
      7'd69  : r_o = 9'd152;
      7'd70  : r_o = 9'd148;
      7'd71  : r_o = 9'd145;
      7'd72  : r_o = 9'd142;
      7'd73  : r_o = 9'd138;
      7'd74  : r_o = 9'd135;
      7'd75  : r_o = 9'd132;
      7'd76  : r_o = 9'd129;
      7'd77  : r_o = 9'd126;
      7'd78  : r_o = 9'd123;
      7'd79  : r_o = 9'd120;
      7'd80  : r_o = 9'd117;
      7'd81  : r_o = 9'd114;
      7'd82  : r_o = 9'd111;
      7'd83  : r_o = 9'd108;
      7'd84  : r_o = 9'd105;
      7'd85  : r_o = 9'd102;
      7'd86  : r_o = 9'd99;
      7'd87  : r_o = 9'd96;
      7'd88  : r_o = 9'd93;
      7'd89  : r_o = 9'd91;
      7'd90  : r_o = 9'd88;
      7'd91  : r_o = 9'd85;
      7'd92  : r_o = 9'd82;
      7'd93  : r_o = 9'd80;
      7'd94  : r_o = 9'd77;
      7'd95  : r_o = 9'd74;
      7'd96  : r_o = 9'd72;
      7'd97  : r_o = 9'd69;
      7'd98  : r_o = 9'd67;
      7'd99  : r_o = 9'd64;
      7'd100 : r_o = 9'd62;
      7'd101 : r_o = 9'd59;
      7'd102 : r_o = 9'd57;
      7'd103 : r_o = 9'd54;
      7'd104 : r_o = 9'd52;
      7'd105 : r_o = 9'd49;
      7'd106 : r_o = 9'd47;
      7'd107 : r_o = 9'd45;
      7'd108 : r_o = 9'd42;
      7'd109 : r_o = 9'd40;
      7'd110 : r_o = 9'd38;
      7'd111 : r_o = 9'd35;
      7'd112 : r_o = 9'd33;
      7'd113 : r_o = 9'd31;
      7'd114 : r_o = 9'd29;
      7'd115 : r_o = 9'd26;
      7'd116 : r_o = 9'd24;
      7'd117 : r_o = 9'd22;
      7'd118 : r_o = 9'd20;
      7'd119 : r_o = 9'd18;
      7'd120 : r_o = 9'd15;
      7'd121 : r_o = 9'd13;
      7'd122 : r_o = 9'd11;
      7'd123 : r_o = 9'd9;
      7'd124 : r_o = 9'd7;
      7'd125 : r_o = 9'd5;
      7'd126 : r_o = 9'd3;
      default: r_o = 9'd1;
    endcase // LUT for initial approximation of reciprocal
  end // always
endmodule
