//hex2bcd.v

module hex2bcd(
d_in,
d_out
);
input [9:0] d_in;
output [11:0] d_out;
//-------------------------------------
wire [3:0] h2;
assign h2 = (d_in >= 10'd900) ? 4'h9 :
						(d_in >= 10'd800) ? 4'h8 :
						(d_in >= 10'd700) ? 4'h7 :
						(d_in >= 10'd600) ? 4'h6 :
						(d_in >= 10'd500) ? 4'h5 :
						(d_in >= 10'd400) ? 4'h4 :
						(d_in >= 10'd300) ? 4'h3 :
						(d_in >= 10'd200) ? 4'h2 :
						(d_in >= 10'd100) ? 4'h1 : 4'h0;

wire [9:0] d_in2 = d_in - (h2 * 10'd100);
wire [3:0] h1;
assign h1 = (d_in2 >= 10'd90) ? 4'h9 :
						(d_in2 >= 10'd80) ? 4'h8 :
						(d_in2 >= 10'd70) ? 4'h7 :
						(d_in2 >= 10'd60) ? 4'h6 :
						(d_in2 >= 10'd50) ? 4'h5 :
						(d_in2 >= 10'd40) ? 4'h4 :
						(d_in2 >= 10'd30) ? 4'h3 :
						(d_in2 >= 10'd20) ? 4'h2 :
						(d_in2 >= 10'd10) ? 4'h1 : 4'h0;
						
wire [9:0] d_in3 = d_in2 - (h1 * 10'd10);
wire [3:0] h0;
assign h0 = d_in3[3:0];

wire [11:0] d_out;
assign d_out = {h2,h1,h0};

endmodule
