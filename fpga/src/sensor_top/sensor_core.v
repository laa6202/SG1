//sensor.v

module sensor_core(
trig,
echo,
fire_measure,
done_measure,
data_measure,
clk_sys,
clk_slow,
rst_n
);

output trig;
input echo;
input fire_measure;
output done_measure;
output [31:0] data_measure;
input clk_sys;
input clk_slow;
input rst_n;

//----------------------------------
//----------------------------------


reg [15:0] cnt_trig;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_trig <= 16'h0;
`ifdef SIM
	else if(cnt_trig == 16'd200)
`else
	else if(cnt_trig == 16'd1500)
`endif
		cnt_trig <= 16'h0;
	else if(fire_measure)
		cnt_trig <= 16'h1;
	else if(cnt_trig != 16'h0)
		cnt_trig <= cnt_trig + 16'h1;
	else ;
end

wire trig = (cnt_trig != 16'h0) ? 1'b1 : 1'b0;


//--------- get echo ---------
reg echo_d0;
reg echo_d1;
always @ (posedge clk_sys) begin
	echo_d0 <= echo;
	echo_d1 <= echo_d0;
end

reg [31:0] cnt_echo;
always @ (posedge clk_sys or negedge rst_n) begin
	if(~rst_n)
		cnt_echo <= 32'h0;
	else if(fire_measure)
		cnt_echo <= 32'h0;
	else if(echo_d0)
		cnt_echo <= cnt_echo + 32'h1;
	else ;
end

wire [31:0] data_measure;
assign data_measure = cnt_echo;

//--------- get echo done flag --------
wire echo_falling =  echo_d1 & (~echo_d0);
wire done_measure = echo_falling;


endmodule


