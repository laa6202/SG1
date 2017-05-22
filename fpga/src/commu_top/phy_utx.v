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
output uart_tx;
input [7:0]	tx_data;
input 			tx_vld;
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
	else if(cnt_us== 8'd99)
			cnt_us <= 8'd0;
	else if(tx_vld)
		cnt_us <= 8'd1;		
	else if(cnt_us != 8'd0)
			cnt_us <= pluse_us ? (cnt_us + 8'h1) : cnt_us;
	else ;
end

reg xor_tx;
reg [7:0] lock_tx;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n) begin
		xor_tx <= 1'b0;
		lock_tx <= 8'h0;
	end
	else if(tx_vld) begin
		xor_tx <= ^tx_data;
		lock_tx <= tx_data;
	end
	else ;
end


//--------- uart tx output ----------
reg uart_tx;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		uart_tx <= 1'b1;
	else if(pluse_us)	begin
		case(cnt_us)
			8'd1 : uart_tx <= 1'b0;		//start bit
			8'd9 : uart_tx <= lock_tx[0];
			8'd18 : uart_tx <= lock_tx[1];
			8'd26 : uart_tx <= lock_tx[2];
			8'd35 : uart_tx <= lock_tx[3];
			8'd44 : uart_tx <= lock_tx[4];
			8'd53 : uart_tx <= lock_tx[5];
			8'd61 : uart_tx <= lock_tx[6];
			8'd70 : uart_tx <= lock_tx[7];
			8'd79 : uart_tx <= 1'b1;	//no XOR_TX
			8'd87 : uart_tx <= 1'b1;	//stop bit
			default : ;
		endcase
	end
	else ;
end
	
endmodule
