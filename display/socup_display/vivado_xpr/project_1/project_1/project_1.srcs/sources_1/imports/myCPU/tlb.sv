`include "define.svh"
module tlb_translate (
	input clk,    // Clock
	input aresetn,
	input [31:0] iaddr_v,
	input [31:0] daddr_v,
	input [`TLB_INDEX-1:0] Index,
	input [31:0] EntryHi,
	input [31:0] EntryLo0,
	input [31:0] EntryLo1,
	input [31:0] PageMask,
	input tlbwr,
	input tlbwi,
	input [`TLB_INDEX-1:0]tlbwrIndex,
	input memEn,
	output logic [`TLB_INDEX:0] pmeetIndex,
	output logic [31:0] wEntryHi,
	output logic [31:0] wEntryLo1,
	output logic [31:0] wEntryLo0,
	output logic [31:0] wPageMask,
	output logic [31:0] iaddr_p,
	output logic istall,
	output logic [31:0] daddr_p,
	output logic dstall,
	output logic dvalid,
	output logic ivalid,
	output logic icached,
	output logic dcached,
	output logic dwunable,
	output logic imiss,
	output logic dmiss
	);

typedef struct packed {
logic [18:0] vpn2;
logic [7:0] asid;
logic g;
logic [11:0] pagemask;
logic [19:0] pfn0;
logic [4:0] cdv0;
logic [19:0] pfn1;
logic [4:0] cdv1;
}TLB;

TLB tlb_arr[0:`TLB_NUM-1];
TLB ibuffer;
TLB dbuffer;

logic i_inbuffer;
logic d_inbuffer;
logic [31:0] iaddr_buf_p;
logic ivalid_buf;
logic icached_buf;
logic [31:0] daddr_buf_p;
logic dwunable_buf;
logic dvalid_buf;
logic dcached_buf;
logic [`TLB_NUM-1:0] imeet; 
logic [3:0] imeetIndex;
logic [31:0] pmeet;
logic [`TLB_NUM-1:0] dmeet; 
logic [3:0] dmeetIndex;

always_comb begin : proc_i_map
	if(iaddr_v[31:30]==2'b10) begin 
		iaddr_p={3'b0,iaddr_v[28:0]};
		ivalid=1;
		if(iaddr_v[29]) icached=0;else icached=1;
		imiss=0;
	end else begin 
		iaddr_p=iaddr_buf_p;
		ivalid=ivalid_buf;
		icached=icached_buf;
		if(i_inbuffer) imiss=0;else imiss=1;
	end 
end

always_comb begin : proc_d_map
	if(daddr_v[31:30]==2'b10) begin  
		daddr_p={3'b0,daddr_v[28:0]};
		dvalid=1;
		if(daddr_v[29]) dcached=0; else dcached=1;
		dwunable=0;
		dmiss=0;
	end else begin 
		daddr_p=daddr_buf_p;
		dvalid=dvalid_buf;
		dcached=dcached_buf;
		dwunable=dwunable_buf;
		if(d_inbuffer)dmiss=0;else dmiss=1;
	end	
end

logic istate;
logic nextistate;
logic dstate;
logic nextdstate;

always_ff @(posedge clk) begin : proc_state
	if(~aresetn) begin
		istate <= 0;
		dstate<=0;
	end else begin
		istate <= nextistate;
		dstate<=nextdstate;
	end
end

always_comb begin : proc_state_stall_i
	case(istate)
		1'b0:begin 
			if(iaddr_v[31:30]==2'b10) begin 
				nextistate=1'b0;
				istall=0;
			end else if(i_inbuffer) begin 
				nextistate=1'b0;
				istall=0;
			end else begin 
				nextistate=1'b1;
				istall=1;
			end
		end
		1'b1:begin 
			nextistate=1'b0;
			istall=0;
		end
	endcase // istate
end

always_comb begin : proc_state_stall_d
	case(dstate)
		1'b0:begin 
			if((daddr_v[31:30]==2'b10)|~memEn) begin 
				nextdstate=1'b0;
				dstall=0;
			end else if(d_inbuffer) begin 
				nextdstate=1'b0;
				dstall=0;
			end else begin 
				nextdstate=1'b1;
				dstall=1;
			end
		end
		1'b1:begin 
			nextdstate=1'b0;
			dstall=0;
		end
	endcase // dstate
end

always_comb begin : proc_tlbr 
	wEntryLo0={6'b0,tlb_arr[Index].pfn0,tlb_arr[Index].cdv0,tlb_arr[Index].g};
	wEntryLo1={6'b0,tlb_arr[Index].pfn1,tlb_arr[Index].cdv1,tlb_arr[Index].g};
	wEntryHi={tlb_arr[Index].vpn2,5'b0,tlb_arr[Index].asid};
	wPageMask={7'b0,tlb_arr[Index].pagemask,13'b0};
end

always_ff @(posedge clk) begin
	if(tlbwi) begin 
		tlb_arr[Index]<={EntryHi[31:13],EntryHi[7:0],EntryLo1[0]&EntryLo0[0],PageMask[24:13],EntryLo0[25:6],EntryLo0[5:1],EntryLo1[25:6],EntryLo1[5:1]};
	end else if(tlbwr) begin 
		tlb_arr[tlbwrIndex]<={EntryHi[31:13],EntryHi[7:0],EntryLo1[0]&EntryLo0[0],PageMask[24:13],EntryLo0[25:6],EntryLo0[5:1],EntryLo1[25:6],EntryLo1[5:1]};
	end
end

always_ff @(posedge clk) begin
	if((nextistate==1'b1)&(~imeetIndex[3])) ibuffer<=tlb_arr[imeetIndex];
	else if(tlbwi|tlbwr) ibuffer<={EntryHi[31:13],EntryHi[7:0],EntryLo1[0]&EntryLo0[0],PageMask[24:13],EntryLo0[25:6],EntryLo0[5:1],EntryLo1[25:6],EntryLo1[5:1]};
	if((nextdstate==1'b1)&(~dmeetIndex[3])) dbuffer<=tlb_arr[dmeetIndex];
	else if(tlbwi|tlbwr) dbuffer<={EntryHi[31:13],EntryHi[7:0],EntryLo1[0]&EntryLo0[0],PageMask[24:13],EntryLo0[25:6],EntryLo0[5:1],EntryLo1[25:6],EntryLo1[5:1]};
end

always_comb begin : proc_find_tlbp
	for(int i=0;i<`TLB_NUM;i++) begin 
		pmeet[i]=((tlb_arr[i].vpn2==EntryHi[31:13])&(tlb_arr[i].g|tlb_arr[i].asid==EntryHi[7:0]));
	end
end

always_comb begin : proc_tlb_get_p
	pmeetIndex=4'd8;
	for(int i=0;i<`TLB_NUM;i++) begin 
		if(pmeet[i]) pmeetIndex=i;
	end
end

always_comb begin : proc_compare_buffer_i
	//for 4K page, no mask and
	case(iaddr_v[12]) 
		1'b1:begin 
			iaddr_buf_p={ibuffer.pfn1,iaddr_v[11:0]};
			if(ibuffer.cdv1[4:2]==3'd3) icached_buf=1'b1;else icached_buf=1'b0;
			ivalid_buf=ibuffer.cdv1[0];		
		end
		default: begin 
			iaddr_buf_p={ibuffer.pfn0,iaddr_v[11:0]};
			if(ibuffer.cdv0[4:2]==3'd3) icached_buf=1'b1;else icached_buf=1'b0;
			ivalid_buf=ibuffer.cdv0[0];
		end
	endcase
	if((ibuffer.vpn2==iaddr_v[31:13])&(ibuffer.g|ibuffer.asid==EntryHi[7:0])) begin 
		i_inbuffer=1;
	end else begin 
		i_inbuffer=0;
	end
end

always_comb begin : proc_compare_buffer_d
	//for 4K page, no mask and
	case(daddr_v[12]) 
		1'b1:begin 
			daddr_buf_p={dbuffer.pfn1,daddr_v[11:0]};
			if(dbuffer.cdv1[4:2]==3'd3) dcached_buf=1'b1;else dcached_buf=1'b0;//for test
			dvalid_buf=dbuffer.cdv1[0];	
			dwunable_buf=~dbuffer.cdv1[1];	
		end
		default: begin 
			daddr_buf_p={dbuffer.pfn0,daddr_v[11:0]};
			if(dbuffer.cdv0[4:2]==3'd3) dcached_buf=1'b1;else dcached_buf=1'b0;//for test
			dvalid_buf=dbuffer.cdv0[0];
			dwunable_buf=~dbuffer.cdv0[1];
		end
	endcase
	if((dbuffer.vpn2==daddr_v[31:13])&(dbuffer.g|(dbuffer.asid==EntryHi[7:0]))) begin 
		d_inbuffer=1;
	end else begin 
		d_inbuffer=0;
	end
end


always_comb begin : proc_tlb_search_i
	for(int i=0;i<`TLB_NUM;i++) begin 
		imeet[i]=((tlb_arr[i].vpn2==iaddr_v[31:13])&(tlb_arr[i].g|(tlb_arr[i].asid==EntryHi[7:0])));
	end
end

always_comb begin : proc_tlb_get_i
	imeetIndex=4'd8;
	for(int i=0;i<`TLB_NUM;i++)begin 
		if(imeet[i]) imeetIndex=i;
	end
end

always_comb begin : proc_tlb_search_d
	for(int i=0;i<`TLB_NUM;i++) begin 
		//dmeet[i]=(((tlb_arr[i].vpn2&(~tlb_arr[i].pagemask[31:13]))==(daddr_v[31:13]&(~tlb_arr[i].pagemask[31:13])))&(tlb_arr[i].g|tlb_arr[i].asid==EntryHi[7:0]));
		dmeet[i]=((tlb_arr[i].vpn2==daddr_v[31:13])&(tlb_arr[i].g|(tlb_arr[i].asid==EntryHi[7:0])));
	end
end

always_comb begin : proc_tlb_get_d
	dmeetIndex=4'd8;
	for(int i=0;i<`TLB_NUM;i++)begin 
		if(dmeet[i]) dmeetIndex=i;
	end
end

// always_ff @(posedge clk) begin
// 	if(~aresetn) begin
// 		iaddr_p<=32'b0;
// 		ivalid<=1'b0;
// 		icached<=1'b0;
// 		imiss<=0;
// 	end else begin
// 		if(imeetIndex[`TLB_INDEX]) imiss<=1;
// 		else begin 
// 			imiss<=0;
// 			case(iaddr_v[12]) 
// 				1'b1:begin 
// 					iaddr_p<={tlb_arr[imeetIndex].pfn1,iaddr_v[11:0]};
// 					if(tlb_arr[imeetIndex].cdv1[4:2]==3'd3) icached<=1'b1;else icached<=1'b0;//for test
// 					ivalid<=tlb_arr[imeetIndex].cdv1[0];		
// 				end
// 				default: begin 
// 					iaddr_p<={tlb_arr[imeetIndex].pfn0,iaddr_v[11:0]};
// 					if(tlb_arr[imeetIndex].cdv0[4:2]==3'd3) icached<=1'b1;else icached<=1'b0;//for test
// 					ivalid<=tlb_arr[imeetIndex].cdv0[0];
// 				end
// 			endcase
// 		end
// 	end
// end


// always_ff @(posedge clk) begin
// 	if(~aresetn) begin
// 		daddr_p<=32'b0;
// 		dvalid<=1'b0;
// 		dcached<=1'b0;
// 		dmiss<=0;
// 	end else begin
// 		if(dmeetIndex[`TLB_INDEX]) begin 
// 			dmiss<=1;
// 		end
// 		else begin
// 			dmiss<=0; 
// 			case(daddr_v[12]) 
// 				1'b1:begin 
// 					daddr_p<={tlb_arr[dmeetIndex].pfn1,daddr_v[11:0]};
// 					if(tlb_arr[dmeetIndex].cdv1[4:2]==3'd3) dcached<=1'b1;else dcached<=1'b0;
// 					dvalid<=tlb_arr[dmeetIndex].cdv1[0];	
// 					dwunable<=tlb_arr[dmeetIndex].cdv1[1];
// 				end
// 				default: begin 
// 					daddr_p<={tlb_arr[dmeetIndex].pfn0,daddr_v[11:0]};
// 					if(tlb_arr[dmeetIndex].cdv0[4:2]==3'd3) dcached<=1'b1;else dcached<=1'b0;
// 					dvalid<=tlb_arr[dmeetIndex].cdv0[0];
// 					dwunable<=tlb_arr[dmeetIndex].cdv0[1];
// 				end
// 			endcase
// 		end
// 	end
// end


endmodule