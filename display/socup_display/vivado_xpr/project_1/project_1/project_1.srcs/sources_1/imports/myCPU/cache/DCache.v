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
module DCache(
  input         clock,
  input         reset,
  input         io_enable,
  input  [31:0] io_dAddr,
  input  [2:0]  io_dSize,
  input  [31:0] io_wData,
  input         io_wEn,
  input  [3:0]  io_wStrb,
  output        io_dWait,
  output [31:0] io_rData,
  input  [3:0]  io_action,
  output [31:0] io_missCount,
  output [31:0] io_hitCount,
  input  [31:0] io_bankDataIn_0_0,
  input  [31:0] io_bankDataIn_0_1,
  input  [31:0] io_bankDataIn_0_2,
  input  [31:0] io_bankDataIn_0_3,
  input  [31:0] io_bankDataIn_0_4,
  input  [31:0] io_bankDataIn_0_5,
  input  [31:0] io_bankDataIn_0_6,
  input  [31:0] io_bankDataIn_0_7,
  input  [31:0] io_bankDataIn_1_0,
  input  [31:0] io_bankDataIn_1_1,
  input  [31:0] io_bankDataIn_1_2,
  input  [31:0] io_bankDataIn_1_3,
  input  [31:0] io_bankDataIn_1_4,
  input  [31:0] io_bankDataIn_1_5,
  input  [31:0] io_bankDataIn_1_6,
  input  [31:0] io_bankDataIn_1_7,
  output [31:0] io_bankDataOut_0,
  output [31:0] io_bankDataOut_1,
  output [31:0] io_bankDataOut_2,
  output [31:0] io_bankDataOut_3,
  output [31:0] io_bankDataOut_4,
  output [31:0] io_bankDataOut_5,
  output [31:0] io_bankDataOut_6,
  output [31:0] io_bankDataOut_7,
  output [3:0]  io_bankWEn_0_0,
  output [3:0]  io_bankWEn_0_1,
  output [3:0]  io_bankWEn_0_2,
  output [3:0]  io_bankWEn_0_3,
  output [3:0]  io_bankWEn_0_4,
  output [3:0]  io_bankWEn_0_5,
  output [3:0]  io_bankWEn_0_6,
  output [3:0]  io_bankWEn_0_7,
  output [3:0]  io_bankWEn_1_0,
  output [3:0]  io_bankWEn_1_1,
  output [3:0]  io_bankWEn_1_2,
  output [3:0]  io_bankWEn_1_3,
  output [3:0]  io_bankWEn_1_4,
  output [3:0]  io_bankWEn_1_5,
  output [3:0]  io_bankWEn_1_6,
  output [3:0]  io_bankWEn_1_7,
  output [7:0]  io_bankSetAddr,
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
  input         io_vcReady,
  input         io_vcHit,
  output [26:0] io_vcWAddr,
  output [31:0] io_vcWData_0,
  output [31:0] io_vcWData_1,
  output [31:0] io_vcWData_2,
  output [31:0] io_vcWData_3,
  output [31:0] io_vcWData_4,
  output [31:0] io_vcWData_5,
  output [31:0] io_vcWData_6,
  output [31:0] io_vcWData_7,
  output        io_vcWValid,
  output [26:0] io_vcRAddr,
  input  [31:0] io_vcRData_0,
  input  [31:0] io_vcRData_1,
  input  [31:0] io_vcRData_2,
  input  [31:0] io_vcRData_3,
  input  [31:0] io_vcRData_4,
  input  [31:0] io_vcRData_5,
  input  [31:0] io_vcRData_6,
  input  [31:0] io_vcRData_7
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [255:0] _RAND_1;
  reg [255:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
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
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
`endif // RANDOMIZE_REG_INIT
  reg [18:0] tagMem [0:511]; // @[DCache.scala 163:19]
  wire [18:0] tagMem__T_36_data; // @[DCache.scala 163:19]
  wire [8:0] tagMem__T_36_addr; // @[DCache.scala 163:19]
  wire [18:0] tagMem__T_42_data; // @[DCache.scala 163:19]
  wire [8:0] tagMem__T_42_addr; // @[DCache.scala 163:19]
  wire [18:0] tagMem__T_133_data; // @[DCache.scala 163:19]
  wire [8:0] tagMem__T_133_addr; // @[DCache.scala 163:19]
  wire [18:0] tagMem__T_211_data; // @[DCache.scala 163:19]
  wire [8:0] tagMem__T_211_addr; // @[DCache.scala 163:19]
  wire  tagMem__T_211_mask; // @[DCache.scala 163:19]
  wire  tagMem__T_211_en; // @[DCache.scala 163:19]
  wire  lruMem_clock; // @[DCache.scala 302:22]
  wire  lruMem_reset; // @[DCache.scala 302:22]
  wire [7:0] lruMem_io_setAddr; // @[DCache.scala 302:22]
  wire  lruMem_io_visit; // @[DCache.scala 302:22]
  wire  lruMem_io_visitValid; // @[DCache.scala 302:22]
  wire  lruMem_io_waySel; // @[DCache.scala 302:22]
  reg [255:0] validMem_0; // @[DCache.scala 164:25]
  reg [255:0] validMem_1; // @[DCache.scala 164:25]
  reg [31:0] hitCount; // @[DCache.scala 168:25]
  reg [31:0] missCount; // @[DCache.scala 169:26]
  reg [31:0] prevAddr; // @[DCache.scala 170:25]
  reg [2:0] rState; // @[DCache.scala 187:23]
  reg [1:0] wState; // @[DCache.scala 188:23]
  reg [31:0] rAddr; // @[DCache.scala 192:22]
  reg [2:0] rBank; // @[DCache.scala 194:22]
  reg [31:0] rBuf_0; // @[DCache.scala 196:21]
  reg [31:0] rBuf_1; // @[DCache.scala 196:21]
  reg [31:0] rBuf_2; // @[DCache.scala 196:21]
  reg [31:0] rBuf_3; // @[DCache.scala 196:21]
  reg [31:0] rBuf_4; // @[DCache.scala 196:21]
  reg [31:0] rBuf_5; // @[DCache.scala 196:21]
  reg [31:0] rBuf_6; // @[DCache.scala 196:21]
  reg [31:0] rBuf_7; // @[DCache.scala 196:21]
  reg  rValid_0; // @[DCache.scala 198:23]
  reg  rValid_1; // @[DCache.scala 198:23]
  reg  rValid_2; // @[DCache.scala 198:23]
  reg  rValid_3; // @[DCache.scala 198:23]
  reg  rValid_4; // @[DCache.scala 198:23]
  reg  rValid_5; // @[DCache.scala 198:23]
  reg  rValid_6; // @[DCache.scala 198:23]
  reg  rValid_7; // @[DCache.scala 198:23]
  reg  rRefillSel; // @[DCache.scala 200:27]
  reg [31:0] wAddr; // @[DCache.scala 208:22]
  reg [31:0] wBuf_0; // @[DCache.scala 210:21]
  reg [31:0] wBuf_1; // @[DCache.scala 210:21]
  reg [31:0] wBuf_2; // @[DCache.scala 210:21]
  reg [31:0] wBuf_3; // @[DCache.scala 210:21]
  reg [31:0] wBuf_4; // @[DCache.scala 210:21]
  reg [31:0] wBuf_5; // @[DCache.scala 210:21]
  reg [31:0] wBuf_6; // @[DCache.scala 210:21]
  reg [31:0] wBuf_7; // @[DCache.scala 210:21]
  reg [2:0] wReqBank; // @[DCache.scala 215:25]
  reg [31:0] wReqData; // @[DCache.scala 216:25]
  reg [3:0] wReqWStrb; // @[DCache.scala 217:26]
  reg  wReqValid; // @[DCache.scala 218:26]
  wire [7:0] dSet = io_dAddr[12:5]; // @[Types.scala 48:34]
  wire [18:0] dTag = io_dAddr[31:13]; // @[Types.scala 47:34]
  wire [2:0] dBank = io_dAddr[4:2]; // @[Types.scala 49:35]
  reg  oState; // @[DCache.scala 229:23]
  reg [31:0] oKnownData; // @[DCache.scala 230:27]
  reg  oReadWay; // @[DCache.scala 231:25]
  reg [2:0] oReadBank; // @[DCache.scala 232:26]
  wire  _T_12 = rState == 3'h3; // @[DCache.scala 240:32]
  wire  _T_15 = rState == 3'h2; // @[DCache.scala 247:34]
  wire  _T_18 = rState == 3'h1; // @[DCache.scala 251:28]
  wire  _T_22 = ~oState; // @[DCache.scala 254:26]
  wire  _GEN_639 = ~oReadWay; // @[DCache.scala 254:18]
  wire  _GEN_640 = 3'h1 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_1 = _GEN_639 & _GEN_640 ? io_bankDataIn_0_1 : io_bankDataIn_0_0; // @[DCache.scala 254:18]
  wire  _GEN_642 = 3'h2 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_2 = _GEN_639 & _GEN_642 ? io_bankDataIn_0_2 : _GEN_1; // @[DCache.scala 254:18]
  wire  _GEN_644 = 3'h3 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_3 = _GEN_639 & _GEN_644 ? io_bankDataIn_0_3 : _GEN_2; // @[DCache.scala 254:18]
  wire  _GEN_646 = 3'h4 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_4 = _GEN_639 & _GEN_646 ? io_bankDataIn_0_4 : _GEN_3; // @[DCache.scala 254:18]
  wire  _GEN_648 = 3'h5 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_5 = _GEN_639 & _GEN_648 ? io_bankDataIn_0_5 : _GEN_4; // @[DCache.scala 254:18]
  wire  _GEN_650 = 3'h6 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_6 = _GEN_639 & _GEN_650 ? io_bankDataIn_0_6 : _GEN_5; // @[DCache.scala 254:18]
  wire  _GEN_652 = 3'h7 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_7 = _GEN_639 & _GEN_652 ? io_bankDataIn_0_7 : _GEN_6; // @[DCache.scala 254:18]
  wire  _GEN_653 = 3'h0 == oReadBank; // @[DCache.scala 254:18]
  wire [31:0] _GEN_8 = oReadWay & _GEN_653 ? io_bankDataIn_1_0 : _GEN_7; // @[DCache.scala 254:18]
  wire [31:0] _GEN_9 = oReadWay & _GEN_640 ? io_bankDataIn_1_1 : _GEN_8; // @[DCache.scala 254:18]
  wire [31:0] _GEN_10 = oReadWay & _GEN_642 ? io_bankDataIn_1_2 : _GEN_9; // @[DCache.scala 254:18]
  wire [31:0] _GEN_11 = oReadWay & _GEN_644 ? io_bankDataIn_1_3 : _GEN_10; // @[DCache.scala 254:18]
  wire [31:0] _GEN_12 = oReadWay & _GEN_646 ? io_bankDataIn_1_4 : _GEN_11; // @[DCache.scala 254:18]
  wire [31:0] _GEN_13 = oReadWay & _GEN_648 ? io_bankDataIn_1_5 : _GEN_12; // @[DCache.scala 254:18]
  wire [31:0] _GEN_14 = oReadWay & _GEN_650 ? io_bankDataIn_1_6 : _GEN_13; // @[DCache.scala 254:18]
  wire [31:0] _GEN_15 = oReadWay & _GEN_652 ? io_bankDataIn_1_7 : _GEN_14; // @[DCache.scala 254:18]
  wire  _T_27 = rState == 3'h0; // @[DCache.scala 263:22]
  wire  _T_28 = wState == 2'h0; // @[DCache.scala 263:43]
  wire  axiReady = _T_27 & _T_28; // @[DCache.scala 263:33]
  wire  _T_30 = ~wReqValid; // @[DCache.scala 267:16]
  wire  _T_31 = _T_30 & io_wEn; // @[DCache.scala 267:27]
  wire  canBuffer = _T_31 & axiReady; // @[DCache.scala 267:37]
  wire [255:0] _T_33 = validMem_0 >> dSet; // @[DCache.scala 271:66]
  wire  _T_37 = tagMem__T_36_data == dTag; // @[DCache.scala 271:123]
  wire  _T_38 = _T_33[0] & _T_37; // @[DCache.scala 271:73]
  wire [255:0] _T_39 = validMem_1 >> dSet; // @[DCache.scala 271:66]
  wire  _T_43 = tagMem__T_42_data == dTag; // @[DCache.scala 271:123]
  wire  _T_44 = _T_39[0] & _T_43; // @[DCache.scala 271:73]
  wire [1:0] hitWays = {_T_44,_T_38}; // @[DCache.scala 271:135]
  wire  hitWayId = hitWays[0] ? 1'h0 : 1'h1; // @[Mux.scala 47:69]
  wire  _T_50 = wReqBank == rBank; // @[DCache.scala 277:44]
  wire  _T_51 = wReqValid & _T_50; // @[DCache.scala 277:32]
  wire  _T_53 = _T_51 & _T_15; // @[DCache.scala 277:54]
  wire  bufHitAxiDirect = _T_53 & io_axiReadIn_rvalid; // @[DCache.scala 277:75]
  wire  _T_57 = rAddr[31:5] == io_dAddr[31:5]; // @[DCache.scala 280:44]
  wire  _T_59 = _T_57 & _T_15; // @[DCache.scala 280:79]
  wire  _GEN_17 = 3'h1 == dBank ? rValid_1 : rValid_0; // @[DCache.scala 280:100]
  wire  _GEN_18 = 3'h2 == dBank ? rValid_2 : _GEN_17; // @[DCache.scala 280:100]
  wire  _GEN_19 = 3'h3 == dBank ? rValid_3 : _GEN_18; // @[DCache.scala 280:100]
  wire  _GEN_20 = 3'h4 == dBank ? rValid_4 : _GEN_19; // @[DCache.scala 280:100]
  wire  _GEN_21 = 3'h5 == dBank ? rValid_5 : _GEN_20; // @[DCache.scala 280:100]
  wire  _GEN_22 = 3'h6 == dBank ? rValid_6 : _GEN_21; // @[DCache.scala 280:100]
  wire  _GEN_23 = 3'h7 == dBank ? rValid_7 : _GEN_22; // @[DCache.scala 280:100]
  wire  hitAxiBuf = _T_59 & _GEN_23; // @[DCache.scala 280:100]
  wire  _T_68 = dBank == rBank; // @[DCache.scala 283:32]
  wire  _T_69 = _T_59 & _T_68; // @[DCache.scala 282:103]
  wire  _T_70 = _T_69 & io_axiReadIn_rvalid; // @[DCache.scala 283:42]
  wire  _T_71 = ~bufHitAxiDirect; // @[DCache.scala 283:68]
  wire  hitAxiDirect = _T_70 & _T_71; // @[DCache.scala 283:65]
  wire  _T_74 = |hitWays; // @[DCache.scala 289:24]
  wire  _T_75 = ~_T_12; // @[DCache.scala 289:30]
  wire  hitWay = _T_74 & _T_75; // @[DCache.scala 289:27]
  wire  _T_77 = hitAxiDirect | hitAxiBuf; // @[DCache.scala 292:23]
  wire  hit = _T_77 | hitWay; // @[DCache.scala 292:36]
  wire  _T_79 = io_dAddr != prevAddr; // @[DCache.scala 296:22]
  wire  _T_80 = _T_79 & io_enable; // @[DCache.scala 296:35]
  wire  _T_81 = ~hit; // @[DCache.scala 296:51]
  wire  isMiss = _T_80 & _T_81; // @[DCache.scala 296:48]
  wire  isHit = _T_80 & hit; // @[DCache.scala 298:47]
  wire [31:0] _T_87 = missCount + 32'h1; // @[DCache.scala 299:38]
  wire [31:0] _T_90 = hitCount + 32'h1; // @[DCache.scala 300:35]
  wire  _T_98 = io_enable & _T_81; // @[DCache.scala 347:26]
  wire  _T_99 = ~canBuffer; // @[DCache.scala 347:37]
  wire [31:0] _GEN_25 = 3'h1 == dBank ? rBuf_1 : rBuf_0; // @[DCache.scala 404:18]
  wire [31:0] _GEN_26 = 3'h2 == dBank ? rBuf_2 : _GEN_25; // @[DCache.scala 404:18]
  wire [31:0] _GEN_27 = 3'h3 == dBank ? rBuf_3 : _GEN_26; // @[DCache.scala 404:18]
  wire [31:0] _GEN_28 = 3'h4 == dBank ? rBuf_4 : _GEN_27; // @[DCache.scala 404:18]
  wire [31:0] _GEN_29 = 3'h5 == dBank ? rBuf_5 : _GEN_28; // @[DCache.scala 404:18]
  wire [31:0] _GEN_30 = 3'h6 == dBank ? rBuf_6 : _GEN_29; // @[DCache.scala 404:18]
  wire [31:0] _GEN_31 = 3'h7 == dBank ? rBuf_7 : _GEN_30; // @[DCache.scala 404:18]
  wire [7:0] _T_105 = io_wStrb[3] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [7:0] _T_107 = io_wStrb[2] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [7:0] _T_109 = io_wStrb[1] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [7:0] _T_111 = io_wStrb[0] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [32:0] _T_115 = {1'h0,_T_105,_T_107,_T_109,_T_111}; // @[Cat.scala 29:58]
  wire [31:0] _T_117 = _T_115[31:0] & io_wData; // @[DCache.scala 40:12]
  wire [31:0] _T_118 = ~_T_115[31:0]; // @[DCache.scala 40:25]
  wire [31:0] _T_119 = _T_118 & _GEN_31; // @[DCache.scala 40:33]
  wire [31:0] _T_120 = _T_117 | _T_119; // @[DCache.scala 40:21]
  wire [31:0] _GEN_32 = 3'h0 == dBank ? _T_120 : rBuf_0; // @[DCache.scala 406:19]
  wire [31:0] _GEN_33 = 3'h1 == dBank ? _T_120 : rBuf_1; // @[DCache.scala 406:19]
  wire [31:0] _GEN_34 = 3'h2 == dBank ? _T_120 : rBuf_2; // @[DCache.scala 406:19]
  wire [31:0] _GEN_35 = 3'h3 == dBank ? _T_120 : rBuf_3; // @[DCache.scala 406:19]
  wire [31:0] _GEN_36 = 3'h4 == dBank ? _T_120 : rBuf_4; // @[DCache.scala 406:19]
  wire [31:0] _GEN_37 = 3'h5 == dBank ? _T_120 : rBuf_5; // @[DCache.scala 406:19]
  wire [31:0] _GEN_38 = 3'h6 == dBank ? _T_120 : rBuf_6; // @[DCache.scala 406:19]
  wire [31:0] _GEN_39 = 3'h7 == dBank ? _T_120 : rBuf_7; // @[DCache.scala 406:19]
  wire  _GEN_661 = ~hitWayId; // @[DCache.scala 416:35]
  wire  _GEN_662 = 3'h0 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_40 = _GEN_661 & _GEN_662 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_664 = 3'h1 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_41 = _GEN_661 & _GEN_664 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_666 = 3'h2 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_42 = _GEN_661 & _GEN_666 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_668 = 3'h3 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_43 = _GEN_661 & _GEN_668 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_670 = 3'h4 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_44 = _GEN_661 & _GEN_670 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_672 = 3'h5 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_45 = _GEN_661 & _GEN_672 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_674 = 3'h6 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_46 = _GEN_661 & _GEN_674 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire  _GEN_676 = 3'h7 == dBank; // @[DCache.scala 416:35]
  wire [3:0] _GEN_47 = _GEN_661 & _GEN_676 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_48 = hitWayId & _GEN_662 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_49 = hitWayId & _GEN_664 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_50 = hitWayId & _GEN_666 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_51 = hitWayId & _GEN_668 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_52 = hitWayId & _GEN_670 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_53 = hitWayId & _GEN_672 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_54 = hitWayId & _GEN_674 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [3:0] _GEN_55 = hitWayId & _GEN_676 ? io_wStrb : 4'h0; // @[DCache.scala 416:35]
  wire [255:0] _T_121 = 256'h1 << dSet; // @[DCache.scala 89:10]
  wire [31:0] _T_125 = {io_dAddr[31:2],2'h0}; // @[Cat.scala 29:58]
  wire  refillSel = lruMem_io_waySel; // @[DCache.scala 307:23 DCache.scala 308:13]
  wire [255:0] _GEN_61 = refillSel ? validMem_1 : validMem_0; // @[DCache.scala 431:37]
  wire [255:0] _T_127 = _GEN_61 >> dSet; // @[DCache.scala 431:37]
  wire [1:0] _T_131 = _T_127[0] ? 2'h1 : 2'h0; // @[DCache.scala 432:20]
  wire [31:0] _T_135 = {tagMem__T_133_data,dSet,5'h0}; // @[Cat.scala 29:58]
  wire [255:0] _T_137 = ~_T_121; // @[DCache.scala 113:10]
  wire [255:0] _T_138 = _GEN_61 & _T_137; // @[DCache.scala 113:7]
  wire  _GEN_67 = canBuffer | wReqValid; // @[DCache.scala 438:24]
  wire  _GEN_71 = axiReady ? 1'h0 : rValid_0; // @[DCache.scala 420:27]
  wire  _GEN_72 = axiReady ? 1'h0 : rValid_1; // @[DCache.scala 420:27]
  wire  _GEN_73 = axiReady ? 1'h0 : rValid_2; // @[DCache.scala 420:27]
  wire  _GEN_74 = axiReady ? 1'h0 : rValid_3; // @[DCache.scala 420:27]
  wire  _GEN_75 = axiReady ? 1'h0 : rValid_4; // @[DCache.scala 420:27]
  wire  _GEN_76 = axiReady ? 1'h0 : rValid_5; // @[DCache.scala 420:27]
  wire  _GEN_77 = axiReady ? 1'h0 : rValid_6; // @[DCache.scala 420:27]
  wire  _GEN_78 = axiReady ? 1'h0 : rValid_7; // @[DCache.scala 420:27]
  wire [1:0] _GEN_84 = axiReady ? _T_131 : wState; // @[DCache.scala 420:27]
  wire [31:0] _GEN_88 = axiReady ? _T_135 : wAddr; // @[DCache.scala 420:27]
  wire  _GEN_95 = hitWay | oState; // @[DCache.scala 409:24]
  wire [3:0] _GEN_100 = hitWay ? _GEN_40 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_101 = hitWay ? _GEN_41 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_102 = hitWay ? _GEN_42 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_103 = hitWay ? _GEN_43 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_104 = hitWay ? _GEN_44 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_105 = hitWay ? _GEN_45 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_106 = hitWay ? _GEN_46 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_107 = hitWay ? _GEN_47 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_108 = hitWay ? _GEN_48 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_109 = hitWay ? _GEN_49 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_110 = hitWay ? _GEN_50 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_111 = hitWay ? _GEN_51 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_112 = hitWay ? _GEN_52 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_113 = hitWay ? _GEN_53 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_114 = hitWay ? _GEN_54 : 4'h0; // @[DCache.scala 409:24]
  wire [3:0] _GEN_115 = hitWay ? _GEN_55 : 4'h0; // @[DCache.scala 409:24]
  wire  _GEN_118 = hitWay & hitWayId; // @[DCache.scala 409:24]
  wire  _GEN_122 = hitWay ? rValid_0 : _GEN_71; // @[DCache.scala 409:24]
  wire  _GEN_123 = hitWay ? rValid_1 : _GEN_72; // @[DCache.scala 409:24]
  wire  _GEN_124 = hitWay ? rValid_2 : _GEN_73; // @[DCache.scala 409:24]
  wire  _GEN_125 = hitWay ? rValid_3 : _GEN_74; // @[DCache.scala 409:24]
  wire  _GEN_126 = hitWay ? rValid_4 : _GEN_75; // @[DCache.scala 409:24]
  wire  _GEN_127 = hitWay ? rValid_5 : _GEN_76; // @[DCache.scala 409:24]
  wire  _GEN_128 = hitWay ? rValid_6 : _GEN_77; // @[DCache.scala 409:24]
  wire  _GEN_129 = hitWay ? rValid_7 : _GEN_78; // @[DCache.scala 409:24]
  wire [1:0] _GEN_135 = hitWay ? wState : _GEN_84; // @[DCache.scala 409:24]
  wire  _GEN_138 = hitWay ? 1'h0 : axiReady; // @[DCache.scala 409:24]
  wire [31:0] _GEN_139 = hitWay ? wAddr : _GEN_88; // @[DCache.scala 409:24]
  wire [31:0] _GEN_149 = hitAxiBuf ? _GEN_32 : rBuf_0; // @[DCache.scala 401:27]
  wire [31:0] _GEN_150 = hitAxiBuf ? _GEN_33 : rBuf_1; // @[DCache.scala 401:27]
  wire [31:0] _GEN_151 = hitAxiBuf ? _GEN_34 : rBuf_2; // @[DCache.scala 401:27]
  wire [31:0] _GEN_152 = hitAxiBuf ? _GEN_35 : rBuf_3; // @[DCache.scala 401:27]
  wire [31:0] _GEN_153 = hitAxiBuf ? _GEN_36 : rBuf_4; // @[DCache.scala 401:27]
  wire [31:0] _GEN_154 = hitAxiBuf ? _GEN_37 : rBuf_5; // @[DCache.scala 401:27]
  wire [31:0] _GEN_155 = hitAxiBuf ? _GEN_38 : rBuf_6; // @[DCache.scala 401:27]
  wire [31:0] _GEN_156 = hitAxiBuf ? _GEN_39 : rBuf_7; // @[DCache.scala 401:27]
  wire  _GEN_157 = hitAxiBuf ? rRefillSel : _GEN_118; // @[DCache.scala 401:27]
  wire [3:0] _GEN_162 = hitAxiBuf ? 4'h0 : _GEN_100; // @[DCache.scala 401:27]
  wire [3:0] _GEN_163 = hitAxiBuf ? 4'h0 : _GEN_101; // @[DCache.scala 401:27]
  wire [3:0] _GEN_164 = hitAxiBuf ? 4'h0 : _GEN_102; // @[DCache.scala 401:27]
  wire [3:0] _GEN_165 = hitAxiBuf ? 4'h0 : _GEN_103; // @[DCache.scala 401:27]
  wire [3:0] _GEN_166 = hitAxiBuf ? 4'h0 : _GEN_104; // @[DCache.scala 401:27]
  wire [3:0] _GEN_167 = hitAxiBuf ? 4'h0 : _GEN_105; // @[DCache.scala 401:27]
  wire [3:0] _GEN_168 = hitAxiBuf ? 4'h0 : _GEN_106; // @[DCache.scala 401:27]
  wire [3:0] _GEN_169 = hitAxiBuf ? 4'h0 : _GEN_107; // @[DCache.scala 401:27]
  wire [3:0] _GEN_170 = hitAxiBuf ? 4'h0 : _GEN_108; // @[DCache.scala 401:27]
  wire [3:0] _GEN_171 = hitAxiBuf ? 4'h0 : _GEN_109; // @[DCache.scala 401:27]
  wire [3:0] _GEN_172 = hitAxiBuf ? 4'h0 : _GEN_110; // @[DCache.scala 401:27]
  wire [3:0] _GEN_173 = hitAxiBuf ? 4'h0 : _GEN_111; // @[DCache.scala 401:27]
  wire [3:0] _GEN_174 = hitAxiBuf ? 4'h0 : _GEN_112; // @[DCache.scala 401:27]
  wire [3:0] _GEN_175 = hitAxiBuf ? 4'h0 : _GEN_113; // @[DCache.scala 401:27]
  wire [3:0] _GEN_176 = hitAxiBuf ? 4'h0 : _GEN_114; // @[DCache.scala 401:27]
  wire [3:0] _GEN_177 = hitAxiBuf ? 4'h0 : _GEN_115; // @[DCache.scala 401:27]
  wire  _GEN_183 = hitAxiBuf ? rValid_0 : _GEN_122; // @[DCache.scala 401:27]
  wire  _GEN_184 = hitAxiBuf ? rValid_1 : _GEN_123; // @[DCache.scala 401:27]
  wire  _GEN_185 = hitAxiBuf ? rValid_2 : _GEN_124; // @[DCache.scala 401:27]
  wire  _GEN_186 = hitAxiBuf ? rValid_3 : _GEN_125; // @[DCache.scala 401:27]
  wire  _GEN_187 = hitAxiBuf ? rValid_4 : _GEN_126; // @[DCache.scala 401:27]
  wire  _GEN_188 = hitAxiBuf ? rValid_5 : _GEN_127; // @[DCache.scala 401:27]
  wire  _GEN_189 = hitAxiBuf ? rValid_6 : _GEN_128; // @[DCache.scala 401:27]
  wire  _GEN_190 = hitAxiBuf ? rValid_7 : _GEN_129; // @[DCache.scala 401:27]
  wire [1:0] _GEN_195 = hitAxiBuf ? wState : _GEN_135; // @[DCache.scala 401:27]
  wire  _GEN_198 = hitAxiBuf ? 1'h0 : _GEN_138; // @[DCache.scala 401:27]
  wire [31:0] _GEN_199 = hitAxiBuf ? wAddr : _GEN_139; // @[DCache.scala 401:27]
  wire  _GEN_209 = hitAxiDirect ? rRefillSel : _GEN_157; // @[DCache.scala 394:24]
  wire [31:0] _GEN_210 = hitAxiDirect ? rBuf_0 : _GEN_149; // @[DCache.scala 394:24]
  wire [31:0] _GEN_211 = hitAxiDirect ? rBuf_1 : _GEN_150; // @[DCache.scala 394:24]
  wire [31:0] _GEN_212 = hitAxiDirect ? rBuf_2 : _GEN_151; // @[DCache.scala 394:24]
  wire [31:0] _GEN_213 = hitAxiDirect ? rBuf_3 : _GEN_152; // @[DCache.scala 394:24]
  wire [31:0] _GEN_214 = hitAxiDirect ? rBuf_4 : _GEN_153; // @[DCache.scala 394:24]
  wire [31:0] _GEN_215 = hitAxiDirect ? rBuf_5 : _GEN_154; // @[DCache.scala 394:24]
  wire [31:0] _GEN_216 = hitAxiDirect ? rBuf_6 : _GEN_155; // @[DCache.scala 394:24]
  wire [31:0] _GEN_217 = hitAxiDirect ? rBuf_7 : _GEN_156; // @[DCache.scala 394:24]
  wire [3:0] _GEN_222 = hitAxiDirect ? 4'h0 : _GEN_162; // @[DCache.scala 394:24]
  wire [3:0] _GEN_223 = hitAxiDirect ? 4'h0 : _GEN_163; // @[DCache.scala 394:24]
  wire [3:0] _GEN_224 = hitAxiDirect ? 4'h0 : _GEN_164; // @[DCache.scala 394:24]
  wire [3:0] _GEN_225 = hitAxiDirect ? 4'h0 : _GEN_165; // @[DCache.scala 394:24]
  wire [3:0] _GEN_226 = hitAxiDirect ? 4'h0 : _GEN_166; // @[DCache.scala 394:24]
  wire [3:0] _GEN_227 = hitAxiDirect ? 4'h0 : _GEN_167; // @[DCache.scala 394:24]
  wire [3:0] _GEN_228 = hitAxiDirect ? 4'h0 : _GEN_168; // @[DCache.scala 394:24]
  wire [3:0] _GEN_229 = hitAxiDirect ? 4'h0 : _GEN_169; // @[DCache.scala 394:24]
  wire [3:0] _GEN_230 = hitAxiDirect ? 4'h0 : _GEN_170; // @[DCache.scala 394:24]
  wire [3:0] _GEN_231 = hitAxiDirect ? 4'h0 : _GEN_171; // @[DCache.scala 394:24]
  wire [3:0] _GEN_232 = hitAxiDirect ? 4'h0 : _GEN_172; // @[DCache.scala 394:24]
  wire [3:0] _GEN_233 = hitAxiDirect ? 4'h0 : _GEN_173; // @[DCache.scala 394:24]
  wire [3:0] _GEN_234 = hitAxiDirect ? 4'h0 : _GEN_174; // @[DCache.scala 394:24]
  wire [3:0] _GEN_235 = hitAxiDirect ? 4'h0 : _GEN_175; // @[DCache.scala 394:24]
  wire [3:0] _GEN_236 = hitAxiDirect ? 4'h0 : _GEN_176; // @[DCache.scala 394:24]
  wire [3:0] _GEN_237 = hitAxiDirect ? 4'h0 : _GEN_177; // @[DCache.scala 394:24]
  wire  _GEN_243 = hitAxiDirect ? rValid_0 : _GEN_183; // @[DCache.scala 394:24]
  wire  _GEN_244 = hitAxiDirect ? rValid_1 : _GEN_184; // @[DCache.scala 394:24]
  wire  _GEN_245 = hitAxiDirect ? rValid_2 : _GEN_185; // @[DCache.scala 394:24]
  wire  _GEN_246 = hitAxiDirect ? rValid_3 : _GEN_186; // @[DCache.scala 394:24]
  wire  _GEN_247 = hitAxiDirect ? rValid_4 : _GEN_187; // @[DCache.scala 394:24]
  wire  _GEN_248 = hitAxiDirect ? rValid_5 : _GEN_188; // @[DCache.scala 394:24]
  wire  _GEN_249 = hitAxiDirect ? rValid_6 : _GEN_189; // @[DCache.scala 394:24]
  wire  _GEN_250 = hitAxiDirect ? rValid_7 : _GEN_190; // @[DCache.scala 394:24]
  wire [1:0] _GEN_255 = hitAxiDirect ? wState : _GEN_195; // @[DCache.scala 394:24]
  wire  _GEN_258 = hitAxiDirect ? 1'h0 : _GEN_198; // @[DCache.scala 394:24]
  wire [31:0] _GEN_259 = hitAxiDirect ? wAddr : _GEN_199; // @[DCache.scala 394:24]
  wire [31:0] _GEN_270 = io_enable ? _GEN_210 : rBuf_0; // @[DCache.scala 393:19]
  wire [31:0] _GEN_271 = io_enable ? _GEN_211 : rBuf_1; // @[DCache.scala 393:19]
  wire [31:0] _GEN_272 = io_enable ? _GEN_212 : rBuf_2; // @[DCache.scala 393:19]
  wire [31:0] _GEN_273 = io_enable ? _GEN_213 : rBuf_3; // @[DCache.scala 393:19]
  wire [31:0] _GEN_274 = io_enable ? _GEN_214 : rBuf_4; // @[DCache.scala 393:19]
  wire [31:0] _GEN_275 = io_enable ? _GEN_215 : rBuf_5; // @[DCache.scala 393:19]
  wire [31:0] _GEN_276 = io_enable ? _GEN_216 : rBuf_6; // @[DCache.scala 393:19]
  wire [31:0] _GEN_277 = io_enable ? _GEN_217 : rBuf_7; // @[DCache.scala 393:19]
  wire [3:0] _GEN_282 = io_enable ? _GEN_222 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_283 = io_enable ? _GEN_223 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_284 = io_enable ? _GEN_224 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_285 = io_enable ? _GEN_225 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_286 = io_enable ? _GEN_226 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_287 = io_enable ? _GEN_227 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_288 = io_enable ? _GEN_228 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_289 = io_enable ? _GEN_229 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_290 = io_enable ? _GEN_230 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_291 = io_enable ? _GEN_231 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_292 = io_enable ? _GEN_232 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_293 = io_enable ? _GEN_233 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_294 = io_enable ? _GEN_234 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_295 = io_enable ? _GEN_235 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_296 = io_enable ? _GEN_236 : 4'h0; // @[DCache.scala 393:19]
  wire [3:0] _GEN_297 = io_enable ? _GEN_237 : 4'h0; // @[DCache.scala 393:19]
  wire  _GEN_303 = io_enable ? _GEN_243 : rValid_0; // @[DCache.scala 393:19]
  wire  _GEN_304 = io_enable ? _GEN_244 : rValid_1; // @[DCache.scala 393:19]
  wire  _GEN_305 = io_enable ? _GEN_245 : rValid_2; // @[DCache.scala 393:19]
  wire  _GEN_306 = io_enable ? _GEN_246 : rValid_3; // @[DCache.scala 393:19]
  wire  _GEN_307 = io_enable ? _GEN_247 : rValid_4; // @[DCache.scala 393:19]
  wire  _GEN_308 = io_enable ? _GEN_248 : rValid_5; // @[DCache.scala 393:19]
  wire  _GEN_309 = io_enable ? _GEN_249 : rValid_6; // @[DCache.scala 393:19]
  wire  _GEN_310 = io_enable ? _GEN_250 : rValid_7; // @[DCache.scala 393:19]
  wire [1:0] _GEN_315 = io_enable ? _GEN_255 : wState; // @[DCache.scala 393:19]
  wire [31:0] _GEN_319 = io_enable ? _GEN_259 : wAddr; // @[DCache.scala 393:19]
  wire  _T_139 = 2'h1 == wState; // @[Conditional.scala 37:30]
  wire [31:0] _GEN_334 = rRefillSel ? io_bankDataIn_1_0 : io_bankDataIn_0_0; // @[DCache.scala 452:12]
  wire [31:0] _GEN_335 = rRefillSel ? io_bankDataIn_1_1 : io_bankDataIn_0_1; // @[DCache.scala 452:12]
  wire [31:0] _GEN_336 = rRefillSel ? io_bankDataIn_1_2 : io_bankDataIn_0_2; // @[DCache.scala 452:12]
  wire [31:0] _GEN_337 = rRefillSel ? io_bankDataIn_1_3 : io_bankDataIn_0_3; // @[DCache.scala 452:12]
  wire [31:0] _GEN_338 = rRefillSel ? io_bankDataIn_1_4 : io_bankDataIn_0_4; // @[DCache.scala 452:12]
  wire [31:0] _GEN_339 = rRefillSel ? io_bankDataIn_1_5 : io_bankDataIn_0_5; // @[DCache.scala 452:12]
  wire [31:0] _GEN_340 = rRefillSel ? io_bankDataIn_1_6 : io_bankDataIn_0_6; // @[DCache.scala 452:12]
  wire [31:0] _GEN_341 = rRefillSel ? io_bankDataIn_1_7 : io_bankDataIn_0_7; // @[DCache.scala 452:12]
  wire  _T_140 = 2'h2 == wState; // @[Conditional.scala 37:30]
  wire [1:0] _T_141 = io_vcReady ? 2'h0 : 2'h2; // @[DCache.scala 456:20]
  wire [1:0] _GEN_342 = _T_140 ? _T_141 : _GEN_315; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_343 = _T_139 ? 2'h2 : _GEN_342; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_344 = _T_139 ? _GEN_334 : wBuf_0; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_345 = _T_139 ? _GEN_335 : wBuf_1; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_346 = _T_139 ? _GEN_336 : wBuf_2; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_347 = _T_139 ? _GEN_337 : wBuf_3; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_348 = _T_139 ? _GEN_338 : wBuf_4; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_349 = _T_139 ? _GEN_339 : wBuf_5; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_350 = _T_139 ? _GEN_340 : wBuf_6; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_351 = _T_139 ? _GEN_341 : wBuf_7; // @[Conditional.scala 40:58]
  wire  _T_142 = 3'h1 == rState; // @[Conditional.scala 37:30]
  wire [7:0] _T_146 = wReqWStrb[3] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [7:0] _T_148 = wReqWStrb[2] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [7:0] _T_150 = wReqWStrb[1] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [7:0] _T_152 = wReqWStrb[0] ? 8'hff : 8'h0; // @[DCache.scala 26:32]
  wire [32:0] _T_156 = {1'h0,_T_146,_T_148,_T_150,_T_152}; // @[Cat.scala 29:58]
  wire [31:0] _T_158 = _T_156[31:0] & wReqData; // @[DCache.scala 40:12]
  wire [31:0] _T_159 = ~_T_156[31:0]; // @[DCache.scala 40:25]
  wire [31:0] _GEN_353 = 3'h1 == wReqBank ? rBuf_1 : rBuf_0; // @[DCache.scala 40:33]
  wire [31:0] _GEN_354 = 3'h2 == wReqBank ? rBuf_2 : _GEN_353; // @[DCache.scala 40:33]
  wire [31:0] _GEN_355 = 3'h3 == wReqBank ? rBuf_3 : _GEN_354; // @[DCache.scala 40:33]
  wire [31:0] _GEN_356 = 3'h4 == wReqBank ? rBuf_4 : _GEN_355; // @[DCache.scala 40:33]
  wire [31:0] _GEN_357 = 3'h5 == wReqBank ? rBuf_5 : _GEN_356; // @[DCache.scala 40:33]
  wire [31:0] _GEN_358 = 3'h6 == wReqBank ? rBuf_6 : _GEN_357; // @[DCache.scala 40:33]
  wire [31:0] _GEN_359 = 3'h7 == wReqBank ? rBuf_7 : _GEN_358; // @[DCache.scala 40:33]
  wire [31:0] _T_160 = _T_159 & _GEN_359; // @[DCache.scala 40:33]
  wire [31:0] _T_161 = _T_158 | _T_160; // @[DCache.scala 40:21]
  wire  _GEN_377 = io_vcHit | _GEN_303; // @[DCache.scala 462:22]
  wire  _GEN_378 = io_vcHit | _GEN_304; // @[DCache.scala 462:22]
  wire  _GEN_379 = io_vcHit | _GEN_305; // @[DCache.scala 462:22]
  wire  _GEN_380 = io_vcHit | _GEN_306; // @[DCache.scala 462:22]
  wire  _GEN_381 = io_vcHit | _GEN_307; // @[DCache.scala 462:22]
  wire  _GEN_382 = io_vcHit | _GEN_308; // @[DCache.scala 462:22]
  wire  _GEN_383 = io_vcHit | _GEN_309; // @[DCache.scala 462:22]
  wire  _GEN_384 = io_vcHit | _GEN_310; // @[DCache.scala 462:22]
  wire  _GEN_394 = io_vcHit ? 1'h0 : 1'h1; // @[DCache.scala 462:22]
  wire  _T_163 = 3'h2 == rState; // @[Conditional.scala 37:30]
  wire [31:0] _T_180 = _T_159 & io_axiReadIn_rdata; // @[DCache.scala 40:33]
  wire [31:0] _T_181 = _T_158 | _T_180; // @[DCache.scala 40:21]
  wire  _T_182 = hitAxiDirect & io_wEn; // @[DCache.scala 482:33]
  wire [31:0] _T_199 = _T_118 & io_axiReadIn_rdata; // @[DCache.scala 40:33]
  wire [31:0] _T_200 = _T_117 | _T_199; // @[DCache.scala 40:21]
  wire [31:0] _T_201 = io_axiReadIn_rvalid ? io_axiReadIn_rdata : 32'h0; // @[DCache.scala 485:27]
  wire [2:0] _T_203 = rBank + 3'h1; // @[DCache.scala 488:47]
  wire  _T_205 = io_axiReadIn_rlast & io_axiReadIn_rvalid; // @[DCache.scala 489:40]
  wire  _T_207 = 3'h3 == rState; // @[Conditional.scala 37:30]
  wire [3:0] _GEN_444 = ~rRefillSel ? 4'hf : _GEN_282; // @[DCache.scala 494:30]
  wire [3:0] _GEN_445 = rRefillSel ? 4'hf : _GEN_290; // @[DCache.scala 494:30]
  wire [3:0] _GEN_446 = ~rRefillSel ? 4'hf : _GEN_283; // @[DCache.scala 494:30]
  wire [3:0] _GEN_447 = rRefillSel ? 4'hf : _GEN_291; // @[DCache.scala 494:30]
  wire [3:0] _GEN_448 = ~rRefillSel ? 4'hf : _GEN_284; // @[DCache.scala 494:30]
  wire [3:0] _GEN_449 = rRefillSel ? 4'hf : _GEN_292; // @[DCache.scala 494:30]
  wire [3:0] _GEN_450 = ~rRefillSel ? 4'hf : _GEN_285; // @[DCache.scala 494:30]
  wire [3:0] _GEN_451 = rRefillSel ? 4'hf : _GEN_293; // @[DCache.scala 494:30]
  wire [3:0] _GEN_452 = ~rRefillSel ? 4'hf : _GEN_286; // @[DCache.scala 494:30]
  wire [3:0] _GEN_453 = rRefillSel ? 4'hf : _GEN_294; // @[DCache.scala 494:30]
  wire [3:0] _GEN_454 = ~rRefillSel ? 4'hf : _GEN_287; // @[DCache.scala 494:30]
  wire [3:0] _GEN_455 = rRefillSel ? 4'hf : _GEN_295; // @[DCache.scala 494:30]
  wire [3:0] _GEN_456 = ~rRefillSel ? 4'hf : _GEN_288; // @[DCache.scala 494:30]
  wire [3:0] _GEN_457 = rRefillSel ? 4'hf : _GEN_296; // @[DCache.scala 494:30]
  wire [3:0] _GEN_458 = ~rRefillSel ? 4'hf : _GEN_289; // @[DCache.scala 494:30]
  wire [3:0] _GEN_459 = rRefillSel ? 4'hf : _GEN_297; // @[DCache.scala 494:30]
  wire [255:0] _T_214 = 256'h1 << rAddr[12:5]; // @[DCache.scala 89:10]
  wire [255:0] _GEN_465 = rRefillSel ? validMem_1 : validMem_0; // @[DCache.scala 113:7]
  wire [255:0] _T_227 = _GEN_465 | _T_214; // @[DCache.scala 101:7]
  wire  _T_230 = 3'h4 == rState; // @[Conditional.scala 37:30]
  wire [39:0] _T_236 = {rAddr[31:5],dSet,5'h0}; // @[Cat.scala 29:58]
  wire [39:0] _GEN_478 = _T_28 ? _T_236 : {{8'd0}, _GEN_319}; // @[DCache.scala 513:32]
  wire [39:0] _GEN_490 = _T_230 ? _GEN_478 : {{8'd0}, _GEN_319}; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_491 = _T_207 ? _GEN_444 : _GEN_282; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_492 = _T_207 ? _GEN_445 : _GEN_290; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_493 = _T_207 ? _GEN_446 : _GEN_283; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_494 = _T_207 ? _GEN_447 : _GEN_291; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_495 = _T_207 ? _GEN_448 : _GEN_284; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_496 = _T_207 ? _GEN_449 : _GEN_292; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_497 = _T_207 ? _GEN_450 : _GEN_285; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_498 = _T_207 ? _GEN_451 : _GEN_293; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_499 = _T_207 ? _GEN_452 : _GEN_286; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_500 = _T_207 ? _GEN_453 : _GEN_294; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_501 = _T_207 ? _GEN_454 : _GEN_287; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_502 = _T_207 ? _GEN_455 : _GEN_295; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_503 = _T_207 ? _GEN_456 : _GEN_288; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_504 = _T_207 ? _GEN_457 : _GEN_296; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_505 = _T_207 ? _GEN_458 : _GEN_289; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_506 = _T_207 ? _GEN_459 : _GEN_297; // @[Conditional.scala 39:67]
  wire [39:0] _GEN_527 = _T_207 ? {{8'd0}, _GEN_319} : _GEN_490; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_547 = _T_163 ? _GEN_282 : _GEN_491; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_548 = _T_163 ? _GEN_290 : _GEN_492; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_549 = _T_163 ? _GEN_283 : _GEN_493; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_550 = _T_163 ? _GEN_291 : _GEN_494; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_551 = _T_163 ? _GEN_284 : _GEN_495; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_552 = _T_163 ? _GEN_292 : _GEN_496; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_553 = _T_163 ? _GEN_285 : _GEN_497; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_554 = _T_163 ? _GEN_293 : _GEN_498; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_555 = _T_163 ? _GEN_286 : _GEN_499; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_556 = _T_163 ? _GEN_294 : _GEN_500; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_557 = _T_163 ? _GEN_287 : _GEN_501; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_558 = _T_163 ? _GEN_295 : _GEN_502; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_559 = _T_163 ? _GEN_288 : _GEN_503; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_560 = _T_163 ? _GEN_296 : _GEN_504; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_561 = _T_163 ? _GEN_289 : _GEN_505; // @[Conditional.scala 39:67]
  wire [3:0] _GEN_562 = _T_163 ? _GEN_297 : _GEN_506; // @[Conditional.scala 39:67]
  wire  _GEN_565 = _T_163 ? 1'h0 : _T_207; // @[Conditional.scala 39:67]
  wire [39:0] _GEN_582 = _T_163 ? {{8'd0}, _GEN_319} : _GEN_527; // @[Conditional.scala 39:67]
  wire [39:0] _GEN_638 = _T_142 ? {{8'd0}, _GEN_319} : _GEN_582; // @[Conditional.scala 40:58]
  LruMem lruMem ( // @[DCache.scala 302:22]
    .clock(lruMem_clock),
    .reset(lruMem_reset),
    .io_setAddr(lruMem_io_setAddr),
    .io_visit(lruMem_io_visit),
    .io_visitValid(lruMem_io_visitValid),
    .io_waySel(lruMem_io_waySel)
  );
  assign tagMem__T_36_addr = {1'h0,dSet};
  assign tagMem__T_36_data = tagMem[tagMem__T_36_addr]; // @[DCache.scala 163:19]
  assign tagMem__T_42_addr = {1'h1,dSet};
  assign tagMem__T_42_data = tagMem[tagMem__T_42_addr]; // @[DCache.scala 163:19]
  assign tagMem__T_133_addr = {refillSel,dSet};
  assign tagMem__T_133_data = tagMem[tagMem__T_133_addr]; // @[DCache.scala 163:19]
  assign tagMem__T_211_data = rAddr[31:13];
  assign tagMem__T_211_addr = {rRefillSel,rAddr[12:5]};
  assign tagMem__T_211_mask = 1'h1;
  assign tagMem__T_211_en = _T_142 ? 1'h0 : _GEN_565;
  assign io_dWait = _T_98 & _T_99; // @[DCache.scala 347:12]
  assign io_rData = _T_22 ? oKnownData : _GEN_15; // @[DCache.scala 254:12]
  assign io_missCount = missCount; // @[DCache.scala 174:16]
  assign io_hitCount = hitCount; // @[DCache.scala 173:15]
  assign io_bankDataOut_0 = _T_12 ? rBuf_0 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_1 = _T_12 ? rBuf_1 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_2 = _T_12 ? rBuf_2 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_3 = _T_12 ? rBuf_3 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_4 = _T_12 ? rBuf_4 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_5 = _T_12 ? rBuf_5 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_6 = _T_12 ? rBuf_6 : io_wData; // @[DCache.scala 259:18]
  assign io_bankDataOut_7 = _T_12 ? rBuf_7 : io_wData; // @[DCache.scala 259:18]
  assign io_bankWEn_0_0 = _T_142 ? _GEN_282 : _GEN_547; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_1 = _T_142 ? _GEN_283 : _GEN_549; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_2 = _T_142 ? _GEN_284 : _GEN_551; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_3 = _T_142 ? _GEN_285 : _GEN_553; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_4 = _T_142 ? _GEN_286 : _GEN_555; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_5 = _T_142 ? _GEN_287 : _GEN_557; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_6 = _T_142 ? _GEN_288 : _GEN_559; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_0_7 = _T_142 ? _GEN_289 : _GEN_561; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_0 = _T_142 ? _GEN_290 : _GEN_548; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_1 = _T_142 ? _GEN_291 : _GEN_550; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_2 = _T_142 ? _GEN_292 : _GEN_552; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_3 = _T_142 ? _GEN_293 : _GEN_554; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_4 = _T_142 ? _GEN_294 : _GEN_556; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_5 = _T_142 ? _GEN_295 : _GEN_558; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_6 = _T_142 ? _GEN_296 : _GEN_560; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankWEn_1_7 = _T_142 ? _GEN_297 : _GEN_562; // @[DCache.scala 239:14 DCache.scala 416:35 DCache.scala 494:30]
  assign io_bankSetAddr = _T_12 ? rAddr[12:5] : dSet; // @[DCache.scala 240:18]
  assign io_axiReadAddrOut_arid = 4'h0; // @[DCache.scala 241:26]
  assign io_axiReadAddrOut_araddr = rAddr; // @[DCache.scala 242:28]
  assign io_axiReadAddrOut_arvalid = _T_142 & _GEN_394; // @[DCache.scala 243:29 DCache.scala 473:35]
  assign io_axiReadAddrOut_arlen = 4'h7; // @[DCache.scala 244:27]
  assign io_axiReadAddrOut_arsize = 3'h2; // @[DCache.scala 245:28]
  assign io_axiReadAddrOut_arburst = 2'h2; // @[DCache.scala 246:29]
  assign io_axiReadOut_rready = rState == 3'h2; // @[DCache.scala 247:24]
  assign io_vcWAddr = wAddr[31:5]; // @[DCache.scala 248:14]
  assign io_vcWData_0 = wBuf_0; // @[DCache.scala 249:14]
  assign io_vcWData_1 = wBuf_1; // @[DCache.scala 249:14]
  assign io_vcWData_2 = wBuf_2; // @[DCache.scala 249:14]
  assign io_vcWData_3 = wBuf_3; // @[DCache.scala 249:14]
  assign io_vcWData_4 = wBuf_4; // @[DCache.scala 249:14]
  assign io_vcWData_5 = wBuf_5; // @[DCache.scala 249:14]
  assign io_vcWData_6 = wBuf_6; // @[DCache.scala 249:14]
  assign io_vcWData_7 = wBuf_7; // @[DCache.scala 249:14]
  assign io_vcWValid = wState == 2'h2; // @[DCache.scala 250:15]
  assign io_vcRAddr = _T_18 ? rAddr[31:5] : io_dAddr[31:5]; // @[DCache.scala 251:14]
  assign lruMem_clock = clock;
  assign lruMem_reset = reset;
  assign lruMem_io_setAddr = io_dAddr[12:5]; // @[DCache.scala 303:21]
  assign lruMem_io_visit = io_enable & _GEN_209; // @[DCache.scala 304:19 DCache.scala 400:23 DCache.scala 408:23 DCache.scala 419:23]
  assign lruMem_io_visitValid = _T_77 | hitWay; // @[DCache.scala 305:24]
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
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {8{`RANDOM}};
  validMem_0 = _RAND_1[255:0];
  _RAND_2 = {8{`RANDOM}};
  validMem_1 = _RAND_2[255:0];
  _RAND_3 = {1{`RANDOM}};
  hitCount = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  missCount = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  prevAddr = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  rState = _RAND_6[2:0];
  _RAND_7 = {1{`RANDOM}};
  wState = _RAND_7[1:0];
  _RAND_8 = {1{`RANDOM}};
  rAddr = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  rBank = _RAND_9[2:0];
  _RAND_10 = {1{`RANDOM}};
  rBuf_0 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  rBuf_1 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  rBuf_2 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  rBuf_3 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  rBuf_4 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  rBuf_5 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  rBuf_6 = _RAND_16[31:0];
  _RAND_17 = {1{`RANDOM}};
  rBuf_7 = _RAND_17[31:0];
  _RAND_18 = {1{`RANDOM}};
  rValid_0 = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  rValid_1 = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  rValid_2 = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  rValid_3 = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  rValid_4 = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  rValid_5 = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  rValid_6 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  rValid_7 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  rRefillSel = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  wAddr = _RAND_27[31:0];
  _RAND_28 = {1{`RANDOM}};
  wBuf_0 = _RAND_28[31:0];
  _RAND_29 = {1{`RANDOM}};
  wBuf_1 = _RAND_29[31:0];
  _RAND_30 = {1{`RANDOM}};
  wBuf_2 = _RAND_30[31:0];
  _RAND_31 = {1{`RANDOM}};
  wBuf_3 = _RAND_31[31:0];
  _RAND_32 = {1{`RANDOM}};
  wBuf_4 = _RAND_32[31:0];
  _RAND_33 = {1{`RANDOM}};
  wBuf_5 = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  wBuf_6 = _RAND_34[31:0];
  _RAND_35 = {1{`RANDOM}};
  wBuf_7 = _RAND_35[31:0];
  _RAND_36 = {1{`RANDOM}};
  wReqBank = _RAND_36[2:0];
  _RAND_37 = {1{`RANDOM}};
  wReqData = _RAND_37[31:0];
  _RAND_38 = {1{`RANDOM}};
  wReqWStrb = _RAND_38[3:0];
  _RAND_39 = {1{`RANDOM}};
  wReqValid = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  oState = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  oKnownData = _RAND_41[31:0];
  _RAND_42 = {1{`RANDOM}};
  oReadWay = _RAND_42[0:0];
  _RAND_43 = {1{`RANDOM}};
  oReadBank = _RAND_43[2:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(tagMem__T_211_en & tagMem__T_211_mask) begin
      tagMem[tagMem__T_211_addr] <= tagMem__T_211_data; // @[DCache.scala 163:19]
    end
    if (reset) begin
      validMem_0 <= 256'h0;
    end else if (_T_142) begin
      if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (~refillSel) begin
                  validMem_0 <= _T_138;
                end
              end
            end
          end
        end
      end
    end else if (_T_163) begin
      if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (~refillSel) begin
                  validMem_0 <= _T_138;
                end
              end
            end
          end
        end
      end
    end else if (_T_207) begin
      if (~rRefillSel) begin
        validMem_0 <= _T_227;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (~refillSel) begin
                  validMem_0 <= _T_138;
                end
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              if (~refillSel) begin
                validMem_0 <= _T_138;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      validMem_1 <= 256'h0;
    end else if (_T_142) begin
      if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (refillSel) begin
                  validMem_1 <= _T_138;
                end
              end
            end
          end
        end
      end
    end else if (_T_163) begin
      if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (refillSel) begin
                  validMem_1 <= _T_138;
                end
              end
            end
          end
        end
      end
    end else if (_T_207) begin
      if (rRefillSel) begin
        validMem_1 <= _T_227;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (refillSel) begin
                  validMem_1 <= _T_138;
                end
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              if (refillSel) begin
                validMem_1 <= _T_138;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      hitCount <= 32'h0;
    end else if (isHit) begin
      hitCount <= _T_90;
    end
    if (reset) begin
      missCount <= 32'h0;
    end else if (isMiss) begin
      missCount <= _T_87;
    end
    if (reset) begin
      prevAddr <= 32'h0;
    end else if (io_enable) begin
      prevAddr <= io_dAddr;
    end
    if (reset) begin
      rState <= 3'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        rState <= 3'h3;
      end else if (io_axiReadAddrIn_arready) begin
        rState <= 3'h2;
      end else begin
        rState <= 3'h1;
      end
    end else if (_T_163) begin
      if (_T_205) begin
        rState <= 3'h3;
      end else begin
        rState <= 3'h2;
      end
    end else if (_T_207) begin
      rState <= 3'h0;
    end else if (_T_230) begin
      if (_T_28) begin
        rState <= 3'h0;
      end else begin
        rState <= 3'h4;
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rState <= 3'h1;
            end
          end
        end
      end
    end
    if (reset) begin
      wState <= 2'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        wState <= 2'h2;
      end else if (_T_140) begin
        if (io_vcReady) begin
          wState <= 2'h0;
        end else begin
          wState <= 2'h2;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (_T_127[0]) begin
                  wState <= 2'h1;
                end else begin
                  wState <= 2'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        wState <= 2'h2;
      end else if (_T_140) begin
        if (io_vcReady) begin
          wState <= 2'h0;
        end else begin
          wState <= 2'h2;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (_T_127[0]) begin
                  wState <= 2'h1;
                end else begin
                  wState <= 2'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        wState <= 2'h2;
      end else if (_T_140) begin
        if (io_vcReady) begin
          wState <= 2'h0;
        end else begin
          wState <= 2'h2;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (_T_127[0]) begin
                  wState <= 2'h1;
                end else begin
                  wState <= 2'h0;
                end
              end
            end
          end
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wState <= 2'h2;
      end else if (_T_139) begin
        wState <= 2'h2;
      end else if (_T_140) begin
        if (io_vcReady) begin
          wState <= 2'h0;
        end else begin
          wState <= 2'h2;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                if (_T_127[0]) begin
                  wState <= 2'h1;
                end else begin
                  wState <= 2'h0;
                end
              end
            end
          end
        end
      end
    end else begin
      wState <= _GEN_343;
    end
    if (reset) begin
      rAddr <= 32'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rAddr <= _T_125;
            end
          end
        end
      end
    end
    if (reset) begin
      rBank <= 3'h0;
    end else if (_T_142) begin
      if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rBank <= dBank;
              end
            end
          end
        end
      end
    end else if (_T_163) begin
      if (io_axiReadIn_rvalid) begin
        rBank <= _T_203;
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rBank <= dBank;
            end
          end
        end
      end
    end
    if (reset) begin
      rBuf_0 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h0 == wReqBank) begin
            rBuf_0 <= _T_161;
          end else begin
            rBuf_0 <= io_vcRData_0;
          end
        end else begin
          rBuf_0 <= io_vcRData_0;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h0 == dBank) begin
              rBuf_0 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h0 == rBank) begin
          rBuf_0 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h0 == dBank) begin
                rBuf_0 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h0 == rBank) begin
          rBuf_0 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h0 == dBank) begin
                rBuf_0 <= _T_120;
              end
            end
          end
        end
      end else if (3'h0 == rBank) begin
        if (io_axiReadIn_rvalid) begin
          rBuf_0 <= io_axiReadIn_rdata;
        end else begin
          rBuf_0 <= 32'h0;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h0 == dBank) begin
              rBuf_0 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_0 <= _GEN_270;
    end
    if (reset) begin
      rBuf_1 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h1 == wReqBank) begin
            rBuf_1 <= _T_161;
          end else begin
            rBuf_1 <= io_vcRData_1;
          end
        end else begin
          rBuf_1 <= io_vcRData_1;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h1 == dBank) begin
              rBuf_1 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h1 == rBank) begin
          rBuf_1 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h1 == dBank) begin
                rBuf_1 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h1 == rBank) begin
          rBuf_1 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h1 == dBank) begin
                rBuf_1 <= _T_120;
              end
            end
          end
        end
      end else if (3'h1 == rBank) begin
        if (io_axiReadIn_rvalid) begin
          rBuf_1 <= io_axiReadIn_rdata;
        end else begin
          rBuf_1 <= 32'h0;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h1 == dBank) begin
              rBuf_1 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_1 <= _GEN_271;
    end
    if (reset) begin
      rBuf_2 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h2 == wReqBank) begin
            rBuf_2 <= _T_161;
          end else begin
            rBuf_2 <= io_vcRData_2;
          end
        end else begin
          rBuf_2 <= io_vcRData_2;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h2 == dBank) begin
              rBuf_2 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h2 == rBank) begin
          rBuf_2 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h2 == dBank) begin
                rBuf_2 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h2 == rBank) begin
          rBuf_2 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h2 == dBank) begin
                rBuf_2 <= _T_120;
              end
            end
          end
        end
      end else if (3'h2 == rBank) begin
        if (io_axiReadIn_rvalid) begin
          rBuf_2 <= io_axiReadIn_rdata;
        end else begin
          rBuf_2 <= 32'h0;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h2 == dBank) begin
              rBuf_2 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_2 <= _GEN_272;
    end
    if (reset) begin
      rBuf_3 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h3 == wReqBank) begin
            rBuf_3 <= _T_161;
          end else begin
            rBuf_3 <= io_vcRData_3;
          end
        end else begin
          rBuf_3 <= io_vcRData_3;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h3 == dBank) begin
              rBuf_3 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h3 == rBank) begin
          rBuf_3 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h3 == dBank) begin
                rBuf_3 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h3 == rBank) begin
          rBuf_3 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h3 == dBank) begin
                rBuf_3 <= _T_120;
              end
            end
          end
        end
      end else if (3'h3 == rBank) begin
        if (io_axiReadIn_rvalid) begin
          rBuf_3 <= io_axiReadIn_rdata;
        end else begin
          rBuf_3 <= 32'h0;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h3 == dBank) begin
              rBuf_3 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_3 <= _GEN_273;
    end
    if (reset) begin
      rBuf_4 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h4 == wReqBank) begin
            rBuf_4 <= _T_161;
          end else begin
            rBuf_4 <= io_vcRData_4;
          end
        end else begin
          rBuf_4 <= io_vcRData_4;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h4 == dBank) begin
              rBuf_4 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h4 == rBank) begin
          rBuf_4 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h4 == dBank) begin
                rBuf_4 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h4 == rBank) begin
          rBuf_4 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h4 == dBank) begin
                rBuf_4 <= _T_120;
              end
            end
          end
        end
      end else if (3'h4 == rBank) begin
        rBuf_4 <= _T_201;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h4 == dBank) begin
              rBuf_4 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_4 <= _GEN_274;
    end
    if (reset) begin
      rBuf_5 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h5 == wReqBank) begin
            rBuf_5 <= _T_161;
          end else begin
            rBuf_5 <= io_vcRData_5;
          end
        end else begin
          rBuf_5 <= io_vcRData_5;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h5 == dBank) begin
              rBuf_5 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h5 == rBank) begin
          rBuf_5 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h5 == dBank) begin
                rBuf_5 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h5 == rBank) begin
          rBuf_5 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h5 == dBank) begin
                rBuf_5 <= _T_120;
              end
            end
          end
        end
      end else if (3'h5 == rBank) begin
        rBuf_5 <= _T_201;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h5 == dBank) begin
              rBuf_5 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_5 <= _GEN_275;
    end
    if (reset) begin
      rBuf_6 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h6 == wReqBank) begin
            rBuf_6 <= _T_161;
          end else begin
            rBuf_6 <= io_vcRData_6;
          end
        end else begin
          rBuf_6 <= io_vcRData_6;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h6 == dBank) begin
              rBuf_6 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h6 == rBank) begin
          rBuf_6 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h6 == dBank) begin
                rBuf_6 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h6 == rBank) begin
          rBuf_6 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h6 == dBank) begin
                rBuf_6 <= _T_120;
              end
            end
          end
        end
      end else if (3'h6 == rBank) begin
        rBuf_6 <= _T_201;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h6 == dBank) begin
              rBuf_6 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_6 <= _GEN_276;
    end
    if (reset) begin
      rBuf_7 <= 32'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        if (wReqValid) begin
          if (3'h7 == wReqBank) begin
            rBuf_7 <= _T_161;
          end else begin
            rBuf_7 <= io_vcRData_7;
          end
        end else begin
          rBuf_7 <= io_vcRData_7;
        end
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h7 == dBank) begin
              rBuf_7 <= _T_120;
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        if (3'h7 == rBank) begin
          rBuf_7 <= _T_181;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h7 == dBank) begin
                rBuf_7 <= _T_120;
              end
            end
          end
        end
      end else if (_T_182) begin
        if (3'h7 == rBank) begin
          rBuf_7 <= _T_200;
        end else if (io_enable) begin
          if (!(hitAxiDirect)) begin
            if (hitAxiBuf) begin
              if (3'h7 == dBank) begin
                rBuf_7 <= _T_120;
              end
            end
          end
        end
      end else if (3'h7 == rBank) begin
        rBuf_7 <= _T_201;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (hitAxiBuf) begin
            if (3'h7 == dBank) begin
              rBuf_7 <= _T_120;
            end
          end
        end
      end
    end else begin
      rBuf_7 <= _GEN_277;
    end
    if (reset) begin
      rValid_0 <= 1'h0;
    end else if (_T_142) begin
      rValid_0 <= _GEN_377;
    end else if (_T_163) begin
      if (3'h0 == rBank) begin
        rValid_0 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_0 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_0 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_1 <= 1'h0;
    end else if (_T_142) begin
      rValid_1 <= _GEN_378;
    end else if (_T_163) begin
      if (3'h1 == rBank) begin
        rValid_1 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_1 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_1 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_2 <= 1'h0;
    end else if (_T_142) begin
      rValid_2 <= _GEN_379;
    end else if (_T_163) begin
      if (3'h2 == rBank) begin
        rValid_2 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_2 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_2 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_3 <= 1'h0;
    end else if (_T_142) begin
      rValid_3 <= _GEN_380;
    end else if (_T_163) begin
      if (3'h3 == rBank) begin
        rValid_3 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_3 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_3 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_4 <= 1'h0;
    end else if (_T_142) begin
      rValid_4 <= _GEN_381;
    end else if (_T_163) begin
      if (3'h4 == rBank) begin
        rValid_4 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_4 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_4 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_5 <= 1'h0;
    end else if (_T_142) begin
      rValid_5 <= _GEN_382;
    end else if (_T_163) begin
      if (3'h5 == rBank) begin
        rValid_5 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_5 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_5 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_6 <= 1'h0;
    end else if (_T_142) begin
      rValid_6 <= _GEN_383;
    end else if (_T_163) begin
      if (3'h6 == rBank) begin
        rValid_6 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_6 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_6 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rValid_7 <= 1'h0;
    end else if (_T_142) begin
      rValid_7 <= _GEN_384;
    end else if (_T_163) begin
      if (3'h7 == rBank) begin
        rValid_7 <= io_axiReadIn_rvalid;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                rValid_7 <= 1'h0;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rValid_7 <= 1'h0;
            end
          end
        end
      end
    end
    if (reset) begin
      rRefillSel <= 1'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              rRefillSel <= refillSel;
            end
          end
        end
      end
    end
    if (reset) begin
      wAddr <= 32'h0;
    end else begin
      wAddr <= _GEN_638[31:0];
    end
    if (reset) begin
      wBuf_0 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_0 <= io_bankDataIn_1_0;
        end else begin
          wBuf_0 <= io_bankDataIn_0_0;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_0 <= io_bankDataIn_1_0;
        end else begin
          wBuf_0 <= io_bankDataIn_0_0;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_0 <= io_bankDataIn_1_0;
        end else begin
          wBuf_0 <= io_bankDataIn_0_0;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_0 <= rBuf_0;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_0 <= io_bankDataIn_1_0;
        end else begin
          wBuf_0 <= io_bankDataIn_0_0;
        end
      end
    end else begin
      wBuf_0 <= _GEN_344;
    end
    if (reset) begin
      wBuf_1 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_1 <= io_bankDataIn_1_1;
        end else begin
          wBuf_1 <= io_bankDataIn_0_1;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_1 <= io_bankDataIn_1_1;
        end else begin
          wBuf_1 <= io_bankDataIn_0_1;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_1 <= io_bankDataIn_1_1;
        end else begin
          wBuf_1 <= io_bankDataIn_0_1;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_1 <= rBuf_1;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_1 <= io_bankDataIn_1_1;
        end else begin
          wBuf_1 <= io_bankDataIn_0_1;
        end
      end
    end else begin
      wBuf_1 <= _GEN_345;
    end
    if (reset) begin
      wBuf_2 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_2 <= io_bankDataIn_1_2;
        end else begin
          wBuf_2 <= io_bankDataIn_0_2;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_2 <= io_bankDataIn_1_2;
        end else begin
          wBuf_2 <= io_bankDataIn_0_2;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_2 <= io_bankDataIn_1_2;
        end else begin
          wBuf_2 <= io_bankDataIn_0_2;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_2 <= rBuf_2;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_2 <= io_bankDataIn_1_2;
        end else begin
          wBuf_2 <= io_bankDataIn_0_2;
        end
      end
    end else begin
      wBuf_2 <= _GEN_346;
    end
    if (reset) begin
      wBuf_3 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_3 <= io_bankDataIn_1_3;
        end else begin
          wBuf_3 <= io_bankDataIn_0_3;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_3 <= io_bankDataIn_1_3;
        end else begin
          wBuf_3 <= io_bankDataIn_0_3;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_3 <= io_bankDataIn_1_3;
        end else begin
          wBuf_3 <= io_bankDataIn_0_3;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_3 <= rBuf_3;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_3 <= io_bankDataIn_1_3;
        end else begin
          wBuf_3 <= io_bankDataIn_0_3;
        end
      end
    end else begin
      wBuf_3 <= _GEN_347;
    end
    if (reset) begin
      wBuf_4 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_4 <= io_bankDataIn_1_4;
        end else begin
          wBuf_4 <= io_bankDataIn_0_4;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_4 <= io_bankDataIn_1_4;
        end else begin
          wBuf_4 <= io_bankDataIn_0_4;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_4 <= io_bankDataIn_1_4;
        end else begin
          wBuf_4 <= io_bankDataIn_0_4;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_4 <= rBuf_4;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_4 <= io_bankDataIn_1_4;
        end else begin
          wBuf_4 <= io_bankDataIn_0_4;
        end
      end
    end else begin
      wBuf_4 <= _GEN_348;
    end
    if (reset) begin
      wBuf_5 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_5 <= io_bankDataIn_1_5;
        end else begin
          wBuf_5 <= io_bankDataIn_0_5;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_5 <= io_bankDataIn_1_5;
        end else begin
          wBuf_5 <= io_bankDataIn_0_5;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_5 <= io_bankDataIn_1_5;
        end else begin
          wBuf_5 <= io_bankDataIn_0_5;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_5 <= rBuf_5;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_5 <= io_bankDataIn_1_5;
        end else begin
          wBuf_5 <= io_bankDataIn_0_5;
        end
      end
    end else begin
      wBuf_5 <= _GEN_349;
    end
    if (reset) begin
      wBuf_6 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_6 <= io_bankDataIn_1_6;
        end else begin
          wBuf_6 <= io_bankDataIn_0_6;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_6 <= io_bankDataIn_1_6;
        end else begin
          wBuf_6 <= io_bankDataIn_0_6;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_6 <= io_bankDataIn_1_6;
        end else begin
          wBuf_6 <= io_bankDataIn_0_6;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_6 <= rBuf_6;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_6 <= io_bankDataIn_1_6;
        end else begin
          wBuf_6 <= io_bankDataIn_0_6;
        end
      end
    end else begin
      wBuf_6 <= _GEN_350;
    end
    if (reset) begin
      wBuf_7 <= 32'h0;
    end else if (_T_142) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_7 <= io_bankDataIn_1_7;
        end else begin
          wBuf_7 <= io_bankDataIn_0_7;
        end
      end
    end else if (_T_163) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_7 <= io_bankDataIn_1_7;
        end else begin
          wBuf_7 <= io_bankDataIn_0_7;
        end
      end
    end else if (_T_207) begin
      if (_T_139) begin
        if (rRefillSel) begin
          wBuf_7 <= io_bankDataIn_1_7;
        end else begin
          wBuf_7 <= io_bankDataIn_0_7;
        end
      end
    end else if (_T_230) begin
      if (_T_28) begin
        wBuf_7 <= rBuf_7;
      end else if (_T_139) begin
        if (rRefillSel) begin
          wBuf_7 <= io_bankDataIn_1_7;
        end else begin
          wBuf_7 <= io_bankDataIn_0_7;
        end
      end
    end else begin
      wBuf_7 <= _GEN_351;
    end
    if (reset) begin
      wReqBank <= 3'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              if (canBuffer) begin
                wReqBank <= dBank;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      wReqData <= 32'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              if (canBuffer) begin
                wReqData <= io_wData;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      wReqWStrb <= 4'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              if (canBuffer) begin
                wReqWStrb <= io_wStrb;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      wReqValid <= 1'h0;
    end else if (_T_142) begin
      if (io_vcHit) begin
        wReqValid <= 1'h0;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                wReqValid <= _GEN_67;
              end
            end
          end
        end
      end
    end else if (_T_163) begin
      if (bufHitAxiDirect) begin
        wReqValid <= 1'h0;
      end else if (io_enable) begin
        if (!(hitAxiDirect)) begin
          if (!(hitAxiBuf)) begin
            if (!(hitWay)) begin
              if (axiReady) begin
                wReqValid <= _GEN_67;
              end
            end
          end
        end
      end
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (!(hitWay)) begin
            if (axiReady) begin
              wReqValid <= _GEN_67;
            end
          end
        end
      end
    end
    if (reset) begin
      oState <= 1'h0;
    end else if (io_enable) begin
      if (hitAxiDirect) begin
        oState <= 1'h0;
      end else if (hitAxiBuf) begin
        oState <= 1'h0;
      end else begin
        oState <= _GEN_95;
      end
    end
    if (reset) begin
      oKnownData <= 32'h0;
    end else if (io_enable) begin
      if (hitAxiDirect) begin
        oKnownData <= io_axiReadIn_rdata;
      end else if (hitAxiBuf) begin
        if (3'h7 == dBank) begin
          oKnownData <= rBuf_7;
        end else if (3'h6 == dBank) begin
          oKnownData <= rBuf_6;
        end else if (3'h5 == dBank) begin
          oKnownData <= rBuf_5;
        end else if (3'h4 == dBank) begin
          oKnownData <= rBuf_4;
        end else if (3'h3 == dBank) begin
          oKnownData <= rBuf_3;
        end else if (3'h2 == dBank) begin
          oKnownData <= rBuf_2;
        end else if (3'h1 == dBank) begin
          oKnownData <= rBuf_1;
        end else begin
          oKnownData <= rBuf_0;
        end
      end
    end
    if (reset) begin
      oReadWay <= 1'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (hitWay) begin
            if (hitWays[0]) begin
              oReadWay <= 1'h0;
            end else begin
              oReadWay <= 1'h1;
            end
          end
        end
      end
    end
    if (reset) begin
      oReadBank <= 3'h0;
    end else if (io_enable) begin
      if (!(hitAxiDirect)) begin
        if (!(hitAxiBuf)) begin
          if (hitWay) begin
            oReadBank <= dBank;
          end
        end
      end
    end
  end
endmodule
