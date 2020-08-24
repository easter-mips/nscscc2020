`include "cache/cache.vh"
module write_fifo 
    #( parameter DEPTH = 8 )
    ( input clock, resetn, en
      // write data interface
    , input[`ADDR_BUS] addr_i
    , input[2:0] wsize_i
    , input[`DATA_BUS] wdata_i
    , input[3:0] wstrb_i
    , output logic fifo_ready_o

      // query address interface
    , input[`ADDR_BUS] query_addr_i
    , output logic in_fifo_o

      // axi interface
    , output wire [3:0] axi_awid
    , output logic [31:0] axi_awaddr
    , output wire [7:0] axi_awlen
    , output logic [2:0] axi_awsize
    , output wire [1:0] axi_awburst
    , output wire [0:0] axi_awlock
    , output wire [3:0] axi_awcache
    , output wire [2:0] axi_awprot
    , output wire [3:0] axi_awqos
    , output logic [0:0] axi_awvalid
    , input wire [0:0] axi_awready
    , output wire [3:0] axi_wid
    , output logic [31:0] axi_wdata
    , output logic [3:0] axi_wstrb
    , output logic [0:0] axi_wlast
    , output logic [0:0] axi_wvalid
    , input wire [0:0] axi_wready
    , input wire [3:0] axi_bid
    , input wire [1:0] axi_bresp
    , input wire [0:0] axi_bvalid
    , output wire [0:0] axi_bready
    );

assign axi_awid = 0;
assign axi_awlen = 4'h0;
assign axi_awburst = 2'b0;
assign axi_awlock = 0;
assign axi_awcache = 4'b1111;
assign axi_awprot = 0;
assign axi_awqos = 0;
assign axi_bready = 1;
assign axi_wid = 0;

typedef logic[31:0] Addr;
typedef logic[31:0] Data;

typedef struct packed {
    Addr addr;
    Data data;
    logic[2:0] wsize;
    logic[3:0] wstrb;
} LineBuffer;

typedef logic[$clog2(DEPTH) - 1:0] FifoIndex;

LineBuffer items[DEPTH - 1:0];
LineBuffer next_items[DEPTH - 1:0];

FifoIndex fifo_head = 0;
FifoIndex next_fifo_head;

FifoIndex fifo_tail = 0;
FifoIndex next_fifo_tail;

logic fifo_full = 0;
logic next_fifo_full;

logic[DEPTH - 1:0] item_valid = 0;
logic[DEPTH - 1:0] next_item_valid;

assign fifo_ready_o = !fifo_full;

logic[DEPTH - 1:0] fifo_hit;

typedef logic[2:0] State;
localparam WS_IDLE = 0;
localparam WS_ADDR = 1;
localparam WS_WRITE = 2;
localparam WS_RESP = 3;

State wstate = WS_IDLE;
State next_wstate;

always_comb begin
    in_fifo_o = 0;
    axi_awaddr = 0;
    axi_awsize = 0;
    axi_awvalid = 0;
    axi_wdata = 0;
    axi_wstrb = 0;
    axi_wvalid = 0;
    axi_wlast = 0;

    next_items = items;
    next_item_valid = item_valid;
    next_fifo_head = fifo_head;
    next_fifo_tail = fifo_tail;
    next_fifo_full = fifo_full;

    next_wstate = wstate;

    for (int i = 0; i <= DEPTH - 1; i++) begin
        fifo_hit[i] = item_valid[i] && (items[i].addr[31:2] == query_addr_i[31:2]);
    end
    in_fifo_o = |fifo_hit;

    if (resetn) begin
        // submit new write request
        if (fifo_ready_o && en) begin
            next_items[fifo_tail].addr = addr_i;
            next_items[fifo_tail].data = wdata_i;
            next_items[fifo_tail].wstrb = wstrb_i;
            next_items[fifo_tail].wsize = wsize_i;
            next_fifo_tail = fifo_tail + 1;
            next_item_valid[fifo_tail] = 1;
            if (next_fifo_tail == fifo_head) next_fifo_full = 1;
            if (wstate == WS_IDLE) next_wstate = WS_ADDR;
        end

        // axi write
        case (wstate)
        WS_IDLE: begin
            next_wstate = item_valid[fifo_head] ? WS_ADDR : WS_IDLE;
        end
        WS_ADDR: begin
            axi_awvalid = 1;
            axi_awaddr = items[fifo_head].addr;
            axi_awsize = items[fifo_head].wsize;
            
            next_wstate = axi_awready ? WS_WRITE : WS_ADDR;
        end
        WS_WRITE: begin
            axi_wvalid = 1;
            axi_wdata = items[fifo_head].data;
            axi_wstrb = items[fifo_head].wstrb;
            axi_wlast = 1;

            if (axi_wready) begin
                next_wstate = WS_RESP;
            end
        end
        WS_RESP: begin
            if (axi_bvalid) begin
                next_fifo_full = 0;
                next_fifo_head = fifo_head + 1;
                next_item_valid[fifo_head] = 0;
                if (next_item_valid[next_fifo_head]) next_wstate = WS_ADDR;
                else next_wstate = WS_IDLE;
            end
        end
        endcase
    end
end

always_ff@(posedge clock) begin
    if (!resetn) begin
        item_valid <= 0;
        fifo_head <= 0;
        fifo_tail <= 0;
        fifo_full <= 0;

        wstate <= WS_IDLE;
    end else begin
        items <= next_items;
        item_valid <= next_item_valid;
        fifo_head <= next_fifo_head;
        fifo_tail <= next_fifo_tail;
        fifo_full <= next_fifo_full;

        wstate <= next_wstate;
    end
end

endmodule