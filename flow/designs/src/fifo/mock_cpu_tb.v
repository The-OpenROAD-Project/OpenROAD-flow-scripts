// fifo_oneclock_tb.v
// To run:
//
// iverilog -o fifo_oneclock_tb.vvp *.v && vvp fifo_oneclock_tb.vvp
// gtkwave dump.vcd
`timescale 1ns/1ns

module fifo_oneclock_tb;
    integer start_time;
    integer result;
    wire [31:0] rdata;
    wire wfull;
    wire rempty;
    reg [31:0] wdata;
    reg winc;
    reg wrst_n;
    reg rinc;
    reg clk;
    reg rrst_n;

    // Instantiate the fifo_oneclock module
    fifo_oneclock #(.STAGES(4)) u_fifo_oneclock (
    .rdata(rdata),
    .wfull(wfull),
    .rempty(rempty),
    .wdata(wdata),
    .winc(winc),
    .wrst_n(wrst_n),
    .rinc(rinc),
    .clk(clk),
    .clk_uncore(clk),
    .rrst_n(rrst_n)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, fifo_oneclock_tb);

        // Initialize signals
        clk = 0;
        wrst_n = 0;
        rrst_n = 0;
        winc = 0;
        wdata = 0;
        rinc = 0;
        #21

        // Apply stimulus
        wrst_n = 1;
        rrst_n = 1;
        #2 winc = 1;
        // assign 35 in hex syntax
        wdata = 32'h00050007;
        #2 winc = 0;
        // wait until rempty is false
        start_time = $time;
        // Wait until rempty is false or 100 ticks have passed
        while (rempty && $time < start_time + 100) begin
            #2;
        end
        if (rempty) begin
            $display("Timeout: rempty did not become false within 100 ticks");
        end
        rinc = 1;
        result = 12;
        if (rdata === result) begin
            $display("Test passed: rdata is %d", result);
        end else begin
            $display("Test failed: rdata is not %d, it is %d", result, rdata);
        end
        #2 rinc = 0;

        // End the simulation
        #20 $finish;
    end

    always #1 clk = ~clk;
endmodule
