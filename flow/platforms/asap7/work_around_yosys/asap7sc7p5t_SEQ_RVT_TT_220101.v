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
	//altos_dff_sr_err (xcr_0, delayed_CLK, int_fwire_d, int_fwire_s, int_fwire_r);
	// altos_dff_sr_0 (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, int_fwire_s, int_fwire_r, xcr_0);
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
endmodule
`endcelldefine

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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);
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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
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

	//altos_dff_err (xcr_0, delayed_CLK, delayed_D);
	//altos_dff (int_fwire_IQ, notifier, delayed_CLK, delayed_D, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
	buf (QN, int_fwire_IQN);

	// Timing
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
	//altos_dff_err (xcr_0, int_fwire_clk, delayed_D);
	//altos_dff (int_fwire_IQ, notifier, int_fwire_clk, delayed_D, xcr_0);
	buf (Q, int_fwire_IQ);

	// Timing
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

	//altos_latch (int_fwire_IQ, notifier, delayed_CLK, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
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

	//altos_latch (int_fwire_IQ, notifier, delayed_CLK, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
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

	//altos_latch (int_fwire_IQ, notifier, delayed_CLK, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, delayed_D);
	buf (Q, int_fwire_IQ);

	// Timing
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_latch (int_fwire_IQ, notifier, int_fwire_clk, int_fwire_test);
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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, delayed_CLK, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, delayed_CLK, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
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
	//altos_dff_err (xcr_0, int_fwire_clk, int_fwire_d);
	//altos_dff (int_fwire_IQN, notifier, int_fwire_clk, int_fwire_d, xcr_0);
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

endmodule
`endcelldefine
