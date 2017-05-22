//cfg_reg.v

module cfg_reg(
//fx bus
fx_waddr,
fx_wr,
fx_data,
fx_rd,
fx_raddr,
fx_q,
//clk rst
dev_id,
clk_sys,
rst_n

);

//fx_bus
input 				fx_wr;
input [7:0]		fx_data;
input [21:0]	fx_waddr;
input [21:0]	fx_raddr;
input 				fx_rd;
output  [7:0]	fx_q;
//clk rst
input [5:0] dev_id;
input clk_sys;
input rst_n;

//-----------------------------------------
//-----------------------------------------

wire dev_wsel = (fx_waddr[21:16]== dev_id) ? 1'b1 :1'b0;
wire dev_rsel = (fx_raddr[21:16]== dev_id) ? 1'b1 :1'b0;

wire now_wr = fx_wr & dev_wsel;
wire now_rd = fx_rd & dev_rsel;


//--------- register --------
reg [7:0] cfg_dbg0;
reg [7:0] cfg_dbg1;
reg [7:0] cfg_dbg2;
reg [7:0] cfg_dbg3;
reg [7:0] cfg_dbg4;
reg [7:0] cfg_dbg5;
reg [7:0] cfg_dbg6;
reg [7:0] cfg_dbg7;



//--------- write register ----------
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)	begin
		cfg_dbg0 <= 8'h80;
		cfg_dbg1 <= 8'h81;
		cfg_dbg2 <= 8'h82;
		cfg_dbg3 <= 8'h83;
		cfg_dbg4 <= 8'h84;
		cfg_dbg5 <= 8'h85;
		cfg_dbg6 <= 8'h86;
		cfg_dbg7 <= 8'h87;
	end
	else if(now_wr) begin
		case(fx_waddr[15:0])
			16'h80 : cfg_dbg0 <= fx_data;
			16'h81 : cfg_dbg1 <= fx_data;
			16'h82 : cfg_dbg2 <= fx_data;
			16'h83 : cfg_dbg3 <= fx_data;
			16'h84 : cfg_dbg4 <= fx_data;
			16'h85 : cfg_dbg5 <= fx_data;
			16'h86 : cfg_dbg6 <= fx_data;
			16'h87 : cfg_dbg7 <= fx_data;
			default : ;
		endcase
	end
	else ;
end
			

//---------- read register ---------
reg [7:0] q0;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n) begin
		q0 <= 8'h0;
	end
	else if(now_rd) begin
		case(fx_raddr[15:0])
			16'h0  : q0 <= dev_id;
			16'h80 : q0 <= cfg_dbg0;
			16'h81 : q0 <= cfg_dbg1;
			16'h82 : q0 <= cfg_dbg2;
			16'h83 : q0 <= cfg_dbg3;
			16'h84 : q0 <= cfg_dbg4;
			16'h85 : q0 <= cfg_dbg5;
			16'h86 : q0 <= cfg_dbg6;
			16'h87 : q0 <= cfg_dbg7;
			
			default : q0 <= 8'h0;
		endcase
	end
	else 
		q0 <= 8'h0;
end

wire [7:0] fx_q;
assign fx_q = q0;
	
	
endmodule
