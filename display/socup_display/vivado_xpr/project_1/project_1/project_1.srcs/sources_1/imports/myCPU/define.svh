//for CP0 reset
`define IcacheBlock 3'd1 //128 blocks/way
`define IcacheLen 3'd4 //32 bytes
`define IcacheWay 3'd1 //2 ways
`define DcacheBlock 3'd1 //128 blocks/way
`define DcacheLen 3'd4 //32 bytes
`define DcacheWay 3'd1 //2 ways
//for CPU use
`define IcacheIndexNum 5'd7 //log_{2}128=7
`define IcacheWayNum 3'd1 //log_{2}2=1
`define IcacheTagNum 5'd23 //32-7-2=23
`define DcacheIndexNum 5'd7 //log_{2}128=7
`define DcacheWayNum 3'd1 //log_{2}2=1
`define DcacheTagNum 5'd23 //32-7-2=23
`define IcacheIndexWayNum `IcacheIndexNum+`IcacheWayNum
`define DcacheIndexWayNum `DcacheIndexNum+`DcacheWayNum

`define TLB_NUM 8
`define TLB_INDEX 3