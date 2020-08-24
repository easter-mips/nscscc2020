`include "cache/cache.vh"
module inst_fetcher 
    ( input clock, resetn, en
    , input[`ADDR_BUS] addr_i
    , output logic inst1valid_o
    , output logic inst2valid_o
    , output logic[`INST_BUS] inst1_o
    , output logic[`INST_BUS] inst2_o

    // axi interface
    , output wire [3:0] axi_awid
    , output wire [31:0] axi_awaddr
    , output wire [3:0] axi_awlen
    , output wire [2:0] axi_awsize
    , output wire [1:0] axi_awburst
    , output wire [1:0] axi_awlock
    , output wire [3:0] axi_awcache
    , output wire [2:0] axi_awprot
    , output wire [3:0] axi_awqos
    , output wire [0:0] axi_awvalid
    , input wire [0:0] axi_awready
    , output logic [3:0] axi_wid
    , output wire [31:0] axi_wdata
    , output wire [3:0] axi_wstrb
    , output wire [0:0] axi_wlast
    , output wire [0:0] axi_wvalid
    , input wire [0:0] axi_wready
    , input wire [3:0] axi_bid
    , input wire [1:0] axi_bresp
    , input wire [0:0] axi_bvalid
    , output wire [0:0] axi_bready
    , output wire [3:0] axi_arid
    , output logic [31:0] axi_araddr
    , output wire [3:0] axi_arlen
    , output wire [2:0] axi_arsize
    , output wire [1:0] axi_arburst
    , output wire [1:0] axi_arlock
    , output wire [3:0] axi_arcache
    , output wire [2:0] axi_arprot
    , output wire [3:0] axi_arqos
    , output logic [0:0] axi_arvalid
    , input wire [0:0] axi_arready
    , input wire [3:0] axi_rid
    , input wire [31:0] axi_rdata
    , input wire [1:0] axi_rresp
    , input wire [0:0] axi_rlast
    , input wire [0:0] axi_rvalid
    , output logic [0:0] axi_rready
    );

// disable write channel
assign axi_awid = 4'b0;
assign axi_awaddr = 0;
assign axi_awlen = 0;
assign axi_awsize = 0;
assign axi_awburst = 0;
assign axi_awlock = 0;
assign axi_awcache = 0;
assign axi_awprot = 0;
assign axi_awqos = 0;
assign axi_awvalid = 0;
assign axi_wid = 0;
assign axi_wdata = 0;
assign axi_wstrb = 0;
assign axi_wlast = 0;
assign axi_wvalid = 0;
assign axi_bready = 0;

// read channel config
assign axi_arid = 4'b0000;
assign axi_arlen = 4'h7;
assign axi_arsize = 3'b010;
assign axi_arburst = 2'b10;
assign axi_arlock = 1'b0;
assign axi_arcache = 4'hf;
assign axi_arprot = 3'h0;
assign axi_arqos = 4'h0;

typedef logic[3:0] IFState;
localparam S_IDLE = 0;
localparam S_ADDR = 1;
localparam S_READ = 2;

typedef logic[1:0] OState;
localparam OS_NONE = 0;
localparam OS_INST1 = 1;
localparam OS_INST2 = 2;

typedef logic[`INST_BUS] Inst;
typedef logic[`LINE_ADDR_BUS] LineAddr;
typedef logic[`BANK_BUS] BankIndex;

IFState state = S_IDLE;
IFState next_state;

OState ostate = OS_NONE;
OState next_ostate;

Inst os_inst1 = 0;
Inst next_os_inst1;
Inst os_inst2 = 0;
Inst next_os_inst2;

LineAddr read_addr = 0;
LineAddr next_read_addr;

BankIndex read_bank = 0;
BankIndex next_read_bank;

Inst read_buffer[7:0] = { 0, 0, 0, 0, 0, 0, 0, 0 };
Inst next_read_buffer[7:0];

logic[7:0] read_buffer_valid = 0;
logic[7:0] next_read_buffer_valid;

assign inst1_o = ostate == OS_NONE ? 0 : os_inst1;
assign inst2_o = ostate == OS_INST2 ? os_inst2 : 0;

always_comb begin
    next_state = state;
    next_ostate = OS_NONE;
    next_os_inst1 = 0;
    next_os_inst2 = 0;
    next_read_addr = read_addr;
    next_read_buffer = read_buffer;
    next_read_buffer_valid = read_buffer_valid;
    next_read_bank = read_bank;

    inst1valid_o = 0;
    inst2valid_o = 0;
    // inst1_o = 0;
    // inst2_o = 0;
    axi_araddr = 0;
    axi_arvalid = 0;
    axi_rready = 0;

    if (resetn) begin
        // handle output
        // case (ostate)
        // OS_NONE: begin
        //     inst1_o = 0;
        //     inst2_o = 0;
        // end
        // OS_INST1: begin
        //     inst1_o = os_inst1;
        // end
        // OS_INST2: begin
        //     inst1_o = os_inst1;
        //     inst2_o = os_inst2;
        // end
        // endcase

        // handle axi
        case (state)
        S_IDLE: begin
            if (en && (addr_i[`LINE_ADDR_SLICE] != read_addr || read_buffer_valid == 8'h0)) begin
                // miss, read from axi
                next_read_addr = addr_i[`LINE_ADDR_SLICE];
                next_read_bank = addr_i[4:2];
                next_read_buffer_valid = 0;
                next_state = S_ADDR;
            end
        end
        S_ADDR: begin
            axi_arvalid = 1;
            axi_araddr = { read_addr, read_bank, 2'b00 };

            if (axi_arvalid && axi_arready) begin
                next_state = S_READ;
            end
        end
        S_READ: begin
            axi_rready = 1;

            if (axi_rvalid && axi_rready) begin
                next_read_bank = read_bank + 1;
                next_read_buffer[read_bank] = axi_rdata;
                next_read_buffer_valid[read_bank] = 1'b1;

                if (axi_rlast && next_read_buffer_valid == 8'hff) begin
                    next_state = S_IDLE;
                end else begin
                    next_state = S_READ;
                end
            end
        end
        endcase

        // handle request
        if (en) begin
            if (addr_i[1:0] != 2'b00) begin
                // invalid input, output nop
                inst1valid_o = 1;
                inst2valid_o = 1;
                next_ostate = OS_INST2;
                next_os_inst1 = 0;
                next_os_inst1 = 0;
            end else if (addr_i[`LINE_ADDR_SLICE] == read_addr && addr_i[4:2] == read_bank && axi_rready && axi_rvalid) begin
                next_ostate = OS_INST1;
                inst1valid_o = 1;
                next_os_inst1 = axi_rdata;
            end else if (addr_i[`LINE_ADDR_SLICE] == read_addr) begin
                inst1valid_o = read_buffer_valid[addr_i[4:2]];
                inst2valid_o = addr_i[4:2] != 3'b111 && read_buffer_valid[addr_i[4:2] + 1];
                if (inst1valid_o && inst2valid_o) begin
                    next_ostate = OS_INST2;
                    next_os_inst1 = read_buffer[addr_i[4:2]];
                    next_os_inst2 = read_buffer[addr_i[4:2] + 1];
                end else if (inst1valid_o) begin
                    next_ostate = OS_INST1;
                    next_os_inst1 = read_buffer[addr_i[4:2]];
                end else begin
                    next_ostate = OS_NONE;
                end
            end
        end
    end
end

always_ff@(posedge clock) begin
    if (!resetn) begin
        state <= S_IDLE;
        ostate <= OS_NONE;
        os_inst1 <= 0;
        os_inst2 <= 0;
        read_addr <= 0;
        read_buffer <= { 0, 0, 0, 0, 0, 0, 0, 0 };
        read_buffer_valid <= 0;
        read_bank <= 0;
    end else begin
        state <= next_state;
        ostate <= next_ostate;
        os_inst1 <= next_os_inst1;
        os_inst2 <= next_os_inst2;
        read_addr <= next_read_addr;
        read_buffer <= next_read_buffer;
        read_buffer_valid <= next_read_buffer_valid;
        read_bank <= next_read_bank;
    end
end

endmodule