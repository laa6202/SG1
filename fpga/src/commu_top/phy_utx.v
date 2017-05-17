//phy_utx.v

module phy_utx(
uart_tx,
tx_data,
tx_vld,
//clk rst
clk_sys,
rst_n
);
input uart_tx;
output [7:0]	tx_data;
output 				tx_vld;
//clk rst
input clk_sys;
input rst_n;
//---------------------------------
//---------------------------------


endmodule
