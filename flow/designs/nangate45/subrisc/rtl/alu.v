module Alu
(
	input wire[31:0] A,
	input wire[31:0] B,
	input wire OPFLAG, //[0]sub, [other]xan
	input wire[2:0] CONDFLAG, //[0]unsigned comparison, [1]lsb, [2]neg
	output wire[31:0] OPRES,
	output wire CONDRES
);

wire[31:0] adder_res, adder_and;
wire adder_cout;

wire[32:0] adder_a = {1'b0, A};
wire[32:0] adder_b = {1'b0, B};
wire[32:0] adder_r = adder_b - adder_a;
assign adder_res = adder_r[31:0];
assign adder_cout = adder_r[32];
assign adder_and = (A) & B;

assign OPRES = /*adder_res;*/
				OPFLAG 	? adder_and[31:0]
						  //Old for Subneg4X
						  //{!adder_cout, adder_and[31:1]} //Right-shifted AND
                    	: adder_res; //Sum
assign CONDRES = /*adder_res[31];*/
				 CONDFLAG[0] ? !adder_cout :
                 CONDFLAG[2] ? adder_res[31]
				             : !adder_and[0];

endmodule


module Shifter
(
input wire EN,
input wire[31:0] V,
input wire[4:0] ARGS,
output wire[31:0] RES
);

//Shift by 1, 2, 8

assign RES = V >> 8;

/*
wire[31:0] gatedV = EN ? V : 32'b0;

wire[31:0] res_shifhted = ARGS[0] ? (gatedV >> 1) :
                          ARGS[1] ? (gatedV >> 2) :
						  ARGS[2] ? (gatedV >> 8) : 32'd0;
assign RES = res_shifhted;
*/
endmodule
