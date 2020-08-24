module sramtoaxi (
	input                   clk        ,
	input                   aresetn    ,
	input        [31:0] dwdata     ,
	input        [31:0] dwaddr     ,
	input        [     3:0] dwstrb     ,
	input        [     2:0] dwsize     ,
	input                   dmemEn     ,
	input                   drwmem     ,
	input        [     2:0] drsize     ,
	input        [31:0] draddr     ,
	output logic [31:0] drdata_uncached     ,
	output logic            dwaitForMem,
	output logic [     3:0] awid       ,
	output logic [    31:0] awaddr     ,
	output logic [     3:0] awlen      ,
	output logic [     2:0] awsize     ,
	output logic [     1:0] awburst    ,
	output logic [     1:0] awlock     ,
	output logic [     3:0] awcache    ,
	output logic [     2:0] awprot     ,
	output logic            awvalid    ,
	input                   awready    ,
	output logic [     3:0] wid        ,
	output logic [31:0] wdata      ,
	output logic [     3:0] wstrb      ,
	output logic            wlast      ,
	output logic            wvalid     ,
	input                   wready     ,
	input        [     3:0] bid        ,
	input        [     1:0] bresp      ,
	input                   bvalid     ,
	output logic            bready     ,
	output logic [     3:0] arid       ,
	output logic [    31:0] araddr     ,
	output logic [     3:0] arlen      ,
	output logic [     2:0] arsize     ,
	output logic [     1:0] arburst    ,
	output logic [     1:0] arlock     ,
	output logic [     3:0] arcache    ,
	output logic [     2:0] arprot     ,
	output logic            arvalid    ,
	input                   arready    ,
	input        [     3:0] rid        ,
	input        [    31:0] rdata      ,
	input        [     1:0] rresp      ,
	input                   rlast      ,
	input                   rvalid     ,
	output logic            rready     
);


logic fifo_ready;
logic in_fifo;

write_fifo fifo0
    ( .clock(clk), .resetn(aresetn), .en(dmemEn & (~drwmem))
    , .addr_i(dwaddr)
    , .wsize_i(dwsize)
    , .wdata_i(dwdata)
    , .wstrb_i(dwstrb)
    , .query_addr_i(draddr)
    , .fifo_ready_o(fifo_ready)
    , .in_fifo_o(in_fifo)

    , .axi_awid(awid)
    , .axi_wid(wid)
    , .axi_awaddr(awaddr)
    , .axi_awlen(awlen)
    , .axi_awsize(awsize)
    , .axi_awburst(awburst)
    , .axi_awlock(awlock)
    , .axi_awcache(awcache)
    , .axi_awprot(awprot)
    // , .axi_awqos(awqos)
    , .axi_awvalid(awvalid)
    , .axi_awready(awready)
    , .axi_wdata(wdata)
    , .axi_wstrb(wstrb)
    , .axi_wlast(wlast)
    , .axi_wvalid(wvalid)
    , .axi_wready(wready)
    , .axi_bid(bid)
    , .axi_bresp(bresp)
    , .axi_bvalid(bvalid)
    , .axi_bready(bready)
    );

	// assign awid=4'b1;
	// assign wid=4'b1;
	assign arcache=4'hf;
	// assign awcache=4'hf;
	assign arlock=1'b0;
	// assign awlock=1'b0;
	assign arprot=3'b0;
	// assign awprot=3'b0;
	// assign bready=1'b1;
	assign arid=4'b1;// inst and data is temperorily the same id here.
	// assign awburst=2'b0;
	// assign awlen=4'b0;
	logic [ 1:0] nextstate;

	logic wstall;
	logic drstall;
	logic irstall;

	logic [1:0]               writestate                ;
	logic [         1:0] readstate                 ;
	logic  [1:0]              nextwritestate            ;
	logic [         2:0] nextreadstate             ;
	parameter            finishWData           = 2'd1;
	parameter            readidle            = 2'd0;
	parameter            recvDate            = 2'd1;
	parameter dwaitForHand=2'd2;
	
	logic [31:0] drdata;

assign dwaitForMem=wstall|drstall;

	always_comb begin
        if (dmemEn&(~drwmem)) begin
            wstall = !fifo_ready;
        end else begin
            wstall = 0;
        end
	end

always_comb begin
	arvalid       = 1'b0;
	rready        = 1'b1;
	arsize        = 3'b0;
	arlen         = 4'b0;
	arburst       = 1'b0;
	araddr        = 32'b0;
	drstall       = 1'b0;
	irstall       = 1'b0;
	nextreadstate = readidle;
	drdata        = 32'b0;
	case(readstate)
		readidle : begin
			if (dmemEn&drwmem) begin
                if (in_fifo) begin
                    nextreadstate = readidle;
                    drstall = 1;
                end else begin
                    araddr      = draddr;
                    arvalid     = 1'b1;
                    rready      = 1'b1;
                    arsize      = drsize;
                    arlen       = 1'b0;
                    arburst     = 1'b0;
                    drdata      = 32'b0;
                    if(arready) nextreadstate=recvDate;else nextreadstate=dwaitForHand;
                    drstall     = 1'b1;
                    irstall     = 1'b0;
                end
			end
		end
		recvDate : begin
			arvalid = 1'b0;
			rready  = 1'b1;
			arsize  = 3'b0;
			arlen   = 4'b0;
			arburst = 2'b0;
			if (rvalid) begin
				drdata        = rdata;
				nextreadstate = readidle;
				drstall       = 0;
			end else begin
				drdata        = 32'b0;
				nextreadstate = recvDate;
				drstall       = 1;
			end
			araddr  = 32'b0;
		end
		dwaitForHand : begin
				araddr      = draddr;
				arvalid     = 1'b1;
				rready      = 1'b1;
				arsize      = drsize;
				arlen       = 1'b0;
				arburst     = 1'b0;
				drdata      = 32'b0;
				if(arready) nextreadstate=recvDate;else nextreadstate=dwaitForHand;
				drstall     = 1'b1;
				irstall     = 1'b0;
			end
	endcase
end

always_ff @(posedge clk) begin
	if (~aresetn) begin
		readstate<=readidle;
	end else begin
		readstate<=nextreadstate;
	end
end

always_ff @(posedge clk) begin : proc_inst_uncached
	if(~aresetn) begin
		drdata_uncached<=32'b0;
	end else begin
		drdata_uncached<=drdata;
	end
end

endmodule
