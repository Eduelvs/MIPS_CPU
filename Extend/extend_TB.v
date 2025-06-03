`timescale 1ns/100ps
module extend_TB();

reg [31:0] instr;
wire [31:0] imm;

extend DUT(instr, imm);

initial begin
	instr <= 16'h1234;
	#50 instr <= 32'hffff1111;
	#50 instr <= 32'h00008888;
	#50 instr <= 32'ha0a0a0a0;
	
	#50 $stop;
end

endmodule
