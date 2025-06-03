`timescale 1ns/100ps
module registerfile_TB();

reg clk;
reg rst;
reg write_back_en;
reg [4:0] write_back_reg; 
reg [31:0] write_back;
reg [4:0] a_reg, b_reg;
wire [31:0] a, b;

integer k=0;

registerfile DUT(clk, rst, write_back_en, write_back_reg, write_back, a_reg, b_reg, a, b);

initial begin
	clk = 1;
	rst = 1;
	write_back_en = 0;
	write_back_reg = 0;
	write_back = 0;
	a_reg = 0;
	b_reg = 0;

	#10
	
	// Lendo

	rst = 0;
	write_back_en = 0;
	
	for (k=0; k < 9; k = k + 1) begin
		#20
		a_reg = a_reg + 1;
		b_reg = b_reg + 1;
		
	end
	
	// Escrevendo

	write_back_en = 1;
	
	for (k=0; k < 9; k = k + 1) begin
		#20
		write_back_reg = write_back_reg + 1;
		write_back = write_back + 1;
	end
	
	// Lendo

	write_back_en = 0;
	
	for (k=0; k < 9; k = k + 1) begin
		#20
		a_reg = a_reg + 1;
		b_reg = b_reg + 1;
	end

	#20 $stop();
end

always #10 clk = ~clk;

endmodule

