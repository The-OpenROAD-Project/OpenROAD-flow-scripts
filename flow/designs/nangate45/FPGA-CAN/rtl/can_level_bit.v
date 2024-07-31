
//--------------------------------------------------------------------------------------------------------
// Module  : can_level_bit
// Type    : synthesizable, IP's sub module
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: CAN bus bit level controller,
//           instantiated by can_level_packet
//--------------------------------------------------------------------------------------------------------

module can_level_bit #(
    parameter [15:0] default_c_PTS  = 16'd34,
    parameter [15:0] default_c_PBS1 = 16'd5,
    parameter [15:0] default_c_PBS2 = 16'd10
) (
    input  wire        rstn,  // set to 1 while working
    input  wire        clk,   // system clock, eg, when clk=50000kHz, can baud rate = 50000/(1+default_c_PTS+default_c_PBS1+default_c_PBS2) = 100kHz
    // CAN TX and RX
    input  wire        can_rx,
    output reg         can_tx,
    // user interface
    output reg         req,   // indicate the bit border
    output reg         rbit,  // last bit recieved, valid when req=1
    input  wire        tbit   // next bit to transmit, must set at the cycle after req=1
);


initial can_tx = 1'b1;
initial req  = 1'b0;
initial rbit = 1'b1;

reg        rx_buf = 1'b1;
reg        rx_fall = 1'b0;

always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        rx_buf  <= 1'b1;
        rx_fall <= 1'b0;
    end else begin
        rx_buf  <= can_rx;
        rx_fall <= rx_buf & ~can_rx;
    end


localparam [16:0] default_c_PTS_e  = {1'b0, default_c_PTS};
localparam [16:0] default_c_PBS1_e = {1'b0, default_c_PBS1};
localparam [16:0] default_c_PBS2_e = {1'b0, default_c_PBS2};

reg  [16:0] adjust_c_PBS1 = 17'd0;
reg  [ 2:0] cnt_high = 3'd0;
reg  [16:0] cnt = 17'd1;
reg         inframe = 1'b0;

localparam [1:0] STAT_PTS  = 2'd0,
                 STAT_PBS1 = 2'd1,
                 STAT_PBS2 = 2'd2;

reg [1:0] stat = STAT_PTS;


always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        can_tx <= 1'b1;
        req <= 1'b0;
        rbit <= 1'b1;
        adjust_c_PBS1 <= 8'd0;
        cnt_high <= 3'd0;
        cnt <= 17'd1;
        stat <= STAT_PTS;
        inframe <= 1'b0;
    end else begin
        req <= 1'b0;
        if(~inframe & rx_fall) begin
            adjust_c_PBS1 <= default_c_PBS1_e;
            cnt <= 17'd1;
            stat <= STAT_PTS;
            inframe <= 1'b1;
        end else begin
            case(stat)
                STAT_PTS: begin
                    if( (rx_fall & tbit) && cnt>17'd2 )
                        adjust_c_PBS1 <= default_c_PBS1_e + cnt;
                    if(cnt>=default_c_PTS_e) begin
                        cnt <= 17'd1;
                        stat <= STAT_PBS1;
                    end else
                        cnt <= cnt + 17'd1;
                end
                
                STAT_PBS1: begin
                    if(cnt==17'd1) begin
                        req <= 1'b1;
                        rbit <= rx_buf;   // sampling bit
                        cnt_high <= rx_buf ? cnt_high<3'd7 ? cnt_high+3'd1 : cnt_high : 3'd0;
                    end
                    if(cnt>=adjust_c_PBS1) begin
                        cnt <= 17'd0;
                        stat <= STAT_PBS2;
                    end else
                        cnt <= cnt + 17'd1;
                end
                
                default : begin   // STAT_PBS2 : 
                    if( (rx_fall & tbit) || (cnt>=default_c_PBS2_e) ) begin
                        can_tx <= tbit;
                        adjust_c_PBS1 <= default_c_PBS1_e;
                        cnt <= 17'd1;
                        stat <= STAT_PTS;
                        if(cnt_high==3'd7) inframe <= 1'b0;
                    end else begin
                        cnt <= cnt + 17'd1;
                        if(cnt==default_c_PBS2_e-17'd1)
                            can_tx <= tbit;
                    end
                end
            endcase
        end
    end

endmodule
