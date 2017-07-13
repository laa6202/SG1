//vga_top.v

`define LAST_US 	6'd31
`define LAST_LINE 10'd519

module vga_top(
//vga output
vga_r,
vga_g,
vga_b,
vga_hsync,
vga_vsync,

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

//clk rst
input clk_sys;
input pluse_us;
input rst_n;
//-----------------------------------------
//-----------------------------------------


//--------- us and line count ---------
reg [5:0] cnt_us;
reg [9:0] cnt_line;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_us <= 6'h0;
	else if(pluse_us)	begin
		if(cnt_us == `LAST_US)
			cnt_us <= 6'h0;
		else 
			cnt_us <= cnt_us + 6'h1;
	end
	else ;
end
wire pluse_line;
assign pluse_line = (cnt_us == `LAST_US) & pluse_us;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_line <= 10'h0;
	else if(pluse_line)	begin
		if(cnt_line == `LAST_LINE)
			cnt_line <= 10'h0;
		else 
			cnt_line <= cnt_line + 10'h1;
	end
	else ;
end


//-------- output hsync and vsync ---------
reg hsync;
reg vsync;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		hsync <= 1'b1;
	else 
		hsync <= (cnt_us < 6'h4) ? 1'b0 : 1'b1;
end
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		vsync <= 1'b1;
	else 
		vsync <= (cnt_line < 6'h2) ? 1'b0 : 1'b1;
end
wire vga_hsync = hsync;
wire vga_vsync = vsync;


//----------- hsync_de and vsync_de ---------
reg [1:0] cnt_cycle;
wire pulse_4cycle;
reg [9:0] cnt_pixel;
wire hsync_de;
wire vsync_de;
always @ (posedge clk_sys)	begin
	cnt_cycle <= cnt_cycle + 2'h1;
end

assign pulse_4cycle = (cnt_cycle == 2'h3) ? 1'b1 : 1'b0;

always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_pixel <= 10'h0;
	else if(pulse_4cycle)	begin
		if(cnt_pixel == 10'd639)
			cnt_pixel = 10'h0;
		else if(cnt_pixel != 10'h0)
			cnt_pixel <= cnt_pixel + 10'h1;
		else if(cnt_us == 6'h6)
			cnt_pixel <= 10'h1;
		else ;
	end
	else ;
end
assign hsync_de = (cnt_pixel != 10'h0) ? 1'b1 : 1'b0;
assign vsync_de = (cnt_line >= 10'd30) & (cnt_line < 10'd510);

//----------- output color --------
wire [4:0]	vga_r;
wire [5:0]	vga_g;
wire [4:0]	vga_b;
assign vga_r = hsync_de & vsync_de ? 5'h1f : 5'h0;
assign vga_g = hsync_de & vsync_de ? 6'h0 : 6'h0;
assign vga_b = hsync_de & vsync_de ? 5'h1f : 5'h0;


endmodule

