module exception (
	input clk,    // Clock
	input aresetn,
	input [5:0] hwint,
	input bd,
	input [12:0] excep,
	input instAddrErr,
	input [31:0] pc,
	input [31:0] pro_wCP0Data,
	input [4:0] pro_wCP0Addr,
	input [2:0] pro_sel,
	input pro_wCP0En,
	input [4:0] rCP0Addr,
	input [2:0] rCP0Sel,
	input [31:0] aluAns,
	input [3:0] tlb,
	input [`TLB_INDEX:0] wIndex,
	input [31:0] wEntryHi,
	input [31:0] wEntryLo1,
	input [31:0] wEntryLo0,	
	input [31:0] wPageMask,
	input [31:0] first_pc,
	input bubble,
	output logic flush,
	output logic [31:0] CP0reg,
	output logic [31:0] flushpc,
	output logic [31:0] EntryHi,
	output logic [31:0] EntryLo0,
	output logic [31:0] EntryLo1,
	output logic [31:0] PageMask,
	output logic [`TLB_INDEX-1:0] Index,
	output logic flush_int,
	output logic [`TLB_INDEX-1:0] tlbwrIndex
	);
logic [31:0] CP0[0:30];
/**********
Index 0
Random 1
EntryLo0-1, 2-3
Context 4
PageMask, 5
Wired, 6
badVAddr,8
count,9
EntryHi,10
Compare, 11
status12,
cause,13
epc,14
PRId, 15
Config, 16
ErrorEPC, 30
********/
logic [31:0] CP0_1[15:17];
/********
17:Config1
15:ebase
********/
logic IsExcep;
assign IsExcep=|excep;
logic eret;
logic rAddrErr;
logic resvInst;
logic ovfl;
logic brk;
logic wAddrErr;
logic tlb_rmiss;
logic tlb_wmiss;
logic tlb_rinvalid;
logic tlb_winvalid;
logic tlb_dmodified;
logic copU;
logic [31:0] EntryHi_f;
logic [31:0] EntryLo0_f;
logic [31:0] EntryLo1_f;
logic [31:0] Index_f;
logic [31:0] PageMask_f;

assign tlb_rmiss=excep[12];
assign tlb_wmiss=excep[11];
assign tlb_rinvalid=excep[10];
assign tlb_winvalid=excep[9];
assign tlb_modified=excep[8];
assign eret=excep[6];
assign rAddrErr=excep[5];
assign resvInst=excep[4];
assign ovfl=excep[3];
assign brk=excep[2];
assign sysc=excep[1];
assign wAddrErr=excep[0];
assign copU=excep[7];
logic [31:0] errAddr;
assign errAddr=instAddrErr?pc:aluAns;
logic count;
logic timer_int;
logic [`TLB_INDEX-1:0]next_random;
assign next_random=CP0[1][`TLB_INDEX-1:0]+1'b1;
assign tlbwrIndex=CP0[1][`TLB_INDEX-1:0];

always_ff @(posedge clk) begin
	if(count) CP0[9]<=CP0[9]+1;
	if(~aresetn) begin
		CP0_1[16]<={1'b0,6'd7,3'd2,3'd4,3'd1,3'd2,3'd4,3'd1,7'b0};//may change
		CP0_1[15]<=32'h8000_0000;
		CP0[16]<={1'b1,28'b0,3'd3};
		CP0[15]<=32'h00004220;
		CP0[13]<=32'b0;
		CP0[12] <= {9'b0,1'b1,22'b0};
		CP0[10][12:8]<=5'b0;
		//CP0[9]<=32'b0;
		CP0[6]<=32'b0;
		CP0[5][12:0]<=13'b0;
		CP0[5][31:25]<=7'b0;
		CP0[4][3:0]<=4'b0;
		CP0[3][31:26]<=6'b0;
		CP0[2][31:26]<=6'b0;
		CP0[1][`TLB_INDEX-1:0]<=`TLB_NUM-1;
		CP0[0][31]<=1'b0;
		CP0[0][30:`TLB_INDEX]<=26'b0;
	end else if(~bubble) begin
		CP0[13][14:10]<=hwint[4:0];
		CP0[13][15]<=hwint[5]|timer_int;
		CP0[13][30]<=timer_int;
		if((CP0[12][0]&(~CP0[12][1]))&((CP0[13][8]&CP0[12][8])|(CP0[13][9]&CP0[12][9])|(CP0[12][10]&CP0[13][10])|(CP0[12][11]&CP0[13][11])|(CP0[12][12]&CP0[13][12])|(CP0[12][13]&CP0[13][13])|(CP0[12][14]&CP0[13][14])|(CP0[12][15]&CP0[13][15])))
		begin
			CP0[13][6:2] <= 5'b0;
			CP0[12][1]   <= 1;
			CP0[14]     <= first_pc;
		end
		else if (IsExcep) begin
			if(eret) CP0[12][1]<=0;
			else begin
				if (~CP0[12][1])begin
					CP0[12][1] <= 1;
					if (bd) begin
						CP0[14]     <= pc-4;
						CP0[13][31] <= 1;
					end
					else  begin
						CP0[14]     <= pc;
						CP0[13][31] <= 0;
					end
				end//end cpu0[12][1]
				if(tlb_rmiss|tlb_rinvalid) begin
					CP0[13][6:2] <=5'h2;
					CP0[8]<=errAddr;
					CP0[10][31:12]<=errAddr[31:12];
					CP0[4][22:4]<=errAddr[31:11];
				end else if(tlb_wmiss|tlb_winvalid) begin 
					CP0[13][6:2] <=5'h3;
					CP0[8]<=errAddr;
					CP0[10][31:12]<=errAddr[31:12];
					CP0[4][22:4]<=errAddr[31:11];
				end else if(tlb_modified) begin 
					CP0[13][6:2] <=5'h1;
					CP0[8]<=errAddr;
					CP0[10][31:12]<=errAddr[31:12];
					CP0[4][22:4]<=errAddr[31:11];
				end else if (rAddrErr) begin
					CP0[8]<=errAddr;
					CP0[13][6:2] <= 5'h4;
				end else if (resvInst) begin
					CP0[13][6:2] <= 5'ha;
				end else if (ovfl) begin
					CP0[13][6:2] <= 5'hc;
				end else if (brk) begin
					CP0[13][6:2] <= 5'h9;
				end else if (sysc) begin
					CP0[13][6:2] <= 5'h8;
				end else if (wAddrErr) begin
					CP0[8]       <= errAddr;
					CP0[13][6:2] <= 5'h5;
				end else if (copU) begin 
					CP0[8] <=errAddr;
					CP0[13][6:2]<=5'hb;
					CP0[13][29:28]<=2'd1;//only cop1
				end
		end//excep	
	end
	else if(pro_wCP0En) begin
		case (pro_sel)
			3'b0:begin 
				case(pro_wCP0Addr)
					5'd10:CP0[pro_wCP0Addr]<={pro_wCP0Data[31:13],5'b0,pro_wCP0Data[7:0]};
					5'd5:CP0[pro_wCP0Addr]<={7'b0,pro_wCP0Data[24:13],13'b0};
					5'd2,5'd3:CP0[pro_wCP0Addr]<={6'b0,pro_wCP0Data[25:0]};
					5'd0:CP0[pro_wCP0Addr][`TLB_INDEX-1:0]<=pro_wCP0Data[`TLB_INDEX-1:0];
					5'd13:begin 
						CP0[pro_wCP0Addr][23]<=pro_wCP0Data[23];
						CP0[pro_wCP0Addr][9:8]<=pro_wCP0Data[9:8];
					end
					5'd16:CP0[pro_wCP0Addr][2:0]<=pro_wCP0Data[2:0];
					5'd4:CP0[pro_wCP0Addr][31:23]<=pro_wCP0Data[31:23];
					5'd12:CP0[pro_wCP0Addr]<={3'b0,pro_wCP0Data[28],5'd0,pro_wCP0Data[22],6'd0,pro_wCP0Data[15:8],3'd0,pro_wCP0Data[4],2'b0,pro_wCP0Data[1:0]};
					5'd6:begin
						CP0[pro_wCP0Addr][`TLB_INDEX-1:0]<=pro_wCP0Data[`TLB_INDEX-1:0];
						CP0[1][`TLB_INDEX-1:0]<=`TLB_NUM-1;
					end
					default:CP0[pro_wCP0Addr]<=pro_wCP0Data;
				endcase
			end
			3'b1:begin 
				case (pro_wCP0Addr)
					5'd15:CP0_1[pro_wCP0Addr][29:12]<=pro_wCP0Data[29:12];
				endcase
			end
		endcase
	end 
	else if(tlb[1]) begin 
		CP0[10]<=wEntryHi;
		CP0[2]<=wEntryLo0;
		CP0[3]<=wEntryLo1;
		CP0[5]<=wPageMask;
	end else if(tlb[0]) begin 
		if(wIndex[`TLB_INDEX]) CP0[0][31]<=1;
		else CP0[0][`TLB_INDEX-1:0]<=wIndex[`TLB_INDEX-1:0];
	end else if(tlb[3]) begin 
		CP0[1][`TLB_INDEX-1:0]<=next_random<CP0[6][`TLB_INDEX-1:0]?CP0[6][`TLB_INDEX-1:0]:next_random;
	end
end
end

always_comb begin
	if (~aresetn|bubble) begin
		flush = 0;
		flush_int=0;
	end else
	if ((CP0[12][0]&(~CP0[12][1]))&((CP0[13][8]&CP0[12][8])| (CP0[13][9]&CP0[12][9])|(CP0[12][10]&CP0[13][10])|(CP0[12][11]&CP0[13][11])|(CP0[12][12]&CP0[13][12])|(CP0[12][13]&CP0[13][13])|(CP0[12][14]&CP0[13][14])|(CP0[12][15]&CP0[13][15]))) begin 
		flush=1;
		flush_int=1;
	end
	else if (|excep) begin 
		flush=1;
		flush_int=0;
	end 
	else begin 
		flush=0;
		flush_int=0;
	end
end

always_comb begin : read_CP0
	case(rCP0Sel)
		3'b0:begin 
			case(rCP0Addr)
				5'd10:CP0reg=EntryHi_f;
				5'd2:CP0reg=EntryLo0_f;
				5'd3:CP0reg=EntryLo1_f;
				5'd0:CP0reg=Index_f;
				5'd5:CP0reg=PageMask_f;
				5'd13:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b0))?{CP0[rCP0Addr][31:24],pro_wCP0Data[23],CP0[rCP0Addr][22:10],pro_wCP0Data[9:8],CP0[rCP0Addr][7:0]}:CP0[rCP0Addr];
				5'd12:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b0))?{3'b0,pro_wCP0Data[28],5'd0,pro_wCP0Data[22],6'd0,pro_wCP0Data[15:8],3'd0,pro_wCP0Data[4],2'b0,pro_wCP0Data[1:0]}:CP0[rCP0Addr];
				5'd4:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b0))?{pro_wCP0Data[31:23],CP0[rCP0Addr][22:0]}:CP0[rCP0Addr];
				5'd16:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b0))?{pro_wCP0Data[31:23],CP0[rCP0Addr][22:0]}:CP0[rCP0Addr];
				default:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b0))?pro_wCP0Data:CP0[rCP0Addr];
			endcase // rCP0Addr
		end
		3'b1:begin 
			case (rCP0Addr)
				5'd15:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b1))?{2'b10,pro_wCP0Data[29:12],12'b0}:CP0_1[rCP0Addr];
				default:CP0reg=((pro_wCP0Addr==rCP0Addr)&pro_wCP0En&(pro_sel==3'b1))?pro_wCP0Data:CP0_1[rCP0Addr];
			endcase
		end
		default:CP0reg=32'b0;
	endcase // rCP0Addr
end

always_comb begin : proc_rEntryHi
	EntryHi_f=CP0[10];
	if((pro_wCP0Addr==5'd10)&pro_wCP0En&(pro_sel==3'b0)) EntryHi_f={pro_wCP0Data[31:13],5'b0,pro_wCP0Data[7:0]};
	else if(tlb[1]) EntryHi_f={wEntryHi[31:13],5'b0,wEntryHi[7:0]};
end

always_comb begin : proc_rEntryLo0
	EntryLo0_f=CP0[2];
	if((pro_wCP0Addr==5'd2)&pro_wCP0En&(pro_sel==3'b0)) EntryLo0_f={6'b0,pro_wCP0Data[25:0]};
	else if(tlb[1]) EntryLo0_f={6'b0,wEntryLo0[25:0]};
end

always_comb begin : proc_rEntryLo1
	EntryLo1_f=CP0[3];
	if((pro_wCP0Addr==5'd3)&pro_wCP0En&(pro_sel==3'b0)) EntryLo1_f={6'b0,pro_wCP0Data[25:0]};
	else if(tlb[1]) EntryLo1_f={6'b0,wEntryLo1[25:0]};
end

always_comb begin : proc_rIndex
	Index_f=CP0[0];
	if((pro_wCP0Addr==5'd0)&pro_wCP0En&(pro_sel==3'b0)) Index_f={CP0[0][31:`TLB_INDEX],pro_wCP0Data[`TLB_INDEX-1:0]};
	else if(tlb[1]) Index_f={CP0[0][31:`TLB_INDEX],wIndex[`TLB_INDEX-1:0]};
	else if(tlb[0]) Index_f=(wIndex[`TLB_INDEX])?{1'b1,CP0[0][30:0]}:{CP0[0][31:`TLB_INDEX],wIndex[`TLB_INDEX-1:0]};
end

always_comb begin : proc_pagemask
	PageMask_f=CP0[5];
	if((pro_wCP0Addr==5'd5)&pro_wCP0En&(pro_sel==3'b0)) PageMask_f={7'b0,pro_wCP0Data[24:13],13'b0};
	else if(tlb[1]) PageMask_f={7'b0,wPageMask[24:13],13'b0};
end

always_comb begin :read_epc
	if(excep[6])begin //eret
		if((pro_wCP0Addr==5'd14)&pro_wCP0En&(pro_sel==3'b0)) flushpc=pro_wCP0Data;
		else flushpc=CP0[14];		
	end 
	else if(CP0[12][22])begin 
		if(tlb_wmiss|tlb_rmiss)begin 
			flushpc=32'hbfc00200;
		end else flushpc=32'hbfc00380;
	end else begin 
		if(tlb_wmiss|tlb_rmiss) begin 
			flushpc={CP0_1[15][31:12],12'b0};
		end else begin 
			flushpc={CP0_1[15][31:12],12'b0}+32'h180;
		end
	end
end

assign EntryHi=((pro_wCP0Addr==5'd10)&pro_wCP0En&(pro_sel==3'b0))?{pro_wCP0Data[31:13],5'b0,pro_wCP0Data[7:0]}:CP0[10];
assign EntryLo0=((pro_wCP0Addr==5'd2)&pro_wCP0En&(pro_sel==3'b0))?{6'b0,pro_wCP0Data[25:0]}:CP0[2];
assign EntryLo1=((pro_wCP0Addr==5'd3)&pro_wCP0En&(pro_sel==3'b0))?{6'b0,pro_wCP0Data[25:0]}:CP0[3];
assign Index=((pro_wCP0Addr==5'd0)&pro_wCP0En&(pro_sel==3'b0))?{CP0[0][31:`TLB_INDEX],pro_wCP0Data[`TLB_INDEX-1:0]}:CP0[0];
assign PageMask=((pro_wCP0Addr==5'd5)&pro_wCP0En&(pro_sel==3'b0))?{7'b0,pro_wCP0Data[24:13],13'b0}:CP0[5];

always_ff @(posedge clk) begin : proc_count
	if(~aresetn) begin
		count <= 0;
	end else begin
		count <= ~count;
	end
end

always_ff @(posedge clk) begin
	if(~aresetn) begin
		timer_int <= 0;
	end else begin
		if((pro_wCP0Addr==5'd11)&pro_wCP0En&(pro_sel==3'd0)) timer_int<= 1'b0;
		else if(CP0[9]==CP0[11]) timer_int<=1'b1;
	end
end

endmodule