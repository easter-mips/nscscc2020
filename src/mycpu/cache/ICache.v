module BlockMem(
  input         clock,
  input  [7:0]  io_addr,
  input         io_wEn,
  input  [31:0] io_dataIn_0,
  input  [31:0] io_dataIn_1,
  input  [31:0] io_dataIn_2,
  input  [31:0] io_dataIn_3,
  input  [31:0] io_dataIn_4,
  input  [31:0] io_dataIn_5,
  input  [31:0] io_dataIn_6,
  input  [31:0] io_dataIn_7,
  output [31:0] io_dataOut_0,
  output [31:0] io_dataOut_1,
  output [31:0] io_dataOut_2,
  output [31:0] io_dataOut_3,
  output [31:0] io_dataOut_4,
  output [31:0] io_dataOut_5,
  output [31:0] io_dataOut_6,
  output [31:0] io_dataOut_7
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_14;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_15;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] mem_0 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_0__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_0__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_0__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_0__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_0__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_0__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_0__T_3_addr_pipe_0;
  reg [31:0] mem_1 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_1__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_1__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_1__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_1__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_1__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_1__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_1__T_3_addr_pipe_0;
  reg [31:0] mem_2 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_2__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_2__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_2__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_2__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_2__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_2__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_2__T_3_addr_pipe_0;
  reg [31:0] mem_3 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_3__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_3__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_3__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_3__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_3__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_3__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_3__T_3_addr_pipe_0;
  reg [31:0] mem_4 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_4__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_4__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_4__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_4__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_4__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_4__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_4__T_3_addr_pipe_0;
  reg [31:0] mem_5 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_5__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_5__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_5__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_5__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_5__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_5__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_5__T_3_addr_pipe_0;
  reg [31:0] mem_6 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_6__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_6__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_6__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_6__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_6__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_6__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_6__T_3_addr_pipe_0;
  reg [31:0] mem_7 [0:255]; // @[BlockMem.scala 17:24]
  wire [31:0] mem_7__T_3_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_7__T_3_addr; // @[BlockMem.scala 17:24]
  wire [31:0] mem_7__T_4_data; // @[BlockMem.scala 17:24]
  wire [7:0] mem_7__T_4_addr; // @[BlockMem.scala 17:24]
  wire  mem_7__T_4_mask; // @[BlockMem.scala 17:24]
  wire  mem_7__T_4_en; // @[BlockMem.scala 17:24]
  reg [7:0] mem_7__T_3_addr_pipe_0;
  assign mem_0__T_3_addr = mem_0__T_3_addr_pipe_0;
  assign mem_0__T_3_data = mem_0[mem_0__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_0__T_4_data = io_dataIn_0;
  assign mem_0__T_4_addr = io_addr;
  assign mem_0__T_4_mask = 1'h1;
  assign mem_0__T_4_en = io_wEn;
  assign mem_1__T_3_addr = mem_1__T_3_addr_pipe_0;
  assign mem_1__T_3_data = mem_1[mem_1__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_1__T_4_data = io_dataIn_1;
  assign mem_1__T_4_addr = io_addr;
  assign mem_1__T_4_mask = 1'h1;
  assign mem_1__T_4_en = io_wEn;
  assign mem_2__T_3_addr = mem_2__T_3_addr_pipe_0;
  assign mem_2__T_3_data = mem_2[mem_2__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_2__T_4_data = io_dataIn_2;
  assign mem_2__T_4_addr = io_addr;
  assign mem_2__T_4_mask = 1'h1;
  assign mem_2__T_4_en = io_wEn;
  assign mem_3__T_3_addr = mem_3__T_3_addr_pipe_0;
  assign mem_3__T_3_data = mem_3[mem_3__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_3__T_4_data = io_dataIn_3;
  assign mem_3__T_4_addr = io_addr;
  assign mem_3__T_4_mask = 1'h1;
  assign mem_3__T_4_en = io_wEn;
  assign mem_4__T_3_addr = mem_4__T_3_addr_pipe_0;
  assign mem_4__T_3_data = mem_4[mem_4__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_4__T_4_data = io_dataIn_4;
  assign mem_4__T_4_addr = io_addr;
  assign mem_4__T_4_mask = 1'h1;
  assign mem_4__T_4_en = io_wEn;
  assign mem_5__T_3_addr = mem_5__T_3_addr_pipe_0;
  assign mem_5__T_3_data = mem_5[mem_5__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_5__T_4_data = io_dataIn_5;
  assign mem_5__T_4_addr = io_addr;
  assign mem_5__T_4_mask = 1'h1;
  assign mem_5__T_4_en = io_wEn;
  assign mem_6__T_3_addr = mem_6__T_3_addr_pipe_0;
  assign mem_6__T_3_data = mem_6[mem_6__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_6__T_4_data = io_dataIn_6;
  assign mem_6__T_4_addr = io_addr;
  assign mem_6__T_4_mask = 1'h1;
  assign mem_6__T_4_en = io_wEn;
  assign mem_7__T_3_addr = mem_7__T_3_addr_pipe_0;
  assign mem_7__T_3_data = mem_7[mem_7__T_3_addr]; // @[BlockMem.scala 17:24]
  assign mem_7__T_4_data = io_dataIn_7;
  assign mem_7__T_4_addr = io_addr;
  assign mem_7__T_4_mask = 1'h1;
  assign mem_7__T_4_en = io_wEn;
  assign io_dataOut_0 = mem_0__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_1 = mem_1__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_2 = mem_2__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_3 = mem_3__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_4 = mem_4__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_5 = mem_5__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_6 = mem_6__T_3_data; // @[BlockMem.scala 19:14]
  assign io_dataOut_7 = mem_7__T_3_data; // @[BlockMem.scala 19:14]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_0[initvar] = _RAND_0[31:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_1[initvar] = _RAND_2[31:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_2[initvar] = _RAND_4[31:0];
  _RAND_6 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_3[initvar] = _RAND_6[31:0];
  _RAND_8 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_4[initvar] = _RAND_8[31:0];
  _RAND_10 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_5[initvar] = _RAND_10[31:0];
  _RAND_12 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_6[initvar] = _RAND_12[31:0];
  _RAND_14 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    mem_7[initvar] = _RAND_14[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem_0__T_3_addr_pipe_0 = _RAND_1[7:0];
  _RAND_3 = {1{`RANDOM}};
  mem_1__T_3_addr_pipe_0 = _RAND_3[7:0];
  _RAND_5 = {1{`RANDOM}};
  mem_2__T_3_addr_pipe_0 = _RAND_5[7:0];
  _RAND_7 = {1{`RANDOM}};
  mem_3__T_3_addr_pipe_0 = _RAND_7[7:0];
  _RAND_9 = {1{`RANDOM}};
  mem_4__T_3_addr_pipe_0 = _RAND_9[7:0];
  _RAND_11 = {1{`RANDOM}};
  mem_5__T_3_addr_pipe_0 = _RAND_11[7:0];
  _RAND_13 = {1{`RANDOM}};
  mem_6__T_3_addr_pipe_0 = _RAND_13[7:0];
  _RAND_15 = {1{`RANDOM}};
  mem_7__T_3_addr_pipe_0 = _RAND_15[7:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(mem_0__T_4_en & mem_0__T_4_mask) begin
      mem_0[mem_0__T_4_addr] <= mem_0__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_0__T_3_addr_pipe_0 <= io_addr;
    if(mem_1__T_4_en & mem_1__T_4_mask) begin
      mem_1[mem_1__T_4_addr] <= mem_1__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_1__T_3_addr_pipe_0 <= io_addr;
    if(mem_2__T_4_en & mem_2__T_4_mask) begin
      mem_2[mem_2__T_4_addr] <= mem_2__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_2__T_3_addr_pipe_0 <= io_addr;
    if(mem_3__T_4_en & mem_3__T_4_mask) begin
      mem_3[mem_3__T_4_addr] <= mem_3__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_3__T_3_addr_pipe_0 <= io_addr;
    if(mem_4__T_4_en & mem_4__T_4_mask) begin
      mem_4[mem_4__T_4_addr] <= mem_4__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_4__T_3_addr_pipe_0 <= io_addr;
    if(mem_5__T_4_en & mem_5__T_4_mask) begin
      mem_5[mem_5__T_4_addr] <= mem_5__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_5__T_3_addr_pipe_0 <= io_addr;
    if(mem_6__T_4_en & mem_6__T_4_mask) begin
      mem_6[mem_6__T_4_addr] <= mem_6__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_6__T_3_addr_pipe_0 <= io_addr;
    if(mem_7__T_4_en & mem_7__T_4_mask) begin
      mem_7[mem_7__T_4_addr] <= mem_7__T_4_data; // @[BlockMem.scala 17:24]
    end
    mem_7__T_3_addr_pipe_0 <= io_addr;
  end
endmodule
module LruFsm(
  input   io_current,
  input   io_visit,
  output  io_next,
  output  io_sel
);
  wire [1:0] _T = {io_current, 1'h0}; // @[LruFsm.scala 43:77]
  wire [1:0] _GEN_6 = {{1'd0}, io_visit}; // @[LruFsm.scala 43:95]
  wire [1:0] _T_1 = _T | _GEN_6; // @[LruFsm.scala 43:95]
  wire  _GEN_1 = 2'h1 == _T_1 ? 1'h0 : 1'h1; // @[LruFsm.scala 45:11]
  wire  _GEN_7 = 2'h2 == _T_1; // @[LruFsm.scala 45:11]
  wire  _GEN_2 = _GEN_7 | _GEN_1; // @[LruFsm.scala 45:11]
  assign io_next = 2'h3 == _T_1 ? 1'h0 : _GEN_2; // @[LruFsm.scala 45:11]
  assign io_sel = io_current; // @[LruFsm.scala 46:10]
endmodule
module LruMem(
  input        clock,
  input        reset,
  input  [7:0] io_setAddr,
  input        io_visit,
  input        io_visitValid,
  output       io_waySel
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [255:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg  lruMem [0:255]; // @[LruMem.scala 31:19]
  wire  lruMem__T_2_data; // @[LruMem.scala 31:19]
  wire [7:0] lruMem__T_2_addr; // @[LruMem.scala 31:19]
  wire  lruMem__T_6_data; // @[LruMem.scala 31:19]
  wire [7:0] lruMem__T_6_addr; // @[LruMem.scala 31:19]
  wire  lruMem__T_6_mask; // @[LruMem.scala 31:19]
  wire  lruMem__T_6_en; // @[LruMem.scala 31:19]
  wire  lruFsm_io_current; // @[LruMem.scala 36:22]
  wire  lruFsm_io_visit; // @[LruMem.scala 36:22]
  wire  lruFsm_io_next; // @[LruMem.scala 36:22]
  wire  lruFsm_io_sel; // @[LruMem.scala 36:22]
  reg [255:0] validMem; // @[LruMem.scala 32:25]
  wire [255:0] _T = validMem >> io_setAddr; // @[LruMem.scala 34:47]
  wire [255:0] _T_4 = 256'h1 << io_setAddr; // @[LruMem.scala 11:10]
  wire [255:0] _T_5 = validMem | _T_4; // @[LruMem.scala 16:7]
  LruFsm lruFsm ( // @[LruMem.scala 36:22]
    .io_current(lruFsm_io_current),
    .io_visit(lruFsm_io_visit),
    .io_next(lruFsm_io_next),
    .io_sel(lruFsm_io_sel)
  );
  assign lruMem__T_2_addr = io_setAddr;
  assign lruMem__T_2_data = lruMem[lruMem__T_2_addr]; // @[LruMem.scala 31:19]
  assign lruMem__T_6_data = lruFsm_io_next;
  assign lruMem__T_6_addr = io_setAddr;
  assign lruMem__T_6_mask = 1'h1;
  assign lruMem__T_6_en = io_visitValid;
  assign io_waySel = lruFsm_io_sel; // @[LruMem.scala 39:13]
  assign lruFsm_io_current = _T[0] & lruMem__T_2_data; // @[LruMem.scala 37:21]
  assign lruFsm_io_visit = io_visit; // @[LruMem.scala 38:19]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    lruMem[initvar] = _RAND_0[0:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {8{`RANDOM}};
  validMem = _RAND_1[255:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(lruMem__T_6_en & lruMem__T_6_mask) begin
      lruMem[lruMem__T_6_addr] <= lruMem__T_6_data; // @[LruMem.scala 31:19]
    end
    if (reset) begin
      validMem <= 256'h0;
    end else if (io_visitValid) begin
      validMem <= _T_5;
    end
  end
endmodule
module ICache(
  input         clock,
  input         reset,
  input         io_enable,
  input  [31:0] io_iAddr,
  output [31:0] io_inst1,
  output [31:0] io_inst2,
  output        io_inst1Valid,
  output        io_inst2Valid,
  input  [3:0]  io_action,
  output [3:0]  io_axiReadAddrOut_arid,
  output [31:0] io_axiReadAddrOut_araddr,
  output        io_axiReadAddrOut_arvalid,
  output [3:0]  io_axiReadAddrOut_arlen,
  output [2:0]  io_axiReadAddrOut_arsize,
  output [1:0]  io_axiReadAddrOut_arburst,
  input         io_axiReadAddrIn_arready,
  output        io_axiReadOut_rready,
  input  [3:0]  io_axiReadIn_rid,
  input  [31:0] io_axiReadIn_rdata,
  input  [1:0]  io_axiReadIn_rresp,
  input         io_axiReadIn_rlast,
  input         io_axiReadIn_rvalid,
  output [31:0] io_hitStats_hitCount,
  output [31:0] io_hitStats_missCount
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [255:0] _RAND_5;
  reg [255:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
`endif // RANDOMIZE_REG_INIT
  wire  dataMem_0_clock; // @[ICache.scala 51:11]
  wire [7:0] dataMem_0_io_addr; // @[ICache.scala 51:11]
  wire  dataMem_0_io_wEn; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_0; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_1; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_2; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_3; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_4; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_5; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_6; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataIn_7; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_0; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_1; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_2; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_3; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_4; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_5; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_6; // @[ICache.scala 51:11]
  wire [31:0] dataMem_0_io_dataOut_7; // @[ICache.scala 51:11]
  wire  dataMem_1_clock; // @[ICache.scala 51:11]
  wire [7:0] dataMem_1_io_addr; // @[ICache.scala 51:11]
  wire  dataMem_1_io_wEn; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_0; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_1; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_2; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_3; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_4; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_5; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_6; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataIn_7; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_0; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_1; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_2; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_3; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_4; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_5; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_6; // @[ICache.scala 51:11]
  wire [31:0] dataMem_1_io_dataOut_7; // @[ICache.scala 51:11]
  reg [18:0] tagMem [0:511]; // @[ICache.scala 66:19]
  wire [18:0] tagMem__T_115_data; // @[ICache.scala 66:19]
  wire [8:0] tagMem__T_115_addr; // @[ICache.scala 66:19]
  wire [18:0] tagMem__T_121_data; // @[ICache.scala 66:19]
  wire [8:0] tagMem__T_121_addr; // @[ICache.scala 66:19]
  wire [18:0] tagMem__T_312_data; // @[ICache.scala 66:19]
  wire [8:0] tagMem__T_312_addr; // @[ICache.scala 66:19]
  wire  tagMem__T_312_mask; // @[ICache.scala 66:19]
  wire  tagMem__T_312_en; // @[ICache.scala 66:19]
  wire [18:0] tagMem__T_337_data; // @[ICache.scala 66:19]
  wire [8:0] tagMem__T_337_addr; // @[ICache.scala 66:19]
  wire  tagMem__T_337_mask; // @[ICache.scala 66:19]
  wire  tagMem__T_337_en; // @[ICache.scala 66:19]
  wire [18:0] tagMem__T_362_data; // @[ICache.scala 66:19]
  wire [8:0] tagMem__T_362_addr; // @[ICache.scala 66:19]
  wire  tagMem__T_362_mask; // @[ICache.scala 66:19]
  wire  tagMem__T_362_en; // @[ICache.scala 66:19]
  wire [18:0] tagMem__T_387_data; // @[ICache.scala 66:19]
  wire [8:0] tagMem__T_387_addr; // @[ICache.scala 66:19]
  wire  tagMem__T_387_mask; // @[ICache.scala 66:19]
  wire  tagMem__T_387_en; // @[ICache.scala 66:19]
  wire  lruMem_clock; // @[ICache.scala 67:22]
  wire  lruMem_reset; // @[ICache.scala 67:22]
  wire [7:0] lruMem_io_setAddr; // @[ICache.scala 67:22]
  wire  lruMem_io_visit; // @[ICache.scala 67:22]
  wire  lruMem_io_visitValid; // @[ICache.scala 67:22]
  wire  lruMem_io_waySel; // @[ICache.scala 67:22]
  reg [31:0] rBuf_0 [0:7]; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_7_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_7_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_8_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_8_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_9_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_9_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_10_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_10_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_11_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_11_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_12_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_12_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_13_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_13_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_14_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_14_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_0__T_301_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_0__T_301_addr; // @[ICache.scala 76:39]
  wire  rBuf_0__T_301_mask; // @[ICache.scala 76:39]
  wire  rBuf_0__T_301_en; // @[ICache.scala 76:39]
  reg [31:0] rBuf_1 [0:7]; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_16_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_16_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_17_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_17_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_18_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_18_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_19_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_19_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_20_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_20_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_21_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_21_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_22_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_22_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_23_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_23_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_1__T_326_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_1__T_326_addr; // @[ICache.scala 76:39]
  wire  rBuf_1__T_326_mask; // @[ICache.scala 76:39]
  wire  rBuf_1__T_326_en; // @[ICache.scala 76:39]
  reg [31:0] rBuf_2 [0:7]; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_25_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_25_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_26_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_26_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_27_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_27_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_28_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_28_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_29_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_29_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_30_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_30_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_31_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_31_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_32_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_32_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_2__T_351_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_2__T_351_addr; // @[ICache.scala 76:39]
  wire  rBuf_2__T_351_mask; // @[ICache.scala 76:39]
  wire  rBuf_2__T_351_en; // @[ICache.scala 76:39]
  reg [31:0] rBuf_3 [0:7]; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_34_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_34_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_35_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_35_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_36_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_36_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_37_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_37_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_38_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_38_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_39_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_39_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_40_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_40_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_41_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_41_addr; // @[ICache.scala 76:39]
  wire [31:0] rBuf_3__T_376_data; // @[ICache.scala 76:39]
  wire [2:0] rBuf_3__T_376_addr; // @[ICache.scala 76:39]
  wire  rBuf_3__T_376_mask; // @[ICache.scala 76:39]
  wire  rBuf_3__T_376_en; // @[ICache.scala 76:39]
  reg [255:0] validMem_0; // @[ICache.scala 65:25]
  reg [255:0] validMem_1; // @[ICache.scala 65:25]
  reg [1:0] rState_0; // @[ICache.scala 73:23]
  reg [1:0] rState_1; // @[ICache.scala 73:23]
  reg [1:0] rState_2; // @[ICache.scala 73:23]
  reg [1:0] rState_3; // @[ICache.scala 73:23]
  reg [31:0] rAddr_0; // @[ICache.scala 74:22]
  reg [31:0] rAddr_1; // @[ICache.scala 74:22]
  reg [31:0] rAddr_2; // @[ICache.scala 74:22]
  reg [31:0] rAddr_3; // @[ICache.scala 74:22]
  reg [2:0] rBank_0; // @[ICache.scala 75:22]
  reg [2:0] rBank_1; // @[ICache.scala 75:22]
  reg [2:0] rBank_2; // @[ICache.scala 75:22]
  reg [2:0] rBank_3; // @[ICache.scala 75:22]
  reg [7:0] rValid_0; // @[ICache.scala 77:23]
  reg [7:0] rValid_1; // @[ICache.scala 77:23]
  reg [7:0] rValid_2; // @[ICache.scala 77:23]
  reg [7:0] rValid_3; // @[ICache.scala 77:23]
  reg  rRefillWay_0; // @[ICache.scala 78:27]
  reg  rRefillWay_1; // @[ICache.scala 78:27]
  reg  rRefillWay_2; // @[ICache.scala 78:27]
  reg  rRefillWay_3; // @[ICache.scala 78:27]
  reg  rInvalid_0; // @[ICache.scala 79:25]
  reg  rInvalid_1; // @[ICache.scala 79:25]
  reg  rInvalid_2; // @[ICache.scala 79:25]
  reg  rInvalid_3; // @[ICache.scala 79:25]
  wire  rIsIdle_0 = rState_0 == 2'h0; // @[ICache.scala 83:70]
  wire  rIsIdle_1 = rState_1 == 2'h0; // @[ICache.scala 83:70]
  wire  rIsIdle_2 = rState_2 == 2'h0; // @[ICache.scala 83:70]
  wire  rIsIdle_3 = rState_3 == 2'h0; // @[ICache.scala 83:70]
  wire  rIsAddressing_0 = rState_0 == 2'h1; // @[ICache.scala 83:70]
  wire  rIsAddressing_1 = rState_1 == 2'h1; // @[ICache.scala 83:70]
  wire  rIsAddressing_2 = rState_2 == 2'h1; // @[ICache.scala 83:70]
  wire  rIsAddressing_3 = rState_3 == 2'h1; // @[ICache.scala 83:70]
  wire  rIsRefilling_0 = rState_0 == 2'h3; // @[ICache.scala 83:70]
  wire  rIsRefilling_1 = rState_1 == 2'h3; // @[ICache.scala 83:70]
  wire  rIsRefilling_2 = rState_2 == 2'h3; // @[ICache.scala 83:70]
  wire  rIsRefilling_3 = rState_3 == 2'h3; // @[ICache.scala 83:70]
  wire [1:0] _T_58 = rIsIdle_2 ? 2'h2 : 2'h3; // @[Mux.scala 47:69]
  wire [1:0] _T_59 = rIsIdle_1 ? 2'h1 : _T_58; // @[Mux.scala 47:69]
  wire [1:0] idleSel = rIsIdle_0 ? 2'h0 : _T_59; // @[Mux.scala 47:69]
  wire [1:0] _T_61 = rIsAddressing_2 ? 2'h2 : 2'h3; // @[Mux.scala 47:69]
  wire [1:0] _T_62 = rIsAddressing_1 ? 2'h1 : _T_61; // @[Mux.scala 47:69]
  wire [1:0] addressingSel = rIsAddressing_0 ? 2'h0 : _T_62; // @[Mux.scala 47:69]
  wire [1:0] _T_64 = rIsRefilling_2 ? 2'h2 : 2'h3; // @[Mux.scala 47:69]
  wire [1:0] _T_65 = rIsRefilling_1 ? 2'h1 : _T_64; // @[Mux.scala 47:69]
  wire [1:0] refillSel = rIsRefilling_0 ? 2'h0 : _T_65; // @[Mux.scala 47:69]
  wire  _T_67 = io_axiReadIn_rid == 4'h0; // @[ICache.scala 101:45]
  wire  _T_68 = io_axiReadIn_rvalid & _T_67; // @[ICache.scala 101:25]
  wire  _T_69 = io_axiReadIn_rid == 4'h1; // @[ICache.scala 101:45]
  wire  _T_70 = io_axiReadIn_rvalid & _T_69; // @[ICache.scala 101:25]
  wire  _T_71 = io_axiReadIn_rid == 4'h2; // @[ICache.scala 101:45]
  wire  _T_72 = io_axiReadIn_rvalid & _T_71; // @[ICache.scala 101:25]
  wire  _T_73 = io_axiReadIn_rid == 4'h3; // @[ICache.scala 101:45]
  wire  _T_74 = io_axiReadIn_rvalid & _T_73; // @[ICache.scala 101:25]
  wire [3:0] axiRValid = {_T_74,_T_72,_T_70,_T_68}; // @[ICache.scala 102:5]
  reg [1:0] oState; // @[ICache.scala 106:23]
  reg [31:0] oKnownInst1; // @[ICache.scala 107:28]
  reg [31:0] oKnownInst2; // @[ICache.scala 108:28]
  reg  oReadWay; // @[ICache.scala 109:25]
  reg [2:0] oReadBank; // @[ICache.scala 110:26]
  reg [31:0] hitCount; // @[ICache.scala 113:25]
  reg [31:0] missCount; // @[ICache.scala 114:26]
  reg [31:0] prevAddr; // @[ICache.scala 115:25]
  wire [18:0] iTag = io_iAddr[31:13]; // @[Types.scala 47:34]
  wire [7:0] iSet = io_iAddr[12:5]; // @[Types.scala 48:34]
  wire [2:0] iBank = io_iAddr[4:2]; // @[Types.scala 49:35]
  wire [31:0] _GEN_1 = 2'h1 == addressingSel ? rAddr_1 : rAddr_0; // @[ICache.scala 131:28]
  wire [31:0] _GEN_2 = 2'h2 == addressingSel ? rAddr_2 : _GEN_1; // @[ICache.scala 131:28]
  wire [3:0] _T_85 = {rIsAddressing_3,rIsAddressing_2,rIsAddressing_1,rIsAddressing_0}; // @[ICache.scala 132:46]
  wire  _T_86 = |_T_85; // @[ICache.scala 132:53]
  wire  _T_87 = rState_0 == 2'h2; // @[ICache.scala 83:70]
  wire  _T_88 = rState_1 == 2'h2; // @[ICache.scala 83:70]
  wire  _T_89 = rState_2 == 2'h2; // @[ICache.scala 83:70]
  wire  _T_90 = rState_3 == 2'h2; // @[ICache.scala 83:70]
  wire [3:0] _T_94 = {_T_90,_T_89,_T_88,_T_87}; // @[ICache.scala 136:43]
  wire [3:0] _T_98 = {rIsRefilling_3,rIsRefilling_2,rIsRefilling_1,rIsRefilling_0}; // @[ICache.scala 140:35]
  wire  _T_99 = |_T_98; // @[ICache.scala 140:42]
  wire [31:0] _GEN_5 = 2'h1 == refillSel ? rAddr_1 : rAddr_0; // @[Types.scala 48:34]
  wire [31:0] _GEN_6 = 2'h2 == refillSel ? rAddr_2 : _GEN_5; // @[Types.scala 48:34]
  wire [31:0] _GEN_7 = 2'h3 == refillSel ? rAddr_3 : _GEN_6; // @[Types.scala 48:34]
  wire [7:0] _T_101 = _T_99 ? _GEN_7[12:5] : iSet; // @[ICache.scala 140:21]
  wire [31:0] rBufData_0_0 = rBuf_0__T_7_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_1 = rBuf_0__T_8_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_2 = rBuf_0__T_9_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_3 = rBuf_0__T_10_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_4 = rBuf_0__T_11_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_5 = rBuf_0__T_12_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_6 = rBuf_0__T_13_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_0_7 = rBuf_0__T_14_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_1_0 = rBuf_1__T_16_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_16 = 2'h1 == refillSel ? rBufData_1_0 : rBufData_0_0; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_1 = rBuf_1__T_17_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_17 = 2'h1 == refillSel ? rBufData_1_1 : rBufData_0_1; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_2 = rBuf_1__T_18_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_18 = 2'h1 == refillSel ? rBufData_1_2 : rBufData_0_2; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_3 = rBuf_1__T_19_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_19 = 2'h1 == refillSel ? rBufData_1_3 : rBufData_0_3; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_4 = rBuf_1__T_20_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_20 = 2'h1 == refillSel ? rBufData_1_4 : rBufData_0_4; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_5 = rBuf_1__T_21_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_21 = 2'h1 == refillSel ? rBufData_1_5 : rBufData_0_5; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_6 = rBuf_1__T_22_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_22 = 2'h1 == refillSel ? rBufData_1_6 : rBufData_0_6; // @[ICache.scala 142:17]
  wire [31:0] rBufData_1_7 = rBuf_1__T_23_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_23 = 2'h1 == refillSel ? rBufData_1_7 : rBufData_0_7; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_0 = rBuf_2__T_25_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_24 = 2'h2 == refillSel ? rBufData_2_0 : _GEN_16; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_1 = rBuf_2__T_26_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_25 = 2'h2 == refillSel ? rBufData_2_1 : _GEN_17; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_2 = rBuf_2__T_27_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_26 = 2'h2 == refillSel ? rBufData_2_2 : _GEN_18; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_3 = rBuf_2__T_28_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_27 = 2'h2 == refillSel ? rBufData_2_3 : _GEN_19; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_4 = rBuf_2__T_29_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_28 = 2'h2 == refillSel ? rBufData_2_4 : _GEN_20; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_5 = rBuf_2__T_30_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_29 = 2'h2 == refillSel ? rBufData_2_5 : _GEN_21; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_6 = rBuf_2__T_31_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_30 = 2'h2 == refillSel ? rBufData_2_6 : _GEN_22; // @[ICache.scala 142:17]
  wire [31:0] rBufData_2_7 = rBuf_2__T_32_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] _GEN_31 = 2'h2 == refillSel ? rBufData_2_7 : _GEN_23; // @[ICache.scala 142:17]
  wire [31:0] rBufData_3_0 = rBuf_3__T_34_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_1 = rBuf_3__T_35_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_2 = rBuf_3__T_36_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_3 = rBuf_3__T_37_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_4 = rBuf_3__T_38_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_5 = rBuf_3__T_39_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_6 = rBuf_3__T_40_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire [31:0] rBufData_3_7 = rBuf_3__T_41_data; // @[ICache.scala 81:89 ICache.scala 81:89]
  wire  _GEN_41 = 2'h1 == refillSel ? rRefillWay_1 : rRefillWay_0; // @[ICache.scala 146:30]
  wire  _GEN_42 = 2'h2 == refillSel ? rRefillWay_2 : _GEN_41; // @[ICache.scala 146:30]
  wire  _GEN_43 = 2'h3 == refillSel ? rRefillWay_3 : _GEN_42; // @[ICache.scala 146:30]
  wire  _T_102 = ~_GEN_43; // @[ICache.scala 146:30]
  wire [1:0] _GEN_45 = 2'h1 == refillSel ? rState_1 : rState_0; // @[ICache.scala 146:77]
  wire [1:0] _GEN_46 = 2'h2 == refillSel ? rState_2 : _GEN_45; // @[ICache.scala 146:77]
  wire [1:0] _GEN_47 = 2'h3 == refillSel ? rState_3 : _GEN_46; // @[ICache.scala 146:77]
  wire  _T_103 = _GEN_47 == 2'h3; // @[ICache.scala 146:77]
  wire  _T_108 = 2'h0 == oState; // @[Conditional.scala 37:30]
  wire  _T_109 = 2'h1 == oState; // @[Conditional.scala 37:30]
  wire  _T_110 = 2'h2 == oState; // @[Conditional.scala 37:30]
  wire  _T_111 = 2'h3 == oState; // @[Conditional.scala 37:30]
  wire [31:0] rDataMem_0_0 = dataMem_0_io_dataOut_0; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] rDataMem_0_1 = dataMem_0_io_dataOut_1; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_593 = ~oReadWay; // @[ICache.scala 170:16]
  wire  _GEN_594 = 3'h1 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_50 = _GEN_593 & _GEN_594 ? rDataMem_0_1 : rDataMem_0_0; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_0_2 = dataMem_0_io_dataOut_2; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_596 = 3'h2 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_51 = _GEN_593 & _GEN_596 ? rDataMem_0_2 : _GEN_50; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_0_3 = dataMem_0_io_dataOut_3; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_598 = 3'h3 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_52 = _GEN_593 & _GEN_598 ? rDataMem_0_3 : _GEN_51; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_0_4 = dataMem_0_io_dataOut_4; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_600 = 3'h4 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_53 = _GEN_593 & _GEN_600 ? rDataMem_0_4 : _GEN_52; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_0_5 = dataMem_0_io_dataOut_5; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_602 = 3'h5 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_54 = _GEN_593 & _GEN_602 ? rDataMem_0_5 : _GEN_53; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_0_6 = dataMem_0_io_dataOut_6; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_604 = 3'h6 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_55 = _GEN_593 & _GEN_604 ? rDataMem_0_6 : _GEN_54; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_0_7 = dataMem_0_io_dataOut_7; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_606 = 3'h7 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_56 = _GEN_593 & _GEN_606 ? rDataMem_0_7 : _GEN_55; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_0 = dataMem_1_io_dataOut_0; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire  _GEN_607 = 3'h0 == oReadBank; // @[ICache.scala 170:16]
  wire [31:0] _GEN_57 = oReadWay & _GEN_607 ? rDataMem_1_0 : _GEN_56; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_1 = dataMem_1_io_dataOut_1; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_58 = oReadWay & _GEN_594 ? rDataMem_1_1 : _GEN_57; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_2 = dataMem_1_io_dataOut_2; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_59 = oReadWay & _GEN_596 ? rDataMem_1_2 : _GEN_58; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_3 = dataMem_1_io_dataOut_3; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_60 = oReadWay & _GEN_598 ? rDataMem_1_3 : _GEN_59; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_4 = dataMem_1_io_dataOut_4; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_61 = oReadWay & _GEN_600 ? rDataMem_1_4 : _GEN_60; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_5 = dataMem_1_io_dataOut_5; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_62 = oReadWay & _GEN_602 ? rDataMem_1_5 : _GEN_61; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_6 = dataMem_1_io_dataOut_6; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_63 = oReadWay & _GEN_604 ? rDataMem_1_6 : _GEN_62; // @[ICache.scala 170:16]
  wire [31:0] rDataMem_1_7 = dataMem_1_io_dataOut_7; // @[ICache.scala 56:25 ICache.scala 56:25]
  wire [31:0] _GEN_64 = oReadWay & _GEN_606 ? rDataMem_1_7 : _GEN_63; // @[ICache.scala 170:16]
  wire [2:0] _T_113 = oReadBank + 3'h1; // @[ICache.scala 171:48]
  wire  _GEN_616 = 3'h1 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_66 = _GEN_593 & _GEN_616 ? rDataMem_0_1 : rDataMem_0_0; // @[ICache.scala 171:16]
  wire  _GEN_618 = 3'h2 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_67 = _GEN_593 & _GEN_618 ? rDataMem_0_2 : _GEN_66; // @[ICache.scala 171:16]
  wire  _GEN_620 = 3'h3 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_68 = _GEN_593 & _GEN_620 ? rDataMem_0_3 : _GEN_67; // @[ICache.scala 171:16]
  wire  _GEN_622 = 3'h4 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_69 = _GEN_593 & _GEN_622 ? rDataMem_0_4 : _GEN_68; // @[ICache.scala 171:16]
  wire  _GEN_624 = 3'h5 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_70 = _GEN_593 & _GEN_624 ? rDataMem_0_5 : _GEN_69; // @[ICache.scala 171:16]
  wire  _GEN_626 = 3'h6 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_71 = _GEN_593 & _GEN_626 ? rDataMem_0_6 : _GEN_70; // @[ICache.scala 171:16]
  wire  _GEN_628 = 3'h7 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_72 = _GEN_593 & _GEN_628 ? rDataMem_0_7 : _GEN_71; // @[ICache.scala 171:16]
  wire  _GEN_629 = 3'h0 == _T_113; // @[ICache.scala 171:16]
  wire [31:0] _GEN_73 = oReadWay & _GEN_629 ? rDataMem_1_0 : _GEN_72; // @[ICache.scala 171:16]
  wire [31:0] _GEN_74 = oReadWay & _GEN_616 ? rDataMem_1_1 : _GEN_73; // @[ICache.scala 171:16]
  wire [31:0] _GEN_75 = oReadWay & _GEN_618 ? rDataMem_1_2 : _GEN_74; // @[ICache.scala 171:16]
  wire [31:0] _GEN_76 = oReadWay & _GEN_620 ? rDataMem_1_3 : _GEN_75; // @[ICache.scala 171:16]
  wire [31:0] _GEN_77 = oReadWay & _GEN_622 ? rDataMem_1_4 : _GEN_76; // @[ICache.scala 171:16]
  wire [31:0] _GEN_78 = oReadWay & _GEN_624 ? rDataMem_1_5 : _GEN_77; // @[ICache.scala 171:16]
  wire [31:0] _GEN_79 = oReadWay & _GEN_626 ? rDataMem_1_6 : _GEN_78; // @[ICache.scala 171:16]
  wire [31:0] _GEN_80 = oReadWay & _GEN_628 ? rDataMem_1_7 : _GEN_79; // @[ICache.scala 171:16]
  wire [31:0] _GEN_81 = _T_111 ? _GEN_64 : 32'h0; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_82 = _T_111 ? _GEN_80 : 32'h0; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_83 = _T_110 ? oKnownInst1 : _GEN_81; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_84 = _T_110 ? oKnownInst2 : _GEN_82; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_85 = _T_109 ? oKnownInst1 : _GEN_83; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_86 = _T_109 ? 32'h0 : _GEN_84; // @[Conditional.scala 39:67]
  wire  _T_116 = tagMem__T_115_data == iTag; // @[ICache.scala 179:51]
  wire [255:0] _T_117 = validMem_0 >> iSet; // @[ICache.scala 179:98]
  wire  _T_119 = _T_116 & _T_117[0]; // @[ICache.scala 179:60]
  wire  _T_122 = tagMem__T_121_data == iTag; // @[ICache.scala 179:51]
  wire [255:0] _T_123 = validMem_1 >> iSet; // @[ICache.scala 179:98]
  wire  _T_125 = _T_122 & _T_123[0]; // @[ICache.scala 179:60]
  wire [1:0] hitWays = {_T_125,_T_119}; // @[ICache.scala 180:5]
  wire  _T_128 = |hitWays; // @[ICache.scala 182:24]
  wire  _T_133 = ~_T_99; // @[ICache.scala 182:30]
  wire  hitWay = _T_128 & _T_133; // @[ICache.scala 182:27]
  wire  hitWayId = hitWays[1]; // @[CircuitMath.scala 30:8]
  wire  _T_138 = io_iAddr[31:5] == rAddr_0[31:5]; // @[ICache.scala 188:36]
  wire  _T_139 = rState_0 != 2'h0; // @[ICache.scala 189:17]
  wire  _T_140 = _T_138 & _T_139; // @[ICache.scala 188:71]
  wire  _T_143 = io_iAddr[31:5] == rAddr_1[31:5]; // @[ICache.scala 188:36]
  wire  _T_144 = rState_1 != 2'h0; // @[ICache.scala 189:17]
  wire  _T_145 = _T_143 & _T_144; // @[ICache.scala 188:71]
  wire  _T_148 = io_iAddr[31:5] == rAddr_2[31:5]; // @[ICache.scala 188:36]
  wire  _T_149 = rState_2 != 2'h0; // @[ICache.scala 189:17]
  wire  _T_150 = _T_148 & _T_149; // @[ICache.scala 188:71]
  wire  _T_153 = io_iAddr[31:5] == rAddr_3[31:5]; // @[ICache.scala 188:36]
  wire  _T_154 = rState_3 != 2'h0; // @[ICache.scala 189:17]
  wire  _T_155 = _T_153 & _T_154; // @[ICache.scala 188:71]
  wire [3:0] inAxiReads = {_T_155,_T_150,_T_145,_T_140}; // @[ICache.scala 190:5]
  wire  inAxiRead = |inAxiReads; // @[ICache.scala 192:27]
  wire  _T_162 = iBank == rBank_0; // @[ICache.scala 196:28]
  wire  _T_163 = inAxiReads[0] & _T_162; // @[ICache.scala 196:19]
  wire  _T_165 = _T_163 & axiRValid[0]; // @[ICache.scala 196:41]
  wire  _T_167 = _T_165 & _T_87; // @[ICache.scala 196:57]
  wire  _T_169 = iBank == rBank_1; // @[ICache.scala 196:28]
  wire  _T_170 = inAxiReads[1] & _T_169; // @[ICache.scala 196:19]
  wire  _T_172 = _T_170 & axiRValid[1]; // @[ICache.scala 196:41]
  wire  _T_174 = _T_172 & _T_88; // @[ICache.scala 196:57]
  wire  _T_176 = iBank == rBank_2; // @[ICache.scala 196:28]
  wire  _T_177 = inAxiReads[2] & _T_176; // @[ICache.scala 196:19]
  wire  _T_179 = _T_177 & axiRValid[2]; // @[ICache.scala 196:41]
  wire  _T_181 = _T_179 & _T_89; // @[ICache.scala 196:57]
  wire  _T_183 = iBank == rBank_3; // @[ICache.scala 196:28]
  wire  _T_184 = inAxiReads[3] & _T_183; // @[ICache.scala 196:19]
  wire  _T_186 = _T_184 & axiRValid[3]; // @[ICache.scala 196:41]
  wire  _T_188 = _T_186 & _T_90; // @[ICache.scala 196:57]
  wire [3:0] hitAxiDirects = {_T_188,_T_181,_T_174,_T_167}; // @[ICache.scala 197:5]
  wire  hitAxiDirect = |hitAxiDirects; // @[ICache.scala 199:36]
  wire [1:0] _T_198 = hitAxiDirects[2] ? 2'h2 : 2'h3; // @[Mux.scala 47:69]
  wire [1:0] _T_199 = hitAxiDirects[1] ? 2'h1 : _T_198; // @[Mux.scala 47:69]
  wire [1:0] hitAxiDirectId = hitAxiDirects[0] ? 2'h0 : _T_199; // @[Mux.scala 47:69]
  wire [7:0] _T_202 = rValid_0 >> iBank; // @[ICache.scala 205:31]
  wire  _T_204 = inAxiReads[0] & _T_202[0]; // @[ICache.scala 205:19]
  wire  _T_207 = _T_87 | rIsRefilling_0; // @[ICache.scala 205:64]
  wire  _T_208 = _T_204 & _T_207; // @[ICache.scala 205:39]
  wire [7:0] _T_210 = rValid_1 >> iBank; // @[ICache.scala 205:31]
  wire  _T_212 = inAxiReads[1] & _T_210[0]; // @[ICache.scala 205:19]
  wire  _T_215 = _T_88 | rIsRefilling_1; // @[ICache.scala 205:64]
  wire  _T_216 = _T_212 & _T_215; // @[ICache.scala 205:39]
  wire [7:0] _T_218 = rValid_2 >> iBank; // @[ICache.scala 205:31]
  wire  _T_220 = inAxiReads[2] & _T_218[0]; // @[ICache.scala 205:19]
  wire  _T_223 = _T_89 | rIsRefilling_2; // @[ICache.scala 205:64]
  wire  _T_224 = _T_220 & _T_223; // @[ICache.scala 205:39]
  wire [7:0] _T_226 = rValid_3 >> iBank; // @[ICache.scala 205:31]
  wire  _T_228 = inAxiReads[3] & _T_226[0]; // @[ICache.scala 205:19]
  wire  _T_231 = _T_90 | rIsRefilling_3; // @[ICache.scala 205:64]
  wire  _T_232 = _T_228 & _T_231; // @[ICache.scala 205:39]
  wire [3:0] _T_236 = {_T_232,_T_224,_T_216,_T_208}; // @[ICache.scala 206:5]
  wire [1:0] hitAxiBufs = _T_236[1:0]; // @[ICache.scala 203:24 ICache.scala 204:14]
  wire  hitAxiBuf = |hitAxiBufs; // @[ICache.scala 208:27]
  wire  _T_240 = hitAxiBufs[0] ? 1'h0 : 1'h1; // @[Mux.scala 47:69]
  wire  invalidAddr = io_iAddr[1:0] != 2'h0; // @[ICache.scala 213:33]
  wire  _T_243 = hitAxiDirect | hitAxiBuf; // @[ICache.scala 215:40]
  wire  _T_244 = _T_243 | hitWay; // @[ICache.scala 215:53]
  wire  _T_245 = io_iAddr != prevAddr; // @[ICache.scala 217:31]
  wire  _T_246 = io_enable & _T_245; // @[ICache.scala 217:19]
  wire  _T_249 = _T_244 | invalidAddr; // @[ICache.scala 218:47]
  wire [31:0] _T_251 = hitCount + 32'h1; // @[ICache.scala 219:28]
  wire [31:0] _T_253 = missCount + 32'h1; // @[ICache.scala 221:30]
  wire  actionAddr = io_action[3]; // @[ICache.scala 229:26]
  wire  actionInv = io_action[2]; // @[ICache.scala 230:25]
  wire  actionValid = |io_action[2:0]; // @[ICache.scala 231:34]
  wire  _T_258 = ~actionAddr; // @[ICache.scala 234:22]
  wire  _T_259 = _T_258 & hitWay; // @[ICache.scala 234:30]
  wire [255:0] _T_260 = 256'h1 << iSet; // @[ICache.scala 36:10]
  wire [255:0] _T_261 = ~_T_260; // @[ICache.scala 46:10]
  wire [255:0] _GEN_94 = hitWayId ? validMem_1 : validMem_0; // @[ICache.scala 46:7]
  wire [255:0] _T_262 = _GEN_94 & _T_261; // @[ICache.scala 46:7]
  wire [255:0] _GEN_95 = ~hitWayId ? _T_262 : validMem_0; // @[ICache.scala 235:26]
  wire [255:0] _GEN_96 = hitWayId ? _T_262 : validMem_1; // @[ICache.scala 235:26]
  wire  _T_265 = _T_258 & _T_243; // @[ICache.scala 236:36]
  wire [1:0] hitAxiBufId = {{1'd0}, _T_240}; // @[ICache.scala 209:25 ICache.scala 210:15]
  wire [1:0] _T_266 = hitAxiDirect ? hitAxiDirectId : hitAxiBufId; // @[ICache.scala 237:19]
  wire  _GEN_637 = 2'h0 == _T_266; // @[ICache.scala 237:64]
  wire  _GEN_97 = _GEN_637 | rInvalid_0; // @[ICache.scala 237:64]
  wire  _GEN_638 = 2'h1 == _T_266; // @[ICache.scala 237:64]
  wire  _GEN_98 = _GEN_638 | rInvalid_1; // @[ICache.scala 237:64]
  wire  _GEN_639 = 2'h2 == _T_266; // @[ICache.scala 237:64]
  wire  _GEN_99 = _GEN_639 | rInvalid_2; // @[ICache.scala 237:64]
  wire  _GEN_640 = 2'h3 == _T_266; // @[ICache.scala 237:64]
  wire  _GEN_100 = _GEN_640 | rInvalid_3; // @[ICache.scala 237:64]
  wire  _GEN_101 = _T_265 ? _GEN_97 : rInvalid_0; // @[ICache.scala 236:68]
  wire  _GEN_102 = _T_265 ? _GEN_98 : rInvalid_1; // @[ICache.scala 236:68]
  wire  _GEN_103 = _T_265 ? _GEN_99 : rInvalid_2; // @[ICache.scala 236:68]
  wire  _GEN_104 = _T_265 ? _GEN_100 : rInvalid_3; // @[ICache.scala 236:68]
  wire [255:0] _GEN_105 = _T_259 ? _GEN_95 : validMem_0; // @[ICache.scala 234:41]
  wire [255:0] _GEN_106 = _T_259 ? _GEN_96 : validMem_1; // @[ICache.scala 234:41]
  wire  _GEN_107 = _T_259 ? rInvalid_0 : _GEN_101; // @[ICache.scala 234:41]
  wire  _GEN_108 = _T_259 ? rInvalid_1 : _GEN_102; // @[ICache.scala 234:41]
  wire  _GEN_109 = _T_259 ? rInvalid_2 : _GEN_103; // @[ICache.scala 234:41]
  wire  _GEN_110 = _T_259 ? rInvalid_3 : _GEN_104; // @[ICache.scala 234:41]
  wire [255:0] _GEN_112 = iTag[0] ? validMem_1 : validMem_0; // @[ICache.scala 46:7]
  wire [255:0] _T_272 = _GEN_112 & _T_261; // @[ICache.scala 46:7]
  wire [255:0] _GEN_113 = ~iTag[0] ? _T_272 : _GEN_105; // @[ICache.scala 243:26]
  wire [255:0] _GEN_114 = iTag[0] ? _T_272 : _GEN_106; // @[ICache.scala 243:26]
  wire [255:0] _GEN_115 = actionAddr ? _GEN_113 : _GEN_105; // @[ICache.scala 239:31]
  wire [255:0] _GEN_116 = actionAddr ? _GEN_114 : _GEN_106; // @[ICache.scala 239:31]
  wire [255:0] _GEN_117 = actionInv ? _GEN_115 : validMem_0; // @[ICache.scala 233:20]
  wire [255:0] _GEN_118 = actionInv ? _GEN_116 : validMem_1; // @[ICache.scala 233:20]
  wire  _GEN_119 = actionInv ? _GEN_107 : rInvalid_0; // @[ICache.scala 233:20]
  wire  _GEN_120 = actionInv ? _GEN_108 : rInvalid_1; // @[ICache.scala 233:20]
  wire  _GEN_121 = actionInv ? _GEN_109 : rInvalid_2; // @[ICache.scala 233:20]
  wire  _GEN_122 = actionInv ? _GEN_110 : rInvalid_3; // @[ICache.scala 233:20]
  wire  _T_273 = ~actionValid; // @[ICache.scala 247:22]
  wire  _T_274 = io_enable & _T_273; // @[ICache.scala 247:19]
  wire  _GEN_128 = 2'h1 == hitAxiDirectId ? rRefillWay_1 : rRefillWay_0; // @[ICache.scala 259:23]
  wire  _GEN_129 = 2'h2 == hitAxiDirectId ? rRefillWay_2 : _GEN_128; // @[ICache.scala 259:23]
  wire  _GEN_130 = 2'h3 == hitAxiDirectId ? rRefillWay_3 : _GEN_129; // @[ICache.scala 259:23]
  wire  _T_275 = iBank != 3'h7; // @[ICache.scala 262:30]
  wire [2:0] _T_277 = iBank + 3'h1; // @[ICache.scala 262:67]
  wire [7:0] _GEN_132 = 2'h1 == hitAxiBufId ? rValid_1 : rValid_0; // @[ICache.scala 262:60]
  wire [7:0] _GEN_133 = 2'h2 == hitAxiBufId ? rValid_2 : _GEN_132; // @[ICache.scala 262:60]
  wire [7:0] _GEN_134 = 2'h3 == hitAxiBufId ? rValid_3 : _GEN_133; // @[ICache.scala 262:60]
  wire [7:0] _T_278 = _GEN_134 >> _T_277; // @[ICache.scala 262:60]
  wire  _T_280 = _T_275 & _T_278[0]; // @[ICache.scala 262:38]
  wire  _GEN_641 = 2'h0 == hitAxiBufId; // @[ICache.scala 264:19]
  wire  _GEN_642 = 3'h1 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_644 = 3'h2 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_646 = 3'h3 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_648 = 3'h4 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_650 = 3'h5 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_652 = 3'h6 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_654 = 3'h7 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_655 = 2'h1 == hitAxiBufId; // @[ICache.scala 264:19]
  wire  _GEN_656 = 3'h0 == iBank; // @[ICache.scala 264:19]
  wire  _GEN_671 = 2'h2 == hitAxiBufId; // @[ICache.scala 264:19]
  wire  _GEN_687 = 2'h3 == hitAxiBufId; // @[ICache.scala 264:19]
  wire  _GEN_704 = 3'h1 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_706 = 3'h2 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_708 = 3'h3 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_710 = 3'h4 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_712 = 3'h5 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_714 = 3'h6 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_716 = 3'h7 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_718 = 3'h0 == _T_277; // @[ICache.scala 265:19]
  wire  _GEN_200 = 2'h1 == hitAxiBufId ? rRefillWay_1 : rRefillWay_0; // @[ICache.scala 266:23]
  wire  _GEN_201 = 2'h2 == hitAxiBufId ? rRefillWay_2 : _GEN_200; // @[ICache.scala 266:23]
  wire  _GEN_202 = 2'h3 == hitAxiBufId ? rRefillWay_3 : _GEN_201; // @[ICache.scala 266:23]
  wire  _T_284 = |inAxiRead; // @[ICache.scala 277:24]
  wire  _T_285 = ~_T_284; // @[ICache.scala 277:13]
  wire [3:0] _T_288 = {rIsIdle_3,rIsIdle_2,rIsIdle_1,rIsIdle_0}; // @[ICache.scala 277:39]
  wire  _T_289 = |_T_288; // @[ICache.scala 277:46]
  wire  _T_290 = _T_285 & _T_289; // @[ICache.scala 277:28]
  wire  _T_295 = ~_T_86; // @[ICache.scala 277:53]
  wire  _T_296 = _T_290 & _T_295; // @[ICache.scala 277:50]
  wire  _rRefillWay_idleSel = lruMem_io_waySel; // @[ICache.scala 283:29 ICache.scala 283:29]
  wire  _GEN_251 = hitWay | invalidAddr; // @[ICache.scala 267:26]
  wire  _GEN_252 = hitWay ? _T_275 : invalidAddr; // @[ICache.scala 267:26]
  wire  _GEN_256 = hitWay & hitWayId; // @[ICache.scala 267:26]
  wire  _GEN_281 = hitAxiBuf | _GEN_251; // @[ICache.scala 260:29]
  wire  _GEN_282 = hitAxiBuf ? _T_280 : _GEN_252; // @[ICache.scala 260:29]
  wire  _GEN_286 = hitAxiBuf ? _GEN_202 : _GEN_256; // @[ICache.scala 260:29]
  wire  _GEN_313 = hitAxiDirect | _GEN_281; // @[ICache.scala 255:25]
  wire  _GEN_316 = hitAxiDirect ? _GEN_130 : _GEN_286; // @[ICache.scala 255:25]
  wire  _GEN_317 = hitAxiDirect ? invalidAddr : _GEN_282; // @[ICache.scala 255:25]
  wire  _T_297 = 2'h1 == rState_0; // @[Conditional.scala 37:30]
  wire  _T_298 = 2'h0 == addressingSel; // @[ICache.scala 292:19]
  wire  _T_299 = _T_298 & io_axiReadAddrIn_arready; // @[ICache.scala 292:37]
  wire  _T_300 = 2'h2 == rState_0; // @[Conditional.scala 37:30]
  wire [7:0] _T_304 = 8'h1 << rBank_0; // @[ICache.scala 36:10]
  wire [7:0] _T_305 = rValid_0 | _T_304; // @[ICache.scala 41:7]
  wire [2:0] _T_307 = rBank_0 + 3'h1; // @[ICache.scala 301:32]
  wire  _T_308 = 2'h3 == rState_0; // @[Conditional.scala 37:30]
  wire  _T_309 = 2'h0 == refillSel; // @[ICache.scala 305:19]
  wire [255:0] _T_315 = 256'h1 << rAddr_0[12:5]; // @[ICache.scala 36:10]
  wire [255:0] _T_316 = ~_T_315; // @[ICache.scala 46:10]
  wire [255:0] _GEN_382 = rRefillWay_0 ? validMem_1 : validMem_0; // @[ICache.scala 46:7]
  wire [255:0] _T_317 = _GEN_382 & _T_316; // @[ICache.scala 46:7]
  wire [255:0] _T_320 = _GEN_382 | _T_315; // @[ICache.scala 41:7]
  wire [255:0] _T_321 = rInvalid_0 ? _T_317 : _T_320; // @[ICache.scala 308:41]
  wire [255:0] _GEN_383 = ~rRefillWay_0 ? _T_321 : _GEN_117; // @[ICache.scala 308:35]
  wire [255:0] _GEN_384 = rRefillWay_0 ? _T_321 : _GEN_118; // @[ICache.scala 308:35]
  wire [255:0] _GEN_391 = _T_309 ? _GEN_383 : _GEN_117; // @[ICache.scala 305:34]
  wire [255:0] _GEN_392 = _T_309 ? _GEN_384 : _GEN_118; // @[ICache.scala 305:34]
  wire  _GEN_396 = _T_308 & _T_309; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_399 = _T_308 ? _GEN_391 : _GEN_117; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_400 = _T_308 ? _GEN_392 : _GEN_118; // @[Conditional.scala 39:67]
  wire  _GEN_411 = _T_300 ? 1'h0 : _GEN_396; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_414 = _T_300 ? _GEN_117 : _GEN_399; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_415 = _T_300 ? _GEN_118 : _GEN_400; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_429 = _T_297 ? _GEN_117 : _GEN_414; // @[Conditional.scala 40:58]
  wire [255:0] _GEN_430 = _T_297 ? _GEN_118 : _GEN_415; // @[Conditional.scala 40:58]
  wire  _T_322 = 2'h1 == rState_1; // @[Conditional.scala 37:30]
  wire  _T_323 = 2'h1 == addressingSel; // @[ICache.scala 292:19]
  wire  _T_324 = _T_323 & io_axiReadAddrIn_arready; // @[ICache.scala 292:37]
  wire  _T_325 = 2'h2 == rState_1; // @[Conditional.scala 37:30]
  wire [7:0] _T_329 = 8'h1 << rBank_1; // @[ICache.scala 36:10]
  wire [7:0] _T_330 = rValid_1 | _T_329; // @[ICache.scala 41:7]
  wire [2:0] _T_332 = rBank_1 + 3'h1; // @[ICache.scala 301:32]
  wire  _T_333 = 2'h3 == rState_1; // @[Conditional.scala 37:30]
  wire  _T_334 = 2'h1 == refillSel; // @[ICache.scala 305:19]
  wire [255:0] _T_340 = 256'h1 << rAddr_1[12:5]; // @[ICache.scala 36:10]
  wire [255:0] _T_341 = ~_T_340; // @[ICache.scala 46:10]
  wire [255:0] _GEN_436 = rRefillWay_1 ? validMem_1 : validMem_0; // @[ICache.scala 46:7]
  wire [255:0] _T_342 = _GEN_436 & _T_341; // @[ICache.scala 46:7]
  wire [255:0] _T_345 = _GEN_436 | _T_340; // @[ICache.scala 41:7]
  wire [255:0] _T_346 = rInvalid_1 ? _T_342 : _T_345; // @[ICache.scala 308:41]
  wire [255:0] _GEN_437 = ~rRefillWay_1 ? _T_346 : _GEN_429; // @[ICache.scala 308:35]
  wire [255:0] _GEN_438 = rRefillWay_1 ? _T_346 : _GEN_430; // @[ICache.scala 308:35]
  wire [255:0] _GEN_445 = _T_334 ? _GEN_437 : _GEN_429; // @[ICache.scala 305:34]
  wire [255:0] _GEN_446 = _T_334 ? _GEN_438 : _GEN_430; // @[ICache.scala 305:34]
  wire  _GEN_450 = _T_333 & _T_334; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_453 = _T_333 ? _GEN_445 : _GEN_429; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_454 = _T_333 ? _GEN_446 : _GEN_430; // @[Conditional.scala 39:67]
  wire  _GEN_465 = _T_325 ? 1'h0 : _GEN_450; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_468 = _T_325 ? _GEN_429 : _GEN_453; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_469 = _T_325 ? _GEN_430 : _GEN_454; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_483 = _T_322 ? _GEN_429 : _GEN_468; // @[Conditional.scala 40:58]
  wire [255:0] _GEN_484 = _T_322 ? _GEN_430 : _GEN_469; // @[Conditional.scala 40:58]
  wire  _T_347 = 2'h1 == rState_2; // @[Conditional.scala 37:30]
  wire  _T_348 = 2'h2 == addressingSel; // @[ICache.scala 292:19]
  wire  _T_349 = _T_348 & io_axiReadAddrIn_arready; // @[ICache.scala 292:37]
  wire  _T_350 = 2'h2 == rState_2; // @[Conditional.scala 37:30]
  wire [7:0] _T_354 = 8'h1 << rBank_2; // @[ICache.scala 36:10]
  wire [7:0] _T_355 = rValid_2 | _T_354; // @[ICache.scala 41:7]
  wire [2:0] _T_357 = rBank_2 + 3'h1; // @[ICache.scala 301:32]
  wire  _T_358 = 2'h3 == rState_2; // @[Conditional.scala 37:30]
  wire  _T_359 = 2'h2 == refillSel; // @[ICache.scala 305:19]
  wire [255:0] _T_365 = 256'h1 << rAddr_2[12:5]; // @[ICache.scala 36:10]
  wire [255:0] _T_366 = ~_T_365; // @[ICache.scala 46:10]
  wire [255:0] _GEN_490 = rRefillWay_2 ? validMem_1 : validMem_0; // @[ICache.scala 46:7]
  wire [255:0] _T_367 = _GEN_490 & _T_366; // @[ICache.scala 46:7]
  wire [255:0] _T_370 = _GEN_490 | _T_365; // @[ICache.scala 41:7]
  wire [255:0] _T_371 = rInvalid_2 ? _T_367 : _T_370; // @[ICache.scala 308:41]
  wire [255:0] _GEN_491 = ~rRefillWay_2 ? _T_371 : _GEN_483; // @[ICache.scala 308:35]
  wire [255:0] _GEN_492 = rRefillWay_2 ? _T_371 : _GEN_484; // @[ICache.scala 308:35]
  wire [255:0] _GEN_499 = _T_359 ? _GEN_491 : _GEN_483; // @[ICache.scala 305:34]
  wire [255:0] _GEN_500 = _T_359 ? _GEN_492 : _GEN_484; // @[ICache.scala 305:34]
  wire  _GEN_504 = _T_358 & _T_359; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_507 = _T_358 ? _GEN_499 : _GEN_483; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_508 = _T_358 ? _GEN_500 : _GEN_484; // @[Conditional.scala 39:67]
  wire  _GEN_519 = _T_350 ? 1'h0 : _GEN_504; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_522 = _T_350 ? _GEN_483 : _GEN_507; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_523 = _T_350 ? _GEN_484 : _GEN_508; // @[Conditional.scala 39:67]
  wire [255:0] _GEN_537 = _T_347 ? _GEN_483 : _GEN_522; // @[Conditional.scala 40:58]
  wire [255:0] _GEN_538 = _T_347 ? _GEN_484 : _GEN_523; // @[Conditional.scala 40:58]
  wire  _T_372 = 2'h1 == rState_3; // @[Conditional.scala 37:30]
  wire  _T_373 = 2'h3 == addressingSel; // @[ICache.scala 292:19]
  wire  _T_374 = _T_373 & io_axiReadAddrIn_arready; // @[ICache.scala 292:37]
  wire  _T_375 = 2'h2 == rState_3; // @[Conditional.scala 37:30]
  wire [7:0] _T_379 = 8'h1 << rBank_3; // @[ICache.scala 36:10]
  wire [7:0] _T_380 = rValid_3 | _T_379; // @[ICache.scala 41:7]
  wire [2:0] _T_382 = rBank_3 + 3'h1; // @[ICache.scala 301:32]
  wire  _T_383 = 2'h3 == rState_3; // @[Conditional.scala 37:30]
  wire  _T_384 = 2'h3 == refillSel; // @[ICache.scala 305:19]
  wire [255:0] _T_390 = 256'h1 << rAddr_3[12:5]; // @[ICache.scala 36:10]
  wire [255:0] _T_391 = ~_T_390; // @[ICache.scala 46:10]
  wire [255:0] _GEN_544 = rRefillWay_3 ? validMem_1 : validMem_0; // @[ICache.scala 46:7]
  wire [255:0] _T_392 = _GEN_544 & _T_391; // @[ICache.scala 46:7]
  wire [255:0] _T_395 = _GEN_544 | _T_390; // @[ICache.scala 41:7]
  wire  _GEN_558 = _T_383 & _T_384; // @[Conditional.scala 39:67]
  wire  _GEN_573 = _T_375 ? 1'h0 : _GEN_558; // @[Conditional.scala 39:67]
  wire [31:0] dataMemAddr = {{24'd0}, _T_101}; // @[ICache.scala 58:25 ICache.scala 140:15]
  BlockMem dataMem_0 ( // @[ICache.scala 51:11]
    .clock(dataMem_0_clock),
    .io_addr(dataMem_0_io_addr),
    .io_wEn(dataMem_0_io_wEn),
    .io_dataIn_0(dataMem_0_io_dataIn_0),
    .io_dataIn_1(dataMem_0_io_dataIn_1),
    .io_dataIn_2(dataMem_0_io_dataIn_2),
    .io_dataIn_3(dataMem_0_io_dataIn_3),
    .io_dataIn_4(dataMem_0_io_dataIn_4),
    .io_dataIn_5(dataMem_0_io_dataIn_5),
    .io_dataIn_6(dataMem_0_io_dataIn_6),
    .io_dataIn_7(dataMem_0_io_dataIn_7),
    .io_dataOut_0(dataMem_0_io_dataOut_0),
    .io_dataOut_1(dataMem_0_io_dataOut_1),
    .io_dataOut_2(dataMem_0_io_dataOut_2),
    .io_dataOut_3(dataMem_0_io_dataOut_3),
    .io_dataOut_4(dataMem_0_io_dataOut_4),
    .io_dataOut_5(dataMem_0_io_dataOut_5),
    .io_dataOut_6(dataMem_0_io_dataOut_6),
    .io_dataOut_7(dataMem_0_io_dataOut_7)
  );
  BlockMem dataMem_1 ( // @[ICache.scala 51:11]
    .clock(dataMem_1_clock),
    .io_addr(dataMem_1_io_addr),
    .io_wEn(dataMem_1_io_wEn),
    .io_dataIn_0(dataMem_1_io_dataIn_0),
    .io_dataIn_1(dataMem_1_io_dataIn_1),
    .io_dataIn_2(dataMem_1_io_dataIn_2),
    .io_dataIn_3(dataMem_1_io_dataIn_3),
    .io_dataIn_4(dataMem_1_io_dataIn_4),
    .io_dataIn_5(dataMem_1_io_dataIn_5),
    .io_dataIn_6(dataMem_1_io_dataIn_6),
    .io_dataIn_7(dataMem_1_io_dataIn_7),
    .io_dataOut_0(dataMem_1_io_dataOut_0),
    .io_dataOut_1(dataMem_1_io_dataOut_1),
    .io_dataOut_2(dataMem_1_io_dataOut_2),
    .io_dataOut_3(dataMem_1_io_dataOut_3),
    .io_dataOut_4(dataMem_1_io_dataOut_4),
    .io_dataOut_5(dataMem_1_io_dataOut_5),
    .io_dataOut_6(dataMem_1_io_dataOut_6),
    .io_dataOut_7(dataMem_1_io_dataOut_7)
  );
  LruMem lruMem ( // @[ICache.scala 67:22]
    .clock(lruMem_clock),
    .reset(lruMem_reset),
    .io_setAddr(lruMem_io_setAddr),
    .io_visit(lruMem_io_visit),
    .io_visitValid(lruMem_io_visitValid),
    .io_waySel(lruMem_io_waySel)
  );
  assign tagMem__T_115_addr = {1'h0,iSet};
  assign tagMem__T_115_data = tagMem[tagMem__T_115_addr]; // @[ICache.scala 66:19]
  assign tagMem__T_121_addr = {1'h1,iSet};
  assign tagMem__T_121_data = tagMem[tagMem__T_121_addr]; // @[ICache.scala 66:19]
  assign tagMem__T_312_data = rAddr_0[31:13];
  assign tagMem__T_312_addr = {rRefillWay_0,rAddr_0[12:5]};
  assign tagMem__T_312_mask = 1'h1;
  assign tagMem__T_312_en = _T_297 ? 1'h0 : _GEN_411;
  assign tagMem__T_337_data = rAddr_1[31:13];
  assign tagMem__T_337_addr = {rRefillWay_1,rAddr_1[12:5]};
  assign tagMem__T_337_mask = 1'h1;
  assign tagMem__T_337_en = _T_322 ? 1'h0 : _GEN_465;
  assign tagMem__T_362_data = rAddr_2[31:13];
  assign tagMem__T_362_addr = {rRefillWay_2,rAddr_2[12:5]};
  assign tagMem__T_362_mask = 1'h1;
  assign tagMem__T_362_en = _T_347 ? 1'h0 : _GEN_519;
  assign tagMem__T_387_data = rAddr_3[31:13];
  assign tagMem__T_387_addr = {rRefillWay_3,rAddr_3[12:5]};
  assign tagMem__T_387_mask = 1'h1;
  assign tagMem__T_387_en = _T_372 ? 1'h0 : _GEN_573;
  assign rBuf_0__T_7_addr = 3'h0;
  assign rBuf_0__T_7_data = rBuf_0[rBuf_0__T_7_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_8_addr = 3'h1;
  assign rBuf_0__T_8_data = rBuf_0[rBuf_0__T_8_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_9_addr = 3'h2;
  assign rBuf_0__T_9_data = rBuf_0[rBuf_0__T_9_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_10_addr = 3'h3;
  assign rBuf_0__T_10_data = rBuf_0[rBuf_0__T_10_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_11_addr = 3'h4;
  assign rBuf_0__T_11_data = rBuf_0[rBuf_0__T_11_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_12_addr = 3'h5;
  assign rBuf_0__T_12_data = rBuf_0[rBuf_0__T_12_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_13_addr = 3'h6;
  assign rBuf_0__T_13_data = rBuf_0[rBuf_0__T_13_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_14_addr = 3'h7;
  assign rBuf_0__T_14_data = rBuf_0[rBuf_0__T_14_addr]; // @[ICache.scala 76:39]
  assign rBuf_0__T_301_data = io_axiReadIn_rdata;
  assign rBuf_0__T_301_addr = rBank_0;
  assign rBuf_0__T_301_mask = 1'h1;
  assign rBuf_0__T_301_en = _T_297 ? 1'h0 : _T_300;
  assign rBuf_1__T_16_addr = 3'h0;
  assign rBuf_1__T_16_data = rBuf_1[rBuf_1__T_16_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_17_addr = 3'h1;
  assign rBuf_1__T_17_data = rBuf_1[rBuf_1__T_17_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_18_addr = 3'h2;
  assign rBuf_1__T_18_data = rBuf_1[rBuf_1__T_18_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_19_addr = 3'h3;
  assign rBuf_1__T_19_data = rBuf_1[rBuf_1__T_19_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_20_addr = 3'h4;
  assign rBuf_1__T_20_data = rBuf_1[rBuf_1__T_20_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_21_addr = 3'h5;
  assign rBuf_1__T_21_data = rBuf_1[rBuf_1__T_21_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_22_addr = 3'h6;
  assign rBuf_1__T_22_data = rBuf_1[rBuf_1__T_22_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_23_addr = 3'h7;
  assign rBuf_1__T_23_data = rBuf_1[rBuf_1__T_23_addr]; // @[ICache.scala 76:39]
  assign rBuf_1__T_326_data = io_axiReadIn_rdata;
  assign rBuf_1__T_326_addr = rBank_1;
  assign rBuf_1__T_326_mask = 1'h1;
  assign rBuf_1__T_326_en = _T_322 ? 1'h0 : _T_325;
  assign rBuf_2__T_25_addr = 3'h0;
  assign rBuf_2__T_25_data = rBuf_2[rBuf_2__T_25_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_26_addr = 3'h1;
  assign rBuf_2__T_26_data = rBuf_2[rBuf_2__T_26_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_27_addr = 3'h2;
  assign rBuf_2__T_27_data = rBuf_2[rBuf_2__T_27_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_28_addr = 3'h3;
  assign rBuf_2__T_28_data = rBuf_2[rBuf_2__T_28_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_29_addr = 3'h4;
  assign rBuf_2__T_29_data = rBuf_2[rBuf_2__T_29_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_30_addr = 3'h5;
  assign rBuf_2__T_30_data = rBuf_2[rBuf_2__T_30_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_31_addr = 3'h6;
  assign rBuf_2__T_31_data = rBuf_2[rBuf_2__T_31_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_32_addr = 3'h7;
  assign rBuf_2__T_32_data = rBuf_2[rBuf_2__T_32_addr]; // @[ICache.scala 76:39]
  assign rBuf_2__T_351_data = io_axiReadIn_rdata;
  assign rBuf_2__T_351_addr = rBank_2;
  assign rBuf_2__T_351_mask = 1'h1;
  assign rBuf_2__T_351_en = _T_347 ? 1'h0 : _T_350;
  assign rBuf_3__T_34_addr = 3'h0;
  assign rBuf_3__T_34_data = rBuf_3[rBuf_3__T_34_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_35_addr = 3'h1;
  assign rBuf_3__T_35_data = rBuf_3[rBuf_3__T_35_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_36_addr = 3'h2;
  assign rBuf_3__T_36_data = rBuf_3[rBuf_3__T_36_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_37_addr = 3'h3;
  assign rBuf_3__T_37_data = rBuf_3[rBuf_3__T_37_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_38_addr = 3'h4;
  assign rBuf_3__T_38_data = rBuf_3[rBuf_3__T_38_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_39_addr = 3'h5;
  assign rBuf_3__T_39_data = rBuf_3[rBuf_3__T_39_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_40_addr = 3'h6;
  assign rBuf_3__T_40_data = rBuf_3[rBuf_3__T_40_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_41_addr = 3'h7;
  assign rBuf_3__T_41_data = rBuf_3[rBuf_3__T_41_addr]; // @[ICache.scala 76:39]
  assign rBuf_3__T_376_data = io_axiReadIn_rdata;
  assign rBuf_3__T_376_addr = rBank_3;
  assign rBuf_3__T_376_mask = 1'h1;
  assign rBuf_3__T_376_en = _T_372 ? 1'h0 : _T_375;
  assign io_inst1 = _T_108 ? 32'h0 : _GEN_85; // @[ICache.scala 126:12 ICache.scala 158:16 ICache.scala 162:16 ICache.scala 166:16 ICache.scala 170:16]
  assign io_inst2 = _T_108 ? 32'h0 : _GEN_86; // @[ICache.scala 127:12 ICache.scala 159:16 ICache.scala 163:16 ICache.scala 167:16 ICache.scala 171:16]
  assign io_inst1Valid = _T_274 & _GEN_313; // @[ICache.scala 128:17 ICache.scala 249:21 ICache.scala 256:21 ICache.scala 261:21 ICache.scala 268:21]
  assign io_inst2Valid = _T_274 & _GEN_317; // @[ICache.scala 129:17 ICache.scala 250:21 ICache.scala 262:21 ICache.scala 269:21]
  assign io_axiReadAddrOut_arid = {{2'd0}, addressingSel}; // @[ICache.scala 130:26]
  assign io_axiReadAddrOut_araddr = 2'h3 == addressingSel ? rAddr_3 : _GEN_2; // @[ICache.scala 131:28]
  assign io_axiReadAddrOut_arvalid = |_T_85; // @[ICache.scala 132:29]
  assign io_axiReadAddrOut_arlen = 4'h7; // @[ICache.scala 133:27]
  assign io_axiReadAddrOut_arsize = 3'h2; // @[ICache.scala 134:28]
  assign io_axiReadAddrOut_arburst = 2'h2; // @[ICache.scala 135:29]
  assign io_axiReadOut_rready = |_T_94; // @[ICache.scala 136:24]
  assign io_hitStats_hitCount = hitCount; // @[ICache.scala 137:24]
  assign io_hitStats_missCount = missCount; // @[ICache.scala 138:25]
  assign dataMem_0_clock = clock;
  assign dataMem_0_io_addr = dataMemAddr[7:0]; // @[ICache.scala 60:15]
  assign dataMem_0_io_wEn = _T_102 & _T_103; // @[ICache.scala 146:23]
  assign dataMem_0_io_dataIn_0 = 2'h3 == refillSel ? rBufData_3_0 : _GEN_24; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_1 = 2'h3 == refillSel ? rBufData_3_1 : _GEN_25; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_2 = 2'h3 == refillSel ? rBufData_3_2 : _GEN_26; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_3 = 2'h3 == refillSel ? rBufData_3_3 : _GEN_27; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_4 = 2'h3 == refillSel ? rBufData_3_4 : _GEN_28; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_5 = 2'h3 == refillSel ? rBufData_3_5 : _GEN_29; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_6 = 2'h3 == refillSel ? rBufData_3_6 : _GEN_30; // @[ICache.scala 61:17]
  assign dataMem_0_io_dataIn_7 = 2'h3 == refillSel ? rBufData_3_7 : _GEN_31; // @[ICache.scala 61:17]
  assign dataMem_1_clock = clock;
  assign dataMem_1_io_addr = dataMemAddr[7:0]; // @[ICache.scala 60:15]
  assign dataMem_1_io_wEn = _GEN_43 & _T_103; // @[ICache.scala 146:23]
  assign dataMem_1_io_dataIn_0 = 2'h3 == refillSel ? rBufData_3_0 : _GEN_24; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_1 = 2'h3 == refillSel ? rBufData_3_1 : _GEN_25; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_2 = 2'h3 == refillSel ? rBufData_3_2 : _GEN_26; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_3 = 2'h3 == refillSel ? rBufData_3_3 : _GEN_27; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_4 = 2'h3 == refillSel ? rBufData_3_4 : _GEN_28; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_5 = 2'h3 == refillSel ? rBufData_3_5 : _GEN_29; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_6 = 2'h3 == refillSel ? rBufData_3_6 : _GEN_30; // @[ICache.scala 61:17]
  assign dataMem_1_io_dataIn_7 = 2'h3 == refillSel ? rBufData_3_7 : _GEN_31; // @[ICache.scala 61:17]
  assign lruMem_clock = clock;
  assign lruMem_reset = reset;
  assign lruMem_io_setAddr = io_iAddr[12:5]; // @[ICache.scala 149:21]
  assign lruMem_io_visit = _T_274 & _GEN_316; // @[ICache.scala 150:19 ICache.scala 259:23 ICache.scala 266:23 ICache.scala 273:23]
  assign lruMem_io_visitValid = _T_243 | hitWay; // @[ICache.scala 151:24 ICache.scala 215:24]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 512; initvar = initvar+1)
    tagMem[initvar] = _RAND_0[18:0];
  _RAND_1 = {1{`RANDOM}};
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    rBuf_0[initvar] = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    rBuf_1[initvar] = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    rBuf_2[initvar] = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  for (initvar = 0; initvar < 8; initvar = initvar+1)
    rBuf_3[initvar] = _RAND_4[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {8{`RANDOM}};
  validMem_0 = _RAND_5[255:0];
  _RAND_6 = {8{`RANDOM}};
  validMem_1 = _RAND_6[255:0];
  _RAND_7 = {1{`RANDOM}};
  rState_0 = _RAND_7[1:0];
  _RAND_8 = {1{`RANDOM}};
  rState_1 = _RAND_8[1:0];
  _RAND_9 = {1{`RANDOM}};
  rState_2 = _RAND_9[1:0];
  _RAND_10 = {1{`RANDOM}};
  rState_3 = _RAND_10[1:0];
  _RAND_11 = {1{`RANDOM}};
  rAddr_0 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  rAddr_1 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  rAddr_2 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  rAddr_3 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  rBank_0 = _RAND_15[2:0];
  _RAND_16 = {1{`RANDOM}};
  rBank_1 = _RAND_16[2:0];
  _RAND_17 = {1{`RANDOM}};
  rBank_2 = _RAND_17[2:0];
  _RAND_18 = {1{`RANDOM}};
  rBank_3 = _RAND_18[2:0];
  _RAND_19 = {1{`RANDOM}};
  rValid_0 = _RAND_19[7:0];
  _RAND_20 = {1{`RANDOM}};
  rValid_1 = _RAND_20[7:0];
  _RAND_21 = {1{`RANDOM}};
  rValid_2 = _RAND_21[7:0];
  _RAND_22 = {1{`RANDOM}};
  rValid_3 = _RAND_22[7:0];
  _RAND_23 = {1{`RANDOM}};
  rRefillWay_0 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  rRefillWay_1 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  rRefillWay_2 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  rRefillWay_3 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  rInvalid_0 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  rInvalid_1 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  rInvalid_2 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  rInvalid_3 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  oState = _RAND_31[1:0];
  _RAND_32 = {1{`RANDOM}};
  oKnownInst1 = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  oKnownInst2 = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  oReadWay = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  oReadBank = _RAND_35[2:0];
  _RAND_36 = {1{`RANDOM}};
  hitCount = _RAND_36[31:0];
  _RAND_37 = {1{`RANDOM}};
  missCount = _RAND_37[31:0];
  _RAND_38 = {1{`RANDOM}};
  prevAddr = _RAND_38[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(tagMem__T_312_en & tagMem__T_312_mask) begin
      tagMem[tagMem__T_312_addr] <= tagMem__T_312_data; // @[ICache.scala 66:19]
    end
    if(tagMem__T_337_en & tagMem__T_337_mask) begin
      tagMem[tagMem__T_337_addr] <= tagMem__T_337_data; // @[ICache.scala 66:19]
    end
    if(tagMem__T_362_en & tagMem__T_362_mask) begin
      tagMem[tagMem__T_362_addr] <= tagMem__T_362_data; // @[ICache.scala 66:19]
    end
    if(tagMem__T_387_en & tagMem__T_387_mask) begin
      tagMem[tagMem__T_387_addr] <= tagMem__T_387_data; // @[ICache.scala 66:19]
    end
    if(rBuf_0__T_301_en & rBuf_0__T_301_mask) begin
      rBuf_0[rBuf_0__T_301_addr] <= rBuf_0__T_301_data; // @[ICache.scala 76:39]
    end
    if(rBuf_1__T_326_en & rBuf_1__T_326_mask) begin
      rBuf_1[rBuf_1__T_326_addr] <= rBuf_1__T_326_data; // @[ICache.scala 76:39]
    end
    if(rBuf_2__T_351_en & rBuf_2__T_351_mask) begin
      rBuf_2[rBuf_2__T_351_addr] <= rBuf_2__T_351_data; // @[ICache.scala 76:39]
    end
    if(rBuf_3__T_376_en & rBuf_3__T_376_mask) begin
      rBuf_3[rBuf_3__T_376_addr] <= rBuf_3__T_376_data; // @[ICache.scala 76:39]
    end
    if (reset) begin
      validMem_0 <= 256'h0;
    end else if (_T_372) begin
      if (_T_347) begin
        if (_T_322) begin
          if (_T_297) begin
            if (actionInv) begin
              if (actionAddr) begin
                if (~iTag[0]) begin
                  validMem_0 <= _T_272;
                end else if (_T_259) begin
                  if (~hitWayId) begin
                    validMem_0 <= _T_262;
                  end
                end
              end else if (_T_259) begin
                if (~hitWayId) begin
                  validMem_0 <= _T_262;
                end
              end
            end
          end else if (_T_300) begin
            if (actionInv) begin
              if (actionAddr) begin
                if (~iTag[0]) begin
                  validMem_0 <= _T_272;
                end else if (_T_259) begin
                  if (~hitWayId) begin
                    validMem_0 <= _T_262;
                  end
                end
              end else if (_T_259) begin
                if (~hitWayId) begin
                  validMem_0 <= _T_262;
                end
              end
            end
          end else if (_T_308) begin
            if (_T_309) begin
              if (~rRefillWay_0) begin
                if (rInvalid_0) begin
                  validMem_0 <= _T_317;
                end else begin
                  validMem_0 <= _T_320;
                end
              end else if (actionInv) begin
                if (actionAddr) begin
                  if (~iTag[0]) begin
                    validMem_0 <= _T_272;
                  end else begin
                    validMem_0 <= _GEN_105;
                  end
                end else begin
                  validMem_0 <= _GEN_105;
                end
              end
            end else if (actionInv) begin
              if (actionAddr) begin
                if (~iTag[0]) begin
                  validMem_0 <= _T_272;
                end else begin
                  validMem_0 <= _GEN_105;
                end
              end else begin
                validMem_0 <= _GEN_105;
              end
            end
          end else begin
            validMem_0 <= _GEN_117;
          end
        end else if (_T_325) begin
          if (_T_297) begin
            validMem_0 <= _GEN_117;
          end else if (_T_300) begin
            validMem_0 <= _GEN_117;
          end else if (_T_308) begin
            if (_T_309) begin
              if (~rRefillWay_0) begin
                if (rInvalid_0) begin
                  validMem_0 <= _T_317;
                end else begin
                  validMem_0 <= _T_320;
                end
              end else begin
                validMem_0 <= _GEN_117;
              end
            end else begin
              validMem_0 <= _GEN_117;
            end
          end else begin
            validMem_0 <= _GEN_117;
          end
        end else if (_T_333) begin
          if (_T_334) begin
            if (~rRefillWay_1) begin
              if (rInvalid_1) begin
                validMem_0 <= _T_342;
              end else begin
                validMem_0 <= _T_345;
              end
            end else if (_T_297) begin
              validMem_0 <= _GEN_117;
            end else if (_T_300) begin
              validMem_0 <= _GEN_117;
            end else if (_T_308) begin
              if (_T_309) begin
                if (~rRefillWay_0) begin
                  if (rInvalid_0) begin
                    validMem_0 <= _T_317;
                  end else begin
                    validMem_0 <= _T_320;
                  end
                end else begin
                  validMem_0 <= _GEN_117;
                end
              end else begin
                validMem_0 <= _GEN_117;
              end
            end else begin
              validMem_0 <= _GEN_117;
            end
          end else if (_T_297) begin
            validMem_0 <= _GEN_117;
          end else if (_T_300) begin
            validMem_0 <= _GEN_117;
          end else if (_T_308) begin
            if (_T_309) begin
              if (~rRefillWay_0) begin
                if (rInvalid_0) begin
                  validMem_0 <= _T_317;
                end else begin
                  validMem_0 <= _T_320;
                end
              end else begin
                validMem_0 <= _GEN_117;
              end
            end else begin
              validMem_0 <= _GEN_117;
            end
          end else begin
            validMem_0 <= _GEN_117;
          end
        end else begin
          validMem_0 <= _GEN_429;
        end
      end else if (_T_350) begin
        if (_T_322) begin
          validMem_0 <= _GEN_429;
        end else if (_T_325) begin
          validMem_0 <= _GEN_429;
        end else if (_T_333) begin
          if (_T_334) begin
            if (~rRefillWay_1) begin
              if (rInvalid_1) begin
                validMem_0 <= _T_342;
              end else begin
                validMem_0 <= _T_345;
              end
            end else begin
              validMem_0 <= _GEN_429;
            end
          end else begin
            validMem_0 <= _GEN_429;
          end
        end else begin
          validMem_0 <= _GEN_429;
        end
      end else if (_T_358) begin
        if (_T_359) begin
          if (~rRefillWay_2) begin
            if (rInvalid_2) begin
              validMem_0 <= _T_367;
            end else begin
              validMem_0 <= _T_370;
            end
          end else if (_T_322) begin
            validMem_0 <= _GEN_429;
          end else if (_T_325) begin
            validMem_0 <= _GEN_429;
          end else if (_T_333) begin
            if (_T_334) begin
              if (~rRefillWay_1) begin
                if (rInvalid_1) begin
                  validMem_0 <= _T_342;
                end else begin
                  validMem_0 <= _T_345;
                end
              end else begin
                validMem_0 <= _GEN_429;
              end
            end else begin
              validMem_0 <= _GEN_429;
            end
          end else begin
            validMem_0 <= _GEN_429;
          end
        end else if (_T_322) begin
          validMem_0 <= _GEN_429;
        end else if (_T_325) begin
          validMem_0 <= _GEN_429;
        end else if (_T_333) begin
          if (_T_334) begin
            if (~rRefillWay_1) begin
              if (rInvalid_1) begin
                validMem_0 <= _T_342;
              end else begin
                validMem_0 <= _T_345;
              end
            end else begin
              validMem_0 <= _GEN_429;
            end
          end else begin
            validMem_0 <= _GEN_429;
          end
        end else begin
          validMem_0 <= _GEN_429;
        end
      end else begin
        validMem_0 <= _GEN_483;
      end
    end else if (_T_375) begin
      if (_T_347) begin
        validMem_0 <= _GEN_483;
      end else if (_T_350) begin
        validMem_0 <= _GEN_483;
      end else if (_T_358) begin
        if (_T_359) begin
          if (~rRefillWay_2) begin
            if (rInvalid_2) begin
              validMem_0 <= _T_367;
            end else begin
              validMem_0 <= _T_370;
            end
          end else begin
            validMem_0 <= _GEN_483;
          end
        end else begin
          validMem_0 <= _GEN_483;
        end
      end else begin
        validMem_0 <= _GEN_483;
      end
    end else if (_T_383) begin
      if (_T_384) begin
        if (~rRefillWay_3) begin
          if (rInvalid_3) begin
            validMem_0 <= _T_392;
          end else begin
            validMem_0 <= _T_395;
          end
        end else if (_T_347) begin
          validMem_0 <= _GEN_483;
        end else if (_T_350) begin
          validMem_0 <= _GEN_483;
        end else if (_T_358) begin
          if (_T_359) begin
            if (~rRefillWay_2) begin
              if (rInvalid_2) begin
                validMem_0 <= _T_367;
              end else begin
                validMem_0 <= _T_370;
              end
            end else begin
              validMem_0 <= _GEN_483;
            end
          end else begin
            validMem_0 <= _GEN_483;
          end
        end else begin
          validMem_0 <= _GEN_483;
        end
      end else if (_T_347) begin
        validMem_0 <= _GEN_483;
      end else if (_T_350) begin
        validMem_0 <= _GEN_483;
      end else if (_T_358) begin
        if (_T_359) begin
          if (~rRefillWay_2) begin
            if (rInvalid_2) begin
              validMem_0 <= _T_367;
            end else begin
              validMem_0 <= _T_370;
            end
          end else begin
            validMem_0 <= _GEN_483;
          end
        end else begin
          validMem_0 <= _GEN_483;
        end
      end else begin
        validMem_0 <= _GEN_483;
      end
    end else begin
      validMem_0 <= _GEN_537;
    end
    if (reset) begin
      validMem_1 <= 256'h0;
    end else if (_T_372) begin
      if (_T_347) begin
        if (_T_322) begin
          if (_T_297) begin
            if (actionInv) begin
              if (actionAddr) begin
                if (iTag[0]) begin
                  validMem_1 <= _T_272;
                end else if (_T_259) begin
                  if (hitWayId) begin
                    validMem_1 <= _T_262;
                  end
                end
              end else if (_T_259) begin
                if (hitWayId) begin
                  validMem_1 <= _T_262;
                end
              end
            end
          end else if (_T_300) begin
            if (actionInv) begin
              if (actionAddr) begin
                if (iTag[0]) begin
                  validMem_1 <= _T_272;
                end else if (_T_259) begin
                  if (hitWayId) begin
                    validMem_1 <= _T_262;
                  end
                end
              end else if (_T_259) begin
                if (hitWayId) begin
                  validMem_1 <= _T_262;
                end
              end
            end
          end else if (_T_308) begin
            if (_T_309) begin
              if (rRefillWay_0) begin
                validMem_1 <= _T_321;
              end else if (actionInv) begin
                if (actionAddr) begin
                  if (iTag[0]) begin
                    validMem_1 <= _T_272;
                  end else begin
                    validMem_1 <= _GEN_106;
                  end
                end else begin
                  validMem_1 <= _GEN_106;
                end
              end
            end else if (actionInv) begin
              if (actionAddr) begin
                if (iTag[0]) begin
                  validMem_1 <= _T_272;
                end else begin
                  validMem_1 <= _GEN_106;
                end
              end else begin
                validMem_1 <= _GEN_106;
              end
            end
          end else begin
            validMem_1 <= _GEN_118;
          end
        end else if (_T_325) begin
          if (_T_297) begin
            validMem_1 <= _GEN_118;
          end else if (_T_300) begin
            validMem_1 <= _GEN_118;
          end else if (_T_308) begin
            if (_T_309) begin
              if (rRefillWay_0) begin
                validMem_1 <= _T_321;
              end else begin
                validMem_1 <= _GEN_118;
              end
            end else begin
              validMem_1 <= _GEN_118;
            end
          end else begin
            validMem_1 <= _GEN_118;
          end
        end else if (_T_333) begin
          if (_T_334) begin
            if (rRefillWay_1) begin
              validMem_1 <= _T_346;
            end else if (_T_297) begin
              validMem_1 <= _GEN_118;
            end else if (_T_300) begin
              validMem_1 <= _GEN_118;
            end else if (_T_308) begin
              if (_T_309) begin
                if (rRefillWay_0) begin
                  validMem_1 <= _T_321;
                end else begin
                  validMem_1 <= _GEN_118;
                end
              end else begin
                validMem_1 <= _GEN_118;
              end
            end else begin
              validMem_1 <= _GEN_118;
            end
          end else if (_T_297) begin
            validMem_1 <= _GEN_118;
          end else if (_T_300) begin
            validMem_1 <= _GEN_118;
          end else if (_T_308) begin
            if (_T_309) begin
              if (rRefillWay_0) begin
                validMem_1 <= _T_321;
              end else begin
                validMem_1 <= _GEN_118;
              end
            end else begin
              validMem_1 <= _GEN_118;
            end
          end else begin
            validMem_1 <= _GEN_118;
          end
        end else begin
          validMem_1 <= _GEN_430;
        end
      end else if (_T_350) begin
        if (_T_322) begin
          validMem_1 <= _GEN_430;
        end else if (_T_325) begin
          validMem_1 <= _GEN_430;
        end else if (_T_333) begin
          if (_T_334) begin
            if (rRefillWay_1) begin
              validMem_1 <= _T_346;
            end else begin
              validMem_1 <= _GEN_430;
            end
          end else begin
            validMem_1 <= _GEN_430;
          end
        end else begin
          validMem_1 <= _GEN_430;
        end
      end else if (_T_358) begin
        if (_T_359) begin
          if (rRefillWay_2) begin
            validMem_1 <= _T_371;
          end else if (_T_322) begin
            validMem_1 <= _GEN_430;
          end else if (_T_325) begin
            validMem_1 <= _GEN_430;
          end else if (_T_333) begin
            if (_T_334) begin
              if (rRefillWay_1) begin
                validMem_1 <= _T_346;
              end else begin
                validMem_1 <= _GEN_430;
              end
            end else begin
              validMem_1 <= _GEN_430;
            end
          end else begin
            validMem_1 <= _GEN_430;
          end
        end else if (_T_322) begin
          validMem_1 <= _GEN_430;
        end else if (_T_325) begin
          validMem_1 <= _GEN_430;
        end else if (_T_333) begin
          if (_T_334) begin
            if (rRefillWay_1) begin
              validMem_1 <= _T_346;
            end else begin
              validMem_1 <= _GEN_430;
            end
          end else begin
            validMem_1 <= _GEN_430;
          end
        end else begin
          validMem_1 <= _GEN_430;
        end
      end else begin
        validMem_1 <= _GEN_484;
      end
    end else if (_T_375) begin
      if (_T_347) begin
        validMem_1 <= _GEN_484;
      end else if (_T_350) begin
        validMem_1 <= _GEN_484;
      end else if (_T_358) begin
        if (_T_359) begin
          if (rRefillWay_2) begin
            validMem_1 <= _T_371;
          end else begin
            validMem_1 <= _GEN_484;
          end
        end else begin
          validMem_1 <= _GEN_484;
        end
      end else begin
        validMem_1 <= _GEN_484;
      end
    end else if (_T_383) begin
      if (_T_384) begin
        if (rRefillWay_3) begin
          if (rInvalid_3) begin
            validMem_1 <= _T_392;
          end else begin
            validMem_1 <= _T_395;
          end
        end else if (_T_347) begin
          validMem_1 <= _GEN_484;
        end else if (_T_350) begin
          validMem_1 <= _GEN_484;
        end else if (_T_358) begin
          if (_T_359) begin
            if (rRefillWay_2) begin
              validMem_1 <= _T_371;
            end else begin
              validMem_1 <= _GEN_484;
            end
          end else begin
            validMem_1 <= _GEN_484;
          end
        end else begin
          validMem_1 <= _GEN_484;
        end
      end else if (_T_347) begin
        validMem_1 <= _GEN_484;
      end else if (_T_350) begin
        validMem_1 <= _GEN_484;
      end else if (_T_358) begin
        if (_T_359) begin
          if (rRefillWay_2) begin
            validMem_1 <= _T_371;
          end else begin
            validMem_1 <= _GEN_484;
          end
        end else begin
          validMem_1 <= _GEN_484;
        end
      end else begin
        validMem_1 <= _GEN_484;
      end
    end else begin
      validMem_1 <= _GEN_538;
    end
    if (reset) begin
      rState_0 <= 2'h0;
    end else if (_T_297) begin
      if (_T_299) begin
        rState_0 <= 2'h2;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rState_0 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_300) begin
      if (axiRValid[0]) begin
        if (io_axiReadIn_rlast) begin
          rState_0 <= 2'h3;
        end else begin
          rState_0 <= 2'h2;
        end
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rState_0 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_308) begin
      if (_T_309) begin
        rState_0 <= 2'h0;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rState_0 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h0 == idleSel) begin
                rState_0 <= 2'h1;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rState_1 <= 2'h0;
    end else if (_T_322) begin
      if (_T_324) begin
        rState_1 <= 2'h2;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rState_1 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_325) begin
      if (axiRValid[1]) begin
        if (io_axiReadIn_rlast) begin
          rState_1 <= 2'h3;
        end else begin
          rState_1 <= 2'h2;
        end
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rState_1 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_333) begin
      if (_T_334) begin
        rState_1 <= 2'h0;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rState_1 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h1 == idleSel) begin
                rState_1 <= 2'h1;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rState_2 <= 2'h0;
    end else if (_T_347) begin
      if (_T_349) begin
        rState_2 <= 2'h2;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rState_2 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_350) begin
      if (axiRValid[2]) begin
        if (io_axiReadIn_rlast) begin
          rState_2 <= 2'h3;
        end else begin
          rState_2 <= 2'h2;
        end
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rState_2 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_358) begin
      if (_T_359) begin
        rState_2 <= 2'h0;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rState_2 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h2 == idleSel) begin
                rState_2 <= 2'h1;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rState_3 <= 2'h0;
    end else if (_T_372) begin
      if (_T_374) begin
        rState_3 <= 2'h2;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rState_3 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_375) begin
      if (axiRValid[3]) begin
        if (io_axiReadIn_rlast) begin
          rState_3 <= 2'h3;
        end else begin
          rState_3 <= 2'h2;
        end
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rState_3 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_383) begin
      if (_T_384) begin
        rState_3 <= 2'h0;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rState_3 <= 2'h1;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h3 == idleSel) begin
                rState_3 <= 2'h1;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rAddr_0 <= 32'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h0 == idleSel) begin
                rAddr_0 <= io_iAddr;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rAddr_1 <= 32'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h1 == idleSel) begin
                rAddr_1 <= io_iAddr;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rAddr_2 <= 32'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h2 == idleSel) begin
                rAddr_2 <= io_iAddr;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rAddr_3 <= 32'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h3 == idleSel) begin
                rAddr_3 <= io_iAddr;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rBank_0 <= 3'h0;
    end else if (_T_297) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rBank_0 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_300) begin
      if (axiRValid[0]) begin
        rBank_0 <= _T_307;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rBank_0 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h0 == idleSel) begin
                rBank_0 <= iBank;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rBank_1 <= 3'h0;
    end else if (_T_322) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rBank_1 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_325) begin
      if (axiRValid[1]) begin
        rBank_1 <= _T_332;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rBank_1 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h1 == idleSel) begin
                rBank_1 <= iBank;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rBank_2 <= 3'h0;
    end else if (_T_347) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rBank_2 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_350) begin
      if (axiRValid[2]) begin
        rBank_2 <= _T_357;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rBank_2 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h2 == idleSel) begin
                rBank_2 <= iBank;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rBank_3 <= 3'h0;
    end else if (_T_372) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rBank_3 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_375) begin
      if (axiRValid[3]) begin
        rBank_3 <= _T_382;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rBank_3 <= iBank;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h3 == idleSel) begin
                rBank_3 <= iBank;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_0 <= 8'h0;
    end else if (_T_297) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rValid_0 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_300) begin
      if (axiRValid[0]) begin
        rValid_0 <= _T_305;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h0 == idleSel) begin
                  rValid_0 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h0 == idleSel) begin
                rValid_0 <= 8'h0;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_1 <= 8'h0;
    end else if (_T_322) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rValid_1 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_325) begin
      if (axiRValid[1]) begin
        rValid_1 <= _T_330;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h1 == idleSel) begin
                  rValid_1 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h1 == idleSel) begin
                rValid_1 <= 8'h0;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_2 <= 8'h0;
    end else if (_T_347) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rValid_2 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_350) begin
      if (axiRValid[2]) begin
        rValid_2 <= _T_355;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h2 == idleSel) begin
                  rValid_2 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h2 == idleSel) begin
                rValid_2 <= 8'h0;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_3 <= 8'h0;
    end else if (_T_372) begin
      if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rValid_3 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_375) begin
      if (axiRValid[3]) begin
        rValid_3 <= _T_380;
      end else if (_T_274) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (_T_296) begin
                if (2'h3 == idleSel) begin
                  rValid_3 <= 8'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h3 == idleSel) begin
                rValid_3 <= 8'h0;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rRefillWay_0 <= 1'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h0 == idleSel) begin
                rRefillWay_0 <= _rRefillWay_idleSel;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rRefillWay_1 <= 1'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h1 == idleSel) begin
                rRefillWay_1 <= _rRefillWay_idleSel;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rRefillWay_2 <= 1'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h2 == idleSel) begin
                rRefillWay_2 <= _rRefillWay_idleSel;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rRefillWay_3 <= 1'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (_T_296) begin
              if (2'h3 == idleSel) begin
                rRefillWay_3 <= _rRefillWay_idleSel;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      rInvalid_0 <= 1'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_0 <= _GEN_97;
            end
          end
        end
      end else if (hitAxiBuf) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_0 <= _GEN_97;
            end
          end
        end
      end else if (hitWay) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_0 <= _GEN_97;
            end
          end
        end
      end else if (_T_296) begin
        if (2'h0 == idleSel) begin
          rInvalid_0 <= 1'h0;
        end else if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_0 <= _GEN_97;
            end
          end
        end
      end else begin
        rInvalid_0 <= _GEN_119;
      end
    end else begin
      rInvalid_0 <= _GEN_119;
    end
    if (reset) begin
      rInvalid_1 <= 1'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_1 <= _GEN_98;
            end
          end
        end
      end else if (hitAxiBuf) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_1 <= _GEN_98;
            end
          end
        end
      end else if (hitWay) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_1 <= _GEN_98;
            end
          end
        end
      end else if (_T_296) begin
        if (2'h1 == idleSel) begin
          rInvalid_1 <= 1'h0;
        end else if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_1 <= _GEN_98;
            end
          end
        end
      end else begin
        rInvalid_1 <= _GEN_120;
      end
    end else begin
      rInvalid_1 <= _GEN_120;
    end
    if (reset) begin
      rInvalid_2 <= 1'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_2 <= _GEN_99;
            end
          end
        end
      end else if (hitAxiBuf) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_2 <= _GEN_99;
            end
          end
        end
      end else if (hitWay) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_2 <= _GEN_99;
            end
          end
        end
      end else if (_T_296) begin
        if (2'h2 == idleSel) begin
          rInvalid_2 <= 1'h0;
        end else if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_2 <= _GEN_99;
            end
          end
        end
      end else begin
        rInvalid_2 <= _GEN_121;
      end
    end else begin
      rInvalid_2 <= _GEN_121;
    end
    if (reset) begin
      rInvalid_3 <= 1'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_3 <= _GEN_100;
            end
          end
        end
      end else if (hitAxiBuf) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_3 <= _GEN_100;
            end
          end
        end
      end else if (hitWay) begin
        if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_3 <= _GEN_100;
            end
          end
        end
      end else if (_T_296) begin
        if (2'h3 == idleSel) begin
          rInvalid_3 <= 1'h0;
        end else if (actionInv) begin
          if (!(_T_259)) begin
            if (_T_265) begin
              rInvalid_3 <= _GEN_100;
            end
          end
        end
      end else begin
        rInvalid_3 <= _GEN_122;
      end
    end else begin
      rInvalid_3 <= _GEN_122;
    end
    if (reset) begin
      oState <= 2'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        oState <= 2'h1;
      end else if (hitAxiBuf) begin
        oState <= 2'h2;
      end else if (hitWay) begin
        oState <= 2'h3;
      end else begin
        oState <= 2'h0;
      end
    end
    if (reset) begin
      oKnownInst1 <= 32'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        oKnownInst1 <= io_axiReadIn_rdata;
      end else if (hitAxiBuf) begin
        if (_GEN_687 & _GEN_654) begin
          oKnownInst1 <= rBufData_3_7;
        end else if (_GEN_687 & _GEN_652) begin
          oKnownInst1 <= rBufData_3_6;
        end else if (_GEN_687 & _GEN_650) begin
          oKnownInst1 <= rBufData_3_5;
        end else if (_GEN_687 & _GEN_648) begin
          oKnownInst1 <= rBufData_3_4;
        end else if (_GEN_687 & _GEN_646) begin
          oKnownInst1 <= rBufData_3_3;
        end else if (_GEN_687 & _GEN_644) begin
          oKnownInst1 <= rBufData_3_2;
        end else if (_GEN_687 & _GEN_642) begin
          oKnownInst1 <= rBufData_3_1;
        end else if (_GEN_687 & _GEN_656) begin
          oKnownInst1 <= rBufData_3_0;
        end else if (_GEN_671 & _GEN_654) begin
          oKnownInst1 <= rBufData_2_7;
        end else if (_GEN_671 & _GEN_652) begin
          oKnownInst1 <= rBufData_2_6;
        end else if (_GEN_671 & _GEN_650) begin
          oKnownInst1 <= rBufData_2_5;
        end else if (_GEN_671 & _GEN_648) begin
          oKnownInst1 <= rBufData_2_4;
        end else if (_GEN_671 & _GEN_646) begin
          oKnownInst1 <= rBufData_2_3;
        end else if (_GEN_671 & _GEN_644) begin
          oKnownInst1 <= rBufData_2_2;
        end else if (_GEN_671 & _GEN_642) begin
          oKnownInst1 <= rBufData_2_1;
        end else if (_GEN_671 & _GEN_656) begin
          oKnownInst1 <= rBufData_2_0;
        end else if (_GEN_655 & _GEN_654) begin
          oKnownInst1 <= rBufData_1_7;
        end else if (_GEN_655 & _GEN_652) begin
          oKnownInst1 <= rBufData_1_6;
        end else if (_GEN_655 & _GEN_650) begin
          oKnownInst1 <= rBufData_1_5;
        end else if (_GEN_655 & _GEN_648) begin
          oKnownInst1 <= rBufData_1_4;
        end else if (_GEN_655 & _GEN_646) begin
          oKnownInst1 <= rBufData_1_3;
        end else if (_GEN_655 & _GEN_644) begin
          oKnownInst1 <= rBufData_1_2;
        end else if (_GEN_655 & _GEN_642) begin
          oKnownInst1 <= rBufData_1_1;
        end else if (_GEN_655 & _GEN_656) begin
          oKnownInst1 <= rBufData_1_0;
        end else if (_GEN_641 & _GEN_654) begin
          oKnownInst1 <= rBufData_0_7;
        end else if (_GEN_641 & _GEN_652) begin
          oKnownInst1 <= rBufData_0_6;
        end else if (_GEN_641 & _GEN_650) begin
          oKnownInst1 <= rBufData_0_5;
        end else if (_GEN_641 & _GEN_648) begin
          oKnownInst1 <= rBufData_0_4;
        end else if (_GEN_641 & _GEN_646) begin
          oKnownInst1 <= rBufData_0_3;
        end else if (_GEN_641 & _GEN_644) begin
          oKnownInst1 <= rBufData_0_2;
        end else if (_GEN_641 & _GEN_642) begin
          oKnownInst1 <= rBufData_0_1;
        end else begin
          oKnownInst1 <= rBufData_0_0;
        end
      end else if (invalidAddr) begin
        oKnownInst1 <= 32'h0;
      end
    end
    if (reset) begin
      oKnownInst2 <= 32'h0;
    end else if (_T_274) begin
      if (hitAxiDirect) begin
        if (invalidAddr) begin
          oKnownInst2 <= 32'h0;
        end
      end else if (hitAxiBuf) begin
        if (_GEN_687 & _GEN_716) begin
          oKnownInst2 <= rBufData_3_7;
        end else if (_GEN_687 & _GEN_714) begin
          oKnownInst2 <= rBufData_3_6;
        end else if (_GEN_687 & _GEN_712) begin
          oKnownInst2 <= rBufData_3_5;
        end else if (_GEN_687 & _GEN_710) begin
          oKnownInst2 <= rBufData_3_4;
        end else if (_GEN_687 & _GEN_708) begin
          oKnownInst2 <= rBufData_3_3;
        end else if (_GEN_687 & _GEN_706) begin
          oKnownInst2 <= rBufData_3_2;
        end else if (_GEN_687 & _GEN_704) begin
          oKnownInst2 <= rBufData_3_1;
        end else if (_GEN_687 & _GEN_718) begin
          oKnownInst2 <= rBufData_3_0;
        end else if (_GEN_671 & _GEN_716) begin
          oKnownInst2 <= rBufData_2_7;
        end else if (_GEN_671 & _GEN_714) begin
          oKnownInst2 <= rBufData_2_6;
        end else if (_GEN_671 & _GEN_712) begin
          oKnownInst2 <= rBufData_2_5;
        end else if (_GEN_671 & _GEN_710) begin
          oKnownInst2 <= rBufData_2_4;
        end else if (_GEN_671 & _GEN_708) begin
          oKnownInst2 <= rBufData_2_3;
        end else if (_GEN_671 & _GEN_706) begin
          oKnownInst2 <= rBufData_2_2;
        end else if (_GEN_671 & _GEN_704) begin
          oKnownInst2 <= rBufData_2_1;
        end else if (_GEN_671 & _GEN_718) begin
          oKnownInst2 <= rBufData_2_0;
        end else if (_GEN_655 & _GEN_716) begin
          oKnownInst2 <= rBufData_1_7;
        end else if (_GEN_655 & _GEN_714) begin
          oKnownInst2 <= rBufData_1_6;
        end else if (_GEN_655 & _GEN_712) begin
          oKnownInst2 <= rBufData_1_5;
        end else if (_GEN_655 & _GEN_710) begin
          oKnownInst2 <= rBufData_1_4;
        end else if (_GEN_655 & _GEN_708) begin
          oKnownInst2 <= rBufData_1_3;
        end else if (_GEN_655 & _GEN_706) begin
          oKnownInst2 <= rBufData_1_2;
        end else if (_GEN_655 & _GEN_704) begin
          oKnownInst2 <= rBufData_1_1;
        end else if (_GEN_655 & _GEN_718) begin
          oKnownInst2 <= rBufData_1_0;
        end else if (_GEN_641 & _GEN_716) begin
          oKnownInst2 <= rBufData_0_7;
        end else if (_GEN_641 & _GEN_714) begin
          oKnownInst2 <= rBufData_0_6;
        end else if (_GEN_641 & _GEN_712) begin
          oKnownInst2 <= rBufData_0_5;
        end else if (_GEN_641 & _GEN_710) begin
          oKnownInst2 <= rBufData_0_4;
        end else if (_GEN_641 & _GEN_708) begin
          oKnownInst2 <= rBufData_0_3;
        end else if (_GEN_641 & _GEN_706) begin
          oKnownInst2 <= rBufData_0_2;
        end else if (_GEN_641 & _GEN_704) begin
          oKnownInst2 <= rBufData_0_1;
        end else begin
          oKnownInst2 <= rBufData_0_0;
        end
      end else if (invalidAddr) begin
        oKnownInst2 <= 32'h0;
      end
    end
    if (reset) begin
      oReadWay <= 1'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (hitWay) begin
            oReadWay <= hitWayId;
          end
        end
      end
    end
    if (reset) begin
      oReadBank <= 3'h0;
    end else if (_T_274) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (hitWay) begin
            oReadBank <= iBank;
          end
        end
      end
    end
    if (reset) begin
      hitCount <= 32'h0;
    end else if (_T_246) begin
      if (_T_249) begin
        hitCount <= _T_251;
      end
    end
    if (reset) begin
      missCount <= 32'h0;
    end else if (_T_246) begin
      if (!(_T_249)) begin
        missCount <= _T_253;
      end
    end
    if (reset) begin
      prevAddr <= 32'h0;
    end else if (io_enable) begin
      prevAddr <= io_iAddr;
    end
  end
endmodule
