`timescale 1ns/100ps
module instructionmemory_TB();
reg [9:0] ADDR_Prog;
reg clk;
reg rst;
wire [31:0] data_out;

integer i = 0;

instructionmemory DUT(ADDR_Prog, clk, rst, data_out);

initial begin
	clk = 0;
	rst = 1;
	ADDR_Prog = 0;

	#40
	rst = 0;
	
	for (i=32'h06F0; i < 32'h06F0+30; i = i + 1) begin
		#40 ADDR_Prog = i;
	end
	
	#40 $stop;
end

always #20 clk = ~clk;

endmodule