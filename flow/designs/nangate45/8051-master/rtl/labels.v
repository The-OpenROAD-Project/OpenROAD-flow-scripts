`define ALU_ARITHMATIC_UNIT  3'b000
`define ALU_TRANSFER_UNIT    3'b001
`define ALU_LOGICAL_UNIT     3'b010
`define ALU_BOOLEAN_UNIT     3'b011

`define ALU_ADD              3'b000
`define ALU_ADDC             3'b001
`define ALU_SUBB             3'b010
`define ALU_INC              3'b011
`define ALU_DEC              3'b100
`define ALU_MUL          	 3'b101
`define ALU_DIV         	 3'b110
`define ALU_DA               3'b111

`define ALU_AND_A            3'b000
`define ALU_AND_direct       3'b100
`define ALU_OR_A             3'b001
`define ALU_OR_direct        3'b101
`define ALU_XOR_A            3'b010
`define ALU_XOR_direct       3'b110
`define ALU_CLR              3'b011
`define ALU_NOT              3'b111

`define ALU_RR               3'b001
`define ALU_RL               3'b010
`define ALU_RRC              3'b101
`define ALU_RLC              3'b110
`define ALU_TRANSFER         3'b000
`define ALU_SWAP             3'b011
`define ALU_SWAP_NIBBLE      3'b111

`define ALU_CLR_BIT          3'b000
`define ALU_SET_BIT          3'b001
`define ALU_NOT_BIT          3'b010
`define ALU_AND_BIT          3'b011
`define ALU_NOT_AND_BIT      3'b100
`define ALU_OR_BIT           3'b101
`define ALU_NOT_OR_BIT       3'b110
`define ALU_TRANSFER_BIT     3'b111

`define ALU_ACALL            6'b100000
`define ALU_LCALL            6'b100001
`define ALU_RET              6'b100010
`define ALU_AJMP             6'b100011
`define ALU_LJMP             6'b100100
`define ALU_SJMP             6'b100101
`define ALU_JMP              6'b100110

`define ALU_CJNE_AD          6'b100111
`define ALU_CJNE_ADATA       6'b110000
`define ALU_CJNE_RDATA       6'b110001
`define ALU_CJNE_ATRDATA     6'b110010
`define ALU_DJNZ             6'b101000
`define ALU_JZ               6'b101001
`define ALU_JNZ              6'b101010
`define ALU_JC               6'b101011
`define ALU_JNC              6'b101100
`define ALU_JB               6'b101101
`define ALU_JNB              6'b101110
`define ALU_JBC              6'b101111
