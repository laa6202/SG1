//pluse_ms_gen.v


`define LEN_1MS  10'd999


module pluse_ms_gen(
pluse_ms,
pluse_us,
clk_sys,
rst_n
);
output pluse_ms;
input pluse_us;
input clk_sys;
input rst_n;
//------------------------------------
//------------------------------------

reg [9:0] cnt_us;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_us <= 10'h0;
	else if(pluse_us) begin
		if(cnt_us == `LEN_1MS)
			cnt_us <= 10'h0;
		else 
			cnt_us <= cnt_us + 10'h1;
	end
	else ;
end

reg pluse_ms;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		pluse_ms <= 1'b0;
	else if(pluse_us)	begin
		if(cnt_us == `LEN_1MS)
			pluse_ms <= 1'b1;
		else 
			pluse_ms <= 1'b0;
	end
	else ;
end


endmodule

