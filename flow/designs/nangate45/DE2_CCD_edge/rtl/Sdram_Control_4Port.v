module Sdram_Control_4Port(
		//	HOST Side
        REF_CLK,
        RESET_N,
		//	FIFO Write Side 1
        WR1_DATA,
		WR1,
		WR1_ADDR,
		WR1_MAX_ADDR,
		WR1_LENGTH,
		WR1_LOAD,
		WR1_CLK,
		WR1_FULL,
		WR1_USE,
		//	FIFO Write Side 2
        WR2_DATA,
		WR2,
		WR2_ADDR,
		WR2_MAX_ADDR,
		WR2_LENGTH,
		WR2_LOAD,
		WR2_CLK,
		WR2_FULL,
		WR2_USE,
		//	FIFO Read Side 1
        RD1_DATA,
		RD1,
		RD1_ADDR,
		RD1_MAX_ADDR,
		RD1_LENGTH,
		RD1_LOAD,	
		RD1_CLK,
		RD1_EMPTY,
		RD1_USE,
		//	FIFO Read Side 2
        RD2_DATA,
		RD2,
		RD2_ADDR,
		RD2_MAX_ADDR,
		RD2_LENGTH,
		RD2_LOAD,
		RD2_CLK,
		RD2_EMPTY,
		RD2_USE,
		//	SDRAM Side
        SA,
        BA,
        CS_N,
        CKE,
        RAS_N,
        CAS_N,
        WE_N,
        DQ,
        DQM,
		SDR_CLK
        );


`include        "Sdram_Params.h"
//	HOST Side
input                           REF_CLK;                //System Clock
input                           RESET_N;                //System Reset
//	FIFO Write Side 1
input   [`DSIZE-1:0]            WR1_DATA;               //Data input
input							WR1;					//Write Request
input	[`ASIZE-1:0]			WR1_ADDR;				//Write start address
input	[`ASIZE-1:0]			WR1_MAX_ADDR;			//Write max address
input	[8:0]					WR1_LENGTH;				//Write length
input							WR1_LOAD;				//Write register load & fifo clear
input							WR1_CLK;				//Write fifo clock
output							WR1_FULL;				//Write fifo full
output	[8:0]					WR1_USE;				//Write fifo usedw
//	FIFO Write Side 2
input   [`DSIZE-1:0]            WR2_DATA;               //Data input
input							WR2;					//Write Request
input	[`ASIZE-1:0]			WR2_ADDR;				//Write start address
input	[`ASIZE-1:0]			WR2_MAX_ADDR;			//Write max address
input	[8:0]					WR2_LENGTH;				//Write length
input							WR2_LOAD;				//Write register load & fifo clear
input							WR2_CLK;				//Write fifo clock
output							WR2_FULL;				//Write fifo full
output	[8:0]					WR2_USE;				//Write fifo usedw
//	FIFO Read Side 1
output  [`DSIZE-1:0]            RD1_DATA;               //Data output
input							RD1;					//Read Request
input	[`ASIZE-1:0]			RD1_ADDR;				//Read start address
input	[`ASIZE-1:0]			RD1_MAX_ADDR;			//Read max address
input	[8:0]					RD1_LENGTH;				//Read length
input							RD1_LOAD;				//Read register load & fifo clear
input							RD1_CLK;				//Read fifo clock
output							RD1_EMPTY;				//Read fifo empty
output	[8:0]					RD1_USE;				//Read fifo usedw
//	FIFO Read Side 2
output  [`DSIZE-1:0]            RD2_DATA;               //Data output
input							RD2;					//Read Request
input	[`ASIZE-1:0]			RD2_ADDR;				//Read start address
input	[`ASIZE-1:0]			RD2_MAX_ADDR;			//Read max address
input	[8:0]					RD2_LENGTH;				//Read length
input							RD2_LOAD;				//Read register load & fifo clear
input							RD2_CLK;				//Read fifo clock
output							RD2_EMPTY;				//Read fifo empty
output	[8:0]					RD2_USE;				//Read fifo usedw
//	SDRAM Side
output  [11:0]                  SA;                     //SDRAM address output
output  [1:0]                   BA;                     //SDRAM bank address
output  [1:0]                   CS_N;                   //SDRAM Chip Selects
output                          CKE;                    //SDRAM clock enable
output                          RAS_N;                  //SDRAM Row address Strobe
output                          CAS_N;                  //SDRAM Column address Strobe
output                          WE_N;                   //SDRAM write enable
inout   [`DSIZE-1:0]            DQ;                     //SDRAM data bus
output  [`DSIZE/8-1:0]          DQM;                    //SDRAM data mask lines
output							SDR_CLK;				//SDRAM clock
//	Internal Registers/Wires
//	Controller
reg		[`ASIZE-1:0]			mADDR;					//Internal address
reg		[8:0]					mLENGTH;				//Internal length
reg		[`ASIZE-1:0]			rWR1_ADDR;				//Register write address				
reg		[`ASIZE-1:0]			rWR1_MAX_ADDR;			//Register max write address				
reg		[8:0]					rWR1_LENGTH;			//Register write length
reg		[`ASIZE-1:0]			rWR2_ADDR;				//Register write address				
reg		[`ASIZE-1:0]			rWR2_MAX_ADDR;			//Register max write address				
reg		[8:0]					rWR2_LENGTH;			//Register write length
reg		[`ASIZE-1:0]			rRD1_ADDR;				//Register read address
reg		[`ASIZE-1:0]			rRD1_MAX_ADDR;			//Register max read address
reg		[8:0]					rRD1_LENGTH;			//Register read length
reg		[`ASIZE-1:0]			rRD2_ADDR;				//Register read address
reg		[`ASIZE-1:0]			rRD2_MAX_ADDR;			//Register max read address
reg		[8:0]					rRD2_LENGTH;			//Register read length
reg		[1:0]					WR_MASK;				//Write port active mask
reg		[1:0]					RD_MASK;				//Read port active mask
reg								mWR_DONE;				//Flag write done, 1 pulse SDR_CLK
reg								mRD_DONE;				//Flag read done, 1 pulse SDR_CLK
reg								mWR,Pre_WR;				//Internal WR edge capture
reg								mRD,Pre_RD;				//Internal RD edge capture
reg 	[9:0] 					ST;						//Controller status
reg		[1:0] 					CMD;					//Controller command
reg								PM_STOP;				//Flag page mode stop
reg								PM_DONE;				//Flag page mode done
reg								Read;					//Flag read active
reg								Write;					//Flag write active
reg	    [`DSIZE-1:0]           	mDATAOUT;               //Controller Data output
wire    [`DSIZE-1:0]           	mDATAIN;                //Controller Data input
wire    [`DSIZE-1:0]           	mDATAIN1;                //Controller Data input 1
wire    [`DSIZE-1:0]           	mDATAIN2;                //Controller Data input 2
wire                          	CMDACK;                 //Controller command acknowledgement
//	DRAM Control
reg  	[`DSIZE/8-1:0]          DQM;                    //SDRAM data mask lines
reg     [11:0]                  SA;                     //SDRAM address output
reg     [1:0]                   BA;                     //SDRAM bank address
reg     [1:0]                   CS_N;                   //SDRAM Chip Selects
reg                             CKE;                    //SDRAM clock enable
reg                             RAS_N;                  //SDRAM Row address Strobe
reg                             CAS_N;                  //SDRAM Column address Strobe
reg                             WE_N;                   //SDRAM write enable
wire    [`DSIZE-1:0]            DQOUT;					//SDRAM data out link
wire  	[`DSIZE/8-1:0]          IDQM;                   //SDRAM data mask lines
wire    [11:0]                  ISA;                    //SDRAM address output
wire    [1:0]                   IBA;                    //SDRAM bank address
wire    [1:0]                   ICS_N;                  //SDRAM Chip Selects
wire                            ICKE;                   //SDRAM clock enable
wire                            IRAS_N;                 //SDRAM Row address Strobe
wire                            ICAS_N;                 //SDRAM Column address Strobe
wire                            IWE_N;                  //SDRAM write enable
//	FIFO Control
reg								OUT_VALID;				//Output data request to read side fifo
reg								IN_REQ;					//Input	data request to write side fifo
wire	[8:0]					write_side_fifo_rusedw1;
wire	[8:0]					read_side_fifo_wusedw1;
wire	[8:0]					write_side_fifo_rusedw2;
wire	[8:0]					read_side_fifo_wusedw2;
//	DRAM Internal Control
wire    [`ASIZE-1:0]            saddr;
wire                            load_mode;
wire                            nop;
wire                            reada;
wire                            writea;
wire                            refresh;
wire                            precharge;
wire                            oe;
wire							ref_ack;
wire							ref_req;
wire							init_req;
wire							cm_ack;
wire							active;
wire                            CLK;


Sdram_PLL sdram_pll1	(
				.inclk0(REF_CLK),
				.c0(CLK),
				.c1(SDR_CLK)
				);

control_interface control1 (
                .CLK(CLK),
                .RESET_N(RESET_N),
                .CMD(CMD),
                .ADDR(mADDR),
                .REF_ACK(ref_ack),
                .CM_ACK(cm_ack),
                .NOP(nop),
                .READA(reada),
                .WRITEA(writea),
                .REFRESH(refresh),
                .PRECHARGE(precharge),
                .LOAD_MODE(load_mode),
                .SADDR(saddr),
                .REF_REQ(ref_req),
				.INIT_REQ(init_req),
                .CMD_ACK(CMDACK)
                );

command command1(
                .CLK(CLK),
                .RESET_N(RESET_N),
                .SADDR(saddr),
                .NOP(nop),
                .READA(reada),
                .WRITEA(writea),
                .REFRESH(refresh),
				.LOAD_MODE(load_mode),
                .PRECHARGE(precharge),
                .REF_REQ(ref_req),
				.INIT_REQ(init_req),
                .REF_ACK(ref_ack),
                .CM_ACK(cm_ack),
                .OE(oe),
				.PM_STOP(PM_STOP),
				.PM_DONE(PM_DONE),
                .SA(ISA),
                .BA(IBA),
                .CS_N(ICS_N),
                .CKE(ICKE),
                .RAS_N(IRAS_N),
                .CAS_N(ICAS_N),
                .WE_N(IWE_N)
                );
                
sdr_data_path data_path1(
                .CLK(CLK),
                .RESET_N(RESET_N),
                .DATAIN(mDATAIN),
                .DM(2'b00),
                .DQOUT(DQOUT),
                .DQM(IDQM)
                );

Sdram_FIFO 	write_fifo1(
				.data(WR1_DATA),
				.wrreq(WR1),
				.wrclk(WR1_CLK),
				.aclr(WR1_LOAD),
				.rdreq(IN_REQ&WR_MASK[0]),
				.rdclk(CLK),
				.q(mDATAIN1),
				.wrfull(WR1_FULL),
				.wrusedw(WR1_USE),
				.rdusedw(write_side_fifo_rusedw1)
				);

Sdram_FIFO 	write_fifo2(
				.data(WR2_DATA),
				.wrreq(WR2),
				.wrclk(WR2_CLK),
				.aclr(WR2_LOAD),
				.rdreq(IN_REQ&WR_MASK[1]),
				.rdclk(CLK),
				.q(mDATAIN2),
				.wrfull(WR2_FULL),
				.wrusedw(WR2_USE),
				.rdusedw(write_side_fifo_rusedw2)
				);
				
assign	mDATAIN	=	(WR_MASK[0])	?	mDATAIN1	:
										mDATAIN2	;

Sdram_FIFO 	read_fifo1(
				.data(mDATAOUT),
				.wrreq(OUT_VALID&RD_MASK[0]),
				.wrclk(CLK),
				.aclr(RD1_LOAD),
				.rdreq(RD1),
				.rdclk(RD1_CLK),
				.q(RD1_DATA),
				.wrusedw(read_side_fifo_wusedw1),
				.rdempty(RD1_EMPTY),
				.rdusedw(RD1_USE)
				);
				
Sdram_FIFO 	read_fifo2(
				.data(mDATAOUT),
				.wrreq(OUT_VALID&RD_MASK[1]),
				.wrclk(CLK),
				.aclr(RD2_LOAD),
				.rdreq(RD2),
				.rdclk(RD2_CLK),
				.q(RD2_DATA),
				.wrusedw(read_side_fifo_wusedw2),
				.rdempty(RD2_EMPTY),
				.rdusedw(RD2_USE)
				);

always @(posedge CLK)
begin
	SA      <= (ST==SC_CL+mLENGTH)			?	12'h200	:	ISA;
    BA      <= IBA;
    CS_N    <= ICS_N;
    CKE     <= ICKE;
    RAS_N   <= (ST==SC_CL+mLENGTH)			?	1'b0	:	IRAS_N;
    CAS_N   <= (ST==SC_CL+mLENGTH)			?	1'b1	:	ICAS_N;
    WE_N    <= (ST==SC_CL+mLENGTH)			?	1'b0	:	IWE_N;
	PM_STOP	<= (ST==SC_CL+mLENGTH)			?	1'b1	:	1'b0;
	PM_DONE	<= (ST==SC_CL+SC_RCD+mLENGTH+2)	?	1'b1	:	1'b0;
	DQM		<= ( active && (ST>=SC_CL) )	?	(	((ST==SC_CL+mLENGTH) && Write)?	2'b11	:	2'b00	)	:	2'b11	;
	mDATAOUT<= DQ;
end

assign  DQ = oe ? DQOUT : `DSIZE'hzzzz;
assign	active	=	Read | Write;

always@(posedge CLK or negedge RESET_N)
begin
	if(RESET_N==0)
	begin
		CMD			<=  0;
		ST			<=  0;
		Pre_RD		<=  0;
		Pre_WR		<=  0;
		Read		<=	0;
		Write		<=	0;
		OUT_VALID	<=	0;
		IN_REQ		<=	0;
		mWR_DONE	<=	0;
		mRD_DONE	<=	0;
	end
	else
	begin
		Pre_RD	<=	mRD;
		Pre_WR	<=	mWR;
		case(ST)
		0:	begin
				if({Pre_RD,mRD}==2'b01)
				begin
					Read	<=	1;
					Write	<=	0;
					CMD		<=	2'b01;
					ST		<=	1;
				end
				else if({Pre_WR,mWR}==2'b01)
				begin
					Read	<=	0;
					Write	<=	1;
					CMD		<=	2'b10;
					ST		<=	1;
				end
			end
		1:	begin
				if(CMDACK==1)
				begin
					CMD<=2'b00;
					ST<=2;
				end
			end
		default:	
			begin	
				if(ST!=SC_CL+SC_RCD+mLENGTH+1)
				ST<=ST+1;
				else
				ST<=0;
			end
		endcase
	
		if(Read)
		begin
			if(ST==SC_CL+SC_RCD+1)
			OUT_VALID	<=	1;
			else if(ST==SC_CL+SC_RCD+mLENGTH+1)
			begin
				OUT_VALID	<=	0;
				Read		<=	0;
				mRD_DONE	<=	1;
			end
		end
		else
		mRD_DONE	<=	0;
		
		if(Write)
		begin
			if(ST==SC_CL-1)
			IN_REQ	<=	1;
			else if(ST==SC_CL+mLENGTH-1)
			IN_REQ	<=	0;
			else if(ST==SC_CL+SC_RCD+mLENGTH)
			begin
				Write	<=	0;
				mWR_DONE<=	1;
			end
		end
		else
		mWR_DONE<=	0;

	end
end
//	Internal Address & Length Control
always@(posedge CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		rWR1_ADDR		<=	0;
		rWR2_ADDR		<=	22'h100000;
		rRD1_ADDR		<=	640*16;
		rRD2_ADDR		<=	22'h100000+640*16;
		rWR1_MAX_ADDR	<=	640*512;
		rWR2_MAX_ADDR	<=	22'h100000+640*512;
		rRD1_MAX_ADDR	<=	640*496;
		rRD2_MAX_ADDR	<=	22'h100000+640*496;
		rWR1_LENGTH		<=	256;
		rWR2_LENGTH		<=	256;
		rRD1_LENGTH		<=	256;
		rRD2_LENGTH		<=	256;
	end
	else
	begin
		//	Write Side 1
		if(WR1_LOAD)
		begin
			rWR1_ADDR	<=	WR1_ADDR;
			rWR1_LENGTH	<=	WR1_LENGTH;
		end
		else if(mWR_DONE&WR_MASK[0])
		begin
			if(rWR1_ADDR<rWR1_MAX_ADDR-rWR1_LENGTH)
			rWR1_ADDR	<=	rWR1_ADDR+rWR1_LENGTH;
			else
			rWR1_ADDR	<=	WR1_ADDR;
		end
		//	Write Side 2
		if(WR2_LOAD)
		begin
			rWR2_ADDR	<=	WR2_ADDR;
			rWR2_LENGTH	<=	WR2_LENGTH;
		end
		else if(mWR_DONE&WR_MASK[1])
		begin
			if(rWR2_ADDR<rWR2_MAX_ADDR-rWR2_LENGTH)
			rWR2_ADDR	<=	rWR2_ADDR+rWR2_LENGTH;
			else
			rWR2_ADDR	<=	WR2_ADDR;
		end
		//	Read Side 1
		if(RD1_LOAD)
		begin
			rRD1_ADDR	<=	RD1_ADDR;
			rRD1_LENGTH	<=	RD1_LENGTH;
		end
		else if(mRD_DONE&RD_MASK[0])
		begin
			if(rRD1_ADDR<rRD1_MAX_ADDR-rRD1_LENGTH)
			rRD1_ADDR	<=	rRD1_ADDR+rRD1_LENGTH;
			else
			rRD1_ADDR	<=	RD1_ADDR;
		end
		//	Read Side 2
		if(RD2_LOAD)
		begin
			rRD2_ADDR	<=	RD2_ADDR;
			rRD2_LENGTH	<=	RD2_LENGTH;
		end
		else if(mRD_DONE&RD_MASK[1])
		begin
			if(rRD2_ADDR<rRD2_MAX_ADDR-rRD2_LENGTH)
			rRD2_ADDR	<=	rRD2_ADDR+rRD2_LENGTH;
			else
			rRD2_ADDR	<=	RD2_ADDR;
		end
	end
end
//	Auto Read/Write Control
always@(posedge CLK or negedge RESET_N)
begin
	if(!RESET_N)
	begin
		mWR		<=	0;
		mRD		<=	0;
		mADDR	<=	0;
		mLENGTH	<=	0;
	end
	else
	begin
		if( (mWR==0) && (mRD==0) && (ST==0) &&
			(WR_MASK==0)	&&	(RD_MASK==0) &&
			(WR1_LOAD==0)	&&	(RD1_LOAD==0) &&
			(WR2_LOAD==0)	&&	(RD2_LOAD==0) )
		begin
			//	Write Side 1
			if( (write_side_fifo_rusedw1 >= rWR1_LENGTH) && (rWR1_LENGTH!=0) )
			begin
				mADDR	<=	rWR1_ADDR;
				mLENGTH	<=	rWR1_LENGTH;
				WR_MASK	<=	2'b01;
				RD_MASK	<=	2'b00;
				mWR		<=	1;
				mRD		<=	0;
			end
			//	Write Side 2
			else if( (write_side_fifo_rusedw2 >= rWR2_LENGTH) && (rWR2_LENGTH!=0) )
			begin
				mADDR	<=	rWR2_ADDR;
				mLENGTH	<=	rWR2_LENGTH;
				WR_MASK	<=	2'b10;
				RD_MASK	<=	2'b00;
				mWR		<=	1;
				mRD		<=	0;
			end
			//	Read Side 1
			else if( (read_side_fifo_wusedw1 < rRD1_LENGTH) )
			begin
				mADDR	<=	rRD1_ADDR;
				mLENGTH	<=	rRD1_LENGTH;
				WR_MASK	<=	2'b00;
				RD_MASK	<=	2'b01;
				mWR		<=	0;
				mRD		<=	1;				
			end
			//	Read Side 2
			else if( (read_side_fifo_wusedw2 < rRD2_LENGTH) )
			begin
				mADDR	<=	rRD2_ADDR;
				mLENGTH	<=	rRD2_LENGTH;
				WR_MASK	<=	2'b00;
				RD_MASK	<=	2'b10;
				mWR		<=	0;
				mRD		<=	1;
			end
		end
		if(mWR_DONE)
		begin
			WR_MASK	<=	0;
			mWR		<=	0;
		end
		if(mRD_DONE)
		begin
			RD_MASK	<=	0;
			mRD		<=	0;
		end
	end
end

endmodule
