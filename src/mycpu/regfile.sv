module regfile (
	input clk,    // Clock
	input [4:0] rs1,
	input [4:0] rt1,
	input [4:0] rs2,
	input [4:0] rt2,	
	input ex_pro_wRegEn,
	input ex_lite_wRegEn,
	input ex_pro_valid,
	input ex_reverse,
	input [4:0] ex_pro_wRegAddr,
	input [4:0] ex_lite_wRegAddr,
	//ex_mem
	input mem_lite_wRegEn,
	input [4:0] mem_lite_wRegAddr,
	input mem_reverse,
	input mem_pro_wRegEn,
	input [4:0] mem_pro_wRegAddr,
	input mem_pro_valid,
	//wb
	input               lite_wRegEn  ,
	input [   31:0] lite_wRegData,
	input [4:0] lite_wRegAddr,
	input reverse,		
	input               pro_wRegEn  ,
	input [   31:0] pro_wRegData,
	input [4:0] pro_wRegAddr,	
	input               pro_wHiEn   ,
	input               pro_wLoEn   ,
	input [   31:0] pro_wHiData ,
	input [   31:0] pro_wLoData ,

	output logic [31:0] regrs1,
	output logic [31:0] regrt1,
	output logic [31:0] regrs2,
	output logic [31:0] regrt2,
	output logic [31:0] HiData,
	output logic [31:0] LoData,
	output logic [3:0] regrs1_mux,
	output logic [3:0] regrt1_mux,
	output logic [3:0] regrs2_mux,
	output logic [3:0] regrt2_mux,
	output logic stallrs1,
	output logic stallrt1,
	output logic stallrs2,
	output logic stallrt2
	);

logic [31:0] regs[0:31];
logic [31:0] Hi;
logic [31:0] Lo;
//to reverse back
logic [31:0] first_wRegData;
logic [4:0] first_wRegAddr;
logic first_wRegEn;
logic [31:0] second_wRegData;
logic [4:0] second_wRegAddr;
logic second_wRegEn;
logic [4:0] mem_first_wRegAddr;
logic mem_first_wRegEn;
logic mem_first_valid;
logic [4:0] mem_second_wRegAddr;
logic mem_second_wRegEn;
logic mem_second_valid;
logic [4:0] ex_first_wRegAddr;
logic ex_first_wRegEn;
logic ex_first_valid;
logic [4:0] ex_second_wRegAddr;
logic ex_second_wRegEn;
logic ex_second_valid;

always_comb begin : proc_reverseBack
	if(reverse) begin 
		first_wRegData=lite_wRegData;
		first_wRegEn=lite_wRegEn;
		first_wRegAddr=lite_wRegAddr;
		second_wRegEn=pro_wRegEn;
		second_wRegAddr=pro_wRegAddr;
		second_wRegData=pro_wRegData;
	end else begin 
		second_wRegData=lite_wRegData;
		second_wRegEn=lite_wRegEn;
		second_wRegAddr=lite_wRegAddr;
		first_wRegEn=pro_wRegEn;
		first_wRegAddr=pro_wRegAddr;
		first_wRegData=pro_wRegData;
	end
end

always_comb begin : proc_memReverseBack
	if(mem_reverse) begin 
		mem_first_wRegEn=mem_lite_wRegEn;
		mem_first_wRegAddr=mem_lite_wRegAddr;
		mem_first_valid=1;
		mem_second_wRegEn=mem_pro_wRegEn;
		mem_second_wRegAddr=mem_pro_wRegAddr;
		mem_second_valid=mem_pro_valid;
	end else begin 
		mem_second_wRegEn=mem_lite_wRegEn;
		mem_second_wRegAddr=mem_lite_wRegAddr;
		mem_second_valid=1;
		mem_first_wRegEn=mem_pro_wRegEn;
		mem_first_wRegAddr=mem_pro_wRegAddr;
		mem_first_valid=mem_pro_valid;
	end
end

always_comb begin : proc_exReverseBack
	if(ex_reverse) begin 
		ex_first_wRegEn=ex_lite_wRegEn;
		ex_first_wRegAddr=ex_lite_wRegAddr;
		ex_first_valid=1;
		ex_second_wRegEn=ex_pro_wRegEn;
		ex_second_wRegAddr=ex_pro_wRegAddr;
		ex_second_valid=ex_pro_valid;
	end else begin 
		ex_second_wRegEn=ex_lite_wRegEn;
		ex_second_wRegAddr=ex_lite_wRegAddr;
		ex_second_valid=1;
		ex_first_wRegEn=ex_pro_wRegEn;
		ex_first_wRegAddr=ex_pro_wRegAddr;
		ex_first_valid=ex_pro_valid;
	end
end

always_comb begin : proc_mux_regrs1
	regrs1_mux=4'b0;stallrs1=0;
	if(rs1==5'd0) begin
		regrs1_mux=4'b0;stallrs1=0;
	end
	else if(ex_second_wRegEn&(ex_second_wRegAddr==rs1)) begin 
		if(ex_reverse) regrs1_mux[3]=1;else regrs1_mux[2]=1;
		if(~ex_second_valid) stallrs1=1;
	end
	else if(ex_first_wRegEn&&(ex_first_wRegAddr==rs1)) begin 
		if(ex_reverse) regrs1_mux[2]=1;else regrs1_mux[3]=1;
		if(~ex_first_valid) stallrs1=1;
	end
	else if(mem_second_wRegEn&&(mem_second_wRegAddr==rs1)) begin 
		if(mem_reverse) regrs1_mux[1]=1;else regrs1_mux[0]=1;
		if(~mem_second_valid) stallrs1=1;
	end
	else if(mem_first_wRegEn&&(mem_first_wRegAddr==rs1)) begin 
		if(mem_reverse) regrs1_mux[0]=1;else regrs1_mux[1]=1;
		if(~mem_first_valid) stallrs1=1;
	end
end

always_comb begin : proc_mux_regrt1
	regrt1_mux=4'b0;stallrt1=0;
	if(rt1==5'd0) begin
		regrt1_mux=4'b0;stallrt1=0;
	end
	else if(ex_second_wRegEn&(ex_second_wRegAddr==rt1)) begin 
		if(ex_reverse) regrt1_mux[3]=1;else regrt1_mux[2]=1;
		if(~ex_second_valid) stallrt1=1;
	end
	else if(ex_first_wRegEn&&(ex_first_wRegAddr==rt1)) begin 
		if(ex_reverse) regrt1_mux[2]=1;else regrt1_mux[3]=1;
		if(~ex_first_valid) stallrt1=1;
	end
	else if(mem_second_wRegEn&&(mem_second_wRegAddr==rt1)) begin 
		if(mem_reverse) regrt1_mux[1]=1;else regrt1_mux[0]=1;
		if(~mem_second_valid) stallrt1=1;
	end
	else if(mem_first_wRegEn&&(mem_first_wRegAddr==rt1)) begin 
		if(mem_reverse) regrt1_mux[0]=1;else regrt1_mux[1]=1;
		if(~mem_first_valid) stallrt1=1;
	end
end

always_comb begin : proc_mux_regrs2
	regrs2_mux=4'b0;stallrs2=0;
	if(rs2==5'd0) begin 
		regrs2_mux=4'd0;stallrs2=0;
	end
	else if(ex_second_wRegEn&(ex_second_wRegAddr==rs2)) begin 
		if(ex_reverse) regrs2_mux[3]=1;else regrs2_mux[2]=1;
		if(~ex_second_valid) stallrs2=1;
	end
	else if(ex_first_wRegEn&&(ex_first_wRegAddr==rs2)) begin 
		if(ex_reverse) regrs2_mux[2]=1;else regrs2_mux[3]=1;
		if(~ex_first_valid) stallrs2=1;
	end
	else if(mem_second_wRegEn&&(mem_second_wRegAddr==rs2)) begin 
		if(mem_reverse) regrs2_mux[1]=1;else regrs2_mux[0]=1;
		if(~mem_second_valid) stallrs2=1;
	end
	else if(mem_first_wRegEn&&(mem_first_wRegAddr==rs2)) begin 
		if(mem_reverse) regrs2_mux[0]=1;else regrs2_mux[1]=1;
		if(~mem_first_valid) stallrs2=1;
	end
end

always_comb begin : proc_mux_regrt2
	regrt2_mux=4'b0;stallrt2=0;
	if(rt2==5'd0) begin 
		regrt2_mux=4'b0;stallrt2=0;
	end 
	else if(ex_second_wRegEn&(ex_second_wRegAddr==rt2)) begin 
		if(ex_reverse) regrt2_mux[3]=1;else regrt2_mux[2]=1;
		if(~ex_second_valid) stallrt2=1;
	end
	else if(ex_first_wRegEn&&(ex_first_wRegAddr==rt2)) begin 
		if(ex_reverse) regrt2_mux[2]=1;else regrt2_mux[3]=1;
		if(~ex_first_valid) stallrt2=1;
	end
	else if(mem_second_wRegEn&&(mem_second_wRegAddr==rt2)) begin 
		if(mem_reverse) regrt2_mux[1]=1;else regrt2_mux[0]=1;
		if(~mem_second_valid) stallrt2=1;
	end
	else if(mem_first_wRegEn&&(mem_first_wRegAddr==rt2)) begin 
		if(mem_reverse) regrt2_mux[0]=1;else regrt2_mux[1]=1;
		if(~mem_first_valid) stallrt2=1;
	end
end

always_ff @(posedge clk) begin
	if(first_wRegEn&&second_wRegEn&&(first_wRegAddr==second_wRegAddr)) begin 
		regs[second_wRegAddr]<=second_wRegData;
	end else begin 
		if(first_wRegEn) regs[first_wRegAddr]<=first_wRegData;
		if(second_wRegEn) regs[second_wRegAddr]<=second_wRegData;
	end
end

always_ff @(posedge clk) begin : proc_hilo
	if(pro_wHiEn) Hi<=pro_wHiData;
	if(pro_wLoEn) Lo<=pro_wLoData;
end

always_comb begin : proc_hiloRead
	if(pro_wHiEn) HiData=pro_wHiData;
	else HiData=Hi;
	if(pro_wLoEn) LoData=pro_wLoData;
	else LoData=Lo;
end

logic [31:0] regs_rt1;
logic [31:0] regs_rs1;
logic [31:0] regs_rt2;
logic [31:0] regs_rs2;
assign regs_rt1=regs[rt1];
assign regs_rt2=regs[rt2];
assign regs_rs1=regs[rs1];
assign regs_rs2=regs[rs2];

always_comb begin : proc_regrt1
	if(rt1==5'd0) regrt1=32'b0;
	else if(second_wRegEn&(second_wRegAddr==rt1)) regrt1=second_wRegData;
	else if(first_wRegEn&(first_wRegAddr==rt1)) regrt1=first_wRegData;
	else regrt1=regs_rt1;
end

always_comb begin : proc_regrs1
	if(rs1==5'd0) regrs1=32'b0;
	else if(second_wRegEn&(second_wRegAddr==rs1)) regrs1=second_wRegData;
	else if(first_wRegEn&(first_wRegAddr==rs1)) regrs1=first_wRegData;
	else regrs1=regs_rs1;
end

always_comb begin : proc_lite_regrt2
	if(rt2==5'd0) regrt2=32'b0;
	else if(second_wRegEn&(second_wRegAddr==rt2)) regrt2=second_wRegData;
	else if(first_wRegEn&(first_wRegAddr==rt2)) regrt2=first_wRegData;
	else regrt2=regs_rt2;
end

always_comb begin : proc_regrs2
	if(rs2==5'd0) regrs2=32'b0;
	else if(second_wRegEn&(second_wRegAddr==rs2)) regrs2=second_wRegData;
	else if(first_wRegEn&(first_wRegAddr==rs2)) regrs2=first_wRegData;
	else regrs2=regs_rs2;
end

endmodule