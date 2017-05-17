//phy_urx.v
//clk_sys = 100MHz, uart baud rate is 115200,		
//length of every bit is 8.68us


module phy_urx(
uart_rx,
rx_data,
rx_vld,
//clk rst
clk_sys,	
pluse_us,
rst_n
);
output 				uart_rx;
output [7:0]	rx_data;
output 				rx_vld;
//clk rst
input clk_sys;
input pluse_us;
input rst_n;
//---------------------------------
//---------------------------------


//--------- filter uart_rx --------
wire urx_data;
urx_filter u_urx_filter(
.urx_p0(uart_rx),
.urx_p1(urx_data),
//clk rst
.clk_sys(clk_sys),
.rst_n(rst_n)
);


//--------- main counter ----------
reg [7:0] cnt_us;
wire start_uart;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_us <= 8'd0;
	else if(pluse_us)	begin
		if(cnt_us== 8'd99)
			cnt_us <= 8'd0;
		else if(start_uart)
			cnt_us <= 8'd1;
		else if(cnt_us != 8'd0)
			cnt_us <= cnt_us + 8'h1;
		else ;
	end
	else ;
end


reg urx_data_reg;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		urx_data_reg <= 1'b1;
	else if(pluse_us)
		urx_data_reg <= urx_data;
	else ;
end
wire urx_data_falling = (urx_data_reg) & (~urx_data);
assign start_uart = urx_data_falling & (cnt_us == 8'd0) & pluse_us;


//------ data out ------
reg [7:0] rx_data;
reg 			rx_vld;


endmodule
