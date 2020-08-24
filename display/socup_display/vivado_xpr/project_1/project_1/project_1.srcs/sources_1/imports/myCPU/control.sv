module control (
	input aresetn,
	input stallFromIcache,
	input stallFromEX,
	input stallFromDcache,
	input flush,
	input tlb_istall,
	input tlb_dstall,
	input flush_int,
	output logic stallif1_if2,
	output logic stallid_ex,
	output logic stallex_mem,
	output logic flushif1_if2,
	output logic flushid_ex,
	output logic flushex_mem,
	output logic flushmem_wb
);

/******************
stallFromDcache:stall before ex_mem,flush mem_wb, mem2_wb continue
stallFromEX:because of mult or div or data hazard with load, stall before issue_ex, flush ex_mem,
stallFromIcache:stall if1_if2
flush(eret):change if1_if2, flush all without mem_wb(because the excep may be for the second pipeline)
gotoBranch:change if1_if2, flush id_ex(the delayslot is in the same line with branch in default), not here
stallForLoadHaz:stall
when stall if1_if2, it must flush if2_id, until the stall is false, if2_id will write inst into fifo
********************/

always_comb begin
	if(~aresetn) begin 
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b0;
	end else if(flush_int) begin
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b0001111;
	end else if(flush) begin 
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b0001110;
	end else if(stallFromDcache) begin 
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b1110001;
	end else if(stallFromEX|tlb_dstall) begin 
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b1100010;
	end else if(stallFromIcache|tlb_istall) begin 
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b1000000;
	end else begin 
		{stallif1_if2,stallid_ex,stallex_mem,flushif1_if2,flushid_ex,flushex_mem,flushmem_wb}=7'b0;
	end
end
endmodule