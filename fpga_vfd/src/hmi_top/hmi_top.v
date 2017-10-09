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
input [2:0]		key;
output [9:0]	freq;

//clk rst
input clk_sys;
input rst_n;
//-----------------------------------
//-----------------------------------

reg [9:0] freq_org = 10'd50;

wire [7:0] freq;

endmodule


