 `include "cpu_instr_define.svh"
`include "define.svh"
module decoder (
	input aresetn,
	input [31:0] inst,
	input [31:0] pc,
	output logic [7:0] opcode,
	output logic [4:0] wRegAddr,
	output logic [31:0] op3,
	output logic wRegEn,
	output logic readrsEn,
	output logic readrtEn
	);
logic [     5:0] op   ;
logic [    15:0] imm  ;
logic [   5:0] func ;
logic [  4:0] shamt;
logic [4:0] rd   ;
logic [4:0] rt;
logic [   31:0] b_pc ;
logic [   31:0] j_pc ;
logic [31:0] nextPC;
logic [4:0] rs;
assign rs=inst[25:21];
assign nextPC=pc+4;
assign rd    = inst[15:11];
assign rt =inst[20:16];
assign op    = inst[31:26];
assign imm   = inst[15:0];
assign func  = inst[5:0];
assign shamt = inst[10:6];
assign b_pc  = nextPC+{{14{imm[15]}},imm,2'b0};
assign j_pc  = {nextPC[31:28],inst[25:0],2'b0};
logic cpo0;
assign cpo0=inst[25]&((|inst[24:6])==1'b0);
logic cp0_spec;
assign cp0_spec=((|inst[10:3])==1'b0);
always_comb begin
	if(~aresetn) begin 
		op3=32'd0;opcode=`OPC_SLL;wRegAddr=5'd0;wRegEn=0;readrtEn=0;readrsEn=0;
	end else begin 
		op3=32'd0;wRegEn=0;readrtEn=0;readrsEn=0;opcode=`OPC_RESV;wRegAddr=5'd0;
		case(op)
			`OP_ADDI:begin 
				op3={{16{imm[15]}},imm[15:0]};opcode=`OPC_ADDI;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_ADDIU:begin 
				op3={{16{imm[15]}},imm[15:0]};opcode=`OPC_ADDIU;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_SLTI:begin 
				op3={{16{imm[15]}},imm[15:0]};opcode=`OPC_SLTI;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_SLTIU:begin 
				op3={{16{imm[15]}},imm[15:0]};opcode=`OPC_SLTIU;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_ANDI:begin 
				op3={{16{1'b0}},imm[15:0]};opcode=`OPC_ANDI;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_ORI:begin 
				op3={{16{1'b0}},imm[15:0]};opcode=`OPC_ORI;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_XORI:begin 
				op3={{16{1'b0}},imm[15:0]};opcode=`OPC_XORI;wRegAddr=rt;wRegEn=1;readrsEn=1;
			end
			`OP_LUI:begin 
				op3={imm[15:0],{16{1'b0}}};opcode=`OPC_LUI;wRegAddr=rt;wRegEn=1;
			end
			`OP_R:begin 
				case(func)
					`FUNC_ADD:begin 
						op3=32'b0;opcode=`OPC_ADD;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SUB:begin 
						op3=32'b0;opcode=`OPC_SUB;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_ADDU:begin 
						op3=32'b0;opcode=`OPC_ADDU;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SUBU:begin 
						op3=32'b0;opcode=`OPC_SUBU;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SLT:begin 
						op3=32'b0;opcode=`OPC_SLT;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SLTU:begin 
						op3=32'b0;opcode=`OPC_SLTU;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_AND:begin 
						op3=32'b0;opcode=`OPC_AND;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_NOR:begin 
						op3=32'b0;opcode=`OPC_NOR;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_OR:begin 
						op3=32'b0;opcode=`OPC_OR;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_XOR:begin 
						op3=32'b0;opcode=`OPC_XOR;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SLLV:begin 
						op3=32'b0;opcode=`OPC_SLLV;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SRLV:begin 
						op3=32'b0;opcode=`OPC_SRLV;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SRAV:begin 
						op3=32'b0;opcode=`OPC_SRAV;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SLL:begin 
						op3={{27{1'b0}},shamt};opcode=`OPC_SLL;wRegAddr=rd;wRegEn=1;readrtEn=1;
					end
					`FUNC_SRL:begin 
						op3={{27{1'b0}},shamt};opcode=`OPC_SRL;wRegAddr=rd;wRegEn=1;readrtEn=1;
					end
					`FUNC_SRA:begin 
						op3={{27{1'b0}},shamt};opcode=`OPC_SRA;wRegAddr=rd;wRegEn=1;readrtEn=1;
					end
					`FUNC_JR:begin 
						op3=32'b0;opcode=`OPC_JR;wRegAddr=rd;readrsEn=1;
					end
					`FUNC_JALR:begin 
						op3=32'b0;opcode=`OPC_JALR;wRegAddr=rd;wRegEn=1;readrsEn=1;
					end
					`FUNC_MFHI:begin 
						op3=32'b0;opcode=`OPC_MFHI;wRegAddr=rd;wRegEn=1;
					end
					`FUNC_MFLO:begin 
						op3=32'b0;opcode=`OPC_MFLO;wRegAddr=rd;wRegEn=1;
					end
					`FUNC_MTHI:begin 
						op3=32'b0;opcode=`OPC_MTHI;wRegAddr=rd;readrsEn=1;
					end
					`FUNC_MTLO:begin 
						op3=32'b0;opcode=`OPC_MTLO;wRegAddr=rd;readrsEn=1;
					end
					`FUNC_SYSC:begin 
						op3=inst[25:6];opcode=`OPC_SYSC;wRegAddr=rd;	
					end
					`FUNC_BRK:begin 
						op3=inst[25:6];opcode=`OPC_BRK;wRegAddr=rd;
					end
					`FUNC_MULT:begin 
						op3=32'b0;opcode=`OPC_MULT;wRegAddr=rd;readrtEn=1;readrsEn=1;
					end
					`FUNC_MULTU:begin 
						op3=32'b0;opcode=`OPC_MULTU;wRegAddr=rd;readrtEn=1;readrsEn=1;
					end
					`FUNC_DIV:begin 
						op3=32'b0;opcode=`OPC_DIV;wRegAddr=rd;readrtEn=1;readrsEn=1;
					end
					`FUNC_DIVU:begin 
						op3=32'b0;opcode=`OPC_DIVU;wRegAddr=rd;readrtEn=1;readrsEn=1;
					end
					`FUNC_MOVN:begin 
						op3=32'b0;opcode=`OPC_MOVN;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_MOVZ:begin 
						op3=32'b0;opcode=`OPC_MOVZ;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;
					end
					`FUNC_SYNC:begin 
						opcode=`OPC_SLL;
					end
					`FUNC_MOVCI:begin
						opcode=`OPC_COP_U;
					end
				endcase // func
			end
			`OP_LB:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LB;wRegAddr=rt;wRegEn=1;readrsEn=1;			
			end
			`OP_LBU:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LBU;wRegAddr=rt;wRegEn=1;readrsEn=1;				
			end
			`OP_LH:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LH;wRegAddr=rt;wRegEn=1;readrsEn=1;				
			end
			`OP_LHU:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LHU;wRegAddr=rt;wRegEn=1;readrsEn=1;				
			end
			`OP_LW:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LW;wRegAddr=rt;wRegEn=1;readrsEn=1;				
			end
			`OP_SB:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_SB;wRegAddr=5'b0;readrtEn=1;readrsEn=1;				
			end
			`OP_SH:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_SH;wRegAddr=5'b0;readrtEn=1;readrsEn=1;;				
			end
			`OP_SW:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_SW;wRegAddr=5'b0;readrtEn=1;readrsEn=1;				
			end
			`OP_SWL:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_SWL;wRegAddr=5'b0;readrtEn=1;readrsEn=1;				
			end
			`OP_SWR:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_SWR;wRegAddr=5'b0;readrtEn=1;readrsEn=1;				
			end
			`OP_LWR:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LWR;wRegAddr=rt;wRegEn=1;readrsEn=1;readrtEn=1;
			end
			`OP_LWL:begin 
				op3={{16{imm[15]}},imm};opcode=`OPC_LWL;wRegAddr=rt;wRegEn=1;readrsEn=1;readrtEn=1;		
			end
			`OP_SPEC2:begin 
				case(func)
					`FUNC_CLO:begin 
						op3=32'b0;opcode=`OPC_CLO;wRegAddr=rd;wRegEn=1;readrsEn=1;
					end
					`FUNC_CLZ:begin 
						op3=32'b0;opcode=`OPC_CLZ;wRegAddr=rd;wRegEn=1;readrsEn=1;
					end
					`FUNC_MUL:begin 
						op3=32'b0;opcode=`OPC_MUL;wRegAddr=rd;wRegEn=1;readrtEn=1;readrsEn=1;	
					end
					`FUNC_MADD:begin 
						op3=32'b0;opcode=`OPC_MADD;wRegAddr=rd;readrtEn=1;readrsEn=1;	
					end
					`FUNC_MADDU:begin 
						op3=32'b0;opcode=`OPC_MADDU;wRegAddr=rd;readrtEn=1;readrsEn=1;	
					end
					`FUNC_MSUB:begin 
						op3=32'b0;opcode=`OPC_MSUB;wRegAddr=rd;readrtEn=1;readrsEn=1;	
					end
					`FUNC_MSUBU:begin 
						op3=32'b0;opcode=`OPC_MSUBU;wRegAddr=rd;readrtEn=1;readrsEn=1;	
					end
				endcase//func
			end//spec2
			`OP_SPEC:begin 
				casez(inst[25:0])
					26'b1000_0000_0000_0000_0000_001000:opcode=`OPC_TLBP;
					26'b1000_0000_0000_0000_0000_000010:opcode=`OPC_TLBWI;
					26'b1000_0000_0000_0000_0000_000001:opcode=`OPC_TLBR;
					26'b1000_0000_0000_0000_0000_000110:opcode=`OPC_TLBWR;
					26'b1???_????_????_????_????_100000:opcode=`OPC_SLL;
					26'b0010_0???_????_???0_0000_000???:begin 
						opcode=`OPC_MTC0;wRegAddr=rt;readrtEn=1;
					end
					26'b0000_0???_????_???0_0000_000???:begin 
						opcode=`OPC_MFC0;wRegAddr=rt;readrtEn=1;wRegEn=1;
					end
					26'b1000_0000_0000_0000_0000_011000:begin 
						op3=32'b0;opcode=`OPC_ERET;
					end
				endcase
			end
			`OP_J:begin 
				op3=j_pc;opcode=`OPC_J;wRegAddr=rd;
			end
			`OP_JAL:begin 
				op3=j_pc;opcode=`OPC_JAL;wRegAddr=5'd31;wRegEn=1;
			end
			`OP_BNE:begin 
				op3=b_pc;opcode=`OPC_BNE;wRegAddr=5'd0;readrsEn=1;readrtEn=1;
			end
			`OP_BLEZ:begin 
				op3=b_pc;opcode=`OPC_BLEZ;wRegAddr=5'd0;readrsEn=1;
			end
			`OP_BGTZ:begin 
				op3=b_pc;opcode=`OPC_BGTZ;wRegAddr=5'd0;readrsEn=1;
			end			
			`OP_BEQ:begin 
				op3=b_pc;opcode=`OPC_BEQ;wRegAddr=5'd0;readrsEn=1;readrtEn=1;
			end
			`OP_REGIMM:begin 
				case(rt)
					`OP_BLTZAL:begin 
						op3=b_pc;opcode=`OPC_BLTZAL;wRegAddr=5'd31;wRegEn=1;readrsEn=1;
					end
					`OP_BGEZAL:begin 
						op3=b_pc;opcode=`OPC_BGEZAL;wRegAddr=5'd31;wRegEn=1;readrsEn=1;
					end
					`OP_BLTZ:begin 
						op3=b_pc;opcode=`OPC_BLTZ;wRegAddr=5'd0;readrsEn=1;
					end
					`OP_BGEZ:begin 
						op3=b_pc;opcode=`OPC_BGEZ;wRegAddr=5'd0;readrsEn=1;
					end		
				endcase		
			end
			`OP_CACHE:begin 
				opcode=`OPC_SLL;
				// case(rt)
				// 	`FUNC_I_IndexValid:begin 
				// 		opcode=`OPC_I_IndexValid;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end
				// 	`FUNC_I_IndexStoreTag:begin 
				// 		opcode=`OPC_I_IndexStoreTag;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end
				// 	`FUNC_I_HitInvalid:begin 
				// 		opcode=`OPC_I_HitInvalid;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end
				// 	`FUNC_D_IndexWbInvalid :begin 
				// 		opcode=`OPC_D_IndexWbInvalid;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end 
				// 	`FUNC_D_IndexStoreTag :begin 
				// 		opcode=`OPC_D_IndexStoreTag;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end 
				// 	`FUNC_D_IndexHitValid  :begin 
				// 		opcode=`OPC_D_IndexHitValid;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end
				// 	`FUNC_D_HitWbInvalid :begin 
				// 		opcode=`OPC_D_HitWbInvalid;op3={{16{imm[15]}},imm};readrsEn=1;
				// 	end
				// endcase	
			end
			`OP_PREF:begin 
				opcode=`OPC_SLL;
			end
			`OP_COP1,`OP_COP1X,`OP_SWC1,`OP_LDC1,`OP_SDC1,`OP_LWC1:begin 
				if(inst==32'h45df00e0) opcode=`OPC_RESV;//func test use a instr of cop1
				else opcode=`OPC_COP_U;
			end
		endcase
	end
end


endmodule