module Adder_TB ();
reg [15:0] OperandoA, OperandoB;
wire [16:0] Soma;

Adder DUT ( 
.OperandoA(OperandoA),
.OperandoB(OperandoB),
.Soma(Soma));

initial begin
	OperandoA = 65535;
	OperandoB = 65535;
	#30 $stop;
end

endmodule
