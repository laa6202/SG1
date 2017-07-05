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
parameter S_IDLE = 5'h0;
parameter S_WSTART = 5'h1;
parameter S_WDAT1 = 5'h2;
parameter S_WACK1 = 5'h3;
parameter S_WDAT2 = 5'h4;
parameter S_WACK2 = 5'h5;
parameter S_WDAT3 = 5'h6;
parameter S_WACK3 = 5'h7;
parameter S_STOP = 5'he;
parameter S_DONE = 5'hf;
parameter S_RSTART1 = 5'h11;
parameter S_RDAT1 = 5'h12;
parameter S_RACK1 = 5'h13;
parameter S_RDAT2 = 5'h14;
parameter S_RACK2 = 5'h15;
parameter S_RSTART2 = 5'h10;
parameter S_RDAT3 = 5'h16;
parameter S_RACK3 = 5'h17;
parameter S_RDAT4 = 5'h18;
parameter S_RACK4 = 5'h1a;

reg [4:0] st_iic;
wire act_write;
wire act_read;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_iic <= S_IDLE;
	else begin
		case(st_iic)
			S_IDLE : st_iic <=	act_write ? S_WSTART :
													act_read ? S_RSTART1 : S_IDLE;
			default :  st_iic <= S_IDLE;
		endcase
	end
end


//--------- FSM switch condition -------
assign act_write = act_iic_write[1] & act_iic_write[0];
assign act_read  = act_iic_read[1]  & act_iic_read[0];



wire scl = 1'bz;//scl_nostop;
wire sda = 1'bz;

endmodule

