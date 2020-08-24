`include "cpu_instr_define.svh"
`include "define.svh"
module ex_pro (
	input aresetn,
	input clk,
	input [31:0] pro_pc,
	input [7:0] pro_opcode,
	input [31:0] pro_op3,
	input [3:0] pro_rs_mux,
	input [3:0] pro_rt_mux,
	//in reg
	input [31:0] regrs,
	input [31:0] regrt,
	//in wb
	input [31:0] wb_pro_wRegData,
	input [31:0] wb_lite_wRegData,
	//in mem
	input [31:0] mem_pro_wRegData,
	input [31:0] mem_lite_wRegData,
	input [31:0] HiData,
	input [31:0] LoData,
	input [31:0] rCP0Data,
	input stallid_ex,
	output logic ex_pro_valid,
	output logic [31:0] aluAns,
	output logic wRegEn,
	output logic [6:0] excep,
	output logic instAddrErr,
	output logic [31:0] wHiData,
	output logic [31:0] wLoData,
	output logic wHiEn,
	output logic wLoEn,
	output logic [31:0] wCP0Data,
	output logic wCP0En,
	output logic [31:0] wdata,
	output logic [31:0] addr_v,
	output logic [3:0] wstrb,
	output logic [ 2:0]wsize,	
	output logic memEn,
	output logic rwmem,
	output logic [ 2:0]rsize,	
	 output logic signExt,
	// output logic [31:0] branchPC,
	// output logic gotoBranch,
	output logic multDivStall,
	//output logic [4:0]cacheInst,
	output logic [3:0] tlb,
	output logic [1:0] left_right,
	output logic [31:0] pro_rtReg,
	output logic copU
	);
logic [31:0] pro_regrt;
assign pro_rtReg=pro_regrt;
logic [31:0] pro_regrs;

logic [31:0] new_rs;
logic [31:0] new_rt;
logic stall_count;
always_comb begin
	if(stall_count) pro_regrs=new_rs;
	else begin
		case(pro_rs_mux)
			4'b1000:pro_regrs=mem_pro_wRegData;
			4'b0100:pro_regrs=mem_lite_wRegData;
			4'b0010:pro_regrs=wb_pro_wRegData;
			4'b0001:pro_regrs=wb_lite_wRegData;
			default:pro_regrs=regrs;
		endcase
	end
end

always_comb begin
	if(stall_count) pro_regrt=new_rt;
	else begin
		case(pro_rt_mux)
			4'b1000:pro_regrt=mem_pro_wRegData;
			4'b0100:pro_regrt=mem_lite_wRegData;
			4'b0010:pro_regrt=wb_pro_wRegData;
			4'b0001:pro_regrt=wb_lite_wRegData;
			default:pro_regrt=regrt;
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
		new_rt<=pro_regrt;
		new_rs<=pro_regrs;
	end
end

assign ex_pro_valid=~(pro_opcode[7:4]==3'b0111);


logic tlbwi;
logic tlbr;
logic tlbp;
logic tlbwr;
assign tlb={tlbwr,tlbwi,tlbr,tlbp};

/***********
cacheInst
4:Icache=0;Dcache=1;
3:Index=1;Hit=0;
2:Invalid=1;
1:Store Tag=1;
0:WriteBack=1;
************/
logic wDataAddrErr;
logic rdataAddrErr;
assign instAddrErr=(pro_pc[1:0]==2'd0)?1'd0:1'd1;

logic [          63:0] multans    ;
logic [          63:0] divans    ;
logic [          31:0] multDivop1    ;
logic [          31:0] multDivop2    ;
logic                  multEn     ;
logic [           2:0] multCycleCount  ;
logic dsvalid;
logic ddvalid;
logic divEn;
logic divAnsvalid;
logic divNextstate;
logic divState;

assign addr_v=pro_regrs+pro_op3;

logic [63:0] multansRes;
assign multansRes=~multans+1;

logic [31:0] resvPC;
assign resvPC=pro_pc+8;

logic [31:0] regtmp;
assign regtmp=~pro_regrt+1;
logic [31:0] immtmp;
assign immtmp=~pro_op3+1;
//add,addu
logic [31:0] addregs;
logic addregsOvfl;
assign addregs=pro_regrt+pro_regrs;
assign addregsOvfl=((~(pro_regrs[31]^pro_regrt[31]))&(addregs[31]^pro_regrs[31]))?1'b1:1'b0;
//addi,addiu
logic [31:0] addregimm;
logic addregimmOvfl;
assign addregimm=pro_regrs+pro_op3;
assign addregimmOvfl=((~(pro_regrs[31]^pro_op3[31]))&(addregimm[31]^pro_regrs[31]))?1'b1:1'b0;
//sub,subu
logic [31:0] subregs;
logic subregsOvfl;
assign subregs=pro_regrs+regtmp;
assign subregsOvfl=((~(pro_regrs[31]^regtmp[31]))&(subregs[31]^pro_regrs[31]))?1'b1:1'b0;
//sub,subu
logic [31:0] subregimm;
logic subregimmOvfl;
assign subregimm=pro_regrs+immtmp;
assign subregimmOvfl=((~(pro_regrs[31]^immtmp[31]))&(subregimm[31]^pro_regrs[31]))?1'b1:1'b0;
logic [63:0] multans_t;
assign multans_t=pro_regrs[31]^pro_regrt[31]?multansRes:multans;
always_comb begin
	if(~aresetn) begin 
		aluAns=32'b0;wHiData=32'b0;wLoData=32'b0;wRegEn=0;
		multDivStall=0;divEn=0;multEn=0;multDivop2=32'b0;multDivop1=32'b0;
		wHiEn=0;wLoEn=0;rdataAddrErr=0;wDataAddrErr=0;
		wCP0En=0;wCP0Data=32'b0;
		rwmem=0;memEn=0;rsize=0;wstrb=0;wsize=0;wdata=32'b0;signExt=0;
		//cacheInst=5'd0;
		tlbr=1'b0;tlbp=1'b0;tlbwi=1'b0;tlbwr=1'b0;left_right=2'b0;
	end else begin
		aluAns=32'b0;wHiData=32'b0;wLoData=32'b0;wRegEn=1'b1;
		multDivStall=0;divEn=0;multEn=0;multDivop2=32'b0;multDivop1=32'b0;
		wHiEn=0;wLoEn=0;rdataAddrErr=0;wDataAddrErr=0;
		wCP0En=0;wCP0Data=32'b0;
		rwmem=0;memEn=0;rsize=0;wstrb=0;wsize=0;wdata=32'b0;signExt=0;
		//cacheInst=5'd0;
		tlbr=1'b0;tlbp=1'b0;tlbwi=1'b0;tlbwr=1'b0;left_right=2'b0;
		case(pro_opcode)
			`OPC_MFHI:begin 
				aluAns=HiData;
			end
			`OPC_MFLO:begin 
				aluAns=LoData;
			end
			`OPC_MTHI:begin 
				wHiData=pro_regrs;wRegEn=0;wHiEn=1;
			end
			`OPC_MTLO:begin 
				wLoData=pro_regrs;wRegEn=0;wLoEn=1;
			end		
			`OPC_MULT : begin
				wHiEn=1;wLoEn=1;wRegEn=0;
				if(multCycleCount==4) begin
					{wHiData,wLoData}=pro_regrs[31]^pro_regrt[31]?multansRes:multans;
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop1 = pro_regrs[31]?~pro_regrs+1:pro_regrs;
					multDivop2 = pro_regrt[31]?~pro_regrt+1:pro_regrt;	
					multEn=1;				
					{wHiData,wLoData}=64'b0;
				end
			end
			`OPC_MULTU : begin
				wHiEn=1;wLoEn=1;wRegEn=0;
				if(multCycleCount==4) begin
					{wHiData,wLoData}=multans;
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop2 = pro_regrs;
					multDivop1 = pro_regrt;	
					multEn=1;				
					{wHiData,wLoData}=64'b0;
				end
			end
			`OPC_DIV  : begin
				wHiEn=1;wLoEn=1;wRegEn=0;
				if(divAnsvalid) begin
					wLoData=pro_regrs[31]^pro_regrt[31]?~divans[63:32]+1:divans[63:32];
					wHiData=pro_regrs[31]?~divans[31:0]+1:divans[31:0];
					multDivStall=0;
				end else begin
					{wLoData,wHiData}=0;
					multDivop1 = pro_regrs[31]?~pro_regrs+1:pro_regrs;
					multDivop2 = pro_regrt[31]?~pro_regrt+1:pro_regrt;	
					divEn=1;					
					multDivStall=1;
				end
			end
			`OPC_DIVU : begin
				wHiEn=1;wLoEn=1;wRegEn=0;
				if(divAnsvalid) begin
					{wLoData,wHiData}=divans;
					multDivStall=0;
				end else begin
					{wLoData,wHiData}=0;
					multDivop1 = pro_regrs;
					multDivop2 = pro_regrt;	
					divEn=1;					
					multDivStall=1;
				end				
			end
			`OPC_MUL:begin 
				if(multCycleCount==4) begin
					aluAns=pro_regrs[31]^pro_regrt[31]?multansRes[31:0]:multans[31:0];
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop1 = pro_regrs[31]?~pro_regrs+1:pro_regrs;
					multDivop2 = pro_regrt[31]?~pro_regrt+1:pro_regrt;	
					multEn=1;				
				end
			end				
			`OPC_MADD:begin 
				wHiEn=1;wLoEn=1;
				if(multCycleCount==4) begin
					{wHiData,wLoData}={HiData,LoData}+multans_t;
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop1 = pro_regrs[31]?~pro_regrs+1:pro_regrs;
					multDivop2 = pro_regrt[31]?~pro_regrt+1:pro_regrt;	
					multEn=1;				
					{wHiData,wLoData}=64'b0;
				end			
			end
			`OPC_MADDU:begin 
				wHiEn=1;wLoEn=1;
				if(multCycleCount==4) begin
					{wHiData,wLoData}={HiData,LoData}+multans;
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop2 = pro_regrt;
					multDivop1 = pro_regrs;	
					multEn=1;				
					{wHiData,wLoData}=64'b0;
				end
			end
			`OPC_MSUB:begin 
				wHiEn=1;wLoEn=1;
				if(multCycleCount==4) begin
					{wHiData,wLoData}={HiData,LoData}-multans_t;
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop1 = pro_regrs[31]?~pro_regrs+1:pro_regrs;
					multDivop2 = pro_regrt[31]?~pro_regrt+1:pro_regrt;	
					multEn=1;				
					{wHiData,wLoData}=64'b0;
				end
			end
			`OPC_MSUBU:begin 
				wHiEn=1;wLoEn=1;
				if(multCycleCount==4) begin
					{wHiData,wLoData}={HiData,LoData}-multans;
					multDivStall = 0;
				end else begin
					multDivStall = 1;
					multDivop2 = pro_regrt;
					multDivop1 = pro_regrs;	
					multEn=1;				
					{wHiData,wLoData}=64'b0;
				end
			end
			`OPC_LB:begin 
				aluAns=addr_v;
				rwmem = 1;
				memEn = 1;
				rsize=2'd0;
				signExt=1'b1;
				wRegEn=1;
			end
			`OPC_LBU:begin 
				aluAns=addr_v;
				rwmem = 1;
				memEn = 1;
				rsize=2'd0;
				signExt=1'b0;
				wRegEn=1;
			end
			`OPC_LH:begin 
				aluAns=addr_v;
				if(addr_v[0]==1'b0) begin 
					rdataAddrErr=0;
					wRegEn=1;
					rwmem = 1;
					memEn = 1;
					rsize=2'd1;
					signExt=1'b1;
					wRegEn=1;						
				end else begin 
					rdataAddrErr=1;
					memEn=0;
					wRegEn=0;
				end
			end
			`OPC_LHU:begin 
				aluAns=addr_v;
				if(addr_v[0]==1'b0) begin 
					rdataAddrErr=0;
					wRegEn=1;
					rwmem = 1;
					memEn = 1;
					rsize=2'd1;
					signExt=1'b0;
					wRegEn=1;
				end else begin 
					rdataAddrErr=1;
					memEn=0;
					wRegEn=0;
				end
			end
			`OPC_LW:begin 
				aluAns=addr_v;
				if(addr_v[1:0]==2'b00) begin 
					rdataAddrErr=0;
					wRegEn=1;
					rwmem = 1;
					memEn = 1;
					rsize=2'd2;
					signExt=1'b0;
					wRegEn=1;
				end else begin 
					rdataAddrErr=1;
					memEn=0;
					wRegEn=0;
				end				
			end
			`OPC_SB:begin 
				aluAns=addr_v;
				wRegEn=0;
				rwmem     = 0;
				memEn     = 1;
				wsize=2'd0;
				wdata = {4{pro_regrt[7:0]}};
				case(addr_v[1:0])
					2'b0    : wstrb=4'b0001;
					2'd1    : wstrb=4'b0010;
					2'd2    : wstrb=4'b0100;
					2'd3    : wstrb=4'b1000;
					default : wstrb=4'b0;
				endcase					
			end
			`OPC_SH:begin 
				aluAns=addr_v;wRegEn=0;
				if(aluAns[0]==1'b0) begin 
					rwmem     = 0;
					memEn     = 1;
					wsize =2'd1;
					wdata = {2{pro_regrt[15:0]}};
					wstrb = {addr_v[1],addr_v[1],~addr_v[1],~addr_v[1]};
				end else begin 
					wDataAddrErr=1;
					memEn=0;
				end
			end
			`OPC_SW:begin 
				aluAns=addr_v;wRegEn=0;
				if(addr_v[1:0]==2'b00) begin 
					rwmem     = 0;
					memEn     = 1;
					wsize=2'd2;
					wdata = pro_regrt;
					wstrb = 4'b1111;
				end else begin 
					wDataAddrErr=1;
					memEn=0;
				end				
			end
			`OPC_SWL:begin //swl
				aluAns=addr_v;
				wRegEn=0;
				rwmem     = 0;
				memEn     = 1;
				wsize=2'd2;
				case(addr_v[1:0])
					2'b0:begin 
						wstrb=4'b0001;
						wdata={4{pro_regrt[31:24]}};
					end
					2'b1:begin 
						wstrb=4'b0011;
						wdata={2{pro_regrt[31:16]}};
					end
					2'd2:begin 
						wstrb=4'b0111;
						wdata={8'b0,pro_regrt[31:8]};
					end
					2'd3:begin 
						wstrb=4'b1111;
						wdata=pro_regrt;
					end
					default:begin 
						wstrb=4'b0;
						wdata=pro_regrt;
					end
				endcase
			end
			`OPC_SWR:begin //swr
				aluAns=addr_v;
				wRegEn=0;
				rwmem     = 0;
				memEn     = 1;
				wsize=2'd2;
				case (addr_v[1:0])
					2'b0:begin 
						wstrb=4'b1111;
						wdata=pro_regrt;
					end
					2'b1:begin 
						wstrb=4'b1110;
						wdata={pro_regrt[23:0],8'b0};
					end
					2'd2:begin 
						wstrb=4'b1100;
						wdata={2{pro_regrt[15:0]}};
					end
					2'd3:begin 
						wstrb=4'b1000;
						wdata={4{pro_regrt[7:0]}};
					end
					default : begin 
						wstrb=4'b0;
						wdata=32'b0;
					end
				endcase
			end
			`OPC_LWL:begin //lwl
				aluAns=addr_v;
				left_right=2'd1;
				rdataAddrErr=0;
				wRegEn=1;
				rwmem = 1;
				memEn = 1;
				rsize=2'd2;
				signExt=1'b0;
				wRegEn=1;	
			end
				`OPC_LWR:begin //lwr
					aluAns=addr_v;
					left_right=2'd2;
					rdataAddrErr=0;
					wRegEn=1;
					rwmem = 1;
					memEn = 1;
					rsize=2'd2;
					signExt=1'b0;
					wRegEn=1;
				end
				`OPC_MFC0:begin 
					aluAns=rCP0Data;wRegEn=1;
				end
				`OPC_MTC0:begin 
					wCP0En=1;wCP0Data=pro_regrt;wRegEn=0;
				end
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
				`OPC_SLT: if ((subregs[31]&(~subregsOvfl))|((~subregs[31])&subregsOvfl))
				aluAns = 32'b1;else aluAns=32'b0;
				`OPC_SLTI:if ((subregimm[31]&(~subregimmOvfl))|((~subregimm[31])&subregimmOvfl))
				aluAns = 32'b1;else aluAns=32'b0;
				`OPC_SLTU:aluAns = (pro_regrs<pro_regrt)?32'b1:32'b0;
				`OPC_SLTIU:aluAns = (pro_regrs<pro_op3)?32'b1:32'b0;
				`OPC_AND:aluAns = pro_regrs&pro_regrt;
				`OPC_ANDI:aluAns=pro_regrs&pro_op3;
				`OPC_LUI:aluAns=pro_op3;
				`OPC_NOR:aluAns=~(pro_regrs|pro_regrt);
				`OPC_OR:aluAns=pro_regrs|pro_regrt;
				`OPC_ORI:aluAns=pro_regrs|pro_op3;
				`OPC_XOR:aluAns=pro_regrs^pro_regrt;
				`OPC_XORI:aluAns=pro_regrs^pro_op3;
				`OPC_SLLV:aluAns=pro_regrt<<pro_regrs[4:0];
				`OPC_SLL:aluAns=pro_regrt<<pro_op3[4:0];
				`OPC_SRLV:aluAns=pro_regrt>>pro_regrs[4:0];
				`OPC_SRL:aluAns=pro_regrt>>pro_op3[4:0];
				`OPC_SRAV:aluAns=({32{pro_regrt[31]}}<<(6'd32-{1'b0,pro_regrs[4:0]}))|pro_regrt>>pro_regrs[4:0];
				`OPC_SRA:aluAns=({32{pro_regrt[31]}}<<(6'd32-{1'b0,pro_op3[4:0]}))|pro_regrt>>pro_op3[4:0];
				// `OPC_JALR:begin 
				// 	branchPC=pro_regrs;aluAns=resvPC;gotoBranch=1;
				// end
				// `OPC_JR:begin 
				// 	gotoBranch=1;branchPC=pro_regrs;wRegEn=0;
				// end
				// `OPC_JAL:begin 
				// 	branchPC=pro_op3;aluAns=resvPC;gotoBranch=1;
				// end
				// `OPC_J:begin 
				// 	branchPC=pro_op3;gotoBranch=1;wRegEn=0;
				// end
				// `OPC_BLTZAL:begin 
				// 	aluAns=resvPC;branchPC=pro_op3;
				// 	if(pro_regrs[31]==1'b1) gotoBranch=1;else gotoBranch=0;
				// end
				// `OPC_BGEZAL:begin 
				// 	aluAns=resvPC;branchPC=pro_op3;
				// 	if(pro_regrs[31]==1'b0) gotoBranch=1; else gotoBranch=0;	
				// end
				// `OPC_BLTZ:begin 
				// 	branchPC=pro_op3;wRegEn=0;
				// 	if(pro_regrs[31]==1'b1) gotoBranch=1;else gotoBranch=0;		
				// end		
				// `OPC_BGEZ:begin 
				// 	branchPC=pro_op3;wRegEn=0;
				// 	if(pro_regrs[31]==1'b0) gotoBranch=1;else gotoBranch=0;	
				// end	
				// `OPC_BLEZ:begin 
				// 	branchPC=pro_op3;wRegEn=0;
				// 	if((pro_regrs[31]==1'b1)||(|pro_regrs==1'b0)) gotoBranch=1;else gotoBranch=0;	
				// end
				// `OPC_BGTZ:begin 
				// 	branchPC=pro_op3;wRegEn=0;
				// 	if((pro_regrs[31]==1'b0)&&(|pro_regrs!=1'b0)) gotoBranch=1;else gotoBranch=0;	
				// end	
				// `OPC_BNE:begin 
				// 	branchPC=pro_op3;wRegEn=0;
				// 	if(pro_regrs!=pro_regrt) gotoBranch=1;else gotoBranch=0;			
				// end	
				// `OPC_BEQ:begin 
				// 	branchPC=pro_op3;wRegEn=0;
				// 	if(pro_regrs==pro_regrt) gotoBranch=1;else gotoBranch=0;	
				// end		
				`OPC_CLO:
				aluAns=(pro_regrs[31]==0)?32'd0:
				(pro_regrs[30]==0)?32'd1:
				(pro_regrs[29]==0)?32'd2:
				(pro_regrs[28]==0)?32'd3:
				(pro_regrs[27]==0)?32'd4:
				(pro_regrs[26]==0)?32'd5:
				(pro_regrs[25]==0)?32'd6:
				(pro_regrs[24]==0)?32'd7:
				(pro_regrs[23]==0)?32'd8:
				(pro_regrs[22]==0)?32'd9:
				(pro_regrs[21]==0)?32'd10:
				(pro_regrs[20]==0)?32'd11:
				(pro_regrs[19]==0)?32'd12:
				(pro_regrs[18]==0)?32'd13:
				(pro_regrs[17]==0)?32'd14:
				(pro_regrs[16]==0)?32'd15:
				(pro_regrs[15]==0)?32'd16:
				(pro_regrs[14]==0)?32'd17:
				(pro_regrs[13]==0)?32'd18:
				(pro_regrs[12]==0)?32'd19:
				(pro_regrs[11]==0)?32'd20:
				(pro_regrs[10]==0)?32'd21:
				(pro_regrs[9]==0)?32'd22:
				(pro_regrs[8]==0)?32'd23:
				(pro_regrs[7]==0)?32'd24:
				(pro_regrs[6]==0)?32'd25:
				(pro_regrs[5]==0)?32'd26:
				(pro_regrs[4]==0)?32'd27:
				(pro_regrs[3]==0)?32'd28:
				(pro_regrs[2]==0)?32'd29:
				(pro_regrs[1]==0)?32'd30:	
				(pro_regrs[0]==0)?32'd31:32'd32;
				`OPC_CLZ:	
				aluAns=(pro_regrs[31]==1)?32'd0:
				(pro_regrs[30]==1)?32'd1:
				(pro_regrs[29]==1)?32'd2:
				(pro_regrs[28]==1)?32'd3:
				(pro_regrs[27]==1)?32'd4:
				(pro_regrs[26]==1)?32'd5:
				(pro_regrs[25]==1)?32'd6:
				(pro_regrs[24]==1)?32'd7:
				(pro_regrs[23]==1)?32'd8:
				(pro_regrs[22]==1)?32'd9:
				(pro_regrs[21]==1)?32'd10:
				(pro_regrs[20]==1)?32'd11:
				(pro_regrs[19]==1)?32'd12:
				(pro_regrs[18]==1)?32'd13:
				(pro_regrs[17]==1)?32'd14:
				(pro_regrs[16]==1)?32'd15:
				(pro_regrs[15]==1)?32'd16:
				(pro_regrs[14]==1)?32'd17:
				(pro_regrs[13]==1)?32'd18:
				(pro_regrs[12]==1)?32'd19:
				(pro_regrs[11]==1)?32'd20:
				(pro_regrs[10]==1)?32'd21:
				(pro_regrs[9]==1)?32'd22:
				(pro_regrs[8]==1)?32'd23:
				(pro_regrs[7]==1)?32'd24:
				(pro_regrs[6]==1)?32'd25:
				(pro_regrs[5]==1)?32'd26:
				(pro_regrs[4]==1)?32'd27:
				(pro_regrs[3]==1)?32'd28:
				(pro_regrs[2]==1)?32'd29:
				(pro_regrs[1]==1)?32'd30:	
				(pro_regrs[0]==1)?32'd31:32'd32;	
				`OPC_MOVN:begin
					aluAns=pro_regrs;
					if((|pro_regrt)!=0) wRegEn=1;else wRegEn=0;
				end
				`OPC_MOVZ:begin
					aluAns=pro_regrs;
					if((|pro_regrt)==0) wRegEn=1;else wRegEn=0;
				end	
				// `OPC_I_IndexValid:begin 
				// 	aluAns=addr_v;cacheInst=5'b01100;wRegEn=0;memEn=1;
				// end
				// `OPC_I_IndexStoreTag:begin 
				// 	aluAns=addr_v;cacheInst=5'b00000;wRegEn=0;//as a nop
				// end
				// `OPC_I_HitInvalid:begin 
				// 	aluAns=addr_v;cacheInst=5'b00100;wRegEn=0;memEn=1;
				// end
				// `OPC_D_IndexWbInvalid:begin 
				// 	aluAns=addr_v;cacheInst=5'b11101;wRegEn=0;memEn=1;
				// end 
				// `OPC_D_IndexStoreTag:begin 
				// 	aluAns=addr_v;cacheInst=5'b00000;wRegEn=0;//as a nop
				// end 
				// `OPC_D_IndexHitValid:begin 
				// 	aluAns=addr_v;cacheInst=5'b10100;wRegEn=0;memEn=1;
				// end 
				// `OPC_D_HitWbInvalid:begin 
				// 	aluAns=addr_v;cacheInst=5'b10101;wRegEn=0;memEn=1;
				// end				
				`OPC_RESV:begin
					aluAns=32'b0;wRegEn=0;
				end
				`OPC_TLBR:begin 
					tlbr=1'b1;
				end
				`OPC_TLBWI:begin 
					tlbwi=1'b1;
				end
				`OPC_TLBP:begin 
					tlbp=1'b1;
				end
				`OPC_TLBWR:begin 
					tlbwr=1'b1;
				end
			endcase
		end	
	end
	

	always_ff @(posedge clk) begin : proc_divstate
		if(~aresetn) begin
			divState <= 0;
		end else begin
			divState<=divNextstate;
		end
	end

	always_comb begin : proc_divnextstate
		case (divState)
			1'b0: begin : idle
				if(divEn) begin 
					divNextstate=1'b1;
					dsvalid=1;
					ddvalid=1;
				end else begin 
					divNextstate=1'b0;
					dsvalid=0;
					ddvalid=0;
				end
			end:idle	
			1'b1: begin : waitforresult
				dsvalid=0;
				ddvalid=0;
				if (divAnsvalid) divNextstate=1'b0;
				else divNextstate=1'b1;
			end	:waitforresult
			default : begin 
				dsvalid=0;
				ddvalid=0;
				divNextstate=0;
			end
		endcase
	end

	always_ff @(posedge clk) begin : proc_multCycleCount
		if(~aresetn) begin
			multCycleCount <= 0;
		end else begin
			if (multEn&(multCycleCount[2]!=1'b1)) multCycleCount <= multCycleCount+1 ;
			else multCycleCount<=0;
		end
	end

	div_gen_0 div (
	.aclk                  (clk                  ), // input wire aclk
	.aresetn               (aresetn               ), // input wire aresetn
	.s_axis_divisor_tvalid (dsvalid ), // input wire s_axis_divisor_tvalid
	.s_axis_divisor_tdata  (multDivop2  ), // input wire [31 : 0] s_axis_divisor_tdata
	.s_axis_dividend_tvalid(ddvalid), // input wire s_axis_dividend_tvalid
	.s_axis_dividend_tdata (multDivop1 ), // input wire [31 : 0] s_axis_dividend_tdata
	.m_axis_dout_tvalid    (divAnsvalid    ), // output wire m_axis_dout_tvalid
	.m_axis_dout_tdata     (divans    )  // output wire [63 : 0] m_axis_dout_tdata
	);

	mult_gen_0 mult (
	.CLK(clk    ), // input wire CLK
	.A  (multDivop1), // input wire [31 : 0] A
	.B  (multDivop2), // input wire [31 : 0] B
	.P  (multans), // output wire [63 : 0] P
	.CE (multEn )
	);

	always_comb begin : exception
		if (~aresetn) begin
			excep = 6'b0;
		end else begin
			if(pro_opcode==`OPC_ERET) excep[6]=1'b1;else excep[6]=1'b0;
			if(instAddrErr|rdataAddrErr) excep[5]=1'b1; else excep[5]=1'b0;
			if(pro_opcode==`OPC_RESV) excep[4]=1'b1;else excep[4]=1'b0;
			if(((pro_opcode==`OPC_ADD)&addregsOvfl)|((pro_opcode==`OPC_ADDI)&addregimmOvfl)|((pro_opcode==`OPC_SUB)&subregsOvfl)) excep[3]=1'b1;else excep[3]=1'b0;
			if(pro_opcode==`OPC_BRK) excep[2]=1'b1;else excep[2]=1'b0;
			if(pro_opcode==`OPC_SYSC) excep[1]=1'b1;else excep[1]=1'b0;
			if(wDataAddrErr) excep[0]=1'b1;else excep[0]=1'b0;
		end
	end

	assign copU=(pro_opcode==`OPC_COP_U);
endmodule