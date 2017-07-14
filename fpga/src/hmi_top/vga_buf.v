//vga_buf.v


module vga_buf(
//from ov 
num_line,
num_pclk,
data_pclk,
data_vld,
//ram write
ram_wdata,
ram_waddr,
ram_wren,
//clk rst
clk_sys,
pluse_us,
rst_n

);
//from ov 
input [15:0]	num_line;
input [15:0]	num_pclk;
input [7:0]		data_pclk;
input					data_vld;
//ram write
output [15:0]	ram_wdata;
output [9:0]	ram_waddr;
output				ram_wren;
//clk rst
input clk_sys;
input pluse_us;
input rst_n;

//---------------------------------------
//---------------------------------------

//wire ram_wren = data_vld & num_pclk[0];
wire ram_wren = data_vld & num_pclk[0] & (num_line == 16'd240);		//only one line
wire [9:0] ram_waddr = num_pclk[10:1];
reg [7:0] data_high;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		data_high <= 8'h0;
	else if(data_vld & (~num_pclk[0]))
		data_high <= data_pclk;
	else;
end
wire [15:0] ram_wdata = {data_high,data_pclk};


endmodule

