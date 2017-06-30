module tb;

wire mclk0;
wire mclk1;
wire mclk2;
wire rst_n;

clk_gen u_clk_gen(
.clk_50m(mclk0),
.clk_100m(mclk1),
.clk_1m(mclk2)
);

rst_gen u_rst_gen(
.rst_n(rst_n)
);

wire key_n;
key_gen u_key_gen(
.key_n(key_n)
);

wire s1_trig;
wire s1_echo;
hc_sr04 u_hc_sr04(
.s1_trig(s1_trig), 
.s1_echo(s1_echo),
.clk_1m(mclk2),
.rst_n(rst_n)
);

wire uart_miso;
wire uart_mosi;
rs232 rs232_master(
.uart_tx(uart_mosi),
.uart_rx(uart_miso)
);


//---------- DUT -----------
top sg1_top(
//sensor
.s1_trig(s1_trig),
.s1_echo(s1_echo),
//uart slave
.uart_tx(uart_miso),
.uart_rx(uart_mosi),
//ov inf
.ov_vcc(),
.ov_gnd(),
.ov_vsync(),
.ov_href(),
.ov_pclk(),
.ov_xclk(),
.ov_data(),
.ov_rstn(),
.ov_pwdn(),
.ov_sioc(),
.ov_siod(),
//hmi_top
.led(),
.key_n(key_n),
.ref0(),
.ref1(),
//clk rst 
.mclk0(mclk0),
.mclk1(mclk1),
.mclk2(mclk2),
.hrst_n(rst_n)
);

endmodule
