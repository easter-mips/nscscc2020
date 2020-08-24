`include "cache.vh"

module cache #(parameter WAY_NUM = 2)
(
    input clock, resetn,

    // inst cache interface with CPU
    output logic[`INST_BUS] inst1_o,
    output logic[`INST_BUS] inst2_o,
    output logic inst1_valid_o,
    output logic inst2_valid_o,
    input[`ADDR_BUS] inst_addr_i,
    input inst_en_i,

    output logic data_wait_o,
    output logic rdata_valid_o,

    input[4:0] cache_inst_i,

    // interface with MEM module
    input den_i,
    input dwen_i,
    input[2:0] drsize_i,
    input[2:0] dwsize_i,
    input[3:0] wstrb_i,
    input[`DATA_BUS] dwdata_i,
    input[`ADDR_BUS] drwaddr_i,
    output logic[`DATA_BUS] drdata_o,
    output[31:0] dhit_count,
    output[31:0] dmiss_count,

    // I-cache axi interface
    // write address channel
    output logic[3:0] inst_axi_awid_o,
    output logic[`ADDR_BUS] inst_axi_awaddr_o,
    output logic[3:0] inst_axi_awlen_o,
    output logic[2:0] inst_axi_awsize_o,
    output logic[1:0] inst_axi_awburst_o,
    output logic inst_axi_awvalid_o,
    input inst_axi_awready_i,
    // write data channel
    output logic[3:0] inst_axi_wid_o,
    output logic[`DATA_BUS] inst_axi_wdata_o,
    output logic[3:0] inst_axi_wstrb_o,
    output logic inst_axi_wlast_o,
    output logic inst_axi_wvalid_o,
    input logic inst_axi_wready_i,
    // write response channel
    output logic inst_axi_bready_o,
    input[3:0] inst_axi_bid_i,
    input[1:0] inst_axi_bresp_i,
    input inst_axi_bvalid_i,

    // read address channel
    output logic[3:0] inst_axi_arid_o,
    output logic[31:0] inst_axi_araddr_o,
    output logic[3:0] inst_axi_arlen_o,
    output logic[2:0] inst_axi_arsize_o,
    output logic[1:0] inst_axi_arburst_o,
    output logic inst_axi_arvalid_o,
    input inst_axi_arready_i,
    // read data channel
    input[3:0] inst_axi_rid_i,
    input[`DATA_BUS] inst_axi_rdata_i,
    input[1:0] inst_axi_rresp_i,
    input inst_axi_rlast_i,
    input inst_axi_rvalid_i,
    output logic inst_axi_rready_o,
    
    // D-cache axi interface
    // write address channel
    output logic[3:0] data_axi_awid_o,
    output logic[`ADDR_BUS] data_axi_awaddr_o,
    output logic[3:0] data_axi_awlen_o,
    output logic[2:0] data_axi_awsize_o,
    output logic[1:0] data_axi_awburst_o,
    output logic data_axi_awvalid_o,
    input data_axi_awready_i,
    // write data channel
    output logic[3:0] data_axi_wid_o,
    output logic[`DATA_BUS] data_axi_wdata_o,
    output logic[3:0] data_axi_wstrb_o,
    output logic data_axi_wlast_o,
    output logic data_axi_wvalid_o,
    input logic data_axi_wready_i,
    // write response channel
    output logic data_axi_bready_o,
    input[3:0] data_axi_bid_i,
    input[1:0] data_axi_bresp_i,
    input data_axi_bvalid_i,

    // read address channel
    output logic[3:0] data_axi_arid_o,
    output logic[31:0] data_axi_araddr_o,
    output logic[3:0] data_axi_arlen_o,
    output logic[2:0] data_axi_arsize_o,
    output logic[1:0] data_axi_arburst_o,
    output logic data_axi_arvalid_o,
    input data_axi_arready_i,
    // read data channel
    input[3:0] data_axi_rid_i,
    input[`DATA_BUS] data_axi_rdata_i,
    input[1:0] data_axi_rresp_i,
    input data_axi_rlast_i,
    input data_axi_rvalid_i,
    output logic data_axi_rready_o
);

logic[`SET_BUS] ic_saddr_o;
logic[7:0] ic_bwen_o_0;
logic[7:0] ic_bwen_o_1;
logic[`INST_BUS] ic_bdata_o_0;
logic[`INST_BUS] ic_bdata_o_1;
logic[`INST_BUS] ic_bdata_o_2;
logic[`INST_BUS] ic_bdata_o_3;
logic[`INST_BUS] ic_bdata_o_4;
logic[`INST_BUS] ic_bdata_o_5;
logic[`INST_BUS] ic_bdata_o_6;
logic[`INST_BUS] ic_bdata_o_7;
logic[`INST_BUS] ic_bdata_i_0_0;
logic[`INST_BUS] ic_bdata_i_0_1;
logic[`INST_BUS] ic_bdata_i_0_2;
logic[`INST_BUS] ic_bdata_i_0_3;
logic[`INST_BUS] ic_bdata_i_0_4;
logic[`INST_BUS] ic_bdata_i_0_5;
logic[`INST_BUS] ic_bdata_i_0_6;
logic[`INST_BUS] ic_bdata_i_0_7;
logic[`INST_BUS] ic_bdata_i_1_0;
logic[`INST_BUS] ic_bdata_i_1_1;
logic[`INST_BUS] ic_bdata_i_1_2;
logic[`INST_BUS] ic_bdata_i_1_3;
logic[`INST_BUS] ic_bdata_i_1_4;
logic[`INST_BUS] ic_bdata_i_1_5;
logic[`INST_BUS] ic_bdata_i_1_6;
logic[`INST_BUS] ic_bdata_i_1_7;

logic[3:0] icache_inst;
logic[3:0] dcache_inst;
assign icache_inst = cache_inst_i[4] == 1'b0 ? cache_inst_i[3:0] : 4'b0;
assign dcache_inst = cache_inst_i[4] == 1'b1 ? cache_inst_i[3:0] : 4'b0;

logic[`ADDR_BUS] ic_araddr_o;
logic[3:0] ic_arid_o;
logic ic_arvalid_o;
logic ic_arready_i;

logic[3:0] ic_rid_i;
logic[`INST_BUS] ic_rdata_i;
logic ic_rlast_i;
logic ic_rvalid_i;
logic ic_rready_o;

logic[`LINE_ADDR_BUS] pf_addr_i;
logic pf_need_prefetch_i;
logic pf_ack_i;
logic[`LINE_ADDR_BUS] pf_addr_o;
logic pf_ready_o;
logic pf_fetching_o;
logic[`INST_BUS] pf_inst_o_0;
logic[`INST_BUS] pf_inst_o_1;
logic[`INST_BUS] pf_inst_o_2;
logic[`INST_BUS] pf_inst_o_3;
logic[`INST_BUS] pf_inst_o_4;
logic[`INST_BUS] pf_inst_o_5;
logic[`INST_BUS] pf_inst_o_6;
logic[`INST_BUS] pf_inst_o_7;
logic[`ADDR_BUS] pf_araddr_o;
logic pf_arvalid_o;
logic pf_arready_i;
logic[`INST_BUS] pf_rdata_i;
logic pf_rvalid_i;
logic pf_rlast_i;
logic pf_rready_o;

assign pf_addr_i = inst_addr_i[`LINE_ADDR_SLICE] + 1;


// prefetch prefetch0
//     ( .clock(clock), .resetn(resetn)
//     , .line_addr_i(pf_addr_i)
//     // , .need_prefetch_i(pf_need_prefetch_i)
//     , .need_prefetch_i(1'b0)
//     , .pf_ack_i(pf_ack_i)
//     , .pf_addr_o(pf_addr_o)
//     , .pf_ready_o(pf_ready_o)
//     , .pf_fetching_o(pf_fetching_o)
//     , .pf_inst_o_0(pf_inst_o_0)
//     , .pf_inst_o_1(pf_inst_o_1)
//     , .pf_inst_o_2(pf_inst_o_2)
//     , .pf_inst_o_3(pf_inst_o_3)
//     , .pf_inst_o_4(pf_inst_o_4)
//     , .pf_inst_o_5(pf_inst_o_5)
//     , .pf_inst_o_6(pf_inst_o_6)
//     , .pf_inst_o_7(pf_inst_o_7)

//     , .axi_araddr_o(pf_araddr_o)
//     , .axi_arvalid_o(pf_arvalid_o)
//     , .axi_arready_i(pf_arready_i)
//     , .axi_rdata_i(pf_rdata_i)
//     , .axi_rvalid_i(pf_rvalid_i)
//     , .axi_rlast_i(pf_rlast_i)
//     , .axi_rready_o(pf_rready_o)
//     );

// ICache icache0
//     ( .clock(clock), .reset(~resetn)
//     , .io_enable(inst_en_i)
//     , .io_iAddr(inst_addr_i)
//     , .io_inst1(inst1_o)
//     , .io_inst2(inst2_o)
//     , .io_inst1Valid(inst1_valid_o)
//     , .io_inst2Valid(inst2_valid_o)
//     , .io_action(icache_inst)

//     , .io_axiReadAddrOut_arid(ic_arid_o)
//     , .io_axiReadAddrOut_araddr(ic_araddr_o)
//     , .io_axiReadAddrOut_arvalid(ic_arvalid_o)
//     , .io_axiReadAddrIn_arready(ic_arready_i)
//     , .io_axiReadOut_rready(ic_rready_o)
//     , .io_axiReadIn_rid(ic_rid_i)
//     , .io_axiReadIn_rdata(ic_rdata_i)
//     , .io_axiReadIn_rlast(ic_rlast_i)
//     , .io_axiReadIn_rvalid(ic_rvalid_i)
//     );


icache_controller icache0
    ( .clock(clock)
    , .inst_addr_i(inst_addr_i)
    , .resetn(resetn)
    , .en_i(inst_en_i)
    , .axi_arready_i(ic_arready_i)
    , .axi_rid_i(ic_rid_i)
    , .axi_rdata_i(ic_rdata_i)
    , .axi_rlast_i(ic_rlast_i)
    , .axi_rvalid_i(ic_rvalid_i)
    , .action_i(icache_inst)
    , .bank_data_i_0_0(ic_bdata_i_0_0)
    , .bank_data_i_0_1(ic_bdata_i_0_1)
    , .bank_data_i_0_2(ic_bdata_i_0_2)
    , .bank_data_i_0_3(ic_bdata_i_0_3)
    , .bank_data_i_0_4(ic_bdata_i_0_4)
    , .bank_data_i_0_5(ic_bdata_i_0_5)
    , .bank_data_i_0_6(ic_bdata_i_0_6)
    , .bank_data_i_0_7(ic_bdata_i_0_7)
    , .bank_data_i_1_0(ic_bdata_i_1_0)
    , .bank_data_i_1_1(ic_bdata_i_1_1)
    , .bank_data_i_1_2(ic_bdata_i_1_2)
    , .bank_data_i_1_3(ic_bdata_i_1_3)
    , .bank_data_i_1_4(ic_bdata_i_1_4)
    , .bank_data_i_1_5(ic_bdata_i_1_5)
    , .bank_data_i_1_6(ic_bdata_i_1_6)
    , .bank_data_i_1_7(ic_bdata_i_1_7)

    , .inst_1_o(inst1_o)
    , .inst_2_o(inst2_o)
    , .inst_1_valid(inst1_valid_o)
    , .inst_2_valid(inst2_valid_o)
    , .axi_arid_o(ic_arid_o)
    , .axi_araddr_o(ic_araddr_o)
    , .axi_arvalid_o(ic_arvalid_o)
    , .axi_rready_o(ic_rready_o)
    , .bank_set_addr_o(ic_saddr_o)
    , .bank_data_o_0(ic_bdata_o_0)
    , .bank_data_o_1(ic_bdata_o_1)
    , .bank_data_o_2(ic_bdata_o_2)
    , .bank_data_o_3(ic_bdata_o_3)
    , .bank_data_o_4(ic_bdata_o_4)
    , .bank_data_o_5(ic_bdata_o_5)
    , .bank_data_o_6(ic_bdata_o_6)
    , .bank_data_o_7(ic_bdata_o_7)
    
    , .bank_wen_o_0(ic_bwen_o_0)
    , .bank_wen_o_1(ic_bwen_o_1)

    , .need_prefetch_o(pf_need_prefetch_i)
    , .pf_ack_o(pf_ack_i)
    , .pf_addr_i(32'b0)
    , .pf_ready_i(1'b0)
    , .pf_fetching_i(1'b0)
    , .pf_inst_i_0(pf_inst_o_0)
    , .pf_inst_i_1(pf_inst_o_1)
    , .pf_inst_i_2(pf_inst_o_2)
    , .pf_inst_i_3(pf_inst_o_3)
    , .pf_inst_i_4(pf_inst_o_4)
    , .pf_inst_i_5(pf_inst_o_5)
    , .pf_inst_i_6(pf_inst_o_6)
    , .pf_inst_i_7(pf_inst_o_7)
    );

bank_ram ic_bram_0_0
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[0])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_0)
    , .douta(ic_bdata_i_0_0)
    );

bank_ram ic_bram_0_1
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[1])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_1)
    , .douta(ic_bdata_i_0_1)
    );

bank_ram ic_bram_0_2
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[2])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_2)
    , .douta(ic_bdata_i_0_2)
    );

bank_ram ic_bram_0_3
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[3])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_3)
    , .douta(ic_bdata_i_0_3)
    );

bank_ram ic_bram_0_4
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[4])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_4)
    , .douta(ic_bdata_i_0_4)
    );

bank_ram ic_bram_0_5
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[5])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_5)
    , .douta(ic_bdata_i_0_5)
    );

bank_ram ic_bram_0_6
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[6])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_6)
    , .douta(ic_bdata_i_0_6)
    );

bank_ram ic_bram_0_7
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_0[7])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_7)
    , .douta(ic_bdata_i_0_7)
    );

bank_ram ic_bram_1_0
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[0])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_0)
    , .douta(ic_bdata_i_1_0)
    );

bank_ram ic_bram_1_1
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[1])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_1)
    , .douta(ic_bdata_i_1_1)
    );

bank_ram ic_bram_1_2
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[2])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_2)
    , .douta(ic_bdata_i_1_2)
    );

bank_ram ic_bram_1_3
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[3])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_3)
    , .douta(ic_bdata_i_1_3)
    );

bank_ram ic_bram_1_4
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[4])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_4)
    , .douta(ic_bdata_i_1_4)
    );

bank_ram ic_bram_1_5
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[5])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_5)
    , .douta(ic_bdata_i_1_5)
    );

bank_ram ic_bram_1_6
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[6])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_6)
    , .douta(ic_bdata_i_1_6)
    );

bank_ram ic_bram_1_7
    ( .clka(clock)
    , .ena(1'b1)
    , .wea(ic_bwen_o_1[7])
    , .addra(ic_saddr_o)
    , .dina(ic_bdata_o_7)
    , .douta(ic_bdata_i_1_7)
    );

logic[3:0] dc_bwen[WAY_NUM - 1:0][7:0];
logic[`DATA_BUS] dc_bdata_i[WAY_NUM - 1:0][7:0];
logic[`DATA_BUS] dc_bdata_o[7:0];
logic[`DC_SET_BUS] dc_saddr_o;

genvar i;
for (i = 0; i <= WAY_NUM - 1; i++) begin : dc_bram_block
    genvar j;
    for (j = 0; j <= 7; j++) begin : dc_bram_wayblock
        data_bank_ram dc_bram(
            .clka(clock),
            .ena(1'b1),
            .wea(dc_bwen[i][j]),
            .addra(dc_saddr_o),
            .dina(dc_bdata_o[j]),
            .douta(dc_bdata_i[i][j])
        );
    end
end

logic[2:0] dc_rwsize_i;
logic dc_wait_o;
logic dc_rdatavalid_o;

logic[`ADDR_BUS] dc_araddr_o;
logic dc_arvalid_o;
logic dc_arready_i;
logic[`DATA_BUS] dc_rdata_i;
logic dc_rlast_i;
logic dc_rvalid_i;
logic dc_rready_o;
logic[`DATA_BUS] dc_rdata_o;

logic[`ADDR_BUS] dc_awaddr_o;
logic dc_awvalid_o;
logic dc_awready_i;
logic[`DATA_BUS] dc_wdata_o;
logic dc_wvalid_o;
logic dc_wlast_o;
logic dc_wready_i;

logic dc_bready_o;
logic dc_bvalid_i;
logic[1:0] dc_bresp_i;

// logic[`ADDR_BUS] da_addr_cache;
// logic da_en_cache;
// logic da_wen_cache;
// logic[2:0] da_rwsize_cache;
// logic[3:0] da_wstrb_cache;
// logic[`DATA_BUS] da_wdata_cache;

// dcache_agent dcache_agent0
//     ( .clock(clock), .__reset(1'b0), .__en(1'b1)
//     , .resetn(resetn)

//     // input
//     , .addr_mem(drwaddr_i)
//     , .en_mem(den_i)
//     , .wen_mem(dwen_i)
//     , .rwsize_mem(dc_rwsize_i)
//     , .wstrb_mem(wstrb_i)
//     , .wdata_mem(dwdata_i)
//     , .wait_cache(dc_wait_o)
//     , .rdata_cache(dc_rdata_o)

//     // output
//     , .addr_cache(da_addr_cache)
//     , .en_cache(da_en_cache)
//     , .wen_cache(da_wen_cache)
//     , .rwsize_cache(da_rwsize_cache)
//     , .wstrb_cache(da_wstrb_cache)
//     , .wdata_cache(da_wdata_cache)

//     // direct map to memory output
//     , .wait_mem(data_wait_o)
//     , .rdata_mem(drdata_o)
//     );

logic[`LINE_ADDR_BUS] vc_waddr_i;
logic vc_wvalid_i;
logic[`DATA_BUS] vc_wdata_i[7:0];
logic vc_wready_o;

logic[`LINE_ADDR_BUS] vc_raddr_i;
logic vc_rvalid_i;
logic[`DATA_BUS] vc_rdata_o[7:0];
logic vc_rhit_o;
logic[`ADDR_BUS] vc_axi_awaddr_o;
logic vc_axi_awvalid_o;
logic vc_axi_awready_i;
logic[`DATA_BUS] vc_axi_wdata_o;
logic vc_axi_wvalid_o;
logic vc_axi_wlast_o;
logic vc_axi_wready_i;
logic vc_axi_bready_o;
logic vc_axi_bvalid_i;

victim_cache vcache0
    ( .clock(clock), .resetn(resetn)
    , .waddr_i(vc_waddr_i)
    , .wvalid_i(vc_wvalid_i)
    , .wdata_i(vc_wdata_i)
    , .wready_o(vc_wready_o)

    , .raddr_i(vc_raddr_i)
    , .rdata_o(vc_rdata_o)
    , .rhit_o(vc_rhit_o)

    , .axi_awaddr_o(vc_axi_awaddr_o)
    , .axi_awvalid_o(vc_axi_awvalid_o)
    , .axi_awready_i(vc_axi_awready_i)
    , .axi_wdata_o(vc_axi_wdata_o)
    , .axi_wvalid_o(vc_axi_wvalid_o)
    , .axi_wlast_o(vc_axi_wlast_o)
    , .axi_wready_i(vc_axi_wready_i)
    , .axi_bready_o(vc_axi_bready_o)
    , .axi_bvalid_i(vc_axi_bvalid_i)
    );

logic [31:0] dc_miss_count;
logic [31:0] dc_hit_count;

assign dhit_count = dc_hit_count;
assign dmiss_count = dc_miss_count;

DCache dcache0(
    .clock(clock), .reset(~resetn),
    .io_dAddr(drwaddr_i),
    .io_enable(den_i),
    .io_wEn(dwen_i),
    .io_wData(dwdata_i),
    .io_missCount(dc_miss_count),
    .io_hitCount(dc_hit_count),
    .io_dSize(dc_rwsize_i),
    .io_wStrb(wstrb_i),
    .io_rData(drdata_o),
    .io_dWait(data_wait_o),
    .io_action(dcache_inst),

    .io_bankSetAddr(dc_saddr_o),
    // .bwen_o_0(dc_bwen_0),
    // .bwen_o_1(dc_bwen_1),
    // .bwstrb_o(dc_bwstrb_o),
    .io_bankWEn_0_0(dc_bwen[0][0]),
    .io_bankWEn_0_1(dc_bwen[0][1]),
    .io_bankWEn_0_2(dc_bwen[0][2]),
    .io_bankWEn_0_3(dc_bwen[0][3]),
    .io_bankWEn_0_4(dc_bwen[0][4]),
    .io_bankWEn_0_5(dc_bwen[0][5]),
    .io_bankWEn_0_6(dc_bwen[0][6]),
    .io_bankWEn_0_7(dc_bwen[0][7]),
    .io_bankWEn_1_0(dc_bwen[1][0]),
    .io_bankWEn_1_1(dc_bwen[1][1]),
    .io_bankWEn_1_2(dc_bwen[1][2]),
    .io_bankWEn_1_3(dc_bwen[1][3]),
    .io_bankWEn_1_4(dc_bwen[1][4]),
    .io_bankWEn_1_5(dc_bwen[1][5]),
    .io_bankWEn_1_6(dc_bwen[1][6]),
    .io_bankWEn_1_7(dc_bwen[1][7]),
    // .io_bankWEn_2_0(dc_bwen[2][0]),
    // .io_bankWEn_2_1(dc_bwen[2][1]),
    // .io_bankWEn_2_2(dc_bwen[2][2]),
    // .io_bankWEn_2_3(dc_bwen[2][3]),
    // .io_bankWEn_2_4(dc_bwen[2][4]),
    // .io_bankWEn_2_5(dc_bwen[2][5]),
    // .io_bankWEn_2_6(dc_bwen[2][6]),
    // .io_bankWEn_2_7(dc_bwen[2][7]),
    // .io_bankWEn_3_0(dc_bwen[3][0]),
    // .io_bankWEn_3_1(dc_bwen[3][1]),
    // .io_bankWEn_3_2(dc_bwen[3][2]),
    // .io_bankWEn_3_3(dc_bwen[3][3]),
    // .io_bankWEn_3_4(dc_bwen[3][4]),
    // .io_bankWEn_3_5(dc_bwen[3][5]),
    // .io_bankWEn_3_6(dc_bwen[3][6]),
    // .io_bankWEn_3_7(dc_bwen[3][7]),
    .io_bankDataOut_0(dc_bdata_o[0]),
    .io_bankDataOut_1(dc_bdata_o[1]),
    .io_bankDataOut_2(dc_bdata_o[2]),
    .io_bankDataOut_3(dc_bdata_o[3]),
    .io_bankDataOut_4(dc_bdata_o[4]),
    .io_bankDataOut_5(dc_bdata_o[5]),
    .io_bankDataOut_6(dc_bdata_o[6]),
    .io_bankDataOut_7(dc_bdata_o[7]),
    .io_bankDataIn_0_0(dc_bdata_i[0][0]),
    .io_bankDataIn_0_1(dc_bdata_i[0][1]),
    .io_bankDataIn_0_2(dc_bdata_i[0][2]),
    .io_bankDataIn_0_3(dc_bdata_i[0][3]),
    .io_bankDataIn_0_4(dc_bdata_i[0][4]),
    .io_bankDataIn_0_5(dc_bdata_i[0][5]),
    .io_bankDataIn_0_6(dc_bdata_i[0][6]),
    .io_bankDataIn_0_7(dc_bdata_i[0][7]),
    .io_bankDataIn_1_0(dc_bdata_i[1][0]),
    .io_bankDataIn_1_1(dc_bdata_i[1][1]),
    .io_bankDataIn_1_2(dc_bdata_i[1][2]),
    .io_bankDataIn_1_3(dc_bdata_i[1][3]),
    .io_bankDataIn_1_4(dc_bdata_i[1][4]),
    .io_bankDataIn_1_5(dc_bdata_i[1][5]),
    .io_bankDataIn_1_6(dc_bdata_i[1][6]),
    .io_bankDataIn_1_7(dc_bdata_i[1][7]),
    // .io_bankDataIn_2_0(dc_bdata_i[2][0]),
    // .io_bankDataIn_2_1(dc_bdata_i[2][1]),
    // .io_bankDataIn_2_2(dc_bdata_i[2][2]),
    // .io_bankDataIn_2_3(dc_bdata_i[2][3]),
    // .io_bankDataIn_2_4(dc_bdata_i[2][4]),
    // .io_bankDataIn_2_5(dc_bdata_i[2][5]),
    // .io_bankDataIn_2_6(dc_bdata_i[2][6]),
    // .io_bankDataIn_2_7(dc_bdata_i[2][7]),
    // .io_bankDataIn_3_0(dc_bdata_i[3][0]),
    // .io_bankDataIn_3_1(dc_bdata_i[3][1]),
    // .io_bankDataIn_3_2(dc_bdata_i[3][2]),
    // .io_bankDataIn_3_3(dc_bdata_i[3][3]),
    // .io_bankDataIn_3_4(dc_bdata_i[3][4]),
    // .io_bankDataIn_3_5(dc_bdata_i[3][5]),
    // .io_bankDataIn_3_6(dc_bdata_i[3][6]),
    // .io_bankDataIn_3_7(dc_bdata_i[3][7]),

    .io_axiReadAddrOut_araddr(dc_araddr_o),
    .io_axiReadAddrOut_arvalid(dc_arvalid_o),
    .io_axiReadAddrIn_arready(dc_arready_i),
    .io_axiReadIn_rdata(dc_rdata_i),
    .io_axiReadIn_rlast(dc_rlast_i),
    .io_axiReadIn_rvalid(dc_rvalid_i),
    .io_axiReadOut_rready(dc_rready_o),

    .io_vcWAddr(vc_waddr_i),
    .io_vcWValid(vc_wvalid_i),
    .io_vcWData_0(vc_wdata_i[0]),
    .io_vcWData_1(vc_wdata_i[1]),
    .io_vcWData_2(vc_wdata_i[2]),
    .io_vcWData_3(vc_wdata_i[3]),
    .io_vcWData_4(vc_wdata_i[4]),
    .io_vcWData_5(vc_wdata_i[5]),
    .io_vcWData_6(vc_wdata_i[6]),
    .io_vcWData_7(vc_wdata_i[7]),
    .io_vcReady(vc_wready_o),
    .io_vcRAddr(vc_raddr_i),
    .io_vcRData_0(vc_rdata_o[0]),
    .io_vcRData_1(vc_rdata_o[1]),
    .io_vcRData_2(vc_rdata_o[2]),
    .io_vcRData_3(vc_rdata_o[3]),
    .io_vcRData_4(vc_rdata_o[4]),
    .io_vcRData_5(vc_rdata_o[5]),
    .io_vcRData_6(vc_rdata_o[6]),
    .io_vcRData_7(vc_rdata_o[7]),
    .io_vcHit(vc_rhit_o)
);

// AXI default config
// read channel
assign inst_axi_arlen_o = 4'h7;
assign inst_axi_arsize_o = 3'b010;
assign inst_axi_arburst_o = 2'b10;

assign data_axi_arlen_o = 4'h7;
assign data_axi_arsize_o = 3'b010;
assign data_axi_arburst_o = 2'b10;

assign data_axi_arid_o = 0;
assign data_axi_araddr_o = dc_araddr_o;
assign data_axi_arvalid_o = dc_arvalid_o;
assign dc_arready_i = data_axi_arready_i;
assign dc_rdata_i = data_axi_rdata_i;
assign dc_rvalid_i = data_axi_rvalid_i;
assign dc_rlast_i = data_axi_rlast_i;
assign data_axi_rready_o = dc_rready_o;
// write channel
assign inst_axi_awid_o = 0;
assign inst_axi_awaddr_o = 0;
assign inst_axi_awlen_o = 4'h7;
assign inst_axi_awsize_o = 3'b010;
assign inst_axi_awburst_o = 2'b10;
assign inst_axi_awvalid_o = 0;
assign inst_axi_wid_o = 0;
assign inst_axi_wdata_o = 0;
assign inst_axi_wstrb_o = 0;
assign inst_axi_wvalid_o = 0;
assign inst_axi_wlast_o = 0;
assign inst_axi_bready_o = 0;

assign data_axi_awid_o = 0;
assign data_axi_awaddr_o = vc_axi_awaddr_o;
assign data_axi_awlen_o = 4'h7;
assign data_axi_awsize_o = 3'b010;
assign data_axi_awburst_o = 2'b10;
assign data_axi_awvalid_o = vc_axi_awvalid_o;
assign vc_axi_awready_i = data_axi_awready_i;
assign data_axi_wid_o = 0;
assign data_axi_wdata_o = vc_axi_wdata_o;
assign data_axi_wstrb_o = 4'hf;
assign data_axi_wvalid_o = vc_axi_wvalid_o;
assign data_axi_wlast_o = vc_axi_wlast_o;
assign vc_axi_wready_i = data_axi_wready_i;
assign data_axi_bready_o = vc_axi_bready_o;
assign vc_axi_bvalid_i = data_axi_bvalid_i;

parameter RID_ICACHE = 4'b0000;
parameter RID_PREFETCH = 4'b1111;
always_comb begin
    inst_axi_arid_o = 0;
    inst_axi_arvalid_o = 0;
    inst_axi_araddr_o = 0;

    ic_arready_i = 0;
    pf_arready_i = 0;
    if (ic_arvalid_o) begin
        inst_axi_arid_o = ic_arid_o;
        inst_axi_araddr_o = ic_araddr_o;
        inst_axi_arvalid_o = ic_arvalid_o;

        ic_arready_i = inst_axi_arready_i;
    end else if (pf_arvalid_o) begin
        inst_axi_arid_o = RID_PREFETCH;
        inst_axi_araddr_o = pf_araddr_o;
        inst_axi_arvalid_o = pf_arvalid_o;

        pf_arready_i = inst_axi_arready_i;
    end else begin
        ic_arready_i = inst_axi_arready_i;
        pf_arready_i = inst_axi_arready_i;
    end
end

// // read channel, i-cache first, d-cache next
always_comb begin
    ic_rid_i = 0;
    ic_rdata_i = 0;
    ic_rvalid_i = 0;
    ic_rlast_i = 0;

    pf_rdata_i = 0;
    pf_rvalid_i = 0;
    pf_rlast_i = 0;
    if (inst_axi_rvalid_i && inst_axi_rid_i != RID_PREFETCH) begin
        ic_rid_i = inst_axi_rid_i;
        ic_rdata_i = inst_axi_rdata_i;
        ic_rvalid_i = inst_axi_rvalid_i;
        ic_rlast_i = inst_axi_rlast_i;
    end else if (inst_axi_rvalid_i && inst_axi_rid_i == RID_PREFETCH) begin
        pf_rdata_i = inst_axi_rdata_i;
        pf_rvalid_i = inst_axi_rvalid_i;
        pf_rlast_i = inst_axi_rlast_i;
    end
    inst_axi_rready_o = ic_rready_o | pf_rready_o;
end

// configure rwsize
always_comb begin
    if (dwen_i) begin
        dc_rwsize_i = dwsize_i;
    end else begin
        dc_rwsize_i = drsize_i;
    end
end

assign rdata_valid_o = dc_rdatavalid_o;

endmodule
