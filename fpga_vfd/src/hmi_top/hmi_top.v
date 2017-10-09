//hmi_top.v
//the hmi of vfd

module hmi_top(
sw,
key,
freq,
nixie0,
nixie1,
nixie2,
//clk rst
clk_sys,
rst_n
);
input sw;
input [2:0]		key;
output [9:0]	freq;
output [7:0]	nixie0;
output [7:0]	nixie1;
output [7:0]	nixie2;
//clk rst
input clk_sys;
input rst_n;
//-----------------------------------
//-----------------------------------

reg [9:0] freq_org = 10'd50;

wire [7:0] freq;

endmodule


