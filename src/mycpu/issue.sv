module issue (
	input clk,    // Clock
	input aresetn,
	input [31:0] inst1_cached,
	input [31:0] inst2_cached,
	input [31:0] inst1_uncached,
	input [31:0] inst2_uncached,
	input [31:0] pc,
	input stall,
	input flush,
	input write1En,
	input write2En,
	input gotoBranch,
	input cached,
	input [1:0] iexcep,
	input [3:0] regrs1_mux,
	input [3:0] regrt1_mux,
	input [3:0] regrs2_mux,
	input [3:0] regrt2_mux,
	input stallrs1,
	input stallrt1,
	input stallrs2,
	input stallrt2,
	input [31:0] regrs1,
	input [31:0] regrt1,
	input [31:0] regrs2,
	input [31:0] regrt2,	
	output logic [3:0] pro_rs_mux,
	output logic [3:0] pro_rt_mux,
	output logic [3:0] lite_rs_mux,
	output logic [3:0] lite_rt_mux,	
	output logic reverse,
	output logic fifoFull,
	output logic [31:0] pro_pc,
	output logic [7:0] pro_opcode,
	output logic [4:0] rs1,
	output logic [4:0] rt1,
	output logic [2:0] pro_sel,
	output logic [4:0] pro_wRegAddr,
	output logic [31:0] pro_op3,
	output logic [4:0] pro_wCP0Addr,
	output logic [4:0] pro_rCP0Addr,
	output logic pro_bd,
	output logic pro_wRegEn,
	output logic [31:0] lite_pc,
	output logic [7:0] lite_opcode,
	output logic [4:0] rs2,
	output logic [4:0] rt2,
	output logic [4:0] lite_wRegAddr,
	output logic [31:0] lite_op3,
	output logic lite_bd,
	output logic lite_wRegEn,
	output logic [3:0] issueState,
	output logic pro_bubble,
	output logic lite_bubble,
	output logic [31:0] pro_regrs,
	output logic [31:0] pro_regrt,
	output logic [31:0] lite_regrs,
	output logic [31:0] lite_regrt,
	output logic [1:0] lite_iexcep,
	output logic [1:0] pro_iexcep
	);

logic [31:0] instBuff[0:15];
logic [31:0] pcBuff[0:15];
logic [1:0] iexcepBuff[0:15];
logic [3:0] readPtr;
logic [3:0] writePtr;
logic [1:0] canReadNum;
logic nextbd;
logic firstbd;
//pipe_pro:all func; pipe_lite:arith,branch
//0:1 to pipe_pro,2 to pipe_lite;
//1:2 to pipe_pro,1 to pipe_lite;
//2:1 to pipe_pro;
//3:none
logic stall_first;
logic stall_second;
/*autodef*/
logic [2:0] sel1;
logic [31:0] firstpc;
logic [4:0] rCP0Addr2;
logic [4:0] rCP0Addr1;
logic readrtEn2;
logic readrtEn1;
logic readrsEn2;
logic readrsEn1;
logic [4:0] wRegAddr1;
logic [31:0] op31;
logic [2:0] sel2;
logic [4:0] wRegAddr2;
logic [31:0] secondInst;
logic [4:0] wCP0Addr2;
logic [4:0] wCP0Addr1;
logic [31:0] secondpc;
logic [7:0] opcode2;
logic [7:0] opcode1;
logic [31:0] op32;
logic [31:0] firstInst;
logic wRegEn1;
logic wRegEn2;
assign rs1=firstInst[25:21];
assign rt1=firstInst[20:16];
assign sel1=firstInst[2:0];
assign wCP0Addr1=firstInst[15:11];
assign rCP0Addr1=firstInst[15:11];
assign rs2=secondInst[25:21];
assign rt2=secondInst[20:16];
assign sel2=secondInst[2:0];
assign wCP0Addr2=secondInst[15:11];
assign rCP0Addr2=secondInst[15:11];
logic [1:0] iexcep1;
logic [1:0] iexcep2;

logic [1:0] issueMethod;
logic [1:0] validInstNum;
logic data_hazard;
logic [3:0] readPtrAdd1;
logic [3:0] writePtrAdd4;
logic [3:0] writePtrAdd3;
logic [3:0] writePtrAdd1;
logic [3:0] writePtrAdd2;
assign readPtrAdd1=readPtr+1;
assign writePtrAdd4=writePtr+4;
assign writePtrAdd3=writePtr+3;
assign writePtrAdd1=writePtr+1;
assign writePtrAdd2=writePtr+2;
assign fifoFull=((writePtrAdd3==readPtr)|(writePtrAdd4==readPtr)|(writePtrAdd1==readPtr)|(writePtrAdd2==readPtr))?1'b1:1'b0;
assign canReadNum=(readPtr==writePtr)?2'd0:(readPtrAdd1==writePtr)?2'd1:2'd2;

logic [31:0] inst1;
logic [31:0] inst2;
assign inst1=cached?inst1_cached:inst1_uncached;
assign inst2=cached?inst2_cached:inst2_uncached;


always_ff @(posedge clk) begin : proc_readPtr
	if(~aresetn) begin
		readPtr <= 0;
	end else begin
		if(flush|gotoBranch) begin 
			readPtr<=writePtr;
		end else if(stall) begin 
		end
		else if(issueMethod==2'd0||issueMethod==2'd1) readPtr<=readPtr+2;
		else if(issueMethod==2'd2) begin 
			readPtr<=readPtr+1;
		end
	end
end

always_ff @(posedge clk) begin
	if(~aresetn) begin
		writePtr <= 0;
	end else begin
		if(flush|gotoBranch) begin 
		end else begin 
			if(write1En&&write2En) begin 
				instBuff[writePtr]<=inst1;
				instBuff[writePtrAdd1]<=inst2;
				iexcepBuff[writePtr]<=iexcep;
				pcBuff[writePtr]<=pc;
				pcBuff[writePtrAdd1]<=pc+4;
				iexcepBuff[writePtrAdd1]<=2'd1;
				writePtr<=writePtr+2;
			end else if(write1En) begin 
				instBuff[writePtr]<=inst1;
				iexcepBuff[writePtr]<=iexcep;
				writePtr<=writePtr+1;
				pcBuff[writePtr]<=pc;
			end
		end
	end
end

always_comb begin : proc_getInst
	case(canReadNum)
		2'b01:begin 
			firstInst=instBuff[readPtr];
			firstpc=pcBuff[readPtr];
			secondInst=32'b0;
			secondpc=32'b0;
			iexcep1=iexcepBuff[readPtr];
			iexcep2=2'b1;
		end
		2'b10:begin 
			firstInst=instBuff[readPtr];
			firstpc=pcBuff[readPtr];
			iexcep1=iexcepBuff[readPtr];
			secondInst=instBuff[readPtrAdd1];
			secondpc=pcBuff[readPtrAdd1];
			iexcep2=iexcepBuff[readPtrAdd1];
		end
		default : begin 
			secondInst=32'b0;
			secondpc=32'b0;
			firstInst=32'b0;
			firstpc=32'b0;
			iexcep1=2'd1;
			iexcep2=2'd1;
		end
	endcase
end

decoder first_decoder
(/*autoinst*/
	.aresetn  (aresetn),
	.pc      (firstpc),
	.inst     (firstInst),
	.opcode   (opcode1),
	.wRegAddr (wRegAddr1),
	.op3      (op31),
	.wRegEn  (wRegEn1),
	.readrsEn(readrsEn1),
	.readrtEn(readrtEn1)
	);

decoder second_decoder
(/*autoinst*/
	.aresetn  (aresetn),
	.pc      (secondpc),
	.inst     (secondInst),
	.opcode   (opcode2),
	.wRegAddr (wRegAddr2),
	.op3      (op32),
	.wRegEn  (wRegEn2),
	.readrsEn(readrsEn2),
	.readrtEn(readrtEn2)
	);

assign stall_first=(readrsEn1&stallrs1)|(readrtEn1&stallrt1);
assign stall_second=(readrsEn2&stallrs2)|(readrtEn2&stallrt2);
//data hazard?
always_comb begin 
	if((((readrtEn2&wRegEn1&(wRegAddr1==rt2))|(readrsEn2&wRegEn1&(wRegAddr1==rs2)))&(wRegAddr1!=5'd0))) data_hazard=1;
	else data_hazard=0;
end

logic bd2;

always_comb begin : proc_validInstNum
	casez({canReadNum,stall_first,stall_second,data_hazard})
		5'b??1??:validInstNum=2'd0;
		5'b1001?,5'b10??1,5'b010??:validInstNum=2'd1;
		5'b10000:validInstNum=2'd2;
		default : validInstNum=2'd0;
	endcase
end
always_comb begin
	if(validInstNum==2'd2)begin
		if(opcode1[7:5]==3'b010) begin 
			issueMethod=2'd1;bd2=1;issueState=4'd1;
		end else if(opcode2[7:5]==3'b010) begin 
			issueMethod=2'd2;bd2=0;issueState=4'd2;
		end else if(opcode2[7:5]==3'b000) begin 
			bd2=0;if(opcode1[7:4]==4'b1011) begin 
				issueMethod=2'd2;
				issueState=4'd3;
			end else begin 
				issueMethod=2'd0;
				issueState=4'd4;
			end
		end else if(opcode1[7:5]==3'b000) begin 
			bd2=0;issueMethod=2'd1;issueState=4'd6;
		end else begin 
			issueMethod=2'd2;bd2=0;issueState=4'd7;
		end
	end else if(validInstNum==1) begin
		if(opcode1[7:5]==3'b010) begin 
			issueMethod=2'd3;
			bd2=0;
			issueState=4'd8;
		end else begin 
			issueMethod=2'd2;
			bd2=0;
			issueState=4'd9;
		end
	end else begin 
		issueMethod=2'd3;
		bd2=0;
		issueState=4'd10;
	end
end

// always_ff @(posedge clk) begin : proc_nextbd
// 	if(~aresetn) begin
// 		nextbd <= 0;
// 	end else begin
// 		if({opcode1[7:5],opcode2[7:5]}==6'b010010)
// 		nextbd <= 1;else nextbd<=0;
// 	end
// end

always_ff @(posedge clk) begin : proc_issue
	if (~aresetn|flush|gotoBranch)begin 
		reverse<=0;
		lite_opcode<=6'b0;
		lite_pc<=32'b0;
		lite_wRegAddr<=5'b0;
		lite_op3<=32'b0;
		lite_bd<=0;	
		lite_bubble<=1;
		lite_rs_mux<=0;
		lite_rt_mux<=0;
		lite_regrs<=32'b0;
		lite_regrt<=32'b0;
		pro_regrs<=32'b0;
		pro_regrt<=32'b0;		
		pro_opcode<=6'b0;
		pro_pc<=32'b0;
		pro_sel<=3'b0;
		pro_wRegAddr<=5'b0;
		pro_op3<=32'b0;
		pro_rCP0Addr<=5'b0;
		pro_wCP0Addr<=5'b0;
		pro_bd<=0;	
		pro_bubble<=1;
		pro_iexcep<=2'd1;
		lite_iexcep<=2'd1;
		pro_wRegEn<=0;
		lite_wRegEn<=0;
		pro_rt_mux<=0;
		pro_rs_mux<=0;
	end else if(stall) begin 
	end else begin
		case(issueMethod)
			2'b00:begin
				reverse<=0;
				pro_opcode<=opcode1;
				pro_pc<=firstpc;
				pro_sel<=sel1;
				pro_wRegAddr<=wRegAddr1;
				pro_op3<=op31;
				pro_rCP0Addr<=rCP0Addr1;
				pro_wCP0Addr<=wCP0Addr1;
				pro_bd<=1'b0;
				pro_bubble<=0;
				pro_wRegEn<=wRegEn1;
				pro_rs_mux<=regrs1_mux;
				pro_rt_mux<=regrt1_mux;
				pro_regrt<=regrt1;
				pro_regrs<=regrs1;
				pro_iexcep<=iexcep1;
				lite_regrt<=regrt2;
				lite_regrs<=regrs2;
				lite_wRegEn<=wRegEn2;
				lite_opcode<=opcode2;
				lite_pc<=secondpc;
				lite_wRegAddr<=wRegAddr2;
				lite_op3<=op32;
				lite_bd<=bd2;	
				lite_bubble<=0;
				lite_rs_mux<=regrs2_mux;
				lite_rt_mux<=regrt2_mux;
				lite_iexcep<=iexcep2;
			end
			2'b01:begin
				reverse<=1;
				lite_opcode<=opcode1;
				lite_pc<=firstpc;
				lite_wRegAddr<=wRegAddr1;
				lite_op3<=op31;
				lite_bd<=1'b0;
				lite_bubble<=0;
				lite_wRegEn<=wRegEn1;
				lite_rs_mux<=regrs1_mux;
				lite_rt_mux<=regrt1_mux;
				lite_regrs<=regrs1;
				lite_regrt<=regrt1;
				lite_iexcep<=iexcep1;
				pro_regrs<=regrs2;
				pro_regrt<=regrt2;
				pro_wRegEn<=wRegEn2;
				pro_opcode<=opcode2;
				pro_pc<=secondpc;
				pro_sel<=sel2;
				pro_wRegAddr<=wRegAddr2;
				pro_op3<=op32;
				pro_rCP0Addr<=rCP0Addr2;
				pro_wCP0Addr<=wCP0Addr2;	
				pro_bd<=bd2;
				pro_bubble<=0;
				pro_rs_mux<=regrs2_mux;
				pro_rt_mux<=regrt2_mux;
				pro_iexcep<=iexcep2;
			end 
			2'b10:begin
				reverse<=0;
				pro_opcode<=opcode1;
				pro_pc<=firstpc;
				pro_sel<=sel1;
				pro_wRegAddr<=wRegAddr1;
				pro_op3<=op31;
				pro_rCP0Addr<=rCP0Addr1;
				pro_wCP0Addr<=wCP0Addr1;
				pro_bubble<=0;
				pro_bd<=1'b0;
				pro_wRegEn<=wRegEn1;
				pro_rs_mux<=regrs1_mux;
				pro_rt_mux<=regrt1_mux;
				pro_regrs<=regrs1;
				pro_regrt<=regrt1;
				pro_iexcep<=iexcep1;
				lite_regrs<=32'b0;
				lite_regrt<=32'b0;
				lite_wRegEn<=0;
				lite_opcode<=6'b0;
				lite_pc<=32'b0;
				lite_wRegAddr<=5'b0;
				lite_op3<=32'b0;	
				lite_bd<=0;
				lite_bubble<=1;	
				lite_iexcep<=2'd1;
			end
			default:begin
				reverse<=0;
				lite_opcode<=6'b0;
				lite_pc<=32'b0;
				lite_wRegAddr<=5'b0;
				lite_op3<=32'b0;
				lite_bd<=0;	
				lite_bubble<=1;
				lite_wRegEn<=0;
				lite_rs_mux<=0;
				lite_rt_mux<=0;
				lite_regrs<=32'b0;
				lite_regrt<=32'b0;
				lite_iexcep<=2'd1;
				pro_regrs<=32'b0;
				pro_regrt<=32'b0;
				pro_wRegEn<=0;
				pro_opcode<=6'b0;
				pro_pc<=32'b0;
				pro_sel<=3'b0;
				pro_wRegAddr<=5'b0;
				pro_op3<=32'b0;
				pro_rCP0Addr<=5'b0;
				pro_wCP0Addr<=5'b0;
				pro_bd<=0;	
				pro_bubble<=1;
				pro_rt_mux<=0;
				pro_rs_mux<=0;
				pro_iexcep<=2'd1;		
			end
		endcase
	end
end

endmodule