`timescale 1ns/1ps
module gen_ram_wren (clk, aclr, data_valid, rama_wren, ramb_wren);

	input clk, aclr;
	input data_valid;//接CCD_Capture中的oDVAL
	output rama_wren, ramb_wren;

 
	//Reg Declaration
	reg rama_wren, ramb_wren;
	reg [1:0] ram_state;
	reg [10:0] count_pixel;//pixel计数
	reg [10:0] count_row;//row计数
	reg row_end;//一行结束
	reg frame_end;//一帧结束

	parameter idle0 = 0, rowA = 1,idle1=2, rowB = 3;
	//parameter column_size=12,row_size=10;
	parameter column_size=1280,row_size=1024;

always@(ram_state)
begin
	case (ram_state)
		idle0: 
		begin
			rama_wren <= 0;
			ramb_wren <= 0;
		end				
		rowA:
		begin
			rama_wren <= 1;
			ramb_wren <= 0;
		end
		idle1: 
		begin
			rama_wren <= 0;
			ramb_wren <= 0;
		end
		rowB: 
		begin
			rama_wren <= 0;
			ramb_wren <= 1;
		end			
	endcase
end


always @(posedge clk or negedge aclr)
begin
	if (!aclr)
		ram_state <= idle0;
	else
		case (ram_state)
			idle0: 
			begin
				if (data_valid)
					ram_state <= rowA;
			end	
			rowA: 
			begin
				if (row_end && frame_end)
				begin
					ram_state <= idle0;
					//frame_end<=0;
				end
				else if (row_end)
				begin
					ram_state <= idle1;
				end
			end
			idle1:
         begin
				if (data_valid)
					ram_state <= rowB;
			end
			rowB: 
			begin
				if (row_end && frame_end)
				begin
					ram_state <= idle0;
					//frame_end<=0;
				end
				else if (row_end)
					ram_state <= idle0;
			end
		endcase	
end		

//always @(posedge clk or posedge aclr)
//begin
//	if (aclr) 
//		begin
//			count_pixel <= 0;
//			row_end <= 0;
//         count_row<=0;
//         frame_end <= 0;
//
//	    end
//	else 
//	if (rama_wren || ramb_wren  || data_valid)//必须有data_valid,
//	begin 
//		if (count_pixel==column_size-1)
//	   begin
//			count_pixel <= 0;
//			row_end <= 1;
//			if(count_row==row_size-1)
//				begin
//					count_row<=0;	
//		         frame_end <= 1;
//			   end
//			   else
//			   begin
//               count_row<=count_row+1;
//			      frame_end<=0;
//			   end
//		end
//	  	else
//		begin
//			count_pixel <= count_pixel + 1;
//			row_end <= 0;
//		end
//	end
//end
always @(posedge clk or negedge aclr)
begin
	if (!aclr) 
		begin
			count_pixel <= 0;
			row_end <= 0;
         count_row<=0;
         frame_end <= 0;

	    end
	else 
	if (rama_wren || ramb_wren )//必须有data_valid,
	begin 
		if (count_pixel==column_size-2)
	   begin
			row_end <= 1;
			count_pixel <= count_pixel + 1;
			if(count_row==row_size-1)
				begin	
		         frame_end <= 1;
			   end
			   else
			   begin
			      frame_end<=0;
			   end
		end
	  	else if(count_pixel==column_size-1)
		begin
			row_end<=0;
			count_pixel<=0;
			frame_end<=0;
			if(count_row==row_size-1)
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
			count_pixel <= count_pixel + 1;
			row_end <= 0;
			frame_end<=0;
		end
	end
end

	      

endmodule

