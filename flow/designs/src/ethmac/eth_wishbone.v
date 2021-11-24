//////////////////////////////////////////////////////////////////////
////                                                              ////
////  eth_wishbone.v                                              ////
////                                                              ////
////  This file is part of the Ethernet IP core project           ////
////  http://www.opencores.org/project,ethmac                     ////
////                                                              ////
////  Author(s):                                                  ////
////      - Igor Mohor (igorM@opencores.org)                      ////
////                                                              ////
////  All additional information is available in the Readme.txt   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2001, 2002 Authors                             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.57  2005/02/21 11:35:33  igorm
// Defer indication fixed.
//
// Revision 1.56  2004/04/30 10:30:00  igorm
// Accidently deleted line put back.
//
// Revision 1.55  2004/04/26 15:26:23  igorm
// - Bug connected to the TX_BD_NUM_Wr signal fixed (bug came in with the
//   previous update of the core.
// - TxBDAddress is set to 0 after the TX is enabled in the MODER register.
// - RxBDAddress is set to r_TxBDNum<<1 after the RX is enabled in the MODER
//   register. (thanks to Mathias and Torbjorn)
// - Multicast reception was fixed. Thanks to Ulrich Gries
//
// Revision 1.54  2003/11/12 18:24:59  tadejm
// WISHBONE slave changed and tested from only 32-bit accesss to byte access.
//
// Revision 1.53  2003/10/17 07:46:17  markom
// mbist signals updated according to newest convention
//
// Revision 1.52  2003/01/30 14:51:31  mohor
// Reset has priority in some flipflops.
//
// Revision 1.51  2003/01/30 13:36:22  mohor
// A new bug (entered with previous update) fixed. When abort occured sometimes
// data transmission was blocked.
//
// Revision 1.50  2003/01/22 13:49:26  tadejm
// When control packets were received, they were ignored in some cases.
//
// Revision 1.49  2003/01/21 12:09:40  mohor
// When receiving normal data frame and RxFlow control was switched on, RXB
// interrupt was not set.
//
// Revision 1.48  2003/01/20 12:05:26  mohor
// When in full duplex, transmit was sometimes blocked. Fixed.
//
// Revision 1.47  2002/11/22 13:26:21  mohor
// Registers RxStatusWrite_rck and RxStatusWriteLatched were not used
// anywhere. Removed.
//
// Revision 1.46  2002/11/22 01:57:06  mohor
// Rx Flow control fixed. CF flag added to the RX buffer descriptor. RxAbort
// synchronized.
//
// Revision 1.45  2002/11/19 17:33:34  mohor
// AddressMiss status is connecting to the Rx BD. AddressMiss is identifying
// that a frame was received because of the promiscous mode.
//
// Revision 1.44  2002/11/13 22:21:40  tadejm
// RxError is not generated when small frame reception is enabled and small
// frames are received.
//
// Revision 1.43  2002/10/18 20:53:34  mohor
// case changed to casex.
//
// Revision 1.42  2002/10/18 17:04:20  tadejm
// Changed BIST scan signals.
//
// Revision 1.41  2002/10/18 15:42:09  tadejm
// Igor added WB burst support and repaired BUG when handling TX under-run and retry.
//
// Revision 1.40  2002/10/14 16:07:02  mohor
// TxStatus is written after last access to the TX fifo is finished (in case of abort
// or retry). TxDone is fixed.
//
// Revision 1.39  2002/10/11 15:35:20  mohor
// txfifo_cnt and rxfifo_cnt counters width is defined in the eth_define.v file,
// TxDone and TxRetry are generated after the current WISHBONE access is
// finished.
//
// Revision 1.38  2002/10/10 16:29:30  mohor
// BIST added.
//
// Revision 1.37  2002/09/11 14:18:46  mohor
// Sometimes both RxB_IRQ and RxE_IRQ were activated. Bug fixed.
//
// Revision 1.36  2002/09/10 13:48:46  mohor
// Reception is possible after RxPointer is read and not after BD is read. For
// that reason RxBDReady is changed to RxReady.
// Busy_IRQ interrupt connected. When there is no RxBD ready and frame
// comes, interrupt is generated.
//
// Revision 1.35  2002/09/10 10:35:23  mohor
// Ethernet debug registers removed.
//
// Revision 1.34  2002/09/08 16:31:49  mohor
// Async reset for WB_ACK_O removed (when core was in reset, it was
// impossible to access BDs).
// RxPointers and TxPointers names changed to be more descriptive.
// TxUnderRun synchronized.
//
// Revision 1.33  2002/09/04 18:47:57  mohor
// Debug registers reg1, 2, 3, 4 connected. Synchronization of many signals
// changed (bugs fixed). Access to un-alligned buffers fixed. RxAbort signal
// was not used OK.
//
// Revision 1.32  2002/08/14 19:31:48  mohor
// Register TX_BD_NUM is changed so it contains value of the Tx buffer descriptors. No
// need to multiply or devide any more.
//
// Revision 1.31  2002/07/25 18:29:01  mohor
// WriteRxDataToMemory signal changed so end of frame (when last word is
// written to fifo) is changed.
//
// Revision 1.30  2002/07/23 15:28:31  mohor
// Ram , used for BDs changed from generic_spram to eth_spram_256x32.
//
// Revision 1.29  2002/07/20 00:41:32  mohor
// ShiftEnded synchronization changed.
//
// Revision 1.28  2002/07/18 16:11:46  mohor
// RxBDAddress takes `ETH_TX_BD_NUM_DEF value after reset.
//
// Revision 1.27  2002/07/11 02:53:20  mohor
// RxPointer bug fixed.
//
// Revision 1.26  2002/07/10 13:12:38  mohor
// Previous bug wasn't succesfully removed. Now fixed.
//
// Revision 1.25  2002/07/09 23:53:24  mohor
// Master state machine had a bug when switching from master write to
// master read.
//
// Revision 1.24  2002/07/09 20:44:41  mohor
// m_wb_cyc_o signal released after every single transfer.
//
// Revision 1.23  2002/05/03 10:15:50  mohor
// Outputs registered. Reset changed for eth_wishbone module.
//
// Revision 1.22  2002/04/24 08:52:19  mohor
// Compiler directives added. Tx and Rx fifo size incremented. A "late collision"
// bug fixed.
//
// Revision 1.21  2002/03/29 16:18:11  lampret
// Small typo fixed.
//
// Revision 1.20  2002/03/25 16:19:12  mohor
// Any address can be used for Tx and Rx BD pointers. Address does not need
// to be aligned.
//
// Revision 1.19  2002/03/19 12:51:50  mohor
// Comments in Slovene language removed.
//
// Revision 1.18  2002/03/19 12:46:52  mohor
// casex changed with case, fifo reset changed.
//
// Revision 1.17  2002/03/09 16:08:45  mohor
// rx_fifo was not always cleared ok. Fixed.
//
// Revision 1.16  2002/03/09 13:51:20  mohor
// Status was not latched correctly sometimes. Fixed.
//
// Revision 1.15  2002/03/08 06:56:46  mohor
// Big Endian problem when sending frames fixed.
//
// Revision 1.14  2002/03/02 19:12:40  mohor
// Byte ordering changed (Big Endian used). casex changed with case because
// Xilinx Foundation had problems. Tested in HW. It WORKS.
//
// Revision 1.13  2002/02/26 16:59:55  mohor
// Small fixes for external/internal DMA missmatches.
//
// Revision 1.12  2002/02/26 16:22:07  mohor
// Interrupts changed
//
// Revision 1.11  2002/02/15 17:07:39  mohor
// Status was not written correctly when frames were discarted because of
// address mismatch.
//
// Revision 1.10  2002/02/15 12:17:39  mohor
// RxStartFrm cleared when abort or retry comes.
//
// Revision 1.9  2002/02/15 11:59:10  mohor
// Changes that were lost when updating from 1.5 to 1.8 fixed.
//
// Revision 1.8  2002/02/14 20:54:33  billditt
// Addition  of new module eth_addrcheck.v
//
// Revision 1.7  2002/02/12 17:03:47  mohor
// RxOverRun added to statuses.
//
// Revision 1.6  2002/02/11 09:18:22  mohor
// Tx status is written back to the BD.
//
// Revision 1.5  2002/02/08 16:21:54  mohor
// Rx status is written back to the BD.
//
// Revision 1.4  2002/02/06 14:10:21  mohor
// non-DMA host interface added. Select the right configutation in eth_defines.
//
// Revision 1.3  2002/02/05 16:44:39  mohor
// Both rx and tx part are finished. Tested with wb_clk_i between 10 and 200
// MHz. Statuses, overrun, control frame transmission and reception still  need
// to be fixed.
//
// Revision 1.2  2002/02/01 12:46:51  mohor
// Tx part finished. TxStatus needs to be fixed. Pause request needs to be
// added.
//
// Revision 1.1  2002/01/23 10:47:59  mohor
// Initial version. Equals to eth_wishbonedma.v at this moment.
//
//
//

`include "ethmac_defines.v"
`include "timescale.v"


module eth_wishbone
  (

   // WISHBONE common
   WB_CLK_I, WB_DAT_I, WB_DAT_O, 

   // WISHBONE slave
   WB_ADR_I, WB_WE_I, WB_ACK_O, 
   BDCs, 

   Reset, 

   // WISHBONE master
   m_wb_adr_o, m_wb_sel_o, m_wb_we_o, 
   m_wb_dat_o, m_wb_dat_i, m_wb_cyc_o, 
   m_wb_stb_o, m_wb_ack_i, m_wb_err_i, 

   m_wb_cti_o, m_wb_bte_o, 

   //TX
   MTxClk, TxStartFrm, TxEndFrm, TxUsedData, TxData, 
   TxRetry, TxAbort, TxUnderRun, TxDone, PerPacketCrcEn, 
   PerPacketPad, 

   //RX
   MRxClk, RxData, RxValid, RxStartFrm, RxEndFrm, RxAbort,
   RxStatusWriteLatched_sync2, 
  
   // Register
   r_TxEn, r_RxEn, r_TxBDNum, r_RxFlow, r_PassAll, 

   // Interrupts
   TxB_IRQ, TxE_IRQ, RxB_IRQ, RxE_IRQ, Busy_IRQ, 
  
   // Rx Status
   InvalidSymbol, LatchedCrcError, RxLateCollision, ShortFrame, DribbleNibble,
   ReceivedPacketTooBig, RxLength, LoadRxStatus, ReceivedPacketGood,
   AddressMiss, 
   ReceivedPauseFrm, 
  
   // Tx Status
   RetryCntLatched, RetryLimit, LateCollLatched, DeferLatched, RstDeferLatched,
   CarrierSenseLost

   // Bist
`ifdef ETH_BIST
   ,
   // debug chain signals
   mbist_si_i,       // bist scan serial in
   mbist_so_o,       // bist scan serial out
   mbist_ctrl_i        // bist chain shift control
`endif

`ifdef WISHBONE_DEBUG
   ,
   dbg_dat0
`endif


   );

parameter TX_FIFO_DATA_WIDTH = `ETH_TX_FIFO_DATA_WIDTH;
parameter TX_FIFO_DEPTH      = `ETH_TX_FIFO_DEPTH;
parameter TX_FIFO_CNT_WIDTH  = `ETH_TX_FIFO_CNT_WIDTH;
parameter RX_FIFO_DATA_WIDTH = `ETH_RX_FIFO_DATA_WIDTH;
parameter RX_FIFO_DEPTH      = `ETH_RX_FIFO_DEPTH;
parameter RX_FIFO_CNT_WIDTH  = `ETH_RX_FIFO_CNT_WIDTH;

// WISHBONE common
input           WB_CLK_I;       // WISHBONE clock
input  [31:0]   WB_DAT_I;       // WISHBONE data input
output [31:0]   WB_DAT_O;       // WISHBONE data output

// WISHBONE slave
input   [9:2]   WB_ADR_I;       // WISHBONE address input
input           WB_WE_I;        // WISHBONE write enable input
input   [3:0]   BDCs;           // Buffer descriptors are selected
output          WB_ACK_O;       // WISHBONE acknowledge output

// WISHBONE master
output  [29:0]  m_wb_adr_o;     // 
output   [3:0]  m_wb_sel_o;     // 
output          m_wb_we_o;      // 
output  [31:0]  m_wb_dat_o;     // 
output          m_wb_cyc_o;     // 
output          m_wb_stb_o;     // 
input   [31:0]  m_wb_dat_i;     // 
input           m_wb_ack_i;     // 
input           m_wb_err_i;     // 

output   [2:0]  m_wb_cti_o;     // Cycle Type Identifier
output   [1:0]  m_wb_bte_o;     // Burst Type Extension
reg      [2:0]  m_wb_cti_o;     // Cycle Type Identifier

input           Reset;       // Reset signal

// Rx Status signals
input           InvalidSymbol;    // Invalid symbol was received during reception in 100 Mbps mode
input           LatchedCrcError;  // CRC error
input           RxLateCollision;  // Late collision occured while receiving frame
input           ShortFrame;       // Frame shorter then the minimum size
                                  // (r_MinFL) was received while small
                                  // packets are enabled (r_RecSmall)
input           DribbleNibble;    // Extra nibble received
input           ReceivedPacketTooBig;// Received packet is bigger than r_MaxFL
input    [15:0] RxLength;         // Length of the incoming frame
input           LoadRxStatus;     // Rx status was loaded
input           ReceivedPacketGood;  // Received packet's length and CRC are
                                     // good
input           AddressMiss;      // When a packet is received AddressMiss
                                  // status is written to the Rx BD
input           r_RxFlow;
input           r_PassAll;
input           ReceivedPauseFrm;

// Tx Status signals
input     [3:0] RetryCntLatched;  // Latched Retry Counter
input           RetryLimit;       // Retry limit reached (Retry Max value +1
                                  // attempts were made)
input           LateCollLatched;  // Late collision occured
input           DeferLatched;     // Defer indication (Frame was defered
                                  // before sucessfully sent)
output          RstDeferLatched;
input           CarrierSenseLost; // Carrier Sense was lost during the
                                  // frame transmission

// Tx
input           MTxClk;         // Transmit clock (from PHY)
input           TxUsedData;     // Transmit packet used data
input           TxRetry;        // Transmit packet retry
input           TxAbort;        // Transmit packet abort
input           TxDone;         // Transmission ended
output          TxStartFrm;     // Transmit packet start frame
output          TxEndFrm;       // Transmit packet end frame
output  [7:0]   TxData;         // Transmit packet data byte
output          TxUnderRun;     // Transmit packet under-run
output          PerPacketCrcEn; // Per packet crc enable
output          PerPacketPad;   // Per packet pading

// Rx
input           MRxClk;         // Receive clock (from PHY)
input   [7:0]   RxData;         // Received data byte (from PHY)
input           RxValid;        // 
input           RxStartFrm;     // 
input           RxEndFrm;       // 
input           RxAbort;        // This signal is set when address doesn't
                                // match.
output          RxStatusWriteLatched_sync2;

//Register
input           r_TxEn;         // Transmit enable
input           r_RxEn;         // Receive enable
input   [7:0]   r_TxBDNum;      // Receive buffer descriptor number

// Interrupts
output TxB_IRQ;
output TxE_IRQ;
output RxB_IRQ;
output RxE_IRQ;
output Busy_IRQ;


// Bist
`ifdef ETH_BIST
input   mbist_si_i;       // bist scan serial in
output  mbist_so_o;       // bist scan serial out
input [`ETH_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i; // bist chain shift control
`endif

`ifdef WISHBONE_DEBUG
   output [31:0]                       dbg_dat0;
`endif


reg TxB_IRQ;
reg TxE_IRQ;
reg RxB_IRQ;
reg RxE_IRQ;

reg             TxStartFrm;
reg             TxEndFrm;
reg     [7:0]   TxData;

reg             TxUnderRun;
reg             TxUnderRun_wb;

reg             TxBDRead;
wire            TxStatusWrite;

reg     [1:0]   TxValidBytesLatched;

reg    [15:0]   TxLength;
reg    [15:0]   LatchedTxLength;
reg   [14:11]   TxStatus;

reg   [14:13]   RxStatus;

reg             TxStartFrm_wb;
reg             TxRetry_wb;
reg             TxAbort_wb;
reg             TxDone_wb;

reg             TxDone_wb_q;
reg             TxAbort_wb_q;
reg             TxRetry_wb_q;
reg             TxRetryPacket;
reg             TxRetryPacket_NotCleared;
reg             TxDonePacket;
reg             TxDonePacket_NotCleared;
reg             TxAbortPacket;
reg             TxAbortPacket_NotCleared;
reg             RxBDReady;
reg             RxReady;
reg             TxBDReady;

reg             RxBDRead;

reg    [31:0]   TxDataLatched;
reg     [1:0]   TxByteCnt;
reg             LastWord;
reg             ReadTxDataFromFifo_tck;

reg             BlockingTxStatusWrite;
reg             BlockingTxBDRead;

reg             Flop;

reg     [7:1]   TxBDAddress;
reg     [7:1]   RxBDAddress;

reg             TxRetrySync1;
reg             TxAbortSync1;
reg             TxDoneSync1;

reg             TxAbort_q;
reg             TxRetry_q;
reg             TxUsedData_q;

reg    [31:0]   RxDataLatched2;

reg    [31:8]   RxDataLatched1;     // Big Endian Byte Ordering

reg     [1:0]   RxValidBytes;
reg     [1:0]   RxByteCnt;
reg             LastByteIn;
reg             ShiftWillEnd;

reg             WriteRxDataToFifo;
reg    [15:0]   LatchedRxLength;
reg             RxAbortLatched;

reg             ShiftEnded;
reg             RxOverrun;

reg     [3:0]   BDWrite;                    // BD Write Enable for access from WISHBONE side
reg             BDRead;                     // BD Read access from WISHBONE side
wire   [31:0]   RxBDDataIn;                 // Rx BD data in
wire   [31:0]   TxBDDataIn;                 // Tx BD data in

reg             TxEndFrm_wb;

wire            TxRetryPulse;
wire            TxDonePulse;
wire            TxAbortPulse;

wire            StartRxBDRead;

wire            StartTxBDRead;

wire            TxIRQEn;
wire            WrapTxStatusBit;

wire            RxIRQEn;
wire            WrapRxStatusBit;

wire    [1:0]   TxValidBytes;

wire    [7:1]   TempTxBDAddress;
wire    [7:1]   TempRxBDAddress;

wire            RxStatusWrite;
wire            RxBufferFull;
wire            RxBufferAlmostEmpty;
wire            RxBufferEmpty;

reg             WB_ACK_O;

wire    [8:0]   RxStatusIn;
reg     [8:0]   RxStatusInLatched;

reg WbEn, WbEn_q;
reg RxEn, RxEn_q;
reg TxEn, TxEn_q;
reg r_TxEn_q;
reg r_RxEn_q;

wire ram_ce;
wire [3:0]  ram_we;
wire ram_oe;
reg [7:0]   ram_addr;
reg [31:0]  ram_di;
wire [31:0] ram_do;

wire StartTxPointerRead;
reg TxPointerRead;
reg TxEn_needed;
reg RxEn_needed;

wire StartRxPointerRead;
reg RxPointerRead;

// RX shift ending signals
reg ShiftEnded_rck;
reg ShiftEndedSync1;
reg ShiftEndedSync2;
reg ShiftEndedSync3;
reg ShiftEndedSync_c1;
reg ShiftEndedSync_c2;

wire StartShiftWillEnd;

reg StartOccured;
reg TxStartFrm_sync1;
reg TxStartFrm_sync2;
reg TxStartFrm_syncb1;
reg TxStartFrm_syncb2;

wire TxFifoClear;
wire TxBufferAlmostFull;
wire TxBufferFull;
wire TxBufferEmpty;
wire TxBufferAlmostEmpty;
wire SetReadTxDataFromMemory;
reg BlockReadTxDataFromMemory;

reg tx_burst_en;
reg rx_burst_en;
reg  [`ETH_BURST_CNT_WIDTH-1:0] tx_burst_cnt;

wire ReadTxDataFromMemory_2;
wire tx_burst;

wire [31:0] TxData_wb;
wire ReadTxDataFromFifo_wb;

wire [TX_FIFO_CNT_WIDTH-1:0] txfifo_cnt;
wire [RX_FIFO_CNT_WIDTH-1:0] rxfifo_cnt;

reg  [`ETH_BURST_CNT_WIDTH-1:0] rx_burst_cnt;

wire rx_burst;
wire enough_data_in_rxfifo_for_burst;
wire enough_data_in_rxfifo_for_burst_plus1;

reg ReadTxDataFromMemory;
wire WriteRxDataToMemory;

reg MasterWbTX;
reg MasterWbRX;

reg [29:0] m_wb_adr_o;
reg        m_wb_cyc_o;
reg  [3:0] m_wb_sel_o;
reg        m_wb_we_o;

wire TxLengthEq0;
wire TxLengthLt4;

reg BlockingIncrementTxPointer;
reg [31:2] TxPointerMSB;
reg [1:0]  TxPointerLSB;
reg [1:0]  TxPointerLSB_rst;
reg [31:2] RxPointerMSB;
reg [1:0]  RxPointerLSB_rst;

wire RxBurstAcc;
wire RxWordAcc;
wire RxHalfAcc;
wire RxByteAcc;

wire ResetTxBDReady;
reg BlockingTxStatusWrite_sync1;
reg BlockingTxStatusWrite_sync2;
reg BlockingTxStatusWrite_sync3;

reg cyc_cleared;
reg IncrTxPointer;

reg  [3:0] RxByteSel;
wire MasterAccessFinished;

reg LatchValidBytes;
reg LatchValidBytes_q;

// Start: Generation of the ReadTxDataFromFifo_tck signal and synchronization to the WB_CLK_I
reg ReadTxDataFromFifo_sync1;
reg ReadTxDataFromFifo_sync2;
reg ReadTxDataFromFifo_sync3;
reg ReadTxDataFromFifo_syncb1;
reg ReadTxDataFromFifo_syncb2;
reg ReadTxDataFromFifo_syncb3;

reg RxAbortSync1;
reg RxAbortSync2;
reg RxAbortSync3;
reg RxAbortSync4;
reg RxAbortSyncb1;
reg RxAbortSyncb2;

reg RxEnableWindow;

wire SetWriteRxDataToFifo;

reg WriteRxDataToFifoSync1;
reg WriteRxDataToFifoSync2;
reg WriteRxDataToFifoSync3;

wire WriteRxDataToFifo_wb;

reg LatchedRxStartFrm;
reg SyncRxStartFrm;
reg SyncRxStartFrm_q;
reg SyncRxStartFrm_q2;
wire RxFifoReset;

wire TxError;
wire RxError;

reg RxStatusWriteLatched;
reg RxStatusWriteLatched_sync1;
reg RxStatusWriteLatched_sync2;
reg RxStatusWriteLatched_syncb1;
reg RxStatusWriteLatched_syncb2;

assign m_wb_bte_o = 2'b00;    // Linear burst

assign m_wb_stb_o = m_wb_cyc_o;

always @ (posedge WB_CLK_I)
begin
  WB_ACK_O <= (|BDWrite) & WbEn & WbEn_q | BDRead & WbEn & ~WbEn_q;
end

assign WB_DAT_O = ram_do;

// Generic synchronous single-port RAM interface
eth_spram_256x32
     bd_ram
     (
      .clk     (WB_CLK_I),
      .rst     (Reset),
      .ce      (ram_ce),
      .we      (ram_we),
      .oe      (ram_oe),
      .addr    (ram_addr),
      .di      (ram_di),
      .dato    (ram_do)
`ifdef ETH_BIST
      ,
      .mbist_si_i       (mbist_si_i),
      .mbist_so_o       (mbist_so_o),
      .mbist_ctrl_i       (mbist_ctrl_i)
`endif
      );

assign ram_ce = 1'b1;
assign ram_we = (BDWrite & {4{(WbEn & WbEn_q)}}) |
                {4{(TxStatusWrite | RxStatusWrite)}};
assign ram_oe = BDRead & WbEn & WbEn_q | TxEn & TxEn_q &
                (TxBDRead | TxPointerRead) | RxEn & RxEn_q &
                (RxBDRead | RxPointerRead);


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxEn_needed <= 1'b0;
  else
  if(~TxBDReady & r_TxEn & WbEn & ~WbEn_q)
    TxEn_needed <= 1'b1;
  else
  if(TxPointerRead & TxEn & TxEn_q)
    TxEn_needed <= 1'b0;
end

// Enabling access to the RAM for three devices.
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    begin
      WbEn <= 1'b1;
      RxEn <= 1'b0;
      TxEn <= 1'b0;
      ram_addr <= 8'h0;
      ram_di <= 32'h0;
      BDRead <= 1'b0;
      BDWrite <= 0;
    end
  else
    begin
      // Switching between three stages depends on enable signals
     /* verilator lint_off CASEINCOMPLETE */ // JB
      case ({WbEn_q, RxEn_q, TxEn_q, RxEn_needed, TxEn_needed})  /*// synopsys parallel_case*/
        5'b100_10, 5'b100_11 :
          begin
            WbEn <= 1'b0;
            RxEn <= 1'b1;  // wb access stage and r_RxEn is enabled
            TxEn <= 1'b0;
            ram_addr <= {RxBDAddress, RxPointerRead};
            ram_di <= RxBDDataIn;
          end
        5'b100_01 :
          begin
            WbEn <= 1'b0;
            RxEn <= 1'b0;
            TxEn <= 1'b1;  // wb access stage, r_RxEn is disabled but
                           // r_TxEn is enabled
            ram_addr <= {TxBDAddress, TxPointerRead};
            ram_di <= TxBDDataIn;
          end
        5'b010_00, 5'b010_10 :
          begin
            WbEn <= 1'b1;  // RxEn access stage and r_TxEn is disabled
            RxEn <= 1'b0;
            TxEn <= 1'b0;
            ram_addr <= WB_ADR_I[9:2];
            ram_di <= WB_DAT_I;
            BDWrite <= BDCs[3:0] & {4{WB_WE_I}};
            BDRead <= (|BDCs) & ~WB_WE_I;
          end
        5'b010_01, 5'b010_11 :
          begin
            WbEn <= 1'b0;
            RxEn <= 1'b0;
            TxEn <= 1'b1;  // RxEn access stage and r_TxEn is enabled
            ram_addr <= {TxBDAddress, TxPointerRead};
            ram_di <= TxBDDataIn;
          end
        5'b001_00, 5'b001_01, 5'b001_10, 5'b001_11 :
          begin
            WbEn <= 1'b1;  // TxEn access stage (we always go to wb
                           // access stage)
            RxEn <= 1'b0;
            TxEn <= 1'b0;
            ram_addr <= WB_ADR_I[9:2];
            ram_di <= WB_DAT_I;
            BDWrite <= BDCs[3:0] & {4{WB_WE_I}};
            BDRead <= (|BDCs) & ~WB_WE_I;
          end
        5'b100_00 :
          begin
            WbEn <= 1'b0;  // WbEn access stage and there is no need
                           // for other stages. WbEn needs to be
                           // switched off for a bit
          end
        5'b000_00 :
          begin
            WbEn <= 1'b1;  // Idle state. We go to WbEn access stage.
            RxEn <= 1'b0;
            TxEn <= 1'b0;
            ram_addr <= WB_ADR_I[9:2];
            ram_di <= WB_DAT_I;
            BDWrite <= BDCs[3:0] & {4{WB_WE_I}};
            BDRead <= (|BDCs) & ~WB_WE_I;
          end
      endcase
      /* verilator lint_on CASEINCOMPLETE */
    end
end


// Delayed stage signals
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    begin
      WbEn_q <= 1'b0;
      RxEn_q <= 1'b0;
      TxEn_q <= 1'b0;
      r_TxEn_q <= 1'b0;
      r_RxEn_q <= 1'b0;
    end
  else
    begin
      WbEn_q <= WbEn;
      RxEn_q <= RxEn;
      TxEn_q <= TxEn;
      r_TxEn_q <= r_TxEn;
      r_RxEn_q <= r_RxEn;
    end
end

// Changes for tx occur every second clock. Flop is used for this manner.
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    Flop <= 1'b0;
  else
  if(TxDone | TxAbort | TxRetry_q)
    Flop <= 1'b0;
  else
  if(TxUsedData)
    Flop <= ~Flop;
end

assign ResetTxBDReady = TxDonePulse | TxAbortPulse | TxRetryPulse;

// Latching READY status of the Tx buffer descriptor
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxBDReady <= 1'b0;
  else
  if(TxEn & TxEn_q & TxBDRead)
    // TxBDReady is sampled only once at the beginning.
    TxBDReady <= ram_do[15] & (ram_do[31:16] > 4);
  else
  // Only packets larger then 4 bytes are transmitted.
  if(ResetTxBDReady)
    TxBDReady <= 1'b0;
end

// Reading the Tx buffer descriptor
assign StartTxBDRead = (TxRetryPacket_NotCleared | TxStatusWrite) &
                       ~BlockingTxBDRead & ~TxBDReady;

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxBDRead <= 1'b1;
  else
  if(StartTxBDRead)
    TxBDRead <= 1'b1;
  else
  if(TxBDReady)
    TxBDRead <= 1'b0;
end

// Reading Tx BD pointer
assign StartTxPointerRead = TxBDRead & TxBDReady;

// Reading Tx BD Pointer
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxPointerRead <= 1'b0;
  else
  if(StartTxPointerRead)
    TxPointerRead <= 1'b1;
  else
  if(TxEn_q)
    TxPointerRead <= 1'b0;
end


// Writing status back to the Tx buffer descriptor
assign TxStatusWrite = (TxDonePacket_NotCleared | TxAbortPacket_NotCleared) &
                       TxEn & TxEn_q & ~BlockingTxStatusWrite;


// Status writing must occur only once. Meanwhile it is blocked.
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    BlockingTxStatusWrite <= 1'b0;
  else
  if(~TxDone_wb & ~TxAbort_wb)
    BlockingTxStatusWrite <= 1'b0;
  else
  if(TxStatusWrite)
    BlockingTxStatusWrite <= 1'b1;
end


// Synchronizing BlockingTxStatusWrite to MTxClk
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    BlockingTxStatusWrite_sync1 <= 1'b0;
  else
    BlockingTxStatusWrite_sync1 <= BlockingTxStatusWrite;
end

// Synchronizing BlockingTxStatusWrite to MTxClk
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    BlockingTxStatusWrite_sync2 <= 1'b0;
  else
    BlockingTxStatusWrite_sync2 <= BlockingTxStatusWrite_sync1;
end

// Synchronizing BlockingTxStatusWrite to MTxClk
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    BlockingTxStatusWrite_sync3 <= 1'b0;
  else
    BlockingTxStatusWrite_sync3 <= BlockingTxStatusWrite_sync2;
end

assign RstDeferLatched = BlockingTxStatusWrite_sync2 &
                         ~BlockingTxStatusWrite_sync3;

// TxBDRead state is activated only once. 
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    BlockingTxBDRead <= 1'b0;
  else
  if(StartTxBDRead)
    BlockingTxBDRead <= 1'b1;
  else
  if(~StartTxBDRead & ~TxBDReady)
    BlockingTxBDRead <= 1'b0;
end


// Latching status from the tx buffer descriptor
// Data is avaliable one cycle after the access is started (at that time
// signal TxEn is not active)
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxStatus <= 4'h0;
  else
  if(TxEn & TxEn_q & TxBDRead)
    TxStatus <= ram_do[14:11];
end



//Latching length from the buffer descriptor;
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxLength <= 16'h0;
  else
  if(TxEn & TxEn_q & TxBDRead)
    TxLength <= ram_do[31:16];
  else
  if(MasterWbTX & m_wb_ack_i)
    begin
      if(TxLengthLt4)
        TxLength <= 16'h0;
      else if(TxPointerLSB_rst==2'h0)
        TxLength <= TxLength - 16'd4;    // Length is subtracted at
                                        // the data request
      else if(TxPointerLSB_rst==2'h1)
        TxLength <= TxLength - 16'd3;    // Length is subtracted
                                         // at the data request
      else if(TxPointerLSB_rst==2'h2)
        TxLength <= TxLength - 16'd2;    // Length is subtracted
                                         // at the data request
      else if(TxPointerLSB_rst==2'h3)
        TxLength <= TxLength - 16'd1;    // Length is subtracted
                                         // at the data request
    end
end

//Latching length from the buffer descriptor;
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    LatchedTxLength <= 16'h0;
  else
  if(TxEn & TxEn_q & TxBDRead)
    LatchedTxLength <= ram_do[31:16];
end

assign TxLengthEq0 = TxLength == 0;
assign TxLengthLt4 = TxLength < 4;


// Latching Tx buffer pointer from buffer descriptor. Only 30 MSB bits are
// latched because TxPointerMSB is only used for word-aligned accesses.
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxPointerMSB <= 30'h0;
  else
  if(TxEn & TxEn_q & TxPointerRead)
    TxPointerMSB <= ram_do[31:2];
  else
  if(IncrTxPointer & ~BlockingIncrementTxPointer)
      // TxPointer is word-aligned
    TxPointerMSB <= TxPointerMSB + 1'b1;
end


// Latching 2 MSB bits of the buffer descriptor. Since word accesses are
// performed, valid data does not necesserly start at byte 0 (could be byte
// 0, 1, 2 or 3). This signals are used for proper selection of the start
// byte (TxData and TxByteCnt) are set by this two bits.
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxPointerLSB[1:0] <= 0;
  else
  if(TxEn & TxEn_q & TxPointerRead)
    TxPointerLSB[1:0] <= ram_do[1:0];
end


// Latching 2 MSB bits of the buffer descriptor. 
// After the read access, TxLength needs to be decremented for the number of
// the valid bytes (1 to 4 bytes are valid in the first word). After the
// first read all bytes are valid so this two bits are reset to zero. 
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxPointerLSB_rst[1:0] <= 0;
  else
  if(TxEn & TxEn_q & TxPointerRead)
    TxPointerLSB_rst[1:0] <= ram_do[1:0];
  else
// After first access pointer is word alligned
  if(MasterWbTX & m_wb_ack_i)
    TxPointerLSB_rst[1:0] <= 0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    BlockingIncrementTxPointer <= 0;
  else
  if(MasterAccessFinished)
    BlockingIncrementTxPointer <= 0;
  else
  if(IncrTxPointer)
    BlockingIncrementTxPointer <= 1'b1;
end


assign SetReadTxDataFromMemory = TxEn & TxEn_q & TxPointerRead;

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromMemory <= 1'b0;
  else
  if(TxLengthEq0 | TxAbortPulse | TxRetryPulse)
    ReadTxDataFromMemory <= 1'b0;
  else
  if(SetReadTxDataFromMemory)
    ReadTxDataFromMemory <= 1'b1;
end

assign ReadTxDataFromMemory_2 = ReadTxDataFromMemory &
                                ~BlockReadTxDataFromMemory;

assign tx_burst = ReadTxDataFromMemory_2 & tx_burst_en;

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    BlockReadTxDataFromMemory <= 1'b0;
  else
  if((TxBufferAlmostFull | TxLength <= 4) & MasterWbTX & (~cyc_cleared) &
     (!(TxAbortPacket_NotCleared | TxRetryPacket_NotCleared)))
    BlockReadTxDataFromMemory <= 1'b1;
  else
  if(ReadTxDataFromFifo_wb | TxDonePacket | TxAbortPacket | TxRetryPacket)
    BlockReadTxDataFromMemory <= 1'b0;
end


assign MasterAccessFinished = m_wb_ack_i | m_wb_err_i;

// Enabling master wishbone access to the memory for two devices TX and RX.
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    begin
      MasterWbTX <= 1'b0;
      MasterWbRX <= 1'b0;
      m_wb_adr_o <= 30'h0;
      m_wb_cyc_o <= 1'b0;
      m_wb_we_o  <= 1'b0;
      m_wb_sel_o <= 4'h0;
      cyc_cleared<= 1'b0;
      tx_burst_cnt<= 0;
      rx_burst_cnt<= 0;
      IncrTxPointer<= 1'b0;
      tx_burst_en<= 1'b1;
      rx_burst_en<= 1'b0;
      m_wb_cti_o <= 3'b0;
    end
  else
    begin
      // Switching between two stages depends on enable signals
      casez ({MasterWbTX,
             MasterWbRX,
             ReadTxDataFromMemory_2,
             WriteRxDataToMemory,
             MasterAccessFinished,
             cyc_cleared,
             tx_burst,
             rx_burst})  /*// synopsys parallel_case*/

        8'b00_10_00_10, // Idle and MRB needed
        8'b10_1?_10_1?, // MRB continues
        8'b10_10_01_10, // Clear (previously MR) and MRB needed
        8'b01_1?_01_1?: // Clear (previously MW) and MRB needed
          begin
            MasterWbTX <= 1'b1;  // tx burst
            MasterWbRX <= 1'b0;
            m_wb_cyc_o <= 1'b1;
            m_wb_we_o  <= 1'b0;
            m_wb_sel_o <= 4'hf;
            cyc_cleared<= 1'b0;
            IncrTxPointer<= 1'b1;
            tx_burst_cnt <= tx_burst_cnt+3'h1;
            if(tx_burst_cnt==0)
              m_wb_adr_o <= TxPointerMSB;
            else
              m_wb_adr_o <= m_wb_adr_o + 1'b1;
            if(tx_burst_cnt==(`ETH_BURST_LENGTH-1))
              begin
                tx_burst_en<= 1'b0;
                m_wb_cti_o <= 3'b111;
              end
            else
              begin
                m_wb_cti_o <= 3'b010;
              end
          end
        8'b00_?1_00_?1,             // Idle and MWB needed
        8'b01_?1_10_?1,             // MWB continues
        8'b01_01_01_01,             // Clear (previously MW) and MWB needed
        8'b10_?1_01_?1 :            // Clear (previously MR) and MWB needed
          begin
            MasterWbTX <= 1'b0;  // rx burst
            MasterWbRX <= 1'b1;
            m_wb_cyc_o <= 1'b1;
            m_wb_we_o  <= 1'b1;
            m_wb_sel_o <= RxByteSel;
            IncrTxPointer<= 1'b0;
            cyc_cleared<= 1'b0;
            rx_burst_cnt <= rx_burst_cnt+3'h1;

            if(rx_burst_cnt==0)
              m_wb_adr_o <= RxPointerMSB;
            else
              m_wb_adr_o <= m_wb_adr_o+1'b1;

            if(rx_burst_cnt==(`ETH_BURST_LENGTH-1))
              begin
                rx_burst_en<= 1'b0;
                m_wb_cti_o <= 3'b111;
              end
            else
              begin
                m_wb_cti_o <= 3'b010;
              end
          end
        8'b00_?1_00_?0 :// idle and MW is needed (data write to rx buffer)
          begin
            MasterWbTX <= 1'b0;
            MasterWbRX <= 1'b1;
            m_wb_adr_o <= RxPointerMSB;
            m_wb_cyc_o <= 1'b1;
            m_wb_we_o  <= 1'b1;
            m_wb_sel_o <= RxByteSel;
            IncrTxPointer<= 1'b0;
          end
        8'b00_10_00_00 : // idle and MR is needed (data read from tx buffer)
          begin
            MasterWbTX <= 1'b1;
            MasterWbRX <= 1'b0;
            m_wb_adr_o <= TxPointerMSB;
            m_wb_cyc_o <= 1'b1;
            m_wb_we_o  <= 1'b0;
            m_wb_sel_o <= 4'hf;
            IncrTxPointer<= 1'b1;
          end
        8'b10_10_01_00,// MR and MR is needed (data read from tx buffer)
        8'b01_1?_01_0?  :// MW and MR is needed (data read from tx buffer)
          begin
            MasterWbTX <= 1'b1;
            MasterWbRX <= 1'b0;
            m_wb_adr_o <= TxPointerMSB;
            m_wb_cyc_o <= 1'b1;
            m_wb_we_o  <= 1'b0;
            m_wb_sel_o <= 4'hf;
            cyc_cleared<= 1'b0;
            IncrTxPointer<= 1'b1;
          end
        8'b01_01_01_00,// MW and MW needed (data write to rx buffer)
        8'b10_?1_01_?0 :// MR and MW is needed (data write to rx buffer)
          begin
            MasterWbTX <= 1'b0;
            MasterWbRX <= 1'b1;
            m_wb_adr_o <= RxPointerMSB;
            m_wb_cyc_o <= 1'b1;
            m_wb_we_o  <= 1'b1;
            m_wb_sel_o <= RxByteSel;
            cyc_cleared<= 1'b0;
            IncrTxPointer<= 1'b0;
          end
        8'b01_01_10_00,// MW and MW needed (cycle is cleared between
                      // previous and next access)
        8'b01_1?_10_?0,// MW and MW or MR or MRB needed (cycle is
                    // cleared between previous and next access)
        8'b10_10_10_00,// MR and MR needed (cycle is cleared between
                       // previous and next access)
        8'b10_?1_10_0? :// MR and MR or MW or MWB (cycle is cleared
                       // between previous and next access)
          begin
            m_wb_cyc_o <= 1'b0;// whatever and master read or write is
                               // needed. We need to clear m_wb_cyc_o
                               // before next access is started
            cyc_cleared<= 1'b1;
            IncrTxPointer<= 1'b0;
            tx_burst_cnt<= 0;
            tx_burst_en<= txfifo_cnt<(TX_FIFO_DEPTH-`ETH_BURST_LENGTH) & (TxLength>(`ETH_BURST_LENGTH*4+4));
            rx_burst_cnt<= 0;
            rx_burst_en<= MasterWbRX ? enough_data_in_rxfifo_for_burst_plus1 : enough_data_in_rxfifo_for_burst;  // Counter is not decremented, yet, so plus1 is used.
              m_wb_cti_o <= 3'b0;
          end
        8'b??_00_10_00,// whatever and no master read or write is needed
                       // (ack or err comes finishing previous access)
        8'b??_00_01_00 : // Between cyc_cleared request was cleared
          begin
            MasterWbTX <= 1'b0;
            MasterWbRX <= 1'b0;
            m_wb_cyc_o <= 1'b0;
            cyc_cleared<= 1'b0;
            IncrTxPointer<= 1'b0;
            rx_burst_cnt<= 0;
            // Counter is not decremented, yet, so plus1 is used.
            rx_burst_en<= MasterWbRX ? enough_data_in_rxfifo_for_burst_plus1 :
                                       enough_data_in_rxfifo_for_burst;
            m_wb_cti_o <= 3'b0;
          end
        8'b00_00_00_00:  // whatever and no master read or write is needed
                         // (ack or err comes finishing previous access)
          begin
            tx_burst_cnt<= 0;
            tx_burst_en<= txfifo_cnt<(TX_FIFO_DEPTH-`ETH_BURST_LENGTH) & (TxLength>(`ETH_BURST_LENGTH*4+4));
          end
        default:                    // Don't touch
          begin
            MasterWbTX <= MasterWbTX;
            MasterWbRX <= MasterWbRX;
            m_wb_cyc_o <= m_wb_cyc_o;
            m_wb_sel_o <= m_wb_sel_o;
            IncrTxPointer<= IncrTxPointer;
          end
      endcase
    end
end

assign TxFifoClear = (TxAbortPacket | TxRetryPacket);

eth_fifo
     #(
       .DATA_WIDTH(TX_FIFO_DATA_WIDTH),
       .DEPTH(TX_FIFO_DEPTH),
       .CNT_WIDTH(TX_FIFO_CNT_WIDTH))
tx_fifo (
       .data_in(m_wb_dat_i),
       .data_out(TxData_wb),
       .clk(WB_CLK_I),
       .reset(Reset),
       .write(MasterWbTX & m_wb_ack_i),
       .read(ReadTxDataFromFifo_wb & ~TxBufferEmpty),
       .clear(TxFifoClear),
       .full(TxBufferFull), 
       .almost_full(TxBufferAlmostFull),
       .almost_empty(TxBufferAlmostEmpty),
       .empty(TxBufferEmpty),
       .cnt(txfifo_cnt)
       );

// Start: Generation of the TxStartFrm_wb which is then synchronized to the
// MTxClk
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxStartFrm_wb <= 1'b0;
  else
  if(TxBDReady & ~StartOccured & (TxBufferFull | TxLengthEq0))
    TxStartFrm_wb <= 1'b1;
  else
  if(TxStartFrm_syncb2)
    TxStartFrm_wb <= 1'b0;
end

// StartOccured: TxStartFrm_wb occurs only ones at the beginning. Then it's
// blocked.
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    StartOccured <= 1'b0;
  else
  if(TxStartFrm_wb)
    StartOccured <= 1'b1;
  else
  if(ResetTxBDReady)
    StartOccured <= 1'b0;
end

// Synchronizing TxStartFrm_wb to MTxClk
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxStartFrm_sync1 <= 1'b0;
  else
    TxStartFrm_sync1 <= TxStartFrm_wb;
end

always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxStartFrm_sync2 <= 1'b0;
  else
    TxStartFrm_sync2 <= TxStartFrm_sync1;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxStartFrm_syncb1 <= 1'b0;
  else
    TxStartFrm_syncb1 <= TxStartFrm_sync2;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxStartFrm_syncb2 <= 1'b0;
  else
    TxStartFrm_syncb2 <= TxStartFrm_syncb1;
end

always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxStartFrm <= 1'b0;
  else
  if(TxStartFrm_sync2)
    TxStartFrm <= 1'b1;
  else
  if(TxUsedData_q | ~TxStartFrm_sync2 &
     (TxRetry & (~TxRetry_q) | TxAbort & (~TxAbort_q)))
    TxStartFrm <= 1'b0;
end
// End: Generation of the TxStartFrm_wb which is then synchronized to the
// MTxClk


// TxEndFrm_wb: indicator of the end of frame
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxEndFrm_wb <= 1'b0;
  else
  if(TxLengthEq0 & TxBufferAlmostEmpty & TxUsedData)
    TxEndFrm_wb <= 1'b1;
  else
  if(TxRetryPulse | TxDonePulse | TxAbortPulse)
    TxEndFrm_wb <= 1'b0;
end

// Marks which bytes are valid within the word.
assign TxValidBytes = TxLengthLt4 ? TxLength[1:0] : 2'b0;


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    LatchValidBytes <= 1'b0;
  else
  if(TxLengthLt4 & TxBDReady)
    LatchValidBytes <= 1'b1;
  else
    LatchValidBytes <= 1'b0;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    LatchValidBytes_q <= 1'b0;
  else
    LatchValidBytes_q <= LatchValidBytes;
end


// Latching valid bytes
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxValidBytesLatched <= 2'h0;
  else
  if(LatchValidBytes & ~LatchValidBytes_q)
    TxValidBytesLatched <= TxValidBytes;
  else
  if(TxRetryPulse | TxDonePulse | TxAbortPulse)
    TxValidBytesLatched <= 2'h0;
end


assign TxIRQEn          = TxStatus[14];
assign WrapTxStatusBit  = TxStatus[13];
assign PerPacketPad     = TxStatus[12];
assign PerPacketCrcEn   = TxStatus[11];


assign RxIRQEn         = RxStatus[14];
assign WrapRxStatusBit = RxStatus[13];


// Temporary Tx and Rx buffer descriptor address
assign TempTxBDAddress[7:1] = {7{ TxStatusWrite  & ~WrapTxStatusBit}} &
                              (TxBDAddress + 1'b1); // Tx BD increment or wrap
                                                    // (last BD)

assign TempRxBDAddress[7:1] = 
  {7{ WrapRxStatusBit}} & (r_TxBDNum[6:0]) | // Using first Rx BD
  {7{~WrapRxStatusBit}} & (RxBDAddress + 1'b1); // Using next Rx BD
                                                // (increment address)

// Latching Tx buffer descriptor address
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxBDAddress <= 7'h0;
  else if (r_TxEn & (~r_TxEn_q))
    TxBDAddress <= 7'h0;
  else if (TxStatusWrite)
    TxBDAddress <= TempTxBDAddress;
end

// Latching Rx buffer descriptor address
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxBDAddress <= 7'h0;
  else if(r_RxEn & (~r_RxEn_q))
    RxBDAddress <= r_TxBDNum[6:0];
  else if(RxStatusWrite)
    RxBDAddress <= TempRxBDAddress;
end

wire [8:0] TxStatusInLatched = {TxUnderRun, RetryCntLatched[3:0],
                                RetryLimit, LateCollLatched, DeferLatched,
                                CarrierSenseLost};

assign RxBDDataIn = {LatchedRxLength, 1'b0, RxStatus, 4'h0, RxStatusInLatched};
assign TxBDDataIn = {LatchedTxLength, 1'b0, TxStatus, 2'h0, TxStatusInLatched};


// Signals used for various purposes
assign TxRetryPulse   = TxRetry_wb   & ~TxRetry_wb_q;
assign TxDonePulse    = TxDone_wb    & ~TxDone_wb_q;
assign TxAbortPulse   = TxAbort_wb   & ~TxAbort_wb_q;


// Generating delayed signals
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    begin
      TxAbort_q      <= 1'b0;
      TxRetry_q      <= 1'b0;
      TxUsedData_q   <= 1'b0;
    end
  else
    begin
      TxAbort_q      <= TxAbort;
      TxRetry_q      <= TxRetry;
      TxUsedData_q   <= TxUsedData;
    end
end

// Generating delayed signals
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    begin
      TxDone_wb_q   <= 1'b0;
      TxAbort_wb_q  <= 1'b0;
      TxRetry_wb_q  <= 1'b0;
    end
  else
    begin
      TxDone_wb_q   <= TxDone_wb;
      TxAbort_wb_q  <= TxAbort_wb;
      TxRetry_wb_q  <= TxRetry_wb;
    end
end


reg TxAbortPacketBlocked;
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxAbortPacket <= 1'b0;
  else
  if(TxAbort_wb & (~tx_burst_en) & MasterWbTX & MasterAccessFinished &
    (~TxAbortPacketBlocked) | TxAbort_wb & (~MasterWbTX) &
    (~TxAbortPacketBlocked))
    TxAbortPacket <= 1'b1;
  else
    TxAbortPacket <= 1'b0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxAbortPacket_NotCleared <= 1'b0;
  else
  if(TxEn & TxEn_q & TxAbortPacket_NotCleared)
    TxAbortPacket_NotCleared <= 1'b0;
  else
  if(TxAbort_wb & (~tx_burst_en) & MasterWbTX & MasterAccessFinished &
     (~TxAbortPacketBlocked) | TxAbort_wb & (~MasterWbTX) &
     (~TxAbortPacketBlocked))
    TxAbortPacket_NotCleared <= 1'b1;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxAbortPacketBlocked <= 1'b0;
  else
  if(!TxAbort_wb & TxAbort_wb_q)
    TxAbortPacketBlocked <= 1'b0;
  else
  if(TxAbortPacket)
    TxAbortPacketBlocked <= 1'b1;
end


reg TxRetryPacketBlocked;
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxRetryPacket <= 1'b0;
  else
  if(TxRetry_wb & !tx_burst_en & MasterWbTX & MasterAccessFinished &
     !TxRetryPacketBlocked | TxRetry_wb & !MasterWbTX & !TxRetryPacketBlocked)
    TxRetryPacket <= 1'b1;
  else
    TxRetryPacket <= 1'b0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxRetryPacket_NotCleared <= 1'b0;
  else
  if(StartTxBDRead)
    TxRetryPacket_NotCleared <= 1'b0;
  else
  if(TxRetry_wb & !tx_burst_en & MasterWbTX & MasterAccessFinished &
     !TxRetryPacketBlocked | TxRetry_wb & !MasterWbTX & !TxRetryPacketBlocked)
    TxRetryPacket_NotCleared <= 1'b1;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxRetryPacketBlocked <= 1'b0;
  else
  if(!TxRetry_wb & TxRetry_wb_q)
    TxRetryPacketBlocked <= 1'b0;
  else
  if(TxRetryPacket)
    TxRetryPacketBlocked <= 1'b1;
end


reg TxDonePacketBlocked;
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxDonePacket <= 1'b0;
  else
  if(TxDone_wb & !tx_burst_en & MasterWbTX & MasterAccessFinished &
     !TxDonePacketBlocked | TxDone_wb & !MasterWbTX & !TxDonePacketBlocked)
    TxDonePacket <= 1'b1;
  else
    TxDonePacket <= 1'b0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxDonePacket_NotCleared <= 1'b0;
  else
  if(TxEn & TxEn_q & TxDonePacket_NotCleared)
    TxDonePacket_NotCleared <= 1'b0;
  else
  if(TxDone_wb & !tx_burst_en & MasterWbTX & MasterAccessFinished &
     (~TxDonePacketBlocked) | TxDone_wb & !MasterWbTX & (~TxDonePacketBlocked))
    TxDonePacket_NotCleared <= 1'b1;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxDonePacketBlocked <= 1'b0;
  else
  if(!TxDone_wb & TxDone_wb_q)
    TxDonePacketBlocked <= 1'b0;
  else
  if(TxDonePacket)
    TxDonePacketBlocked <= 1'b1;
end


// Indication of the last word
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    LastWord <= 1'b0;
  else
  if((TxEndFrm | TxAbort | TxRetry) & Flop)
    LastWord <= 1'b0;
  else
  if(TxUsedData & Flop & TxByteCnt == 2'h3)
    LastWord <= TxEndFrm_wb;
end


// Tx end frame generation
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxEndFrm <= 1'b0;
  else
  if(Flop & TxEndFrm | TxAbort | TxRetry_q)
    TxEndFrm <= 1'b0;        
  else
  if(Flop & LastWord)
    begin
      case (TxValidBytesLatched)  /*// synopsys parallel_case*/
        1 : TxEndFrm <= TxByteCnt == 2'h0;
        2 : TxEndFrm <= TxByteCnt == 2'h1;
        3 : TxEndFrm <= TxByteCnt == 2'h2;
        0 : TxEndFrm <= TxByteCnt == 2'h3;
        default : TxEndFrm <= 1'b0;
      endcase
    end
end


// Tx data selection (latching)
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxData <= 0;
  else
  if(TxStartFrm_sync2 & ~TxStartFrm)
    case(TxPointerLSB)  /*// synopsys parallel_case*/
      2'h0 : TxData <= TxData_wb[31:24];// Big Endian Byte Ordering
      2'h1 : TxData <= TxData_wb[23:16];// Big Endian Byte Ordering
      2'h2 : TxData <= TxData_wb[15:08];// Big Endian Byte Ordering
      2'h3 : TxData <= TxData_wb[07:00];// Big Endian Byte Ordering
    endcase
  else
  if(TxStartFrm & TxUsedData & TxPointerLSB==2'h3)
    TxData <= TxData_wb[31:24];// Big Endian Byte Ordering
  else
  if(TxUsedData & Flop)
    begin
      case(TxByteCnt)  /*// synopsys parallel_case*/
        0 : TxData <= TxDataLatched[31:24];// Big Endian Byte Ordering
        1 : TxData <= TxDataLatched[23:16];
        2 : TxData <= TxDataLatched[15:8];
        3 : TxData <= TxDataLatched[7:0];
      endcase
    end
end


// Latching tx data
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxDataLatched[31:0] <= 32'h0;
  else
  if(TxStartFrm_sync2 & ~TxStartFrm | TxUsedData & Flop & TxByteCnt == 2'h3 |
     TxStartFrm & TxUsedData & Flop & TxByteCnt == 2'h0)
    TxDataLatched[31:0] <= TxData_wb[31:0];
end


// Tx under run
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxUnderRun_wb <= 1'b0;
  else
  if(TxAbortPulse)
    TxUnderRun_wb <= 1'b0;
  else
  if(TxBufferEmpty & ReadTxDataFromFifo_wb)
    TxUnderRun_wb <= 1'b1;
end


reg TxUnderRun_sync1;

// Tx under run
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxUnderRun_sync1 <= 1'b0;
  else
  if(TxUnderRun_wb)
    TxUnderRun_sync1 <= 1'b1;
  else
  if(BlockingTxStatusWrite_sync2)
    TxUnderRun_sync1 <= 1'b0;
end

// Tx under run
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxUnderRun <= 1'b0;
  else
  if(BlockingTxStatusWrite_sync2)
    TxUnderRun <= 1'b0;
  else
  if(TxUnderRun_sync1)
    TxUnderRun <= 1'b1;
end


// Tx Byte counter
always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    TxByteCnt <= 2'h0;
  else
  if(TxAbort_q | TxRetry_q)
    TxByteCnt <= 2'h0;
  else
  if(TxStartFrm & ~TxUsedData)
    case(TxPointerLSB)  /*// synopsys parallel_case*/
      2'h0 : TxByteCnt <= 2'h1;
      2'h1 : TxByteCnt <= 2'h2;
      2'h2 : TxByteCnt <= 2'h3;
      2'h3 : TxByteCnt <= 2'h0;
    endcase
  else
  if(TxUsedData & Flop)
    TxByteCnt <= TxByteCnt + 1'b1;
end


always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_tck <= 1'b0;
  else
  if(TxStartFrm_sync2 & ~TxStartFrm | TxUsedData & Flop & TxByteCnt == 2'h3 &
     ~LastWord | TxStartFrm & TxUsedData & Flop & TxByteCnt == 2'h0)
     ReadTxDataFromFifo_tck <= 1'b1;
  else
  if(ReadTxDataFromFifo_syncb2 & ~ReadTxDataFromFifo_syncb3)
    ReadTxDataFromFifo_tck <= 1'b0;
end

// Synchronizing TxStartFrm_wb to MTxClk
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_sync1 <= 1'b0;
  else
    ReadTxDataFromFifo_sync1 <= ReadTxDataFromFifo_tck;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_sync2 <= 1'b0;
  else
    ReadTxDataFromFifo_sync2 <= ReadTxDataFromFifo_sync1;
end

always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_syncb1 <= 1'b0;
  else
    ReadTxDataFromFifo_syncb1 <= ReadTxDataFromFifo_sync2;
end

always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_syncb2 <= 1'b0;
  else
    ReadTxDataFromFifo_syncb2 <= ReadTxDataFromFifo_syncb1;
end

always @ (posedge MTxClk or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_syncb3 <= 1'b0;
  else
    ReadTxDataFromFifo_syncb3 <= ReadTxDataFromFifo_syncb2;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ReadTxDataFromFifo_sync3 <= 1'b0;
  else
    ReadTxDataFromFifo_sync3 <= ReadTxDataFromFifo_sync2;
end

assign ReadTxDataFromFifo_wb = ReadTxDataFromFifo_sync2 &
                               ~ReadTxDataFromFifo_sync3;
// End: Generation of the ReadTxDataFromFifo_tck signal and synchronization
// to the WB_CLK_I


// Synchronizing TxRetry signal (synchronized to WISHBONE clock)
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxRetrySync1 <= 1'b0;
  else
    TxRetrySync1 <= TxRetry;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxRetry_wb <= 1'b0;
  else
    TxRetry_wb <= TxRetrySync1;
end


// Synchronized TxDone_wb signal (synchronized to WISHBONE clock)
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxDoneSync1 <= 1'b0;
  else
    TxDoneSync1 <= TxDone;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxDone_wb <= 1'b0;
  else
    TxDone_wb <= TxDoneSync1;
end

// Synchronizing TxAbort signal (synchronized to WISHBONE clock)
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxAbortSync1 <= 1'b0;
  else
    TxAbortSync1 <= TxAbort;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxAbort_wb <= 1'b0;
  else
    TxAbort_wb <= TxAbortSync1;
end


assign StartRxBDRead = RxStatusWrite | RxAbortSync3 & ~RxAbortSync4 |
                       r_RxEn & ~r_RxEn_q;

// Reading the Rx buffer descriptor
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxBDRead <= 1'b0;
  else
  if(StartRxBDRead & ~RxReady)
    RxBDRead <= 1'b1;
  else
  if(RxBDReady)
    RxBDRead <= 1'b0;
end


// Reading of the next receive buffer descriptor starts after reception status
// is written to the previous one.

// Latching READY status of the Rx buffer descriptor
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxBDReady <= 1'b0;
  else
  if(RxPointerRead)
    RxBDReady <= 1'b0;
  else
  if(RxEn & RxEn_q & RxBDRead)
    RxBDReady <= ram_do[15];// RxBDReady is sampled only once at the beginning
end

// Latching Rx buffer descriptor status
// Data is avaliable one cycle after the access is started (at that time
// signal RxEn is not active)
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxStatus <= 2'h0;
  else
  if(RxEn & RxEn_q & RxBDRead)
    RxStatus <= ram_do[14:13];
end


// RxReady generation
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxReady <= 1'b0;
  else if(ShiftEnded | RxAbortSync2 & ~RxAbortSync3 | ~r_RxEn & r_RxEn_q)
    RxReady <= 1'b0;
  else if(RxEn & RxEn_q & RxPointerRead)
    RxReady <= 1'b1;
end


// Reading Rx BD pointer
assign StartRxPointerRead = RxBDRead & RxBDReady;

// Reading Tx BD Pointer
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxPointerRead <= 1'b0;
  else
  if(StartRxPointerRead)
    RxPointerRead <= 1'b1;
  else
  if(RxEn & RxEn_q)
    RxPointerRead <= 1'b0;
end


//Latching Rx buffer pointer from buffer descriptor;
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxPointerMSB <= 30'h0;
  else
  if(RxEn & RxEn_q & RxPointerRead)
    RxPointerMSB <= ram_do[31:2];
  else
  if(MasterWbRX & m_wb_ack_i)
      RxPointerMSB <= RxPointerMSB + 1'b1; // Word access (always word access.
                                           // m_wb_sel_o are used for
                                           // selecting bytes)
end


//Latching last addresses from buffer descriptor (used as byte-half-word
//indicator);
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxPointerLSB_rst[1:0] <= 0;
  else
  if(MasterWbRX & m_wb_ack_i) // After first write all RxByteSel are active
    RxPointerLSB_rst[1:0] <= 0;
  else
  if(RxEn & RxEn_q & RxPointerRead)
    RxPointerLSB_rst[1:0] <= ram_do[1:0];
end


always @ (RxPointerLSB_rst)
begin
  case(RxPointerLSB_rst[1:0])  /*// synopsys parallel_case*/
    2'h0 : RxByteSel[3:0] = 4'hf;
    2'h1 : RxByteSel[3:0] = 4'h7;
    2'h2 : RxByteSel[3:0] = 4'h3;
    2'h3 : RxByteSel[3:0] = 4'h1;
  endcase
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxEn_needed <= 1'b0;
  else if(~RxReady & r_RxEn & WbEn & ~WbEn_q)
    RxEn_needed <= 1'b1;
  else if(RxPointerRead & RxEn & RxEn_q)
    RxEn_needed <= 1'b0;
end


// Reception status is written back to the buffer descriptor after the end
// of frame is detected.
assign RxStatusWrite = ShiftEnded & RxEn & RxEn_q;


// Indicating that last byte is being reveived
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    LastByteIn <= 1'b0;
  else
  if(ShiftWillEnd & (&RxByteCnt) | RxAbort)
    LastByteIn <= 1'b0;
  else
  if(RxValid & RxReady & RxEndFrm & ~(&RxByteCnt) & RxEnableWindow)
    LastByteIn <= 1'b1;
end

assign StartShiftWillEnd = LastByteIn  | RxValid & RxEndFrm & (&RxByteCnt) &
                           RxEnableWindow;

// Indicating that data reception will end
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    ShiftWillEnd <= 1'b0;
  else
  if(ShiftEnded_rck | RxAbort)
    ShiftWillEnd <= 1'b0;
  else
  if(StartShiftWillEnd)
    ShiftWillEnd <= 1'b1;
end


// Receive byte counter
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxByteCnt <= 2'h0;
  else
  if(ShiftEnded_rck | RxAbort)
    RxByteCnt <= 2'h0;
  else
  if(RxValid & RxStartFrm & RxReady)
    case(RxPointerLSB_rst)  /*// synopsys parallel_case*/
      2'h0 : RxByteCnt <= 2'h1;
      2'h1 : RxByteCnt <= 2'h2;
      2'h2 : RxByteCnt <= 2'h3;
      2'h3 : RxByteCnt <= 2'h0;
    endcase
  else
  if(RxValid & RxEnableWindow & RxReady | LastByteIn)
    RxByteCnt <= RxByteCnt + 1'b1;
end


// Indicates how many bytes are valid within the last word
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxValidBytes <= 2'h1;
  else
  if(RxValid & RxStartFrm)
    case(RxPointerLSB_rst)  /*// synopsys parallel_case*/
      2'h0 : RxValidBytes <= 2'h1;
      2'h1 : RxValidBytes <= 2'h2;
      2'h2 : RxValidBytes <= 2'h3;
      2'h3 : RxValidBytes <= 2'h0;
    endcase
  else
  if(RxValid & ~LastByteIn & ~RxStartFrm & RxEnableWindow)
    RxValidBytes <= RxValidBytes + 1'b1;
end


always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxDataLatched1       <= 24'h0;
  else
  if(RxValid & RxReady & ~LastByteIn)
    if(RxStartFrm)
    begin
      case(RxPointerLSB_rst)     /*// synopsys parallel_case*/
        // Big Endian Byte Ordering
        2'h0:        RxDataLatched1[31:24] <= RxData;
        2'h1:        RxDataLatched1[23:16] <= RxData;
        2'h2:        RxDataLatched1[15:8]  <= RxData;
        2'h3:        RxDataLatched1        <= RxDataLatched1;
      endcase
    end
    else if (RxEnableWindow)
    begin
      case(RxByteCnt)     /*// synopsys parallel_case*/
        // Big Endian Byte Ordering
        2'h0:        RxDataLatched1[31:24] <= RxData;
        2'h1:        RxDataLatched1[23:16] <= RxData;
        2'h2:        RxDataLatched1[15:8]  <= RxData;
        2'h3:        RxDataLatched1        <= RxDataLatched1;
      endcase
    end
end

// Assembling data that will be written to the rx_fifo
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxDataLatched2 <= 32'h0;
  else
  if(SetWriteRxDataToFifo & ~ShiftWillEnd)
    // Big Endian Byte Ordering
    RxDataLatched2 <= {RxDataLatched1[31:8], RxData};
  else
  if(SetWriteRxDataToFifo & ShiftWillEnd)
    case(RxValidBytes)  /*// synopsys parallel_case*/
      // Big Endian Byte Ordering
      0 : RxDataLatched2 <= {RxDataLatched1[31:8],  RxData};
      1 : RxDataLatched2 <= {RxDataLatched1[31:24], 24'h0};
      2 : RxDataLatched2 <= {RxDataLatched1[31:16], 16'h0};
      3 : RxDataLatched2 <= {RxDataLatched1[31:8],   8'h0};
    endcase
end


// Indicating start of the reception process
assign SetWriteRxDataToFifo = (RxValid & RxReady & ~RxStartFrm &
                              RxEnableWindow & (&RxByteCnt))
                              |(RxValid & RxReady &  RxStartFrm &
                              (&RxPointerLSB_rst))
                              |(ShiftWillEnd & LastByteIn & (&RxByteCnt));

always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    WriteRxDataToFifo <= 1'b0;
  else
  if(SetWriteRxDataToFifo & ~RxAbort)
    WriteRxDataToFifo <= 1'b1;
  else
  if(WriteRxDataToFifoSync2 | RxAbort)
    WriteRxDataToFifo <= 1'b0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    WriteRxDataToFifoSync1 <= 1'b0;
  else
  if(WriteRxDataToFifo)
    WriteRxDataToFifoSync1 <= 1'b1;
  else
    WriteRxDataToFifoSync1 <= 1'b0;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    WriteRxDataToFifoSync2 <= 1'b0;
  else
    WriteRxDataToFifoSync2 <= WriteRxDataToFifoSync1;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    WriteRxDataToFifoSync3 <= 1'b0;
  else
    WriteRxDataToFifoSync3 <= WriteRxDataToFifoSync2;
end


assign WriteRxDataToFifo_wb = WriteRxDataToFifoSync2 &
                              ~WriteRxDataToFifoSync3;


always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    LatchedRxStartFrm <= 0;
  else
  if(RxStartFrm & ~SyncRxStartFrm_q)
    LatchedRxStartFrm <= 1;
  else
  if(SyncRxStartFrm_q)
    LatchedRxStartFrm <= 0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    SyncRxStartFrm <= 0;
  else
  if(LatchedRxStartFrm)
    SyncRxStartFrm <= 1;
  else
    SyncRxStartFrm <= 0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    SyncRxStartFrm_q <= 0;
  else
    SyncRxStartFrm_q <= SyncRxStartFrm;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    SyncRxStartFrm_q2 <= 0;
  else
    SyncRxStartFrm_q2 <= SyncRxStartFrm_q;
end


assign RxFifoReset = SyncRxStartFrm_q & ~SyncRxStartFrm_q2;

eth_fifo #(
           .DATA_WIDTH(RX_FIFO_DATA_WIDTH),
           .DEPTH(RX_FIFO_DEPTH),
           .CNT_WIDTH(RX_FIFO_CNT_WIDTH))
rx_fifo (
         .clk            (WB_CLK_I),
         .reset          (Reset),
         // Inputs
         .data_in        (RxDataLatched2),
         .write          (WriteRxDataToFifo_wb & ~RxBufferFull),
         .read           (MasterWbRX & m_wb_ack_i),
         .clear          (RxFifoReset),
         // Outputs
         .data_out       (m_wb_dat_o), 
         .full           (RxBufferFull),
         .almost_full    (),
         .almost_empty   (RxBufferAlmostEmpty), 
         .empty          (RxBufferEmpty),
         .cnt            (rxfifo_cnt)
        );

assign enough_data_in_rxfifo_for_burst = rxfifo_cnt>=`ETH_BURST_LENGTH;
assign enough_data_in_rxfifo_for_burst_plus1 = rxfifo_cnt>`ETH_BURST_LENGTH;
assign WriteRxDataToMemory = ~RxBufferEmpty;
assign rx_burst = rx_burst_en & WriteRxDataToMemory;


// Generation of the end-of-frame signal
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    ShiftEnded_rck <= 1'b0;
  else
  if(~RxAbort & SetWriteRxDataToFifo & StartShiftWillEnd)
    ShiftEnded_rck <= 1'b1;
  else
  if(RxAbort | ShiftEndedSync_c1 & ShiftEndedSync_c2)
    ShiftEnded_rck <= 1'b0;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ShiftEndedSync1 <= 1'b0;
  else
    ShiftEndedSync1 <= ShiftEnded_rck;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ShiftEndedSync2 <= 1'b0;
  else
    ShiftEndedSync2 <= ShiftEndedSync1;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ShiftEndedSync3 <= 1'b0;
  else
  if(ShiftEndedSync1 & ~ShiftEndedSync2)
    ShiftEndedSync3 <= 1'b1;
  else
  if(ShiftEnded)
    ShiftEndedSync3 <= 1'b0;
end

// Generation of the end-of-frame signal
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    ShiftEnded <= 1'b0;
  else
  if(ShiftEndedSync3 & MasterWbRX & m_wb_ack_i & RxBufferAlmostEmpty & ~ShiftEnded)
    ShiftEnded <= 1'b1;
  else
  if(RxStatusWrite)
    ShiftEnded <= 1'b0;
end

always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    ShiftEndedSync_c1 <= 1'b0;
  else
    ShiftEndedSync_c1 <= ShiftEndedSync2;
end

always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    ShiftEndedSync_c2 <= 1'b0;
  else
    ShiftEndedSync_c2 <= ShiftEndedSync_c1;
end

// Generation of the end-of-frame signal
always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxEnableWindow <= 1'b0;
  else if(RxStartFrm)
    RxEnableWindow <= 1'b1;
  else if(RxEndFrm | RxAbort)
    RxEnableWindow <= 1'b0;
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxAbortSync1 <= 1'b0;
  else
    RxAbortSync1 <= RxAbortLatched;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxAbortSync2 <= 1'b0;
  else
    RxAbortSync2 <= RxAbortSync1;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxAbortSync3 <= 1'b0;
  else
    RxAbortSync3 <= RxAbortSync2;
end

always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxAbortSync4 <= 1'b0;
  else
    RxAbortSync4 <= RxAbortSync3;
end

always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxAbortSyncb1 <= 1'b0;
  else
    RxAbortSyncb1 <= RxAbortSync2;
end

always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxAbortSyncb2 <= 1'b0;
  else
    RxAbortSyncb2 <= RxAbortSyncb1;
end


always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxAbortLatched <= 1'b0;
  else
  if(RxAbortSyncb2)
    RxAbortLatched <= 1'b0;
  else
  if(RxAbort)
    RxAbortLatched <= 1'b1;
end


always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    LatchedRxLength[15:0] <= 16'h0;
  else
  if(LoadRxStatus)
    LatchedRxLength[15:0] <= RxLength[15:0];
end


assign RxStatusIn = {ReceivedPauseFrm,
                     AddressMiss,
                     RxOverrun,
                     InvalidSymbol,
                     DribbleNibble,
                     ReceivedPacketTooBig,
                     ShortFrame,
                     LatchedCrcError,
                     RxLateCollision};

always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    RxStatusInLatched <= 'h0;
  else
  if(LoadRxStatus)
    RxStatusInLatched <= RxStatusIn;
end


// Rx overrun
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxOverrun <= 1'b0;
  else if(RxStatusWrite)
    RxOverrun <= 1'b0;
  else if(RxBufferFull & WriteRxDataToFifo_wb)
    RxOverrun <= 1'b1;
end


assign TxError = TxUnderRun | RetryLimit | LateCollLatched | CarrierSenseLost;


// ShortFrame (RxStatusInLatched[2]) can not set an error because short frames
// are aborted when signal r_RecSmall is set to 0 in MODER register. 
// AddressMiss is identifying that a frame was received because of the
// promiscous mode and is not an error
assign RxError = (|RxStatusInLatched[6:3]) | (|RxStatusInLatched[1:0]);


// Latching and synchronizing RxStatusWrite signal. This signal is used for
// clearing the ReceivedPauseFrm signal
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxStatusWriteLatched <= 1'b0;
  else
  if(RxStatusWriteLatched_syncb2)
    RxStatusWriteLatched <= 1'b0;        
  else
  if(RxStatusWrite)
    RxStatusWriteLatched <= 1'b1;
end


always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    begin
      RxStatusWriteLatched_sync1 <= 1'b0;
      RxStatusWriteLatched_sync2 <= 1'b0;
    end
  else
    begin
      RxStatusWriteLatched_sync1 <= RxStatusWriteLatched;
      RxStatusWriteLatched_sync2 <= RxStatusWriteLatched_sync1;
    end
end


always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    begin
      RxStatusWriteLatched_syncb1 <= 1'b0;
      RxStatusWriteLatched_syncb2 <= 1'b0;
    end
  else
    begin
      RxStatusWriteLatched_syncb1 <= RxStatusWriteLatched_sync2;
      RxStatusWriteLatched_syncb2 <= RxStatusWriteLatched_syncb1;
    end
end


// Tx Done Interrupt
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxB_IRQ <= 1'b0;
  else
  if(TxStatusWrite & TxIRQEn)
    TxB_IRQ <= ~TxError;
  else
    TxB_IRQ <= 1'b0;
end


// Tx Error Interrupt
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    TxE_IRQ <= 1'b0;
  else
  if(TxStatusWrite & TxIRQEn)
    TxE_IRQ <= TxError;
  else
    TxE_IRQ <= 1'b0;
end


// Rx Done Interrupt
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxB_IRQ <= 1'b0;
  else
  if(RxStatusWrite & RxIRQEn & ReceivedPacketGood &
     (~ReceivedPauseFrm | ReceivedPauseFrm & r_PassAll & (~r_RxFlow)))
    RxB_IRQ <= (~RxError);
  else
    RxB_IRQ <= 1'b0;
end


// Rx Error Interrupt
always @ (posedge WB_CLK_I or posedge Reset)
begin
  if(Reset)
    RxE_IRQ <= 1'b0;
  else
  if(RxStatusWrite & RxIRQEn & (~ReceivedPauseFrm | ReceivedPauseFrm
     & r_PassAll & (~r_RxFlow)))
    RxE_IRQ <= RxError;
  else
    RxE_IRQ <= 1'b0;
end


// Busy Interrupt

reg Busy_IRQ_rck;
reg Busy_IRQ_sync1;
reg Busy_IRQ_sync2;
reg Busy_IRQ_sync3;
reg Busy_IRQ_syncb1;
reg Busy_IRQ_syncb2;


always @ (posedge MRxClk or posedge Reset)
begin
  if(Reset)
    Busy_IRQ_rck <= 1'b0;
  else
  if(RxValid & RxStartFrm & ~RxReady)
    Busy_IRQ_rck <= 1'b1;
  else
  if(Busy_IRQ_syncb2)
    Busy_IRQ_rck <= 1'b0;
end

always @ (posedge WB_CLK_I)
begin
    Busy_IRQ_sync1 <= Busy_IRQ_rck;
    Busy_IRQ_sync2 <= Busy_IRQ_sync1;
    Busy_IRQ_sync3 <= Busy_IRQ_sync2;
end

always @ (posedge MRxClk)
begin
    Busy_IRQ_syncb1 <= Busy_IRQ_sync2;
    Busy_IRQ_syncb2 <= Busy_IRQ_syncb1;
end

assign Busy_IRQ = Busy_IRQ_sync2 & ~Busy_IRQ_sync3;


// Assign the debug output
`ifdef WISHBONE_DEBUG
// Top byte, burst progress counters
assign dbg_dat0[31] = 0;
assign dbg_dat0[30:28] = rx_burst_cnt;
assign dbg_dat0[27] = 0;
assign dbg_dat0[26:24] = tx_burst_cnt;
// Third byte
assign dbg_dat0[23] = 0; //rx_ethside_fifo_sel;
assign dbg_dat0[22] = 0; //rx_wbside_fifo_sel;
assign dbg_dat0[21] = 0; //rx_fifo0_empty;
assign dbg_dat0[20] = 0; //rx_fifo1_empty;
assign dbg_dat0[19] = 0; //overflow_bug_reset;
assign dbg_dat0[18] = 0; //RxBDOK;
assign dbg_dat0[17] = 0; //write_rx_data_to_memory_go;
assign dbg_dat0[16] = 0; //rx_wb_last_writes;
// Second byte - TxBDAddress - or TX BD address pointer
assign dbg_dat0[15:8] = { BlockingTxBDRead , TxBDAddress};
// Bottom byte - FSM controlling vector
assign dbg_dat0[7:0] = {MasterWbTX,
                       MasterWbRX,
                       ReadTxDataFromMemory_2,
                       WriteRxDataToMemory,
                       MasterAccessFinished,
                       cyc_cleared,
                       tx_burst,
                       rx_burst};
`endif


endmodule
