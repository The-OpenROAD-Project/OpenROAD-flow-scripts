module uart_tx #(
    // clock frequency
    parameter  CLK_FREQ                  = 50000000,     // clk frequency, Unit : Hz
    // UART format
    parameter  BAUD_RATE                 = 115200,       // Unit : Hz
    parameter  PARITY                    = "NONE",       // "NONE", "ODD", or "EVEN"
    parameter  STOP_BITS                 = 2,            // can be 1, 2, 3, 4, ...
    // AXI stream data width
    parameter  BYTE_WIDTH                = 1,            // can be 1, 2, 3, 4, ...
    // TX fifo depth
    parameter  FIFO_EA                   = 0,            // 0:no fifo   1,2:depth=4   3:depth=8   4:depth=16  ...  10:depth=1024   11:depth=2048  ...
    // do you want to send extra byte after each AXI-stream transfer or packet?
    parameter  EXTRA_BYTE_AFTER_TRANSFER = "",           // specify a extra byte to send after each AXI-stream transfer. when ="", do not send this extra byte
    parameter  EXTRA_BYTE_AFTER_PACKET   = ""            // specify a extra byte to send after each AXI-stream packet  . when ="", do not send this extra byte
) (
    input  wire                    rstn,
    input  wire                    clk,
    // input  stream : AXI-stream slave. Associated clock = clk
    output wire                    i_tready,
    input  wire                    i_tvalid,
    input  wire [8*BYTE_WIDTH-1:0] i_tdata,
    input  wire [  BYTE_WIDTH-1:0] i_tkeep,
    input  wire                    i_tlast,
    // UART TX output signal
    output reg                     o_uart_tx
);



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// TX fifo
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
wire                    f_tready;
reg                     f_tvalid;
reg  [8*BYTE_WIDTH-1:0] f_tdata;
reg  [  BYTE_WIDTH-1:0] f_tkeep;
reg                     f_tlast;

generate if (FIFO_EA <= 0) begin          // no TX fifo

    assign       i_tready = f_tready;
    always @ (*) f_tvalid = i_tvalid;
    always @ (*) f_tdata  = i_tdata;
    always @ (*) f_tkeep  = i_tkeep;
    always @ (*) f_tlast  = i_tlast;

end else begin                            // TX fifo

    localparam        EA     = (FIFO_EA<=2) ? 2 : FIFO_EA;
    localparam        DW     = ( 1 + BYTE_WIDTH + 8*BYTE_WIDTH );     // 1-bit tlast, (BYTE_WIDTH)-bit tkeep, (8*BYTE_WIDTH)-bit tdata
    
    reg  [DW-1:0] buffer [ ((1<<EA)-1) : 0 ];
    
    localparam [EA:0] A_ZERO = {{EA{1'b0}}, 1'b0};
    localparam [EA:0] A_ONE  = {{EA{1'b0}}, 1'b1};

    reg  [EA:0] wptr      = A_ZERO;
    reg  [EA:0] wptr_d1   = A_ZERO;
    reg  [EA:0] wptr_d2   = A_ZERO;
    reg  [EA:0] rptr      = A_ZERO;
    wire [EA:0] rptr_next = (f_tvalid & f_tready) ? (rptr+A_ONE) : rptr;
    
    assign i_tready = ( wptr != {~rptr[EA], rptr[EA-1:0]} );

    always @ (posedge clk or negedge rstn)
        if (~rstn) begin
            wptr    <= A_ZERO;
            wptr_d1 <= A_ZERO;
            wptr_d2 <= A_ZERO;
        end else begin
            if (i_tvalid & i_tready)
                wptr <= wptr + A_ONE;
            wptr_d1 <= wptr;
            wptr_d2 <= wptr_d1;
        end

    always @ (posedge clk)
        if (i_tvalid & i_tready)
            buffer[wptr[EA-1:0]] <= {i_tlast, i_tkeep, i_tdata};

    always @ (posedge clk or negedge rstn)
        if (~rstn) begin
            rptr <= A_ZERO;
            f_tvalid <= 1'b0;
        end else begin
            rptr <= rptr_next;
            f_tvalid <= (rptr_next != wptr_d2);
        end

    always @ (posedge clk)
        {f_tlast, f_tkeep, f_tdata} <= buffer[rptr_next[EA-1:0]];
    
    initial {f_tvalid, f_tlast, f_tkeep, f_tdata} = 0;
    
end endgenerate




//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// Generate fractional precise upper limit for counter
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
localparam      BAUD_CYCLES              = ( (CLK_FREQ*10*2 + BAUD_RATE) / (BAUD_RATE*2) ) / 10 ;
localparam      BAUD_CYCLES_FRAC         = ( (CLK_FREQ*10*2 + BAUD_RATE) / (BAUD_RATE*2) ) % 10 ;
localparam      STOP_BIT_CYCLES          = (BAUD_CYCLES_FRAC == 0) ? BAUD_CYCLES : (BAUD_CYCLES + 1);

localparam [9:0] ADDITION_CYCLES = (BAUD_CYCLES_FRAC == 0) ? 10'b0000000000 :
                                   (BAUD_CYCLES_FRAC == 1) ? 10'b0000010000 :
                                   (BAUD_CYCLES_FRAC == 2) ? 10'b0010000100 :
                                   (BAUD_CYCLES_FRAC == 3) ? 10'b0010010010 :
                                   (BAUD_CYCLES_FRAC == 4) ? 10'b0101001010 :
                                   (BAUD_CYCLES_FRAC == 5) ? 10'b0101010101 :
                                   (BAUD_CYCLES_FRAC == 6) ? 10'b1010110101 :
                                   (BAUD_CYCLES_FRAC == 7) ? 10'b1101101101 :
                                   (BAUD_CYCLES_FRAC == 8) ? 10'b1101111011 :
                                  /*BAUD_CYCLES_FRAC == 9)*/ 10'b1111101111 ;

wire [31:0] cycles [9:0];

assign cycles[0] = BAUD_CYCLES + (ADDITION_CYCLES[0] ? 1 : 0);
assign cycles[1] = BAUD_CYCLES + (ADDITION_CYCLES[1] ? 1 : 0);
assign cycles[2] = BAUD_CYCLES + (ADDITION_CYCLES[2] ? 1 : 0);
assign cycles[3] = BAUD_CYCLES + (ADDITION_CYCLES[3] ? 1 : 0);
assign cycles[4] = BAUD_CYCLES + (ADDITION_CYCLES[4] ? 1 : 0);
assign cycles[5] = BAUD_CYCLES + (ADDITION_CYCLES[5] ? 1 : 0);
assign cycles[6] = BAUD_CYCLES + (ADDITION_CYCLES[6] ? 1 : 0);
assign cycles[7] = BAUD_CYCLES + (ADDITION_CYCLES[7] ? 1 : 0);
assign cycles[8] = BAUD_CYCLES + (ADDITION_CYCLES[8] ? 1 : 0);
assign cycles[9] = BAUD_CYCLES + (ADDITION_CYCLES[9] ? 1 : 0);



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
localparam [BYTE_WIDTH-1:0] ZERO_KEEP   = 0;

localparam           [31:0] PARITY_BITS = (PARITY == "ODD" || PARITY == "EVEN") ? 1 : 0;
localparam           [31:0] TOTAL_BITS  = (STOP_BITS >= ('hFFFFFFFF-9-PARITY_BITS)) ? 'hFFFFFFFF : (PARITY_BITS+STOP_BITS+9);

localparam           [ 0:0] BYTE_T_EN   = (EXTRA_BYTE_AFTER_TRANSFER == "") ? 1'b0 : 1'b1;
localparam           [ 0:0] BYTE_B_EN   = (EXTRA_BYTE_AFTER_PACKET   == "") ? 1'b0 : 1'b1;
localparam           [ 7:0] BYTE_T      =  EXTRA_BYTE_AFTER_TRANSFER;
localparam           [ 7:0] BYTE_P      =  EXTRA_BYTE_AFTER_PACKET;



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// function for calculate parity bit
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
function  [0:0] get_parity;
    input [7:0] data;
begin
    get_parity = (PARITY == "ODD" ) ? (~(^(data[7:0]))) : 
                 (PARITY == "EVEN") ?   (^(data[7:0]))  : 
               /*(PARITY == "NONE")*/      1'b1         ;
end
endfunction



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// main FSM
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
localparam [       1:0] S_IDLE     = 2'b01 ,       // only in state S_IDLE, state[0]==1, the goal is to make f_tready pure register-out
                        S_PREPARE  = 2'b00 ,
                        S_TX       = 2'b10 ;

reg  [             1:0] state      = S_IDLE;       // FSM state register

reg  [8*BYTE_WIDTH-1:0] data       = 0;
reg  [  BYTE_WIDTH-1:0] keep       = 0;
reg                     byte_t_en  = 1'b0;
reg                     byte_p_en  = 1'b0;
reg  [             9:0] txbits     = 10'b0;
reg  [            31:0] txcnt      = 0;
reg  [            31:0] cycle      = 1;


always @ (posedge clk or negedge rstn)
    if (~rstn) begin
        state      <= S_IDLE;
        data       <= 0;
        keep       <= 0;
        byte_t_en  <= 1'b0;
        byte_p_en  <= 1'b0;
        txbits     <= 10'b0;
        txcnt      <= 0;
        cycle      <= 1;
    end else begin
        case (state)
            S_IDLE : begin
                state      <= f_tvalid ? S_PREPARE : S_IDLE;
                data       <= f_tdata;
                keep       <= f_tkeep;
                byte_t_en  <= BYTE_T_EN;
                byte_p_en  <= BYTE_B_EN & f_tlast;
                txbits     <= 10'b0;
                txcnt      <= 0;
                cycle      <= 1;
            end
            
            S_PREPARE : begin
                data <= (data >> 8);
                keep <= (keep >> 1);
                if          ( keep[0] == 1'b1   ) begin
                    txbits     <= {get_parity(data[7:0]), data[7:0], 1'b0};
                    state      <= S_TX;
                end else if ( keep != ZERO_KEEP ) begin
                    state      <= S_PREPARE;
                end else if ( byte_t_en         ) begin
                    byte_t_en <= 1'b0;
                    txbits     <= {get_parity(BYTE_T), BYTE_T, 1'b0};
                    state      <= S_TX;
                end else if ( byte_p_en         ) begin
                    byte_p_en <= 1'b0;
                    txbits     <= {get_parity(BYTE_P), BYTE_P, 1'b0};
                    state      <= S_TX;
                end else begin
                    state      <= S_IDLE;
                end
                txcnt <= 0;
                cycle <= 1;
            end
            
            default : begin  // S_TX
                if (keep[0] == 1'b0) begin
                    data <= (data >> 8);
                    keep <= (keep >> 1);
                end
                if ( cycle < ((txcnt<=9) ? cycles[txcnt] : STOP_BIT_CYCLES) ) begin      // cycle loop from 1 to ((txcnt<=9) ? cycles[txcnt] : STOP_BIT_CYCLES)
                    cycle  <= cycle + 1;
                end else begin
                    cycle  <= 1;
                    txbits <= {1'b1, txbits[9:1]};                                       // right shift txbits, and fill '1' to MSB
                    if ( txcnt < (TOTAL_BITS-1) ) begin                                  // txcnt loop from 0 to (TOTAL_BITS-1)
                        txcnt <= txcnt + 1;
                    end else begin
                        txcnt <= 0;
                        state <= S_PREPARE;
                    end
                end
            end
        endcase
    end



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// generate UART output
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
initial o_uart_tx = 1'b1;

always @ (posedge clk or negedge rstn)
    if (~rstn)
        o_uart_tx <= 1'b1;
    else
        o_uart_tx <= (state == S_TX) ? txbits[0] : 1'b1;



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// generate AXI-stream TREADY
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
assign f_tready = state[0];   // (state == S_IDLE)



//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// parameter checking
//---------------------------------------------------------------------------------------------------------------------------------------------------------------
// initial begin
//     if (BYTE_WIDTH <= 0) begin $error("invalid parameter : BYTE_WIDTH<=0"); $stop; end
//     if (STOP_BITS  <= 0) begin $error("invalid parameter : STOP_BITS <=0"); $stop; end
//     if (BAUD_CYCLES < 1) begin $error("invalid parameter : BAUD_CYCLES < 1, please use a faster driving clock"); $stop; end
    
//     $display("uart_tx :           parity = %s" , PARITY );
//     $display("uart_tx :     clock period = %.0f ns   (%-10d Hz)" , 1000000000.0/CLK_FREQ  , CLK_FREQ );
//     $display("uart_tx : baud rate period = %.0f ns   (%-10d Hz)" , 1000000000.0/BAUD_RATE , BAUD_RATE);
//     $display("uart_tx :      baud cycles = %-10d"   , BAUD_CYCLES );
//     $display("uart_tx : baud cycles frac = %-10d"   , BAUD_CYCLES_FRAC  );
    
//     if (PARITY == "ODD" || PARITY == "EVEN") begin
//         $display("uart_tx :             __      ____ ____ ____ ____ ____ ____ ____ ____________ ");
//         $display("uart_tx :        wave   \\____/____X____X____X____X____X____X____X____X____/   ");
//         $display("uart_tx :        bits   | S  | B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7 | P  |   ");
//         $display("uart_tx : time_points  t0   t1   t2   t3   t4   t5   t6   t7   t8   t9   t10  ");
//         $display("uart_tx :");
//     end else begin
//         $display("uart_tx :             __      ____ ____ ____ ____ ____ ____ ____ _______ ");
//         $display("uart_tx :        wave   \\____/____X____X____X____X____X____X____X____/   ");
//         $display("uart_tx :        bits   | S  | B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7 |   ");
//         $display("uart_tx : time_points  t0   t1   t2   t3   t4   t5   t6   t7   t8   t9   ");
//         $display("uart_tx :");
//     end
// end

// generate genvar index, i;
//     for (index=0; index<=9; index=index+1) begin : print_and_check_time
//         localparam cycles_acc = ( (index >= 0) ? (BAUD_CYCLES + (ADDITION_CYCLES[0] ? 1 : 0)) : 0 )
//                               + ( (index >= 1) ? (BAUD_CYCLES + (ADDITION_CYCLES[1] ? 1 : 0)) : 0 )
//                               + ( (index >= 2) ? (BAUD_CYCLES + (ADDITION_CYCLES[2] ? 1 : 0)) : 0 )
//                               + ( (index >= 3) ? (BAUD_CYCLES + (ADDITION_CYCLES[3] ? 1 : 0)) : 0 )
//                               + ( (index >= 4) ? (BAUD_CYCLES + (ADDITION_CYCLES[4] ? 1 : 0)) : 0 )
//                               + ( (index >= 5) ? (BAUD_CYCLES + (ADDITION_CYCLES[5] ? 1 : 0)) : 0 )
//                               + ( (index >= 6) ? (BAUD_CYCLES + (ADDITION_CYCLES[6] ? 1 : 0)) : 0 )
//                               + ( (index >= 7) ? (BAUD_CYCLES + (ADDITION_CYCLES[7] ? 1 : 0)) : 0 )
//                               + ( (index >= 8) ? (BAUD_CYCLES + (ADDITION_CYCLES[8] ? 1 : 0)) : 0 )
//                               + ( (index >= 9) ? (BAUD_CYCLES + (ADDITION_CYCLES[9] ? 1 : 0)) : 0 ) ;
        
//         localparam real ideal_time_ns  = ((index+1)*1000000000.0/BAUD_RATE);
//         localparam real actual_time_ns = (cycles_acc*1000000000.0/CLK_FREQ);
//         localparam real error          = (ideal_time_ns>actual_time_ns) ? (ideal_time_ns-actual_time_ns) : (-ideal_time_ns+actual_time_ns);
//         localparam real relative_error_percent = (error / (1000000000.0/BAUD_RATE)) * 100.0;
        
//         initial if (PARITY == "ODD" || PARITY == "EVEN" || index < 9) begin
//             $display("uart_tx : t%-2d- t0 = %.0f ns (ideal)  %.0f ns (actual).   error=%.0f ns   relative_error=%.3f%%" ,
//                 (index+1) ,
//                 ideal_time_ns ,
//                 actual_time_ns,
//                 error,
//                 relative_error_percent
//             );
            
//             if ( relative_error_percent > 3.0 ) begin $error("relative_error is too large"); $stop; end   // if relative error larger than 3%
//         end
//     end
// endgenerate


endmodule
