module fifo (
    output [31:0] rdata,
    output wfull,
    output rempty,
    input [31:0] wdata,
    input winc, wclk, wrst_n,
    input rinc, rclk, rrst_n
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
        .wclk(wclk),
        .wrst_n(wrst_n),
        .rinc(rinc),
        .rclk(rclk),
        .rrst_n(rrst_n)
    );
endmodule
