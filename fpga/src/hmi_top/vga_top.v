//vga_top.v



module vga_top(
//vga output
vga_r,
vga_g,
vga_b,
vga_hsync,
vga_vsync,
//from ov 
num_line,
num_pclk,
data_pclk,
data_vld,
//clk rst
clk_sys,
pluse_us,
rst_n
);
//vga output
output [4:0]	vga_r;
output [5:0]	vga_g;
output [4:0]	vga_b;
output vga_hsync;
output vga_vsync;
//from ov 
input [15:0]	num_line;
input [15:0]	num_pclk;
input [7:0]		data_pclk;
input					data_vld;
//clk rst
input clk_sys;
input pluse_us;
input rst_n;
//-----------------------------------------
//-----------------------------------------


//ram write
wire [15:0]	ram_wdata;
wire [9:0]	ram_waddr;
wire				ram_wren;
wire [9:0]	ram_raddr;
wire [15:0]	ram_q;
ram640_16 u_ram640x16(
.clock(clk_sys),
.data(ram_wdata),
.rdaddress(ram_raddr),
.wraddress(ram_waddr),
.wren(ram_wren),
.q(ram_q)
);


//--------- vga buf -------
vga_buf u_vga_buf(
//from ov 
.num_line(num_line),
.num_pclk(num_pclk),
.data_pclk(data_pclk),
.data_vld(data_vld),
//ram write
.ram_wdata(ram_wdata),
.ram_waddr(ram_waddr),
.ram_wren(ram_wren),
//clk rst
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)

);


vga_inf u_vga_inf(
//vga output
.vga_r(vga_r),
.vga_g(vga_g),
.vga_b(vga_b),
.vga_hsync(vga_hsync),
.vga_vsync(vga_vsync),
//ram read
.ram_raddr(ram_raddr),
.ram_q(ram_q),
//clk rst
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)
);

endmodule

