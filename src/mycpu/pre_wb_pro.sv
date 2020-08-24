module pre_wb_pro (
	input [31:0] pro_aluAns,
	input pro_rwmem,
	input [ 2:0]pro_rsize,	
	input pro_signExt,
	input [1:0] pro_left_right,	
	input cached,
	input [31:0] drdata_cached,
	input [31:0] drdata_uncached,
	input [31:0] rtReg,
	output logic [31:0] mem_wb_pro_wRegData
);

logic [31:0] memData;
logic [31:0] drdata;
assign drdata=cached?drdata_cached:drdata_uncached;
always_comb begin
	memData=32'b0;
	case(pro_rsize)
		3'b0 :begin 
			case(pro_aluAns[1:0])
				2'd0:memData=pro_signExt?{{24{drdata[7]}},drdata[7:0]}:{24'b0,drdata[7:0]};
				2'd1:memData=pro_signExt?{{24{drdata[15]}},drdata[15:8]}:{24'b0,drdata[15:8]};
				2'd2:memData=pro_signExt?{{24{drdata[23]}},drdata[23:16]}:{24'b0,drdata[23:16]};
				2'd3:memData=pro_signExt?{{24{drdata[31]}},drdata[31:24]}:{24'b0,drdata[31:24]};
			endcase
		end
		3'b01 :begin
			case(pro_aluAns[1])
				1'b1:memData=pro_signExt?{{16{drdata[31]}},drdata[31:16]}:{16'b0,drdata[31:16]};
				1'b0:memData=pro_signExt?{{16{drdata[15]}},drdata[15:0]}:{16'b0,drdata[15:0]};
			endcase // pro_aluAns[0]
		end
		3'b10:begin 
			case(pro_left_right)
				2'b1:begin 
					case(pro_aluAns[1:0])
						2'b0:memData={drdata[7:0],rtReg[23:0]};
						2'b1:memData={drdata[15:0],rtReg[15:0]};
						2'd2:memData={drdata[23:0],rtReg[7:0]};
						2'd3:memData=drdata;
					endcase
				end
				2'd2:begin 
					case (pro_aluAns[1:0])
						2'b0:memData=drdata;
						2'b1:memData={rtReg[31:24],drdata[31:8]};
						2'd2:memData={rtReg[31:16],drdata[31:16]};
						2'd3:memData={rtReg[31:8],drdata[31:24]};
					endcase
				end
				2'd0:begin 
					memData=drdata;
				end
			endcase
		end

	endcase // pro_rsize
end
assign mem_wb_pro_wRegData=pro_rwmem?memData:pro_aluAns;

endmodule