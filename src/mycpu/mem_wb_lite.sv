
module mem_wb_lite (
	input clk,    // Clock
	input aresetn,
	input [31:0] lite_wRegData,
	input lite_wRegEn,
	input [4:0] lite_wRegAddr,
	input [31:0] lite_pc,
	input flush,
	output logic [31:0] mem_wb_lite_wRegData,
	output logic mem_wb_lite_wRegEn,
	output logic [4:0] mem_wb_lite_wRegAddr,
	output logic [31:0] mem_wb_lite_pc			
);

always_ff @(posedge clk) begin
	if(~aresetn|flush) begin
		mem_wb_lite_pc <= 32'b0;
		mem_wb_lite_wRegAddr<=5'b0;
		mem_wb_lite_wRegData<=32'b0;
		mem_wb_lite_wRegEn<=1'b0;
	end else begin
		mem_wb_lite_pc <= lite_pc;
		mem_wb_lite_wRegAddr<=lite_wRegAddr;
		mem_wb_lite_wRegData<=lite_wRegData;
		mem_wb_lite_wRegEn<=lite_wRegEn;
	end
end

endmodule