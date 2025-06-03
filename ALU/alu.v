module alu(
	input [31:0] a, b,
	input [1:0] op,
	output reg [31:0] out
);

always @ (a, b, op) begin
	case (op) 
		0: out = a + b;
		1: out = a - b;
		2: out = a & b;
		3: out = a | b;
		default: out = 32'hXXXX;
	endcase
end

endmodule

