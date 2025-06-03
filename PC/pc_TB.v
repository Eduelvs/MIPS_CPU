`timescale 1ns/100ps
module pc_TB();

reg clk;
reg rst;
wire [31:0] pc;

pc DUT(clk, rst, pc);

initial begin
	clk = 0;
	rst = 1;
	
	#30 
	rst = 0;
	
	#420
	rst = 1;
	
	#100 
	$stop;
end

always #20 clk = ~clk;

endmodule
