// Quick and dirty reimplementation of DFFHQNx2_ASAP7_75t_R
// because verilator doesn't support and has no plans to
// support 1995 UDP tables.
//
// https://github.com/verilator/verilator/issues/5243

module DFFHQNx1_ASAP7_75t_R (QN, D, CLK);
    output QN;
    input D, CLK;
    reg IQNN;
    wire IQN;
    always @(posedge CLK) begin
        IQNN <= ~D;
    end
    assign IQN = IQNN;
    assign QN = IQN;
endmodule

module DFFHQNx2_ASAP7_75t_R (QN, D, CLK);
    output QN;
    input D, CLK;
    reg IQNN;
    wire IQN;
    always @(posedge CLK) begin
        IQNN <= D;
    end
    assign IQN = IQNN;
    assign QN = IQN;
endmodule

module DFFHQNx3_ASAP7_75t_R (QN, D, CLK);
    output QN;
    input D, CLK;
    reg IQNN;
    wire IQN;
    always @(posedge CLK) begin
        IQNN <= ~D;
    end
    assign IQN = IQNN;
    assign QN = IQN;
endmodule
