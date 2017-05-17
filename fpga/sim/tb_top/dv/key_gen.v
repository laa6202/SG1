//key_gen.v

module key_gen(
key_n
);
output	key_n;

//---------------------------------
reg key_n;

initial begin
				key_n <= 1'b1;
	#1000	key_n <= 1'b0;
	#300	key_n <= 1'b1;
end

task do_key;
begin
		key_n <= 1'b0;
	#300 key_n <= 1'b1;
end
endtask

endmodule
