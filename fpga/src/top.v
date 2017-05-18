//top.v
//top of SG_logic1

module top(
//sensor
s1_trig,
s1_echo,
//uart inf
uart_tx,
uart_rx,
//hmi_top
led,
key_n,
ref0,
ref1,
//clk rst 
mclk0,
mclk1,
mclk2,
hrst_n
);
//sensor
output	s1_trig;
input		s1_echo;
//uart slave
output 	uart_tx;
input 	uart_rx;
//hmi
output [3:0]	led;
input		key_n;
output	ref0;
output 	ref1;
input 	mclk0;
input 	mclk1;
input 	mclk2;
input		hrst_n;
//-----------------------------------
//-----------------------------------

//--------- clk rst -----------
wire clk_sys;
wire clk_slow;
wire rst_n;
wire pluse_us;
clk_rst_top u_clk_rst(
.hrst_n(hrst_n),
.mclk0(mclk0),
.mclk1(mclk1),
.mclk2(mclk2),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


//---------- hmi -------------
wire [3:0] led_n;
wire key_vld;
hmi_top u_hmi_top(
.key_n(key_n),
.led(led_n),
.ref0(ref0),
.ref1(ref1),
.key_vld(key_vld),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.rst_n(rst_n)
);
assign led = led_n;


//------------ commu_top ----------
//fx_bus
wire 				fx_wr;
wire [7:0]	fx_data;
wire [21:0]	fx_waddr;
wire [21:0]	fx_raddr;
wire 				fx_rd;
wire  [7:0]	fx_q;
commu_top u_commu_top(
//uart slave
.uart_tx(uart_tx),
.uart_rx(uart_rx),
//fx bus
.fx_waddr(fx_waddr),
.fx_wr(fx_wr),
.fx_data(fx_data),
.fx_rd(fx_rd),
.fx_raddr(fx_raddr),
.fx_q(fx_q),
//clk rst
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


//------------ sensor -------
wire s1_echo_p1;
echo_handle u_echo_handle(
.echo_p0(s1_echo),
.echo_p1(s1_echo_p1),
.clk_sys(clk_sys),
.rst_n(rst_n)
);


alg_box u_alg_box(
.trig(s1_trig),
.echo(s1_echo_p1),
.fire_measure(key_vld),
.done_measure(),
.err_measure(),
.data_measure(),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.rst_n(rst_n)
);



endmodule
