//vfd_top.v

module vfd_top(
pwm,
freq,
//clk rst
clk_sys,
rst_n
);
output pwm;
input [9:0]	freq;
//clk rst
input clk_sys;
input rst_n;
//----------------------------------------------
//----------------------------------------------


wire [31:0] quto;
div u_div(
.clock(clk_sys),
.denom(freq),
.numer(32'd500_000_00),
.quotient(quto),
.remain()
);


//-------- main FSM --------
parameter S_LOAD = 2'h0;
parameter S_DOWN = 2'h1;
parameter S_UP = 2'h2;
reg [1:0] st_vfd;
wire done_down;
wire done_up;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_vfd <= S_LOAD;
	else begin
		case(st_vfd)
			S_LOAD : st_vfd <= S_DOWN;
			S_DOWN : st_vfd <= done_down ? S_UP : S_DOWN;
			S_UP	 : st_vfd <= done_up 	 ? S_LOAD : S_UP;
			default : st_vfd <= S_LOAD;
		endcase
	end
end

reg [31:0] half_period;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		half_period <= 32'd20_000_00;		//20ms --- 50Hz
	else if(st_vfd == S_LOAD)
		half_period <= quto;
	else ;
end

reg [31:0] cnt_down;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_down <= 32'h0;
	else if(st_vfd == S_DOWN)
		cnt_down <= cnt_down + 32'h1;
	else 
		cnt_down <= 32'h0;
end
assign done_down = (cnt_down == half_period) ? 1'b1 : 1'b0;

reg [31:0] cnt_up;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_up <= 32'h0;
	else if(st_vfd == S_UP)
		cnt_up <= cnt_up + 32'h1;
	else 
		cnt_up <= 32'h0;
end
assign done_up = (cnt_up == half_period) ? 1'b1 : 1'b0;


//-------- output --------
reg pwm;
always @ (posedge clk_sys or negedge rst_n)	begin	
	if(~rst_n)
		pwm <= 1'b0;
	else if(st_vfd == S_UP)
		pwm <= 1'b1;
	else 
		pwm <= 1'b0;
end

endmodule
