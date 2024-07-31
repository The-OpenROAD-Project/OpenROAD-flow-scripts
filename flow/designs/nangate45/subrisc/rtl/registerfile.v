module RegisterFile
(
	input wire CLK,
	input wire RST_X,
	//Read port.0
	input wire[3:0] NO_R0,
	input wire EN_R0,
	output wire[31:0] RDATA_R0,
	//Read port.1
	input wire[3:0] NO_R1,
	input wire EN_R1,
	output wire[31:0] RDATA_R1,
	//Write port.0
	input wire[3:0] NO_W0,
	input wire EN_W0,
	input wire[31:0] WDATA_W0
);

reg[31:0] rfs[0:15];

///* Async logic
assign RDATA_R0 = !EN_R0 ? 32'hzzzzzzzz : /*(EN_W0 && (NO_W0 == NO_R0)) ? WDATA_W0 : */rfs[NO_R0];
assign RDATA_R1 = !EN_R1 ? 32'hzzzzzzzz : /*(EN_W0 && (NO_W0 == NO_R1)) ? WDATA_W0 : */rfs[NO_R1];
//*/
integer i;
always @(posedge CLK) begin
    /*if (!RST_X) begin
        for (i=0;i<16;i=i+1)
            rfs[i] <= 32'b0;
    end else
	*/
	if (EN_W0) begin
		rfs[NO_W0] <= WDATA_W0;
	end
end

endmodule