`timescale 1ns/100ps

module mux_TB();

	reg [31:0] a, b;
	reg sel;
	wire [31:0] out;
	
	mux DUT (a, b, sel, out);
	
	initial begin
		a = 0;
		b = 1;
		
		#20 sel = 1;
		
		#20 sel = 0;
		
		#20 $stop;
	end

endmodule 