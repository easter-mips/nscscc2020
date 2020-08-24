`include "cache.vh"
module victim_cache 
    #( parameter DEPTH = 16
     )
    ( input clock, resetn
      // interface with CPU
    , input[`LINE_ADDR_BUS] waddr_i
    , input wvalid_i
    , input[`DATA_BUS] wdata_i[7:0]
    , output logic wready_o

    , input[`LINE_ADDR_BUS] raddr_i
    // , input rvalid_i
    , output logic[`DATA_BUS] rdata_o[7:0]
    , output logic rhit_o
      // interface with AXI
    , output logic[`ADDR_BUS] axi_awaddr_o
    , output logic axi_awvalid_o
    , input axi_awready_i
    , output logic[`DATA_BUS] axi_wdata_o
    , output logic axi_wvalid_o
    , output logic axi_wlast_o
    , input axi_wready_i
    , output logic axi_bready_o
    , input axi_bvalid_i
    );

typedef struct packed {
    logic[`LINE_ADDR_BUS] addr;
    logic[`DATA_BUS] bank_0;
    logic[`DATA_BUS] bank_1;
    logic[`DATA_BUS] bank_2;
    logic[`DATA_BUS] bank_3;
    logic[`DATA_BUS] bank_4;
    logic[`DATA_BUS] bank_5;
    logic[`DATA_BUS] bank_6;
    logic[`DATA_BUS] bank_7;
} LineBuffer;

logic[DEPTH - 1:0] line_valid = 0;
logic[DEPTH - 1:0] next_line_valid;

typedef logic[$clog2(DEPTH) - 1:0] FifoIndex;

LineBuffer cache_data[DEPTH - 1:0];
LineBuffer next_cache_data[DEPTH - 1:0];

FifoIndex fifo_front = 0;
FifoIndex next_fifo_front;
FifoIndex fifo_tail = 0;
FifoIndex next_fifo_tail;
logic[$clog2(DEPTH):0] fifo_count = 0;
logic[$clog2(DEPTH):0] next_fifo_count;

typedef logic[3:0] WriteState;
localparam WS_IDLE = 0;
localparam WS_ADDR = 1;
localparam WS_WRITE = 2;
localparam WS_RESP = 3;
typedef logic [2:0] WriteCount;

logic[`LINE_ADDR_BUS] buf_raddr = 0;
logic[`LINE_ADDR_BUS] next_buf_raddr;

WriteState wstate = WS_IDLE;
WriteState next_wstate;
WriteCount wcount = 0;
WriteCount next_wcount;

logic[DEPTH - 1:0] hit_vector;
logic[DEPTH - 1:0] in_vector;

assign rhit_o = |hit_vector;

logic waddr_in_cache;
assign waddr_in_cache = |in_vector;

assign wready_o = !(fifo_count == DEPTH) && !waddr_in_cache;

always_comb begin
    for (int i = 0; i <= DEPTH - 1; i++) begin
        hit_vector[i] = line_valid[i] && cache_data[i].addr == buf_raddr;
    end
end

always_comb begin
    for (int i = 0; i <= DEPTH - 1; i++) begin
        in_vector[i] = line_valid[i] && cache_data[i].addr == waddr_i;
    end
end

always_comb begin
    rdata_o[0] = 0;
    rdata_o[1] = 0;
    rdata_o[2] = 0;
    rdata_o[3] = 0;
    rdata_o[4] = 0;
    rdata_o[5] = 0;
    rdata_o[6] = 0;
    rdata_o[7] = 0;
    for (int i = 0; i <= DEPTH - 1; i++) begin
        rdata_o[0] = rdata_o[0] | (cache_data[i].bank_0 & {32{hit_vector[i]}});
        rdata_o[1] = rdata_o[1] | (cache_data[i].bank_1 & {32{hit_vector[i]}});
        rdata_o[2] = rdata_o[2] | (cache_data[i].bank_2 & {32{hit_vector[i]}});
        rdata_o[3] = rdata_o[3] | (cache_data[i].bank_3 & {32{hit_vector[i]}});
        rdata_o[4] = rdata_o[4] | (cache_data[i].bank_4 & {32{hit_vector[i]}});
        rdata_o[5] = rdata_o[5] | (cache_data[i].bank_5 & {32{hit_vector[i]}});
        rdata_o[6] = rdata_o[6] | (cache_data[i].bank_6 & {32{hit_vector[i]}});
        rdata_o[7] = rdata_o[7] | (cache_data[i].bank_7 & {32{hit_vector[i]}});
    end
end

assign next_buf_raddr = raddr_i;

always_comb begin
    next_cache_data = cache_data;
    next_line_valid = line_valid;
    next_fifo_front = fifo_front;
    next_fifo_tail = fifo_tail;
    next_fifo_count = fifo_count;
    next_wstate = wstate;
    next_wcount = wcount;

    // rhit_o = 0;
    axi_awaddr_o = 0;
    axi_awvalid_o = 0;
    axi_wdata_o = 0;
    axi_wvalid_o = 0;
    axi_wlast_o = 0;
    axi_bready_o = 0;
    
    if (resetn) begin
        // handle cpu input
        if (wvalid_i && wready_o) begin
            // push data
            next_fifo_count = fifo_count + 1;
            next_fifo_tail = fifo_tail + 1;
            next_cache_data[fifo_tail].addr = waddr_i;
            next_cache_data[fifo_tail].bank_0 = wdata_i[0];
            next_cache_data[fifo_tail].bank_1 = wdata_i[1];
            next_cache_data[fifo_tail].bank_2 = wdata_i[2];
            next_cache_data[fifo_tail].bank_3 = wdata_i[3];
            next_cache_data[fifo_tail].bank_4 = wdata_i[4];
            next_cache_data[fifo_tail].bank_5 = wdata_i[5];
            next_cache_data[fifo_tail].bank_6 = wdata_i[6];
            next_cache_data[fifo_tail].bank_7 = wdata_i[7];
            next_line_valid[fifo_tail] = 1;

            // forwarding state
            if (wstate == WS_IDLE) begin
                next_wstate = WS_ADDR;
            end
        end

        // handle cpu request
        // if (rvalid_i) begin
        //     for (int i = 0; i <= 7; i++) begin
        //         if (cache_data[fifo_tail + i].addr == raddr_i && line_valid[fifo_tail + i]) begin
        //             rhit_o = 1;
        //             rdata_o[0] = cache_data[fifo_tail + i].bank_0;
        //             rdata_o[1] = cache_data[fifo_tail + i].bank_1;
        //             rdata_o[2] = cache_data[fifo_tail + i].bank_2;
        //             rdata_o[3] = cache_data[fifo_tail + i].bank_3;
        //             rdata_o[4] = cache_data[fifo_tail + i].bank_4;
        //             rdata_o[5] = cache_data[fifo_tail + i].bank_5;
        //             rdata_o[6] = cache_data[fifo_tail + i].bank_6;
        //             rdata_o[7] = cache_data[fifo_tail + i].bank_7;
        //         end
        //     end
        // end

        // handle axi output
        case (wstate)
        WS_IDLE: begin
            if (fifo_count != 0) begin
                next_wstate = WS_ADDR;
            end 
        end
        WS_ADDR: begin
            axi_awvalid_o = 1;
            axi_awaddr_o = { cache_data[fifo_front].addr, 5'b00000 };

            if (axi_awvalid_o && axi_awready_i) begin
                next_wstate = WS_WRITE;
                next_wcount = 0;
            end
        end
        WS_WRITE: begin
            axi_wvalid_o = 1;
            axi_wlast_o = wcount == 3'b111;
            case (wcount)
            3'b000: axi_wdata_o = cache_data[fifo_front].bank_0;
            3'b001: axi_wdata_o = cache_data[fifo_front].bank_1;
            3'b010: axi_wdata_o = cache_data[fifo_front].bank_2;
            3'b011: axi_wdata_o = cache_data[fifo_front].bank_3;
            3'b100: axi_wdata_o = cache_data[fifo_front].bank_4;
            3'b101: axi_wdata_o = cache_data[fifo_front].bank_5;
            3'b110: axi_wdata_o = cache_data[fifo_front].bank_6;
            3'b111: axi_wdata_o = cache_data[fifo_front].bank_7;
            endcase

            if (axi_wvalid_o && axi_wready_i) begin
                if (wcount == 3'b111) begin
                    next_wstate = WS_RESP;
                end else begin
                    next_wcount = wcount + 1;
                    next_wstate = WS_WRITE;
                end
            end
        end
        WS_RESP: begin
            axi_bready_o = 1;
            if (axi_bready_o && axi_bvalid_i) begin
                next_fifo_count = next_fifo_count - 1;
                next_line_valid[fifo_front] = 0;
                next_fifo_front = fifo_front + 1;
                if (next_fifo_count > 0) begin
                    next_wstate = WS_ADDR;
                end else begin
                    next_wstate = WS_IDLE;
                end
            end
        end
        endcase
    end
end

always_ff@(posedge clock) begin
    if (!resetn) begin
        line_valid <= 0;
        fifo_count <= 0;
        fifo_front <= 0;
        fifo_tail <= 0;
        wstate <= WS_IDLE;
        wcount <= 0;
        buf_raddr <= 0;
    end else begin
        line_valid <= next_line_valid;
        fifo_count <= next_fifo_count;
        fifo_front <= next_fifo_front;
        fifo_tail <= next_fifo_tail;
        cache_data <= next_cache_data;
        wstate <= next_wstate;
        wcount <= next_wcount;
        buf_raddr <= next_buf_raddr;
    end
end

endmodule
