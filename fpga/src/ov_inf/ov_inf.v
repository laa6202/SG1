//ov_inf.v

module ov_inf(
ov_vcc,
ov_gnd,
ov_vsync,
ov_href,
ov_pclk,
ov_xclk,		//24MHz
ov_data,
ov_rstn,
ov_pwdn,
ov_sioc,
ov_siod,
//clk rst
clk_sys,
clk_24m,
pluse_us,
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
output ov_sioc;
inout  ov_siod;
//clk rst
input clk_sys;
input clk_24m;
input pluse_us;
input rst_n;
//-------------------------------------



wire ov_xclk;
`ifdef SIM
reg [1:0] cnt_cycle;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_cycle <= 2'h0;
	else 
		cnt_cycle <= cnt_cycle + 2'h1;
end
`else
assign	ov_xclk = clk_24m;
`endif



always @(posedge clk_sys)	begin
	ov_vcc <= 1'b1;
	ov_gnd <= 1'b0;

	ov_rstn <= rst_n;
	ov_pwdn <= 1'b0;
end


	
reg ov_vcc;
reg ov_gnd;
reg ov_rstn;
reg ov_pwdn;
	
iic_inf u_iic_inf(
.scl(ov_sioc),		//100K
.sda(ov_siod),
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)
);



reg [7:0] vs_reg;
always @ (posedge clk_sys)
	vs_reg <= {vs_reg[6:0],ov_vsync};
	
reg ov_vs;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		ov_vs <= 1'b0;
	else if(vs_reg == 8'hff)
		ov_vs <= 1'b1;
	else if(vs_reg == 8'h0)
		ov_vs <= 1'b0;
	else	;
end
	
		
reg ov_href_reg;
always @ (posedge clk_sys)
	ov_href_reg <= ov_href;

reg [1:0] ov_pclk_reg;
always @ (posedge clk_sys)
	ov_pclk_reg <= {ov_pclk_reg[0],ov_pclk};
wire ov_pclk_rasing = (~ov_pclk_reg[1]) & ov_pclk_reg[0];

reg [15:0] cnt_pclk/*synthesis noprune*/;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_pclk <= 16'h0;
	else if(~ov_href_reg)
		cnt_pclk <= 16'b0;
	else 
		cnt_pclk <= ov_pclk_rasing ? (cnt_pclk + 16'h1) : cnt_pclk;
end
			

reg [15:0] cnt_vs/*synthesis noprune*/;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_vs <= 16'h0;
	else if(~ov_vs)
		cnt_vs <= 16'b0;
	else 
		cnt_vs <= ov_pclk_rasing ? (cnt_vs + 16'h1) : cnt_vs;
end


endmodule

