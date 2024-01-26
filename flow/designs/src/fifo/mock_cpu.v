// a mock CPU. The inputs and outputs are disconnected from the
// outside world via FIFOs to deal with a large clock insertion
// latency of the CPU core.
//
// One input FIFO and one output FIFO are used. The input FIFOs
// upper and lower bits are multiplied with 4 pipeline stages
// and output on the output FIFO.
//
// ASIZE 3 and DSIZE 32 are used for the FIFOs.
module mock_cpu (
    output [31:0] rdata,
    output wfull,
    output rempty,
    input [31:0] wdata,
    input winc, wrst_n,
    input rinc, clk, clk_uncore, rrst_n
);
    parameter STAGES = 1024;

    reg [31:0] mult_result [0:STAGES - 1];
    reg winc_out [0:STAGES - 1];

    wire [31:0] wdata_out;
    wire [31:0] rdata_in;
    wire rinc_in, rempty_in;
    wire wfull_out;

    fifo1 #(.ASIZE(1), .DSIZE(32)) fifo_in (
        .wdata(wdata),
        .winc(winc),
        .wfull(wfull),
        .rclk(clk),
        .wclk(clk_uncore),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n),
        .rdata(rdata_in),
        .rinc(rinc_in),
        .rempty(rempty_in)
    );

    fifo1 #(.ASIZE(3), .DSIZE(32)) fifo_out (
        .wdata(mult_result[STAGES - 1]),
        .winc(winc_out[STAGES - 1]),
        .wfull(wfull_out),
        .rclk(clk_uncore),
        .wclk(clk),
        .wrst_n(wrst_n),
        .rrst_n(rrst_n),
        .rdata(rdata),
        .rinc(rinc),
        .rempty(rempty)
    );

    assign rinc_in = !rempty_in;

    generate
        genvar i;
        for (i = 0; i < STAGES; i=i+1) begin : mult_pipeline
            always @(posedge clk) begin
                if (i == 0) begin
                    mult_result[i] <= rdata_in[15:0] + rdata_in[31:16];
                    winc_out[i] <= !rempty_in;
                end else begin
                    mult_result[i] <= mult_result[i-1];
                    winc_out[i] <= winc_out[i-1];
                end
            end
        end
    endgenerate

endmodule
