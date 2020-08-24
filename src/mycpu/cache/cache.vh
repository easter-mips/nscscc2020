`timescale 1ns / 1ps
`ifndef ICACHE_DEFS_VH
`define ICACHE_DEFS_VH
`timescale 1ns / 1ps

`define ADDR_BUS 31:0
`define LINE_ADDR_BUS 31:5
`define INST_BUS 31:0
`define DATA_BUS 31:0
`define BLOCK_BUS 4:0
`define SET_BUS 7:0
`define TAG_BUS 18:0
`define DC_SET_BUS 7:0
`define DC_TAG_BUS 18:0
`define BANK_BUS 2:0
`define BANK_SEL_BUS 2:0
`define TRAM_DATA_BUS 18:0

`define WORD_ADDR_SLICE 31:2
`define BLOCK_ADDR_SLICE 31:5
`define LINE_ADDR_SLICE 31:5

`endif