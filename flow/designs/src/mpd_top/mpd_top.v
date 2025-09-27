module mpd_top(clk, rst, ld, done, key, text_in, text_out, valid, pd_request, isolaten_aes_1);
input		clk, rst;
input		ld;
output		done;
input	[127:0]	key;
input	[127:0]	text_in;
output	[127:0]	text_out;
output          valid;
input           pd_request;
input           isolaten_aes_1;

wire done_0, done_1, done_2 ;
wire [127:0] text_out_0, text_out_1, text_out_2 ;
wire sleep, isolaten ;

wire compare1, compare2, compare3 ;
wire valid ;

  aes_cipher_top u_aes_0 (.clk(clk), .rst(rst), .ld(ld), .done(done_0), .key(key), .text_in(text_in), .text_out(text_out_0) );
  aes_cipher_top u_aes_1 (.clk(clk), .rst(rst), .ld(ld), .done(done_1), .key(key), .text_in(text_in), .text_out(text_out_1) );
  aes_cipher_top u_aes_2 (.clk(clk), .rst(rst), .ld(ld), .done(done_2), .key(key), .text_in(text_in), .text_out(text_out_2) );

  power_control u_pwr_control (pd_request, sleep, isolaten);

  assign done = done_0 & done_1 & done_2 ;
  assign valid = compare1 | compare2 | compare3 ;

  assign compare1 = (text_out_0 == text_out_1) ;
  assign compare2 = (text_out_0 == text_out_2) ;
  assign compare3 = (text_out_1 == text_out_2) ;

  assign text_out = (compare1 || compare2) ? text_out_0 : compare3 ? text_out_1 : 128'b0 ;

endmodule

