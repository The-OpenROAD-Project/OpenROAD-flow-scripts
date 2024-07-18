// Quick and dirty reimplementation of altos_dff_module because
// Verilator doesn't support and has no plans to support 1995 UDP
// tables.
//
// https://github.com/verilator/verilator/issues/5243
module altos_dff_module(q, v, clk, d, xcr);
    output reg q;
    input v, clk, d, xcr;

    always @(v or clk or d or xcr) begin
        if (xcr === 1'b0) begin
            q <= 1'bx; // Corresponds to * ? ? ? : ? : x;
        end
        else if (clk === 1'b0 && v !== 1'b0) begin
            if (d === 1'b0) q <= 0; // ? (x1) 0 0 : ? : 0;
            else if (d === 1'b1) q <= 1; // ? (x1) 1 0 : ? : 1;
        end
        else if (clk === 1'b1 && v !== 1'b0) begin
            if (d === 1'b0) q <= 0; // ? (x1) 0 1 : 0 : 0;
            else if (d === 1'b1) q <= 1; // ? (x1) 1 1 : 1 : 1;
        end
        // Additional conditions would need to be translated similarly.
    end
endmodule
