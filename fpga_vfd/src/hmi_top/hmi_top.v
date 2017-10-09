//hmi_top.v
//the hmi of vfd

module hmi_top(
key,
freq,
smg_data,
smg_scan,
//clk rst
clk_sys,
rst_n
);
input [2:0]		key;
output [9:0]	freq;
output [7:0] 	smg_data;
output [5:0]	smg_scan;
//clk rst
input clk_sys;
input rst_n;
//-----------------------------------
//-----------------------------------

wire [9:0] freq_org = 10'd50;

reg [9:0] freq;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		freq <= freq_org;
	else 
		freq <= freq + 10'h1;
end


smg_interface u_smg_inf(
.CLK(clk_sys),
.RSTn(rst_n),
.Number_Sig({14'h0,freq_org}),
.SMG_Data(smg_data),
.Scan_Sig(smg_scan)
);


endmodule


