// Copyright (c) 2026 Bandham Balaji
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module dsp_mac (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire sel_b         = uio_in[0];
    wire clr_acc       = uio_in[1];
    wire acc_en        = uio_in[2];
    wire sat_en        = uio_in[3];
    wire [1:0] out_sel = uio_in[5:4];

    // Pipeline Stage 1: Input latching
    reg signed [7:0] a_reg;
    reg signed [7:0] b_reg;
    reg              pipe_valid_s1;
    reg              acc_en_s1;
    reg              sat_en_s1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg         <= 8'sd0;
            b_reg         <= 8'sd0;
            pipe_valid_s1 <= 1'b0;
            acc_en_s1     <= 1'b0;
            sat_en_s1     <= 1'b0;
        end else if (ena) begin
            if (!sel_b) begin
                a_reg         <= $signed(ui_in);
                pipe_valid_s1 <= 1'b0;
            end else begin
                b_reg         <= $signed(ui_in);
                pipe_valid_s1 <= 1'b1;
                acc_en_s1     <= acc_en;
                sat_en_s1     <= sat_en;
            end
        end
    end

    // Pipeline Stage 2: Multiplier
    wire signed [15:0] mult_comb = a_reg * b_reg;
    reg signed [15:0] prod_reg;
    reg               pipe_valid_s2;
    reg               acc_en_s2;
    reg               sat_en_s2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            prod_reg      <= 16'sd0;
            pipe_valid_s2 <= 1'b0;
            acc_en_s2     <= 1'b0;
            sat_en_s2     <= 1'b0;
        end else if (ena) begin
            prod_reg      <= mult_comb;
            pipe_valid_s2 <= pipe_valid_s1;
            acc_en_s2     <= acc_en_s1;
            sat_en_s2     <= sat_en_s1;
        end
    end

    // Pipeline Stage 3: Accumulator with saturation
    reg signed [15:0] acc_reg;
    reg               ovf_sticky;
    reg               sat_active;

    wire signed [16:0] acc_ext  = {acc_reg[15], acc_reg};
    wire signed [16:0] prod_ext = {prod_reg[15], prod_reg};
    wire signed [16:0] sum_ext  = acc_en_s2 ? (acc_ext + prod_ext) : prod_ext;

    wire pos_ovf = acc_en_s2 & (~acc_reg[15] & ~prod_reg[15] & sum_ext[15]);
    wire neg_ovf = acc_en_s2 & (acc_reg[15] & prod_reg[15] & ~sum_ext[15]);
    wire ovf_detected = pos_ovf | neg_ovf;

    reg signed [15:0] next_acc;
    always @(*) begin
        if (sat_en_s2 && pos_ovf) begin
            next_acc = 16'sh7FFF;
        end else if (sat_en_s2 && neg_ovf) begin
            next_acc = 16'sh8000;
        end else begin
            next_acc = sum_ext[15:0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_reg    <= 16'sd0;
            ovf_sticky <= 1'b0;
            sat_active <= 1'b0;
        end else if (ena) begin
            if (clr_acc) begin
                acc_reg    <= 16'sd0;
                ovf_sticky <= 1'b0;
                sat_active <= 1'b0;
            end else if (pipe_valid_s2) begin
                acc_reg    <= next_acc;
                sat_active <= sat_en_s2 & ovf_detected;
                if (ovf_detected) begin
                    ovf_sticky <= 1'b1;
                end
            end
        end
    end

    // Flags & outputs
    wire zero_flag = (acc_reg == 16'sd0);
    wire sign_flag = acc_reg[15];
    wire [7:0] flags = {ovf_sticky, sat_active, zero_flag, sign_flag, pipe_valid_s2, 3'b000};

    reg [7:0] uo_out_mux;
    always @(*) begin
        case (out_sel)
            2'b00:   uo_out_mux = acc_reg[7:0];
            2'b01:   uo_out_mux = acc_reg[15:8];
            2'b10:   uo_out_mux = flags;
            2'b11:   uo_out_mux = prod_reg[15:8];
            default: uo_out_mux = acc_reg[7:0];
        endcase
    end
    assign uo_out = uo_out_mux;

    assign uio_oe  = 8'b1100_0000;
    assign uio_out = {pipe_valid_s2, ovf_sticky, 6'b000000};

endmodule

`default_nettype wire
