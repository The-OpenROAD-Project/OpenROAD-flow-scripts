
`timescale 1ns / 1ps
module gen_ram_rden (
	clk, 
	aclr,
	rama_wren, 
	ramb_wren, 

	sel_row1_out, 
	sel_row2_out, 
   row_end,
	frame_end,
	
	rama_rden, 
	ramb_rden );

	input clk, aclr;
	input rama_wren, ramb_wren;
	output sel_row1_out, sel_row2_out;
	output row_end;
	output frame_end;//?
	output rama_rden, ramb_rden;

	//parameter column_size=12,row_size=10;//仿真时用
	parameter column_size=1280,row_size=1024;
    parameter idle = 0,  read_out = 1 ;

	//Reg Declaration
	reg sel_row1_out, sel_row2_out;
	reg sel_row1, sel_row2;
	reg row_state;
	reg [10:0] count_pixel;
	reg [10:0] count_row;

	//reg [10:0] count_idle_period;//
	//reg start_read;
	reg row_end;
	reg frame_end;
  
	
	
    
	//Wire Declaration
//	wire count_idle_period_en = rama_wren || ramb_wren ;//?那岂不是每行都有
//	wire count_pixel_en =  (row1_state == A) || (row1_state == B) ;

	
	
//	assign rama_rden = (sel_row1 == 2'b01) || (sel_row2 == 2'b01) ;
//	assign ramb_rden = (sel_row1 == 2'b10) || (sel_row2 == 2'b10) ;
	assign rama_rden = (sel_row1 == 2'b1) ?1:0 ;
	assign ramb_rden = (sel_row2 == 2'b1) ?1:0 ;

	

//always @ (posedge clk or posedge aclr)
//begin
//	if (aclr)
//   begin
//      count_idle_period <= 0;
//      start_read <= 0;
//   end
//   else
//		if (count_idle_period_en) 
//		begin			
//			if (count_idle_period == column_size)
//				start_read <= 1;
//         else
//         begin
//				count_idle_period <= count_idle_period + 1;
//				start_read <= 0;
//			end
//		end
//end
    
		
		
//always@(row1_state)
//begin
//	case (row1_state)
//		idle: 
//		begin
//			sel_row1 <= 2'b00;
//			count_idle_period <= 0;
//		end	
//		A: 
//		begin
//			sel_row1 <= 2'b01;
//		end
//		B: 
//		begin
//			sel_row1 <= 2'b10;
//		end
//		default :
//		begin
//			sel_row1 <= 2'b00;
//	   end
//	endcase
//end
//
//
//always@(row2_state)
//begin
//	case (row2_state)
//		idle: 
//		begin
//			sel_row2 <= 2'b00;
//			count_idle_period <= 0;
//		end		
//		A: 
//		begin
//			sel_row2 <= 2'b01;
//		end
//		B: 
//		begin
//			sel_row2 <= 2'b10;
//		end
//		default :
//		begin
//			sel_row2 <= 2'b00;
//	   end
//	endcase
//end




//always @(posedge clk or posedge aclr)
//begin
//	if (aclr)
//		row1_state <= idle;
//	else
//		case (row1_state)
//			idle: 
//			begin
//			  	if (start_read)
//					row1_state <= A;
//				end
//			A: 
//			begin
//			   if (frame_end)
//				begin
//				   count_idle_period<=0;
//					start_read<=0;
//					frame_end<=0;
//					row1_state <= idle;
//				end
//			   else if (row_end)
//					row1_state <= B;
//			end
//			B: 
//			begin
//				if (frame_end)
//				begin
//				   count_idle_period<=0;
//					start_read<=0;
//					frame_end<=0;
//					row1_state <= idle;
//				end
//			   else if (row_end)
//					row1_state <= A;
//			end		
//		endcase	
//end		
//
//
//always @(posedge clk or posedge aclr)
//begin
//	if (aclr)
//		row2_state <= idle;
//	else
//		case (row2_state)
//			idle: 
//			begin
//			  	if (start_read)
//					row2_state <= B;
//			end	
//			A: 
//			begin
//			   if (frame_end)
//				begin
//				   count_idle_period<=0;
//					start_read<=0;
//					frame_end<=0;
//					row2_state <= idle;
//				end		      
//			   else if (row_end)
//					row2_state <= B;
//			end
//			B: 
//			begin
//				if (frame_end)
//			   begin
//				   count_idle_period<=0;
//					start_read<=0;
//					frame_end<=0;
//					row2_state <= idle;
//				end
//			   else if (row_end)
//					row2_state <= A;
//			end		
//		endcase	
//end		




//always @(posedge clk or posedge aclr)
//begin
//	if (aclr) 
//	begin
//		count_pixel <= 0;
//		row_end <= 0;
//		count_row<=0;
//		frame_end<=0;
//	end
//	else if (count_pixel_en)
//	begin
//      if(count_pixel == column_size-1)
//		begin
//			count_pixel <= 0;
//			row_end <= 0;
//		end	
//		else if (count_pixel == column_size-2)
//		begin	   	  
//		   row_end <= 1;
//			count_pixel <= count_pixel+1;
//			if(count_row==row_size-1)
//		   begin
//				count_row<=0;	
//				frame_end <= 1;
//		   end
//			else
//		   begin
//				count_row<=count_row+1;
//				frame_end<=0;
//		   end
//		end
//		else
//		begin
//		   count_pixel <= count_pixel+1;
//			row_end <= 0;
//		end 
//	end
//end

always @ (posedge clk or negedge aclr)
begin
	if (!aclr)
	begin
      sel_row1_out <= 0;
      sel_row2_out <= 0;
	end
	else 
	begin
		sel_row1_out <= sel_row1;
		sel_row2_out <= sel_row2;
	end
end 











always@(posedge clk or negedge aclr)
begin
	if(!aclr)
	   row_state <= idle;	
	else 
		case(row_state)
			idle:
			begin
				if(ramb_wren)
					row_state<=read_out;
			end
	      read_out:
			begin
				if (frame_end)
				begin
				   //count_idle_period<=0;
					//start_read<=0;
					//frame_end<=0;
					row_state <= idle;
				end
			   else if (row_end)
					row_state <= idle;
			end
		endcase
end	      
always @(posedge clk or negedge aclr)
begin
	if (!aclr) 
	begin
		count_pixel <= 0;
		row_end <= 0;
		count_row<=0;
		frame_end<=0;
	end
	else if (row_state==read_out)//?
	begin
      if(count_pixel == column_size-2)
		begin
			row_end <= 1;
			count_pixel <= count_pixel+1;
			if(count_row==row_size/2-1)
		   begin
				frame_end <= 1;
		   end
			else
		   begin
				frame_end<=0;
		   end
		end	
		else if (count_pixel == column_size-1)
		begin	   	  
		   count_pixel <= 0;
			row_end <= 0;	
			frame_end<=0;	
         if(count_row==row_size/2-1)
		   begin
				count_row<=0;	
		   end
			else
		   begin
				count_row<=count_row+1;
		   end			
		end
		else
		begin
		   count_pixel <= count_pixel+1;
			row_end <= 0;
			frame_end<=0;
		end 
	end
end

always@(row_state)
begin
	case (row_state)
		idle: 
		begin
			sel_row1 <= 2'b0;
			sel_row2 <= 2'b0;
		end	
		read_out: 
		begin
			sel_row1 <= 2'b1;
			sel_row2 <= 2'b1;
		end
		default :
		begin
			sel_row1 <= 2'b0;
			sel_row2 <= 2'b0;
	   end
	endcase
end
endmodule
