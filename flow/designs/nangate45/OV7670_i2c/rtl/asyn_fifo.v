`timescale 1ns / 1ps

module asyn_fifo
	#(
		parameter DATA_WIDTH=8,
					 FIFO_DEPTH_WIDTH=11  //total depth will then be 2**FIFO_DEPTH_WIDTH
	)
	(
	input wire rst_n,
	input wire clk_write,clk_read, //clock input from both domains
	input wire write,read, 
	input wire [DATA_WIDTH-1:0] data_write, //input FROM write clock domain
	output wire [DATA_WIDTH-1:0] data_read, //output TO read clock domain
	output reg full,empty, //full=sync to write domain clk , empty=sync to read domain clk
	output reg[FIFO_DEPTH_WIDTH-1:0] data_count_w,data_count_r //counts number of data left in fifo memory(sync to either write or read clk)
    );
	 
	 
	 /*
	 async_fifo #(.DATA_WIDTH(16),.FIFO_DEPTH_WIDTH(10)) m2 //1024x16 FIFO mem
	(
		.rst_n(rst_n),
		.clk_write(),
		.clk_read(), //clock input from both domains
		.write(),
		.read(), 
		.data_write(), //input FROM write clock domain
		.data_read(), //output TO read clock domain
		.full(),
		.empty(), //full=sync to write domain clk , empty=sync to read domain clk
		..data_count_w(),
		.data_count_r() //counts number of data left in fifo memory(sync to either write or read clk)
    );
	 */
	 
	 
	 localparam FIFO_DEPTH=2**FIFO_DEPTH_WIDTH;
	 
	 initial begin
		full=0;
		empty=1;
	 end
	 
	 
	 ///////////////////WRITE CLOCK DOMAIN//////////////////////////////
	 reg[FIFO_DEPTH_WIDTH:0] w_ptr_q=0; //binary counter for write pointer
	 reg[FIFO_DEPTH_WIDTH:0] r_ptr_sync; //binary pointer for read pointer sync to write clk
	 wire[FIFO_DEPTH_WIDTH:0] w_grey,w_grey_nxt; //grey counter for write pointer
	 reg[FIFO_DEPTH_WIDTH:0] r_grey_sync; //grey counter for the read pointer synchronized to write clock
	 
	 wire we;
	 reg[3:0] i; //log_2(FIFO_DEPTH_WIDTH)
	 
	 assign w_grey=w_ptr_q^(w_ptr_q>>1); //binary to grey code conversion for current write pointer
	 assign w_grey_nxt=(w_ptr_q+1'b1)^((w_ptr_q+1'b1)>>1);  //next grey code
	 assign we= write && !full; 
	 
	 //register operation
	 always @(posedge clk_write,negedge rst_n) begin
		if(!rst_n) begin
			w_ptr_q<=0;
			full<=0;
		end
		else begin
			if(write && !full) begin //write condition
				w_ptr_q<=w_ptr_q+1'b1; 
				full <= w_grey_nxt == {~r_grey_sync[FIFO_DEPTH_WIDTH:FIFO_DEPTH_WIDTH-1],r_grey_sync[FIFO_DEPTH_WIDTH-2:0]}; //algorithm for full logic which can be observed on the grey code table
			end
			else full <= w_grey == {~r_grey_sync[FIFO_DEPTH_WIDTH:FIFO_DEPTH_WIDTH-1],r_grey_sync[FIFO_DEPTH_WIDTH-2:0]}; 
			
			for(i=0;i<=FIFO_DEPTH_WIDTH;i=i+1) r_ptr_sync[i]=^(r_grey_sync>>i); //grey code to binary converter 
			data_count_w <= (w_ptr_q>=r_ptr_sync)? (w_ptr_q-r_ptr_sync):(FIFO_DEPTH-r_ptr_sync+w_ptr_q); //compares write pointer and sync read pointer to generate data_count
		end							
	 end

	/////////////////////////////////////////////////////////////////////
	 
	 
	  ///////////////////READ CLOCK DOMAIN//////////////////////////////
	 reg[FIFO_DEPTH_WIDTH:0] r_ptr_q=0; //binary counter for read pointer
	 wire[FIFO_DEPTH_WIDTH:0] r_ptr_d;
	 reg[FIFO_DEPTH_WIDTH:0] w_ptr_sync; //binary counter for write pointer sync to read clk
	 reg[FIFO_DEPTH_WIDTH:0] w_grey_sync; //grey counter for the write pointer synchronized to read clock
	 wire[FIFO_DEPTH_WIDTH:0] r_grey,r_grey_nxt; //grey counter for read pointer 
	 
	 
	 assign r_grey= r_ptr_q^(r_ptr_q>>1);  //binary to grey code conversion
	 assign r_grey_nxt= (r_ptr_q+1'b1)^((r_ptr_q+1'b1)>>1); //next grey code
	 assign r_ptr_d= (read && !empty)? r_ptr_q+1'b1:r_ptr_q;
	 
	 //register operation
	 always @(posedge clk_read,negedge rst_n) begin
		if(!rst_n) begin
			r_ptr_q<=0;
			empty<=1;
		end
		else begin
			r_ptr_q<=r_ptr_d;
			if(read && !empty) empty <= r_grey_nxt==w_grey_sync;//empty condition
			else empty <= r_grey==w_grey_sync; 
			
			for(i=0;i<=FIFO_DEPTH_WIDTH;i=i+1) w_ptr_sync[i]=^(w_grey_sync>>i); //grey code to binary converter
			data_count_r = (w_ptr_q>=r_ptr_sync)? (w_ptr_q-r_ptr_sync):(FIFO_DEPTH-r_ptr_sync+w_ptr_q); //compares read pointer to sync write pointer to generate data_count
		end
	 end
	 ////////////////////////////////////////////////////////////////////////
	 
	 
	 /////////////////////CLOCK DOMAIN CROSSING//////////////////////////////
	 reg[FIFO_DEPTH_WIDTH:0] r_grey_sync_temp;
	 reg[FIFO_DEPTH_WIDTH:0] w_grey_sync_temp;
	 always @(posedge clk_write) begin //2 D-Flipflops for reduced metastability in clock domain crossing from READ DOMAIN to WRITE DOMAIN
		r_grey_sync_temp<=r_grey; 
		r_grey_sync<=r_grey_sync_temp;
	 end
	 always @(posedge clk_read) begin //2 D-Flipflops for reduced metastability in clock domain crossing from WRITE DOMAIN to READ DOMAIN
		w_grey_sync_temp<=w_grey;
		w_grey_sync<=w_grey_sync_temp;
	 end
	 
	//////////////////////////////////////////////////////////////////////////
	 
	 
	 
	//instantiation of dual port block ram
	dual_port_sync #(.ADDR_WIDTH(FIFO_DEPTH_WIDTH) , .DATA_WIDTH(DATA_WIDTH)) m0
	(
		.clk_r(clk_read),
		.clk_w(clk_write),
		.we(we),
		.din(data_write),
		.addr_a(w_ptr_q[FIFO_DEPTH_WIDTH-1:0]), //write address
		.addr_b(r_ptr_d[FIFO_DEPTH_WIDTH-1:0] ), //read address ,addr_b is already buffered inside this module so we will use the "_d" ptr to advance the data(not "_q")
		.dout(data_read)
	);

endmodule



	//inference template for dual port block ram
module dual_port_sync
	#(
		parameter ADDR_WIDTH=11, //2k by 8 dual port synchronous ram(16k block ram)
					 DATA_WIDTH=8
	)
	(
		input clk_r,
		input clk_w,
		input we, 
		input[DATA_WIDTH-1:0] din,
		input[ADDR_WIDTH-1:0] addr_a,addr_b, //addr_a for write, addr_b for read
		output[DATA_WIDTH-1:0] dout
	);
	
	reg[DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	reg[ADDR_WIDTH-1:0] addr_b_q;
	
	always @(posedge clk_w) begin
		if(we) ram[addr_a]<=din;
	end
	always @(posedge clk_r) begin
		addr_b_q<=addr_b;	
	end
	assign dout=ram[addr_b_q];
	
endmodule

	
	
