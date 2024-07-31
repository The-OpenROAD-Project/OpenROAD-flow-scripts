//module ram_blk (
//	data,
//	wren,
//	wraddress,
//	rdaddress,
//	rden,
//	clock,
//	q);
//
//	input	[7:0]  data;
//	input	  wren;
//	input	[4:0]  wraddress;
//	input	[4:0]  rdaddress;
//	input	  rden;
//	input	  clock;
//	output	[7:0]  q;
//
//	wire [7:0] sub_wire0;
//	wire [7:0] q = sub_wire0[7:0];
//
//	altsyncram	altsyncram_component (
//				.wren_a (wren),
//				.clock0 (clock),
//				.address_a (wraddress),
//				.address_b (rdaddress),
//				.rden_b (rden),
//				.data_a (data),
//				.q_b (sub_wire0));
//	defparam
//		altsyncram_component.operation_mode = "DUAL_PORT",
//		altsyncram_component.maximum_depth = 192,
//		altsyncram_component.width_a = 8,
//		altsyncram_component.widthad_a = 5,
//		altsyncram_component.numwords_a = 24,
//		altsyncram_component.width_b = 8,
//		altsyncram_component.widthad_b = 5,
//		altsyncram_component.numwords_b = 24,
//		altsyncram_component.width_byteena_a = 1,
//		altsyncram_component.outdata_reg_b = "UNREGISTERED",
//		altsyncram_component.indata_aclr_a = "NONE",
//		altsyncram_component.wrcontrol_aclr_a = "NONE",
//		altsyncram_component.address_aclr_a = "NONE",
//		altsyncram_component.address_reg_b = "CLOCK0",
//		altsyncram_component.rdcontrol_reg_b = "CLOCK0",
//		altsyncram_component.rdcontrol_aclr_b = "NONE",
//		altsyncram_component.address_aclr_b = "NONE",
//		altsyncram_component.outdata_aclr_b = "NONE",
//		altsyncram_component.read_during_write_mode_mixed_ports = "DONT_CARE",
//		altsyncram_component.ram_block_type = "AUTO",
//		altsyncram_component.intended_device_family = "Stratix";
//
//
//endmodule
//
//// ============================================================
//// CNX file retrieval info
//// ============================================================
//// Retrieval info: PRIVATE: VarWidth NUMERIC "0"
//// Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "8"
//// Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "8"
//// Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "8"
//// Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "8"
//// Retrieval info: PRIVATE: MEMSIZE NUMERIC "192"
//// Retrieval info: PRIVATE: Clock NUMERIC "0"
//// Retrieval info: PRIVATE: rden NUMERIC "1"
//// Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
//// Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
//// Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
//// Retrieval info: PRIVATE: Clock_A NUMERIC "0"
//// Retrieval info: PRIVATE: Clock_B NUMERIC "0"
//// Retrieval info: PRIVATE: REGdata NUMERIC "1"
//// Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
//// Retrieval info: PRIVATE: REGwren NUMERIC "1"
//// Retrieval info: PRIVATE: REGrdaddress NUMERIC "1"
//// Retrieval info: PRIVATE: REGrren NUMERIC "1"
//// Retrieval info: PRIVATE: REGq NUMERIC "0"
//// Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "0"
//// Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "0"
//// Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "0"
//// Retrieval info: PRIVATE: CLRdata NUMERIC "0"
//// Retrieval info: PRIVATE: CLRwren NUMERIC "0"
//// Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
//// Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
//// Retrieval info: PRIVATE: CLRrren NUMERIC "0"
//// Retrieval info: PRIVATE: CLRq NUMERIC "0"
//// Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
//// Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
//// Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
//// Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
//// Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
//// Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
//// Retrieval info: PRIVATE: enable NUMERIC "0"
//// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "2"
//// Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
//// Retrieval info: PRIVATE: MIFfilename STRING ""
//// Retrieval info: PRIVATE: UseLCs NUMERIC "0"
//// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
//// Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
//// Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "2"
//// Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
//// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix"
//// Retrieval info: CONSTANT: OPERATION_MODE STRING "DUAL_PORT"
//// Retrieval info: CONSTANT: MAXIMUM_DEPTH NUMERIC "192"
//// Retrieval info: CONSTANT: WIDTH_A NUMERIC "8"
//// Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "5"
//// Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "24"
//// Retrieval info: CONSTANT: WIDTH_B NUMERIC "8"
//// Retrieval info: CONSTANT: WIDTHAD_B NUMERIC "5"
//// Retrieval info: CONSTANT: NUMWORDS_B NUMERIC "24"
//// Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
//// Retrieval info: CONSTANT: OUTDATA_REG_B STRING "UNREGISTERED"
//// Retrieval info: CONSTANT: INDATA_ACLR_A STRING "NONE"
//// Retrieval info: CONSTANT: WRCONTROL_ACLR_A STRING "NONE"
//// Retrieval info: CONSTANT: ADDRESS_ACLR_A STRING "NONE"
//// Retrieval info: CONSTANT: ADDRESS_REG_B STRING "CLOCK0"
//// Retrieval info: CONSTANT: RDCONTROL_REG_B STRING "CLOCK0"
//// Retrieval info: CONSTANT: RDCONTROL_ACLR_B STRING "NONE"
//// Retrieval info: CONSTANT: ADDRESS_ACLR_B STRING "NONE"
//// Retrieval info: CONSTANT: OUTDATA_ACLR_B STRING "NONE"
//// Retrieval info: CONSTANT: READ_DURING_WRITE_MODE_MIXED_PORTS STRING "DONT_CARE"
//// Retrieval info: CONSTANT: RAM_BLOCK_TYPE STRING "AUTO"
//// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix"
//// Retrieval info: USED_PORT: data 0 0 8 0 INPUT NODEFVAL data[7..0]
//// Retrieval info: USED_PORT: wren 0 0 0 0 INPUT VCC wren
//// Retrieval info: USED_PORT: q 0 0 8 0 OUTPUT NODEFVAL q[7..0]
//// Retrieval info: USED_PORT: wraddress 0 0 5 0 INPUT NODEFVAL wraddress[4..0]
//// Retrieval info: USED_PORT: rdaddress 0 0 5 0 INPUT NODEFVAL rdaddress[4..0]
//// Retrieval info: USED_PORT: rden 0 0 0 0 INPUT VCC rden
//// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
//// Retrieval info: CONNECT: @data_a 0 0 8 0 data 0 0 8 0
//// Retrieval info: CONNECT: @wren_a 0 0 0 0 wren 0 0 0 0
//// Retrieval info: CONNECT: q 0 0 8 0 @q_b 0 0 8 0
//// Retrieval info: CONNECT: @address_a 0 0 5 0 wraddress 0 0 5 0
//// Retrieval info: CONNECT: @address_b 0 0 5 0 rdaddress 0 0 5 0
//// Retrieval info: CONNECT: @rden_b 0 0 0 0 rden 0 0 0 0
//// Retrieval info: CONNECT: @clock0 0 0 0 0 clock 0 0 0 0
//// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
module ram_blk (
	data,
	wren,
	wraddress,
	rdaddress,
	rden,
	clock,
	q);

	input	[9:0]  data;
	input	  wren;
	input	[10:0]  wraddress;
	input	[10:0]  rdaddress;
	input	  rden;
	input	  clock;
	output	[9:0]  q;
	
	reg [9:0] RAM[1279:0];		
   reg [9:0] q;   
//在ISE中仿真时使用	
always@(posedge clock)
begin
	if(wren)
      RAM[wraddress]<=data;   		  
   if(rden)
      q<=RAM[rdaddress];
end
endmodule