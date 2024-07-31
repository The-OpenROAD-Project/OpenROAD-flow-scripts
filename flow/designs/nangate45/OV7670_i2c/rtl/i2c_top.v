`timescale 1ns / 1ps

module i2c_top //works on both i2c and SCCB mode(no pullups resistors needed)
	#(parameter freq=100_000)
	(
	input wire clk, rst_n,
	input wire start,stop,
	input wire[7:0] wr_data,
	output reg rd_tick, //ticks when read data from servant is ready,data will be taken from rd_data
	output reg[1:0] ack, //ack[1] ticks at the ack bit[9th bit],ack[0] asserts when ack bit is ACK,else NACK
	output wire[7:0] rd_data, 
	inout scl,sda, 
	output wire[3:0] state
    ); 
	 
	 /*
	 i2c_top #(.freq(100_000)) m0
	(
		.clk(clk),
		.rst_n(rst_n),
		.start(start),
		.stop(stop),
		.wr_data(wr_data),
		.rd_tick(rd_tick), //ticks when read data from servant is ready,data will be taken from rd_data
		.ack(ack), //ack[1] ticks at the ack bit[9th bit],ack[0] asserts when ack bit is ACK,else NACK
		.rd_data(rd_data), 
		.scl(scl),
		.sda(sda)
    ); 
	 */
	 
	 localparam full= (100_000_000)/(2*freq),
					half= full/2,
					counter_width=log2(full);
					
	 function integer log2(input integer n); //automatically determines the width needed by counter
		integer i;
		 begin
			log2=1;
			for(i=0;2**i<n;i=i+1)
				log2=i+1;
		 end
	 endfunction
		 
	 //FSM state declarations
	 localparam[3:0] idle=0,
							starting=1,
							packet=2,
							ack_servant=3,
							renew_data=4,
							read=5,
							ack_master=6,
							stop_1=7,
							stop_2=8;
	 reg[3:0] state_q=idle,state_d;
	 reg start_q=0,start_d;
	 reg[3:0] idx_q=0,idx_d;
	 reg[8:0] wr_data_q=0,wr_data_d;
	 reg[7:0] rd_data_q,rd_data_d;
	 reg scl_q=0,scl_d;
	 reg sda_q=0,sda_d;
	 reg[counter_width-1:0] counter_q=0,counter_d;
	 wire scl_lo,scl_hi;
	 
	//register operations
	 always@(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			state_q<=idle;
			start_q<=0;
			idx_q<=0;
			wr_data_q<=0;
			scl_q<=0;
			sda_q<=0;
			counter_q<=0;
			rd_data_q<=0;
		end
		else begin
			state_q<=state_d;
			start_q<=start_d;
			idx_q<=idx_d;
			wr_data_q<=wr_data_d;
			scl_q<=scl_d;
			sda_q<=sda_d;
			counter_q<=counter_d;
			rd_data_q<=rd_data_d;
		end
	 end
	 
	 
	 //free-running clk, freq depends on parameter "freq"
	 always @* begin
		counter_d=counter_q+1;
		scl_d=scl_q;
		if(state_q==idle || state_q==starting) scl_d=1'b1;
		else if(counter_q==full) begin
			counter_d=0;
			scl_d=(scl_q==0)?1'b1:1'b0;
		end
	 end
	 
	 
	 //FSM next-state logic
	 always @* begin
		state_d=state_q;
		start_d=start_q;
		idx_d=idx_q;
		wr_data_d=wr_data_q;
		rd_data_d=rd_data_q;
		sda_d=sda_q;
		ack=0;
		rd_tick=0;
		case(state_q)
					idle: begin		//wait for the "start" to assert
								sda_d=1'b1;
								if(start==1'b1) begin
									wr_data_d={wr_data,1'b1}; //the last 1'b1 is for the ACK coming from the servant("1" means high impedance or "reading")
									start_d= (wr_data[0])? 1:0; // if last bit(R/W bit) is one:read after writing servant address, else write again after writing servant address
									idx_d=4'd8; //index to be used on transmitting the wr_data serially(MSB first)
									state_d=starting;
								end
							 end
							 
				starting: if(scl_hi) begin //start command, change sda to low while scl is high
								sda_d=0;
								state_d=packet;
							 end
							 
				  packet: if(scl_lo) begin //transmit wr_data serially(MSB first)
								sda_d= (wr_data_q[idx_q]==0)? 0:1'b1;
								idx_d= idx_q-1;
								if(idx_q==0) begin
									state_d=ack_servant;
									idx_d=0;
								end
							 end
  							 
			ack_servant: if(scl_hi) begin //wait for ACK bit response(9th bit) from servant
								ack[1]=1;
								ack[0]=!sda; 
								start_d=start;
								wr_data_d={wr_data,1'b1};
								if(stop) state_d=stop_1; //master can forcefully stops the transaction(even if response is either NACK or ACK)
								else if(start_q==1 && wr_data_q[1]) begin //if repeated start happened before, choose if its read or write based on wr_data[1] (R/W bit)
									start_d=0;
									idx_d=7;
									state_d=read;
								end
								else state_d=renew_data;
							 end
							 
			 renew_data: begin //new byte is comin(packets of data after the slave address)
								idx_d=8;
								if(start_q) begin //if master wants a repeated start
									state_d=starting;
								end
								else state_d=packet; //if master wants to continue writing
							 end
							 
					 read: if(scl_hi) begin //read data from slave(MSB first)
								rd_data_d[idx_q]=sda;
								idx_d=idx_q-1;
								if(idx_q==0) begin
									state_d=ack_master;
									idx_d=0;
								end
							 end
							 
			 ack_master: if(scl_lo) begin //master must ACK after receiving data from servant
								//sda_d=!sda_q; //acknowledge:1
								sda_d=1;  //dont acknowledge if using SCCB
								if(sda_q==0 || sda_d==1) begin
									rd_tick=1;
									idx_d=7;
									if(stop) state_d=stop_1; //after receiving data, master can opt to stop
									else if(start) begin //after receiving data, master can opt to repeat start
										start_d=1;
										state_d=starting;
									end
									else state_d=read; ///after receiving data, master can also just continue receving more data
								end
							 end
				  stop_1: if(scl_lo) begin
								sda_d=1'b0;
								state_d=stop_2;
							 end
				  stop_2: if(scl_hi) begin
								sda_d=1'b1;
								state_d=idle;
							 end
				 default: state_d=idle;
		endcase
	 end
	 
	 /*
	 //i2c output logic
	 assign scl=scl_q? 1'bz:0; //bidiectional logic for pull-up scl
	 assign sda=sda_q? 1'bz:0; //bidirectional logic for pull-up scl
	 */
	 
	 //sccb output logic
	 assign scl=scl_q? 1'b1:0; //sccb scl does not scl
	 assign sda=(state_q==read || state_q==ack_servant)? 1'bz : sda_q?1'b1:0; //sccb scl does not scl
	 
	 assign scl_hi= scl_q==1'b1 && counter_q==half && scl==1'b1; //scl is on the middle of a high(1) bit
	 assign scl_lo= scl_q==1'b0 && counter_q==half; //scl is on the middle of a low(0) bit
	 assign rd_data=rd_data_q;
	 assign state=state_q;

endmodule
