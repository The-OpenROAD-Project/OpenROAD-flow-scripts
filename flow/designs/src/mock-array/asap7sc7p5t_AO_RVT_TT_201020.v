// BSD 3-Clause License
// 
// Copyright 2020 Lawrence T. Clark, Vinay Vashishtha, or Arizona State
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

// Verilog for library /home/ltclark/ASAP7/LIB2/Liberate_2/Verilog/asap7sc7p5t_AO_RVT_TT_201020 created by Liberate 18.1.0.293 on Sat Nov 28 03:36:02 MST 2020 for SDF version 2.1

// type:  
`timescale 1ns/10ps
`celldefine
module A2O1A1Ixp33_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0, C__bar);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2 & C))
			(B => Y) = 0;
		if ((~A1 & A2 & C))
			(B => Y) = 0;
		if ((~A1 & ~A2 & C))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
		if ((A1 & A2 & B))
			(C => Y) = 0;
		if ((A1 & A2 & ~B))
			(C => Y) = 0;
		if ((A1 & ~A2 & B))
			(C => Y) = 0;
		if ((~A1 & B))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module A2O1A1O1Ixp25_ASAP7_75t_R (Y, A1, A2, B, C, D);
	output Y;
	input A1, A2, B, C, D;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, D__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2;

	not (D__bar, D);
	not (C__bar, C);
	and (int_fwire_0, C__bar, D__bar);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar, D__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar, D__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2 & C & ~D))
			(B => Y) = 0;
		if ((~A1 & A2 & C & ~D))
			(B => Y) = 0;
		if ((~A1 & ~A2 & C & ~D))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
		if ((A1 & A2 & B & ~D))
			(C => Y) = 0;
		if ((A1 & A2 & ~B & ~D))
			(C => Y) = 0;
		if ((~A2 & B & ~D))
			(C => Y) = 0;
		if ((~A1 & A2 & B & ~D))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
		if ((B & ~C))
			(D => Y) = 0;
		if ((A1 & A2 & ~B & ~C))
			(D => Y) = 0;
		if ((A1 & ~A2 & ~B & C))
			(D => Y) = 0;
		if ((A1 & ~A2 & ~B & ~C) | (~A1 & A2 & ~B & ~C))
			(D => Y) = 0;
		if ((~A1 & A2 & ~B & C))
			(D => Y) = 0;
		if ((~A1 & ~A2 & ~B & C))
			(D => Y) = 0;
		if ((~A1 & ~A2 & ~B & ~C))
			(D => Y) = 0;
		ifnone (D => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO211x2_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B, C);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2 & ~C))
			(B => Y) = 0;
		if ((~A1 & A2 & ~C))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~C))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
		if ((A1 & ~A2 & ~B))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO21x1_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2))
			(B => Y) = 0;
		if ((~A1 & A2))
			(B => Y) = 0;
		if ((~A1 & ~A2))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO21x2_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2);
	or (Y, int_fwire_0, B);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2))
			(B => Y) = 0;
		if ((~A1 & A2))
			(B => Y) = 0;
		if ((~A1 & ~A2))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO221x1_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing
	specify
		if ((A2 & B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO221x2_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing
	specify
		if ((A2 & B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO222x2_ASAP7_75t_R (Y, A1, A2, B1, B2, C1, C2);
	output Y;
	input A1, A2, B1, B2, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2);
	and (int_fwire_2, A1, A2);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2 & C2) | (~A1 & ~A2 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2 & C1) | (~A1 & ~A2 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO22x1_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO22x2_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO31x2_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire int_fwire_0;

	and (int_fwire_0, A1, A2, A3);
	or (Y, int_fwire_0, B);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		(A3 => Y) = 0;
		if ((A1 & A2 & ~A3))
			(B => Y) = 0;
		if ((A1 & ~A2 & A3))
			(B => Y) = 0;
		if ((A1 & ~A2 & ~A3))
			(B => Y) = 0;
		if ((~A1 & A2 & A3))
			(B => Y) = 0;
		if ((~A1 & A2 & ~A3) | (~A1 & ~A2 & A3))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~A3))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO322x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~C1 & ~C2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & ~C1 & C2) | (~A1 & ~A2 & A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & C1) | (A1 & ~A2 & ~A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & C1) | (~A1 & A2 & ~A3 & ~B1 & B2 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO32x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2) | (~A1 & ~A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1) | (~A1 & ~A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO32x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2) | (~A1 & ~A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1) | (~A1 & ~A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO331x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C);
	output Y;
	input A1, A2, A3, B1, B2, B3, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C) | (~A1 & ~A2 & A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C) | (~A1 & ~A2 & A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C) | (~A1 & ~A2 & A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO331x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C);
	output Y;
	input A1, A2, A3, B1, B2, B3, C;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0, C);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C) | (~A1 & ~A2 & A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C) | (~A1 & ~A2 & A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C) | (~A1 & ~A2 & A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO332x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C2) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO332x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C2) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO333x1_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2, C3);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3) | (A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3) | (A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2) | (A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		ifnone (C3 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO333x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire int_fwire_0, int_fwire_1, int_fwire_2;

	and (int_fwire_0, C1, C2, C3);
	and (int_fwire_1, B1, B2, B3);
	and (int_fwire_2, A1, A2, A3);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3) | (A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3) | (A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2) | (A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		ifnone (C3 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AO33x2_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire int_fwire_0, int_fwire_1;

	and (int_fwire_0, B1, B2, B3);
	and (int_fwire_1, A1, A2, A3);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3) | (A2 & A3 & ~B1 & ~B2 & B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3) | (A1 & A3 & ~B1 & ~B2 & B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3) | (A1 & A2 & ~B1 & ~B2 & B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3) | (~A1 & ~A2 & A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3) | (~A1 & ~A2 & A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2) | (~A1 & ~A2 & A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI211x1_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar, C__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2 & ~C))
			(B => Y) = 0;
		if ((~A1 & A2 & ~C))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~C))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
		if ((A1 & ~A2 & ~B))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI211xp5_ASAP7_75t_R (Y, A1, A2, B, C);
	output Y;
	input A1, A2, B, C;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire C__bar, int_fwire_0, int_fwire_1;

	not (C__bar, C);
	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar, C__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2 & ~C))
			(B => Y) = 0;
		if ((~A1 & A2 & ~C))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~C))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
		if ((A1 & ~A2 & ~B))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI21x1_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0, int_fwire_1;

	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2))
			(B => Y) = 0;
		if ((~A1 & A2))
			(B => Y) = 0;
		if ((~A1 & ~A2))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI21xp33_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0, int_fwire_1;

	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2))
			(B => Y) = 0;
		if ((~A1 & A2))
			(B => Y) = 0;
		if ((~A1 & ~A2))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI21xp5_ASAP7_75t_R (Y, A1, A2, B);
	output Y;
	input A1, A2, B;

	// Function
	wire A1__bar, A2__bar, B__bar;
	wire int_fwire_0, int_fwire_1;

	not (B__bar, B);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_1, A1__bar, B__bar);
	or (Y, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		if ((A1 & ~A2))
			(B => Y) = 0;
		if ((~A1 & A2))
			(B => Y) = 0;
		if ((~A1 & ~A2))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI221x1_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;

	not (C__bar, C);
	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar, C__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar, C__bar);
	and (int_fwire_3, A1__bar, B1__bar, C__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2) | (~A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI221xp5_ASAP7_75t_R (Y, A1, A2, B1, B2, C);
	output Y;
	input A1, A2, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;

	not (C__bar, C);
	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar, C__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar, C__bar);
	and (int_fwire_3, A1__bar, B1__bar, C__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI222xp33_ASAP7_75t_R (Y, A1, A2, B1, B2, C1, C2);
	output Y;
	input A1, A2, B1, B2, C1, C2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, C1__bar, C2__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7;

	not (C2__bar, C2);
	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_1, A2__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A2__bar, B1__bar, C2__bar);
	and (int_fwire_3, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_4, A1__bar, B2__bar, C2__bar);
	and (int_fwire_5, A1__bar, B2__bar, C1__bar);
	and (int_fwire_6, A1__bar, B1__bar, C2__bar);
	and (int_fwire_7, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2 & ~C1 & ~C2) | (A2 & ~B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2 & ~C1 & ~C2) | (A1 & ~B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & ~A2 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI22x1_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3;

	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar);
	and (int_fwire_3, A1__bar, B1__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI22xp33_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3;

	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar);
	and (int_fwire_3, A1__bar, B1__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI22xp5_ASAP7_75t_R (Y, A1, A2, B1, B2);
	output Y;
	input A1, A2, B1, B2;

	// Function
	wire A1__bar, A2__bar, B1__bar;
	wire B2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3;

	not (B2__bar, B2);
	not (A2__bar, A2);
	and (int_fwire_0, A2__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B2__bar);
	and (int_fwire_3, A1__bar, B1__bar);
	or (Y, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & ~A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & ~A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI311xp33_ASAP7_75t_R (Y, A1, A2, A3, B, C);
	output Y;
	input A1, A2, A3, B, C;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, C__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2;

	not (C__bar, C);
	not (B__bar, B);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B__bar, C__bar);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar, C__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		(A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~C))
			(B => Y) = 0;
		if ((A1 & ~A2 & A3 & ~C))
			(B => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~C))
			(B => Y) = 0;
		if ((~A1 & A2 & A3 & ~C))
			(B => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~C) | (~A1 & ~A2 & A3 & ~C))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~C))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B) | (~A1 & ~A2 & A3 & ~B))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI31xp33_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2;

	not (B__bar, B);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B__bar);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		(A3 => Y) = 0;
		if ((A1 & A2 & ~A3))
			(B => Y) = 0;
		if ((A1 & ~A2 & A3))
			(B => Y) = 0;
		if ((A1 & ~A2 & ~A3))
			(B => Y) = 0;
		if ((~A1 & A2 & A3))
			(B => Y) = 0;
		if ((~A1 & A2 & ~A3) | (~A1 & ~A2 & A3))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~A3))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI31xp67_ASAP7_75t_R (Y, A1, A2, A3, B);
	output Y;
	input A1, A2, A3, B;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2;

	not (B__bar, B);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B__bar);
	not (A2__bar, A2);
	and (int_fwire_1, A2__bar, B__bar);
	not (A1__bar, A1);
	and (int_fwire_2, A1__bar, B__bar);
	or (Y, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		(A1 => Y) = 0;
		(A2 => Y) = 0;
		(A3 => Y) = 0;
		if ((A1 & A2 & ~A3))
			(B => Y) = 0;
		if ((A1 & ~A2 & A3))
			(B => Y) = 0;
		if ((A1 & ~A2 & ~A3))
			(B => Y) = 0;
		if ((~A1 & A2 & A3))
			(B => Y) = 0;
		if ((~A1 & A2 & ~A3) | (~A1 & ~A2 & A3))
			(B => Y) = 0;
		if ((~A1 & ~A2 & ~A3))
			(B => Y) = 0;
		ifnone (B => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI321xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C);
	output Y;
	input A1, A2, A3, B1, B2, C;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, C__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;

	not (C__bar, C);
	not (B2__bar, B2);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B2__bar, C__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A3__bar, B1__bar, C__bar);
	not (A2__bar, A2);
	and (int_fwire_2, A2__bar, B2__bar, C__bar);
	and (int_fwire_3, A2__bar, B1__bar, C__bar);
	not (A1__bar, A1);
	and (int_fwire_4, A1__bar, B2__bar, C__bar);
	and (int_fwire_5, A1__bar, B1__bar, C__bar);
	or (Y, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~C))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~C))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~C))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~C))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~C))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~C))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & ~C))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & ~C))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & ~C) | (~A1 & ~A2 & A3 & B2 & ~C))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & ~C))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~C))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~C))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~C) | (~A1 & ~A2 & A3 & B1 & ~C))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~C))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2))
			(C => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2) | (~A1 & ~A2 & A3 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2) | (~A1 & ~A2 & A3 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2) | (~A1 & ~A2 & A3 & ~B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2))
			(C => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2))
			(C => Y) = 0;
		ifnone (C => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI322xp5_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, C1, C2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, C1__bar;
	wire C2__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3, int_fwire_4;
	wire int_fwire_5, int_fwire_6, int_fwire_7;
	wire int_fwire_8, int_fwire_9, int_fwire_10;
	wire int_fwire_11;

	not (C2__bar, C2);
	not (B2__bar, B2);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B2__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_1, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A3__bar, B1__bar, C2__bar);
	and (int_fwire_3, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_4, A2__bar, B2__bar, C2__bar);
	and (int_fwire_5, A2__bar, B2__bar, C1__bar);
	and (int_fwire_6, A2__bar, B1__bar, C2__bar);
	and (int_fwire_7, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_8, A1__bar, B2__bar, C2__bar);
	and (int_fwire_9, A1__bar, B2__bar, C1__bar);
	and (int_fwire_10, A1__bar, B1__bar, C2__bar);
	and (int_fwire_11, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~C1 & ~C2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & ~C1 & C2) | (~A1 & ~A2 & A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & C1) | (A1 & ~A2 & ~A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & C1) | (~A1 & A2 & ~A3 & ~B1 & B2 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI32xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2);
	output Y;
	input A1, A2, A3, B1, B2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;
	wire int_fwire_4, int_fwire_5;

	not (B2__bar, B2);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_1, A3__bar, B1__bar);
	not (A2__bar, A2);
	and (int_fwire_2, A2__bar, B2__bar);
	and (int_fwire_3, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_4, A1__bar, B2__bar);
	and (int_fwire_5, A1__bar, B1__bar);
	or (Y, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & ~B2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2) | (~A1 & ~A2 & A3 & B2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1) | (~A1 & ~A2 & A3 & B1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI331xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, int_fwire_0, int_fwire_1;
	wire int_fwire_2, int_fwire_3, int_fwire_4;
	wire int_fwire_5, int_fwire_6, int_fwire_7;
	wire int_fwire_8;

	not (C1__bar, C1);
	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar, C1__bar);
	not (B2__bar, B2);
	and (int_fwire_1, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_3, A2__bar, B3__bar, C1__bar);
	and (int_fwire_4, A2__bar, B2__bar, C1__bar);
	and (int_fwire_5, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_6, A1__bar, B3__bar, C1__bar);
	and (int_fwire_7, A1__bar, B2__bar, C1__bar);
	and (int_fwire_8, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI332xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, C2__bar, int_fwire_0;
	wire int_fwire_1, int_fwire_2, int_fwire_3;
	wire int_fwire_4, int_fwire_5, int_fwire_6;
	wire int_fwire_7, int_fwire_8, int_fwire_9;
	wire int_fwire_10, int_fwire_11, int_fwire_12;
	wire int_fwire_13, int_fwire_14, int_fwire_15;
	wire int_fwire_16, int_fwire_17;

	not (C2__bar, C2);
	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_1, A3__bar, B3__bar, C1__bar);
	not (B2__bar, B2);
	and (int_fwire_2, A3__bar, B2__bar, C2__bar);
	and (int_fwire_3, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_4, A3__bar, B1__bar, C2__bar);
	and (int_fwire_5, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_6, A2__bar, B3__bar, C2__bar);
	and (int_fwire_7, A2__bar, B3__bar, C1__bar);
	and (int_fwire_8, A2__bar, B2__bar, C2__bar);
	and (int_fwire_9, A2__bar, B2__bar, C1__bar);
	and (int_fwire_10, A2__bar, B1__bar, C2__bar);
	and (int_fwire_11, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_12, A1__bar, B3__bar, C2__bar);
	and (int_fwire_13, A1__bar, B3__bar, C1__bar);
	and (int_fwire_14, A1__bar, B2__bar, C2__bar);
	and (int_fwire_15, A1__bar, B2__bar, C1__bar);
	and (int_fwire_16, A1__bar, B1__bar, C2__bar);
	and (int_fwire_17, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2) | (A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C2) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C2) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1) | (A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1) | (A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1) | (~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1) | (~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI333xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3, C1, C2, C3);
	output Y;
	input A1, A2, A3, B1, B2, B3, C1, C2, C3;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire C1__bar, C2__bar, C3__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;
	wire int_fwire_9, int_fwire_10, int_fwire_11;
	wire int_fwire_12, int_fwire_13, int_fwire_14;
	wire int_fwire_15, int_fwire_16, int_fwire_17;
	wire int_fwire_18, int_fwire_19, int_fwire_20;
	wire int_fwire_21, int_fwire_22, int_fwire_23;
	wire int_fwire_24, int_fwire_25, int_fwire_26;

	not (C3__bar, C3);
	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar, C3__bar);
	not (C2__bar, C2);
	and (int_fwire_1, A3__bar, B3__bar, C2__bar);
	not (C1__bar, C1);
	and (int_fwire_2, A3__bar, B3__bar, C1__bar);
	not (B2__bar, B2);
	and (int_fwire_3, A3__bar, B2__bar, C3__bar);
	and (int_fwire_4, A3__bar, B2__bar, C2__bar);
	and (int_fwire_5, A3__bar, B2__bar, C1__bar);
	not (B1__bar, B1);
	and (int_fwire_6, A3__bar, B1__bar, C3__bar);
	and (int_fwire_7, A3__bar, B1__bar, C2__bar);
	and (int_fwire_8, A3__bar, B1__bar, C1__bar);
	not (A2__bar, A2);
	and (int_fwire_9, A2__bar, B3__bar, C3__bar);
	and (int_fwire_10, A2__bar, B3__bar, C2__bar);
	and (int_fwire_11, A2__bar, B3__bar, C1__bar);
	and (int_fwire_12, A2__bar, B2__bar, C3__bar);
	and (int_fwire_13, A2__bar, B2__bar, C2__bar);
	and (int_fwire_14, A2__bar, B2__bar, C1__bar);
	and (int_fwire_15, A2__bar, B1__bar, C3__bar);
	and (int_fwire_16, A2__bar, B1__bar, C2__bar);
	and (int_fwire_17, A2__bar, B1__bar, C1__bar);
	not (A1__bar, A1);
	and (int_fwire_18, A1__bar, B3__bar, C3__bar);
	and (int_fwire_19, A1__bar, B3__bar, C2__bar);
	and (int_fwire_20, A1__bar, B3__bar, C1__bar);
	and (int_fwire_21, A1__bar, B2__bar, C3__bar);
	and (int_fwire_22, A1__bar, B2__bar, C2__bar);
	and (int_fwire_23, A1__bar, B2__bar, C1__bar);
	and (int_fwire_24, A1__bar, B1__bar, C3__bar);
	and (int_fwire_25, A1__bar, B1__bar, C2__bar);
	and (int_fwire_26, A1__bar, B1__bar, C1__bar);
	or (Y, int_fwire_26, int_fwire_25, int_fwire_24, int_fwire_23, int_fwire_22, int_fwire_21, int_fwire_20, int_fwire_19, int_fwire_18, int_fwire_17, int_fwire_16, int_fwire_15, int_fwire_14, int_fwire_13, int_fwire_12, int_fwire_11, int_fwire_10, int_fwire_9, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3) | (A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3) | (A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3) | (A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3) | (A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3) | (A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3) | (A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & C1 & ~C2 & ~C3) | (A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2 & C3) | (A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2 & C3) | (A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2 & C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2 & C3) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3 & ~C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & C3) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3 & ~C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & B3 & ~C1 & ~C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3 & ~C1 & ~C2 & ~C3))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & C3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3 & ~C1 & ~C2 & ~C3))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & C3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3 & ~C1 & ~C2 & ~C3))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & C2 & ~C3) | (~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & C3))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~C1 & ~C2 & ~C3))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C2 & C3) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C2 & C3))
			(C1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C2 & C3))
			(C1 => Y) = 0;
		ifnone (C1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C3) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C3))
			(C2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C3))
			(C2 => Y) = 0;
		ifnone (C2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2) | (A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2) | (A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & B2 & ~B3 & C1 & C2) | (~A1 & ~A2 & ~A3 & ~B1 & ~B2 & B3 & C1 & C2))
			(C3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & ~B1 & ~B2 & ~B3 & C1 & C2))
			(C3 => Y) = 0;
		ifnone (C3 => Y) = 0;
	endspecify
endmodule
`endcelldefine

// type:  
`timescale 1ns/10ps
`celldefine
module AOI33xp33_ASAP7_75t_R (Y, A1, A2, A3, B1, B2, B3);
	output Y;
	input A1, A2, A3, B1, B2, B3;

	// Function
	wire A1__bar, A2__bar, A3__bar;
	wire B1__bar, B2__bar, B3__bar;
	wire int_fwire_0, int_fwire_1, int_fwire_2;
	wire int_fwire_3, int_fwire_4, int_fwire_5;
	wire int_fwire_6, int_fwire_7, int_fwire_8;

	not (B3__bar, B3);
	not (A3__bar, A3);
	and (int_fwire_0, A3__bar, B3__bar);
	not (B2__bar, B2);
	and (int_fwire_1, A3__bar, B2__bar);
	not (B1__bar, B1);
	and (int_fwire_2, A3__bar, B1__bar);
	not (A2__bar, A2);
	and (int_fwire_3, A2__bar, B3__bar);
	and (int_fwire_4, A2__bar, B2__bar);
	and (int_fwire_5, A2__bar, B1__bar);
	not (A1__bar, A1);
	and (int_fwire_6, A1__bar, B3__bar);
	and (int_fwire_7, A1__bar, B2__bar);
	and (int_fwire_8, A1__bar, B1__bar);
	or (Y, int_fwire_8, int_fwire_7, int_fwire_6, int_fwire_5, int_fwire_4, int_fwire_3, int_fwire_2, int_fwire_1, int_fwire_0);

	// Timing
	specify
		if ((A2 & A3 & B1 & B2 & ~B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & B1 & ~B2 & ~B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & B2 & ~B3) | (A2 & A3 & ~B1 & ~B2 & B3))
			(A1 => Y) = 0;
		if ((A2 & A3 & ~B1 & ~B2 & ~B3))
			(A1 => Y) = 0;
		ifnone (A1 => Y) = 0;
		if ((A1 & A3 & B1 & B2 & ~B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & B1 & ~B2 & ~B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & B2 & ~B3) | (A1 & A3 & ~B1 & ~B2 & B3))
			(A2 => Y) = 0;
		if ((A1 & A3 & ~B1 & ~B2 & ~B3))
			(A2 => Y) = 0;
		ifnone (A2 => Y) = 0;
		if ((A1 & A2 & B1 & B2 & ~B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & B1 & ~B2 & ~B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & B2 & ~B3) | (A1 & A2 & ~B1 & ~B2 & B3))
			(A3 => Y) = 0;
		if ((A1 & A2 & ~B1 & ~B2 & ~B3))
			(A3 => Y) = 0;
		ifnone (A3 => Y) = 0;
		if ((A1 & A2 & ~A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B2 & B3) | (~A1 & A2 & ~A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((~A1 & A2 & A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & A3 & B2 & B3))
			(B1 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B2 & B3))
			(B1 => Y) = 0;
		ifnone (B1 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B3) | (~A1 & A2 & ~A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & A3 & B1 & B3))
			(B2 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B3))
			(B2 => Y) = 0;
		ifnone (B2 => Y) = 0;
		if ((A1 & A2 & ~A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((A1 & ~A2 & ~A3 & B1 & B2) | (~A1 & A2 & ~A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((~A1 & A2 & A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & A3 & B1 & B2))
			(B3 => Y) = 0;
		if ((~A1 & ~A2 & ~A3 & B1 & B2))
			(B3 => Y) = 0;
		ifnone (B3 => Y) = 0;
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
