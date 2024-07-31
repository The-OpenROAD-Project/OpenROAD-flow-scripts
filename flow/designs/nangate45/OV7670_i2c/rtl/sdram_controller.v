`timescale 1ns / 1ps

module sdram_controller(
	//fpga to controller
	input wire clk,rst_n,  //clk=165MHz
	input wire rw, // 1:read , 0:write
	input wire rw_en, //must be asserted before read/write
	input wire[14:0] f_addr, //14:2=row(13)  , 1:0=bank(2) , no need for column address since full page mode will always start from zero and end with 512 words
	input wire [15:0] f2s_data, //fpga-to-sdram data , write data burst will start at assertion of f2s_data_valid
	output wire[15:0] s2f_data, //sdram to fpga data
	output wire s2f_data_valid, //asserts while  burst-reading(data is available at output UNTIL the next rising edge)
	output reg f2s_data_valid, //asserts while burst-writing(data must be available at input BEFORE the next rising edge)
	output reg ready, //"1" if sdram is available for nxt read/write operation
	
	//controller to sdram
	output wire s_clk,
	output wire s_cke, //always high for almost all operations(except for self-refresh w/c I did not use here)
	output wire s_cs_n, s_ras_n, s_cas_n, s_we_n, //commands
	output wire[12:0] s_addr, //row/colum address bus
	output wire[1:0] s_ba, //bank address bus
	output wire LDQM , HDQM, //low-byte and high-byte mask (always zero:disabled)
	inout[15:0] s_dq //sdram inout/output data	
    );	
	 
	 /*
	 sdram_controller m1(
		//fpga to controller
		.clk(CLK_OUT), //clk=165MHz
		.rst_n(rst_n),  
		.rw(rw), // 1:read , 0:write
		.rw_en(rw_en), //must be asserted before read/write
		.f_addr(f_addr_q), //14:2=row(13)  , 1:0=bank(2) , no need for column address since full page mode will always start from zero and end with 512 words
		.f2s_data(f2s_data_q), //fpga-to-sdram data , write data burst will start at assertion of f2s_data_valid
		.s2f_data(s2f_data), //sdram to fpga data
		.s2f_data_valid(s2f_data_valid),  //asserts while  burst-reading(data is available at output UNTIL the next rising edge)
		.f2s_data_valid(f2s_data_valid), //asserts while burst-writing(data must be available at input BEFORE the next rising edge)
		.ready(ready), //"1" if sdram is available for nxt read/write operation
		//controller to sdram
		.s_clk(sdram_clk),
		.s_cke(sdram_cke), 
		.s_cs_n(sdram_cs_n),
		.s_ras_n(sdram_ras_n ), 
		.s_cas_n(sdram_cas_n),
		.s_we_n(sdram_we_n), 
		.s_addr(sdram_addr), 
		.s_ba(sdram_ba), 
		.LDQM(sdram_dqm[0]),
		.HDQM(sdram_dqm[1]),
		.s_dq(sdram_dq) 
    );
	 */
	 
	 //s_clock(clk input to sdram) is 180 degrees lagging from main clock to solve the hold-setup time requirements of sdram
	 ODDR2#(.DDR_ALIGNMENT("NONE"), .INIT(1'b0),.SRTYPE("SYNC")) oddr2_primitive
	 (
		.D0(1'b0), //1'b0
		.D1(1'b1 ), //1'b1
		.C0(clk),
		.C1(~clk),
		.CE(1'b1),
		.R(1'b0),
		.S(1'b0),
		.Q(s_clk)
	);
	//FSM states		//initialize
	 localparam[3:0]  start=0,
							precharge_init=1, 
							refresh_1=2,
							refresh_2=3,
							load_mode_reg=4,
							//normal operation
							idle=5,
							read=6,
							read_data=7,
							write=8,
							write_burst=9,
							//refresh every 7.81us
							refresh=10,
		
							delay=11; //waiting state for any amount of delay needed
							
	//minimum time specs needed(in clks for 165MHz(6ns))
	localparam[3:0] t_RP=2, //15ns(precharge) 
					t_RC=7, //60ns(active to active,ref to ref)
					t_MRD=2, //2 clk,(mode register) /2/
					t_RCD=2, //15ns (active to read/write)
					t_WR=2, //2clk delay after writing before manual/auto precharge can start
					t_CL=3; //CAS latency(delay of data_out after read command)
					
	//commands {cs_n,ras_n,cas_n,we_n} REFER TO THE DATASHEET: winbond W9825G6KH
	localparam[3:0]  cmd_precharge=4'b0010,
						  cmd_NOP=4'b1111,
						  cmd_activate=4'b0011,
						  cmd_write=4'b0100,
						  cmd_read=4'b0101,
						  cmd_setmode=4'b0000,
						  cmd_refresh=4'b0001;
						  
	reg[3:0] state_q,state_d; //_q is registered output, _d is input to DFF
	reg[3:0] nxt_q,nxt_d; //state after next state
	reg[3:0] cmd_q,cmd_d; //{cs_n,ras_n,cas_n,we_n}
	reg[15:0] delay_ctr_q,delay_ctr_d; //stores delay needed(max is 200us for the initialization sequence)
	reg[10:0] refresh_ctr_q=0,refresh_ctr_d; 
	reg refresh_flag_q,refresh_flag_d;
	reg[9:0] burst_index_q=0,burst_index_d; //stores the data left to be burst(512 for full page burst)
	reg rw_d,rw_q,rw_en_q,rw_en_d;
	
	//buffer for output for a glitch-free signal
	reg[12:0] s_addr_q,s_addr_d;
	reg[1:0] s_ba_q,s_ba_d;
	reg[15:0] s_dq_q,s_dq_d;
	reg tri_q,tri_d;
	
	//buffer for input
	reg[14:0] f_addr_q,f_addr_d;
	reg[15:0] f2s_data_q,f2s_data_d;
	reg[15:0] s2f_data_q,s2f_data_d;
	reg s2f_data_valid_q,s2f_data_valid_d;


	
	
	//register operation
	always @(posedge clk,negedge rst_n) begin
		if(!rst_n) begin
			state_q<=start;
			nxt_q<=start;
			cmd_q<=cmd_NOP;
			delay_ctr_q<=0;
			refresh_ctr_q<=0;
			s_addr_q<=0;
			tri_q<=0;
			rw_q<=0;
			rw_en_q<=0;
			
			s_ba_q<=0;
			s_dq_q<=0;
			f_addr_q<=0;
			rw_q<=0;
			f2s_data_q<=0;
			s2f_data_q<=0;
			s2f_data_valid_q<=0;
			rw_q<=0;
			refresh_flag_q<=0;
			burst_index_q<=0;
		end
		else begin
			state_q<=state_d;
			nxt_q<=nxt_d;
			cmd_q<=cmd_d;
			delay_ctr_q<=delay_ctr_d;
			refresh_ctr_q<=refresh_ctr_d;
			s_addr_q<=s_addr_d;
			tri_q<=tri_d;
			refresh_flag_q<=refresh_flag_d;
			burst_index_q<=burst_index_d;
			
			s_ba_q<=s_ba_d;
			s_dq_q<=s_dq_d;
			f_addr_q<=f_addr_d;
			rw_q<=rw_d;
			f2s_data_q<=f2s_data_d;
			s2f_data_q<=s2f_data_d;
			s2f_data_valid_q<=s2f_data_valid_d;
			rw_q<=rw_d;
			rw_en_q<=rw_en_d;
		end
	end
	

	//next-state logics
	always @* begin
		state_d=state_q;
		nxt_d=nxt_q;
		cmd_d=cmd_NOP; //always default to No Operation 
		delay_ctr_d=delay_ctr_q;
		ready=0; 
		s_addr_d=s_addr_q;
		s_ba_d=s_ba_q;
		s_dq_d=s_dq_q;
		f_addr_d=f_addr_q;
		rw_d=rw_q;
		f2s_data_d=f2s_data_q;
		s2f_data_d=s2f_data_q;
		tri_d=0;  
		s2f_data_valid_d=1'b0;
		f2s_data_valid=1'b0;
		burst_index_d=burst_index_q;
		rw_d=rw_q;
		rw_en_d=rw_en_q;
		
		//refresh every 7.8us or else data will be lost. 
		refresh_flag_d=refresh_flag_q;
		refresh_ctr_d=refresh_ctr_q+1'b1;
		if(refresh_ctr_q==770) begin //7.7 us
			refresh_ctr_d=0;
			refresh_flag_d=1;
		end
		
		
		
		case(state_q)
					////////////////BEGIN:INITIALIZE////////////////
			delay: begin //wait here for a delay specified by delay_ctr_q(parameter in time specs)
						delay_ctr_d=delay_ctr_q-1'b1;
						if(delay_ctr_d==0) state_d=nxt_q;	
						if(nxt_q==write) tri_d=1;
					 end
			start: begin //initiliaze after power-up
						state_d=delay;
						nxt_d=precharge_init;
						delay_ctr_d=16'd33_000; //wait for 200us
						s_addr_d=0;
						s_ba_d=0;
					 end
precharge_init: begin //precharge ALL banks (A10 must be high)
						state_d=delay;
						nxt_d=refresh_1;
						delay_ctr_d=t_RP-1;
						cmd_d=cmd_precharge;
						s_addr_d[10]=1'b1;
					 end
		refresh_1: begin
						state_d=delay;
						nxt_d=refresh_2;
						delay_ctr_d=t_RC-1;
						cmd_d=cmd_refresh;
					  end
		refresh_2: begin
						state_d=delay;
						nxt_d=load_mode_reg;
						delay_ctr_d=t_RC-1;
						cmd_d=cmd_refresh;
					  end
  load_mode_reg: begin
						state_d=delay;
						nxt_d=idle;
						delay_ctr_d=t_MRD-1;
						cmd_d=cmd_setmode;
						s_addr_d=13'b 000_0_00_011_0_111; //{reserved,writemode,reserved,CL,AddressingMode,BurstLength}
						s_ba_d=2'b00; //reserved
					  end
					 ////////////////END:INITIALIZE////////////////
					
					////////////////BEGIN:NORMAL OPERATION////////////////
		     idle: begin 
						ready=rw_en_q? 0:1;
						if(rw_en_q) begin //permission granted for r/w operation 
								state_d=delay;
								cmd_d=cmd_activate;
								delay_ctr_d=t_RCD-1;
								nxt_d=rw_q?read:write;
								burst_index_d=0;
								rw_en_d=1'b0;
								{s_addr_d,s_ba_d}=f_addr_q;//row + bank addr
						end
						else if(refresh_flag_q || rw_en) begin  //refresh every 7.7us and BEFORE start of burst read/write operations
							state_d=delay;
							nxt_d=refresh;
							delay_ctr_d=t_RP-1;
							cmd_d=cmd_precharge; //precharge all banks first before auto-refresh
							s_addr_d[10]=1'b1;
							refresh_flag_d=0;
							if(rw_en) begin 
								rw_en_d=rw_en;
								f_addr_d=f_addr; 
								rw_d=rw;
							end
						end
						
					  end 
	     refresh:	begin
						 state_d=delay;
						 nxt_d=idle;
						 delay_ctr_d=t_RC-1;
						 cmd_d=cmd_refresh;
						end					 
			read: begin 
						state_d=delay;
						delay_ctr_d=t_CL; //not subtracted by one since the sdram is "late" by half a cycle so register is one clk after the expected clock latency delay
						cmd_d=cmd_read;
						s_addr_d=0;//what column to activate(in full page mode, column starts at LEFTMOST which is zero)
						s_ba_d=f_addr_q[1:0]; //what bank to activate
						s_addr_d[10]=1'b0; //no auto-precharge for full page burst
						nxt_d=read_data;
					end
	 read_data: begin //read data after CAS latency of 3 clk
						s2f_data_d=s_dq;
						s2f_data_valid_d=1'b1;
						burst_index_d=burst_index_q+1;
						if(burst_index_q==512) begin //if all 512 burst data is already finished, precharge then go back to idle
							s2f_data_valid_d=1'b0;
							state_d=delay;
							nxt_d=idle;
							delay_ctr_d=t_RP-1;
							cmd_d=cmd_precharge;
						end
					end		
		 write: begin  
						f2s_data_d=f2s_data; //write data
						f2s_data_valid=1'b1;
						s_addr_d=0; //what column to activate(in full page mode, column starts at LEFTMOST which is zero)
						s_ba_d=f_addr_q[1:0];
						s_addr_d[10]=1'b0; //no auto-precharge for full page burst
						tri_d=1'b1; //tristate buffer on since we output/write signals
						cmd_d=cmd_write;
						state_d=write_burst;
						burst_index_d=burst_index_q+1;
				   end
  write_burst: begin    //write data burst will start at assertion of f2s_data_valid
						f2s_data_d=f2s_data; //write data
						f2s_data_valid=1'b1; 
						tri_d=1'b1; //tristate buffer on since we output/write signals
						burst_index_d=burst_index_q+1;
						
						if(burst_index_q==512) begin //if all 512 burst data is already finished, precharge then go back to idle
							tri_d=0;
							state_d=delay;
							f2s_data_valid=1'b0;
							nxt_d=idle;
							delay_ctr_d=t_RP+t_WR-1;
							cmd_d=cmd_precharge;
						end
					end
				  ////////////////END:NORMAL OPERATION////////////////
				  
		default: state_d=start;
		endcase
		
		
			
	
	end
	
	//assign the outputs to corresponding buffers
	assign s_cs_n=cmd_q[3],
			 s_ras_n=cmd_q[2],
			 s_cas_n=cmd_q[1],
			 s_we_n=cmd_q[0];
	assign s_cke=1'b1; 
	assign LDQM=1'b0, 
			 HDQM=1'b0;
	assign s_addr=s_addr_q;
	assign s_ba=s_ba_q;
   assign s_dq=tri_q? f2s_data_q:16'hzzzz; //tri-state output,tri=1 for write , tri=0 for read(hi-Z)
	assign s2f_data=s2f_data_q;
	assign s2f_data_valid=s2f_data_valid_q;
					
	
endmodule
