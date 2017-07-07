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

wire scl_up = (cnt_us == 4'h2) & pluse_us;
wire scl_down = (cnt_us == 4'h7) & pluse_us;


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
parameter S_WSTART1 = 5'h1;
parameter S_WSTART2 = 5'h2;
parameter S_WDAT1 = 5'h3;
parameter S_WACK1 = 5'h4;
parameter S_WDAT2 = 5'h5;
parameter S_WACK2 = 5'h6;
parameter S_WDAT3 = 5'h7;
parameter S_WACK3 = 5'h8;
parameter S_STOP = 5'he;
parameter S_DONE = 5'hf;
parameter S_RSTART11 = 5'h11;
parameter S_RSTART12 = 5'h12;
parameter S_RDAT1 = 5'h13;
parameter S_RACK1 = 5'h14;
parameter S_RDAT2 = 5'h15;
parameter S_RACK2 = 5'h16;
parameter S_RSTART21 = 5'ha;
parameter S_RSTART22 = 5'hb;
parameter S_RDAT3 = 5'h17;
parameter S_RACK3 = 5'h18;
parameter S_RDAT4 = 5'h19;
parameter S_RACK4 = 5'h1a;

reg [4:0] st_iic;
wire act_write;
wire act_read;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)
		st_iic <= S_IDLE;
	else begin
		case(st_iic)
			S_IDLE : st_iic <=	act_write ? S_WSTART1 :
													act_read ? S_RSTART11 : S_IDLE;
			S_WSTART1 : st_iic <= scl_up ? S_WSTART2 :  S_WSTART1;
			S_WSTART2 : st_iic <= scl_down ? S_WDAT1 : S_WSTART2;
			default :  st_iic <= S_IDLE;
		endcase
	end
end


//--------- FSM switch condition -------
assign act_write = act_iic_write[1] & act_iic_write[0];
assign act_read  = act_iic_read[1]  & act_iic_read[0];




//----------- data output -------------
reg [7:0] tmp_devid;
reg [7:0] tmp_addr;
reg [7:0] tmp_data;
always @ (posedge clk_sys or negedge rst_n)	begin
	if(~rst_n)	begin
		tmp_devid <= 8'h0;
		tmp_addr <= 8'h0;
		tmp_data <= 8'h0;
	end
	else if((st_iic == S_WSTART1)||(st_iic == S_RSTART11))	begin
		tmp_devid <= cfg_iic_devid;
		tmp_addr <= cfg_iic_addr;
		tmp_data <= cfg_iic_wdata;
	end
	else if((st_iic == S_WDAT1)||(st_iic == S_RDAT1)||(st_iic == S_RDAT3))
		tmp_devid <= scl_down ? {tmp_devid[6:0],1'b0} : tmp_devid;
	else if((st_iic == S_WDAT2)||(st_iic == S_RDAT2))
		tmp_addr <= scl_down ? {tmp_addr[6:0],1'b0} : tmp_addr;
	else if(st_iic == S_WDAT3)
		tmp_data <= scl_down ? {tmp_data[6:0],1'b0} : tmp_data;
end


		
wire scl = 1'bz;//scl_nostop;
wire sda_org;
assign sda_org = 	(st_iic == S_WSTART1) ? 1'b1 :
									(st_iic == S_WSTART2) ? 1'b0 :	
									(st_iic == S_WDAT1)|(st_iic == S_RDAT1) ? tmp_devid[7] :
									(st_iic == S_WDAT2)|(st_iic == S_RDAT2) ? tmp_devid[7] :1'bz;

endmodule

