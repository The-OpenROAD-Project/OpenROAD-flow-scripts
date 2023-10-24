/*
Copyright 2023 IHP PDK Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
module spi(
    input clk,
    input rst,
    input ss,
    input mosi,
    output miso,
    input sck,
    output done,
    input [7:0] din,
    output [7:0] dout
  );
 
  reg mosi_d, mosi_q;
  reg ss_d, ss_q;
  reg sck_d, sck_q;
  reg sck_old_d, sck_old_q;
  reg [7:0] data_d, data_q;
  reg done_d, done_q;
  reg [2:0] bit_ct_d, bit_ct_q;
  reg [7:0] dout_d, dout_q;
  reg miso_d, miso_q;
 
  assign miso = miso_q;
  assign done = done_q;
  assign dout = dout_q;
 
  always @(*) begin
    ss_d = ss;
    mosi_d = mosi;
    miso_d = miso_q;
    sck_d = sck;
    sck_old_d = sck_q;
    data_d = data_q;
    done_d = 1'b0;
    bit_ct_d = bit_ct_q;
    dout_d = dout_q;
 
    if (ss_q) begin                           // if slave select is high (deselcted)
      bit_ct_d = 3'b0;                        // reset bit counter
      data_d = din;                           // read in data
      miso_d = data_q[7];                     // output MSB
    end else begin                            // else slave select is low (selected)
      if (!sck_old_q && sck_q) begin          // rising edge
        data_d = {data_q[6:0], mosi_q};       // read data in and shift
        bit_ct_d = bit_ct_q + 1'b1;           // increment the bit counter
        if (bit_ct_q == 3'b111) begin         // if we are on the last bit
          dout_d = {data_q[6:0], mosi_q};     // output the byte
          done_d = 1'b1;                      // set transfer done flag
          data_d = din;                       // read in new byte
        end
      end else if (sck_old_q && !sck_q) begin // falling edge
        miso_d = data_q[7];                   // output MSB
      end
    end
  end
 
  always @(posedge clk) begin
    if (rst) begin
      done_q <= 1'b0;
      bit_ct_q <= 3'b0;
      dout_q <= 8'b0;
      miso_q <= 1'b1;
    end else begin
      done_q <= done_d;
      bit_ct_q <= bit_ct_d;
      dout_q <= dout_d;
      miso_q <= miso_d;
    end
 
    sck_q <= sck_d;
    mosi_q <= mosi_d;
    ss_q <= ss_d;
    data_q <= data_d;
    sck_old_q <= sck_old_d;
 
  end
 
endmodule

