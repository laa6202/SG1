//lega_box.v
//legality check and box

module lega_box(
trig,
echo,
fire_measure,
done_measure,
err_measure,
data_measure,
clk_sys,
clk_slow,
rst_n
);
output trig;
input echo;
input fire_measure;
output done_measure;
output err_measure;
output [31:0] data_measure;
input clk_sys;
input clk_slow;
input rst_n;
//---------------------------------


parameter S_IDLE = 4'h0;
parameter S_INIT = 4'h1;
parameter S_MEAS = 4'h2;
parameter S_LEGA = 4'h3;
parameter S_TOUT = 4'h4;
parameter S_TRIG = 4'h5;
parameter S_DERR = 4'h6;
parameter S_DONE = 4'h7;
parameter S_WAIT = 4'he;
reg [3:0] st_lega;
wire ok_lega;
wire now_timeout;
wire done_core;
wire done_wait;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_lega <= S_IDLE;
	else begin
		case(st_lega)
			S_IDLE : st_lega <= fire_measure ? S_INIT : S_IDLE;
			S_INIT : st_lega <= S_MEAS;
			S_MEAS : st_lega <= done_core ? S_LEGA : S_MEAS;
			S_LEGA : st_lega <= ok_lega ? S_DONE : S_TOUT;
			S_TOUT : st_lega <= now_timeout ? S_DERR : S_WAIT;
			S_WAIT : st_lega <= done_wait ? S_TRIG : S_WAIT;
			S_TRIG : st_lega <= S_MEAS;
			S_DERR : st_lega <= S_IDLE;
			S_DONE : st_lega <= S_IDLE;
			default : st_lega <= S_IDLE;
		endcase
	end
end


//---------- FSM switch condition ----------
`ifdef SIM
assign ok_lega = (data_measure <= 32'd2000) ? 1'b1 : 1'b0;
`else
assign ok_lega = (data_measure[31:20] >= 12'h002) ? 1'b0 : 1'b1;
`endif

reg [3:0] cnt_retry;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_retry <= 4'h0;
	else if(st_lega == S_IDLE)
		cnt_retry <= 4'h0;
	else if(st_lega == S_TOUT)
		cnt_retry <= cnt_retry + 4'h1;
	else ;
end
`ifdef SIM
assign now_timeout = (cnt_retry == 4'd2) ? 1'b1 : 1'b0;
`else 
assign now_timeout = (cnt_retry == 4'd10) ? 1'b1 : 1'b0;
`endif


reg [31:0] cnt_wait;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_wait <= 32'h0;
	else if(st_lega == S_WAIT)
		cnt_wait <= cnt_wait + 32'h1;
	else 
		cnt_wait <= 32'h0;
end
`ifdef SIM
assign done_wait = (cnt_wait == 32'd100) ? 1'b1: 1'b0;
`else
assign done_wait = (cnt_wait == 32'd30_000_00) ? 1'b1 : 1'b0;
`endif


//---------- core -----------
wire fire_core = (st_lega == S_INIT) | (st_lega == S_TRIG);

sensor_core u_sersor_core(
.trig(trig),
.echo(echo),
.fire_measure(fire_core),
.done_measure(done_core),
.data_measure(data_measure),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.rst_n(rst_n)
);

wire done_measure = (st_lega == S_DONE) | (st_lega == S_DERR);
wire err_measure = (st_lega == S_DERR) ? 1'b1 : 1'b0;


endmodule

