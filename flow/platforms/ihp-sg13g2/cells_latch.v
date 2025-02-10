module $_DLATCH_P_(input E, input D, output Q);
    sg13g2_dlhq_1 _TECHMAP_REPLACE_ (
        .D(D),
        .GATE(E),
        .Q(Q)
        );
endmodule

module $_DLATCH_N_(input E, input D, output Q);
    sg13g2_dllrq_1 _TECHMAP_REPLACE_ (
        .D(D),
        .GATE_N(E),
        .RESET_B(1'b1),
        .Q(Q)
        );
endmodule
