module mac (
    input  logic         clock,
    input  logic [15:0]  a,
    input  logic [15:0]  b,
    input  logic         valid_in,
    output logic [31:0]  acc_out,
    output logic         valid_out
);
    // Pipeline registers for a, b, and valid
    logic [15:0] a_pipe [0:3];
    logic [15:0] b_pipe [0:3];
    logic        valid_pipe [0:3];
    logic [31:0] mul_result;
    logic [31:0] acc;

    always_ff @(posedge clock) begin
        // Stage 0: input register
        a_pipe[0] <= a;
        b_pipe[0] <= b;
        valid_pipe[0] <= valid_in;

        // Stages 1-3: pipeline shift
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        valid_pipe[1] <= valid_pipe[0];

        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        valid_pipe[2] <= valid_pipe[1];

        a_pipe[3] <= a_pipe[2];
        b_pipe[3] <= b_pipe[2];
        valid_pipe[3] <= valid_pipe[2];

        // Stage 4: multiply and accumulate
        mul_result <= a_pipe[3] * b_pipe[3];
        if (valid_pipe[3])
            acc <= acc + mul_result;
    end

    assign acc_out = acc;
    assign valid_out = valid_pipe[3];
endmodule
