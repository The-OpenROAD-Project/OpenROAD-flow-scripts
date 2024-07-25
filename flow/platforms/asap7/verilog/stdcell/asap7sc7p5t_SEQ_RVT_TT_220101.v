// BSD 3-Clause License
// 
// Copyright 2022 Lawrence T. Clark, Vinay Vashishtha, or Arizona State
// University
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice,
// this list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
// contributors may be used to endorse or promote products derived from this
// software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

// Verilog for library /home/anolas19/Liberate/Verilog/asap7sc7p5t_SEQ_RVT_TT_211229_pex created by Liberate 18.1.0.293 on Fri Dec 31 22:59:44 MST 2021 for SDF version 2.1

// type:  
`timescale 1ns/10ps
`celldefine
module DFFASRHQNx1_ASAP7_75t_R (QN, D, RESETN, SETN, CLK);
	output QN;
	input D, RESETN, SETN, CLK;
	reg notifier;
	wire delayed_D, delayed_RESETN, delayed_SETN, delayed_CLK;

	// Function
	wire int_fwire_d, int_fwire_IQN, int_fwire_r;
	wire int_fwire_s, xcr_0;

	not (int_fwire_d, delayed_D);
	not (int_fwire_s, delayed_RESETN);
	not (int_fwire_r, delayed_SETN);
	altos_dff_sr_err (xcr_0, delayed_CLK, int_fwire_d, int_fwire_s, int_fwire_r);
	altos_dff_sr_0 (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, int_fwire_s, int_fwire_r, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, adacond8;
	wire CLK__bar, D__bar;


	// Additional timing gates
	and (adacond0, RESETN, SETN);
	and (adacond1, D, SETN);
	and (adacond2, CLK, SETN);
	not (CLK__bar, CLK);
	and (adacond3, CLK__bar, SETN);
	not (D__bar, D);
	and (adacond4, D__bar, RESETN);
	and (adacond5, CLK, RESETN);
	and (adacond6, CLK__bar, RESETN);
	and (adacond7, D, RESETN, SETN);
	and (adacond8, D__bar, RESETN, SETN);

	specify
		if ((CLK & SETN))
			(negedge RESETN => (QN+:1'b1)) = 0;
		if ((~CLK & D & SETN))
			(negedge RESETN => (QN+:1'b1)) = 0;
		if ((~CLK & ~D & SETN))
			(negedge RESETN => (QN+:1'b1)) = 0;
		ifnone (negedge RESETN => (QN+:1'b1)) = 0;
		if ((CLK & RESETN))
			(negedge SETN => (QN+:1'b0)) = 0;
		if ((CLK & ~RESETN))
			(negedge SETN => (QN+:1'b0)) = 0;
		if ((~CLK & D & RESETN))
			(negedge SETN => (QN+:1'b0)) = 0;
		if ((~CLK & D & ~RESETN))
			(negedge SETN => (QN+:1'b0)) = 0;
		if ((~CLK & ~D & RESETN))
			(negedge SETN => (QN+:1'b0)) = 0;
		if ((~CLK & ~D & ~RESETN))
			(negedge SETN => (QN+:1'b0)) = 0;
		ifnone (negedge SETN => (QN+:1'b0)) = 0;
		if ((CLK & ~RESETN))
			(posedge SETN => (QN+:1'b1)) = 0;
		if ((~CLK & D & ~RESETN))
			(posedge SETN => (QN+:1'b1)) = 0;
		if ((~CLK & ~D & ~RESETN))
			(posedge SETN => (QN+:1'b1)) = 0;
		ifnone (posedge SETN => (QN+:1'b1)) = 0;
		(posedge CLK => (QN+:!D)) = 0;
		$setuphold (posedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge SETN &&& CLK, posedge RESETN &&& CLK, 0, 0, notifier,,, delayed_SETN, delayed_RESETN);
		$setuphold (posedge SETN &&& ~CLK, posedge RESETN &&& ~CLK, 0, 0, notifier,,, delayed_SETN, delayed_RESETN);
		$setuphold (posedge SETN, posedge RESETN, 0, 0, notifier,,, delayed_SETN, delayed_RESETN);
		$setuphold (posedge RESETN &&& CLK, posedge SETN &&& CLK, 0, 0, notifier,,, delayed_RESETN, delayed_SETN);
		$setuphold (posedge RESETN &&& ~CLK, posedge SETN &&& ~CLK, 0, 0, notifier,,, delayed_RESETN, delayed_SETN);
		$setuphold (posedge RESETN, posedge SETN, 0, 0, notifier,,, delayed_RESETN, delayed_SETN);
		$recovery (posedge RESETN &&& adacond1, posedge CLK &&& adacond1, 0, notifier);
		$recovery (posedge RESETN, posedge CLK, 0, notifier);
		$hold (posedge CLK &&& adacond1, posedge RESETN &&& adacond1, 0, notifier);
		$hold (posedge CLK, posedge RESETN, 0, notifier);
		$recovery (posedge SETN &&& adacond4, posedge CLK &&& adacond4, 0, notifier);
		$recovery (posedge SETN, posedge CLK, 0, notifier);
		$hold (posedge CLK &&& adacond4, posedge SETN &&& adacond4, 0, notifier);
		$hold (posedge CLK, posedge SETN, 0, notifier);
		$width (negedge RESETN &&& adacond2, 0, 0, notifier);
		$width (negedge RESETN &&& adacond3, 0, 0, notifier);
		$width (negedge SETN &&& adacond5, 0, 0, notifier);
		$width (negedge SETN &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
		$width (posedge CLK &&& adacond8, 0, 0, notifier);
		$width (negedge CLK &&& adacond8, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine


`ifdef _udp_def_altos_latch_
`else
`define _udp_def_altos_latch_
primitive altos_latch (q, v, clk, d);
	output q;
	reg q;
	input v, clk, d;

	table
		* ? ? : ? : x;
		? 1 0 : ? : 0;
		? 1 1 : ? : 1;
		? x 0 : 0 : -;
		? x 1 : 1 : -;
		? 0 ? : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_err_
`else
`define _udp_def_altos_dff_err_
primitive altos_dff_err (q, clk, d);
	output q;
	reg q;
	input clk, d;

	table
		(0x) ? : ? : 0;
		(1x) ? : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_
`else
`define _udp_def_altos_dff_
primitive altos_dff (q, v, clk, d, xcr);
	output q;
	reg q;
	input v, clk, d, xcr;

	table
		*  ?   ? ? : ? : x;
		? (x1) 0 0 : ? : 0;
		? (x1) 1 0 : ? : 1;
		? (x1) 0 1 : 0 : 0;
		? (x1) 1 1 : 1 : 1;
		? (x1) ? x : ? : -;
		? (bx) 0 ? : 0 : -;
		? (bx) 1 ? : 1 : -;
		? (x0) b ? : ? : -;
		? (x0) ? x : ? : -;
		? (01) 0 ? : ? : 0;
		? (01) 1 ? : ? : 1;
		? (10) ? ? : ? : -;
		?  b   * ? : ? : -;
		?  ?   ? * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_r_err_
`else
`define _udp_def_altos_dff_r_err_
primitive altos_dff_r_err (q, clk, d, r);
	output q;
	reg q;
	input clk, d, r;

	table
		 ?   0 (0x) : ? : -;
		 ?   0 (x0) : ? : -;
		(0x) ?  0   : ? : 0;
		(0x) 0  x   : ? : 0;
		(1x) ?  0   : ? : 1;
		(1x) 0  x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_r_
`else
`define _udp_def_altos_dff_r_
primitive altos_dff_r (q, v, clk, d, r, xcr);
	output q;
	reg q;
	input v, clk, d, r, xcr;

	table
		*  ?   ?  ?   ? : ? : x;
		?  ?   ?  1   ? : ? : 0;
		?  b   ? (1?) ? : 0 : -;
		?  x   0 (1?) ? : 0 : -;
		?  ?   ? (10) ? : ? : -;
		?  ?   ? (x0) ? : ? : -;
		?  ?   ? (0x) ? : 0 : -;
		? (x1) 0  ?   0 : ? : 0;
		? (x1) 1  0   0 : ? : 1;
		? (x1) 0  ?   1 : 0 : 0;
		? (x1) 1  0   1 : 1 : 1;
		? (x1) ?  ?   x : ? : -;
		? (bx) 0  ?   ? : 0 : -;
		? (bx) 1  0   ? : 1 : -;
		? (x0) 0  ?   ? : ? : -;
		? (x0) 1  0   ? : ? : -;
		? (x0) ?  0   x : ? : -;
		? (01) 0  ?   ? : ? : 0;
		? (01) 1  0   ? : ? : 1;
		? (10) ?  ?   ? : ? : -;
		?  b   *  ?   ? : ? : -;
		?  ?   ?  ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_s_err_
`else
`define _udp_def_altos_dff_s_err_
primitive altos_dff_s_err (q, clk, d, s);
	output q;
	reg q;
	input clk, d, s;

	table
		 ?   1 (0x) : ? : -;
		 ?   1 (x0) : ? : -;
		(0x) ?  0   : ? : 0;
		(0x) 1  x   : ? : 0;
		(1x) ?  0   : ? : 1;
		(1x) 1  x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_s_
`else
`define _udp_def_altos_dff_s_
primitive altos_dff_s (q, v, clk, d, s, xcr);
	output q;
	reg q;
	input v, clk, d, s, xcr;

	table
		*  ?   ?  ?   ? : ? : x;
		?  ?   ?  1   ? : ? : 1;
		?  b   ? (1?) ? : 1 : -;
		?  x   1 (1?) ? : 1 : -;
		?  ?   ? (10) ? : ? : -;
		?  ?   ? (x0) ? : ? : -;
		?  ?   ? (0x) ? : 1 : -;
		? (x1) 0  0   0 : ? : 0;
		? (x1) 1  ?   0 : ? : 1;
		? (x1) 1  ?   1 : 1 : 1;
		? (x1) 0  0   1 : 0 : 0;
		? (x1) ?  ?   x : ? : -;
		? (bx) 1  ?   ? : 1 : -;
		? (bx) 0  0   ? : 0 : -;
		? (x0) 1  ?   ? : ? : -;
		? (x0) 0  0   ? : ? : -;
		? (x0) ?  0   x : ? : -;
		? (01) 1  ?   ? : ? : 1;
		? (01) 0  0   ? : ? : 0;
		? (10) ?  ?   ? : ? : -;
		?  b   *  ?   ? : ? : -;
		?  ?   ?  ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_err_
`else
`define _udp_def_altos_dff_sr_err_
primitive altos_dff_sr_err (q, clk, d, s, r);
	output q;
	reg q;
	input clk, d, s, r;

	table
		 ?   1 (0x)  ?   : ? : -;
		 ?   0  ?   (0x) : ? : -;
		 ?   0  ?   (x0) : ? : -;
		(0x) ?  0    0   : ? : 0;
		(0x) 1  x    0   : ? : 0;
		(0x) 0  0    x   : ? : 0;
		(1x) ?  0    0   : ? : 1;
		(1x) 1  x    0   : ? : 1;
		(1x) 0  0    x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_0
`else
`define _udp_def_altos_dff_sr_0
primitive altos_dff_sr_0 (q, v, clk, d, s, r, xcr);
	output q;
	reg q;
	input v, clk, d, s, r, xcr;

	table
	//	v,  clk, d, s, r : q' : q;

		*  ?   ?   ?   ?   ? : ? : x;
		?  ?   ?   ?   1   ? : ? : 0;
		?  ?   ?   1   0   ? : ? : 1;
		?  b   ? (1?)  0   ? : 1 : -;
		?  x   1 (1?)  0   ? : 1 : -;
		?  ?   ? (10)  0   ? : ? : -;
		?  ?   ? (x0)  0   ? : ? : -;
		?  ?   ? (0x)  0   ? : 1 : -;
		?  b   ?  0   (1?) ? : 0 : -;
		?  x   0  0   (1?) ? : 0 : -;
		?  ?   ?  0   (10) ? : ? : -;
		?  ?   ?  0   (x0) ? : ? : -;
		?  ?   ?  0   (0x) ? : 0 : -;
		? (x1) 0  0    ?   0 : ? : 0;
		? (x1) 1  ?    0   0 : ? : 1;
		? (x1) 0  0    ?   1 : 0 : 0;
		? (x1) 1  ?    0   1 : 1 : 1;
		? (x1) ?  ?    0   x : ? : -;
		? (x1) ?  0    ?   x : ? : -;
		? (1x) 0  0    ?   ? : 0 : -;
		? (1x) 1  ?    0   ? : 1 : -;
		? (x0) 0  0    ?   ? : ? : -;
		? (x0) 1  ?    0   ? : ? : -;
		? (x0) ?  0    0   x : ? : -;
		? (0x) 0  0    ?   ? : 0 : -;
		? (0x) 1  ?    0   ? : 1 : -;
		? (01) 0  0    ?   ? : ? : 0;
		? (01) 1  ?    0   ? : ? : 1;
		? (10) ?  0    ?   ? : ? : -;
		? (10) ?  ?    0   ? : ? : -;
		?  b   *  0    ?   ? : ? : -;
		?  b   *  ?    0   ? : ? : -;
		?  ?   ?  ?    ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_1
`else
`define _udp_def_altos_dff_sr_1
primitive altos_dff_sr_1 (q, v, clk, d, s, r, xcr);
	output q;
	reg q;
	input v, clk, d, s, r, xcr;

	table
	//	v,  clk, d, s, r : q' : q;

		*  ?   ?   ?   ?   ? : ? : x;
		?  ?   ?   0   1   ? : ? : 0;
		?  ?   ?   1   ?   ? : ? : 1;
		?  b   ? (1?)  0   ? : 1 : -;
		?  x   1 (1?)  0   ? : 1 : -;
		?  ?   ? (10)  0   ? : ? : -;
		?  ?   ? (x0)  0   ? : ? : -;
		?  ?   ? (0x)  0   ? : 1 : -;
		?  b   ?  0   (1?) ? : 0 : -;
		?  x   0  0   (1?) ? : 0 : -;
		?  ?   ?  0   (10) ? : ? : -;
		?  ?   ?  0   (x0) ? : ? : -;
		?  ?   ?  0   (0x) ? : 0 : -;
		? (x1) 0  0    ?   0 : ? : 0;
		? (x1) 1  ?    0   0 : ? : 1;
		? (x1) 0  0    ?   1 : 0 : 0;
		? (x1) 1  ?    0   1 : 1 : 1;
		? (x1) ?  ?    0   x : ? : -;
		? (x1) ?  0    ?   x : ? : -;
		? (1x) 0  0    ?   ? : 0 : -;
		? (1x) 1  ?    0   ? : 1 : -;
		? (x0) 0  0    ?   ? : ? : -;
		? (x0) 1  ?    0   ? : ? : -;
		? (x0) ?  0    0   x : ? : -;
		? (0x) 0  0    ?   ? : 0 : -;
		? (0x) 1  ?    0   ? : 1 : -;
		? (01) 0  0    ?   ? : ? : 0;
		? (01) 1  ?    0   ? : ? : 1;
		? (10) ?  0    ?   ? : ? : -;
		? (10) ?  ?    0   ? : ? : -;
		?  b   *  0    ?   ? : ? : -;
		?  b   *  ?    0   ? : ? : -;
		?  ?   ?  ?    ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_r_
`else
`define _udp_def_altos_latch_r_
primitive altos_latch_r (q, v, clk, d, r);
	output q;
	reg q;
	input v, clk, d, r;

	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 0;
		? 0 ? 0 : ? : -;
		? 0 ? x : 0 : -;
		? 1 0 0 : ? : 0;
		? 1 0 x : ? : 0;
		? 1 1 0 : ? : 1;
		? x 0 0 : 0 : -;
		? x 0 x : 0 : -;
		? x 1 0 : 1 : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_s_
`else
`define _udp_def_altos_latch_s_
primitive altos_latch_s (q, v, clk, d, s);
	output q;
	reg q;
	input v, clk, d, s;

	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 1;
		? 0 ? 0 : ? : -;
		? 0 ? x : 1 : -;
		? 1 1 0 : ? : 1;
		? 1 1 x : ? : 1;
		? 1 0 0 : ? : 0;
		? x 1 0 : 1 : -;
		? x 1 x : 1 : -;
		? x 0 0 : 0 : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_sr_0
`else
`define _udp_def_altos_latch_sr_0
primitive altos_latch_sr_0 (q, v, clk, d, s, r);
	output q;
	reg q;
	input v, clk, d, s, r;

	table
		* ? ? ? ? : ? : x;
		? 1 1 ? 0 : ? : 1;
		? 1 0 0 ? : ? : 0;
		? ? ? 1 0 : ? : 1;
		? ? ? ? 1 : ? : 0;
		? 0 * ? ? : ? : -;
		? 0 ? * 0 : 1 : 1;
		? 0 ? 0 * : 0 : 0;
		? * 1 ? 0 : 1 : 1;
		? * 0 0 ? : 0 : 0;
		? ? 1 * 0 : 1 : 1;
		? ? 0 0 * : 0 : 0;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_sr_1
`else
`define _udp_def_altos_latch_sr_1
primitive altos_latch_sr_1 (q, v, clk, d, s, r);
	output q;
	reg q;
	input v, clk, d, s, r;

	table
		* ? ? ? ? : ? : x;
		? 1 1 ? 0 : ? : 1;
		? 1 0 0 ? : ? : 0;
		? ? ? 1 ? : ? : 1;
		? ? ? 0 1 : ? : 0;
		? 0 * ? ? : ? : -;
		? 0 ? * 0 : 1 : 1;
		? 0 ? 0 * : 0 : 0;
		? * 1 ? 0 : 1 : 1;
		? * 0 0 ? : 0 : 0;
		? ? 1 * 0 : 1 : 1;
		? ? 0 0 * : 0 : 0;
	endtable
endprimitive
`endif
// type:  
`timescale 1ns/10ps
`celldefine
module DFFHQNx1_ASAP7_75t_R (QN, D, CLK);
	output QN;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (int_fwire_d, delayed_D);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
	specify
		(posedge CLK => (QN+:!D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFHQNx2_ASAP7_75t_R (QN, D, CLK);
	output QN;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (int_fwire_d, delayed_D);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
	specify
		(posedge CLK => (QN+:!D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFHQNx3_ASAP7_75t_R (QN, D, CLK);
	output QN;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (int_fwire_d, delayed_D);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
	specify
		(posedge CLK => (QN+:!D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFHQx4_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_IQ, xcr_0;

	altos_dff_err (xcr_0, delayed_CLK, delayed_D);
	altos_dff (int_fwire_IQ, notifier, delayed_CLK, delayed_D, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(posedge CLK => (Q+:D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFLQNx1_ASAP7_75t_R (QN, D, CLK);
	output QN;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (int_fwire_d, delayed_D);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
	specify
		(negedge CLK => (QN+:!D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFLQNx2_ASAP7_75t_R (QN, D, CLK);
	output QN;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (int_fwire_d, delayed_D);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
	specify
		(negedge CLK => (QN+:!D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFLQNx3_ASAP7_75t_R (QN, D, CLK);
	output QN;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (int_fwire_d, delayed_D);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
	specify
		(negedge CLK => (QN+:!D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DFFLQx4_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, xcr_0;

	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, delayed_D);
	altos_dff (int_fwire_IQ, notifier, int_fwire_clk, delayed_D, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(negedge CLK => (Q+:D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DHLx1_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_IQ;

	altos_latch (int_fwire_IQ, notifier, delayed_CLK, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(D => Q) = 0;
		(posedge CLK => (Q+:D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DHLx2_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_IQ;

	altos_latch (int_fwire_IQ, notifier, delayed_CLK, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(D => Q) = 0;
		(posedge CLK => (Q+:D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DHLx3_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_IQ;

	altos_latch (int_fwire_IQ, notifier, delayed_CLK, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(D => Q) = 0;
		(posedge CLK => (Q+:D)) = 0;
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (posedge CLK &&& D, 0, 0, notifier);
		$width (posedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DLLx1_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ;

	not (int_fwire_clk, delayed_CLK);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(D => Q) = 0;
		(negedge CLK => (Q+:D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DLLx2_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ;

	not (int_fwire_clk, delayed_CLK);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(D => Q) = 0;
		(negedge CLK => (Q+:D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module DLLx3_ASAP7_75t_R (Q, D, CLK);
	output Q;
	input D, CLK;
	reg notifier;
	wire delayed_D, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ;

	not (int_fwire_clk, delayed_CLK);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
	specify
		(D => Q) = 0;
		(negedge CLK => (Q+:D)) = 0;
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$width (negedge CLK &&& D, 0, 0, notifier);
		$width (negedge CLK &&& ~D, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx1_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx2_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx2p67DC_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx3_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx4DC_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx4_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx5_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx5p33DC_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx6p67DC_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module ICGx8DC_ASAP7_75t_R (GCLK, ENA, SE, CLK);
	output GCLK;
	input ENA, SE, CLK;
	reg notifier;
	wire delayed_ENA, delayed_SE, delayed_CLK;

	// Function
	wire int_fwire_clk, int_fwire_IQ, int_fwire_test;

	not (int_fwire_clk, delayed_CLK);
	or (int_fwire_test, delayed_ENA, delayed_SE);
	altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
	and (GCLK, delayed_CLK, int_fwire_IQ);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, ENA__bar;
	wire int_twire_0, SE__bar;


	// Additional timing gates
	not (ENA__bar, ENA);
	and (int_twire_0, ENA__bar, SE);
	or (adacond0, ENA, int_twire_0);
	not (SE__bar, SE);
	and (adacond1, ENA__bar, SE__bar);

	specify
		if ((ENA) | (~ENA & SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		if ((~ENA & ~SE))
			(negedge CLK => (GCLK+:1'b0)) = 0;
		ifnone (CLK => GCLK) = 0;
		$setuphold (posedge CLK &&& ~SE, posedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~SE, negedge ENA &&& ~SE, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, posedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK, negedge ENA, 0, 0, notifier,,, delayed_CLK, delayed_ENA);
		$setuphold (posedge CLK &&& ~ENA, posedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& ~ENA, negedge SE &&& ~ENA, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$width (posedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond0, 0, 0, notifier);
		$width (negedge CLK &&& adacond1, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFHx1_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(posedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (posedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFHx2_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(posedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (posedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFHx3_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(posedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (posedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFHx4_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_d, int_fwire_IQN, xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(posedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (posedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (posedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (posedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (posedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFLx1_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(negedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (negedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFLx2_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(negedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (negedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFLx3_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(negedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (negedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module SDFLx4_ASAP7_75t_R (QN, D, SE, SI, CLK);
	output QN;
	input D, SE, SI, CLK;
	reg notifier;
	wire delayed_D, delayed_SE, delayed_SI, delayed_CLK;

	// Function
	wire delayed_D__bar, delayed_SE__bar, delayed_SI__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_clk, int_fwire_d, int_fwire_IQN;
	wire xcr_0;

	not (delayed_SI__bar, delayed_SI);
	and (int_fwire_0, delayed_SE, delayed_SI__bar);
	not (delayed_D__bar, delayed_D);
	and (int_fwire_1, delayed_D__bar, delayed_SI__bar);
	not (delayed_SE__bar, delayed_SE);
	and (int_fwire_2, delayed_D__bar, delayed_SE__bar);
	or (int_fwire_d, int_fwire_2, int_fwire_1, int_fwire_0);
	not (int_fwire_clk, delayed_CLK);
	altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing

	// Additional timing wires
	wire adacond0, adacond1, adacond2;
	wire adacond3, adacond4, adacond5;
	wire adacond6, adacond7, D__bar;
	wire int_twire_0, int_twire_1, int_twire_2;
	wire int_twire_3, int_twire_4, int_twire_5;
	wire SE__bar, SI__bar;


	// Additional timing gates
	not (SE__bar, SE);
	and (adacond0, SE__bar, SI);
	not (SI__bar, SI);
	and (adacond1, SE__bar, SI__bar);
	and (adacond2, D, SI__bar);
	not (D__bar, D);
	and (adacond3, D__bar, SI);
	and (adacond4, D, SE);
	and (adacond5, D__bar, SE);
	and (int_twire_0, D__bar, SE, SI);
	and (int_twire_1, D, SE__bar);
	and (int_twire_2, D, SE, SI);
	or (adacond6, int_twire_2, int_twire_1, int_twire_0);
	and (int_twire_3, D__bar, SE__bar);
	and (int_twire_4, D__bar, SE, SI__bar);
	and (int_twire_5, D, SE, SI__bar);
	or (adacond7, int_twire_5, int_twire_4, int_twire_3);

	specify
		(negedge CLK => (QN+:((SE && !SI) || (!SE && !D)))) = 0;
		$setuphold (negedge CLK &&& adacond0, posedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond0, negedge D &&& adacond0, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, posedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond1, negedge D &&& adacond1, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, posedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK, negedge D, 0, 0, notifier,,, delayed_CLK, delayed_D);
		$setuphold (negedge CLK &&& adacond2, posedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond2, negedge SE &&& adacond2, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, posedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond3, negedge SE &&& adacond3, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, posedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK, negedge SE, 0, 0, notifier,,, delayed_CLK, delayed_SE);
		$setuphold (negedge CLK &&& adacond4, posedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond4, negedge SI &&& adacond4, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, posedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK &&& adacond5, negedge SI &&& adacond5, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, posedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$setuphold (negedge CLK, negedge SI, 0, 0, notifier,,, delayed_CLK, delayed_SI);
		$width (posedge CLK &&& adacond6, 0, 0, notifier);
		$width (negedge CLK &&& adacond6, 0, 0, notifier);
		$width (posedge CLK &&& adacond7, 0, 0, notifier);
		$width (negedge CLK &&& adacond7, 0, 0, notifier);
	endspecify
endmodule
`endcelldefine


`ifdef _udp_def_altos_latch_
`else
`define _udp_def_altos_latch_
primitive altos_latch (q, v, clk, d);
	output q;
	reg q;
	input v, clk, d;

	table
		* ? ? : ? : x;
		? 1 0 : ? : 0;
		? 1 1 : ? : 1;
		? x 0 : 0 : -;
		? x 1 : 1 : -;
		? 0 ? : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_err_
`else
`define _udp_def_altos_dff_err_
primitive altos_dff_err (q, clk, d);
	output q;
	reg q;
	input clk, d;

	table
		(0x) ? : ? : 0;
		(1x) ? : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_
`else
`define _udp_def_altos_dff_
primitive altos_dff (q, v, clk, d, xcr);
	output q;
	reg q;
	input v, clk, d, xcr;

	table
		*  ?   ? ? : ? : x;
		? (x1) 0 0 : ? : 0;
		? (x1) 1 0 : ? : 1;
		? (x1) 0 1 : 0 : 0;
		? (x1) 1 1 : 1 : 1;
		? (x1) ? x : ? : -;
		? (bx) 0 ? : 0 : -;
		? (bx) 1 ? : 1 : -;
		? (x0) b ? : ? : -;
		? (x0) ? x : ? : -;
		? (01) 0 ? : ? : 0;
		? (01) 1 ? : ? : 1;
		? (10) ? ? : ? : -;
		?  b   * ? : ? : -;
		?  ?   ? * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_r_err_
`else
`define _udp_def_altos_dff_r_err_
primitive altos_dff_r_err (q, clk, d, r);
	output q;
	reg q;
	input clk, d, r;

	table
		 ?   0 (0x) : ? : -;
		 ?   0 (x0) : ? : -;
		(0x) ?  0   : ? : 0;
		(0x) 0  x   : ? : 0;
		(1x) ?  0   : ? : 1;
		(1x) 0  x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_r_
`else
`define _udp_def_altos_dff_r_
primitive altos_dff_r (q, v, clk, d, r, xcr);
	output q;
	reg q;
	input v, clk, d, r, xcr;

	table
		*  ?   ?  ?   ? : ? : x;
		?  ?   ?  1   ? : ? : 0;
		?  b   ? (1?) ? : 0 : -;
		?  x   0 (1?) ? : 0 : -;
		?  ?   ? (10) ? : ? : -;
		?  ?   ? (x0) ? : ? : -;
		?  ?   ? (0x) ? : 0 : -;
		? (x1) 0  ?   0 : ? : 0;
		? (x1) 1  0   0 : ? : 1;
		? (x1) 0  ?   1 : 0 : 0;
		? (x1) 1  0   1 : 1 : 1;
		? (x1) ?  ?   x : ? : -;
		? (bx) 0  ?   ? : 0 : -;
		? (bx) 1  0   ? : 1 : -;
		? (x0) 0  ?   ? : ? : -;
		? (x0) 1  0   ? : ? : -;
		? (x0) ?  0   x : ? : -;
		? (01) 0  ?   ? : ? : 0;
		? (01) 1  0   ? : ? : 1;
		? (10) ?  ?   ? : ? : -;
		?  b   *  ?   ? : ? : -;
		?  ?   ?  ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_s_err_
`else
`define _udp_def_altos_dff_s_err_
primitive altos_dff_s_err (q, clk, d, s);
	output q;
	reg q;
	input clk, d, s;

	table
		 ?   1 (0x) : ? : -;
		 ?   1 (x0) : ? : -;
		(0x) ?  0   : ? : 0;
		(0x) 1  x   : ? : 0;
		(1x) ?  0   : ? : 1;
		(1x) 1  x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_s_
`else
`define _udp_def_altos_dff_s_
primitive altos_dff_s (q, v, clk, d, s, xcr);
	output q;
	reg q;
	input v, clk, d, s, xcr;

	table
		*  ?   ?  ?   ? : ? : x;
		?  ?   ?  1   ? : ? : 1;
		?  b   ? (1?) ? : 1 : -;
		?  x   1 (1?) ? : 1 : -;
		?  ?   ? (10) ? : ? : -;
		?  ?   ? (x0) ? : ? : -;
		?  ?   ? (0x) ? : 1 : -;
		? (x1) 0  0   0 : ? : 0;
		? (x1) 1  ?   0 : ? : 1;
		? (x1) 1  ?   1 : 1 : 1;
		? (x1) 0  0   1 : 0 : 0;
		? (x1) ?  ?   x : ? : -;
		? (bx) 1  ?   ? : 1 : -;
		? (bx) 0  0   ? : 0 : -;
		? (x0) 1  ?   ? : ? : -;
		? (x0) 0  0   ? : ? : -;
		? (x0) ?  0   x : ? : -;
		? (01) 1  ?   ? : ? : 1;
		? (01) 0  0   ? : ? : 0;
		? (10) ?  ?   ? : ? : -;
		?  b   *  ?   ? : ? : -;
		?  ?   ?  ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_err_
`else
`define _udp_def_altos_dff_sr_err_
primitive altos_dff_sr_err (q, clk, d, s, r);
	output q;
	reg q;
	input clk, d, s, r;

	table
		 ?   1 (0x)  ?   : ? : -;
		 ?   0  ?   (0x) : ? : -;
		 ?   0  ?   (x0) : ? : -;
		(0x) ?  0    0   : ? : 0;
		(0x) 1  x    0   : ? : 0;
		(0x) 0  0    x   : ? : 0;
		(1x) ?  0    0   : ? : 1;
		(1x) 1  x    0   : ? : 1;
		(1x) 0  0    x   : ? : 1;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_0
`else
`define _udp_def_altos_dff_sr_0
primitive altos_dff_sr_0 (q, v, clk, d, s, r, xcr);
	output q;
	reg q;
	input v, clk, d, s, r, xcr;

	table
	//	v,  clk, d, s, r : q' : q;

		*  ?   ?   ?   ?   ? : ? : x;
		?  ?   ?   ?   1   ? : ? : 0;
		?  ?   ?   1   0   ? : ? : 1;
		?  b   ? (1?)  0   ? : 1 : -;
		?  x   1 (1?)  0   ? : 1 : -;
		?  ?   ? (10)  0   ? : ? : -;
		?  ?   ? (x0)  0   ? : ? : -;
		?  ?   ? (0x)  0   ? : 1 : -;
		?  b   ?  0   (1?) ? : 0 : -;
		?  x   0  0   (1?) ? : 0 : -;
		?  ?   ?  0   (10) ? : ? : -;
		?  ?   ?  0   (x0) ? : ? : -;
		?  ?   ?  0   (0x) ? : 0 : -;
		? (x1) 0  0    ?   0 : ? : 0;
		? (x1) 1  ?    0   0 : ? : 1;
		? (x1) 0  0    ?   1 : 0 : 0;
		? (x1) 1  ?    0   1 : 1 : 1;
		? (x1) ?  ?    0   x : ? : -;
		? (x1) ?  0    ?   x : ? : -;
		? (1x) 0  0    ?   ? : 0 : -;
		? (1x) 1  ?    0   ? : 1 : -;
		? (x0) 0  0    ?   ? : ? : -;
		? (x0) 1  ?    0   ? : ? : -;
		? (x0) ?  0    0   x : ? : -;
		? (0x) 0  0    ?   ? : 0 : -;
		? (0x) 1  ?    0   ? : 1 : -;
		? (01) 0  0    ?   ? : ? : 0;
		? (01) 1  ?    0   ? : ? : 1;
		? (10) ?  0    ?   ? : ? : -;
		? (10) ?  ?    0   ? : ? : -;
		?  b   *  0    ?   ? : ? : -;
		?  b   *  ?    0   ? : ? : -;
		?  ?   ?  ?    ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_dff_sr_1
`else
`define _udp_def_altos_dff_sr_1
primitive altos_dff_sr_1 (q, v, clk, d, s, r, xcr);
	output q;
	reg q;
	input v, clk, d, s, r, xcr;

	table
	//	v,  clk, d, s, r : q' : q;

		*  ?   ?   ?   ?   ? : ? : x;
		?  ?   ?   0   1   ? : ? : 0;
		?  ?   ?   1   ?   ? : ? : 1;
		?  b   ? (1?)  0   ? : 1 : -;
		?  x   1 (1?)  0   ? : 1 : -;
		?  ?   ? (10)  0   ? : ? : -;
		?  ?   ? (x0)  0   ? : ? : -;
		?  ?   ? (0x)  0   ? : 1 : -;
		?  b   ?  0   (1?) ? : 0 : -;
		?  x   0  0   (1?) ? : 0 : -;
		?  ?   ?  0   (10) ? : ? : -;
		?  ?   ?  0   (x0) ? : ? : -;
		?  ?   ?  0   (0x) ? : 0 : -;
		? (x1) 0  0    ?   0 : ? : 0;
		? (x1) 1  ?    0   0 : ? : 1;
		? (x1) 0  0    ?   1 : 0 : 0;
		? (x1) 1  ?    0   1 : 1 : 1;
		? (x1) ?  ?    0   x : ? : -;
		? (x1) ?  0    ?   x : ? : -;
		? (1x) 0  0    ?   ? : 0 : -;
		? (1x) 1  ?    0   ? : 1 : -;
		? (x0) 0  0    ?   ? : ? : -;
		? (x0) 1  ?    0   ? : ? : -;
		? (x0) ?  0    0   x : ? : -;
		? (0x) 0  0    ?   ? : 0 : -;
		? (0x) 1  ?    0   ? : 1 : -;
		? (01) 0  0    ?   ? : ? : 0;
		? (01) 1  ?    0   ? : ? : 1;
		? (10) ?  0    ?   ? : ? : -;
		? (10) ?  ?    0   ? : ? : -;
		?  b   *  0    ?   ? : ? : -;
		?  b   *  ?    0   ? : ? : -;
		?  ?   ?  ?    ?   * : ? : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_r_
`else
`define _udp_def_altos_latch_r_
primitive altos_latch_r (q, v, clk, d, r);
	output q;
	reg q;
	input v, clk, d, r;

	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 0;
		? 0 ? 0 : ? : -;
		? 0 ? x : 0 : -;
		? 1 0 0 : ? : 0;
		? 1 0 x : ? : 0;
		? 1 1 0 : ? : 1;
		? x 0 0 : 0 : -;
		? x 0 x : 0 : -;
		? x 1 0 : 1 : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_s_
`else
`define _udp_def_altos_latch_s_
primitive altos_latch_s (q, v, clk, d, s);
	output q;
	reg q;
	input v, clk, d, s;

	table
		* ? ? ? : ? : x;
		? ? ? 1 : ? : 1;
		? 0 ? 0 : ? : -;
		? 0 ? x : 1 : -;
		? 1 1 0 : ? : 1;
		? 1 1 x : ? : 1;
		? 1 0 0 : ? : 0;
		? x 1 0 : 1 : -;
		? x 1 x : 1 : -;
		? x 0 0 : 0 : -;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_sr_0
`else
`define _udp_def_altos_latch_sr_0
primitive altos_latch_sr_0 (q, v, clk, d, s, r);
	output q;
	reg q;
	input v, clk, d, s, r;

	table
		* ? ? ? ? : ? : x;
		? 1 1 ? 0 : ? : 1;
		? 1 0 0 ? : ? : 0;
		? ? ? 1 0 : ? : 1;
		? ? ? ? 1 : ? : 0;
		? 0 * ? ? : ? : -;
		? 0 ? * 0 : 1 : 1;
		? 0 ? 0 * : 0 : 0;
		? * 1 ? 0 : 1 : 1;
		? * 0 0 ? : 0 : 0;
		? ? 1 * 0 : 1 : 1;
		? ? 0 0 * : 0 : 0;
	endtable
endprimitive
`endif

`ifdef _udp_def_altos_latch_sr_1
`else
`define _udp_def_altos_latch_sr_1
primitive altos_latch_sr_1 (q, v, clk, d, s, r);
	output q;
	reg q;
	input v, clk, d, s, r;

	table
		* ? ? ? ? : ? : x;
		? 1 1 ? 0 : ? : 1;
		? 1 0 0 ? : ? : 0;
		? ? ? 1 ? : ? : 1;
		? ? ? 0 1 : ? : 0;
		? 0 * ? ? : ? : -;
		? 0 ? * 0 : 1 : 1;
		? 0 ? 0 * : 0 : 0;
		? * 1 ? 0 : 1 : 1;
		? * 0 0 ? : 0 : 0;
		? ? 1 * 0 : 1 : 1;
		? ? 0 0 * : 0 : 0;
	endtable
endprimitive
`endif
