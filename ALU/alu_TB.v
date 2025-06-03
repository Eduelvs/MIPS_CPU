`timescale 1ns/100ps
module alu_TB();

	reg  [31:0] a, b;
	reg  [1:0] op;
	wire [31:0] out;	
	
	alu DUT(a, b, op, out);
	
	initial 
	begin
		a = 100;
		b = 50;
		op = 0;

		#20 op <= 1;
		#20 op <= 2;
		#20 op <= 3;
	end
		
	initial #100 $stop;

endmodule