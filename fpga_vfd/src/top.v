//top.v
// top of vfd project

module top(
key,
led,
smg_data,
smg_scan,
pwm,
pwm2,
//hclk hrst in
mclk0,
mclk1,
mclk2,
hrst_n
);
input  [2:0]	key;
output [3:0] 	led;
output [7:0]	smg_data;
output [5:0]	smg_scan;
output				pwm;
output				pwm2;
//hclk hrst in
input mclk0;
input mclk1;
input mclk2;
input hrst_n;
//--------------------------------------
//--------------------------------------


wire clk_sys;
wire clk_slow;
wire rst_n;
wire pluse_us;
wire pluse_ms;
clk_rst_top u_clk_rst(
.hrst_n(hrst_n),
.mclk0(mclk0),
.mclk1(mclk1),
.mclk2(mclk2),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.pluse_us(pluse_us),
.pluse_ms(pluse_ms),
.rst_n(rst_n)
);


//----------- hmi_top --------
wire [9:0]	freq;
hmi_top u_hmi_top(
.key(~key),
.freq(freq),
.smg_data(smg_data),
.smg_scan(smg_scan),
//clk rst
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.pluse_ms(pluse_ms),
.rst_n(rst_n)
);



//---------- vfd_top --------
wire pwm;
wire pwm2 = ~pwm;
vfd_top u_vfd( 
.pwm(pwm),
.freq(freq),
//clk rst
.clk_sys(clk_sys),
.rst_n(rst_n)
);


//---------- led --------
wire [3:0]	led;
assign led[0] = &key;
assign led[1] = 1'b1;
assign led[2] = 1'b0;
assign led[3] = pwm;


endmodule

