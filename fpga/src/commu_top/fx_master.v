//fx_master.v

module fx_master(
//phy data
rx_data,
rx_vld,
tx_data,
tx_vld,
//fx bus
fx_waddr,
fx_wr,
fx_data,
fx_rd,
fx_raddr,
fx_q,
//clk rst
clk_sys,
rst_n
);
//phy data
input [7:0]	rx_data;
input				rx_vld;
output [7:0]	tx_data;
output 				tx_vld;
//fx_bus
output 				fx_wr;
output [7:0]	fx_data;
output [21:0]	fx_waddr;
output [21:0]	fx_raddr;
output 				fx_rd;
input  [7:0]	fx_q;
//clk rst
input clk_sys;
input rst_n;
//--------------------------------------
//--------------------------------------



endmodule
