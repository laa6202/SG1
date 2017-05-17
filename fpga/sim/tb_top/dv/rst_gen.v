module rst_gen(
rst_n
);
output rst_n;
//--------------------------
reg rst_n;

initial begin
				rst_n <= 1'b1;
	#200	rst_n <= 1'b0;
	#300	rst_n <= 1'b1;
end

task do_reset;
begin
		rst_n <= 1'b0;
	#300 rst_n <= 1'b1;
end
endtask

endmodule
