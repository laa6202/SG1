//hmi_top.v
//the hmi of vfd

module hmi_top(
key,
freq,
smg_data,
smg_scan,
//clk rst
clk_sys,
clk_slow,
pluse_ms,
rst_n
);
input [2:0]		key;
output [9:0]	freq;
output [7:0] 	smg_data;
output [5:0]	smg_scan;
//clk rst
input clk_sys;
input clk_slow;
input pluse_ms;
input rst_n;
//-----------------------------------
//-----------------------------------

wire [9:0] freq;
freq_gen u_freq_gen(
.key(key),
.freq(freq),
//clk rst
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.pluse_ms(pluse_ms),
.rst_n(rst_n)
);

wire [11:0] freq_smg;
hex2bcd u_hex2bcd(
.d_in(freq),
.d_out(freq_smg)
);


smg_interface u_smg_inf(
.CLK(clk_sys),
.RSTn(rst_n),
.Number_Sig({12'h0,freq_smg}),
.SMG_Data(smg_data),
.Scan_Sig(smg_scan)
);


endmodule


