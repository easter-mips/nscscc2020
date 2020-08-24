`include "cache.vh"
module icache_controller
    ( input  clock, resetn, en_i
    , input [31:0] inst_addr_i
    , input  axi_arready_i
    , input [3:0] axi_rid_i
    , input [31:0] axi_rdata_i
    , input  axi_rlast_i
    , input  axi_rvalid_i
    , input [31:0] bank_data_i_0_0
    , input [31:0] bank_data_i_0_1
    , input [31:0] bank_data_i_0_2
    , input [31:0] bank_data_i_0_3
    , input [31:0] bank_data_i_0_4
    , input [31:0] bank_data_i_0_5
    , input [31:0] bank_data_i_0_6
    , input [31:0] bank_data_i_0_7
    , input [31:0] bank_data_i_1_0
    , input [31:0] bank_data_i_1_1
    , input [31:0] bank_data_i_1_2
    , input [31:0] bank_data_i_1_3
    , input [31:0] bank_data_i_1_4
    , input [31:0] bank_data_i_1_5
    , input [31:0] bank_data_i_1_6
    , input [31:0] bank_data_i_1_7
    , input [3:0] action_i

    , output logic [31:0] inst_1_o
    , output logic [31:0] inst_2_o
    , output logic  inst_1_valid
    , output logic  inst_2_valid
    , output logic [3:0] axi_arid_o
    , output logic [31:0] axi_araddr_o
    , output logic  axi_arvalid_o
    , output logic  axi_rready_o
    , output logic [`SET_BUS] bank_set_addr_o
    , output logic [31:0] bank_data_o_0
    , output logic [31:0] bank_data_o_1
    , output logic [31:0] bank_data_o_2
    , output logic [31:0] bank_data_o_3
    , output logic [31:0] bank_data_o_4
    , output logic [31:0] bank_data_o_5
    , output logic [31:0] bank_data_o_6
    , output logic [31:0] bank_data_o_7
    , output logic [7:0] bank_wen_o_0
    , output logic [7:0] bank_wen_o_1

      // prefetch
    , output logic need_prefetch_o
    , output logic pf_ack_o
    , input[`LINE_ADDR_BUS] pf_addr_i
    , input pf_ready_i
    , input pf_fetching_i
    , input[`INST_BUS] pf_inst_i_0
    , input[`INST_BUS] pf_inst_i_1
    , input[`INST_BUS] pf_inst_i_2
    , input[`INST_BUS] pf_inst_i_3
    , input[`INST_BUS] pf_inst_i_4
    , input[`INST_BUS] pf_inst_i_5
    , input[`INST_BUS] pf_inst_i_6
    , input[`INST_BUS] pf_inst_i_7
    );

`define IC_STATE_BUS 1:0
parameter S_IDLE =  2'b00;
parameter S_ADDR = 2'b10;
parameter S_RECV = 2'b11;
parameter S_EXT = 2'b01;

logic[`IC_STATE_BUS] state = S_IDLE;
logic[`IC_STATE_BUS] next_state;


logic[`ADDR_BUS] axi_addr;
logic[7:0] axi_read_valid = 0;
logic[`BANK_BUS] axi_next_bank = 0;
logic[`INST_BUS] axi_bank_buf[7:0];
logic axi_invalid = 0;

logic[`ADDR_BUS] req_addr;
logic requested;

logic[255:0] lru = 0;

wire[`TAG_BUS] tag_i;
wire[`SET_BUS] set_i;
wire[`BANK_BUS] bank_i;
assign {tag_i, set_i, bank_i} = inst_addr_i[31:2];

wire[`TAG_BUS] axi_tag;
wire[`SET_BUS] axi_set;
wire[`BANK_BUS] axi_bank;
assign {axi_tag, axi_set, axi_bank} = axi_addr[31:2];

wire[`TAG_BUS] req_tag;
wire[`SET_BUS] req_set;
wire[`BANK_BUS] req_bank;
assign {req_tag, req_set, req_bank} = req_addr[31:2];

logic[`TAG_BUS] tag_0[255:0];
logic[`TAG_BUS] tag_1[255:0];

logic[255:0] valid_0 = 0;
logic[255:0] valid_1 = 0;
// assign tvvalid_i_0 = valid_0[bank_set_addr_o];
// assign tvvalid_i_1 = valid_1[bank_set_addr_o];

`define IC_OSTATE_BUS 3:0
parameter OS_NO_OUTPUT = 0;
parameter OS_KNOWN1 = 1;
parameter OS_KNOWN2 = 2;
parameter OS_READ = 3;

logic[`IC_OSTATE_BUS] ostate = OS_NO_OUTPUT;
logic[`IC_OSTATE_BUS] next_ostate;

logic[`INST_BUS] os_known_inst1 = 0;
logic[`INST_BUS] next_os_known_inst1;
logic[`INST_BUS] os_known_inst2 = 0;
logic[`INST_BUS] next_os_known_inst2;

logic os_read_way = 0;
logic next_os_read_way;
logic[2:0] os_read_bank = 0;
logic[2:0] next_os_read_bank;

logic[`ADDR_BUS] the_addr;
assign the_addr = requested ? req_addr : inst_addr_i;

logic[`TAG_BUS] the_tag;
logic[`SET_BUS] the_set;
logic[`BANK_BUS] the_bank;
assign { the_tag, the_set, the_bank } = the_addr[31:2];

logic action_addr; // 1: index, 0: hit
logic action_inv; // 1: invalid
logic action_store; // 1: store
logic action_wb; // 1: writeback
assign { action_addr, action_inv, action_store, action_wb } = action_i;
logic action_valid;
assign action_valid = |action_i[2:0];

function hit_way_0(input[`SET_BUS] set, input[`TAG_BUS] tag);
    return tag_0[set] == tag && valid_0[set];
endfunction

function hit_way_1(input[`SET_BUS] set, input[`TAG_BUS] tag);
    return tag_1[set] == tag && valid_1[set];
endfunction

logic action_hit_way_0;
logic action_hit_way_1;
assign action_hit_way_0 = hit_way_0(set_i, tag_i);
assign action_hit_way_1 = hit_way_1(set_i, tag_i);

logic action_hit_axi;
assign action_hit_axi = inst_addr_i[`LINE_ADDR_SLICE] == axi_addr[`LINE_ADDR_SLICE] && (state == S_ADDR || state == S_RECV);

assign axi_arid_o = 4'b0000;
always_comb begin
    next_state = S_IDLE;
    next_ostate = OS_NO_OUTPUT;
    next_os_known_inst1 = 0;
    next_os_known_inst2 = 0;
    next_os_read_way = 0;
    next_os_read_bank = 0;
    
    inst_1_o = 0; inst_1_valid = 0;
    inst_2_o = 0; inst_2_valid = 0;
    axi_araddr_o = 0; axi_arvalid_o = 0;
    axi_rready_o = 0;

    // bank_set_addr_o = 0;
    bank_data_o_0 = 0;
    bank_data_o_1 = 0;
    bank_data_o_2 = 0;
    bank_data_o_3 = 0;
    bank_data_o_4 = 0;
    bank_data_o_5 = 0;
    bank_data_o_6 = 0;
    bank_data_o_7 = 0;
    bank_wen_o_0 = 0;
    bank_wen_o_1 = 0;

    need_prefetch_o = 0;
    pf_ack_o = 0;
    bank_set_addr_o = the_set;
    
    if (!resetn) begin
    end else begin
        // check whether need prefetch
        // if (en_i && inst_addr_i[1:0] == 2'b00 && !hit_way_0(set_i + 1, tag_i) && !hit_way_1(set_i + 1, tag_i)) begin
        //     need_prefetch_o = 1;
        // end

        case (ostate)
            OS_NO_OUTPUT: begin
                inst_1_o = 0;
                inst_2_o = 0;
            end
            OS_KNOWN1: begin
                inst_1_o = os_known_inst1;
                inst_2_o = 0;
            end
            OS_KNOWN2: begin
                inst_1_o = os_known_inst1;
                inst_2_o = os_known_inst2;
            end
            OS_READ: begin
                if (os_read_way == 0) begin // read Way 0
                    case (os_read_bank)
                        3'b000: begin
                            inst_1_o = bank_data_i_0_0;
                            inst_2_o = bank_data_i_0_1;
                        end
                        3'b001: begin
                            inst_1_o = bank_data_i_0_1;
                            inst_2_o = bank_data_i_0_2;
                        end
                        3'b010: begin
                            inst_1_o = bank_data_i_0_2;
                            inst_2_o = bank_data_i_0_3;
                        end
                        3'b011: begin
                            inst_1_o = bank_data_i_0_3;
                            inst_2_o = bank_data_i_0_4;
                        end
                        3'b100: begin
                            inst_1_o = bank_data_i_0_4;
                            inst_2_o = bank_data_i_0_5;
                        end
                        3'b101: begin
                            inst_1_o = bank_data_i_0_5;
                            inst_2_o = bank_data_i_0_6;
                        end
                        3'b110: begin
                            inst_1_o = bank_data_i_0_6;
                            inst_2_o = bank_data_i_0_7;
                        end
                        3'b111: begin
                            inst_1_o = bank_data_i_0_7;
                        end
                    endcase
                end else begin
                    case (os_read_bank)
                        3'b000: begin
                            inst_1_o = bank_data_i_1_0;
                            inst_2_o = bank_data_i_1_1;
                        end
                        3'b001: begin
                            inst_1_o = bank_data_i_1_1;
                            inst_2_o = bank_data_i_1_2;
                        end
                        3'b010: begin
                            inst_1_o = bank_data_i_1_2;
                            inst_2_o = bank_data_i_1_3;
                        end
                        3'b011: begin
                            inst_1_o = bank_data_i_1_3;
                            inst_2_o = bank_data_i_1_4;
                        end
                        3'b100: begin
                            inst_1_o = bank_data_i_1_4;
                            inst_2_o = bank_data_i_1_5;
                        end
                        3'b101: begin
                            inst_1_o = bank_data_i_1_5;
                            inst_2_o = bank_data_i_1_6;
                        end
                        3'b110: begin
                            inst_1_o = bank_data_i_1_6;
                            inst_2_o = bank_data_i_1_7;
                        end
                        3'b111: begin
                            inst_1_o = bank_data_i_1_7;
                        end
                    endcase
                end
            end
        endcase
        case(state)
            S_IDLE: begin
                if (!en_i && !requested) begin
                    // do nothing
                end else if (the_addr[1:0] != 2'b00) begin
                    // invalid addr
                    inst_1_valid = 1;
                    inst_2_valid = 1;
                    next_ostate = OS_KNOWN2; 
                    next_os_known_inst1 = 0; next_os_known_inst2 = 0;
                    next_state = S_IDLE;
                end else if (the_addr != inst_addr_i) begin
                    // input addr has changed
                    inst_1_valid = 0;
                    inst_2_valid = 0;
                end else begin
                    if (tag_0[the_set] == the_tag && valid_0[the_set]) begin
                        // hit way 0
                        if (the_bank == 3'b111) begin
                            inst_1_valid = 1;
                            inst_2_valid = 0;
                        end else begin
                            inst_1_valid = 1;
                            inst_2_valid = 1;
                        end
                        next_ostate = OS_READ;
                        next_os_read_way = 0;
                        next_os_read_bank = the_bank;
                    end else if (tag_1[the_set] == the_tag && valid_1[the_set]) begin
                        // hit way 1
                        if (the_bank == 3'b111) begin
                            inst_1_valid = 1;
                            inst_2_valid = 0;
                        end else begin
                            inst_1_valid = 1;
                            inst_2_valid = 1;
                        end
                        next_ostate = OS_READ;
                        next_os_read_way = 1;
                        next_os_read_bank = the_bank;
                    // end else if (pf_addr_i == the_addr[`LINE_ADDR_SLICE] && pf_fetching_i) begin
                        // just wait
                    // end else if (pf_addr_i == the_addr[`LINE_ADDR_SLICE] && pf_ready_i) begin
                    //     // prefetched
                    //     pf_ack_o = 1;
                    //     if (!valid_0[the_set] || (valid_1[the_set] && lru[the_set] == 0)) begin
                    //         bank_wen_o_0 = 8'hff;
                    //         bank_wen_o_1 = 0;
                    //         bank_data_o_0 = pf_inst_i_0;
                    //         bank_data_o_1 = pf_inst_i_1;
                    //         bank_data_o_2 = pf_inst_i_2;
                    //         bank_data_o_3 = pf_inst_i_3;
                    //         bank_data_o_4 = pf_inst_i_4;
                    //         bank_data_o_5 = pf_inst_i_5;
                    //         bank_data_o_6 = pf_inst_i_6;
                    //         bank_data_o_7 = pf_inst_i_7;
                    //     end else begin
                    //         bank_wen_o_1 = 8'hff;
                    //         bank_wen_o_0 = 0;
                    //         bank_data_o_0 = pf_inst_i_0;
                    //         bank_data_o_1 = pf_inst_i_1;
                    //         bank_data_o_2 = pf_inst_i_2;
                    //         bank_data_o_3 = pf_inst_i_3;
                    //         bank_data_o_4 = pf_inst_i_4;
                    //         bank_data_o_5 = pf_inst_i_5;
                    //         bank_data_o_6 = pf_inst_i_6;
                    //         bank_data_o_7 = pf_inst_i_7;
                    //     end
                    //     inst_1_valid = 1;
                    //     inst_2_valid = the_bank != 3'b111;
                    //     next_ostate = the_bank == 3'b111 ? OS_KNOWN1 : OS_KNOWN2;
                    //     case (the_bank)
                    //         3'b000: begin
                    //             next_os_known_inst1 = pf_inst_i_0;
                    //             next_os_known_inst2 = pf_inst_i_1;
                    //         end
                    //         3'b001: begin
                    //             next_os_known_inst1 = pf_inst_i_1;
                    //             next_os_known_inst2 = pf_inst_i_2;
                    //         end
                    //         3'b010: begin
                    //             next_os_known_inst1 = pf_inst_i_2;
                    //             next_os_known_inst2 = pf_inst_i_3;
                    //         end
                    //         3'b011: begin
                    //             next_os_known_inst1 = pf_inst_i_3;
                    //             next_os_known_inst2 = pf_inst_i_4;
                    //         end
                    //         3'b100: begin
                    //             next_os_known_inst1 = pf_inst_i_4;
                    //             next_os_known_inst2 = pf_inst_i_5;
                    //         end
                    //         3'b101: begin
                    //             next_os_known_inst1 = pf_inst_i_5;
                    //             next_os_known_inst2 = pf_inst_i_6;
                    //         end
                    //         3'b110: begin
                    //             next_os_known_inst1 = pf_inst_i_6;
                    //             next_os_known_inst2 = pf_inst_i_7;
                    //         end
                    //         3'b111: begin
                    //             next_os_known_inst1 = pf_inst_i_7;
                    //         end
                    //     endcase
                    end else begin
                        // miss
                        next_state = S_ADDR;
                    end
                end
            end

            S_ADDR: begin
                // AXI control signals
                axi_araddr_o = axi_addr;
                axi_arvalid_o = 1;

                if (axi_arvalid_o && axi_arready_i) begin
                    next_state = S_RECV;
                end else begin
                    next_state = S_ADDR;
                end
            end
            S_RECV: begin
                // delay 1 clock

                axi_rready_o = 1;

                if (!requested && en_i && inst_addr_i[1:0] == 2'b00 && inst_addr_i[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && axi_read_valid[bank_i]) begin
                    // direct buffered hit
                    if (bank_i != 3'b111 && axi_read_valid[bank_i + 1]) begin
                        inst_1_valid = 1;
                        inst_2_valid = 1;
                        
                        next_ostate = OS_KNOWN2;
                        next_os_known_inst1 = axi_bank_buf[bank_i];
                        next_os_known_inst2 = axi_bank_buf[bank_i + 1];
                    end else begin
                        inst_1_valid = 1;
                        inst_2_valid = 0;
                        
                        next_ostate = OS_KNOWN1;
                        next_os_known_inst1 = axi_bank_buf[bank_i];
                        next_os_known_inst2 = 0;
                    end
                end else if (!requested && en_i && inst_addr_i[1:0] == 2'b00 && inst_addr_i[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && bank_i == axi_next_bank) begin
                    if (axi_rready_o && axi_rvalid_i) begin
                        inst_1_valid = 1;
                        inst_2_valid = 0;

                        next_ostate = OS_KNOWN1;
                        next_os_known_inst1 = axi_rdata_i;
                    end
                end else if (!requested && en_i && set_i != axi_set && tag_0[set_i] == tag_i && valid_0[set_i] && !axi_rlast_i) begin
                    // hit without set conflict
                    // bank_set_addr_o = set_i;
                    inst_1_valid = 1;
                    inst_2_valid = bank_i != 3'b111;
                    next_ostate = OS_READ;
                    next_os_read_way = 0;
                    next_os_read_bank = bank_i;
                end else if (!requested && en_i && set_i != axi_set && tag_1[set_i] == tag_i && valid_1[set_i] && !axi_rlast_i) begin
                    // hit without set conflict
                    // bank_set_addr_o = set_i;
                    inst_1_valid = 1;
                    inst_2_valid = bank_i != 3'b111;
                    next_ostate = OS_READ;
                    next_os_read_way = 1;
                    next_os_read_bank = bank_i;
                end else if (requested && req_addr[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && axi_read_valid[req_bank]) begin
                    if (req_bank != 3'b111 && axi_read_valid[req_bank + 1]) begin
                        inst_1_valid = 1;
                        inst_2_valid = 1;
                        
                        next_ostate = OS_KNOWN2;
                        next_os_known_inst1 = axi_bank_buf[req_bank];
                        next_os_known_inst2 = axi_bank_buf[req_bank + 1];
                    end else begin
                        inst_1_valid = 1;
                        inst_2_valid = 0;
                        
                        next_ostate = OS_KNOWN1;
                        next_os_known_inst1 = axi_bank_buf[req_bank];
                        next_os_known_inst2 = 0;
                    end

                    // WORKAROUND for syscall
                    if (req_addr != inst_addr_i) begin
                        inst_1_valid = 0;
                        inst_2_valid = 0;
                    end
                end else if (requested && req_addr[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && req_bank == axi_next_bank) begin
                    if (axi_rready_o && axi_rvalid_i) begin
                        inst_1_valid = 1;
                        inst_2_valid = 0;

                        next_ostate = OS_KNOWN1;
                        next_os_known_inst1 = axi_rdata_i;

                        // WORKAROUND for syscall

                        if (req_addr != inst_addr_i) begin
                            inst_1_valid = 0;
                            inst_2_valid = 0;
                        end
                    end
                end else begin
                    if (!requested && en_i && inst_addr_i[1:0] != 2'b00) begin
                        inst_1_valid = 1;
                        inst_2_valid = 1;
                        next_ostate = OS_NO_OUTPUT;
                    end
                end

                // if (axi_rready_o && axi_rvalid_i) begin
                //     if (!tvvalid_i_0) begin
                //         bank_wen_o_0 = 8'hff;
                //         bank_wen_o_1 = 0;
                //         bank_sel_o = axi_read_count;
                //         bdata_o = rdata_i;
                //     end else if (!tvvalid_i_1) begin
                //         bwen_o_0 = 0;
                //         bwen_o_1 = 1;
                //         bank_sel_o = axi_read_count;
                //         bdata_o = rdata_i;
                //     end else begin
                //         bwen_o_0 = !lru[axi_set];
                //         bwen_o_1 = lru[axi_set];
                //         bank_sel_o = axi_read_count;
                //         bdata_o = rdata_i;
                //     end
                // end else begin
                //     bwen_o_0 = 0;
                //     bwen_o_1 = 0;
                //     bank_sel_o = 0;
                //     bdata_o = 0;
                // end

                if (axi_rready_o && axi_rvalid_i && axi_rlast_i) begin
                    bank_set_addr_o = axi_set;
                    // tdata_o = axi_tag;
                    // twen_o_0 = !lru[axi_set];
                    // twen_o_1 = lru[axi_set];

                    // wait at the last trans
                    // next_buf_wait_o = 1;
                    // next_buf_data_o = 0;
                    bank_data_o_0 = axi_bank_buf[0];
                    bank_data_o_1 = axi_bank_buf[1];
                    bank_data_o_2 = axi_bank_buf[2];
                    bank_data_o_3 = axi_bank_buf[3];
                    bank_data_o_4 = axi_bank_buf[4];
                    bank_data_o_5 = axi_bank_buf[5];
                    bank_data_o_6 = axi_bank_buf[6];
                    bank_data_o_7 = axi_bank_buf[7];
                    case (axi_next_bank)
                        3'b000: begin
                            bank_data_o_0 = axi_rdata_i;
                        end
                        3'b001: begin
                            bank_data_o_1 = axi_rdata_i;
                        end
                        3'b010: begin
                            bank_data_o_2 = axi_rdata_i;
                        end
                        3'b011: begin
                            bank_data_o_3 = axi_rdata_i;
                        end
                        3'b100: begin
                            bank_data_o_4 = axi_rdata_i;
                        end
                        3'b101: begin
                            bank_data_o_5 = axi_rdata_i;
                        end
                        3'b110: begin
                            bank_data_o_6 = axi_rdata_i;
                        end
                        3'b111: begin
                            bank_data_o_7 = axi_rdata_i;
                        end
                    endcase
                    if (!valid_0[axi_set]) begin
                        bank_wen_o_0 = 8'hff;
                        bank_wen_o_1 = 0;
                    end else if (!valid_1[axi_set]) begin
                        bank_wen_o_0 = 0;
                        bank_wen_o_1 = 8'hff;
                    end else if (lru[axi_set] == 0) begin
                        bank_wen_o_0 = 8'hff;
                        bank_wen_o_1 = 0;
                    end else if (lru[axi_set] == 1) begin
                        bank_wen_o_0 = 0;
                        bank_wen_o_1 = 8'hff;
                    end
                end else begin
                    // tdata_o = 0;
                    // twen_o_0 = 0;
                    // twen_o_1 = 0;
                end

                if (axi_rready_o && axi_rvalid_i && axi_rlast_i) begin
                    next_state = S_IDLE;
                end else begin
                    next_state = S_RECV;
                end
            end

            // no need to add another state
            // S_EXT: begin
            //     if (addr_i == req_addr && req_addr[1:0] !== 2'b00) begin
            //         wait_o = 0;
            //         inst_o = 0;
            //         next_state = S_IDLE;
            //     end else if (addr_i == req_addr) begin
            //         wait_o = 1;
            //         bank_sel_o = req_bank;
            //         bwen_o_0 = 0;
            //         bwen_o_1 = 0;
            //         bdata_o = 0;
            //         inst_o = 0;

            //         saddr_o = req_set;
            //         twen_o_0 = 0;
            //         twen_o_1 = 0;
            //         tdata_o = 0;
            //         next_state = S_IDLE;
            //     end else begin
            //         wait_o = 1;
            //         bank_sel_o = bank_i;
            //         bwen_o_0 = 0;
            //         bwen_o_1 = 0;
            //         bdata_o = 0;
            //         inst_o = 0;

            //         saddr_o = set_i;
            //         twen_o_0 = 0;
            //         twen_o_1 = 0;
            //         tdata_o = 0;
            //         next_state = S_IDLE;                   
            //     end

            //     // if ((tvtag_i_0 == req_tag) && tvvalid_i_0) begin
            //     //     // output data
            //     //     inst_o = bdata_i_0;
            //     //     wait_o = 0;

            //     //     // AXI control signals
            //     //     araddr_o = 0;
            //     //     arvalid_o = 0;
            //     //     rready_o = 0;

            //     //     next_state = S_IDLE;
            //     // end else if ((tvtag_i_1 == req_tag) && tvvalid_i_1) begin
            //     //     // output data
            //     //     inst_o = bdata_i_1;
            //     //     wait_o = 0;

            //     //     // AXI control signals
            //     //     araddr_o = 0;
            //     //     arvalid_o = 0;
            //     //     rready_o = 0;

            //     //     next_state = S_IDLE;
            //     // end else begin
            //     //     // block pipeline
            //     //     inst_o = 0;
            //     //     wait_o = 1;

            //     //     // AXI control signals
            //     //     araddr_o = { req_addr[31:2], 2'b00 };
            //     //     arvalid_o = 1;
            //     //     rready_o = 0;

            //     //     if (arvalid_o && arready_i) begin // handshake success
            //     //         next_state = S_RECV;
            //     //     end else begin // handshake failed
            //     //         next_state = S_ADDR;
            //     //     end
            //     // end
            // end
        endcase
    end
end

always_ff@(posedge clock) begin
    if (!resetn) begin
        requested <= 0;
        valid_0 <= 0;
        valid_1 <= 0;
        state <= S_IDLE;
        ostate <= OS_NO_OUTPUT;
        os_known_inst1 <= 0;
        os_known_inst2 <= 0;
        os_read_way <= 0;
        os_read_bank <= 0;

        axi_read_valid = 0;
        axi_next_bank = 0;
    end else begin
        state <= next_state;
        ostate <= next_ostate;
        os_known_inst1 <= next_os_known_inst1;
        os_known_inst2 <= next_os_known_inst2;
        os_read_way <= next_os_read_way;
        os_read_bank <= next_os_read_bank;

        // cache inst
        if (action_valid) begin
            if (action_addr == 1'b0) begin // hit addressing
                if (action_hit_way_0) begin
                    valid_0[set_i] <= 0;
                end
                if (action_hit_way_1) begin
                    valid_1[set_i] <= 0;
                end
                if (action_hit_axi) begin
                    axi_invalid <= 1;
                end
            end else begin // index addressing
                if (tag_i[0] == 0) begin
                    valid_0[set_i] <= 0;
                end else begin
                    valid_1[set_i] <= 0;
                end
            end
        end

        case(state)
            S_IDLE: begin
                requested <= 0;
                if (!en_i && !requested) begin
                end else if (the_addr[1:0] != 2'b00) begin
                end else if (the_addr != inst_addr_i) begin
                end else if ((tag_0[the_set] == the_tag) && valid_0[the_set]) begin
                    lru[the_set] <= 1;
                end else if ((tag_1[the_set] == the_tag) && valid_1[the_set]) begin
                    lru[the_set] <= 0;
                // end else if (pf_addr_i == the_addr[`LINE_ADDR_SLICE] && pf_fetching_i) begin
                //     // just wait
                // end else if (pf_addr_i == the_addr[`LINE_ADDR_SLICE] && pf_ready_i) begin
                //     if (!valid_0[the_set] || (valid_1[the_set] && lru[the_set] == 0)) begin
                //         lru[the_set] <= 1;
                //         valid_0[the_set] <= 1;
                //         tag_0[the_set] <= the_tag;
                //     end else begin
                //         lru[the_set] <= 0;
                //         valid_1[the_set] <= 1;
                //         tag_1[the_set] <= the_tag;
                //     end
                end else begin
                    // pipeline query is interrupted
                    requested <= 1;
                    req_addr <= the_addr;
                    axi_addr <= the_addr;
                    axi_next_bank <= the_bank;
                    axi_invalid <= 0;
                end
            end
            S_ADDR: begin
                if (axi_arvalid_o && axi_arready_i) begin
                    axi_read_valid <= 0;
                end 
            end
            S_RECV: begin
                if (!requested && en_i && inst_addr_i[1:0] == 2'b00 && inst_addr_i[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && axi_read_valid[bank_i]) begin
                    // DO NOTHING
                end else if (!requested && en_i && inst_addr_i[1:0] == 2'b00 && inst_addr_i[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && bank_i == axi_next_bank) begin
                    if (axi_rready_o && axi_rvalid_i) begin
                        // DO NOTHING
                    end else begin
                        requested <= 1;
                        req_addr <= inst_addr_i;
                    end
                end else if (!requested && en_i && set_i != axi_set && tag_0[set_i] == tag_i && valid_0[set_i] && !axi_rlast_i) begin
                    // hit without set conflict
                    lru[set_i] <= 1;
                end else if (!requested && en_i && set_i != axi_set && tag_1[set_i] == tag_i && valid_1[set_i] && !axi_rlast_i) begin
                    // hit without set conflict
                    lru[set_i] <= 0;
                end else if (requested && req_addr[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && axi_read_valid[req_bank]) begin
                    requested <= 0;
                end else if (requested && req_addr[`BLOCK_ADDR_SLICE] == axi_addr[`BLOCK_ADDR_SLICE] && req_bank == axi_next_bank) begin
                    if (axi_rready_o && axi_rvalid_i) begin
                        requested <= 0;
                    end 
                end else begin
                    if (!requested && en_i && inst_addr_i[1:0] == 2'b00) begin
                        req_addr <= inst_addr_i;
                        requested <= 1;
                    end
                end
                
                if (axi_rready_o && axi_rvalid_i && axi_rlast_i) begin
                    if (!valid_0[axi_set]) begin
                        lru[axi_set] <= 1;
                        valid_0[axi_set] <= !axi_invalid && !(action_valid && !action_addr && action_hit_axi);
                        tag_0[axi_set] <= axi_tag;
                    end else if (!valid_1[axi_set]) begin
                        lru[axi_set] <= 0;
                        valid_1[axi_set] <= !axi_invalid && !(action_valid && !action_addr && action_hit_axi);
                        tag_1[axi_set] <= axi_tag;
                    end else begin
                        if (lru[axi_set] == 0) begin
                            valid_0[axi_set] <= !axi_invalid && !(action_valid && !action_addr && action_hit_axi);
                            tag_0[axi_set] <= axi_tag;
                        end else begin
                            valid_1[axi_set] <= !axi_invalid && !(action_valid && !action_addr && action_hit_axi);
                            tag_1[axi_set] <= axi_tag;
                        end
                        lru[axi_set] <= !lru[axi_set];
                    end
                end

                if (axi_rready_o && axi_rvalid_i) begin
                    axi_bank_buf[axi_next_bank] <= axi_rdata_i;
                    axi_read_valid[axi_next_bank] <= 1;
                    axi_next_bank <= axi_next_bank + 1;
                end
            end
        endcase
    end
end

endmodule // icache_controller
