//urx_filter.v

module urx_filter(
urx_p0,
urx_p1,
//clk rst
clk_sys,
rst_n
);
input		urx_p0;
output	urx_p1;
//clk rst
input	clk_sys;
input rst_n;
//--------------------------------------


reg [15:0] urx_reg;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		urx_reg <= 16'h0;
	else 
		urx_reg <= {urx_reg[14:0],urx_p0};
end

reg urx_keep;
`ifdef SIM
always @(posedge clk_sys) begin
	urx_keep <= urx_p0;
end
`else
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		urx_keep <= 1'b1;
	else 
		urx_keep <= (urx_reg == 16'hffff) ? 1'b1 :
								(urx_reg == 16'h0000) ? 1'b0 : urx_keep;
end
`endif

wire urx_p1;
assign urx_p1 = urx_keep;



endmodule

