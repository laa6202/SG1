//hc_sr04.v

module hc_sr04(
s1_trig,
s1_echo,
clk_1m,
rst_n
);
input		s1_trig;
output 	s1_echo;
input		clk_1m;
input 	rst_n;
//----------------------------------


wire trig = s1_trig;
reg trig_reg;
always @ (posedge clk_1m)
	trig_reg <= trig;
wire trig_falling = trig_reg & (~trig);


reg [7:0]  cnt_1m;
always @(posedge clk_1m or negedge rst_n)	begin
	if(~rst_n)
		cnt_1m <= 8'h0;
	else if(cnt_1m == 8'd7)
		cnt_1m <= 8'h0;
	else if(trig_falling)
		cnt_1m <= 8'h1;
	else if(cnt_1m != 8'h0)
		cnt_1m <= cnt_1m + 8'h1;
	else ;
end

wire s1_echo = (cnt_1m >= 8'd1) & (cnt_1m <= 8'd5);


endmodule

