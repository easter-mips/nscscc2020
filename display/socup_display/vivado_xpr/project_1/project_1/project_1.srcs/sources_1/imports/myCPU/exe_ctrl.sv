//output ex result to mem;
//output branch result to if and id
//both pro and lite
//deal with excep
module exe_ctrl (
	input clk,    // Clock
	input aresetn, 

	input flush,
	input stall,
	input reverse,

	input [31:0] lite_pc,
	input [31:0] lite_aluAns,
	input lite_wRegEn,
	input [4:0] lite_wRegAddr,
	input [6:0] lite_excep,
	input lite_instAddrErr,
	input lite_bd,
	input [1:0] lite_iexcep,
	input lite_bubble,

	input [31:0] pro_pc,
	input [31:0] pro_aluAns,
	input pro_wRegEn,
	input [4:0] pro_wRegAddr,
	input [6:0] pro_excep,
	input pro_instAddrErr,
	input pro_bd,
	input [1:0] pro_iexcep,

	input [31:0] pro_wHiData,
	input [31:0] pro_wLoData,
	input pro_wHiEn,
	input pro_wLoEn,
	input [31:0] pro_wCP0Data,
	input [4:0] pro_wCP0Addr,
	input [2:0] pro_sel,
	input pro_wCP0En,
	
	input [31:0] pro_wdata,
	input [3:0] pro_wstrb,
	input [ 2:0]pro_wsize,	
	input pro_memEn,
	input pro_rwmem,
	input [ 2:0]pro_rsize,
	input [31:0]pro_addr,	
	input [1:0] pro_left_right,
	input [31:0] pro_rtReg,
	input pro_signExt,	
	input [31:0] addr_p,
	input [3:0] tlb,
	input dmiss,
	input dvalid,
	input dwunable,
	input dcached,
	input pro_bubble,
	input copU,

	//input [4:0] cacheInst,
	output logic ex_mem_reverse,
	output logic [31:0] ex_mem_lite_wRegData,
	output logic ex_mem_lite_wRegEn,
	output logic [4:0] ex_mem_lite_wRegAddr,
	output logic [31:0] ex_mem_lite_pc,
	output logic [31:0] ex_mem_pro_pc,
	output logic [31:0] ex_mem_pro_aluAns,
	output logic ex_mem_pro_wRegEn,
	output logic [4:0] ex_mem_pro_wRegAddr,
	output logic [31:0] ex_mem_pro_wHiData,
	output logic [31:0] ex_mem_pro_wLoData,
	output logic ex_mem_pro_wHiEn,
	output logic ex_mem_pro_wLoEn,
	output logic [31:0] ex_mem_pro_wCP0Data,
	output logic [4:0] ex_mem_pro_wCP0Addr,
	output logic [2:0] ex_mem_pro_sel,
	output logic ex_mem_pro_wCP0En,
	output logic [31:0] ex_mem_pro_wdata,
	output logic [31:0] ex_mem_pro_addr,
	output logic [3:0] ex_mem_pro_wstrb,
	output logic [ 2:0]ex_mem_pro_wsize,	
	output logic ex_mem_pro_memEn_uncached,
	output logic ex_mem_pro_memEn_cached,
	output logic ex_mem_pro_rwmem,
	output logic [ 2:0]ex_mem_pro_rsize,	
	output logic [1:0]ex_mem_pro_left_right,
	output logic [31:0]ex_mem_pro_rtReg,
	output logic ex_mem_pro_signExt,
	output logic bd,
	output logic [31:0] pc,
	output logic [12:0] excep,
	output logic instAddrErr,
	output logic ex_mem_pro_cached,
	output logic [3:0] ex_mem_pro_tlb,
	//output logic [4:0]ex_mem_cacheInst,
	output logic [31:0] ex_excep_first_pc,
	output logic ex_excep_bubble
);

logic [12:0] ex_pro_excep;
logic [12:0] ex_lite_excep;
logic ex_pro_IsExcep;
logic ex_lite_IsExcep;
assign ex_pro_IsExcep=|ex_pro_excep;
assign ex_lite_IsExcep=|ex_lite_excep;
logic wen;
assign wen=pro_memEn&(~pro_rwmem);
//rmiss,wmiss,rinvalid,winvalid,modified
assign ex_pro_excep={pro_iexcep[1]|(dmiss&pro_rwmem),dmiss&wen,~pro_iexcep[0]|(~dvalid&pro_rwmem),~dvalid&wen,wen&dwunable,copU,pro_excep};
assign ex_lite_excep={lite_iexcep[1],1'b0,~lite_iexcep[0],1'b0,1'b0,lite_excep};
always_ff @(posedge clk) begin
	if(~aresetn|flush) begin
		excep<=12'b0;
		instAddrErr<=0;
		ex_mem_lite_wRegEn<=0;
		ex_mem_pro_wRegEn<=1'b0;
		ex_mem_pro_wHiEn<=0;
		ex_mem_pro_wLoEn<=0;
		ex_mem_pro_wCP0En<=0;
		ex_mem_pro_memEn_uncached<=0;
		ex_mem_pro_memEn_cached<=0;	
		//ex_mem_cacheInst<=5'd0;
		ex_mem_pro_tlb<=0;
		ex_excep_bubble<=1;
		ex_excep_first_pc<=32'b0;
	end else if(stall) begin 
	end else begin 
		case({reverse,ex_pro_IsExcep,ex_lite_IsExcep})
			3'b010,3'b011:begin //no lite, no pro En ,only pro excep
				excep<=ex_pro_excep;
				instAddrErr<=pro_instAddrErr|(~pro_iexcep[0])|pro_iexcep[1];
				pc<=pro_pc;
				bd<=pro_bd;
				ex_mem_lite_wRegEn<=0;
				ex_mem_pro_wRegEn<=1'b0;
				ex_mem_pro_wHiEn<=0;
				ex_mem_pro_wLoEn<=0;
				ex_mem_pro_wCP0En<=0;
				ex_mem_pro_memEn_uncached<=0;	
				ex_mem_pro_memEn_cached<=0;	
				ex_mem_pro_tlb<=0;
				//ex_mem_cacheInst<=5'b0;
				ex_excep_first_pc<=pro_pc;
				ex_excep_bubble<=0;
			end
			3'b001:begin //pro, lite excep
				excep<=ex_lite_excep;
				instAddrErr<=lite_instAddrErr|(~lite_iexcep[0])|lite_iexcep[1];
				pc<=lite_pc;
				bd<=lite_bd;
				ex_mem_lite_wRegEn<=0;
				ex_mem_pro_wRegEn<=pro_wRegEn;
				ex_mem_pro_wHiEn<=pro_wHiEn;
				ex_mem_pro_wLoEn<=pro_wLoEn;
				ex_mem_pro_wCP0En<=0;
				// if(|cacheInst) ex_mem_pro_memEn_uncached<=0;else ex_mem_pro_memEn_uncached<=pro_memEn&(~dcached);	
				// if(|cacheInst) ex_mem_pro_memEn_cached<=0;else ex_mem_pro_memEn_cached<=pro_memEn&dcached;
				ex_mem_pro_memEn_uncached<=pro_memEn&(~dcached);
				ex_mem_pro_memEn_cached<=pro_memEn&dcached;	
				ex_mem_pro_tlb<=tlb;
				//ex_mem_cacheInst<=cacheInst;	
				ex_excep_first_pc<=pro_pc;
				ex_excep_bubble<=0;
			end
			3'b101,3'b111:begin //no pro, lite excep
				excep<=ex_lite_excep;
				instAddrErr<=lite_instAddrErr|(~lite_iexcep[0])|lite_iexcep[1];
				pc<=lite_pc;
				bd<=lite_bd;
				ex_mem_lite_wRegEn<=0;
				ex_mem_pro_wRegEn<=1'b0;
				ex_mem_pro_wHiEn<=0;
				ex_mem_pro_wLoEn<=0;
				ex_mem_pro_wCP0En<=0;
				ex_mem_pro_memEn_uncached<=0;	
				ex_mem_pro_memEn_cached<=0;		
				ex_mem_pro_tlb<=0;	
				//ex_mem_cacheInst<=5'b0;	
				ex_excep_first_pc<=lite_pc;
				ex_excep_bubble<=0;	
			end
			3'b110:begin //lite, pro excep
				ex_mem_lite_wRegEn<=lite_wRegEn;
				ex_mem_pro_wRegEn<=1'b0;
				excep<=ex_pro_excep;
				pc<=pro_pc;
				bd<=pro_bd;
				instAddrErr<=pro_instAddrErr|(~pro_iexcep[0])|pro_iexcep[1];
				ex_mem_pro_wHiEn<=0;
				ex_mem_pro_wLoEn<=0;
				ex_mem_pro_wCP0En<=0;
				ex_mem_pro_memEn_uncached<=0;	
				ex_mem_pro_memEn_cached<=0;	
				ex_mem_pro_tlb<=0;
				//ex_mem_cacheInst<=5'b0;	
				ex_excep_first_pc<=lite_pc;
				ex_excep_bubble<=0;		
			end
			default:begin 
				excep<=12'b0;
				instAddrErr<=0;
				pc<=pro_pc;
				bd<=pro_bd;
				ex_mem_lite_wRegEn<=lite_wRegEn;
				ex_mem_pro_wRegEn<=pro_wRegEn;
				ex_mem_pro_wHiEn<=pro_wHiEn;
				ex_mem_pro_wLoEn<=pro_wLoEn;
				ex_mem_pro_wCP0En<=pro_wCP0En;
				// if(|cacheInst) ex_mem_pro_memEn_uncached<=0;else ex_mem_pro_memEn_uncached<=pro_memEn&(~dcached);	
				// if(|cacheInst) ex_mem_pro_memEn_cached<=0;else ex_mem_pro_memEn_cached<=pro_memEn&dcached;
				ex_mem_pro_memEn_uncached<=pro_memEn&(~dcached);
				ex_mem_pro_memEn_cached<=pro_memEn&dcached;	
				ex_mem_pro_tlb<=tlb;
				//ex_mem_cacheInst<=cacheInst;	
				if(reverse) begin 
					ex_excep_first_pc<=lite_pc;
					ex_excep_bubble<=0;
				end else begin 
					ex_excep_first_pc<=pro_pc;
					ex_excep_bubble<=pro_bubble;
				end
			end
		endcase // {reverse,|ex_pro_excep,|lite_excep}
	end
end

always_ff @(posedge clk) begin
	if(stall) begin 
	end else begin
		ex_mem_lite_pc <= lite_pc;
		ex_mem_lite_wRegAddr<=lite_wRegAddr;
		ex_mem_lite_wRegData<=lite_aluAns;		
		ex_mem_reverse<=reverse;
		ex_mem_pro_pc<=pro_pc;
		ex_mem_pro_addr<=addr_p;
		ex_mem_pro_aluAns <=pro_aluAns;
		ex_mem_pro_wRegAddr<=pro_wRegAddr;
		ex_mem_pro_wHiData<=pro_wHiData;
		ex_mem_pro_wLoData<=pro_wLoData;
		ex_mem_pro_wCP0Data<=pro_wCP0Data;
		ex_mem_pro_wCP0Addr<=pro_wCP0Addr;
		ex_mem_pro_sel<=pro_sel;
		ex_mem_pro_rwmem<=pro_rwmem;
		ex_mem_pro_wsize<=pro_wsize;
		ex_mem_pro_wstrb<=pro_wstrb;
		ex_mem_pro_wdata<=pro_wdata;
		ex_mem_pro_rsize<=pro_rsize;
		ex_mem_pro_left_right<=pro_left_right;
		ex_mem_pro_signExt<=pro_signExt;
		ex_mem_pro_cached<=dcached;
		ex_mem_pro_rtReg<=pro_rtReg;
	end
end

endmodule