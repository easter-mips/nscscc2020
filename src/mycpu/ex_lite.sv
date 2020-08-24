`include "cpu_instr_define.svh"
module ex_lite (
	input aresetn,
	input clk,
	input stallid_ex,
	input [31:0] lite_pc,
	input [7:0] lite_opcode,
	input [31:0] lite_op3,
		input [3:0] lite_rs_mux,
	input [3:0] lite_rt_mux,
	//in reg
	input [31:0] regrs,
	input [31:0] regrt,
	//in wb
	input [31:0] wb_pro_wRegData,
	input [31:0] wb_lite_wRegData,
	//in mem
	input [31:0] mem_pro_wRegData,
	input [31:0] mem_lite_wRegData,	
	output logic [31:0] aluAns,
	output logic wRegEn,
	output logic [31:0] branchPC,
	output logic gotoBranch,
	output logic [6:0] excep,
	output logic instAddrErr
);

logic [31:0] lite_regrs;
logic [31:0] lite_regrt;
logic [31:0] new_rs;
logic [31:0] new_rt;
logic stall_count;
always_comb begin
	if(stall_count) lite_regrs=new_rs;
	else begin
		case(lite_rs_mux)
			4'b1000:lite_regrs=mem_pro_wRegData;
			4'b0100:lite_regrs=mem_lite_wRegData;
			4'b0010:lite_regrs=wb_pro_wRegData;
			4'b0001:lite_regrs=wb_lite_wRegData;
			default:lite_regrs=regrs;
		endcase
	end
end

always_comb begin
	if(stall_count) lite_regrt=new_rt;
	else begin
		case(lite_rt_mux)
			4'b1000:lite_regrt=mem_pro_wRegData;
			4'b0100:lite_regrt=mem_lite_wRegData;
			4'b0010:lite_regrt=wb_pro_wRegData;
			4'b0001:lite_regrt=wb_lite_wRegData;
			default:lite_regrt=regrt;
		endcase
	end
end

always_ff @(posedge clk) begin : proc_new_mux
	if(~aresetn|~stallid_ex) begin
		new_rs<= 0;
		new_rt<=0;
		stall_count<=0;
	end else if(stallid_ex) begin
		stall_count<=1;
		new_rt<=lite_regrt;
		new_rs<=lite_regrs;
	end
end

logic [31:0] resvPC;
assign resvPC=lite_pc+8;

logic [31:0] regtmp;
assign regtmp=~lite_regrt+1;
logic [31:0] immtmp;
assign immtmp=~lite_op3+1;
//add,addu
logic [31:0] addregs;
logic addregsOvfl;
assign addregs=lite_regrt+lite_regrs;
assign addregsOvfl=((~(lite_regrs[31]^lite_regrt[31]))&(addregs[31]^lite_regrs[31]))?1'b1:1'b0;
//addi,addiu
logic [31:0] addregimm;
logic addregimmOvfl;
assign addregimm=lite_regrs+lite_op3;
assign addregimmOvfl=((~(lite_regrs[31]^lite_op3[31]))&(addregimm[31]^lite_regrs[31]))?1'b1:1'b0;
//sub,subu
logic [31:0] subregs;
logic subregsOvfl;
assign subregs=lite_regrs+regtmp;
assign subregsOvfl=((~(lite_regrs[31]^regtmp[31]))&(subregs[31]^lite_regrs[31]))?1'b1:1'b0;
//sub,subu
logic [31:0] subregimm;
logic subregimmOvfl;
assign subregimm=lite_regrs+immtmp;
assign subregimmOvfl=((~(lite_regrs[31]^immtmp[31]))&(subregimm[31]^lite_regrs[31]))?1'b1:1'b0;

always_comb begin
	if(~aresetn) begin 
		wRegEn=1'b0;aluAns=32'b0;branchPC=32'b0;gotoBranch=0;
	end else begin 
		wRegEn=1'b1;aluAns=32'b0;branchPC=32'b0;gotoBranch=0;
		case (lite_opcode)
			`OPC_ADD:begin 
				if(addregsOvfl) wRegEn=0;
				aluAns=addregs;
			end
			`OPC_ADDI:begin 
				if (addregimmOvfl) wRegEn=0;
				aluAns=addregimm;
			end
			`OPC_ADDIU:aluAns=addregimm;
			`OPC_ADDU:aluAns=addregs;
			`OPC_SUB:begin 
				if(subregsOvfl) wRegEn=0;
				aluAns=subregs;
			end
			`OPC_SUBU:aluAns=subregs;
			`OPC_SLT: 
				if ((subregs[31]&(~subregsOvfl))|((~subregs[31])&subregsOvfl))
					aluAns = 32'b1;else aluAns=32'b0;
			`OPC_SLTI:
				if ((subregimm[31]&(~subregimmOvfl))|((~subregimm[31])&subregimmOvfl))
					aluAns = 32'b1;else aluAns=32'b0;
			`OPC_SLTU:aluAns = (lite_regrs<lite_regrt)?32'b1:32'b0;
			`OPC_SLTIU:aluAns = (lite_regrs<lite_op3)?32'b1:32'b0;
			`OPC_AND:aluAns = lite_regrs&lite_regrt;
			`OPC_ANDI:aluAns=lite_regrs&lite_op3;
			`OPC_LUI:aluAns=lite_op3;
			`OPC_NOR:aluAns=~(lite_regrs|lite_regrt);
			`OPC_OR:aluAns=lite_regrs|lite_regrt;
			`OPC_ORI:aluAns=lite_regrs|lite_op3;
			`OPC_XOR:aluAns=lite_regrs^lite_regrt;
			`OPC_XORI:aluAns=lite_regrs^lite_op3;
			`OPC_SLLV:aluAns=lite_regrt<<lite_regrs[4:0];
			`OPC_SLL:aluAns=lite_regrt<<lite_op3[4:0];
			`OPC_SRLV:aluAns=lite_regrt>>lite_regrs[4:0];
			`OPC_SRL:aluAns=lite_regrt>>lite_op3[4:0];
			`OPC_SRAV:aluAns=({32{lite_regrt[31]}}<<(6'd32-{1'b0,lite_regrs[4:0]}))|lite_regrt>>lite_regrs[4:0];
			`OPC_SRA:aluAns=({32{lite_regrt[31]}}<<(6'd32-{1'b0,lite_op3[4:0]}))|lite_regrt>>lite_op3[4:0];
			`OPC_JALR:begin 
				branchPC=lite_regrs;aluAns=resvPC;gotoBranch=1;
			end
			`OPC_JR:begin 
				gotoBranch=1;branchPC=lite_regrs;wRegEn=0;
			end
			`OPC_JAL:begin 
				branchPC=lite_op3;aluAns=resvPC;gotoBranch=1;
			end
			`OPC_J:begin 
				branchPC=lite_op3;gotoBranch=1;wRegEn=0;
			end
			`OPC_BLTZAL:begin 
				aluAns=resvPC;branchPC=lite_op3;
				if(lite_regrs[31]==1'b1) gotoBranch=1;else gotoBranch=0;
			end
			`OPC_BGEZAL:begin 
				aluAns=resvPC;branchPC=lite_op3;
				if(lite_regrs[31]==1'b0) gotoBranch=1; else gotoBranch=0;	
			end
			`OPC_BLTZ:begin 
				branchPC=lite_op3;wRegEn=0;
				if(lite_regrs[31]==1'b1) gotoBranch=1;else gotoBranch=0;		
			end		
			`OPC_BGEZ:begin 
				branchPC=lite_op3;wRegEn=0;
				if(lite_regrs[31]==1'b0) gotoBranch=1;else gotoBranch=0;	
			end	
			`OPC_BLEZ:begin 
				branchPC=lite_op3;wRegEn=0;
				if((lite_regrs[31]==1'b1)||(|lite_regrs==1'b0)) gotoBranch=1;else gotoBranch=0;	
			end
			`OPC_BGTZ:begin 
				branchPC=lite_op3;wRegEn=0;
				if((lite_regrs[31]==1'b0)&&(|lite_regrs!=1'b0)) gotoBranch=1;else gotoBranch=0;	
			end	
			`OPC_BNE:begin 
				branchPC=lite_op3;wRegEn=0;
				if(lite_regrs!=lite_regrt) gotoBranch=1;else gotoBranch=0;			
			end	
			`OPC_BEQ:begin 
				branchPC=lite_op3;wRegEn=0;
				if(lite_regrs==lite_regrt) gotoBranch=1;else gotoBranch=0;	
			end		
			`OPC_CLO:
			aluAns=(lite_regrs[31]==0)?32'd0:
				(lite_regrs[30]==0)?32'd1:
				(lite_regrs[29]==0)?32'd2:
				(lite_regrs[28]==0)?32'd3:
				(lite_regrs[27]==0)?32'd4:
				(lite_regrs[26]==0)?32'd5:
				(lite_regrs[25]==0)?32'd6:
				(lite_regrs[24]==0)?32'd7:
				(lite_regrs[23]==0)?32'd8:
				(lite_regrs[22]==0)?32'd9:
				(lite_regrs[21]==0)?32'd10:
				(lite_regrs[20]==0)?32'd11:
				(lite_regrs[19]==0)?32'd12:
				(lite_regrs[18]==0)?32'd13:
				(lite_regrs[17]==0)?32'd14:
				(lite_regrs[16]==0)?32'd15:
				(lite_regrs[15]==0)?32'd16:
				(lite_regrs[14]==0)?32'd17:
				(lite_regrs[13]==0)?32'd18:
				(lite_regrs[12]==0)?32'd19:
				(lite_regrs[11]==0)?32'd20:
				(lite_regrs[10]==0)?32'd21:
				(lite_regrs[9]==0)?32'd22:
				(lite_regrs[8]==0)?32'd23:
				(lite_regrs[7]==0)?32'd24:
				(lite_regrs[6]==0)?32'd25:
				(lite_regrs[5]==0)?32'd26:
				(lite_regrs[4]==0)?32'd27:
				(lite_regrs[3]==0)?32'd28:
				(lite_regrs[2]==0)?32'd29:
				(lite_regrs[1]==0)?32'd30:	
				(lite_regrs[0]==0)?32'd31:32'd32;
			`OPC_CLZ:	
			aluAns=(lite_regrs[31]==1)?32'd0:
				(lite_regrs[30]==1)?32'd1:
				(lite_regrs[29]==1)?32'd2:
				(lite_regrs[28]==1)?32'd3:
				(lite_regrs[27]==1)?32'd4:
				(lite_regrs[26]==1)?32'd5:
				(lite_regrs[25]==1)?32'd6:
				(lite_regrs[24]==1)?32'd7:
				(lite_regrs[23]==1)?32'd8:
				(lite_regrs[22]==1)?32'd9:
				(lite_regrs[21]==1)?32'd10:
				(lite_regrs[20]==1)?32'd11:
				(lite_regrs[19]==1)?32'd12:
				(lite_regrs[18]==1)?32'd13:
				(lite_regrs[17]==1)?32'd14:
				(lite_regrs[16]==1)?32'd15:
				(lite_regrs[15]==1)?32'd16:
				(lite_regrs[14]==1)?32'd17:
				(lite_regrs[13]==1)?32'd18:
				(lite_regrs[12]==1)?32'd19:
				(lite_regrs[11]==1)?32'd20:
				(lite_regrs[10]==1)?32'd21:
				(lite_regrs[9]==1)?32'd22:
				(lite_regrs[8]==1)?32'd23:
				(lite_regrs[7]==1)?32'd24:
				(lite_regrs[6]==1)?32'd25:
				(lite_regrs[5]==1)?32'd26:
				(lite_regrs[4]==1)?32'd27:
				(lite_regrs[3]==1)?32'd28:
				(lite_regrs[2]==1)?32'd29:
				(lite_regrs[1]==1)?32'd30:	
				(lite_regrs[0]==1)?32'd31:32'd32;	
			`OPC_MOVN:begin
				aluAns=lite_regrs;
				if((|lite_regrt)!=0) wRegEn=1;else wRegEn=0;
			end
			`OPC_MOVZ:begin
				aluAns=lite_regrs;
				if((|lite_regrt)==0) wRegEn=1;else wRegEn=0;
			end	
			`OPC_RESV:begin
				aluAns=32'b0;
				wRegEn=0;
			end
		endcase
	end
end

assign instAddrErr=(lite_pc[1:0]==2'd0)?1'd0:1'd1;

always_comb begin : exception
	if (~aresetn) begin
		excep = 7'b0;
	end else begin
		excep[6]=0;
		if (instAddrErr) excep[5]=1'b1; else excep[5]=1'b0;
		if(lite_opcode==`OPC_RESV) excep[4]=1'b1;else excep[4]=1'b0;
		if(((lite_opcode==`OPC_ADD)&addregsOvfl)|((lite_opcode==`OPC_ADDI)&addregimmOvfl)|((lite_opcode==`OPC_SUB)&subregsOvfl)) excep[3]=1'b1;else excep[3]=1'b0;
		excep[2]=0;excep[1]=0;excep[0]=1'b0;
	end
end

endmodule