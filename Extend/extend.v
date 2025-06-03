module extend(
	input [31:0] instr,
	output [31:0] imm
);

// Extensão de sinal
assign imm = { { 16{ instr[15] } }, instr[15:0] };

endmodule

