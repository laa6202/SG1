//iic_inf.v

module iic_inf(
scl,		//100K
sda,
// registers 
stu_iic_status,	
cfg_iic_devid,	
cfg_iic_addr,	
cfg_iic_wdata,	
stu_iic_rdata,	
act_iic_write,
act_iic_read,
//clk rst
clk_sys,
pluse_us,
rst_n
);

output scl;
inout	 sda;
// registers 
output  [7:0] stu_iic_status;	
input 	[7:0] cfg_iic_devid;	
input 	[7:0] cfg_iic_addr;		
input 	[7:0] cfg_iic_wdata;	
output  [7:0] stu_iic_rdata;	
input 	[7:0] act_iic_write;
input 	[7:0] act_iic_read;	
//clk rst
input clk_sys;
input pluse_us;
input rst_n;
//-----------------------------------------
//-----------------------------------------


// if SIM 1us = 1cycle
reg [3:0] cnt_us;
always  @(posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		cnt_us <= 4'h0;
	else if(pluse_us)	begin
		if(cnt_us == 4'd9)
			cnt_us <= 4'h0;
		else 
			cnt_us <= cnt_us + 4'h1;
	end
	else ;
end

wire scl_up = (cnt_us == 4'h3) & pluse_us;
wire scl_donw = (cnt_us == 4'h8) & pluse_us;


reg scl_nostop;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		scl_nostop <= 1'b1;
	else if(cnt_us <= 4'h4)
		scl_nostop <= 1'b1;
	else 
		scl_nostop <= 1'b0;
end


//--------- main FSM ------------
parameter S_IDLE = 4'h0;
parameter S_START = 4'h1;
parameter S_WDAT1 = 4'h2;
parameter S_WACK1 = 4'h3;
parameter S_WDAT2 = 4'h4;
parameter S_WACK2 = 4'h5;
parameter S_RDAT1 = 4'h6;
parameter S_RACK1 = 4'h7;
parameter S_RDAT2 = 4'h8;
parameter S_RACK2 = 4'h9;
parameter S_RDAT3 = 4'ha;
parameter S_RACK3 = 4'hb;
parameter S_DONE = 4'hf;
reg [3:0] st_iic;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_iic <= S_IDLE;
	else begin
		case(st_iic)
			S_IDLE : ;
			default : st_iic <= S_IDLE; 
		endcase
	end
end


wire scl = 1'bz;//scl_nostop;
wire sda = 1'bz;

endmodule

