// Copyright (C) 1991-2002 Altera Corporation
// Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// support information,  device programming or simulation file,  and any other
// associated  documentation or information  provided by  Altera  or a partner
// under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// other  use  of such  megafunction  design,  netlist,  support  information,
// device programming or simulation file,  or any other  related documentation
// or information  is prohibited  for  any  other purpose,  including, but not
// limited to  modification,  reverse engineering,  de-compiling, or use  with
// any other  silicon devices,  unless such use is  explicitly  licensed under
// a separate agreement with  Altera  or a megafunction partner.  Title to the
// intellectual property,  including patents,  copyrights,  trademarks,  trade
// secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// support  information,  device programming or simulation file,  or any other
// related documentation or information provided by  Altera  or a megafunction
// partner, remains with Altera, the megafunction partner, or their respective
// licensors. No other licenses, including any licenses needed under any third
// party's intellectual property, are provided herein.
`timescale 1ns / 1ps
module ctrl(
					aclr,
					data_valid_in,
					clk,
					frame_end_rd,
					rama_rden,
					ramb_rden,
					ramc_rden,
					rama_wren,
					ramb_wren,
					ramc_wren,
					row_end_rd,
					rama_rdadd,
					rama_wradd,
					ramb_rdadd,
					ramb_wradd,
					ramc_rdadd,
					ramc_wradd,
					sel_row1_out,
					sel_row2_out,
					sel_row3_out
);

	input	aclr;
	input	data_valid_in;
	input	clk;

	output	rama_rden;
	output	ramb_rden;
	output	ramc_rden;
	output	rama_wren;
	output	ramb_wren;
	output	ramc_wren;

	output	[9:0] rama_rdadd;
	output	[9:0] rama_wradd;
	output	[9:0] ramb_rdadd;
	output	[9:0] ramb_wradd;
	output	[9:0] ramc_rdadd;
	output	[9:0] ramc_wradd;
	output	[1:0] sel_row1_out;
	output	[1:0] sel_row2_out;
	output	[1:0] sel_row3_out;
	output row_end_rd;
	output frame_end_rd;
	
	
	reg rama_wren, ramb_wren, ramc_wren;
	//reg [9:0] rama_wradd, ramb_wradd, ramc_wradd;
	
	reg [2:0] ram_wr_state;
	

	parameter idle_wr = 0, rowA_wr = 1, rowB_wr = 3, rowC_wr = 5, idle1_wr=2,  idle2_wr=4,  idle3_wr=6;
	//parameter column_size=12,row_size=16;
	parameter column_size=1280,row_size=1024;

	reg [10:0] count_pixel_wr;
	reg row_end_wr;
	reg [10:0] count_row_wr;
	reg frame_end_wr;

	always @(posedge clk or negedge aclr)
	begin
		if (!aclr)
		begin
			ram_wr_state <= idle_wr;
			rama_wren <= 0;
			ramb_wren <= 0;
			ramc_wren <= 0;
		end
		else
		begin
			case (ram_wr_state)
				idle_wr:
				begin
			  		if (data_valid_in)
					begin
						ram_wr_state <= rowA_wr;
						rama_wren <= 1;
						ramb_wren <= 0;
						ramc_wren <= 0;
					end
				end
				rowA_wr:
				begin
					if (row_end_wr && frame_end_wr)
			      begin			
						ram_wr_state <= idle_wr;
						rama_wren <= 0;
						ramb_wren <= 0;
						ramc_wren <= 0;						
					end
					else if (row_end_wr)
					begin
						ram_wr_state <= idle1_wr;
						rama_wren <= 0;
						ramb_wren <= 0;	
						ramc_wren <= 0;
						
					end
					else
					begin
						rama_wren <=!rama_wren;
						ramb_wren <= 0;
						ramc_wren <= 0;
					end
				end
				idle1_wr:
				begin
					if (data_valid_in)
					begin
						ram_wr_state <= rowB_wr;
						rama_wren <= 0;
						ramb_wren <= 1;
						ramc_wren <= 0;
					end
				end
				rowB_wr:
				begin
					if (row_end_wr && frame_end_wr)		      
					begin			
						ram_wr_state <= idle_wr;
						rama_wren <= 0;
						ramb_wren <= 0;
						ramc_wren <= 0;	
					end
					else if (row_end_wr)
					begin	
						ram_wr_state <= idle2_wr;
						rama_wren <= 0;
						ramb_wren <= 0;
						ramc_wren <= 0;
					end
					else
					begin
						rama_wren <= 0;
						ramb_wren <= !ramb_wren;
						ramc_wren <= 0;
					end
				end
				idle2_wr:
				begin
					if (data_valid_in)
					begin
						ram_wr_state <= rowC_wr;
						rama_wren <= 0;
						ramb_wren <= 0;
						ramc_wren <= 1;
					end
				end
				rowC_wr:
				begin
					if (row_end_wr && frame_end_wr)		      
					begin			
						ram_wr_state <= idle_wr;
						rama_wren <= 0;
						ramb_wren <= 0;
						ramc_wren <= 0;
					end
					else if (row_end_wr)
					begin
						ram_wr_state <= idle3_wr;
						rama_wren <= 0;
						ramb_wren <= 0;
						ramc_wren <= 0;
					end
					else
					begin
						rama_wren <=0;
						ramb_wren <=0;
						ramc_wren <=!ramc_wren;
					end
				end
				idle3_wr:
				begin
					if (data_valid_in)
					begin
						ram_wr_state <= rowA_wr;
						rama_wren <= 1;
						ramb_wren <= 0;
						ramc_wren <= 0;
					end
				end
			endcase	
		end	
	end

	always @(posedge clk or negedge aclr)
	begin
	if (!aclr) 
		begin
			count_pixel_wr <= 0;
			row_end_wr <= 0;
         count_row_wr <= 0;
         frame_end_wr <= 0;

	    end
	else 
	if (ram_wr_state==rowA_wr||ram_wr_state==rowB_wr||ram_wr_state==rowC_wr)//
	begin 
		if (count_pixel_wr==column_size-2)
	   begin
			row_end_wr <= 1;
			count_pixel_wr <= count_pixel_wr + 1;
			if(count_row_wr==row_size/2-1)//?
				begin	
		         frame_end_wr <= 1;
			   end
			   else
			   begin
			      frame_end_wr <= 0;
			   end
		end
	  	else if(count_pixel_wr==column_size-1)
		begin
			row_end_wr<=0;
			count_pixel_wr<=0;
			frame_end_wr<=0;
			if(count_row_wr==row_size/2-1)
				begin
					count_row_wr <= 0;	       
			   end
			else
			   begin
               count_row_wr<=count_row_wr+1;			      
			   end
		end
		else 
		begin
			count_pixel_wr <= count_pixel_wr + 1;
			row_end_wr <= 0;
			frame_end_wr <= 0;
		end
	end
	end
	
	assign rama_wradd=(ram_wr_state==rowA_wr)?count_pixel_wr[10:1]:0;
	assign ramb_wradd=(ram_wr_state==rowB_wr)?count_pixel_wr[10:1]:0;
	assign ramc_wradd=(ram_wr_state==rowC_wr)?count_pixel_wr[10:1]:0;
	
	
	
	
	//**************************************************************//
	parameter idle_rd=0,work1_rd=1,idle1_rd=2,work2_rd=3,idle2_rd=4,work3_rd=5,idle3_rd=6,work4_rd=7,work5_rd=8,idle4_rd=9;
	reg [3:0] ram_rd_state;
	reg [10:0] count_pixel_rd;
	reg row_end_rd;
	reg [10:0] count_row_rd;
	reg frame_end_rd;
	reg rama_rden,ramb_rden,ramc_rden;
	wire [9:0] rama_rdadd,ramb_rdadd,ramc_rdadd;
	reg [1:0] sel_row1,sel_row2,sel_row3;
	reg [1:0] sel_row1_out,sel_row2_out,sel_row3_out;
	
	always@(posedge clk or negedge aclr)
	begin
		if(!aclr)
		begin
			ram_rd_state<=idle_rd;
			rama_rden <= 0;
			ramb_rden <= 0;
			ramc_rden <= 0;
			sel_row1 <= 0;
			sel_row2 <= 0;
			sel_row3 <= 0;
		end
		else
			case(ram_rd_state)
			idle_rd: 
			begin
			  	if (ram_wr_state == rowB_wr)//
				begin
					ram_rd_state <= work1_rd;
					rama_rden <= 1;
					ramb_rden <= 1;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 1;
					sel_row3 <= 2;
				end
				else
				begin
					rama_rden <= 0;
					ramb_rden <= 0;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
				end
			end
			work1_rd:
			begin
//				if(count_row_rd==row_size/2-1)
//				begin
//					ram_rd_state <= work5_rd;//?
//					rama_rden <= 1;
//					ramb_rden <= 1;
//					ramc_rden <= 0;
//					sel_row1 <= 1;
//					sel_row2 <= 2;
//					sel_row3 <= 0;
//				end
//				else 
				if(row_end_rd)
				begin
					ram_rd_state <= idle1_rd;
					rama_rden <= 0;
					ramb_rden <= 0;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
				end
				else
				begin
					rama_rden <= !rama_rden;
					ramb_rden <= !ramb_rden;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 1;
					sel_row3 <= 2;
				end
			end
			idle1_rd:
			begin
				if(count_row_rd==row_size/2-1)
				begin
					ram_rd_state <= idle4_rd;//?
					rama_rden <= 0;
					ramb_rden <= 0;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
				end
				else if (ram_wr_state == rowC_wr)
				begin
					ram_rd_state <= work2_rd;
					rama_rden <= 1;
					ramb_rden <= 1;
					ramc_rden <= 1;
					sel_row1 <= 1;
					sel_row2 <= 2;
					sel_row3 <= 3;
				end
			end
			work2_rd:
			begin
//				if(count_row_rd==row_size/2-1)
//				begin
//					ram_rd_state <= work5_rd;//?
//					rama_rden <= 1;
//					ramb_rden <= 1;
//					ramc_rden <= 0;
//					sel_row1 <= 1;
//					sel_row2 <= 2;
//					sel_row3 <= 0;
//				end
//				else 
				if(row_end_rd)
				begin
					ram_rd_state <= idle2_rd;
					rama_rden <= 0;
					ramb_rden <= 0;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
				end
				else
				begin
					rama_rden <= !rama_rden;
					ramb_rden <= !ramb_rden;
					ramc_rden <= !ramc_rden;
					sel_row1 <= 1;
					sel_row2 <= 2;
					sel_row3 <= 3;
				end
			end
			idle2_rd:
			begin
				if (ram_wr_state == rowA_wr)
				begin
					ram_rd_state <= work3_rd;
					rama_rden <= 1;
					ramb_rden <= 1;
					ramc_rden <= 1;
					sel_row1 <= 2;
					sel_row2 <= 3;
					sel_row3 <= 1;
				end
			end
			work3_rd:
			begin
//				if(count_row_rd==row_size/2-1)
//				begin
//					ram_rd_state <= work5_rd;//?
//					rama_rden <= 1;
//					ramb_rden <= 1;
//					ramc_rden <= 0;
//					sel_row1 <= 1;
//					sel_row2 <= 2;
//					sel_row3 <= 0;
//				end
//				else 
				if(row_end_rd)
				begin
					ram_rd_state <= idle3_rd;
					rama_rden <= 0;
					ramb_rden <= 0;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
				end
				else
				begin
					rama_rden <= !rama_rden;
					ramb_rden <= !ramb_rden;
					ramc_rden <= !ramc_rden;
					sel_row1 <= 2;
					sel_row2 <= 3;
					sel_row3 <= 1;
				end				
			end
			idle3_rd:
			begin
//				if(count_row_rd==row_size/2-1)
//				begin
//					ram_rd_state <= work5_rd;//?
//					rama_rden <= 1;
//					ramb_rden <= 1;
//					ramc_rden <= 0;
//					sel_row1 <= 1;
//					sel_row2 <= 2;
//					sel_row3 <= 0;
//				end
//				else 
				if (ram_wr_state == rowB_wr)
				begin
					ram_rd_state <= work4_rd;
					rama_rden <= 1;
					ramb_rden <= 1;
					ramc_rden <= 1;
					sel_row1 <= 3;
					sel_row2 <= 1;
					sel_row3 <= 2;
				end
			end
			work4_rd:
			begin
//				if(count_row_rd==row_size/2-1)
//				begin
//					ram_rd_state <= work5_rd;//?
//					rama_rden <= 1;
//					ramb_rden <= 1;
//					ramc_rden <= 0;
//					sel_row1 <= 1;
//					sel_row2 <= 2;
//					sel_row3 <= 0;
//				end
//				else 
				if(row_end_rd)
				begin
					ram_rd_state <= idle1_rd;
					rama_rden <= 0;
					ramb_rden <= 0;
					ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
				end
				else
				begin
					rama_rden <= !rama_rden;
					ramb_rden <= !ramb_rden;
					ramc_rden <= !ramc_rden;
				end
			end
			
			
			idle4_rd:
			begin
			if(count_row_rd==row_size/2-1)
				begin
					ram_rd_state <= work5_rd;//?
					rama_rden <= 1;
					ramb_rden <= 1;
					ramc_rden <= 0;
					sel_row1 <= 1;
					sel_row2 <= 2;
					sel_row3 <= 0;
				end
			end
			
			
			work5_rd:
			begin
			   if(row_end_rd)
			   begin
			      ram_rd_state<=idle_rd;
			      rama_rden <= 0;
			      ramb_rden <= 0;
			      ramc_rden <= 0;
					sel_row1 <= 0;
					sel_row2 <= 0;
					sel_row3 <= 0;
			   end
			   else
				begin
					rama_rden <= !rama_rden;
					ramb_rden <= !ramb_rden;
					ramc_rden <= 0;
				end	
			end
			endcase
	end
	
	always @(posedge clk or negedge aclr)
	begin
	if (!aclr) 
	begin
		count_pixel_rd <= 0;
		row_end_rd <= 0;
      count_row_rd <= 0;
      frame_end_rd <= 0;
	end
	else 
	if (ram_rd_state==work1_rd||ram_rd_state==work2_rd||ram_rd_state==work3_rd||ram_rd_state==work4_rd||ram_rd_state==work5_rd)//
	begin 
		if (count_pixel_rd==column_size-2)//10
	   begin
			row_end_rd <= 1;
			count_pixel_rd <= count_pixel_rd + 1;
			if(count_row_rd==row_size/2-1)
			begin	
		      frame_end_rd <= 1;
			end
			else
			begin
			   frame_end_rd <= 0;
			end
		end
	  	else if(count_pixel_rd==column_size-1)
		begin
			row_end_rd <= 0;
			count_pixel_rd <= 0;
			frame_end_rd <= 0;
			if(count_row_rd==row_size/2-1)
				begin
					count_row_rd <= 0;	       
			   end
			else
			   begin
               count_row_rd <= count_row_rd+1;			      
			   end
		end
		else 
		begin
			count_pixel_rd <= count_pixel_rd + 1;
			row_end_rd <= 0;
			frame_end_rd <= 0;
		end
	end
	end
	
	
	assign rama_rdadd=(ram_rd_state==work1_rd||ram_rd_state==work2_rd||ram_rd_state==work3_rd||ram_rd_state==work4_rd||ram_rd_state==work5_rd)?count_pixel_rd[10:1]:0;
	assign ramb_rdadd=(ram_rd_state==work1_rd||ram_rd_state==work2_rd||ram_rd_state==work3_rd||ram_rd_state==work4_rd||ram_rd_state==work5_rd)?count_pixel_rd[10:1]:0;
	assign ramc_rdadd=(ram_rd_state==work1_rd||ram_rd_state==work2_rd||ram_rd_state==work3_rd||ram_rd_state==work4_rd||ram_rd_state==work5_rd)?count_pixel_rd[10:1]:0;

	
	always @ (posedge clk or negedge aclr)	begin
	if (!aclr)
	begin
		sel_row1_out <= 0;		sel_row2_out <= 0;
		sel_row3_out <= 0;
	end
	else 
	begin
		sel_row1_out <= sel_row1;
		sel_row2_out <= sel_row2;
		sel_row3_out <= sel_row3;
	end
	end

endmodule
