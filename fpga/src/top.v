//top.v
//top of SG_logic1

module top(
//sensor
s1_trig,
s1_echo,
//ov7670
ov_vcc,
ov_gnd,
ov_vsync,
ov_href,
ov_pclk,
ov_xclk,
ov_data,
ov_rstn,
ov_pwdn,
ov_sioc,
ov_siod,
//vga output
vga_r,
vga_g,
vga_b,
vga_hsync,
vga_vsync,
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
//ov7670
input  ov_vcc;
input  ov_gnd;
input  ov_vsync;
input  ov_href;
input  ov_pclk;
output ov_xclk;
input  [7:0]	ov_data;
output ov_rstn;
output ov_pwdn;
output ov_sioc;
inout  ov_siod;
//vga output
output [4:0]	vga_r;
output [5:0]	vga_g;
output [4:0]	vga_b;
output vga_hsync;
output vga_vsync;
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
wire clk_24m;
wire rst_n;
wire pluse_us;
clk_rst_top u_clk_rst(
.hrst_n(hrst_n),
.mclk0(mclk0),
.mclk1(mclk1),
.mclk2(mclk2),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.clk_24m(clk_24m),
.pluse_us(pluse_us),
.rst_n(rst_n)
);



//----------- fx_bus ---------
wire  [7:0]	fx_q;
wire [7:0] fx_q_control;
wire [7:0] fx_q_ov_inf;
fx_bus u_fx_bus(
//for more device
.fx_q_control(fx_q_control),
.fx_q_ov_inf(fx_q_ov_inf),
//for master
.fx_q(fx_q),
//clk rsr
.clk_sys(clk_sys),
.rst_n(rst_n)
);


//------------ control_top ------------
//fx_bus
wire 				fx_wr;
wire [7:0]	fx_data;
wire [21:0]	fx_waddr;
wire [21:0]	fx_raddr;
wire 				fx_rd;

control_top u_ctrl_top(
//fx bus
.fx_waddr(fx_waddr),
.fx_wr(fx_wr),
.fx_data(fx_data),
.fx_rd(fx_rd),
.fx_raddr(fx_raddr),
.fx_q(fx_q_control),
//clk rst
.dev_id(6'h1),
.clk_sys(clk_sys),
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







//alg_box u_alg_box(
sensor_core u_sersor(
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



//---------- ov 7670 ------
wire [15:0]	 cnt_line;
wire [15:0]	 cnt_pclk;
wire [7:0]	 data_pclk;
wire 				 data_vld;
ov_inf u_ov_inf(
.ov_vcc(ov_vcc),
.ov_gnd(ov_gnd),
.ov_vsync(ov_vsync),
.ov_href(ov_href),
.ov_pclk(ov_pclk),
.ov_xclk(ov_xclk),
.ov_data(ov_data),
.ov_rstn(ov_rstn),
.ov_pwdn(ov_pwdn),
.ov_sioc(ov_sioc),
.ov_siod(ov_siod),
.cnt_pclk(cnt_pclk),
.cnt_line(cnt_line),
.data_pclk(data_pclk),
.data_vld(data_vld),
//fx bus
.fx_waddr(fx_waddr),
.fx_wr(fx_wr),
.fx_data(fx_data),
.fx_rd(fx_rd),
.fx_raddr(fx_raddr),
.fx_q(fx_q_ov_inf),
.dev_id(6'h02),
//clk rst
.clk_sys(clk_sys),
.clk_24m(clk_24m),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


//---------- vga out ----------
vga_top u_vga_top(
//vga output
.vga_r(vga_r),
.vga_g(vga_g),
.vga_b(vga_b),
.vga_hsync(vga_hsync),
.vga_vsync(vga_vsync),
//form ov
.num_pclk(cnt_pclk),
.num_line(cnt_line),
.data_pclk(data_pclk),
.data_vld(data_vld),
//clk rst
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)
);

endmodule
