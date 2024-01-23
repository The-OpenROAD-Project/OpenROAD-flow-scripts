module fifo_oneclock (
    output [31:0] rdata,
    output wfull,
    output rempty,
    input [31:0] wdata,
    input winc, clk, wrst_n,
    input rinc, clk, rrst_n
);

    fifo1 #(
        .DSIZE(32),
        .ASIZE(5)
    ) fifo_instance (
        .rdata(rdata),
        .wfull(wfull),
        .rempty(rempty),
        .wdata(wdata),
        .winc(winc),
        .wclk(clk),
        .wrst_n(wrst_n),
        .rinc(rinc),
        .rclk(clk),
        .rrst_n(rrst_n)
    );
endmodule
