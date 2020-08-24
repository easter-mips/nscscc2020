`include "cache.vh"
module prefetch
    ( input clock, resetn
      // cpu interface
    , input[`LINE_ADDR_BUS] line_addr_i
    , input need_prefetch_i
    , input pf_ack_i
    , output logic[`LINE_ADDR_BUS] pf_addr_o
    , output logic pf_ready_o
    , output logic pf_fetching_o
    , output logic[`INST_BUS] pf_inst_o_0
    , output logic[`INST_BUS] pf_inst_o_1
    , output logic[`INST_BUS] pf_inst_o_2
    , output logic[`INST_BUS] pf_inst_o_3
    , output logic[`INST_BUS] pf_inst_o_4
    , output logic[`INST_BUS] pf_inst_o_5
    , output logic[`INST_BUS] pf_inst_o_6
    , output logic[`INST_BUS] pf_inst_o_7

    // axi interface
    , output logic[`ADDR_BUS] axi_araddr_o
    , output logic axi_arvalid_o
    , input axi_arready_i
    , input[`INST_BUS] axi_rdata_i
    , input axi_rvalid_i
    , input axi_rlast_i
    , output logic axi_rready_o
    );

`define PF_STATE_BUS 3:0
parameter S_IDLE = 0;
parameter S_ADDR = 1;
parameter S_READ = 2;
parameter S_READY = 3;

// model states
logic[`PF_STATE_BUS] state = S_IDLE;
logic[`PF_STATE_BUS] next_state;

logic[`LINE_ADDR_BUS] pf_addr = 0;
logic[`LINE_ADDR_BUS] next_pf_addr;

logic[`INST_BUS] pf_insts[7:0] = { 0, 0, 0, 0, 0, 0, 0, 0 };
logic[`INST_BUS] next_pf_insts[7:0];

logic[2:0] axi_read_cnt = 0;
logic[2:0] next_axi_read_cnt;

logic[31:0] fail_count = 0;
logic[31:0] next_fail_count;

logic[31:0] succ_count = 0;
logic[31:0] next_succ_count;

assign pf_inst_o_0 = pf_insts[0];
assign pf_inst_o_1 = pf_insts[1];
assign pf_inst_o_2 = pf_insts[2];
assign pf_inst_o_3 = pf_insts[3];
assign pf_inst_o_4 = pf_insts[4];
assign pf_inst_o_5 = pf_insts[5];
assign pf_inst_o_6 = pf_insts[6];
assign pf_inst_o_7 = pf_insts[7];

always_comb begin
    pf_addr_o = pf_addr;
    pf_ready_o = 0;
    pf_fetching_o = 0;

    axi_araddr_o = 0;
    axi_arvalid_o = 0;
    axi_rready_o = 0;

    next_state = state;
    next_pf_addr = pf_addr;
    next_pf_insts[0] = pf_insts[0];
    next_pf_insts[1] = pf_insts[1];
    next_pf_insts[2] = pf_insts[2];
    next_pf_insts[3] = pf_insts[3];
    next_pf_insts[4] = pf_insts[4];
    next_pf_insts[5] = pf_insts[5];
    next_pf_insts[6] = pf_insts[6];
    next_pf_insts[7] = pf_insts[7];

    next_axi_read_cnt = axi_read_cnt;
    next_fail_count = fail_count;
    next_succ_count = succ_count;
    if (resetn) begin
        case (state)
        S_IDLE: begin
            if (need_prefetch_i) begin
                next_pf_addr = line_addr_i;
                next_state = S_ADDR;
                pf_fetching_o = 1;
            end else begin
                next_pf_addr = 0;
                next_state = S_IDLE;
            end
        end
        S_ADDR: begin
            pf_fetching_o = 1;
            axi_araddr_o = { pf_addr, 5'b00000 };
            axi_arvalid_o = 1;
            if (axi_arvalid_o && axi_arready_i) begin
                next_state = S_READ;
                next_axi_read_cnt = 0;
            end else begin
                next_state = S_ADDR;
            end
        end
        S_READ: begin
            pf_fetching_o = 1;
            axi_rready_o = 1;

            if (axi_rready_o && axi_rvalid_i) begin
                next_axi_read_cnt = axi_read_cnt + 1;
                next_pf_insts[axi_read_cnt] = axi_rdata_i;

                if (axi_rlast_i && axi_read_cnt == 3'b111) begin
                    if (line_addr_i == pf_addr || line_addr_i == pf_addr + 1) begin
                        next_state = S_READY;
                    end else begin
                        next_state = S_IDLE;
                        next_pf_addr = 0;
                        next_fail_count = fail_count + 1;
                    end
                end else begin
                    next_state = S_READ;
                end
            end
        end
        S_READY: begin
            pf_ready_o = 1;

            if (pf_ack_i) begin
                next_state = S_IDLE;
                next_succ_count = succ_count + 1;
                next_pf_addr = 0;
            end else if (line_addr_i == pf_addr || line_addr_i == pf_addr + 1) begin
                next_state = S_READY;
            end else begin
                next_pf_addr = 0;
                next_state = S_IDLE;
                next_fail_count = fail_count + 1;
            end
        end
        endcase
    end
end

always_ff@(posedge clock) begin
    if (!resetn) begin
        state <= S_IDLE;
        pf_addr <= 0;
        axi_read_cnt <= 0;
        fail_count <= 0;
        succ_count <= 0;
    end else begin
        state <= next_state;
        pf_addr <= next_pf_addr;
        axi_read_cnt <= next_axi_read_cnt;
        pf_insts[0] <= next_pf_insts[0];
        pf_insts[1] <= next_pf_insts[1];
        pf_insts[2] <= next_pf_insts[2];
        pf_insts[3] <= next_pf_insts[3];
        pf_insts[4] <= next_pf_insts[4];
        pf_insts[5] <= next_pf_insts[5];
        pf_insts[6] <= next_pf_insts[6];
        pf_insts[7] <= next_pf_insts[7];

        fail_count <= next_fail_count;
        succ_count <= next_succ_count;
    end
end

endmodule