module mux_row (
							clk, 
							aclr, 
							rama,
							ramb,
							ramc,
							sel_row1,
							sel_row2,
							sel_row3,
							row_end,
							row1_1,
							row1_2,
							row1_3,
							row2_1,
							row2_2,
							row2_3,
							row3_1,
							row3_2,
							row3_3
						  );

	parameter idle=0, A=1, B=2, C=3;

	input clk, aclr;
	input [9:0] rama, ramb, ramc;
	input [1:0] sel_row1, sel_row2, sel_row3;
	input row_end;
	output [9:0] row1_1, row1_2, row1_3;
	output [9:0] row2_1, row2_2, row2_3;
	output [9:0] row3_1, row3_2, row3_3;


	//Reg Declaration
	wire [9:0] col1_a, col1_b, col1_c;
	wire [9:0] col2_a, col2_b, col2_c;
	wire [9:0] col3_a, col3_b, col3_c;
	reg row_end_del1, row_end_del2, row_end_del3, row_end_del4, row_end_del5;
	reg [9:0] ram_col3_a, ram_col3_b, ram_col3_c;
	reg [9:0] ram_col3_a_dly1,ram_col3_a_dly2,ram_col3_a_dly3,ram_col3_a_dly4,ram_col3_a_dly5,ram_col3_a_dly6;
	reg [9:0] ram_col3_b_dly1,ram_col3_b_dly2,ram_col3_b_dly3,ram_col3_b_dly4,ram_col3_b_dly5,ram_col3_b_dly6;
	reg [9:0] ram_col3_c_dly1,ram_col3_c_dly2,ram_col3_c_dly3,ram_col3_c_dly4,ram_col3_c_dly5,ram_col3_c_dly6;
	
	//Wire Declaration
	wire sel_edge_col3 = row_end_del4;
	wire sel_edge_col1 = row_end_del5;
	
	
	/**********************************************************/
//	assign row1_1 = sel_edge_col1 ? (29'b0000000000) : (col1_a);
//	assign row1_2 = col2_a;
//	assign row1_3 = sel_edge_col3 ? (29'b0000000000) : (col3_a);
//	assign row2_1 = sel_edge_col1 ? (29'b0000000000) : (col1_b);
//	assign row2_2 = col2_b;
//	assign row2_3 = sel_edge_col3 ? (29'b0000000000) : (col3_b);
//	assign row3_1 = sel_edge_col1 ? (29'b0000000000) : (col1_c);
//	assign row3_2 = col2_c;
//	assign row3_3 = sel_edge_col3 ? (29'b0000000000) : (col3_c);
	
	assign row1_1 = col1_a;
	assign row1_2 = col2_a;
	assign row1_3 = col3_a;
	assign row2_1 = col1_b;
	assign row2_2 = col2_b;
	assign row2_3 = col3_b;
	assign row3_1 = col1_c;
	assign row3_2 = col2_c;
	assign row3_3 = col3_c;
	
	always @ (posedge clk or negedge aclr)
	begin
	if (!aclr)
	begin
		row_end_del1 <= 0;
		row_end_del2 <= 0;
		row_end_del3 <= 0;
		row_end_del4 <= 0;
		row_end_del5 <= 0;
	end
	else 
	begin
		row_end_del1 <= row_end;
		row_end_del2 <= row_end_del1;
		row_end_del3 <= row_end_del2;
		row_end_del4 <= row_end_del3;
		row_end_del5 <= row_end_del4;
	end       
	end

	always @ (rama or ramb or ramc or sel_row1)
	begin
		case (sel_row1)
		idle:
		begin
			ram_col3_a = 0;
		end
		A:
		begin
			ram_col3_a = rama;  
		end
		B: 
		begin
			ram_col3_a = ramb;
		end
		C:
		begin
			ram_col3_a = ramc;
		end
		endcase	
	end
			

	always @ (posedge clk or negedge aclr)
	begin
		if (!aclr)
	   begin
			ram_col3_a_dly1 <= 0;
			ram_col3_a_dly2 <= 0;
			ram_col3_a_dly3 <= 0;
			ram_col3_a_dly4 <= 0;
			ram_col3_a_dly5 <= 0;
			ram_col3_a_dly6 <= 0;
		end
		else
		begin
			ram_col3_a_dly1 <= ram_col3_a;
			ram_col3_a_dly2 <= ram_col3_a_dly1;
			ram_col3_a_dly3 <= ram_col3_a_dly2;
			ram_col3_a_dly4 <= ram_col3_a_dly3;
			ram_col3_a_dly5 <= ram_col3_a_dly4;
			ram_col3_a_dly6 <= ram_col3_a_dly5;
		end
	end

	assign col3_a=ram_col3_a_dly2;
	assign col2_a=ram_col3_a_dly4;
	assign col1_a=ram_col3_a_dly6;
	
	always @ (rama or ramb or ramc or sel_row2)
	begin
	   case (sel_row2)
		idle: 
		begin
			ram_col3_b = 0;
		end			
		A:
		begin
			ram_col3_b = rama;  
		end
		B:
		begin
			ram_col3_b = ramb;
		end
		C: 
		begin
			ram_col3_b = ramc;
  		end
   	endcase	
	end


	always @ (posedge clk or negedge aclr) 
	begin
   if (!aclr)
	begin
		ram_col3_b_dly1 <= 0;
		ram_col3_b_dly2 <= 0;
		ram_col3_b_dly3 <= 0;
		ram_col3_b_dly4 <= 0;
		ram_col3_b_dly5 <= 0;
		ram_col3_b_dly6 <= 0;
	end
	else
	begin
		ram_col3_b_dly1 <= ram_col3_b;
		ram_col3_b_dly2 <= ram_col3_b_dly1;
		ram_col3_b_dly3 <= ram_col3_b_dly2;
		ram_col3_b_dly4 <= ram_col3_b_dly3;
		ram_col3_b_dly5 <= ram_col3_b_dly4;
		ram_col3_b_dly6 <= ram_col3_b_dly5;
	end
	end
	
	assign col3_b=ram_col3_b_dly2;
	assign col2_b=ram_col3_b_dly4;
	assign col1_b=ram_col3_b_dly6;
	
	always @ (rama or ramb or ramc or sel_row3)
	begin
	   case (sel_row3)
		idle: 
		begin
			ram_col3_c = 0;
		end				
		A: 
		begin
			ram_col3_c = rama;  
		end
		B: 
		begin
			ram_col3_c = ramb;
		end
		C: 
		begin
			ram_col3_c = ramc;
  		end
   	endcase	
	end


	always @ (posedge clk or negedge aclr)
	begin
   if (!aclr)
	begin
		ram_col3_c_dly1 <= 0;
		ram_col3_c_dly2 <= 0;
		ram_col3_c_dly3 <= 0;
		ram_col3_c_dly4 <= 0;
		ram_col3_c_dly5 <= 0;
		ram_col3_c_dly6 <= 0;
	end
	else
	begin
	   ram_col3_c_dly1 <= ram_col3_c;
		ram_col3_c_dly2 <= ram_col3_c_dly1;
		ram_col3_c_dly3 <= ram_col3_c_dly2;
		ram_col3_c_dly4 <= ram_col3_c_dly3;
		ram_col3_c_dly5 <= ram_col3_c_dly4;
		ram_col3_c_dly6 <= ram_col3_c_dly5;
	end
	end

	assign col3_c=ram_col3_c_dly2;
	assign col2_c=ram_col3_c_dly4;
	assign col1_c=ram_col3_c_dly6;

	      

endmodule
