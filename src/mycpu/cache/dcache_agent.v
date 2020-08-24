/* AUTOMATICALLY GENERATED VERILOG-2001 SOURCE CODE.
** GENERATED BY CLASH 1.2.3. DO NOT MODIFY.
*/
`timescale 1ns / 1ps
module dcache_agent
    ( // Inputs
      input  clock // clock
    , input  __reset // reset
    , input  __en
    , input  resetn
    , input [31:0] addr_mem
    , input  en_mem
    , input  wen_mem
    , input [2:0] rwsize_mem
    , input [3:0] wstrb_mem
    , input [31:0] wdata_mem
    , input  wait_cache
    , input [31:0] rdata_cache

      // Outputs
    , output wire [31:0] addr_cache
    , output wire  en_cache
    , output wire  wen_cache
    , output wire [2:0] rwsize_cache
    , output wire [3:0] wstrb_cache
    , output wire [31:0] wdata_cache
    , output wire  wait_mem
    , output wire [31:0] rdata_mem
    );
  // ../src/DCacheAgentTop.hs:49:1-9
  reg [107:0] c$ds_app_arg = {1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx};
  wire [213:0] c$case_alt;
  wire  c$app_arg;
  wire  c$case_alt_0;
  wire  c$case_alt_1;
  wire [31:0] c$app_arg_0;
  wire [3:0] c$app_arg_1;
  wire [2:0] c$app_arg_2;
  wire  c$app_arg_3;
  wire  c$app_arg_4;
  wire [31:0] c$app_arg_5;
  // ../src/DCacheAgent/Agent.hs:17:1-12
  wire [106:0] ipv;
  wire [107:0] c$app_arg_6;
  wire [107:0] c$case_alt_2;
  wire [107:0] c$case_alt_3;
  wire [107:0] c$case_alt_4;
  wire [107:0] c$case_alt_5;
  wire [106:0] eta1;
  wire [105:0] _clash_internal;

  assign eta1 = {resetn
                ,addr_mem
                ,en_mem
                ,wen_mem
                ,rwsize_mem
                ,wstrb_mem
                ,wdata_mem
                ,wait_cache
                ,rdata_cache};

  // register begin
  always @(posedge clock or  posedge  __reset) begin : c$ds_app_arg_register
    if ( __reset) begin
      c$ds_app_arg <= {1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx};
    end else  if (__en)  begin
      c$ds_app_arg <= c$case_alt[213:106];
    end
  end
  // register end

  assign _clash_internal = c$case_alt[105:0];

  assign c$case_alt = eta1[106:106] ? {c$app_arg_6
                                      ,{c$app_arg_5
                                       ,c$app_arg_4
                                       ,c$app_arg_3
                                       ,c$app_arg_2
                                       ,c$app_arg_1
                                       ,c$app_arg_0
                                       ,c$app_arg
                                       ,eta1[31:0]}} : {{1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx}
                                                       ,{32'b00000000000000000000000000000000
                                                        ,1'b0
                                                        ,1'b0
                                                        ,3'b000
                                                        ,4'b0000
                                                        ,32'b00000000000000000000000000000000
                                                        ,1'b0
                                                        ,32'b00000000000000000000000000000000}};

  assign c$app_arg = c$ds_app_arg[107:107] ? eta1[73:73] : c$case_alt_0;

  assign c$case_alt_0 = eta1[73:73] ? c$case_alt_1 : eta1[32:32];

  assign c$case_alt_1 = eta1[72:72] ? 1'b0 : eta1[32:32];

  assign c$app_arg_0 = c$ds_app_arg[107:107] ? ipv[64:33] : eta1[64:33];

  assign c$app_arg_1 = c$ds_app_arg[107:107] ? ipv[68:65] : eta1[68:65];

  assign c$app_arg_2 = c$ds_app_arg[107:107] ? ipv[71:69] : eta1[71:69];

  assign c$app_arg_3 = c$ds_app_arg[107:107] ? ipv[72:72] : eta1[72:72];

  assign c$app_arg_4 = c$ds_app_arg[107:107] ? ipv[73:73] : eta1[73:73];

  assign c$app_arg_5 = c$ds_app_arg[107:107] ? ipv[105:74] : eta1[105:74];

  assign ipv = c$ds_app_arg[106:0];

  assign c$app_arg_6 = c$ds_app_arg[107:107] ? c$case_alt_2 : c$case_alt_3;

  assign c$case_alt_2 = eta1[32:32] ? c$ds_app_arg : {1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx};

  assign c$case_alt_3 = eta1[73:73] ? c$case_alt_4 : {1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx};

  assign c$case_alt_4 = eta1[72:72] ? c$case_alt_5 : {1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx};

  assign c$case_alt_5 = eta1[32:32] ? {1'b1,eta1} : {1'b0,107'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx};

  assign addr_cache = _clash_internal[105:74];

  assign en_cache = _clash_internal[73:73];

  assign wen_cache = _clash_internal[72:72];

  assign rwsize_cache = _clash_internal[71:69];

  assign wstrb_cache = _clash_internal[68:65];

  assign wdata_cache = _clash_internal[64:33];

  assign wait_mem = _clash_internal[32:32];

  assign rdata_mem = _clash_internal[31:0];


endmodule
