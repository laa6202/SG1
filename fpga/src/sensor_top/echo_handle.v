//echo_handle.v

module echo_handle(
echo_p0,
echo_p1,
clk_sys,
rst_n
);
input		echo_p0;
output	echo_p1;
input		clk_sys;
input		rst_n;
//-----------------------------------
//-----------------------------------

reg [15:0] echo_reg;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		echo_reg <= 16'h0;
	else 
		echo_reg <= {echo_reg[14:0],echo_p0};
end

reg echo_p1;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		echo_p1 <= 1'b0;
	else 
		echo_p1 <= 	(echo_reg == 16'hffff) ? 1'b1 :
								(echo_reg == 16'h0) ? 1'b0 : echo_p1;
end


endmodule
