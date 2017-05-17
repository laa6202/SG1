//pluse_us_gen.v

//clk_sys = 100M => LEN_1US = 99(100-1)
//clk_sys = 80M => LEN_1US = 79(80-1)
`define LEN_1US  8'd99
//SIM : LEN_1US_SIM = 0(1-1)
`define LEN_1US_SIM 	8'd0

module pluse_us_gen(
pluse_us,
clk_sys,
rst_n
);
output pluse_us;
input clk_sys;
input rst_n;
//------------------------------------
//------------------------------------

reg [7:0] cnt_cycle;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_cycle <= 8'h0;
`ifdef SIM
	else if(cnt_cycle == `LEN_1US_SIM)		//SIM 1 cycle == 1us
`else
	else if(cnt_cycle == `LEN_1US)
`endif
		cnt_cycle <= 8'h0;
	else 
		cnt_cycle <= cnt_cycle + 8'h1;
end

reg pluse_us;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		pluse_us <= 1'b0;
`ifdef SIM
	else if(cnt_cycle == `LEN_1US_SIM)
`else
	else if(cnt_cycle == `LEN_1US)
`endif
		pluse_us <= 1'b1;
	else 
		pluse_us <= 1'b0;
end


endmodule

