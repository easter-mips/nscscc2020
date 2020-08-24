`include "define.svh"
// `define DEBUG_ICACHE
module mycpu_top (
	input        [        5:0] ext_int          ,
	input                      aresetn          ,
	input                      aclk             ,
	output logic [        3:0] arid             ,
	output logic [       31:0] araddr           ,
	output logic [        3:0] arlen            ,
	output logic [        2:0] arsize           ,
	output logic [        1:0] arburst          ,
	output logic [        0:0] arlock           ,
	output logic [        3:0] arcache          ,
	output logic [        2:0] arprot           ,
	output logic               arvalid          ,
	input                      arready          ,
	input        [        3:0] rid              ,
	input        [   31:0] rdata            ,
	input        [        1:0] rresp            ,
	input                      rlast            ,
	input                      rvalid           ,
	output logic               rready           ,
	output logic [        3:0] awid             ,
	output logic [       31:0] awaddr           ,
	output logic [        3:0] awlen            ,
	output logic [        2:0] awsize           ,
	output logic [        1:0] awburst          ,
	output logic [        1:0] awlock           ,
	output logic [        3:0] awcache          ,
	output logic [        2:0] awprot           ,
	output logic               awvalid          ,
	input                      awready          ,
	output logic [        3:0] wid              ,
	output logic [   31:0] wdata            ,
	output logic [        3:0] wstrb            ,
	output logic               wlast            ,
	output logic               wvalid           ,
	input                      wready           ,
	input        [        3:0] bid              ,
	input        [        1:0] bresp            ,
	input                      bvalid           ,
	output logic               bready         ,
	output logic [31:0] debug_wb_pc,
	output logic [3 :0] debug_wb_rf_wen,
	output logic [4 :0] debug_wb_rf_wnum,
	output logic [31:0] debug_wb_rf_wdata
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
assign debug_first_wdata=naked_cpu.debug_first_wdata;
assign debug_first_wnum=naked_cpu.debug_first_wnum;
assign debug_first_wen=naked_cpu.debug_first_wen;
assign debug_first_pc=naked_cpu.debug_first_pc;
assign debug_second_wdata=naked_cpu.debug_second_wdata;
assign debug_second_wnum=naked_cpu.debug_second_wnum;
assign debug_second_wen=naked_cpu.debug_second_wen;
assign debug_second_pc=naked_cpu.debug_second_pc;
assign countIssue0=naked_cpu.countIssue0;
assign countIssue1=naked_cpu.countIssue1;
assign countIssue2=naked_cpu.countIssue2;
assign countIssue3=naked_cpu.countIssue3;
assign countIcacheStall=naked_cpu.countIcacheStall;
assign countDcacheStall=naked_cpu.countDcacheStall;
assign countMultDivStall=naked_cpu.countMultDivStall;
assign countLoadHazStall=naked_cpu.countLoadHazStall;
assign countgotoBranch=naked_cpu.countgotoBranch;
assign countIssue2DataHaz=naked_cpu.countIssue2DataHaz;
assign countIssue2FifoEmpty=naked_cpu.countIssue2FifoEmpty;

logic [        3:0] pt_arid             ;
logic [       31:0] pt_araddr           ;
logic [        3:0] pt_arlen            ;
logic [        2:0] pt_arsize           ;
logic [        1:0] pt_arburst          ;
logic [        1:0] pt_arlock           ;
logic [        3:0] pt_arcache          ;
logic [        2:0] pt_arprot           ;
logic               pt_arvalid          ;
logic                      pt_arready          ;
logic        [        3:0] pt_rid              ;
logic        [   31:0] pt_rdata            ;
logic        [        1:0] pt_rresp            ;
logic                      pt_rlast            ;
logic                      pt_rvalid           ;
logic               pt_rready           ;
logic [        3:0] pt_awid             ;
logic [       31:0] pt_awaddr           ;
logic [        3:0] pt_awlen            ;
logic [        2:0] pt_awsize           ;
logic [        1:0] pt_awburst          ;

logic [        1:0] pt_awlock           ;

logic [        3:0] pt_awcache          ;
logic [        2:0] pt_awprot           ;
logic               pt_awvalid          ;
logic                      pt_awready          ;
logic [        3:0] pt_wid              ;
logic [   31:0] pt_wdata            ;
logic [        3:0] pt_wstrb            ;
logic               pt_wlast            ;
logic               pt_wvalid           ;
logic                      pt_wready           ;
logic        [        3:0] pt_bid              ;
logic        [        1:0] pt_bresp            ;
logic                      pt_bvalid           ;
logic               pt_bready         ;

logic [        3:0] df_arid             ;
logic [       31:0] df_araddr           ;
logic [        3:0] df_arlen            ;
logic [        2:0] df_arsize           ;
logic [        1:0] df_arburst          ;
logic [        1:0] df_arlock           ;
logic [        3:0] df_arcache          ;
logic [        2:0] df_arprot           ;
logic               df_arvalid          ;
logic                      df_arready          ;
logic        [        3:0] df_rid              ;
logic        [   31:0] df_rdata            ;
logic        [        1:0] df_rresp            ;
logic                      df_rlast            ;
logic                      df_rvalid           ;
logic               df_rready           ;
logic [        3:0] df_awid             ;
logic [       31:0] df_awaddr           ;
logic [        3:0] df_awlen            ;
logic [        2:0] df_awsize           ;
logic [        1:0] df_awburst          ;
logic [        1:0] df_awlock           ;
logic [        3:0] df_awcache          ;
logic [        2:0] df_awprot           ;
logic               df_awvalid          ;
logic                      df_awready          ;
logic [        3:0] df_wid              ;
logic [   31:0] df_wdata            ;
logic [        3:0] df_wstrb            ;
logic               df_wlast            ;
logic               df_wvalid           ;
logic                      df_wready           ;
logic        [        3:0] df_bid              ;
logic        [        1:0] df_bresp            ;
logic                      df_bvalid           ;
logic               df_bready         ;


logic [        3:0] inst_arid             ;
logic [       31:0] inst_araddr           ;
logic [        3:0] inst_arlen            ;
logic [        2:0] inst_arsize           ;
logic [        1:0] inst_arburst          ;
logic [        1:0] inst_arlock           ;
logic [        3:0] inst_arcache          ;
logic [        2:0] inst_arprot           ;
logic               inst_arvalid          ;
logic                      inst_arready          ;
logic        [        3:0] inst_rid              ;
logic        [   31:0] inst_rdata            ;
logic        [        1:0] inst_rresp            ;
logic                      inst_rlast            ;
logic                      inst_rvalid           ;
logic               inst_rready           ;
logic [        3:0] inst_awid             ;
logic [       31:0] inst_awaddr           ;
logic [        3:0] inst_awlen            ;
logic [        2:0] inst_awsize           ;
logic [        1:0] inst_awburst          ;
logic [        1:0] inst_awlock           ;

logic [        3:0] inst_awcache          ;
logic [        2:0] inst_awprot           ;
logic               inst_awvalid          ;
logic                      inst_awready          ;
logic [        3:0] inst_wid              ;
logic [   31:0] inst_wdata            ;
logic [        3:0] inst_wstrb            ;
logic               inst_wlast            ;
logic               inst_wvalid           ;
logic                      inst_wready           ;
logic        [        3:0] inst_bid              ;
logic        [        1:0] inst_bresp            ;
logic                      inst_bvalid           ;
logic               inst_bready         ;

logic [        3:0] data_arid             ;
logic [       31:0] data_araddr           ;
logic [        3:0] data_arlen            ;
logic [        2:0] data_arsize           ;
logic [        1:0] data_arburst          ;
logic [        1:0] data_arlock           ;
logic [        3:0] data_arcache          ;
logic [        2:0] data_arprot           ;
logic               data_arvalid          ;
logic                      data_arready          ;
logic        [        3:0] data_rid              ;
logic        [   31:0] data_rdata            ;
logic        [        1:0] data_rresp            ;
logic                      data_rlast            ;
logic                      data_rvalid           ;
logic               data_rready           ;
logic [        3:0] data_awid             ;
logic [       31:0] data_awaddr           ;
logic [        3:0] data_awlen            ;
logic [        2:0] data_awsize           ;
logic [        1:0] data_awburst          ;
logic [        0:0] data_awlock           ;
logic [        3:0] data_awcache          ;
logic [        2:0] data_awprot           ;
logic               data_awvalid          ;
logic                      data_awready          ;
logic [        3:0] data_wid              ;
logic [   31:0] data_wdata            ;
logic [        3:0] data_wstrb            ;
logic               data_wlast            ;
logic               data_wvalid           ;
logic                      data_wready           ;
logic        [        3:0] data_bid              ;
logic        [        1:0] data_bresp            ;
logic                      data_bvalid           ;
logic               data_bready         ;

logic inst1ok_cached;
logic inst2ok_cached;

logic inst2ok_uncached;
logic inst1ok_uncached;

logic stallFromDcache;
logic stallFromIcache;
logic [31:0] inst1_cached;
logic [31:0] inst2_cached;

logic [31:0] inst1_uncached;
logic [31:0] inst2_uncached;

logic [31:0] iaddr;
logic [31:0] drdata_cached;
logic [31:0] drdata_uncached;
logic [31:0] ex_mem_pro_wdata;
logic [31:0] ex_mem_pro_addr;
logic [3:0] ex_mem_pro_wstrb;

logic [ 2:0]ex_mem_pro_wsize;

logic ex_mem_pro_memEn_uncached;
logic ex_mem_pro_memEn_cached;
logic ex_mem_pro_rwmem;
logic [ 2:0]ex_mem_pro_rsize;
logic stallFromDcache_cached;
logic stallFromDcache_uncached;
logic iEn_cached;
logic iEn_uncached;
//logic [4:0]ex_mem_cacheInst;
assign stallFromDcache=stallFromDcache_cached|stallFromDcache_uncached;
// assign stallFromIcache=(iwaitForMem&iEn_uncached)|(~inst1ok_cached&iEn_cached);
assign stallFromIcache=((~inst1ok_uncached)&iEn_uncached)|(~inst1ok_cached&iEn_cached);
// !!!!! DEBUG I-CACHE !!!!!
// `ifdef DEBUG_ICACHE
// // assign stallFromIcache=((~inst1ok_uncached)&iEn_uncached)|(~inst1ok_cached&iEn_cached);
// assign stallFromICache = inst1ok_cached;
// `else
// assign stallFromIcache=((~inst1ok_uncached)&iEn_uncached)|(~inst1ok_cached&iEn_cached);
// `endif
// !!!!! END DEBUG I-CACHE !!!!!
// assign instok_uncached=~iwaitForMem;

logic [11:0] icache_index_v;
logic [11:0] dcache_index_v;

logic [7:0] full_arlen;
logic [7:0] full_awlen;
assign arlen=full_arlen[4:0];
assign awlen=full_awlen[4:0];

// fuse read and write signals into one
logic dwen;
assign dwen=~ex_mem_pro_rwmem;

logic[31:0] cache_data_hit_count;
logic[31:0] cache_data_miss_count;
cache cache0

( 	.clock(aclk),

	.resetn(aresetn),
	.inst1_o(inst1_cached),
	.inst2_o(inst2_cached),
	.inst1_valid_o(inst1ok_cached),
	.inst2_valid_o(inst2ok_cached),
	.inst_addr_i(iaddr),
`ifdef DEBUG_ICACHE
    .inst_en_i(1'b1),
`else
    .inst_en_i(iEn_cached), // I-cache enable
`endif
	.data_wait_o(stallFromDcache_cached),
    .dhit_count(cache_data_hit_count),
    .dmiss_count(cache_data_miss_count),
    .cache_inst_i(5'b0), // cache instruction input
	.rdata_valid_o(drdatavalid),
	.den_i(ex_mem_pro_memEn_cached),
	.dwen_i(dwen),
	.drsize_i(ex_mem_pro_rsize),
	.dwsize_i(ex_mem_pro_wsize),
	.wstrb_i(ex_mem_pro_wstrb),
	.dwdata_i(ex_mem_pro_wdata),
	.drwaddr_i(ex_mem_pro_addr),
	.drdata_o(drdata_cached),

//     // inst AXI interface,
    .inst_axi_awid_o(inst_awid),
    .inst_axi_awaddr_o(inst_awaddr),
    .inst_axi_awlen_o(inst_awlen),
    .inst_axi_awsize_o(inst_awsize),
    .inst_axi_awburst_o(inst_awburst),
    .inst_axi_awvalid_o(inst_awvalid),
    .inst_axi_awready_i(inst_awready),
    .inst_axi_wid_o(inst_wid),
    .inst_axi_wdata_o(inst_wdata),
    .inst_axi_wstrb_o(inst_wstrb),
    .inst_axi_wlast_o(inst_wlast),
    .inst_axi_wvalid_o(inst_wvalid),
    .inst_axi_wready_i(inst_wready),
    .inst_axi_bready_o(inst_bready),
    .inst_axi_bid_i(inst_bid),
    .inst_axi_bresp_i(inst_bresp),
    .inst_axi_bvalid_i(inst_bvalid),
    .inst_axi_arid_o(inst_arid),
    .inst_axi_araddr_o(inst_araddr),
    .inst_axi_arlen_o(inst_arlen),
    .inst_axi_arsize_o(inst_arsize),
    .inst_axi_arburst_o(inst_arburst),
    .inst_axi_arvalid_o(inst_arvalid),
    .inst_axi_arready_i(inst_arready),
    .inst_axi_rid_i(inst_rid),
    .inst_axi_rdata_i(inst_rdata),
    .inst_axi_rresp_i(inst_rresp),
    .inst_axi_rlast_i(inst_rlast),
    .inst_axi_rvalid_i(inst_rvalid),
    .inst_axi_rready_o(inst_rready),
    // data AXI interface,
    .data_axi_awid_o(data_awid),
    .data_axi_awaddr_o(data_awaddr),
    .data_axi_awlen_o(data_awlen),
    .data_axi_awsize_o(data_awsize),
    .data_axi_awburst_o(data_awburst),
    .data_axi_awvalid_o(data_awvalid),
    .data_axi_awready_i(data_awready),
    .data_axi_wid_o(data_wid),
    .data_axi_wdata_o(data_wdata),
    .data_axi_wstrb_o(data_wstrb),
    .data_axi_wlast_o(data_wlast),
    .data_axi_wvalid_o(data_wvalid),
    .data_axi_wready_i(data_wready),
    .data_axi_bready_o(data_bready),
    .data_axi_bid_i(data_bid),
    .data_axi_bresp_i(data_bresp),
    .data_axi_bvalid_i(data_bvalid),
    .data_axi_arid_o(data_arid),
    .data_axi_araddr_o(data_araddr),
    .data_axi_arlen_o(data_arlen),
    .data_axi_arsize_o(data_arsize),
    .data_axi_arburst_o(data_arburst),
    .data_axi_arvalid_o(data_arvalid),
    .data_axi_arready_i(data_arready),
    .data_axi_rid_i(data_rid),
    .data_axi_rdata_i(data_rdata),
    .data_axi_rresp_i(data_rresp),
    .data_axi_rlast_i(data_rlast),
    .data_axi_rvalid_i(data_rvalid),
    .data_axi_rready_o(data_rready)
    );

`ifdef DEBUG_ICACHE
assign inst1ok_uncached = inst1ok_cached;
assign inst2ok_uncached = inst2ok_cached;
assign inst1_uncached = inst1_cached;
assign inst2_uncached = inst2_cached;
`endif

inst_fetcher direct_fetch0
    ( .clock(aclk), .resetn(aresetn)
`ifdef DEBUG_ICACHE
    , .en(1'b0)
`else
    , .en(iEn_uncached)
`endif
    , .addr_i(iaddr)
`ifndef DEBUG_ICACHE
    , .inst1valid_o(inst1ok_uncached)
    , .inst1_o(inst1_uncached)
    , .inst2valid_o(inst2ok_uncached)
    , .inst2_o(inst2_uncached)
`endif

    , .axi_awid(df_awid)
    , .axi_wid(df_wid)
    , .axi_awaddr(df_awaddr)
    , .axi_awlen(df_awlen)
    , .axi_awsize(df_awsize)
    , .axi_awburst(df_awburst)
    , .axi_awlock(df_awlock)
    , .axi_awcache(df_awcache)
    , .axi_awprot(df_awprot)
    // , .axi_awqos(df_awqos)
    , .axi_awvalid(df_awvalid)
    , .axi_awready(df_awready)
    , .axi_wdata(df_wdata)
    , .axi_wstrb(df_wstrb)
    , .axi_wlast(df_wlast)
    , .axi_wvalid(df_wvalid)
    , .axi_wready(df_wready)
    , .axi_bid(df_bid)
    , .axi_bresp(df_bresp)
    , .axi_bvalid(df_bvalid)
    , .axi_bready(df_bready)
    , .axi_arid(df_arid)
    , .axi_araddr(df_araddr)
    , .axi_arlen(df_arlen)
    , .axi_arsize(df_arsize)
    , .axi_arburst(df_arburst)
    , .axi_arlock(df_arlock)
    , .axi_arcache(df_arcache)
    , .axi_arprot(df_arprot)
    // , .axi_arqos(df_arqos)
    , .axi_arvalid(df_arvalid)
    , .axi_arready(df_arready)
    , .axi_rid(df_rid)
    , .axi_rdata(df_rdata)
    , .axi_rresp(df_rresp)
    , .axi_rlast(df_rlast)
    , .axi_rvalid(df_rvalid)
    , .axi_rready(df_rready)
    );


//mem data pass through, without cache
sramtoaxi inst_sramtoaxi (
	.clk         (aclk),
	.aresetn     (aresetn),
	.dwdata      (ex_mem_pro_wdata),
	.dwaddr      (ex_mem_pro_addr),
	.dwstrb      (ex_mem_pro_wstrb),
	.dwsize      (ex_mem_pro_wsize),
	.dmemEn      (ex_mem_pro_memEn_uncached),
	.drwmem      (ex_mem_pro_rwmem),
	.drsize      (ex_mem_pro_rsize),
	.draddr      (ex_mem_pro_addr),
	.dwaitForMem (stallFromDcache_uncached),
	.drdata_uncached(drdata_uncached),
	.awid        (pt_awid),
	.awaddr      (pt_awaddr),
	.awlen       (pt_awlen),
	.awsize      (pt_awsize),
	.awburst     (pt_awburst),
	.awlock      (pt_awlock),
	.awcache     (pt_awcache),
	.awprot      (pt_awprot),
	.awvalid     (pt_awvalid),
	.awready     (pt_awready),
	.wid         (pt_wid),
	.wdata       (pt_wdata),
	.wstrb       (pt_wstrb),
	.wlast       (pt_wlast),
	.wvalid      (pt_wvalid),
	.wready      (pt_wready),
	.bid         (pt_bid),
	.bresp       (pt_bresp),
	.bvalid      (pt_bvalid),
	.bready      (pt_bready),
	.arid        (pt_arid),
	.araddr      (pt_araddr),
	.arlen       (pt_arlen),
	.arsize      (pt_arsize),
	.arburst     (pt_arburst),
	.arlock      (pt_arlock),
	.arcache     (pt_arcache),
	.arprot      (pt_arprot),
	.arvalid     (pt_arvalid),
	.arready     (pt_arready),
	.rid         (pt_rid),
	.rdata       (pt_rdata),
	.rresp       (pt_rresp),
	.rlast       (pt_rlast),
	.rvalid      (pt_rvalid),
	.rready      (pt_rready)
	);

cpu naked_cpu
(
	.ext_int                   (ext_int),
	.aresetn                   (aresetn),
	.aclk                      (aclk),
	.inst1ok_cached           (inst1ok_cached),
	.inst2ok_cached           (inst2ok_cached),

	.inst1ok_uncached          (inst1ok_uncached),
    .inst2ok_uncached(inst2ok_uncached),
	.inst1_cached             (inst1_cached),
	.inst2_cached             (inst2_cached),
	.inst1_uncached            (inst1_uncached),
    .inst2_uncached(inst2_uncached),

	.iEn_uncached             (iEn_uncached),
	.iEn_cached               (iEn_cached),
	.stallFromDcache           (stallFromDcache),
	.stallFromIcache           (stallFromIcache),
	.iaddr                     (iaddr),
	.drdata_cached             (drdata_cached),
	.drdata_uncached           (drdata_uncached),
	.ex_mem_pro_wdata          (ex_mem_pro_wdata),
	.ex_mem_pro_addr           (ex_mem_pro_addr),
	.ex_mem_pro_wstrb          (ex_mem_pro_wstrb),
	.ex_mem_pro_wsize          (ex_mem_pro_wsize),
	.memEn_uncached (ex_mem_pro_memEn_uncached),
	.memEn_cached   (ex_mem_pro_memEn_cached),
	.ex_mem_pro_rwmem          (ex_mem_pro_rwmem),
	.ex_mem_pro_rsize          (ex_mem_pro_rsize)
    //,
    //.ex_mem_cacheInst(ex_mem_cacheInst)
	);

axi_crossbar_4x1 crossbar0(

    .aclk(aclk),
	.aresetn(aresetn),
	.s_axi_awid({ data_awid, inst_awid, pt_awid, df_awid }),
	.s_axi_awaddr({ data_awaddr, inst_awaddr, pt_awaddr, df_awaddr }),
	.s_axi_awlen({ data_awlen, inst_awlen, pt_awlen, df_awlen }),
	.s_axi_awsize({ data_awsize, inst_awsize, pt_awsize, df_awsize }),
	.s_axi_awburst({ data_awburst, inst_awburst, pt_awburst, df_awburst }),
	.s_axi_awlock(8'b0),
	.s_axi_awcache(16'hffff),
	.s_axi_awprot(12'h0),
	.s_axi_awqos(16'h0),
	.s_axi_awvalid({ data_awvalid, inst_awvalid, pt_awvalid, df_awvalid }),
	.s_axi_awready({ data_awready, inst_awready, pt_awready, df_awready }),
    .s_axi_wid({ data_wid, inst_wid, pt_wid, df_wid }),
	.s_axi_wdata({ data_wdata, inst_wdata, pt_wdata, df_wdata }),
	.s_axi_wstrb({ data_wstrb, inst_wstrb, pt_wstrb, df_wstrb }),
//	.s_axi_wid    ({data_wid,inst_wid,pt_wid,df_wid}),
    .s_axi_wlast({ data_wlast, inst_wlast, pt_wlast, df_wlast }),
	.s_axi_wvalid({ data_wvalid, inst_wvalid, pt_wvalid, df_wvalid }),
	.s_axi_wready({ data_wready, inst_wready, pt_wready, df_wready }),
	.s_axi_bid({ data_bid,inst_bid, pt_bid, df_bid }),
	.s_axi_bresp({ data_bresp, inst_bresp, pt_bresp, df_bresp }),
	.s_axi_bvalid({ data_bvalid,inst_bvalid, pt_bvalid, df_bvalid }),
	.s_axi_bready({ data_bready, inst_bready, pt_bready, df_bready }),
	.s_axi_arid({ data_arid, inst_arid, pt_arid, df_arid }),
	.s_axi_araddr({ data_araddr, inst_araddr, pt_araddr, df_araddr }),
	.s_axi_arlen({ data_arlen, inst_arlen, pt_arlen, df_arlen }),
	.s_axi_arsize({ data_arsize, inst_arsize, pt_arsize, df_arsize }),
	.s_axi_arburst({ data_arburst, inst_arburst, pt_arburst, df_arburst }),
	.s_axi_arlock(8'b0),
	.s_axi_arcache(16'hffff),
	.s_axi_arprot(12'b0),
	.s_axi_arqos(16'h0),
	.s_axi_arvalid({ data_arvalid, inst_arvalid, pt_arvalid, df_arvalid }),
	.s_axi_arready({ data_arready, inst_arready, pt_arready, df_arready }),
	.s_axi_rid({ data_rid, inst_rid, pt_rid, df_rid }),
	.s_axi_rdata({ data_rdata, inst_rdata, pt_rdata, df_rdata }),
	.s_axi_rresp({ data_rresp, inst_rresp, pt_rresp, df_rresp }),
	.s_axi_rlast({ data_rlast, inst_rlast, pt_rlast, df_rlast }),
	.s_axi_rvalid({ data_rvalid, inst_rvalid, pt_rvalid, df_rvalid }),
	.s_axi_rready({ data_rready, inst_rready, pt_rready, df_rready }),
	.m_axi_arid(arid),
	.m_axi_araddr(araddr),
	.m_axi_arlen(arlen),

	.m_axi_arsize(arsize),
	.m_axi_arburst(arburst),
	.m_axi_arlock(arlock),
	.m_axi_arcache(arcache),
	.m_axi_arprot(arprot),
	.m_axi_arvalid(arvalid),
	.m_axi_arready(arready),
	.m_axi_rid(rid),
	.m_axi_rdata(rdata),

	.m_axi_rresp(rresp),

	.m_axi_rlast(rlast),
	.m_axi_rvalid(rvalid),
	.m_axi_rready(rready),
	.m_axi_awid(awid),

    .m_axi_wid(wid),
	.m_axi_awaddr(awaddr),
	.m_axi_awlen(awlen),

	.m_axi_awsize(awsize),
	.m_axi_awburst(awburst),
	.m_axi_awlock(awlock),
	.m_axi_awcache(awcache),
	.m_axi_awprot(awprot),
	.m_axi_awvalid(awvalid),
	.m_axi_awready(awready),

    .m_axi_arqos  (m_axi_arqos),
    .m_axi_awqos  (m_axi_awqos),
//    .m_axi_wid    (wid),

	.m_axi_wdata(wdata),
	.m_axi_wstrb(wstrb),
	.m_axi_wlast(wlast),
	.m_axi_wvalid(wvalid),
	.m_axi_wready(wready),
	.m_axi_bid(bid),
	.m_axi_bresp(bresp),
	.m_axi_bvalid(bvalid),
	.m_axi_bready(bready)
	);

endmodule
