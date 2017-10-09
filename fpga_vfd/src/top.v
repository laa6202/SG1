//top.v
// top of vfd project

module top(
sw,
key,
led,
//hclk hrst in
mclk0,
mclk1,
mclk2,
hrst_n
);
input					sw;
input  [7:0]	key;
output [3:0] 	led;
//hclk hrst in
input mclk0;
input mclk1;
input mclk2;
input hrst_n;
//--------------------------------------
//--------------------------------------


wire clk_sys;
wire pluse_us;
clk_rst_top u_clk_rst(
.hrst_n(hrst_n),
.mclk0(mclk0),
.mclk1(mclk1),
.mclk2(mclk2),
.clk_sys(clk_sys),
.clk_slow(),
.clk_24m(),
.clk_40m(),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


//----------- hmi_top --------
wire [7:0]	freq;
hmi_top u_hmi_top(
.sw(sw),
.key(key),
.freq(freq),
//clk rst
.clk_sys(clk_sys),
.rst_n(rst_n)
);


endmodule

