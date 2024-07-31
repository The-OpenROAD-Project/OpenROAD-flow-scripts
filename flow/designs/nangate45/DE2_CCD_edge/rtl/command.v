module command(
        CLK,
        RESET_N,
        SADDR,
        NOP,
        READA,
        WRITEA,
        REFRESH,
        PRECHARGE,
        LOAD_MODE,
        REF_REQ,
		INIT_REQ,
		PM_STOP,
		PM_DONE,
        REF_ACK,
        CM_ACK,
        OE,
        SA,
        BA,
        CS_N,
        CKE,
        RAS_N,
        CAS_N,
        WE_N
        );

`include        "Sdram_Params.h"

input                           CLK;                    // System Clock
input                           RESET_N;                // System Reset
input   [`ASIZE-1:0]            SADDR;                  // Address
input                           NOP;                    // Decoded NOP command
input                           READA;                  // Decoded READA command
input                           WRITEA;                 // Decoded WRITEA command
input                           REFRESH;                // Decoded REFRESH command
input                           PRECHARGE;              // Decoded PRECHARGE command
input                           LOAD_MODE;              // Decoded LOAD_MODE command
input                           REF_REQ;                // Hidden refresh request
input							INIT_REQ;				// Hidden initial request
input							PM_STOP;				// Page mode stop
input							PM_DONE;				// Page mode done
output                          REF_ACK;                // Refresh request acknowledge
output                          CM_ACK;                 // Command acknowledge
output                          OE;                     // OE signal for data path module
output  [11:0]                  SA;                     // SDRAM address
output  [1:0]                   BA;                     // SDRAM bank address
output  [1:0]                   CS_N;                   // SDRAM chip selects
output                          CKE;                    // SDRAM clock enable
output                          RAS_N;                  // SDRAM RAS
output                          CAS_N;                  // SDRAM CAS
output                          WE_N;                   // SDRAM WE_N

            
reg                             CM_ACK;
reg                             REF_ACK;
reg                             OE;
reg     [11:0]                  SA;
reg     [1:0]                   BA;
reg     [1:0]                   CS_N;
reg                             CKE;
reg                             RAS_N;
reg                             CAS_N;
reg                             WE_N;



// Internal signals
reg                             do_reada;
reg                             do_writea;
reg                             do_refresh;
reg                             do_precharge;
reg                             do_load_mode;
reg								do_initial;
reg                             command_done;
reg     [7:0]                   command_delay;
reg     [1:0]                   rw_shift;
reg                             do_act;
reg                             rw_flag;
reg                             do_rw;
reg     [6:0]                   oe_shift;
reg                             oe1;
reg                             oe2;
reg                             oe3;
reg                             oe4;
reg     [3:0]                   rp_shift;
reg                             rp_done;
reg								ex_read;
reg								ex_write;

wire    [`ROWSIZE - 1:0]        rowaddr;
wire    [`COLSIZE - 1:0]        coladdr;
wire    [`BANKSIZE - 1:0]       bankaddr;

assign   rowaddr   = SADDR[`ROWSTART + `ROWSIZE - 1: `ROWSTART];          // assignment of the row address bits from SADDR
assign   coladdr   = SADDR[`COLSTART + `COLSIZE - 1:`COLSTART];           // assignment of the column address bits
assign   bankaddr  = SADDR[`BANKSTART + `BANKSIZE - 1:`BANKSTART];        // assignment of the bank address bits



// This always block monitors the individual command lines and issues a command
// to the next stage if there currently another command already running.
//
always @(posedge CLK or negedge RESET_N)
begin
        if (RESET_N == 0) 
        begin
                do_reada        <= 0;
                do_writea       <= 0;
                do_refresh      <= 0;
                do_precharge    <= 0;
                do_load_mode    <= 0;
				do_initial		<= 0;
                command_done    <= 0;
                command_delay   <= 0;
                rw_flag         <= 0;
                rp_shift        <= 0;
                rp_done         <= 0;
				ex_read			<= 0;
				ex_write		<= 0;
        end
        
        else
        begin

//  Issue the appropriate command if the sdram is not currently busy
			if( INIT_REQ == 1 )
			begin
                do_reada        <= 0;
                do_writea       <= 0;
                do_refresh      <= 0;
                do_precharge    <= 0;
                do_load_mode    <= 0;
				do_initial		<= 1;
                command_done    <= 0;
                command_delay   <= 0;
                rw_flag         <= 0;
                rp_shift        <= 0;
                rp_done         <= 0;
				ex_read			<= 0;
				ex_write		<= 0;
			end
			else
			begin
				do_initial		<= 0;
				
                if ((REF_REQ == 1 | REFRESH == 1) & command_done == 0 & do_refresh == 0 & rp_done == 0         // Refresh
                        & do_reada == 0 & do_writea == 0)
                        do_refresh <= 1;         
                else
                        do_refresh <= 0;

                if ((READA == 1) & (command_done == 0) & (do_reada == 0) & (rp_done == 0) & (REF_REQ == 0))    // READA
                begin
				        do_reada <= 1;
						ex_read <= 1;
				end
                else
                        do_reada <= 0;
                    
                if ((WRITEA == 1) & (command_done == 0) & (do_writea == 0) & (rp_done == 0) & (REF_REQ == 0))  // WRITEA
                begin
				        do_writea <= 1;
						ex_write <= 1;
				end
                else
                        do_writea <= 0;

                if ((PRECHARGE == 1) & (command_done == 0) & (do_precharge == 0))                              // PRECHARGE
                        do_precharge <= 1;
                else
                        do_precharge <= 0;
 
                if ((LOAD_MODE == 1) & (command_done == 0) & (do_load_mode == 0))                              // LOADMODE
                        do_load_mode <= 1;
                else
                        do_load_mode <= 0;
                                               
// set command_delay shift register and command_done flag
// The command delay shift register is a timer that is used to ensure that
// the SDRAM devices have had sufficient time to finish the last command.

                if ((do_refresh == 1) | (do_reada == 1) | (do_writea == 1) | (do_precharge == 1)
                     | (do_load_mode == 1))
                begin
                        command_delay <= 8'b11111111;
                        command_done  <= 1;
                        rw_flag <= do_reada;                                                  
                end
                
                else
                begin
                        command_done        <= command_delay[0];                // the command_delay shift operation
                        command_delay		<= (command_delay>>1);
                end 
                
 
 // start additional timer that is used for the refresh, writea, reada commands               
                if (command_delay[0] == 0 & command_done == 1)
                begin
                	rp_shift <= 4'b1111;
                	rp_done <= 1;
                end
                else
                begin						
					if(SC_PM == 0)
					begin
						rp_shift	<= (rp_shift>>1);
                    	rp_done		<= rp_shift[0];
					end
					else
					begin
						if( (ex_read == 0) && (ex_write == 0) )
						begin
							rp_shift	<= (rp_shift>>1);
        	            	rp_done		<= rp_shift[0];
						end
						else
						begin
							if( PM_STOP==1 )
							begin
								rp_shift	<= (rp_shift>>1);
        	      		      	rp_done     <= rp_shift[0];
								ex_read		<= 1'b0;
								ex_write	<= 1'b0;
							end					
						end
					end
                end
			end
        end
end


// logic that generates the OE signal for the data path module
// For normal burst write he duration of OE is dependent on the configured burst length.
// For page mode accesses(SC_PM=1) the OE signal is turned on at the start of the write command
// and is left on until a PRECHARGE(page burst terminate) is detected.
//
always @(posedge CLK or negedge RESET_N)
begin
        if (RESET_N == 0)
        begin
                oe_shift <= 0;
                oe1      <= 0;
                oe2      <= 0;
                OE       <= 0;
        end
        else
        begin
                if (SC_PM == 0)
                begin
                        if (do_writea == 1)
                        begin
                                if (SC_BL == 1)                       //  Set the shift register to the appropriate
                                        oe_shift <= 0;                // value based on burst length.
                                else if (SC_BL == 2)
                                        oe_shift <= 1;
                                else if (SC_BL == 4)
                                        oe_shift <= 7;
                                else if (SC_BL == 8)
                                        oe_shift <= 127;
                                oe1 <= 1;
                        end
                        else 
                        begin
                                oe_shift <= (oe_shift>>1);
                                oe1  <= oe_shift[0];
                                oe2  <= oe1;
                                oe3  <= oe2;
                                oe4  <= oe3;
                                if (SC_RCD == 2)
                                        OE <= oe3;
                                else
                                        OE <= oe4;
                        end
                end
                else
                begin
                        if (do_writea == 1)                                    // OE generation for page mode accesses
                                oe4   <= 1;
                        else if (do_precharge == 1 | do_reada == 1 | do_refresh==1 | do_initial == 1 | PM_STOP==1 )
                                oe4   <= 0;
                        OE <= oe4;
                end
                               
        end
end




// This always block tracks the time between the activate command and the
// subsequent WRITEA or READA command, RC.  The shift register is set using
// the configuration register setting SC_RCD. The shift register is loaded with
// a single '1' with the position within the register dependent on SC_RCD.
// When the '1' is shifted out of the register it sets so_rw which triggers
// a writea or reada command
//
always @(posedge CLK or negedge RESET_N)
begin
        if (RESET_N == 0)
        begin
                rw_shift <= 0;
                do_rw    <= 0;
        end
        
        else
        begin
                
                if ((do_reada == 1) | (do_writea == 1))
                begin
                        if (SC_RCD == 1)                          // Set the shift register
                                do_rw <= 1;
                        else if (SC_RCD == 2)
                                rw_shift <= 1;
                        else if (SC_RCD == 3)
                                rw_shift <= 2;
                end
                else
                begin
                        rw_shift <= (rw_shift>>1);
                        do_rw    <= rw_shift[0];
                end 
        end
end              

// This always block generates the command acknowledge, CM_ACK, signal.
// It also generates the acknowledge signal, REF_ACK, that acknowledges
// a refresh request that was generated by the internal refresh timer circuit.
always @(posedge CLK or negedge RESET_N) 
begin

        if (RESET_N == 0) 
        begin
                CM_ACK   <= 0;
                REF_ACK  <= 0;
        end
        
        else
        begin
                if (do_refresh == 1 & REF_REQ == 1)                   // Internal refresh timer refresh request
                        REF_ACK <= 1;
                else if ((do_refresh == 1) | (do_reada == 1) | (do_writea == 1) | (do_precharge == 1)   // externa  commands
                         | (do_load_mode))
                        CM_ACK <= 1;
                else
                begin
                        REF_ACK <= 0;
                        CM_ACK  <= 0;
                end
        end
end 
                    






// This always block generates the address, cs, cke, and command signals(ras,cas,wen)
// 
always @(posedge CLK ) begin
        if (RESET_N==0) begin
                SA    <= 0;
                BA    <= 0;
                CS_N  <= 1;
                RAS_N <= 1;
                CAS_N <= 1;
                WE_N  <= 1;
                CKE   <= 0;
        end
        else begin
                CKE <= 1;

// Generate SA 	
                if (do_writea == 1 | do_reada == 1)    // ACTIVATE command is being issued, so present the row address
                        SA <= rowaddr;
                else
                        SA <= coladdr;                 // else alway present column address
                if ((do_rw==1) | (do_precharge))
                        SA[10] <= !SC_PM;              // set SA[10] for autoprecharge read/write or for a precharge all command
                                                       // don't set it if the controller is in page mode.           
                if (do_precharge==1 | do_load_mode==1)
                        BA <= 0;                       // Set BA=0 if performing a precharge or load_mode command
                else
                        BA <= bankaddr[1:0];           // else set it with the appropriate address bits
		
                if (do_refresh==1 | do_precharge==1 | do_load_mode==1 | do_initial==1)
                        CS_N <= 0;                                    // Select both chip selects if performing
                else                                                  // refresh, precharge(all) or load_mode
                begin
                        CS_N[0] <= SADDR[`ASIZE-1];                   // else set the chip selects based off of the
                        CS_N[1] <= ~SADDR[`ASIZE-1];                  // msb address bit
                end
				
				if(do_load_mode==1)
				SA	  <= {2'b00,SDR_CL,SDR_BT,SDR_BL};


//Generate the appropriate logic levels on RAS_N, CAS_N, and WE_N
//depending on the issued command.
//		
                if ( do_refresh==1 ) begin                        // Refresh: S=00, RAS=0, CAS=0, WE=1
                        RAS_N <= 0;
                        CAS_N <= 0;
                        WE_N  <= 1;
                end
                else if ((do_precharge==1) & ((oe4 == 1) | (rw_flag == 1))) begin      // burst terminate if write is active
                        RAS_N <= 1;
                        CAS_N <= 1;
                        WE_N  <= 0;
                end
                else if (do_precharge==1) begin                 // Precharge All: S=00, RAS=0, CAS=1, WE=0
                        RAS_N <= 0;
                        CAS_N <= 1;
                        WE_N  <= 0;
                end
                else if (do_load_mode==1) begin                 // Mode Write: S=00, RAS=0, CAS=0, WE=0
                        RAS_N <= 0;
                        CAS_N <= 0;
                        WE_N  <= 0;
                end
                else if (do_reada == 1 | do_writea == 1) begin  // Activate: S=01 or 10, RAS=0, CAS=1, WE=1
                        RAS_N <= 0;
                        CAS_N <= 1;
                        WE_N  <= 1;
                end
                else if (do_rw == 1) begin                      // Read/Write: S=01 or 10, RAS=1, CAS=0, WE=0 or 1
                        RAS_N <= 1;
                        CAS_N <= 0;
                        WE_N  <= rw_flag;
                end
				else if (do_initial ==1) begin
                        RAS_N <= 1;
                        CAS_N <= 1;
                        WE_N  <= 1;				
				end
                else begin                                      // No Operation: RAS=1, CAS=1, WE=1
                        RAS_N <= 1;
                        CAS_N <= 1;
                        WE_N  <= 1;
                end
        end 
end

endmodule
