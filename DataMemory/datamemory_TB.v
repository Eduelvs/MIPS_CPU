`timescale 1ns/100ps
module datamemory_TB();
reg [31:0] data_in;
reg [9:0] ADDR;
reg WR_RD;
reg clk;
reg rst;
wire [31:0] data_out;

integer i = 0;

datamemory DUT(data_in, ADDR, WR_RD, clk, rst, data_out);

initial begin
	rst = 1;
	clk = 0;
	WR_RD = 1;	
	ADDR = 0;
	data_in = 0;


	#40
	rst = 0;
	
	// Lendo
	WR_RD = 1;
	ADDR = 0;
	
	for (i=0; i < 10; i = i + 1) begin
		#40 ADDR = ADDR + 1;
	end
	
	// Escrevendo
	WR_RD = 0;
	ADDR = 0;
	data_in = 0;
	
	for (i=0; i < 10; i = i + 1) begin
		#40
		ADDR = ADDR + 1;
		data_in = data_in + 1;
	end
	
	// Lendo
	WR_RD = 1;
	ADDR = 0;

	for (i=0; i < 10; i = i + 1) begin
		#40 ADDR = ADDR + 1;	
	end
	
	#40 $stop;
end

// f = 50 MHz => Tc = 20
always #20 clk = ~clk;

endmodule



