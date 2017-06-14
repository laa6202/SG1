//ov_inf.v

module ov_inf(
ov_vcc,
ov_gnd,
ov_vsync,
ov_href,
ov_pclk,
ov_xclk,
ov_data,
ov_rstn,
ov_pwdn,
//clk rst
clk_sys,
rst_n

);
output ov_vcc;
output ov_gnd;
input  ov_vsync;
input  ov_href;
input  ov_pclk;
output ov_xclk;
input  [7:0]	ov_data;
output ov_rstn;
output ov_pwdn;
//clk rst
input clk_sys;
input rst_n;
//-------------------------------------

reg ov_vcc;
reg ov_gnd;
reg ov_xclk;
reg ov_rstn;
reg ov_pwdn;

reg [1:0] cnt_cycle;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_cycle <= 2'h0;
	else 
		cnt_cycle <= cnt_cycle + 2'h1;
end


always @(posedge clk_sys)	begin
	ov_vcc <= 1'b1;
	ov_gnd <= 1'b0;
	ov_xclk <= cnt_cycle[1];
	ov_rstn <= rst_n;
	ov_pwdn <= 1'b0;
end
	
endmodule
