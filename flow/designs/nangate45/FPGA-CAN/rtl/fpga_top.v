
//--------------------------------------------------------------------------------------------------------
// Module  : fpga_top
// Type    : synthesizable, FPGA's top, IP's example design
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: an example of can_top
//--------------------------------------------------------------------------------------------------------

module fpga_top (
    // clock, Connect to the oscillator on the FPGA board, the frequency must be 50MHz.
    input  wire           CLK50M,
    // UART (TX only), connect to the serial port of the computer (for example, through the USB to UART module), not necessary.
    output wire           UART_TX,
    // CAN bus, connect to CAN-PHY chip.
    input  wire           CAN_RX,
    output wire           CAN_TX
);


wire clk = CLK50M;  // 50 MHz (maybe you can set a frequency close to but not equal to 50 MHz, like 50.5MHz, for testing the robust of CAN's clock alignment).


// --------------------------------------------------------------------------------------------------------------
//  power on reset generate
// --------------------------------------------------------------------------------------------------------------
reg        rstn = 1'b0;
reg [ 2:0] rstn_shift = 3'd0;
always @ (posedge clk)
    {rstn, rstn_shift} <= {rstn_shift, 1'b1};



// --------------------------------------------------------------------------------------------------------------
//  signals
// --------------------------------------------------------------------------------------------------------------
reg [31:0] can_tx_cnt;
reg        can_tx_valid;
reg [31:0] can_tx_data;

wire       can_rx_valid;
wire [7:0] can_rx_data;


// --------------------------------------------------------------------------------------------------------------
//  Periodically send incremental data to the CAN tx-buffer
// --------------------------------------------------------------------------------------------------------------
always @ (posedge clk or negedge rstn)
    if(~rstn) begin
        can_tx_cnt <= 0;
        can_tx_valid <= 1'b0;
        can_tx_data <= 0;
    end else begin
        if(can_tx_cnt<50000000-1) begin
            can_tx_cnt <= can_tx_cnt + 1;
            can_tx_valid <= 1'b0;
        end else begin
            can_tx_cnt <= 0;
            can_tx_valid <= 1'b1;
            can_tx_data <= can_tx_data + 1;
        end
    end


// --------------------------------------------------------------------------------------------------------------
//  CAN controller
// --------------------------------------------------------------------------------------------------------------
can_top #(
    .LOCAL_ID          ( 11'h456            ),
    .RX_ID_SHORT_FILTER( 11'h123            ),
    .RX_ID_SHORT_MASK  ( 11'h7ff            ),
    .RX_ID_LONG_FILTER ( 29'h12345678       ),
    .RX_ID_LONG_MASK   ( 29'h1fffffff       ),
    .default_c_PTS     ( 16'd34             ),      // CAN baud rate = 1MHz
    .default_c_PBS1    ( 16'd5              ),
    .default_c_PBS2    ( 16'd10             )
) u_can_top (
    .rstn              ( rstn               ),
    .clk               ( clk                ),
    .can_rx            ( CAN_RX             ),
    .can_tx            ( CAN_TX             ),
    .tx_valid          ( can_tx_valid       ),
    .tx_ready          (                    ),
    .tx_data           ( can_tx_data        ),
    .rx_valid          ( can_rx_valid       ),
    .rx_last           (                    ),
    .rx_data           ( can_rx_data        ),
    .rx_id             (                    ),
    .rx_ide            (                    )
);


// --------------------------------------------------------------------------------------------------------------
//  send CAN RX data to UART TX
// --------------------------------------------------------------------------------------------------------------
uart_tx #(
    .CLK_FREQ          ( 50000000           ),
    .BAUD_RATE         ( 115200             ),      // UART baud rate = 115200
    .PARITY            ( "NONE"             ),
    .STOP_BITS         ( 3                  ),
    .BYTE_WIDTH        ( 1                  ),
    .FIFO_EA           ( 10                 ),      // enable TX fifo, fifo depth = 1024
    .EXTRA_BYTE_AFTER_TRANSFER ( ""         ),
    .EXTRA_BYTE_AFTER_PACKET   ( ""         )
) u_uart_tx (
    .rstn              ( rstn               ),
    .clk               ( clk                ),
    .i_tready          (                    ),
    .i_tvalid          ( can_rx_valid       ),
    .i_tdata           ( can_rx_data        ),
    .i_tkeep           ( 1'b1               ),
    .i_tlast           ( 1'b0               ),
    .o_uart_tx         ( UART_TX            )
);



endmodule
