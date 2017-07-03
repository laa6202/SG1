//iic_reg.v

module iic_reg(
//fx bus
fx_waddr,
fx_wr,
fx_data,
fx_rd,
fx_raddr,
fx_q,
// registers 
stu_iic_status,	
cfg_iic_devid,	
cfg_iic_addr,	
cfg_iic_wdata,	
stu_iic_rdata,	
act_iic_write,
act_iic_read,
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
// registers 
input  [7:0] stu_iic_status;	
output [7:0] cfg_iic_devid;	
output [7:0] cfg_iic_addr;		
output [7:0] cfg_iic_wdata;	
input  [7:0] stu_iic_rdata;	
output [7:0] act_iic_write;
output [7:0] act_iic_read;	
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
wire[7:0] stu_iic_status;	//0x1
reg [7:0] cfg_iic_devid;	//0x2
reg [7:0] cfg_iic_addr;		//0x3
reg [7:0] cfg_iic_wdata;	//0x4
wire[7:0] stu_iic_rdata;	//0x5
wire[7:0] act_iic_write;	//0x6
wire[7:0]	act_iic_read;		//0x7
reg [7:0] cfg_dbg0;
reg [7:0] cfg_dbg1;
reg [7:0] cfg_dbg2;
reg [7:0] cfg_dbg3;
reg [7:0] cfg_dbg4;
reg [7:0] cfg_dbg5;
reg [7:0] cfg_dbg6;
reg [7:0] cfg_dbg7;



//--------- write configuration ----------
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)	begin
		cfg_iic_devid <= 8'h42;
		cfg_iic_addr <= 8'h0;
		cfg_iic_wdata <= 8'h0;
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
			16'h2  : cfg_iic_devid <= fx_data;
			16'h3  : cfg_iic_addr  <= fx_data;
			16'h4  : cfg_iic_wdata <= fx_data;
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
			
			
//--------- action write --------			
assign act_iic_write =  (now_wr & (fx_waddr[15:0] == 16'h6)) ? fx_data : 8'h0;
assign act_iic_read  =  (now_wr & (fx_waddr[15:0] == 16'h7)) ? fx_data : 8'h0;
		

		
//---------- read cfg and status ---------
reg [7:0] q0;
always @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n) begin
		q0 <= 8'h0;
	end
	else if(now_rd) begin
		case(fx_raddr[15:0])
			16'h0  : q0 <= dev_id;
			16'h1  : q0 <= stu_iic_status;
			16'h2  : q0 <= cfg_iic_devid;
			16'h3  : q0 <= cfg_iic_addr;
			16'h4  : q0 <= cfg_iic_wdata;
			16'h5  : q0 <= stu_iic_rdata;
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
