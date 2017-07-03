//fx_bus.v
//bus for more slave 

module fx_bus(
//for more device
fx_q_control,
fx_q_ov_inf,
//for master
fx_q,
//clk rsr
clk_sys,
rst_n
);
//for more device
input [7:0]	fx_q_control;
input [7:0]	fx_q_ov_inf;
//for master
output [7:0]	fx_q;
//clk rsr
input clk_sys;
input rst_n;
//------------------------------------------
//------------------------------------------

wire [7:0] fx_q;
assign fx_q = fx_q_control | fx_q_ov_inf;


endmodule



