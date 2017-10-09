module clk_gen(
clk_50m,
clk_100m,
clk_1m
);
output clk_50m;
output clk_100m;
output clk_1m;
//------------------------------------
reg clk_50m;
reg clk_100m;
reg clk_1m;
initial clk_50m <= 1'b1;
initial clk_100m <= 1'b1;
initial clk_1m <= 1'b1;

always #10 clk_50m <= ~clk_50m;
always #5 clk_100m <= ~clk_100m;
always #500 clk_1m <= ~clk_1m;

endmodule



