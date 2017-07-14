//ov_monitor.v

module ov_monitor(
ov_data,
ov_href,
ov_vsync,
ov_pclk,
cnt_pclk,
cnt_line,
data_pclk,
data_vld,
//clk rst
clk_sys,
rst_n
);
input [7:0]	ov_data;
input ov_href;
input ov_vsync;
input ov_pclk;
output [15:0]	cnt_pclk;
output [15:0]	cnt_line;
output [7:0]	data_pclk;
output 				data_vld;
//clk rst
input clk_sys;
input rst_n;

//-----------------------------------------
//-----------------------------------------

//----------- fitter ----------
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
	
		
reg [1:0]ov_href_reg;
always @ (posedge clk_sys)
	ov_href_reg <= {ov_href_reg[0],ov_href};
wire ov_href_rasing = ov_href_reg[0] & (~ov_href_reg[1]);


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


reg [15:0] cnt_line;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_line <= 16'h0;
	else if(ov_vs)
		cnt_line <= 16'h0;
	else if(ov_href_rasing)
		cnt_line <= cnt_line + 16'h1;
	else ;
end

reg [7:0]	data_pclk;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		data_pclk <= 8'h0;
	else 
		data_pclk <= ov_data;
end
wire data_vld = ov_pclk_rasing & ov_href_reg[1];


endmodule

