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
//fx bus
fx_waddr,
fx_wr,
fx_data,
fx_rd,
fx_raddr,
fx_q,
dev_id,
//clk rst
clk_sys,
clk_24m,
pluse_us,
rst_n

);
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
//fx_bus
input 				fx_wr;
input [7:0]		fx_data;
input [21:0]	fx_waddr;
input [21:0]	fx_raddr;
input 				fx_rd;
output  [7:0]	fx_q;
input [5:0] dev_id;
//clk rst
input clk_sys;
input clk_24m;
input pluse_us;
input rst_n;
//-------------------------------------
//-------------------------------------


//----------- mclk -----------
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


//---------- power down and rst --------
reg ov_rstn;
reg ov_pwdn;
always @(posedge clk_sys)	begin
	ov_rstn <= rst_n;
	ov_pwdn <= 1'b0;
end



//-------- iic regs -------
// registers 
wire [7:0] stu_iic_status;	
wire [7:0] cfg_iic_devid;	
wire [7:0] cfg_iic_addr;		
wire [7:0] cfg_iic_wdata;	
wire [7:0] stu_iic_rdata;	
wire [7:0] act_iic_write;
wire [7:0] act_iic_read;	
iic_reg u_iic_reg(
//fx bus
.fx_waddr(fx_waddr),
.fx_wr(fx_wr),
.fx_data(fx_data),
.fx_rd(fx_rd),
.fx_raddr(fx_raddr),
.fx_q(fx_q),
// registers 
.stu_iic_status(stu_iic_status),	
.cfg_iic_devid(cfg_iic_devid),	
.cfg_iic_addr(cfg_iic_addr),	
.cfg_iic_wdata(cfg_iic_wdata),	
.stu_iic_rdata(stu_iic_rdata),	
.act_iic_write(act_iic_write),
.act_iic_read(act_iic_read),
//clk rst
.dev_id(dev_id),
.clk_sys(clk_sys),
.rst_n(rst_n)

);


	
//------------ iic -----------
iic_inf u_iic_inf(
.scl(ov_sioc),		//100K
.sda(ov_siod),
// registers 
.stu_iic_status(stu_iic_status),	
.cfg_iic_devid(cfg_iic_devid),	
.cfg_iic_addr(cfg_iic_addr),	
.cfg_iic_wdata(cfg_iic_wdata),	
.stu_iic_rdata(stu_iic_rdata),	
.act_iic_write(act_iic_write),
.act_iic_read(act_iic_read),
//clk rst
.clk_sys(clk_sys),
.pluse_us(pluse_us),
.rst_n(rst_n)
);


//---------- for debug -----------
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

