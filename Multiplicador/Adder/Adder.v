module Adder (
	output [16:0] Soma,
	input [15:0] OperandoA, OperandoB
);


assign Soma = OperandoA + OperandoB;

endmodule
