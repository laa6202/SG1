//fx_master.v

module fx_master(
//phy data
rx_data,
rx_vld,
tx_data,
tx_vld,
//fx bus
fx_waddr,
fx_wr,
fx_data,
fx_rd,
fx_raddr,
fx_q,
//clk rst
clk_sys,
rst_n
);
//phy data
input [7:0]	rx_data;
input				rx_vld;
output [7:0]	tx_data;
output 				tx_vld;
//fx_bus
output 				fx_wr;
output [7:0]	fx_data;
output [21:0]	fx_waddr;
output [21:0]	fx_raddr;
output 				fx_rd;
input  [7:0]	fx_q;
//clk rst
input clk_sys;
input rst_n;
//--------------------------------------
//--------------------------------------


//--------- master FSM --------
parameter S_IDLE = 4'h0;
parameter S_ADD1 = 4'h1;
parameter S_ADD2 = 4'h2;
parameter S_DATA = 4'h3;
parameter S_GCMD = 4'h4;
parameter S_FCMD = 4'h5;
parameter S_FDAT = 4'h6;
parameter S_RESP = 4'h7;
parameter S_WAIT = 4'h8;
parameter S_DONE = 4'hf;
reg [3:0] st_fx;
wire done_wait;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_fx <= S_IDLE;
	else begin
		case(st_fx)
			S_IDLE : st_fx <= rx_vld ? S_ADD1 : S_IDLE;
			S_ADD1 : st_fx <= rx_vld ? S_ADD2 : S_ADD1;
			S_ADD2 : st_fx <= rx_vld ? S_DATA : S_ADD2;
			S_DATA : st_fx <= rx_vld ? S_GCMD : S_DATA;
			S_GCMD : st_fx <= S_FCMD;
			S_FCMD : st_fx <= S_FDAT;
			S_FDAT : st_fx <= S_RESP;
			S_RESP : st_fx <= S_WAIT;
			S_WAIT : st_fx <= done_wait ? S_DONE : S_WAIT;
			S_DONE : st_fx <= S_IDLE;
			default : st_fx <= S_IDLE;
		endcase
	end
end

reg [7:0] cnt_wait;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_wait <= 8'h0;
	else if(st_fx == S_WAIT)
		cnt_wait <= cnt_wait + 8'h1;
	else 
		cnt_wait <= 8'h0;
end
assign done_wait = (cnt_wait == 8'd99) ? 1'b1 : 1'b0;


//------------ gen fx command ---------
reg [1:0] 	op_act;
reg [5:0] 	op_dev;
reg [15:0] 	op_addr;
reg [7:0] 	op_data;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)	begin
		op_act <= 2'b0;
		op_dev <= 6'h0;
		op_addr <= 16'h0;
		op_data <= 8'h0;
	end
	else if(rx_vld) begin
		if(st_fx == S_IDLE)	begin
			op_act <= rx_data[7:6];
			op_dev <= rx_data[5:0];
		end
		else if(st_fx == S_ADD1)
			op_addr[15:8] <= rx_data;
		else if(st_fx == S_ADD2)
			op_addr[7:0] <= rx_data;
		else if(st_fx == S_DATA)
			op_data <= rx_data;
		else ;
	end
	else ;
end

reg 				fx_wr;
reg [7:0]		fx_data;
reg [21:0]	fx_waddr;
reg [21:0]	fx_raddr;
reg 				fx_rd;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n) begin
		fx_wr <= 1'b0;
		fx_data <= 8'h0;
		fx_waddr <= 22'h0;
		fx_raddr <= 22'h0;
		fx_rd <= 1'b0;
	end
	else if(st_fx == S_GCMD)	begin
		fx_wr <= (op_act == 2'b10) ? 1'b1 : 1'b0;
		fx_data <= (op_act == 2'b10) ? op_data : 8'h0;
		fx_waddr <= (op_act == 2'b10) ? {op_dev, op_addr} : 22'h0;
		fx_raddr <= (op_act == 2'b00) ? {op_dev, op_addr} : 22'h0;
		fx_rd <= (op_act == 2'b00) ? 1'b1 : 1'b0;
	end
	else begin
		fx_wr <= 1'b0;
		fx_data <= 8'h0;
		fx_waddr <= 22'h0;
		fx_raddr <= 22'h0;
		fx_rd <= 1'b0;
	end
end


//---------- gen tx_data and tx_vld -----------
reg [7:0]	tx_data;
reg 			tx_vld;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)	begin
		tx_data <= 8'h0;
		tx_vld <= 1'b0;
	end
	else if(st_fx == S_FDAT)	begin
		tx_data <= fx_q;
		tx_vld <= 1'b1;
	end
	else begin
		tx_data <= 8'h0;
		tx_vld <= 1'b0;
	end
end

		

endmodule
