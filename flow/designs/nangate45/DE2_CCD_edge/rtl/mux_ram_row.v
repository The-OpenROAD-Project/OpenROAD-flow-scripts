module mux_ram_row (
clk, 
aclr, 
rama,
ramb,

sel_row1,
sel_row2,

row_end,
row1_1,
row1_2,

row2_1,
row2_2


);

parameter idle=0, A=1;

input clk, aclr;
input [9:0] rama, ramb;
input sel_row1, sel_row2;
input row_end;
output [9:0] row1_1, row1_2;
output [9:0] row2_1, row2_2;



	//Reg Declaration
	reg [9:0] col1_a, col1_b;
	reg [9:0] col2_a, col2_b;

	reg row_end_del1, row_end_del2, row_end_del3, row_end_del4, row_end_del5;
	reg [9:0] ram_col2_a, ram_col2_b;
	
	
	//Wire Declaration
	wire sel_edge_col3 = row_end_del3;
	wire sel_edge_col1 = row_end_del4;
	
	
	
	assign row1_1 = sel_edge_col1 ? (10'b0000000000) : (col1_a);
	assign row1_2 = col2_a;
	
	assign row2_1 = sel_edge_col1 ? (10'b0000000000) : (col1_b);
	assign row2_2 = col2_b;

	
	
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

always @ (rama or sel_row1)
begin
	case (sel_row1)
		idle:
		begin
			ram_col2_a = 0;
		end		
		A:
		begin
			ram_col2_a = rama;  
		end
	endcase	
end
			
always @ (posedge clk or negedge aclr)
begin
   if (!aclr)
	begin
		col1_a <= 0;
		col2_a <= 0;
	end
	else
	begin
		col2_a <= ram_col2_a;
		col1_a <= col2_a;
	end
end

always @ ( ramb  or sel_row2)
begin
	case (sel_row2)
		idle: 
		begin
			ram_col2_b = 0;
		end		
		A: 
		begin
			ram_col2_b = ramb;  
		end
	endcase	
end

always @ (posedge clk or negedge aclr) 
begin
   if (!aclr)
	begin
		col1_b <= 0;
		col2_b <= 0;
	end
	else
	begin
		col2_b <= ram_col2_b;
		col1_b <= col2_b;
	end
end

endmodule
