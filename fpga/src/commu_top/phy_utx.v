//phy_utx.v

module phy_utx(
uart_tx,
tx_data,
tx_vld,
//clk rst
clk_sys,
pluse_us,
rst_n
);
input uart_tx;
output [7:0]	tx_data;
output 				tx_vld;
//clk rst
input clk_sys;
input pluse_us;
input rst_n;
//---------------------------------
//---------------------------------


//--------- main counter ----------
reg [7:0] cnt_us;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_us <= 8'd0;
	else if(pluse_us)	begin
		if(cnt_us== 8'd99)
			cnt_us <= 8'd0;
		else if(tx_vld)
			cnt_us <= 8'd1;
		else if(cnt_us != 8'd0)
			cnt_us <= cnt_us + 8'h1;
		else ;
	end
	else ;
end

reg xor_tx;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		xor_tx <= 1'b0;
	else if(tx_vld)
		xor_tx <= ^tx_data;
	else ;
end

endmodule
