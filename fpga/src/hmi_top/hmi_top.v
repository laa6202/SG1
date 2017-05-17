//hmi_top.v

module hmi_top(
key_n,
ref0,
ref1,
led,
key_vld,
clk_sys,
clk_slow,
rst_n
);
input key_n;
output ref0;
output ref1;
output [3:0]	led;
output 	key_vld;
input clk_sys;
input clk_slow;
input rst_n;
//-----------------------------------
//-----------------------------------


wire ref0 = 1'b0;
wire ref1 = 1'b1;

reg [27:0] cnt_cycle;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_cycle <= 28'h0;
	else 
		cnt_cycle <= cnt_cycle + 28'h1;
end
wire [3:0] led;
assign led = cnt_cycle[27:24];


//----------- key --------------
wire key = ~key_n;
reg [15:0] cnt_us;
always @ (posedge clk_slow or negedge rst_n)	begin	
	if(~rst_n)
		cnt_us <= 16'h0;
	else 
		cnt_us <= cnt_us + 16'h1;
end
reg [7:0] key_reg;
always @(posedge clk_slow or negedge rst_n) begin	
	if(~rst_n)
		key_reg <= 8'h0;
	else if(cnt_us[9:0] == 10'h0)
		key_reg <= {key_reg [6:0],key};
	else ;
end


`ifdef SIM
wire key_true = key;
`else
reg key_true;
always @ (posedge clk_slow or negedge rst_n) begin	
	if(~rst_n)
		key_true <= 1'b0;
	else if(key_reg == 8'hff)
		key_true <= 1'b1;
	else if(key_reg == 8'h0)
		key_true <= 1'b0;
	else ;
end
`endif

reg key_true_reg;
`ifdef SIM
always @ (posedge clk_sys)
	key_true_reg <= key_true;
`else
always @ (posedge clk_slow)
	key_true_reg <= key_true;
`endif

wire key_vld;
assign	key_vld = (~key_true_reg) & key_true;

endmodule
