module instFetch (
	input clk,    
	input aresetn, 
	input stall,
	input flush,
	input gotoBranch,
	input [31:0] branchPC,
	//if inst1ok=0, then inst2ok must be 0
	input inst1ok_cached,
	input inst2ok_cached,
	input inst1ok_uncached,
	input inst2ok_uncached,
	input fifoFull,
	input [31:0] flushpc,
	input imiss,
	input ivalid,
	input icached,
	output logic [31:0] pc,
	output logic [31:0] if_id_pc,
	output logic write1En,
	output logic write2En,
	output logic [1:0] iexcep,
	output logic if_id_icached
	);

always_ff @(posedge clk) begin
	if(~aresetn) pc <= 32'hbfc00000; 
	else if(flush) pc<=flushpc;
	else if(gotoBranch) pc<=branchPC;
	else if(stall|fifoFull)begin 
	end
	else if((inst1ok_cached &inst2ok_cached)|(inst1ok_uncached&inst2ok_uncached)) pc<=pc+8;
	else if(inst1ok_cached|inst1ok_uncached) pc<=pc+4;
end

always_ff @(posedge clk) begin : proc_writeEn
	if(~aresetn|stall|fifoFull|gotoBranch|flush) begin
		write1En <= 0;
		write2En<=0;
		iexcep<=2'b1;
		if_id_icached<=1'b0;
	end else begin
		if_id_icached<=icached;
		if((inst1ok_cached&inst2ok_cached)|(inst1ok_uncached&inst2ok_uncached)) begin 
			write1En<=1;
			write2En<=1;
			iexcep<={imiss,ivalid};
		end else if(inst1ok_cached|inst1ok_uncached|imiss|(~ivalid)) begin 
			write1En<=1;
			write2En<=0;
			iexcep<={imiss,ivalid};
		end else begin 
			write1En<=0;
			write2En<=0;	
			iexcep<=2'd1;			
		end
	end
end

always_ff @(posedge clk) begin
	if_id_pc<=pc;
end

endmodule