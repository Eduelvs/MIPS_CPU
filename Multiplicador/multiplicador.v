module multiplicador ( //281.136 MHz
	output [31:0] Produto,
	input [15:0] Multiplicando, Multiplicador,
	input St,
	input Clk, Reset
);

wire[16:0] Soma;
wire[32:0] Saidas;

wire Load, Sh, Ad, K;

assign Produto = Saidas[31:0];

CONTROL control (Load, Sh, Ad, Clk, K, Produto[0], St, Reset);

Counter counter (K, Load, Clk, Reset);

Adder adder (Soma, Multiplicando, Produto[31:16]);

ACC acc (
	Saidas,
	Soma, Multiplicador, Multiplicando,
	Load, Sh, Ad, Clk, Reset
);

endmodule
