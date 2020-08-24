`include "define.svh"
module cpu (
	input        [        5:0] ext_int          ,
	input                      aresetn          ,
	input                      aclk             ,
	input inst1ok_cached,
	input inst2ok_cached,
	input inst1ok_uncached, 
	input inst2ok_uncached,
	input stallFromDcache,
	input stallFromIcache,
	input [31:0] inst1_cached,
	input [31:0] inst2_uncached,
	input [31:0] inst1_uncached,
	input [31:0] inst2_cached,
	output logic [31:0] iaddr,
	output logic iEn_uncached,
	output logic iEn_cached,
	input [31:0] drdata_cached,
	input [31:0] drdata_uncached,
	output logic [31:0] ex_mem_pro_wdata,
	output logic [31:0] ex_mem_pro_addr,
	output logic [3:0] ex_mem_pro_wstrb,
	output logic [ 2:0]ex_mem_pro_wsize,	
	output logic memEn_uncached,
	output logic memEn_cached,
	output logic ex_mem_pro_rwmem,
	output logic [ 2:0]ex_mem_pro_rsize
	//,
	//output logic [4:0] ex_mem_cacheInst
	);

logic [31:0] debug_first_pc;
logic [3 :0] debug_first_wen;
logic [4 :0] debug_first_wnum;
logic [31:0] debug_first_wdata;
logic [31:0] debug_second_pc;
logic [3 :0] debug_second_wen;
logic [4 :0] debug_second_wnum;
logic [31:0] debug_second_wdata;
logic [31:0] countIssue0;
logic [31:0] countIssue1;
logic [31:0] countIssue2;
logic [31:0] countIssue3;
logic [31:0] countIcacheStall;
logic [31:0] countDcacheStall;
logic [31:0] countMultDivStall;
logic [31:0] countLoadHazStall;
logic [31:0] countgotoBranch;
logic [31:0] countIssue2FifoEmpty;
logic [31:0] countIssue2DataHaz;

logic [31:0] flushpc;
logic flush;
logic gotoBranch;
logic [31:0] branchPC;
logic fifoFull;
logic write1En;
logic write2En;
logic [31:0] if_id_pc;
logic [31:0] pc;
logic flush_int;

logic id_ex_reverse;
logic [31:0] id_ex_pro_pc;
logic [7:0] id_ex_pro_opcode;
logic [4:0] id_ex_pro_rs;
logic [4:0] id_ex_pro_rt;
logic [2:0] id_ex_pro_sel;
logic [4:0] id_ex_pro_wRegAddr;
logic [31:0] id_ex_pro_op3;
logic [4:0] id_ex_pro_wCP0Addr;
logic [4:0] id_ex_pro_rCP0Addr;
logic id_ex_pro_bd;
logic [31:0] id_ex_lite_pc;
logic [7:0] id_ex_lite_opcode;
logic [4:0] id_ex_lite_rs;
logic [4:0] id_ex_lite_rt;
logic [4:0] id_ex_lite_wRegAddr;
logic [31:0] id_ex_lite_op3;
logic id_ex_lite_bd;	
logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rt1;
logic [4:0] rt2;
logic [3:0] regrs1_mux;
logic [3:0] regrt1_mux;
logic [3:0] regrs2_mux;
logic [3:0] regrt2_mux;
logic [3:0] pro_rs_mux;
logic [3:0] pro_rt_mux;
logic [3:0] lite_rs_mux;
logic [3:0] lite_rt_mux;
logic [31:0] regrs1;
logic [31:0] regrt1;
logic [31:0] regrs2;
logic [31:0] regrt2;

logic [31:0] ex_pro_aluAns;
logic ex_pro_wRegEn;
logic [6:0] ex_pro_excep;
logic ex_pro_instAddrErr;
logic [31:0] ex_pro_wHiData;
logic [31:0] ex_pro_wLoData;
logic ex_pro_wHiEn;
logic ex_pro_wLoEn;
logic [31:0] ex_pro_wCP0Data;
logic ex_pro_wCP0En;
logic [31:0] ex_pro_branchPC;
logic ex_pro_gotoBranch;
logic [31:0] ex_pro_wdata;
logic [31:0] ex_pro_addr;
logic [3:0] ex_pro_wstrb;
logic [ 2:0]ex_pro_wsize;	
logic ex_pro_rwmem;
logic [ 2:0]ex_pro_rsize;	
logic ex_pro_signExt;
logic [1:0] ex_pro_left_right;
logic [31:0] pro_rtReg;

logic [31:0] addrtmp;
logic [31:0] pro_regrs;
logic [31:0] pro_regrt;
logic [31:0] lite_regrs;
logic [31:0] lite_regrt;

logic [31:0] ex_lite_aluAns;
logic ex_lite_wRegEn;
logic [31:0] ex_lite_branchPC;
logic ex_lite_gotoBranch;
logic [6:0] ex_lite_excep;
logic ex_lite_instAddrErr;

logic ex_mem_reverse;
logic [31:0] ex_mem_lite_wRegData;
logic ex_mem_lite_wRegEn;
logic [4:0] ex_mem_lite_wRegAddr;
logic [6:0] ex_mem_lite_excep;
logic ex_mem_lite_instAddrErr;	
logic [31:0] ex_mem_lite_pc;
logic [31:0] ex_mem_pro_pc;
logic [31:0] ex_mem_pro_aluAns;
logic ex_mem_pro_wRegEn;
logic [4:0] ex_mem_pro_wRegAddr;
logic [31:0] ex_mem_pro_wHiData;
logic [31:0] ex_mem_pro_wLoData;
logic ex_mem_pro_wHiEn;
logic ex_mem_pro_wLoEn;
logic [31:0] ex_mem_pro_wCP0Data;
logic [4:0] ex_mem_pro_wCP0Addr;
logic [2:0] ex_mem_pro_sel;
logic ex_mem_pro_wCP0En;
logic ex_mem_pro_signExt;	
logic [1:0] ex_mem_pro_left_right;	
logic [31:0] ex_mem_pro_rtReg;

logic [31:0] id_ex_lite_regrs;
logic [31:0] id_ex_lite_regrt;
logic [31:0] id_ex_pro_regrs;
logic [31:0] id_ex_pro_regrt;
logic [31:0] HiData;
logic [31:0] LoData;

logic [31:0] drdata     ;
logic [31:0] rCP0Data;

logic mem_wb_reverse;
logic mem_wb_pro_wRegEn;
logic [4:0] mem_wb_pro_wRegAddr;
logic [31:0] mem_wb_pro_aluAns;
logic [31:0] mem_wb_pro_pc;
logic mem_wb_pro_rwmem;
logic [2:0] mem_wb_pro_rsize;
logic mem_wb_pro_signExt;

logic [31:0] mem_wb_lite_wRegData;
logic mem_wb_lite_wRegEn;
logic [4:0] mem_wb_lite_wRegAddr;
logic [31:0] mem_wb_lite_pc;
logic mem_wb_pro_cached;
logic [1:0] mem_wb_pro_left_right;
logic [31:0] mem_wb_pro_rtReg;

logic [31:0] mem_wb_pro_wRegData;

logic stallif1_if2;
logic stallid_ex;
logic flushif1_if2;
logic flushid_ex;
logic multDivStall;
logic flushex_mem;
logic stallex_mem;
logic flushmem_wb;
logic stallForLoadHaz;

logic [12:0] excep;
logic excep_instAddrErr;
logic excep_bd;
logic [31:0] excep_pc;
logic id_ex_pro_bubble;
logic id_ex_lite_bubble;
logic ex_excep_bubble;
logic [31:0] ex_excep_first_pc;

//debug
logic [3:0] issueState;

//cache
//logic [4:0] cacheInst;

//tlb
logic [3:0] tlb;
logic [3:0] ex_mem_pro_tlb;
logic [`TLB_INDEX-1:0] cp0_Index;
logic [`TLB_INDEX-1:0] tlbwrIndex;
logic [31:0] cp0_EntryHi;
logic [31:0] cp0_EntryLo0;
logic [31:0] cp0_EntryLo1;
logic [`TLB_INDEX:0] tlb_Index;
logic [31:0] tlb_EntryHi;
logic [31:0] tlb_EntryLo1;
logic [31:0] tlb_EntryLo0;
logic [31:0] cp0_PageMask;
logic [31:0] tlb_PageMask;
logic tlb_istall;
logic tlb_dstall;
logic dvalid;
logic ivalid;
logic icached;
logic dcached;
logic dwunable;
logic imiss;
logic dmiss;
logic [1:0] iexcep;
logic [1:0] pro_iexcep;
logic [1:0] lite_iexcep;
assign iEn_cached=~imiss&icached&ivalid;
assign iEn_uncached=~imiss&(~icached)&ivalid;
logic [31:0] addr_p;

logic ex_mem_pro_memEn_uncached;
logic ex_mem_pro_memEn_cached;
assign memEn_uncached=ex_mem_pro_memEn_uncached&(~flush_int);
assign memEn_cached=ex_mem_pro_memEn_cached&(~flush_int);

logic wHiEn;
logic wLoEn;
assign wHiEn=ex_mem_pro_wHiEn&(~flush_int);
assign wLoEn=ex_mem_pro_wLoEn&(~flush_int);

assign gotoBranch=ex_lite_gotoBranch&(~flushex_mem)&(~stallex_mem);
logic copU;

// assign stallif1_if2=stallFromDcache|stallFromIcache|multDivStall|tlb_dstall|tlb_istall;
// assign stallid_ex=stallFromDcache|multDivStall|tlb_dstall;
// assign stallex_mem=stallFromDcache;
// assign flushmem_wb=flush_int|stallFromDcache;
// assign flushex_mem=flush|multDivStall|tlb_dstall;

control inst_control
(
	.aresetn(aresetn),
	.stallFromIcache (stallFromIcache),
	.stallFromEX     (multDivStall),
	.stallFromDcache (stallFromDcache),
	.flush           (flush),
	.stallif1_if2    (stallif1_if2),
	.stallid_ex      (stallid_ex),
	.stallex_mem    (stallex_mem),
	.flushif1_if2    (flushif1_if2),
	.flushid_ex      (flushid_ex),
	.flushex_mem    (flushex_mem),
	.flushmem_wb  (flushmem_wb),
	.tlb_istall     (tlb_istall),
	.tlb_dstall     (tlb_dstall),
	.flush_int(flush_int)
	);

instFetch inst_instFetch
(
	.clk        (aclk),
	.aresetn    (aresetn),
	.stall      (stallif1_if2),
	.flush      (flush),
	.gotoBranch (gotoBranch),//from ex ctrl
	.branchPC   (ex_lite_branchPC),
	.fifoFull   (fifoFull),
	.flushpc        (flushpc),//from excep
	.pc        (pc),
	.write1En  (write1En),
	.write2En  (write2En),
	.if_id_pc  (if_id_pc),
	.imiss     (imiss),
	.ivalid    (ivalid),
	.iexcep    (iexcep),
	.inst1ok_cached (inst1ok_cached),
	.inst2ok_cached (inst2ok_cached),
	.inst1ok_uncached(inst1ok_uncached),
	.inst2ok_uncached(inst2ok_uncached),
	.icached        (icached),
	.if_id_icached  (if_id_icached)
	);

issue inst_issue
(
	.clk           (aclk),
	.aresetn       (aresetn),
	.gotoBranch   (gotoBranch),
	.inst1_cached (inst1_cached),
	.inst2_cached (inst2_cached),
	.inst1_uncached(inst1_uncached),
	.inst2_uncached(inst2_uncached),
	.cached       (if_id_icached),
	.write1En     (write1En),
	.write2En     (write2En),
	.pc           (if_id_pc),
	.stall         (stallid_ex),
	.flush         (flush),
	.reverse       (id_ex_reverse),
	.fifoFull      (fifoFull),
	.rs1           (rs1),
	.rt1           (rt1),
	.rs2           (rs2),
	.rt2           (rt2),
	.regrs1_mux    (regrs1_mux),
	.regrt1_mux    (regrt1_mux),
	.regrs2_mux    (regrs2_mux),
	.regrt2_mux    (regrt2_mux),
	.stallrs1      (stallrs1),
	.stallrt1      (stallrt1),
	.stallrs2      (stallrs2),
	.stallrt2      (stallrt2),
	.pro_rs_mux    (pro_rs_mux),
	.pro_rt_mux    (pro_rt_mux),
	.lite_rs_mux   (lite_rs_mux),
	.lite_rt_mux   (lite_rt_mux),
	.regrs1        (regrs1),
	.regrt1        (regrt1),
	.regrs2        (regrs2),
	.regrt2        (regrt2),
	.pro_regrs     (pro_regrs),
	.pro_regrt     (pro_regrt),
	.lite_regrs    (lite_regrs),
	.lite_regrt    (lite_regrt),
	.pro_opcode    (id_ex_pro_opcode),
	.pro_pc       (id_ex_pro_pc),
	.pro_sel       (id_ex_pro_sel),
	.pro_wRegAddr  (id_ex_pro_wRegAddr),
	.pro_op3       (id_ex_pro_op3),
	.pro_wCP0Addr  (id_ex_pro_wCP0Addr),
	.pro_rCP0Addr  (id_ex_pro_rCP0Addr),
	.pro_bd        (id_ex_pro_bd),
	.pro_bubble (id_ex_pro_bubble),
	.pro_wRegEn    (id_ex_pro_wRegEn),
	.lite_opcode   (id_ex_lite_opcode),
	.lite_pc      (id_ex_lite_pc),
	.lite_wRegAddr (id_ex_lite_wRegAddr),
	.lite_op3      (id_ex_lite_op3),
	.lite_bd       (id_ex_lite_bd),
	.lite_wRegEn (id_ex_lite_wRegEn),
	.issueState   (issueState),
	.iexcep       (iexcep),
	.lite_iexcep   (lite_iexcep),
	.pro_iexcep    (pro_iexcep),
	.lite_bubble(id_ex_lite_bubble)
	);

ex_pro inst_ex_pro
(
	.aresetn            (aresetn),
	.clk                (aclk),
	.pro_pc             (id_ex_pro_pc),
	.pro_opcode         (id_ex_pro_opcode),
	.pro_op3            (id_ex_pro_op3),
	.regrs          (pro_regrs),
	.regrt          (pro_regrt),
	.pro_rs_mux       (pro_rs_mux),
	.pro_rt_mux       (pro_rt_mux),
	.wb_pro_wRegData  (mem_wb_pro_aluAns),
	.wb_lite_wRegData (mem_wb_lite_wRegData),
	.mem_pro_wRegData (ex_mem_pro_aluAns),
	.mem_lite_wRegData(ex_mem_lite_wRegData),
	.HiData             (HiData),
	.LoData             (LoData),
	.rCP0Data           (rCP0Data),
	.aluAns      (ex_pro_aluAns),
	.wRegEn      (ex_pro_wRegEn),
	.excep       (ex_pro_excep),
	.instAddrErr (ex_pro_instAddrErr),
	.wHiData     (ex_pro_wHiData),
	.wLoData     (ex_pro_wLoData),
	.wHiEn       (ex_pro_wHiEn),
	.wLoEn       (ex_pro_wLoEn),
	.wCP0Data    (ex_pro_wCP0Data),
	.wCP0En      (ex_pro_wCP0En),
	.wdata              (ex_pro_wdata),
	.wstrb              (ex_pro_wstrb),
	.wsize              (ex_pro_wsize),
	.rwmem              (ex_pro_rwmem),
	.memEn       (ex_pro_memEn),
	.rsize              (ex_pro_rsize),
	.addr_v              (ex_pro_addr),
	.signExt            (ex_pro_signExt),
	.multDivStall       (multDivStall),
	.stallid_ex       (stallid_ex),
	//.cacheInst (cacheInst),
	.tlb           (tlb),
	.ex_pro_valid(ex_pro_valid),
	.left_right(ex_pro_left_right),
	.pro_rtReg        (pro_rtReg),
	.copU             (copU)
	);

ex_lite inst_ex_lite
(
	.aresetn       (aresetn),
	.clk              (aclk),
	.stallid_ex            (stallid_ex),
	.lite_pc       (id_ex_lite_pc),
	.lite_opcode   (id_ex_lite_opcode),
	.lite_op3      (id_ex_lite_op3),
	.regrs    (lite_regrs),
	.regrt    (lite_regrt),
	.lite_rs_mux      (lite_rs_mux),
	.lite_rt_mux      (lite_rt_mux),
	.wb_pro_wRegData  (mem_wb_pro_aluAns),
	.wb_lite_wRegData (mem_wb_lite_wRegData),
	.mem_pro_wRegData (ex_mem_pro_aluAns),
	.mem_lite_wRegData(ex_mem_lite_wRegData),
	.aluAns        (ex_lite_aluAns),
	.wRegEn        (ex_lite_wRegEn),
	.branchPC      (ex_lite_branchPC),
	.gotoBranch    (ex_lite_gotoBranch),
	.excep         (ex_lite_excep),
	.instAddrErr   (ex_lite_instAddrErr)
	);

exe_ctrl inst_exe_ctrl
(
	.clk                     (aclk),
	.aresetn                 (aresetn),
	.flush                   (flushex_mem),
	.stall                   (stallex_mem),
	.reverse                 (id_ex_reverse),
	.lite_pc                 (id_ex_lite_pc),
	.lite_aluAns             (ex_lite_aluAns),
	.lite_wRegEn             (ex_lite_wRegEn),
	.lite_wRegAddr           (id_ex_lite_wRegAddr),
	.lite_excep              (ex_lite_excep),
	.lite_instAddrErr        (ex_lite_instAddrErr),
	.lite_bd                 (id_ex_lite_bd),
	.lite_bubble(id_ex_lite_bubble),
	.lite_iexcep              (lite_iexcep),
	.pro_pc                  (id_ex_pro_pc),
	.addr_p(addr_p),
	.pro_aluAns              (ex_pro_aluAns),
	.pro_wRegEn              (ex_pro_wRegEn),
	.pro_wRegAddr            (id_ex_pro_wRegAddr),
	.pro_excep               (ex_pro_excep),
	.pro_instAddrErr         (ex_pro_instAddrErr),
	.pro_wHiData             (ex_pro_wHiData),
	.pro_wLoData             (ex_pro_wLoData),
	.pro_wHiEn               (ex_pro_wHiEn),
	.pro_wLoEn               (ex_pro_wLoEn),
	.pro_wCP0Data            (ex_pro_wCP0Data),
	.pro_wCP0Addr            (id_ex_pro_wCP0Addr),
	.pro_sel                 (id_ex_pro_sel),
	.pro_wCP0En              (ex_pro_wCP0En),
	.pro_bd                  (id_ex_pro_bd),
	.pro_wdata               (ex_pro_wdata),
	.pro_wstrb               (ex_pro_wstrb),
	.pro_wsize               (ex_pro_wsize),
	.pro_rwmem               (ex_pro_rwmem),
	.pro_memEn                (ex_pro_memEn),
	.pro_rsize               (ex_pro_rsize),
	.pro_addr               (ex_pro_addr),
	.pro_left_right (ex_pro_left_right),
	.pro_rtReg(pro_rtReg),
	.pro_signExt             (ex_pro_signExt),
	.pro_bubble(id_ex_pro_bubble),
	.pro_iexcep               (pro_iexcep),
	.copU                     (copU),
	.ex_mem_reverse          (ex_mem_reverse),
	.ex_mem_lite_wRegData    (ex_mem_lite_wRegData),
	.ex_mem_lite_wRegEn      (ex_mem_lite_wRegEn),
	.ex_mem_lite_wRegAddr    (ex_mem_lite_wRegAddr),
	.ex_mem_lite_pc          (ex_mem_lite_pc),
	.ex_mem_pro_pc           (ex_mem_pro_pc),
	.ex_mem_pro_aluAns       (ex_mem_pro_aluAns),
	.ex_mem_pro_wRegEn       (ex_mem_pro_wRegEn),
	.ex_mem_pro_wRegAddr     (ex_mem_pro_wRegAddr),
	.ex_mem_pro_wHiData      (ex_mem_pro_wHiData),
	.ex_mem_pro_wLoData      (ex_mem_pro_wLoData),
	.ex_mem_pro_wHiEn        (ex_mem_pro_wHiEn),
	.ex_mem_pro_wLoEn        (ex_mem_pro_wLoEn),
	.ex_mem_pro_wCP0Data     (ex_mem_pro_wCP0Data),
	.ex_mem_pro_wCP0Addr     (ex_mem_pro_wCP0Addr),
	.ex_mem_pro_sel          (ex_mem_pro_sel),
	.ex_mem_pro_wCP0En       (ex_mem_pro_wCP0En),
	.ex_excep_bubble(ex_excep_bubble),
	.ex_excep_first_pc(ex_excep_first_pc),
	.ex_mem_pro_wdata        (ex_mem_pro_wdata),
	.ex_mem_pro_wstrb        (ex_mem_pro_wstrb),
	.ex_mem_pro_wsize        (ex_mem_pro_wsize),
	.ex_mem_pro_rwmem        (ex_mem_pro_rwmem),
	.ex_mem_pro_rsize        (ex_mem_pro_rsize),
	.ex_mem_pro_addr        (ex_mem_pro_addr),
	.ex_mem_pro_left_right(ex_mem_pro_left_right),
	.ex_mem_pro_rtReg(ex_mem_pro_rtReg),
	.ex_mem_pro_signExt      (ex_mem_pro_signExt),
	.excep               (excep),
	.instAddrErr         (excep_instAddrErr),
	.bd                   (excep_bd),
	.pc                  (excep_pc),
	.ex_mem_pro_memEn_uncached(ex_mem_pro_memEn_uncached),
	.ex_mem_pro_memEn_cached  (ex_mem_pro_memEn_cached),
	.ex_mem_pro_cached        (ex_mem_pro_cached),
	.tlb                      (tlb),
	.ex_mem_pro_tlb           (ex_mem_pro_tlb),
	.dmiss                    (dmiss),
	.dvalid                   (dvalid),
	.dwunable                 (dwunable),
	.dcached                  (dcached)
	// .cacheInst                (cacheInst),
	// .ex_mem_cacheInst         (ex_mem_cacheInst)
	);

mem_wb_pro inst_mem_wb_pro
(
	.clk                    (aclk),
	.aresetn                (aresetn),
	.flush                  (flushmem_wb),
	.pro_wRegEn             (ex_mem_pro_wRegEn),
	.pro_wRegAddr           (ex_mem_pro_wRegAddr),
	.pro_aluAns             (ex_mem_pro_aluAns),
	.pro_rwmem              (ex_mem_pro_rwmem),
	.pro_rtReg(ex_mem_pro_rtReg),
	.pro_pc                 (ex_mem_pro_pc),
	.pro_left_right(ex_mem_pro_left_right),
	.mem_wb_pro_wRegEn   (mem_wb_pro_wRegEn),
	.mem_wb_pro_wRegAddr (mem_wb_pro_wRegAddr),
	.mem_wb_pro_aluAns   (mem_wb_pro_aluAns),
	.mem_wb_pro_rwmem        (mem_wb_pro_rwmem),
	.mem_wb_pc           (mem_wb_pro_pc),
	.reverse               (ex_mem_reverse),
	.mem_wb_reverse     (mem_wb_reverse),
	.pro_rsize             (ex_mem_pro_rsize),
	.pro_signExt           (ex_mem_pro_signExt),
	.mem_wb_pro_rsize       (mem_wb_pro_rsize),
	.mem_wb_pro_signExt     (mem_wb_pro_signExt),
	.mem_wb_pro_left_right(mem_wb_pro_left_right),
	.mem_wb_pro_rtReg(mem_wb_pro_rtReg),
	.pro_cached(ex_mem_pro_cached),
	.mem_wb_pro_cached(mem_wb_pro_cached),
	.mem_pro_valid      (mem_pro_valid)

	);

pre_wb_pro inst_pre_wb_pro
(
	.pro_aluAns           (mem_wb_pro_aluAns),
	.pro_rwmem            (mem_wb_pro_rwmem),
	.pro_left_right (mem_wb_pro_left_right),
	.drdata_uncached               (drdata_uncached),
	.drdata_cached      (drdata_cached),
	.mem_wb_pro_wRegData(mem_wb_pro_wRegData),
	.pro_rsize           (mem_wb_pro_rsize),
	.pro_signExt         (mem_wb_pro_signExt),
	.rtReg(mem_wb_pro_rtReg),
	.cached             (mem_wb_pro_cached)
	);


mem_wb_lite inst_mem_wb_lite
(
	.clk                     (aclk),
	.aresetn                 (aresetn),
	.lite_wRegData           (ex_mem_lite_wRegData),
	.lite_wRegEn             (ex_mem_lite_wRegEn),
	.lite_wRegAddr           (ex_mem_lite_wRegAddr),
	.lite_pc                 (ex_mem_lite_pc),
	.flush                   (flushmem_wb),
	.mem_wb_lite_wRegData (mem_wb_lite_wRegData),
	.mem_wb_lite_wRegEn   (mem_wb_lite_wRegEn),
	.mem_wb_lite_wRegAddr (mem_wb_lite_wRegAddr),
	.mem_wb_lite_pc       (mem_wb_lite_pc)
	);


regfile inst_regfile
(
	.clk               (aclk),
	.rs1              (rs1),
	.rt1              (rt1),
	.rs2              (rs2),
	.rt2              (rt2),
	.ex_pro_wRegEn       (id_ex_pro_wRegEn),
	.ex_lite_wRegEn      (id_ex_lite_wRegEn),
	.ex_pro_valid     (ex_pro_valid),
	.ex_reverse          (id_ex_reverse),
	.ex_pro_wRegAddr     (id_ex_pro_wRegAddr),
	.ex_lite_wRegAddr    (id_ex_lite_wRegAddr),
	.pro_wRegEn        (mem_wb_pro_wRegEn),
	.pro_wRegData      (mem_wb_pro_wRegData),
	.pro_wRegAddr      (mem_wb_pro_wRegAddr),
	.pro_wHiEn         (wHiEn),
	.pro_wLoEn         (wLoEn),
	.pro_wHiData       (ex_mem_pro_wHiData),
	.pro_wLoData       (ex_mem_pro_wLoData),
	.lite_wRegEn       (mem_wb_lite_wRegEn),
	.lite_wRegData     (mem_wb_lite_wRegData),
	.lite_wRegAddr     (mem_wb_lite_wRegAddr),
	.reverse           (mem_wb_reverse),
	.mem_lite_wRegEn   (ex_mem_lite_wRegEn),
	.mem_lite_wRegAddr (ex_mem_lite_wRegAddr),
	.mem_pro_valid    (mem_pro_valid),
	.mem_reverse       (ex_mem_reverse),
	.mem_pro_wRegEn    (ex_mem_pro_wRegEn),
	.mem_pro_wRegAddr  (ex_mem_pro_wRegAddr),	
	.HiData            (HiData),
	.LoData            (LoData),
	.regrs1           (regrs1),
	.regrt1           (regrt1),
	.regrs2           (regrs2),
	.regrt2           (regrt2),
	.regrs1_mux       (regrs1_mux),
	.regrt1_mux       (regrt1_mux),
	.regrs2_mux       (regrs2_mux),
	.regrt2_mux       (regrt2_mux),
	.stallrs1         (stallrs1),
	.stallrt1         (stallrt1),
	.stallrt2         (stallrt2),
	.stallrs2         (stallrs2)
	);

exception inst_exception
(
	.clk              (aclk),
	.aresetn          (aresetn),
	.hwint           (ext_int),
	.excep       (excep),
	.instAddrErr (excep_instAddrErr),
	.pc          (excep_pc),
	.bd         (excep_bd),
	.bubble(ex_excep_bubble),
	.first_pc(ex_excep_first_pc),
	.pro_wCP0Data     (ex_mem_pro_wCP0Data),
	.pro_wCP0Addr     (ex_mem_pro_wCP0Addr),
	.pro_sel          (ex_mem_pro_sel),
	.pro_wCP0En       (ex_mem_pro_wCP0En),
	.rCP0Addr         (id_ex_pro_rCP0Addr),
	.rCP0Sel     (id_ex_pro_sel),
	.flushpc            (flushpc),
	.CP0reg           (rCP0Data),
	.aluAns          (ex_mem_pro_aluAns),
	.flush           (flush),
	.tlb         (ex_mem_pro_tlb[3:0]),
	.wIndex      (tlb_Index),
	.wEntryHi    (tlb_EntryHi),
	.wEntryLo1   (tlb_EntryLo1),
	.wEntryLo0   (tlb_EntryLo0),
	.wPageMask   (tlb_PageMask),
	.EntryHi     (cp0_EntryHi),
	.EntryLo0    (cp0_EntryLo0),
	.EntryLo1    (cp0_EntryLo1),
	.Index       (cp0_Index),
	.PageMask    (cp0_PageMask),
	.flush_int(flush_int),
	.tlbwrIndex   (tlbwrIndex)
	);

tlb_translate inst_tlb
(
	.clk        (aclk),
	.aresetn    (aresetn),
	.iaddr_v    (pc),
	.daddr_v    (ex_pro_addr),
	.memEn     (ex_pro_memEn),
	.Index      (cp0_Index),
	.EntryHi    (cp0_EntryHi),
	.EntryLo0   (cp0_EntryLo0),
	.EntryLo1   (cp0_EntryLo1),
	.PageMask  (cp0_PageMask),
	.tlbwi      (tlb[2]),
	.tlbwr     (tlb[3]),
	.tlbwrIndex (tlbwrIndex),
	.pmeetIndex (tlb_Index),
	.wEntryHi   (tlb_EntryHi),
	.wEntryLo1  (tlb_EntryLo1),
	.wEntryLo0  (tlb_EntryLo0),
	.wPageMask (tlb_PageMask),
	.iaddr_p    (iaddr),
	.istall     (tlb_istall),
	.daddr_p (addr_p),
	.dstall     (tlb_dstall),
	.dvalid     (dvalid),
	.ivalid     (ivalid),
	.icached    (icached),
	.dcached    (dcached),
	.dwunable   (dwunable),
	.imiss     (imiss),
	.dmiss     (dmiss)
	);

always_comb begin : proc_debug
	if(mem_wb_reverse) begin 
		debug_first_wdata=mem_wb_lite_wRegData;
		debug_first_wnum=mem_wb_lite_wRegAddr;
		debug_first_wen={4{mem_wb_lite_wRegEn}};
		debug_first_pc=mem_wb_lite_pc;
		debug_second_wdata=mem_wb_pro_wRegData;
		debug_second_wnum=mem_wb_pro_wRegAddr;
		debug_second_wen={4{mem_wb_pro_wRegEn}};
		debug_second_pc=mem_wb_pro_pc;		
	end else begin 
		debug_first_wdata=mem_wb_pro_wRegData;
		debug_first_wnum=mem_wb_pro_wRegAddr;
		debug_first_wen={4{mem_wb_pro_wRegEn}};
		debug_first_pc=mem_wb_pro_pc;
		debug_second_wdata=mem_wb_lite_wRegData;
		debug_second_wnum=mem_wb_lite_wRegAddr;
		debug_second_wen={4{mem_wb_lite_wRegEn}};
		debug_second_pc=mem_wb_lite_pc;
	end
end

//debug
always_ff @(posedge aclk) begin
	if(~aresetn) begin
		countIcacheStall <= 0;
		countDcacheStall <= 0;
		countMultDivStall <= 0;
		countLoadHazStall <= 0;
		countgotoBranch <= 0;
	end else begin
		if(stallFromIcache) countIcacheStall <= countIcacheStall+1;
		if(stallFromDcache) countDcacheStall <= countDcacheStall+1;
		if(multDivStall) countMultDivStall <= countMultDivStall+1;
		if(stallForLoadHaz) countLoadHazStall <= countLoadHazStall+1;
		if(gotoBranch) countgotoBranch <= countgotoBranch+1;
	end
end

always_ff @(posedge aclk) begin
	if(~aresetn) begin
		countIssue0 <= 0;
		countIssue1 <= 0;
		countIssue2 <= 0;
		countIssue3 <= 0;
		countIssue2FifoEmpty<=0;
		countIssue2DataHaz<=0;
	end else begin
		//issue2
		if((issueState==4'd1)|(issueState==4'd4)|(issueState==4'd6)) countIssue2<=countIssue2+1;
		//issue1 for second branch
		if(issueState==4'd2) countIssue1<=countIssue1+1;
		//issue0 for first branch
		if(issueState==4'd8) countIssue0<=countIssue0+1;
		//issue1 for datahazard
		if((issueState==4'd3)|(issueState==4'd5)) countIssue2DataHaz<=countIssue2DataHaz+1;
		//issue1 for 2 complex instr
		if(issueState==4'd7) countIssue3<=countIssue3+1;
		//issue1 for fifoEmpty
		if(issueState==4'd9) countIssue2FifoEmpty<=countIssue2FifoEmpty+1;

	end
end

endmodule