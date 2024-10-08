module prim_secded_28_22_dec (
	in,
	d_o,
	syndrome_o,
	err_o
);
	input [27:0] in;
	output wire [21:0] d_o;
	output wire [5:0] syndrome_o;
	output wire [1:0] err_o;
	wire single_error;
	assign syndrome_o[0] = (((((((((((in[22] ^ in[0]) ^ in[1]) ^ in[2]) ^ in[3]) ^ in[4]) ^ in[5]) ^ in[6]) ^ in[7]) ^ in[8]) ^ in[9]) ^ in[20]) ^ in[21];
	assign syndrome_o[1] = (((((((((((in[23] ^ in[0]) ^ in[1]) ^ in[2]) ^ in[3]) ^ in[10]) ^ in[11]) ^ in[12]) ^ in[13]) ^ in[14]) ^ in[15]) ^ in[20]) ^ in[21];
	assign syndrome_o[2] = ((((((((((in[24] ^ in[0]) ^ in[4]) ^ in[5]) ^ in[6]) ^ in[10]) ^ in[11]) ^ in[12]) ^ in[16]) ^ in[17]) ^ in[18]) ^ in[20];
	assign syndrome_o[3] = ((((((((((in[25] ^ in[1]) ^ in[4]) ^ in[7]) ^ in[8]) ^ in[10]) ^ in[13]) ^ in[14]) ^ in[16]) ^ in[17]) ^ in[19]) ^ in[21];
	assign syndrome_o[4] = (((((((((((in[26] ^ in[2]) ^ in[5]) ^ in[7]) ^ in[9]) ^ in[11]) ^ in[13]) ^ in[15]) ^ in[16]) ^ in[18]) ^ in[19]) ^ in[20]) ^ in[21];
	assign syndrome_o[5] = (((((((((((in[27] ^ in[3]) ^ in[6]) ^ in[8]) ^ in[9]) ^ in[12]) ^ in[14]) ^ in[15]) ^ in[17]) ^ in[18]) ^ in[19]) ^ in[20]) ^ in[21];
	assign d_o[0] = (syndrome_o == 6'h07) ^ in[0];
	assign d_o[1] = (syndrome_o == 6'h0b) ^ in[1];
	assign d_o[2] = (syndrome_o == 6'h13) ^ in[2];
	assign d_o[3] = (syndrome_o == 6'h23) ^ in[3];
	assign d_o[4] = (syndrome_o == 6'h0d) ^ in[4];
	assign d_o[5] = (syndrome_o == 6'h15) ^ in[5];
	assign d_o[6] = (syndrome_o == 6'h25) ^ in[6];
	assign d_o[7] = (syndrome_o == 6'h19) ^ in[7];
	assign d_o[8] = (syndrome_o == 6'h29) ^ in[8];
	assign d_o[9] = (syndrome_o == 6'h31) ^ in[9];
	assign d_o[10] = (syndrome_o == 6'h0e) ^ in[10];
	assign d_o[11] = (syndrome_o == 6'h16) ^ in[11];
	assign d_o[12] = (syndrome_o == 6'h26) ^ in[12];
	assign d_o[13] = (syndrome_o == 6'h1a) ^ in[13];
	assign d_o[14] = (syndrome_o == 6'h2a) ^ in[14];
	assign d_o[15] = (syndrome_o == 6'h32) ^ in[15];
	assign d_o[16] = (syndrome_o == 6'h1c) ^ in[16];
	assign d_o[17] = (syndrome_o == 6'h2c) ^ in[17];
	assign d_o[18] = (syndrome_o == 6'h34) ^ in[18];
	assign d_o[19] = (syndrome_o == 6'h38) ^ in[19];
	assign d_o[20] = (syndrome_o == 6'h37) ^ in[20];
	assign d_o[21] = (syndrome_o == 6'h3b) ^ in[21];
	assign single_error = ^syndrome_o;
	assign err_o[0] = single_error;
	assign err_o[1] = ~single_error & |syndrome_o;
endmodule
