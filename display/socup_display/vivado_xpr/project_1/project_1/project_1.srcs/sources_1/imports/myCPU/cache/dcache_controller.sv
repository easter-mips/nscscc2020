`include "cache.vh"
module dcache_controller(
    input clock,
    input resetn,

    // interface with CPU MEM module
    input [`ADDR_BUS] addr_i,
    input en_i,
    input wen_i,
    input[`DATA_BUS] wdata_i,
    input[2:0] rwsize_i,
    input[3:0] wstrb_i,
    output logic[`DATA_BUS] rdata_o,
    output logic wait_o,
    output logic rdatavalid_o,

    // interface with BANK ram
    output logic[`SET_BUS] saddr_o,
    output logic[7:0] bwen_o_0,
    output logic[7:0] bwen_o_1,
    output logic[3:0] bwstrb_o,
    output logic[`DATA_BUS] bdata_o_0,
    output logic[`DATA_BUS] bdata_o_1,
    output logic[`DATA_BUS] bdata_o_2,
    output logic[`DATA_BUS] bdata_o_3,
    output logic[`DATA_BUS] bdata_o_4,
    output logic[`DATA_BUS] bdata_o_5,
    output logic[`DATA_BUS] bdata_o_6,
    output logic[`DATA_BUS] bdata_o_7,
    input [`DATA_BUS] bdata_i_0_0,
    input [`DATA_BUS] bdata_i_0_1,
    input [`DATA_BUS] bdata_i_0_2,
    input [`DATA_BUS] bdata_i_0_3,
    input [`DATA_BUS] bdata_i_0_4,
    input [`DATA_BUS] bdata_i_0_5,
    input [`DATA_BUS] bdata_i_0_6,
    input [`DATA_BUS] bdata_i_0_7,
    input [`DATA_BUS] bdata_i_1_0,
    input [`DATA_BUS] bdata_i_1_1,
    input [`DATA_BUS] bdata_i_1_2,
    input [`DATA_BUS] bdata_i_1_3,
    input [`DATA_BUS] bdata_i_1_4,
    input [`DATA_BUS] bdata_i_1_5,
    input [`DATA_BUS] bdata_i_1_6,
    input [`DATA_BUS] bdata_i_1_7,

    // interface with TAG ram
    // reuse set addr output (saddr_o) for BANK ram
    // input [`TRAM_DATA_BUS] tdata_i_0,
    // input [`TRAM_DATA_BUS] tdata_i_1,
    // output logic twen_o_0,
    // output logic twen_o_1,
    // output logic[`TRAM_DATA_BUS] tdata_o,

    // interface with AXI ram
    // Read address channel
    output logic[`ADDR_BUS] araddr_o,
    output logic arvalid_o,
    input arready_i,
    // Read data channel
    input [`DATA_BUS] rdata_i,
    input rlast_i,
    input rvalid_i,
    output logic rready_o,

    // Write addr channel
    output logic[`ADDR_BUS] awaddr_o,
    output logic awvalid_o,
    input awready_i,
    // Write data channel
    output logic[`DATA_BUS] wdata_o,
    output logic wvalid_o,
    output logic wlast_o,
    input wready_i,
    // Write response channel
    output logic bready_o,
    input bvalid_i,
    input[1:0] bresp_i,

    // interface with victim cache
    output logic[`LINE_ADDR_BUS] vc_waddr_o,
    output logic vc_wvalid_o,
    output logic[`DATA_BUS] vc_wdata_o[7:0],
    input vc_wready_i,
    output logic[`LINE_ADDR_BUS] vc_raddr_o,
    // output logic vc_rvalid_o,
    input[`DATA_BUS] vc_rdata_i[7:0],
    input vc_rhit_i
);

`define DC_STATE_BUS 2:0
`define S_LOOKUP 3'b000
// `define S_WRITE_BANK 3'b110
`define S_RW 3'b101
// `define S_CR_ADDR 3'b001
// `define S_CR_WRITE 3'b010
// `define S_CR_READ 3'b011
// `define S_CR_RESP 3'b111

`define DC_RSTATE_BUS 2:0
`define RS_IDLE 3'b000
`define RS_ADDR 3'b100
`define RS_READ 3'b101
`define RS_FILL 3'b110
`define RS_FINISH 3'b111

`define DC_WSTATE_BUS 2:0
`define WS_IDLE 3'b000
`define WS_SUBMIT 3'b100
`define WS_FINISH 3'b111

logic[`DC_STATE_BUS] state = `S_LOOKUP;
logic[`DC_STATE_BUS] next_state;

logic[`DC_RSTATE_BUS] rstate;
logic[`DC_RSTATE_BUS] next_rstate;

logic[`DC_WSTATE_BUS] wstate;
logic[`DC_WSTATE_BUS] next_wstate;

`define DC_OSTATE_BUS 3:0
parameter OS_NONE = 0;
parameter OS_KNOWN = 1; // in buf_data_o
parameter OS_READ = 2; // in buf_read_way, buf_read_bank
logic[`DC_OSTATE_BUS] ostate = OS_NONE;
logic[`DC_OSTATE_BUS] next_ostate;
logic[`DATA_BUS] os_known_data;
logic[`DATA_BUS] next_os_known_data;
logic os_read_way_id = 0;
logic next_os_read_way_id;
logic[2:0] os_read_way_bank_id = 0;
logic[2:0] next_os_read_way_bank_id;

logic[255:0] lru = 0;

logic[255:0] valid_0 = 0;
logic[255:0] valid_1 = 0;
logic[`TAG_BUS] tag_0[255:0];
logic[`TAG_BUS] tag_1[255:0];
logic[255:0] dirty_0 = 0;
logic[255:0] dirty_1 = 0;

logic requested = 0;
logic[`ADDR_BUS] req_addr = 0;
logic req_wen = 0;
logic[31:0] req_wdata = 0;
logic[2:0] req_size = 0;
logic[3:0] req_strb = 0;

logic[`ADDR_BUS] axi_raddr = 0;
logic axi_rdirty = 0;
logic[`DATA_BUS] axi_rbuf[7:0];
logic[2:0] axi_rcnt = 0;

logic[`ADDR_BUS] axi_waddr = 0;
logic[3:0] axi_wcnt = 0;
logic need_wb = 0;
logic selected = 0;

logic[`ADDR_BUS] prev_addr;
logic prev_wen;
logic[3:0] prev_wstrb;
logic[31:0] prev_wdata;
logic[2:0] prev_rwsize;

// logic[`DATA_BUS] buf_rdata_o = 0;
// logic next_buf_wait_o;
// logic[`DATA_BUS] next_buf_rdata_o;

// temp wires
wire[`TAG_BUS] tag_i;
wire[`SET_BUS] set_i;
wire[`BANK_BUS] bank_i;
assign {tag_i, set_i, bank_i} = addr_i[31:2];

wire[`TAG_BUS] req_tag;
wire[`SET_BUS] req_set;
wire[`BANK_BUS] req_bank;
assign {req_tag, req_set, req_bank} = req_addr[31:2];

wire[`TAG_BUS] axi_rtag;
wire[`SET_BUS] axi_rset;
wire[`BANK_BUS] axi_rbank;
assign {axi_rtag, axi_rset, axi_rbank} = axi_raddr[31:2];

wire[`TAG_BUS] axi_wtag;
wire[`SET_BUS] axi_wset;
wire[`BANK_BUS] axi_wbank;
assign {axi_wtag, axi_wset, axi_wbank} = axi_waddr[31:2];

wire[`TAG_BUS] prev_tag;
wire[`SET_BUS] prev_set;
wire[`BANK_BUS] prev_bank;
assign {prev_tag, prev_set, prev_bank} = prev_addr[31:2];

// temp variable
logic[31:0] bdata;
logic[`ADDR_BUS] the_addr;
logic the_wen;
logic[2:0] the_rwsize;
logic[3:0] the_wstrb;
logic[31:0] the_wdata;

wire[`TAG_BUS] the_tag;
wire[`SET_BUS] the_set;
wire[`BANK_BUS] the_bank;
assign {the_tag, the_set, the_bank} = the_addr[31:2];
assign the_addr = requested ? req_addr : addr_i;
assign the_wen = requested ? req_wen : wen_i;
assign the_rwsize = requested ? req_size : rwsize_i;
assign the_wstrb = requested ? req_strb : wstrb_i;
assign the_wdata = requested ? req_wdata : wdata_i;

function[31:0] write_bank_data(
    input[31:0] bank_data,
    input[31:0] wdata,
    input[2:0] wsize,
    input[3:0] wstrb
);
    logic[31:0] x;
    x = bank_data;

    case (wsize)
        3'b000: begin
            case (wstrb)
                4'h1: begin
                    x[7:0] = wdata[7:0];
                end
                4'h2: begin
                    x[15:8] = wdata[15:8];
                end
                4'h4: begin
                    x[23:16] = wdata[23:16];
                end
                4'h8: begin
                    x[31:24] = wdata[31:24];
                end
            endcase
        end
        3'b001: begin
            case (wstrb)
                4'h3: begin
                    x[15:0] = wdata[15:0];
                end
                4'hc: begin
                    x[31:16] = wdata[31:16];
                end
            endcase
        end
        default: begin
            x = wdata;
        end

    endcase

return x;

endfunction

function[31:0] read_bank_data(input[31:0] bank_data, input[2:0] rsize, input[31:0] addr);
    case (rsize)
        3'b000: begin
            case (addr[1:0])
                2'b00: return { 24'b0, bank_data[7:0] };
                2'b01: return { 24'b0, bank_data[15:8] };
                2'b10: return { 24'b0, bank_data[23:16] };
                2'b11: return { 24'b0, bank_data[31:24] };
                // 2'b00: return { 24'b0, bank_data[7:0] };
                // 2'b01: return { 16'b0, bank_data[15:8], 8'b0 };
                // 2'b10: return { 8'b0, bank_data[23:16], 16'b0 };
                // 2'b11: return { bank_data[31:24], 24'b0 };
            endcase
        end
        3'b001: begin
            case (addr[1:1])
                1'b0: return { 16'b0, bank_data[15:0] };
                1'b1: return { 16'b0, bank_data[31:16] };
                // 1'b0: return { 16'b0, bank_data[15:0] };
                // 1'b1: return { bank_data[31:16], 16'b0 };
            endcase
        end
        default: return bank_data;
    endcase
endfunction

// logic sel_way;
// logic sel_dirty;

assign vc_raddr_o = the_addr[`LINE_ADDR_SLICE];

always_comb begin
    // sel_way = 0;
    // sel_dirty = 0;
    saddr_o = 0;
    bwen_o_0 = 0;
    bwen_o_1 = 0;
    bwstrb_o = 4'hf;
    wait_o = 1;
    rdatavalid_o = 0;
    // twen_o_0 = 0;
    // twen_o_1 = 0;
    // tdata_o = 0;
    araddr_o = 0;
    arvalid_o = 0;
    rready_o = 0;
    awaddr_o = 0;
    awvalid_o = 0;
    wdata_o = 0;
    wvalid_o = 0;
    wlast_o = 0;
    bready_o = 0;
    next_state = `S_LOOKUP;
    next_rstate = `RS_IDLE;
    next_wstate = `WS_IDLE;
    next_ostate = OS_NONE;
    next_os_known_data = 0;
    next_os_read_way_bank_id = 0;
    next_os_read_way_id = 0;
    rdata_o = 0;

    bdata = 0;
    bdata_o_0 = 0;
    bdata_o_1 = 0;
    bdata_o_2 = 0;
    bdata_o_3 = 0;
    bdata_o_4 = 0;
    bdata_o_5 = 0;
    bdata_o_6 = 0;
    bdata_o_7 = 0;

    vc_waddr_o = 0;
    vc_wdata_o = { 0, 0, 0, 0, 0, 0, 0, 0 };
    vc_wvalid_o = 0;
    // vc_raddr_o = 0;
    // vc_rvalid_o = 0;

    if (!resetn) begin
        wait_o = 0;
        next_state = `S_LOOKUP;
    end else begin
        case (ostate)
            OS_NONE: begin
                rdata_o = 0;
            end
            OS_KNOWN: begin
                rdata_o = os_known_data;
            end
            OS_READ: begin
                if (os_read_way_id == 0) begin
                    case (os_read_way_bank_id)
                        3'b000: begin
                            bdata = bdata_i_0_0;
                        end
                        3'b001: begin
                            bdata = bdata_i_0_1;
                        end
                        3'b010: begin
                            bdata = bdata_i_0_2;
                        end
                        3'b011: begin
                            bdata = bdata_i_0_3;
                        end
                        3'b100: begin
                            bdata = bdata_i_0_4;
                        end
                        3'b101: begin
                            bdata = bdata_i_0_5;
                        end
                        3'b110: begin
                            bdata = bdata_i_0_6;
                        end
                        3'b111: begin
                            bdata = bdata_i_0_7;
                        end
                    endcase
                    rdata_o = read_bank_data(bdata, prev_rwsize, prev_addr);
                end else begin
                    case (os_read_way_bank_id)
                        3'b000: begin
                            bdata = bdata_i_1_0;
                        end
                        3'b001: begin
                            bdata = bdata_i_1_1;
                        end
                        3'b010: begin
                            bdata = bdata_i_1_2;
                        end
                        3'b011: begin
                            bdata = bdata_i_1_3;
                        end
                        3'b100: begin
                            bdata = bdata_i_1_4;
                        end
                        3'b101: begin
                            bdata = bdata_i_1_5;
                        end
                        3'b110: begin
                            bdata = bdata_i_1_6;
                        end
                        3'b111: begin
                            bdata = bdata_i_1_7;
                        end
                    endcase
                    rdata_o = read_bank_data(bdata, prev_rwsize, prev_addr);
                end
            end
        endcase 
        case (state)
            `S_LOOKUP: begin
                if (en_i || requested) begin
                    // if (the_addr[31:16] == 16'h1faf) begin
                    //     next_state = `S_CR_ADDR;
                    //     wait_o = 1;
                    // end else begin
                        saddr_o = the_set;
                        // vc_rvalid_o = 1;
                        // vc_raddr_o = the_addr[`LINE_ADDR_SLICE];
                        if (the_tag == tag_0[the_set] && valid_0[the_set]) begin
                            // hit line 0
                            if (!the_wen) begin // read
                                next_ostate = OS_READ;
                                next_os_read_way_id = 0;
                                next_os_read_way_bank_id = the_bank;

                                wait_o = 0;
                                next_state = `S_LOOKUP;
                            end else begin // write
                                next_state = `S_LOOKUP;
                                bwen_o_0 = 0;
                                bwen_o_0[the_bank] = 1;
                                bwen_o_1 = 0;
                                // pass strb to the bank ram
                                bwstrb_o = the_wstrb;
                                case (the_bank)
                                    3'b000: begin
                                        bdata_o_0 = the_wdata;
                                    end
                                    3'b001: begin
                                        bdata_o_1 = the_wdata;
                                    end
                                    3'b010: begin
                                        bdata_o_2 = the_wdata;
                                    end
                                    3'b011: begin
                                        bdata_o_3 = the_wdata;
                                    end
                                    3'b100: begin
                                        bdata_o_4 = the_wdata;
                                    end
                                    3'b101: begin
                                        bdata_o_5 = the_wdata;
                                    end
                                    3'b110: begin
                                        bdata_o_6 = the_wdata;
                                    end
                                    3'b111: begin
                                        bdata_o_7 = the_wdata;
                                    end
                                endcase

                                wait_o = 0;
                            end
                        end else if (the_tag == tag_1[the_set] && valid_1[the_set]) begin
                            // hit line 1
                            if (!the_wen) begin // read
                                next_ostate = OS_READ;
                                next_os_read_way_id = 1;
                                next_os_read_way_bank_id = the_bank;

                                wait_o = 0;
                                next_state = `S_LOOKUP;
                            end else begin // write
                                next_state = `S_LOOKUP;
                                bwen_o_1 = 0;
                                bwen_o_1[the_bank] = 1;
                                bwen_o_0 = 0;
                                bwstrb_o = the_wstrb;
                                case (the_bank)
                                    3'b000: begin
                                        bdata_o_0 = the_wdata;
                                    end
                                    3'b001: begin
                                        bdata_o_1 = the_wdata;
                                    end
                                    3'b010: begin
                                        bdata_o_2 = the_wdata;
                                    end
                                    3'b011: begin
                                        bdata_o_3 = the_wdata;
                                    end
                                    3'b100: begin
                                        bdata_o_4 = the_wdata;
                                    end
                                    3'b101: begin
                                        bdata_o_5 = the_wdata;
                                    end
                                    3'b110: begin
                                        bdata_o_6 = the_wdata;
                                    end
                                    3'b111: begin
                                        bdata_o_7 = the_wdata;
                                    end
                                endcase

                                wait_o = 0;
                            end
                        // end else if (vc_rhit_i) begin
                        //     if (!valid_0[the_set]) begin
                        //         sel_way = 0;
                        //     end else if (!valid_1[the_set]) begin
                        //         sel_way = 1;
                        //     end else begin
                        //         sel_way = lru[the_set];
                        //     end

                        //     sel_dirty = sel_way == 0 ? dirty_0[the_set] : dirty_1[the_set];
                        //     if (!sel_dirty || vc_wready_i) begin
                        //         wait_o = 0;
                        //         if (sel_way == 0) begin
                        //             bwen_o_0 = 8'hff;
                        //             bwen_o_1 = 0;
                        //         end else begin
                        //             bwen_o_1 = 8'hff;
                        //             bwen_o_0 = 0;
                        //         end

                        //         bdata_o_0 = vc_rdata_i[0];
                        //         bdata_o_1 = vc_rdata_i[1];
                        //         bdata_o_2 = vc_rdata_i[2];
                        //         bdata_o_3 = vc_rdata_i[3];
                        //         bdata_o_4 = vc_rdata_i[4];
                        //         bdata_o_5 = vc_rdata_i[5];
                        //         bdata_o_6 = vc_rdata_i[6];
                        //         bdata_o_7 = vc_rdata_i[7];
                                
                        //         if (sel_dirty) begin
                        //             vc_wvalid_o = 1;
                        //             vc_waddr_o = { (sel_way == 0 ? tag_0[the_set] : tag_1[the_set]), the_set };
                        //             vc_wdata_o[0] = sel_way == 0 ? bdata_i_0_0 : bdata_i_1_0;
                        //             vc_wdata_o[1] = sel_way == 0 ? bdata_i_0_1 : bdata_i_1_1;
                        //             vc_wdata_o[2] = sel_way == 0 ? bdata_i_0_2 : bdata_i_1_2;
                        //             vc_wdata_o[3] = sel_way == 0 ? bdata_i_0_3 : bdata_i_1_3;
                        //             vc_wdata_o[4] = sel_way == 0 ? bdata_i_0_4 : bdata_i_1_4;
                        //             vc_wdata_o[5] = sel_way == 0 ? bdata_i_0_5 : bdata_i_1_5;
                        //             vc_wdata_o[6] = sel_way == 0 ? bdata_i_0_6 : bdata_i_1_6;
                        //             vc_wdata_o[7] = sel_way == 0 ? bdata_i_0_7 : bdata_i_1_7;
                        //         end

                        //         if (the_wen) begin
                        //             // write
                        //             case (the_bank)
                        //             3'b000: bdata_o_0 = write_bank_data(vc_rdata_i[0], the_wdata, the_rwsize, the_wstrb);
                        //             3'b001: bdata_o_1 = write_bank_data(vc_rdata_i[1], the_wdata, the_rwsize, the_wstrb);
                        //             3'b010: bdata_o_2 = write_bank_data(vc_rdata_i[2], the_wdata, the_rwsize, the_wstrb);
                        //             3'b011: bdata_o_3 = write_bank_data(vc_rdata_i[3], the_wdata, the_rwsize, the_wstrb);
                        //             3'b100: bdata_o_4 = write_bank_data(vc_rdata_i[4], the_wdata, the_rwsize, the_wstrb);
                        //             3'b101: bdata_o_5 = write_bank_data(vc_rdata_i[5], the_wdata, the_rwsize, the_wstrb);
                        //             3'b110: bdata_o_6 = write_bank_data(vc_rdata_i[6], the_wdata, the_rwsize, the_wstrb);
                        //             3'b111: bdata_o_7 = write_bank_data(vc_rdata_i[7], the_wdata, the_rwsize, the_wstrb);
                        //             endcase
                        //         end else begin
                        //             // read
                        //             next_ostate = OS_KNOWN;
                        //             case (the_bank)
                        //             3'b000: next_os_known_data = vc_rdata_i[0];
                        //             3'b001: next_os_known_data = vc_rdata_i[1];
                        //             3'b010: next_os_known_data = vc_rdata_i[2];
                        //             3'b011: next_os_known_data = vc_rdata_i[3];
                        //             3'b100: next_os_known_data = vc_rdata_i[4];
                        //             3'b101: next_os_known_data = vc_rdata_i[5];
                        //             3'b110: next_os_known_data = vc_rdata_i[6];
                        //             3'b111: next_os_known_data = vc_rdata_i[7];
                        //             endcase
                        //         end
                        //     end else begin
                        //         wait_o = 1;
                        //     end
                        end else begin
                            // miss
                            wait_o = 1;

                            if (!valid_0[the_set]) begin
                                next_wstate = `WS_FINISH;
                            end else if (!valid_1[the_set]) begin
                                next_wstate = `WS_FINISH;
                            end else begin
                                if (lru[the_set] == 0) begin
                                    next_wstate = dirty_0[the_set] ? `WS_SUBMIT : `WS_FINISH;
                                end else begin
                                    next_wstate = dirty_1[the_set] ? `WS_SUBMIT : `WS_FINISH;
                                end
                            end

                            next_rstate = `RS_ADDR;
                            next_state = `S_RW;
                        end
                    // end
                end else begin
                    wait_o = 0;
                end
            end

            // `S_WRITE_BANK: begin
            //     wait_o = 0;
            //     next_state = `S_LOOKUP;
            //     saddr_o = prev_set;

            //     if (prev_tag == tag_0[prev_set] && valid_0[prev_set]) begin
            //         // hit way 0
            //         bwen_o_0 = 0;
            //         bwen_o_0[prev_bank] = 1;
            //         case (prev_bank)
            //             3'b000: begin
            //                 bdata = bdata_i_0_0;
            //             end
            //             3'b001: begin
            //                 bdata = bdata_i_0_1;
            //             end
            //             3'b010: begin
            //                 bdata = bdata_i_0_2;
            //             end
            //             3'b011: begin
            //                 bdata = bdata_i_0_3;
            //             end
            //             3'b100: begin
            //                 bdata = bdata_i_0_4;
            //             end
            //             3'b101: begin
            //                 bdata = bdata_i_0_5;
            //             end
            //             3'b110: begin
            //                 bdata = bdata_i_0_6;
            //             end
            //             3'b111: begin
            //                 bdata = bdata_i_0_7;
            //             end
            //         endcase
            //         bdata = write_bank_data(bdata, prev_wdata, prev_rwsize, prev_wstrb);
            //         case (prev_bank)
            //             3'b000: begin
            //                 bdata_o_0 = bdata;
            //             end
            //             3'b001: begin
            //                 bdata_o_1 = bdata;
            //             end
            //             3'b010: begin
            //                 bdata_o_2 = bdata;
            //             end
            //             3'b011: begin
            //                 bdata_o_3 = bdata;
            //             end
            //             3'b100: begin
            //                 bdata_o_4 = bdata;
            //             end
            //             3'b101: begin
            //                 bdata_o_5 = bdata;
            //             end
            //             3'b110: begin
            //                 bdata_o_6 = bdata;
            //             end
            //             3'b111: begin
            //                 bdata_o_7 = bdata;
            //             end
            //         endcase
            //     end else begin
            //         // hit way 1
            //         bwen_o_1 = 0;
            //         bwen_o_1[prev_bank] = 1;
            //         case (prev_bank)
            //             3'b000: begin
            //                 bdata = bdata_i_1_0;
            //             end
            //             3'b001: begin
            //                 bdata = bdata_i_1_1;
            //             end
            //             3'b010: begin
            //                 bdata = bdata_i_1_2;
            //             end
            //             3'b011: begin
            //                 bdata = bdata_i_1_3;
            //             end
            //             3'b100: begin
            //                 bdata = bdata_i_1_4;
            //             end
            //             3'b101: begin
            //                 bdata = bdata_i_1_5;
            //             end
            //             3'b110: begin
            //                 bdata = bdata_i_1_6;
            //             end
            //             3'b111: begin
            //                 bdata = bdata_i_1_7;
            //             end
            //         endcase
            //         bdata = write_bank_data(bdata, prev_wdata, prev_rwsize, prev_wstrb);
            //         case (prev_bank)
            //             3'b000: begin
            //                 bdata_o_0 = bdata;
            //             end
            //             3'b001: begin
            //                 bdata_o_1 = bdata;
            //             end
            //             3'b010: begin
            //                 bdata_o_2 = bdata;
            //             end
            //             3'b011: begin
            //                 bdata_o_3 = bdata;
            //             end
            //             3'b100: begin
            //                 bdata_o_4 = bdata;
            //             end
            //             3'b101: begin
            //                 bdata_o_5 = bdata;
            //             end
            //             3'b110: begin
            //                 bdata_o_6 = bdata;
            //             end
            //             3'b111: begin
            //                 bdata_o_7 = bdata;
            //             end
            //         endcase
            //     end
            // end

            // `S_CR_ADDR: begin
            //     next_state = `S_CR_ADDR;
            //     if (prev_wen) begin
            //         // write
            //         awaddr_o = axi_waddr;
            //         awvalid_o = 1;

            //         if (awvalid_o && awready_i) begin
            //             next_state = `S_CR_WRITE;
            //         end
            //     end else begin
            //         araddr_o = axi_raddr;
            //         arvalid_o = 1;

            //         if (arvalid_o && arready_i) begin
            //             next_state = `S_CR_READ;
            //         end
            //     end
            // end

            // `S_CR_READ: begin
            //     next_state = `S_CR_READ;
            //     wait_o = 1;
            //     rready_o = 1;

            //     if (rready_o && rvalid_i && rlast_i) begin
            //         wait_o = 0;
            //         rdatavalid_o = 1;
            //         next_ostate = OS_KNOWN;
            //         next_os_known_data = rdata_i;
            //         next_state = `S_LOOKUP;
            //     end
            // end

            // `S_CR_WRITE: begin
            //     next_state = `S_CR_WRITE;
            //     wait_o = 1;
            //     wdata_o = prev_wdata;
            //     wvalid_o = 1;
            //     wlast_o = 1;

            //     if (wvalid_o && wready_i) begin
            //         next_state = `S_CR_RESP;
            //     end
            // end

            // `S_CR_RESP: begin
            //     next_state = `S_CR_RESP;
            //     wait_o = 1;
            //     bready_o = 1;

            //     if (bready_o && bvalid_i) begin
            //         next_state = `S_LOOKUP;
            //         wait_o = 0;
            //         rdatavalid_o = 1;
            //     end
            // end

            `S_RW: begin
                case (wstate)
                //     `WS_ADDR: begin
                //         awaddr_o = axi_waddr;
                //         awvalid_o = 1;
                //         saddr_o = axi_wset;

                //         if (awvalid_o && awready_i) begin
                //             next_wstate = `WS_READ;
                //         end else begin
                //             next_wstate = `WS_ADDR;
                //         end
                //     end

                //     `WS_READ: begin
                //         wlast_o = 0;
                //         bready_o = 0;
                //         if (axi_wcnt != 4'b1000) begin
                //             saddr_o = axi_wset;
                //             wvalid_o = 1;
                //             if (selected == 0) begin
                //                 case (axi_wcnt)
                //                     4'b0000: bdata = bdata_i_0_0;
                //                     4'b0001: bdata = bdata_i_0_1;
                //                     4'b0010: bdata = bdata_i_0_2;
                //                     4'b0011: bdata = bdata_i_0_3;
                //                     4'b0100: bdata = bdata_i_0_4;
                //                     4'b0101: bdata = bdata_i_0_5;
                //                     4'b0110: bdata = bdata_i_0_6;
                //                     4'b0111: bdata = bdata_i_0_7;
                //                 endcase
                //             end else begin
                //                 case (axi_wcnt)
                //                     4'b0000: bdata = bdata_i_1_0;
                //                     4'b0001: bdata = bdata_i_1_1;
                //                     4'b0010: bdata = bdata_i_1_2;
                //                     4'b0011: bdata = bdata_i_1_3;
                //                     4'b0100: bdata = bdata_i_1_4;
                //                     4'b0101: bdata = bdata_i_1_5;
                //                     4'b0110: bdata = bdata_i_1_6;
                //                     4'b0111: bdata = bdata_i_1_7;
                //                 endcase
                //             end
                //             wdata_o = bdata;
                //         end

                //         if (axi_wcnt == 4'b0111) begin
                //             wlast_o = 1;
                //         end

                //         if (axi_wcnt == 4'b1000) begin
                //             wvalid_o = 0;
                //             wlast_o = 0;
                //             bready_o = 1;
                //         end

                //         next_wstate = `WS_READ;
                //         if (axi_wcnt == 4'b1000 && bready_o && bvalid_i) begin
                //             next_wstate = `WS_FINISH;
                //         end else begin
                //             next_wstate = `WS_READ;
                //         end
                //     end
                    `WS_SUBMIT: begin
                        saddr_o = axi_wset;
                        vc_wvalid_o = 1;
                        vc_waddr_o = axi_waddr[`LINE_ADDR_SLICE];
                        if (selected == 0) begin
                            vc_wdata_o[0] = bdata_i_0_0;
                            vc_wdata_o[1] = bdata_i_0_1;
                            vc_wdata_o[2] = bdata_i_0_2;
                            vc_wdata_o[3] = bdata_i_0_3;
                            vc_wdata_o[4] = bdata_i_0_4;
                            vc_wdata_o[5] = bdata_i_0_5;
                            vc_wdata_o[6] = bdata_i_0_6;
                            vc_wdata_o[7] = bdata_i_0_7;
                        end else begin
                            vc_wdata_o[0] = bdata_i_1_0;
                            vc_wdata_o[1] = bdata_i_1_1;
                            vc_wdata_o[2] = bdata_i_1_2;
                            vc_wdata_o[3] = bdata_i_1_3;
                            vc_wdata_o[4] = bdata_i_1_4;
                            vc_wdata_o[5] = bdata_i_1_5;
                            vc_wdata_o[6] = bdata_i_1_6;
                            vc_wdata_o[7] = bdata_i_1_7;
                        end
                        if (vc_wready_i) begin
                            next_wstate = `WS_FINISH;
                        end else begin
                            next_wstate = `WS_SUBMIT;
                        end
                    end

                    `WS_FINISH: begin
                        next_wstate = `WS_FINISH;
                    end
                endcase

                if (!en_i && !requested) begin
                    wait_o = 0;
                end

                case (rstate)
                    `RS_ADDR: begin
                        if (vc_rhit_i) begin
                            next_rstate = `RS_FILL;
                        end else begin
                            araddr_o = axi_raddr;
                            arvalid_o = 1;

                            if (arvalid_o && arready_i) begin
                                next_rstate = `RS_READ;
                            end else begin
                                next_rstate = `RS_ADDR;
                            end
                        end
                    end

                    `RS_READ: begin
                        rready_o = 1;

                        // handshake
                        if (rready_o && rvalid_i) begin
                            if (axi_rcnt == 3'b111) begin
                                if (wstate == `WS_FINISH) begin
                                    saddr_o = axi_rset;
                                    bdata_o_0 = axi_rbuf[0];
                                    bdata_o_1 = axi_rbuf[1];
                                    bdata_o_2 = axi_rbuf[2];
                                    bdata_o_3 = axi_rbuf[3];
                                    bdata_o_4 = axi_rbuf[4];
                                    bdata_o_5 = axi_rbuf[5];
                                    bdata_o_6 = axi_rbuf[6];
                                    bdata_o_7 = rdata_i;

                                    if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == req_bank && rready_o && rvalid_i) begin
                                        // requested strikethrough hit
                                        bdata_o_7 = write_bank_data(rdata_i, req_wdata, req_size, req_strb);
                                    end else if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > req_bank) begin
                                        // requested buffered hit
                                        case (req_bank)
                                            3'b000: begin
                                                bdata_o_0 = write_bank_data(axi_rbuf[0], req_wdata, req_size, req_strb);
                                            end
                                            3'b001: begin
                                                bdata_o_1 = write_bank_data(axi_rbuf[1], req_wdata, req_size, req_strb);
                                            end
                                            3'b010: begin
                                                bdata_o_2 = write_bank_data(axi_rbuf[2], req_wdata, req_size, req_strb);
                                            end
                                            3'b011: begin
                                                bdata_o_3 = write_bank_data(axi_rbuf[3], req_wdata, req_size, req_strb);
                                            end
                                            3'b100: begin
                                                bdata_o_4 = write_bank_data(axi_rbuf[4], req_wdata, req_size, req_strb);
                                            end
                                            3'b101: begin
                                                bdata_o_5 = write_bank_data(axi_rbuf[5], req_wdata, req_size, req_strb);
                                            end
                                            3'b110: begin
                                                bdata_o_6 = write_bank_data(axi_rbuf[6], req_wdata, req_size, req_strb);
                                            end
                                            3'b111: begin // this should never happen
                                                bdata_o_7 = write_bank_data(axi_rbuf[7], req_wdata, req_size, req_strb);
                                            end
                                        endcase
                                    end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == bank_i && rready_o && rvalid_i) begin
                                        // direct strikethrough hit
                                        bdata_o_7 = write_bank_data(rdata_i, wdata_i, rwsize_i, wstrb_i);
                                    end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > bank_i) begin
                                        // direct buffered hit
                                        case (bank_i)
                                            3'b000: begin
                                                bdata_o_0 = write_bank_data(axi_rbuf[0], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b001: begin
                                                bdata_o_1 = write_bank_data(axi_rbuf[1], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b010: begin
                                                bdata_o_2 = write_bank_data(axi_rbuf[2], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b011: begin
                                                bdata_o_3 = write_bank_data(axi_rbuf[3], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b100: begin
                                                bdata_o_4 = write_bank_data(axi_rbuf[4], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b101: begin
                                                bdata_o_5 = write_bank_data(axi_rbuf[5], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b110: begin
                                                bdata_o_6 = write_bank_data(axi_rbuf[6], wdata_i, rwsize_i, wstrb_i);
                                            end
                                            3'b111: begin // this should never happen
                                                bdata_o_7 = write_bank_data(axi_rbuf[7], wdata_i, rwsize_i, wstrb_i);
                                            end
                                        endcase
                                    end

                                    if (selected == 0) begin
                                        bwen_o_0 = 8'hff;
                                        bwen_o_1 = 0;
                                    end else begin
                                        bwen_o_1 = 8'hff;
                                        bwen_o_0 = 0;
                                    end

                                    // tdata_o = axi_rtag;
                                    // twen_o_0 = !selected;
                                    // twen_o_1 = selected;

                                    next_rstate = `RS_FINISH;
                                end else begin
                                    next_rstate = `RS_FILL;
                                end
                            end else begin
                                next_rstate = `RS_READ;
                            end
                        end else begin
                            next_rstate = `RS_READ;
                        end

                        // hit handle
                        if (requested) begin
                            if (req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == req_bank && rready_o && rvalid_i) begin
                                // strikethrough hit
                                wait_o = 0;
                                rdatavalid_o = 1;
                                if (req_wen) begin
                                    // write
                                    // bdata = rdata_i;
                                    // bdata = write_bank_data(bdata, wdata_i, rwsize_i, wstrb_i);
                                    // do nothing here
                                end else begin
                                    // read
                                    next_ostate = OS_KNOWN;
                                    next_os_known_data = read_bank_data(rdata_i, req_size, req_addr);
                                end
                            end else if (req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > req_bank) begin
                                // buffered hit
                                wait_o = 0;
                                rdatavalid_o = 1;
                                if (req_wen) begin
                                    // write
                                    // do nothing here
                                end else begin
                                    // read
                                    next_ostate = OS_KNOWN;
                                    next_os_known_data = read_bank_data(axi_rbuf[req_bank], req_size, req_addr);
                                end
                            end
                        end else begin
                            if (en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == bank_i && rready_o && rvalid_i) begin
                                // strikethrough hit
                                wait_o = 0;
                                rdatavalid_o = 1;
                                if (wen_i) begin
                                    // write
                                    // bdata = rdata_i;
                                    // bdata = write_bank_data(bdata, wdata_i, rwsize_i, wstrb_i);
                                    // do nothing here
                                end else begin
                                    // read
                                    next_ostate = OS_KNOWN;
                                    next_os_known_data = read_bank_data(rdata_i, rwsize_i, addr_i);
                                end
                            end else if (en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > bank_i) begin
                                // buffered hit
                                wait_o = 0;
                                rdatavalid_o = 1;
                                if (wen_i) begin
                                    // write
                                    // do nothing here
                                end else begin
                                    // read
                                    next_ostate = OS_KNOWN;
                                    next_os_known_data = read_bank_data(axi_rbuf[bank_i], rwsize_i, addr_i);
                                end
                            end
                        end
                    end

                    `RS_FILL: begin
                        // fill handle
                        if (wstate == `WS_FINISH) begin
                            saddr_o = axi_rset;
                            bdata_o_0 = axi_rbuf[0];
                            bdata_o_1 = axi_rbuf[1];
                            bdata_o_2 = axi_rbuf[2];
                            bdata_o_3 = axi_rbuf[3];
                            bdata_o_4 = axi_rbuf[4];
                            bdata_o_5 = axi_rbuf[5];
                            bdata_o_6 = axi_rbuf[6];
                            bdata_o_7 = axi_rbuf[7];

                            if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE]) begin
                                // requested buffered hit
                                case (req_bank)
                                    3'b000: begin
                                        bdata_o_0 = write_bank_data(axi_rbuf[0], req_wdata, req_size, req_strb);
                                    end
                                    3'b001: begin
                                        bdata_o_1 = write_bank_data(axi_rbuf[1], req_wdata, req_size, req_strb);
                                    end
                                    3'b010: begin
                                        bdata_o_2 = write_bank_data(axi_rbuf[2], req_wdata, req_size, req_strb);
                                    end
                                    3'b011: begin
                                        bdata_o_3 = write_bank_data(axi_rbuf[3], req_wdata, req_size, req_strb);
                                    end
                                    3'b100: begin
                                        bdata_o_4 = write_bank_data(axi_rbuf[4], req_wdata, req_size, req_strb);
                                    end
                                    3'b101: begin
                                        bdata_o_5 = write_bank_data(axi_rbuf[5], req_wdata, req_size, req_strb);
                                    end
                                    3'b110: begin
                                        bdata_o_6 = write_bank_data(axi_rbuf[6], req_wdata, req_size, req_strb);
                                    end
                                    3'b111: begin // this should never happen
                                        bdata_o_7 = write_bank_data(axi_rbuf[7], req_wdata, req_size, req_strb);
                                    end
                                endcase
                            end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE]) begin
                                // direct buffered hit
                                case (bank_i)
                                    3'b000: begin
                                        bdata_o_0 = write_bank_data(axi_rbuf[0], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b001: begin
                                        bdata_o_1 = write_bank_data(axi_rbuf[1], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b010: begin
                                        bdata_o_2 = write_bank_data(axi_rbuf[2], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b011: begin
                                        bdata_o_3 = write_bank_data(axi_rbuf[3], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b100: begin
                                        bdata_o_4 = write_bank_data(axi_rbuf[4], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b101: begin
                                        bdata_o_5 = write_bank_data(axi_rbuf[5], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b110: begin
                                        bdata_o_6 = write_bank_data(axi_rbuf[6], wdata_i, rwsize_i, wstrb_i);
                                    end
                                    3'b111: begin // this should never happen
                                        bdata_o_7 = write_bank_data(axi_rbuf[7], wdata_i, rwsize_i, wstrb_i);
                                    end
                                endcase
                            end

                            if (selected == 0) begin
                                bwen_o_0 = 8'hff;
                                bwen_o_1 = 0;
                            end else begin
                                bwen_o_1 = 8'hff;
                                bwen_o_0 = 0;
                            end

                            // tdata_o = axi_rtag;
                            // twen_o_0 = !selected;
                            // twen_o_1 = selected;

                            next_rstate = `RS_FINISH;
                        end else begin
                            next_rstate = `RS_FILL;
                        end

                        // hit handle
                        if (requested) begin
                            if (req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > req_bank) begin
                                // buffered hit
                                wait_o = 0;
                                rdatavalid_o = 1;
                                if (req_wen) begin
                                    // write
                                    // do nothing here
                                    // axi_rdirty <= 1;
                                end else begin
                                    // read
                                    next_ostate = OS_KNOWN;
                                    next_os_known_data = read_bank_data(axi_rbuf[req_bank], req_size, req_addr);
                                end
                            end
                        end else begin
                            if (en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > bank_i) begin
                                // buffered hit
                                wait_o = 0;
                                rdatavalid_o = 1;
                                if (wen_i) begin
                                    // write
                                    // do nothing here
                                    // axi_rdirty <= 1;
                                end else begin
                                    // read
                                    next_ostate = OS_KNOWN;
                                    next_os_known_data = read_bank_data(axi_rbuf[bank_i], rwsize_i, addr_i);
                                end
                            end
                        end
                    end

                    `RS_FINISH: begin
                        next_rstate = `RS_FINISH;
                    end
                endcase
                if (next_wstate == `WS_FINISH && next_rstate == `RS_FINISH) begin
                    next_state = `S_LOOKUP;
                end else begin
                    next_state = `S_RW;
                end

            end
            default: begin
                // this SHOULD NEVER happen
            end
        endcase
    end
end

always_ff@(posedge clock) begin
    if (!resetn) begin
        requested <= 0;
        valid_0 <= 0;
        valid_1 <= 0;
        state <= `S_LOOKUP;
        rstate <= `RS_IDLE;
        wstate <= `WS_IDLE;
        ostate <= OS_NONE;
        os_known_data<=0;
    end else begin
        case (state)
            `S_LOOKUP: begin
                axi_rcnt <= 0;
                axi_wcnt <= 0;
                if (!en_i && !requested) begin
                    // do nothing
                end else begin
                    requested <= 0;
                    prev_addr <= the_addr;
                    prev_wen <= the_wen;
                    prev_rwsize <= the_rwsize;
                    prev_wstrb <= the_wstrb;
                    prev_wdata <= the_wdata;

                    // if (the_addr[31:16] == 16'h1faf) begin // Is CONFREG addr?
                    //     if (the_wen) begin
                    //         axi_waddr <= the_addr;
                    //     end else begin
                    //         axi_raddr <= the_addr;
                    //     end
                    // end else begin
                        if (the_tag == tag_0[the_set] && valid_0[the_set]) begin
                            // hit line 0
                            // update lru
                            lru[the_set] <= 1;

                            if (the_wen) begin
                                // write
                                dirty_0[the_set] <= 1;
                            end else begin
                                // read
                                // do nothing
                            end
                        end else if (the_tag == tag_1[the_set] && valid_1[the_set]) begin
                            // hit line 1
                            // update lru
                            lru[the_addr] <= 0;

                            if (the_wen) begin
                                // write
                                dirty_1[the_set] <= 1;
                            end else begin
                                // read
                                // do nothing
                            end
                        // end else if (vc_rhit_i) begin
                        //     if (!sel_dirty || vc_wready_i) begin
                        //         lru[the_set] = !sel_way;
                        //         if (sel_way == 0) begin
                        //             tag_0[the_set] = the_tag;
                        //             valid_0[the_set] = 1;
                        //             dirty_0[the_set] = the_wen;
                        //         end else begin
                        //             tag_1[the_set] = the_tag;
                        //             valid_1[the_set] = 1;
                        //             dirty_1[the_set] = the_wen;
                        //         end
                        //     end
                        end else begin
                            // miss
                            requested <= 1;
                            req_addr <= the_addr;
                            req_wen <= the_wen;
                            req_size <= the_rwsize;
                            req_strb <= the_wstrb;
                            req_wdata <= the_wdata;

                            axi_raddr <= { the_addr[`BLOCK_ADDR_SLICE], 5'b00000 };
                            axi_rdirty <= 0;

                            axi_rcnt <= 0;
                            axi_wcnt <= 0;

                            if (!valid_0[the_set]) begin
                                selected <= 0;
                                need_wb <= 0;
                            end else if (!valid_1[the_set]) begin
                                selected <= 1;
                                need_wb <= 0;
                            end else begin
                                if (lru[the_set] == 0) begin
                                    selected <= 0;
                                    axi_waddr <= { tag_0[the_set], the_set, 5'b00000 };
                                    need_wb <= 1;
                                end else begin
                                    selected <= 1;
                                    axi_waddr <= { tag_1[the_set], the_set, 5'b00000 };
                                    need_wb <= 1;
                                end
                            end
                        end
                    end
                // end
            end

            // `S_CR_ADDR: begin
            // end

            `S_RW: begin
                case (wstate)
                    // `WS_ADDR: begin
                    //     // do nothing
                    // end

                    // `WS_READ: begin
                    //     if (axi_wcnt != 4'b1000) begin
                    //         if (wready_i && wvalid_o) begin
                    //             axi_wcnt <= axi_wcnt + 1;
                    //         end
                    //     end
                    // end

                    `WS_FINISH: begin
                        // do nothing
                    end
                endcase

                case (rstate)
                    `RS_ADDR: begin
                        // do nothing
                        if (vc_rhit_i) begin
                            axi_rbuf[0] <= vc_rdata_i[0];
                            axi_rbuf[1] <= vc_rdata_i[1];
                            axi_rbuf[2] <= vc_rdata_i[2];
                            axi_rbuf[3] <= vc_rdata_i[3];
                            axi_rbuf[4] <= vc_rdata_i[4];
                            axi_rbuf[5] <= vc_rdata_i[5];
                            axi_rbuf[6] <= vc_rdata_i[6];
                            axi_rbuf[7] <= vc_rdata_i[7];
                        end
                    end

                    `RS_READ: begin
                        // handshake
                        if (rready_o && rvalid_i) begin
                            if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == req_bank && rready_o && rvalid_i) begin
                                // requested strikethrough hit, do nothing
                            end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == bank_i && rready_o && rvalid_i) begin
                                // direct strikethrough hit, do nothing
                            end else begin
                                axi_rbuf[axi_rcnt] <= rdata_i;
                            end
                            if (axi_rcnt < 3'b111) begin
                                axi_rcnt <= axi_rcnt + 1;
                            end
                            if (axi_rcnt == 3'b111) begin
                                if (wstate == `WS_FINISH) begin
                                    lru[axi_rset] <= !selected;
                                    if (selected == 0) begin
                                        if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                            dirty_0[axi_rset] <= 1;
                                        end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                            dirty_0[axi_rset] <= 1;
                                        end else begin
                                            dirty_0[axi_rset] <= axi_rdirty;
                                        end
                                        valid_0[axi_rset] <= 1;
                                        tag_0[axi_rset] <= axi_rtag;
                                    end else begin
                                        if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                            dirty_1[axi_rset] <= 1;
                                        end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                            dirty_1[axi_rset] <= 1;
                                        end else begin
                                            dirty_1[axi_rset] <= axi_rdirty;
                                        end
                                        valid_1[axi_rset] <= 1;
                                        tag_1[axi_rset] <= axi_rtag;
                                    end
                                end
                            end
                        end

                        // hit handle
                        if (requested) begin
                            if (req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == req_bank && rready_o && rvalid_i) begin
                                // strikethrough hit
                                if (req_wen) begin
                                    // write
                                    axi_rdirty <= 1;
                                    axi_rbuf[axi_rcnt] <= write_bank_data(rdata_i, req_wdata, req_size, req_strb);
                                    requested <= 0;
                                end else begin
                                    // read
                                    // do nothing
                                end
                                requested <= 0;
                            end else if (req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > req_bank) begin
                                // buffered hit
                                if (wen_i) begin
                                    // write
                                    axi_rdirty <= 1;
                                    axi_rbuf[req_bank] <= write_bank_data(axi_rbuf[req_bank], req_wdata, req_size, req_strb);
                                    requested <= 0;
                                end else begin
                                    // read
                                    // do nothing
                                end
                                requested <= 0;
                            end
                        end else begin
                            if (en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt == bank_i && rready_o && rvalid_i) begin
                                // strikethrough hit
                                if (wen_i) begin
                                    // write
                                    axi_rdirty <= 1;
                                    axi_rbuf[axi_rcnt] <= write_bank_data(rdata_i, wdata_i, rwsize_i, wstrb_i);
                                end else begin
                                    // read
                                    // do nothing
                                end
                            end else if (en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > bank_i) begin
                                // buffered hit
                                if (wen_i) begin
                                    // write
                                    axi_rdirty <= 1;
                                    axi_rbuf[bank_i] <= write_bank_data(axi_rbuf[bank_i], wdata_i, rwsize_i, wstrb_i);
                                end else begin
                                    // read
                                    // do nothing
                                end
                            end else if (en_i) begin
                                // miss
                                requested <= 1;
                                req_addr <= addr_i;
                                req_wen <= wen_i;
                                req_size <= rwsize_i;
                                req_strb <= wstrb_i;
                                req_wdata <= wdata_i;
                            end
                        end
                    end

                    `RS_FILL: begin
                        // fill handle
                        if (wstate == `WS_FINISH) begin
                            lru[axi_rset] <= !selected;
                            if (selected == 0) begin
                                if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                    dirty_0[axi_rset] <= 1;
                                end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                    dirty_0[axi_rset] <= 1;
                                end else begin
                                    dirty_0[axi_rset] <= axi_rdirty;
                                end
                                valid_0[axi_rset] <= 1;
                                tag_0[axi_rset] <= axi_rtag;
                            end else begin
                                if (req_wen && requested && req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                    dirty_1[axi_rset] <= 1;
                                end else if (wen_i && !requested && en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && rready_o && rvalid_i) begin
                                    dirty_1[axi_rset] <= 1;
                                end else begin
                                    dirty_1[axi_rset] <= axi_rdirty;
                                end
                                valid_1[axi_rset] <= 1;
                                tag_1[axi_rset] <= axi_rtag;
                            end
                        end

                        // hit handle
                        if (requested) begin
                            if (req_addr[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > req_bank) begin
                                // buffered hit
                                if (wen_i) begin
                                    // write
                                    axi_rdirty <= 1;
                                    axi_rbuf[axi_rset] <= write_bank_data(axi_rbuf[req_bank], req_wdata, req_size, req_strb);
                                    requested <= 0;
                                end else begin
                                    // read
                                    // do nothing
                                    requested <= 0;
                                end
                            end
                        end else begin
                            if (en_i && addr_i[`BLOCK_ADDR_SLICE] == axi_raddr[`BLOCK_ADDR_SLICE] && axi_rcnt > bank_i) begin
                                // buffered hit
                                if (wen_i) begin
                                    // write
                                    axi_rdirty <= 1;
                                    axi_rbuf[bank_i] <= write_bank_data(axi_rbuf[bank_i], wdata_i, rwsize_i, wstrb_i);
                                end else begin
                                    // read
                                    // do nothing
                                end
                            end else if (en_i) begin
                                // miss
                                requested <= 1;
                                req_addr <= addr_i;
                                req_wen <= wen_i;
                                req_size <= rwsize_i;
                                req_strb <= wstrb_i;
                                req_wdata <= wdata_i;
                            end
                        end
                    end

                    `RS_FINISH: begin
                        // do nothing
                    end
                endcase
            end
            default: begin
                // this SHOULD NEVER happen
            end
        endcase

        state <= next_state;
        rstate <= next_rstate;
        wstate <= next_wstate;
        ostate <= next_ostate;
        os_known_data <= next_os_known_data;
        os_read_way_id <= next_os_read_way_id;
        os_read_way_bank_id <= next_os_read_way_bank_id;
    end
end

endmodule