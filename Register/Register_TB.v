`timescale 1ns/100ps
module Register_TB();

reg rst, clk;
reg [31:0] D;
wire [31:0] Q;
	
integer i;
	
Register DUT(rst, clk, D, Q);
	
	
initial begin
	clk = 0;
	rst = 1;	
	#40 rst = 0;
		
	for(i = 0; i < 15; i = i + 1) 
	begin	
		#40 D = i;
	end
	
	#40 rst = 1;

	#100 $stop;
end
	
always #20 clk = ~clk;
	
endmodule