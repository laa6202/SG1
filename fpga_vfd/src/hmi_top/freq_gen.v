//freq_gen.v

module freq_gen(
key,
freq,
//clk rst
clk_sys,
clk_slow,
rst_n
);
input [2:0]	key;
output [9:0]	freq;
//clk rst
input clk_sys;
input clk_slow;
input rst_n;
//----------------------------------------

reg [7:0] k0;
reg [7:0] k1;
reg [7:0] k2;
always @ (posedge clk_sys)	begin
	k0 <= {k0[6:0],key[0]};
	k1 <= {k1[6:0],key[1]};
	k2 <= {k2[6:0],key[2]};
end

reg [2:0] key_real;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		key_real <= 3'h0;
	else begin
		if(k0 == 8'h0)
			key_real[0] <= 1'b0;
		if(k0 == 8'hff)
			key_real[0] <= 1'b1;
		if(k1 == 8'h0)
			key_real[1] <= 1'b0;
		if(k1 == 8'hff)
			key_real[1] <= 1'b1;
		if(k2 == 8'h0)
			key_real[2] <= 1'b0;
		if(k2 == 8'hff)
			key_real[2] <= 1'b1;
	end
end

reg [2:0] key_real_reg;
always @(posedge clk_sys)
	key_real_reg <= key_real;

wire [2:0] key_rasing;
assign key_rasing[0] =  key_real[0] & (~key_real_reg[0]);
assign key_rasing[1] =  key_real[1] & (~key_real_reg[1]);
assign key_rasing[2] =  key_real[2] & (~key_real_reg[2]);


wire [9:0] freq_org = 10'd50;

reg [10:0] freq_real;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		freq_real <= {1'b0,freq_org};
	else if(freq_real > 10'd1000)
		freq_real <= freq_real - 10'd1000;
	else if(key_rasing[2])
		freq_real <= freq_real + 11'd100;
	else if(key_rasing[1])
		freq_real <= freq_real + 11'd10;
	else if(key_rasing[0])
		freq_real <= freq_real + 11'd1;
	else ;
end

wire [9:0] freq = freq_real[9:0];

endmodule
