module mem_wb_pro (
	input clk,    // Clock
	input aresetn,
	input flush,
	input pro_wRegEn,
	input [4:0] pro_wRegAddr,
	input [31:0] pro_aluAns,
	input pro_rwmem,
	input [ 2:0]pro_rsize,	
	input pro_signExt,
	input [1:0] pro_left_right,	
	input [31:0] pro_pc,
	input reverse,
	input pro_cached,
	input [31:0] pro_rtReg,
	output logic mem_wb_pro_wRegEn,
	output logic [4:0] mem_wb_pro_wRegAddr,
	output logic [31:0] mem_wb_pro_aluAns,
	output logic [31:0] mem_wb_pc,
	output logic mem_wb_reverse,	
	output logic mem_wb_pro_rwmem,
	output logic [ 2:0]mem_wb_pro_rsize,
	output logic mem_wb_pro_signExt		,
	output logic mem_wb_pro_cached,
	output logic mem_pro_valid,
	output logic [1:0] mem_wb_pro_left_right,
	output logic [31:0] mem_wb_pro_rtReg
);

assign mem_pro_valid=~pro_rwmem;

always_ff @(posedge clk) begin
	if(~aresetn|flush) begin 
		mem_wb_pro_wRegEn<=0;
		mem_wb_pro_wRegAddr<=0;
		mem_wb_pro_aluAns<=0;
		mem_wb_pro_rwmem<=0;	
		mem_wb_pc<=0;
		mem_wb_reverse<=0;
		mem_wb_pro_rsize<=0;
		mem_wb_pro_signExt<=0;
		mem_wb_pro_cached<=0;
		mem_wb_pro_left_right<=0;
		mem_wb_pro_rtReg<=0;
	end 
	/*NO stall in mem*/
	// else if(stall) begin 
	// end 
	else begin 
		mem_wb_pro_wRegEn<=pro_wRegEn;
		mem_wb_pro_wRegAddr<=pro_wRegAddr;
		mem_wb_pro_aluAns<=pro_aluAns;
		mem_wb_pro_rwmem<=pro_rwmem;	
		mem_wb_pc<=pro_pc;
		mem_wb_reverse<=reverse;		
		mem_wb_pro_rsize<=pro_rsize;
		mem_wb_pro_signExt<=pro_signExt;	
		mem_wb_pro_cached<=pro_cached;	
		mem_wb_pro_left_right<=pro_left_right;
		mem_wb_pro_rtReg<=pro_rtReg;
	end
end

endmodule