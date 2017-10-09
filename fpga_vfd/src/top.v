//top.v
// top of vfd project

module top(
sw,
key,
led,
nixie0,
nixie1,
nixie2,
pwm,
//hclk hrst in
mclk0,
mclk1,
mclk2,
hrst_n
);
input					sw;
input  [2:0]	key;
output [3:0] 	led;
output [7:0]	nixie0;
output [7:0]	nixie1;
output [7:0]	nixie2;
output				pwm;
//hclk hrst in
input mclk0;
input mclk1;
input mclk2;
input hrst_n;
//--------------------------------------
//--------------------------------------


wire clk_sys;
wire rst_n;
wire pluse_us;
clk_rst_top u_clk_rst(
.hrst_n(hrst_n),
.mclk0(mclk0),
.mclk1(mclk1),
.mclk2(mclk2),
.clk_sys(clk_sys),
.clk_slow(),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


//----------- hmi_top --------
wire [9:0]	freq;
hmi_top u_hmi_top(
.sw(sw),
.key(key),
.freq(freq),
.nixie0(nixie0),
.nixie1(nixie1),
.nixie2(nixie2),
//clk rst
.clk_sys(clk_sys),
.rst_n(rst_n)
);



//---------- led --------
wire [3:0]	led;
assign led[0] = 1'b0;
assign led[1] = sw;
assign led[2] = 1'b0;
assign led[3] = pwm;


endmodule

