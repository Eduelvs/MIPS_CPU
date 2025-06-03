`timescale 1ns/100ps
module ADDRDecoding_Prog_TB();
	
	reg [31:0] ADDR;
	wire CS;
	integer i;
	
	ADDRDecoding_Prog DUT(ADDR, CS);
	initial begin
		for(i = 32'h06E0; i <= 32'h0AFF; i = i + 1)
			#20 ADDR = i;		
	
		$stop;
	end
	
endmodule 