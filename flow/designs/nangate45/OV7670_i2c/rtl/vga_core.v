`timescale 1ns / 1ps

module vga_core(
	input wire clk,rst_n, //clock must be 25MHz for 640x480 30fps
	output wire hsync,vsync,
	output reg video_on,
	output wire[11:0] pixel_x,pixel_y
    );		//650x480 parameters
	 localparam HD=640, //Horizontal Display
					HR=16, //Right Border
					HRet=96, //Horizontal Retrace
					HL=48, //Left Border
					
					VD=480, //Vertical Display
					VB=10, //Bottom Border
					VRet=2, //Vertical Retrace
					VT=33; //Top Border
	reg[11:0] vctr_q=0,vctr_d; //counter for vertical scan
	reg[11:0] hctr_q=0,hctr_d; //counter for vertical scan
	reg hsync_q=0,hsync_d;
	reg vsync_q=0,vsync_d;
	//vctr and hctr register operation
	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			vctr_q<=0;
			hctr_q<=0;
			vsync_q<=0;
			hsync_q<=0;
		end
		else begin
			vctr_q<=vctr_d;
			hctr_q<=hctr_d;
			vsync_q<=vsync_d;
			hsync_q<=hsync_d;
		end
	end
	
	always @* begin
		vctr_d=vctr_q;
		hctr_d=hctr_q;
		video_on=0;
		hsync_d=1; 
		vsync_d=1; 
		
		if(hctr_q==HD+HR+HRet+HL-1) hctr_d=0; //horizontal counter
		else hctr_d=hctr_q+1'b1;
		
		if(vctr_q==VD+VB+VRet+VT-1) vctr_d=0; //vertical counter
		else if(hctr_q==HD+HR+HRet+HL-1) vctr_d=vctr_q+1'b1;
		
		if(hctr_q<HD && vctr_q<VD) video_on=1; //video_on 
		
		if( (hctr_d>=HD+HR) && (hctr_d<=HD+HR+HRet-1) ) hsync_d=0; //horizontal sync 
		if( (vctr_d>=VD+VB) && (vctr_d<=VD+VB+VRet-1) ) vsync_d=0; //vertical sync
				
	end
		assign vsync=vsync_q;
		assign hsync=hsync_q;
		assign pixel_x=hctr_q;
		assign pixel_y=vctr_q;

endmodule
