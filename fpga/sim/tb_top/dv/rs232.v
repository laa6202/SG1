//rs232.v

module rs232(
uart_tx,
uart_rx
);
output uart_tx;
input  uart_rx;
//------------------------------------

reg tx;
initial begin
#0			tx <= 1'b1;				
#1000
#86.8		tx <= 1'b1;		//idle
#86.8		tx <= 1'b0;		//start
#86.8		tx <= 1'b1;		//bit7
#86.8		tx <= 1'b0;		//bit6
#86.8		tx <= 1'b1;		//bit5
#86.8		tx <= 1'b0;		//bit4
#86.8		tx <= 1'b1;		//bit3
#86.8		tx <= 1'b0;		//bit2
#86.8		tx <= 1'b1;		//bit1
#86.8		tx <= 1'b0;		//bit0
#86.8		tx <= 1'b0;		//bit xor
#86.8		tx <= 1'b1;		//stop
#86.8		tx <= 1'b1;		//idle
end


wire uart_tx = tx;

endmodule
