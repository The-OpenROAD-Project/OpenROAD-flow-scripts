
`include "defines.v"
module opAddress(clk,rst,source0,dest0,source1,dest1,dest2,dest3,dest4,R0,R1,R0_valid,R1_valid,R_invalid,addr8,addr16,rom_read,i_ram_read,e_ram_read,bank,stall,stall_alu,stall_dec_addr,nop_dec,nop2,nop3,nop4);

input clk,rst;
input [17:0] source0;
input [16:0] dest0,dest2,dest3,dest4;
output reg [17:0] source1;
output reg [16:0] dest1;

output [7:0] addr8;
output [15:0] addr16;
output reg rom_read;
output reg i_ram_read;
output reg e_ram_read;
input [1:0] bank;
input [7:0] R1,R0;
input R0_valid, R1_valid, R_invalid;
//input stall_alu;
input stall_alu, nop_dec;
input nop2, nop3, nop4;
input stall_dec_addr;

reg [7:0] add_src, add_dst;

output stall;
assign stall = (stall_s || stall_d) && !stall_dec_addr;
reg stall_s, stall_d;

always@(*) begin
  if (source0[17] && !source0[16] && !source0[15]) begin
    case (source0[14:13])
      2'b00   : add_src = source0[7:0];
      2'b01   : add_src = source0[0] ? R1 : R0;
      2'b10   : add_src = {3'b0,bank,source0[2:0]};
      2'b11   : add_src = source0[7] ? {source0[7:3],3'b0} : {2'b0,1'b1,source0[7:3]};
      default : add_src = 8'b0;
    endcase

    if( source0[14:13] != 2'b11 ) 
      case (add_src)
        8'h82 : source1 = {5'b11100,2'b0,3'd2,add_src};  //dptrL 
        8'h83 : source1 = {5'b11100,2'b0,3'd3,add_src};  //dptrH 
        //: source1 = {source0[17:11],3'd4,8'd0};  //PCL    
        //: source1 = {source0[17:11],3'd5,8'd0};  //PCH    
        //: source1 = {source0[17:11],3'd6,8'd0};  //SPL    
        8'h81 : source1 = {5'b11100,2'b0,3'd7,add_src};  //SPH   
        8'hF0 : source1 = {5'b11100,2'd1,3'b0,add_src}; //B    
        8'hE0 : source1 = {5'b11100,2'd2,3'b0,add_src}; //ACC    
        8'hD0 : source1 = {5'b11100,2'd3,3'b0,add_src}; //PSW    
        default : source1 = {10'b1000000000,add_src};
      endcase
    else
      case (add_src)
        8'h82 : source1 = {5'b11100,2'b0,3'd2,source0[7:0]};  //dptrL 
        8'h83 : source1 = {5'b11100,2'b0,3'd3,source0[7:0]};  //dptrH 
        //: source1 = {source0[17:11],3'd4,8'd0};  //PCL    
        //: source1 = {source0[17:11],3'd5,8'd0};  //PCH    
        //: source1 = {source0[17:11],3'd6,8'd0};  //SPL    
        8'h81 : source1 = {5'b11100,2'b0,3'd7,source0[7:0]};  //SPH   
        8'hF0 : source1 = {5'b11100,2'd1,3'b0,source0[7:0]}; //B    
        8'hE0 : source1 = {5'b11100,2'd2,3'b0,source0[7:0]}; //ACC    
        8'hD0 : source1 = {5'b11100,2'd3,3'b0,source0[7:0]}; //PSW    
        default : source1 = {7'b1000000,source0[2:0],add_src};
      endcase
  end
  else begin
    source1 = source0;
    add_src = 8'b0;
  end
end

always@(*) begin
	if (source0[17] && !source0[16] && !source0[15]) begin
		case (source0[14:13])
			2'b00 	: 
          //add_src = source0[7:0]; 					    // Direct addressing
          if (!nop2 && ((dest2[16] && !dest2[15] && dest2[14] && (source0[7:0] == dest2[7:0])) || 
              (dest2[16] && !dest2[15] && dest2[14] && (source0[7:0] == dest2[7:0])) ||
              (dest2[16] && !dest2[15] && dest2[14] && (source0[7:0] == dest2[7:0])))) begin
            stall_s = 1'b1; 
          end
          else if (!nop3 && ((dest3[16] && !dest3[15] && dest3[14] && (source0[7:0] == dest3[7:0])) || 
              (dest3[16] && !dest3[15] && dest3[14] && (source0[7:0] == dest3[7:0])) ||
              (dest3[16] && !dest3[15] && dest3[14] && (source0[7:0] == dest3[7:0])))) begin
            stall_s = 1'b1; 
          end
          else if (!nop4 && ((dest4[16] && !dest4[15] && dest4[14] && (source0[7:0] == dest4[7:0])) || 
              (dest4[16] && !dest4[15] && dest4[14] && (source0[7:0] == dest4[7:0])) ||
              (dest4[16] && !dest4[15] && dest4[14] && (source0[7:0] == dest4[7:0])))) begin
            stall_s = 1'b1;
          end
          else begin
            stall_s = 1'b0;            
          end
			2'b11 	: 
          //add_src = source0[7:0]; 					    // Direct addressing
          if (source0[17] && !source0[16]) begin
            if (!nop2 && ((dest2[16] && !dest2[15] && dest2[14] && (add_src == dest2[7:0])) || 
                (dest2[16] && !dest2[15] && dest2[14] && (add_src == dest2[7:0])) ||
                (dest2[16] && !dest2[15] && dest2[14] && (add_src == dest2[7:0])))) begin
              stall_s = 1'b1; 
            end
            else if (!nop3 && ((dest3[16] && !dest3[15] && dest3[14] && (add_src == dest3[7:0])) || 
                (dest3[16] && !dest3[15] && dest3[14] && (add_src == dest3[7:0])) ||
                (dest3[16] && !dest3[15] && dest3[14] && (add_src == dest3[7:0])))) begin
              stall_s = 1'b1; 
            end
            else if (!nop4 && ((dest4[16] && !dest4[15] && dest4[14] && (source0[7:0] == dest4[7:0])) || 
                (dest4[16] && !dest4[15] && dest4[14] && (add_src == dest4[7:0])) ||
                (dest4[16] && !dest4[15] && dest4[14] && (add_src == dest4[7:0])))) begin
              stall_s = 1'b1;
            end
            else stall_s = 1'b0;
          end
          else stall_s = 1'b0;            
			2'b01 	: 
          //add_src = source0[0] ? R1 : R0; 			// Indirect addressing
               if (!nop2 && ((dest2[16] && dest2[15] && dest2[4] && dest2[3]) || (dest2[16] && !dest2[15] && ((dest2[10] && !source0[0]) || (dest2[11] && source0[0]))))) stall_s = 1'b1;
          else if (!nop3 && ((dest3[16] && dest3[15] && dest3[4] && dest3[3]) || (dest3[16] && !dest3[15] && ((dest3[10] && !source0[0]) || (dest3[11] && source0[0]))))) stall_s = 1'b1;
          else if (!nop4 && ((dest4[16] && dest4[15] && dest4[4] && dest4[3]) || (dest4[16] && !dest4[15] && ((dest4[10] && !source0[0]) || (dest4[11] && source0[0]))))) stall_s = 1'b1;
          else if ((!source0[0] && (!R0_valid || R_invalid)) || (source0[0] && (!R1_valid || R_invalid))) stall_s = 1'b1;
          else if (!nop2 && dest2[16] && !dest2[15] && (source1[7:0] == dest2[7:0])) stall_s = 1'b1;
          else if (!nop3 && dest3[16] && !dest3[15] && (source1[7:0] == dest3[7:0])) stall_s = 1'b1;
          else if (!nop4 && dest4[16] && !dest4[15] && (source1[7:0] == dest4[7:0])) stall_s = 1'b1;
          else stall_s = 1'b0;            
      2'b10 	: 
          //add_src = {3'b0,bank,source0[2:0]}; 	// Register addressing
          if((!nop2 && (dest2[16] && dest2[15] && dest2[4] && dest2[3])) ||
             (!nop3 && (dest3[16] && dest3[15] && dest3[4] && dest3[3])) ||
             (!nop4 && (dest4[16] && dest4[15] && dest4[4] && dest4[3])))
            stall_s = 1'b1; 
          else if (!nop2 && dest2[16] && !dest2[15] && (dest2[7:0] == add_src)) stall_s = 1'b1;
          else if (!nop3 && dest3[16] && !dest3[15] && (dest3[7:0] == add_src)) stall_s = 1'b1;
          else if (!nop4 && dest4[16] && !dest4[15] && (dest4[7:0] == add_src)) stall_s = 1'b1;
          else begin
            stall_s = 1'b0;            
          end
		endcase
	end
  else begin
    stall_s = 1'b0;
  end
end

always@(*) begin
  if (dest0[16] && !dest0[15]) begin
    case (dest0[13:12])
      2'b00   : add_dst = dest0[7:0];
      2'b01   : add_dst = dest0[0] ? R1 : R0;
      2'b10   : add_dst = {3'b0,bank,dest0[2:0]};
      2'b11   : add_dst = dest0[7] ? {dest0[7:3],3'b0} : {2'b0,1'b1,dest0[7:3]};
      default : add_dst = 8'b0;
    endcase

    case (add_dst)
      8'h82 : dest1 = {3'b110,4'b0,dest0[9:8],dest0[2:0],2'd0,3'd2};
      8'h83 : dest1 = {3'b110,4'b0,dest0[9:8],dest0[2:0],2'd0,3'd3};
      //PCL   : dest1 = {dest0[16:8],3'd0,2'd0,3'd4};
      //PCH   : dest1 = {dest0[16:8],3'd0,2'd0,3'd5};
      //SPL   : dest1 = {dest0[16:8],3'd0,2'd0,3'd6};
      8'h81 : dest1 = {3'b110,4'b0,dest0[9:8],dest0[2:0],2'd0,3'd7};
      8'hF0 : dest1 = {3'b110,4'b0,dest0[9:8],dest0[2:0],2'd1,3'd0};
      8'hE0 : dest1 = {3'b110,4'b0,dest0[9:8],dest0[2:0],2'd2,3'd0};
      8'hD0 : dest1 = {3'b110,4'b0,dest0[9:8],dest0[2:0],2'd3,3'd0};
      default : begin
        if      (add_dst == {3'b0,bank,3'b0})  dest1 = {5'b10100,2'b01,dest0[9:8],add_dst}; 
        else if (add_dst == {3'b0,bank,3'b1})  dest1 = {5'b10100,2'b10,dest0[9:8],add_dst}; 
        else                                   dest1 = {5'b10100,2'b00,dest0[9:8],add_dst}; 
      end
    endcase
  end
  else begin
    dest1 = dest0;
    add_dst = 8'b0;
  end

end

always@(*) begin
	if (dest0[16] && !dest0[15] && dest0[14]) begin
		case (dest0[13:12])
			2'b01 	: 
      //add_dst = dest0[0] ? R1 : R0; 		// Indirect addressing
          if (!nop2 && ((dest2[16] && !dest2[15] && dest2[10] && !dest0[0]) ||
              (dest2[16] && !dest2[15] && dest2[11] && dest0[0]) ||
              (dest2[16] && dest2[15] && dest2[4] && dest2[3]))) begin
            stall_d = 1'b1; 
          end
          else if (!nop3 && ((dest3[16] && !dest3[15] && dest3[10] && !dest0[0]) ||
              (dest3[16] && !dest3[15] && dest3[11] && dest0[0]) ||
              (dest3[16] && dest3[15] && dest3[4] && dest3[3]))) begin
            stall_d = 1'b1; 
          end
          else if (!nop4 && ((dest4[16] && !dest4[15] && dest4[10] && !dest0[0]) ||
              (dest4[16] && !dest4[15] && dest4[11] && dest0[0]) ||
              (dest4[16] && dest4[15] && dest4[4] && dest4[3]))) begin
            stall_d = 1'b1; 
          end
          else if (!nop2 && dest2[16] && !dest2[15] && ((dest2[10] && !dest0[0]) || (dest2[11] && dest0[0]))) stall_d = 1'b1;
          else if (!nop3 && dest3[16] && !dest3[15] && ((dest3[10] && !dest0[0]) || (dest3[11] && dest0[0]))) stall_d = 1'b1;
          else if (!nop4 && dest4[16] && !dest4[15] && ((dest4[10] && !dest0[0]) || (dest4[11] && dest0[0]))) stall_d = 1'b1;
          else if ((!dest0[0] && (!R0_valid || R_invalid)) || (dest0[0] && (!R1_valid || R_invalid))) stall_d = 1'b1;
          else if (!nop2 && dest2[16] && !dest2[15] && (dest1[7:0] == dest2[7:0])) stall_d = 1'b1;
          else if (!nop3 && dest3[16] && !dest3[15] && (dest1[7:0] == dest3[7:0])) stall_d = 1'b1;
          else if (!nop4 && dest4[16] && !dest4[15] && (dest1[7:0] == dest4[7:0])) stall_d = 1'b1;
          else stall_d = 1'b0;            
			2'b10 	: 
          if ((!nop2 && dest2[16] && dest2[15] && dest2[4] && dest2[3]) ||
              (!nop3 && dest3[16] && dest3[15] && dest3[4] && dest3[3]) ||
              (!nop4 && dest4[16] && dest4[15] && dest4[4] && dest4[3]))
            stall_d = 1'b1;
          else if (!nop2 && dest2[16] && !dest2[15] && (dest2[7:0] == add_dst)) stall_d = 1'b1;
          else if (!nop3 && dest3[16] && !dest3[15] && (dest3[7:0] == add_dst)) stall_d = 1'b1;
          else if (!nop4 && dest4[16] && !dest4[15] && (dest4[7:0] == add_dst)) stall_d = 1'b1;
          else begin
            stall_d = 1'b0;            
          end
			default : 
          begin stall_d = 1'b0; end
		endcase
	end
	else begin
    stall_d = 1'b0;
  end
end


assign addr16 = source1[15:0];
assign addr8 = (source1[14] && source1[13]) ? (source1[7] ? {source1[7:3],3'b0} : {2'b0,1'b1,source1[7:3]}) : source1[7:0];


always@(*) begin
// in case of 16 bit operand, need to modify source format
rom_read = 1'b0;
i_ram_read = 1'b0;
e_ram_read = 1'b0;
if (rst || stall_alu || nop_dec) begin
  rom_read = 1'b0;
  i_ram_read = 1'b0;
  e_ram_read = 1'b0;
end
else if (!source1[17]) // Long address
  	if (!source1[16]) e_ram_read = 1'b1;
  	else rom_read = 1'b1;
else 
	if (!source1[15] && !source1[16]) i_ram_read = 1'b1;
end

endmodule


