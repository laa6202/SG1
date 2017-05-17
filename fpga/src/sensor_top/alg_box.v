//alg_box.v

//`define ALG_BOX_EN
//`define ALG_BOX_EN

module alg_box(
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

//----------------------------------
//----------------------------------


//----------- main FSM ------------
parameter S_IDLE = 3'h0;
parameter S_TRIG = 3'h1;
parameter S_MEAS = 3'h2;
parameter S_CHECK = 3'h3;
parameter S_WAIT = 3'h4;
parameter S_DONE = 3'h7;
reg [2:0] st_alg;
wire done_lega;
wire done_alg;
wire done_wait;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_alg <= S_IDLE;
	else begin
		case(st_alg)
			S_IDLE : st_alg <= fire_measure ? S_TRIG : S_IDLE;
			S_TRIG : st_alg <= S_MEAS;
			S_MEAS : st_alg <= done_lega ? S_CHECK : S_MEAS;
			S_CHECK: st_alg <= done_alg ? S_DONE : S_WAIT;
			//S_CHECK: st_alg <= S_DONE ;
			S_WAIT : st_alg <= done_wait ? S_TRIG : S_WAIT;
			S_DONE : st_alg <= S_IDLE;
			default : st_alg <= S_IDLE;
		endcase
	end
end


//---------- FSM switch condition --------

reg [3:0] cnt_redo;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_redo <= 4'h0;
	else if(st_alg == S_DONE)
		cnt_redo <= 4'h0;
	else if(st_alg == S_CHECK)
		cnt_redo <= cnt_redo + 4'h1;
	else ;
end
`ifdef SIM
assign done_alg = (cnt_redo == 4'h2) ? 1'b1 : 1'b0;
`else 
assign done_alg = (cnt_redo == 4'h4) ? 1'b1 : 1'b0;
`endif


reg [31:0] cnt_wait;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_wait <= 32'h0;
	else if(st_alg == S_WAIT)
		cnt_wait <= cnt_wait + 32'h1;
	else 
		cnt_wait <= 32'h0;
end
`ifdef SIM
assign done_wait = (cnt_wait == 32'd100) ? 1'b1: 1'b0;
`else
assign done_wait = (cnt_wait == 32'd20_000_00) ? 1'b1 : 1'b0;
`endif




//-------------- lega box -----------
wire fire_lega = (st_alg == S_TRIG) ? 1'b1 : 1'b0;

wire [31:0] data_lega;
wire err_lega;

lega_box u_lega_box(
.trig(trig),
.echo(echo),
.fire_measure(fire_lega),
.done_measure(done_lega),
.err_measure(err_lega),
.data_measure(data_lega),
.clk_sys(clk_sys),
.clk_slow(clk_slow),
.rst_n(rst_n)
);




//---------- data output -----------
reg [31:0] data_min;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		data_min <= 32'hffff_ffff;
	else if(st_alg == S_IDLE)
		data_min <= 32'hffff_ffff;
	else if((done_lega)& (~err_lega))
		data_min <= (data_min <= data_lega) ? data_min : data_lega;
	else ;
end
reg [31:0] data_measure;
reg 			 done_measure;
reg				err_measure;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		done_measure <= 1'b0;
	else if(st_alg == S_DONE)
		done_measure <= 1'b1;
	else 
		done_measure <= 1'b0;
end
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		data_measure <= 32'hffff_ffff;
	else if(st_alg == S_DONE)
`ifdef ALG_BOX_EN	
		data_measure <= data_min;
`else
		data_measure <= data_lega;
`endif
	else ;
end
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		err_measure <= 1'b0;
	else if(st_alg == S_DONE)
`ifdef ALG_BOX_EN	
		err_measure <= (data_min == 32'hffff_ffff) ? 1'b1 : 1'b0;
`else
		err_measure <= err_lega;
`endif
	else ;
end


endmodule
