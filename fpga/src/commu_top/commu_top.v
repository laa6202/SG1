//commu_top.v

module commu_top(
//uart slave
uart_tx,
uart_rx,
//fx bus
fx_waddr,
fx_wr,
fx_data,
fx_rd,
fx_raddr,
fx_q,
//clk rst
clk_sys,
pluse_us,
rst_n
);
//uart slave
output 	uart_tx;
input 	uart_rx;
//fx_bus
output 				fx_wr;
output [7:0]	fx_data;
output [31:0]	fx_waddr;
output [31:0]	fx_raddr;
output 				fx_rd;
input  [7:0]	fx_q;
//clk rst
input clk_sys;
input pluse_us;
input rst_n;
//-----------------------------------------
//-----------------------------------------


//--------- uart physical level ---------
wire [7:0] 	rx_data;
wire				rx_vld;
phy_urx u_phy_urx(
.uart_rx(uart_rx),
.rx_data(rx_data),
.rx_vld(rx_vld),
//clk rst
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


wire [7:0] 	tx_data;
wire				tx_vld;
phy_utx u_phy_utx(
.uart_tx(uart_tx),
.tx_data(tx_data),
.tx_vld(tx_vld),
//clk rst
.clk_sys(clk_sys),
.rst_n(rst_n)
);




endmodule

