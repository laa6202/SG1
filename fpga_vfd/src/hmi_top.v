//hmi_top.v
//the hmi of vfd

module hmi_top(
sw,
key,
freq,
//clk rst
clk_sys,
rst_n
);
input sw;
input [7:0]		key;
output [7:0]	freq;
//clk rst
input clk_sys;
input rst_n;
//-----------------------------------
//-----------------------------------

wire [7:0] freq = key;

endmodule


