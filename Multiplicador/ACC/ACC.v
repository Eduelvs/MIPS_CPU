module ACC (
	output reg [32:0] Saidas,
	input [16:0] Soma,
	input [15:0] Multiplicador,
	input [15:0] Multiplicando,
	input Load, Sh, Ad, Clk, Reset
);

always @ (posedge Clk or posedge Reset) begin
	if (Reset) Saidas = 0;
	else if (Load) begin
		Saidas = { Multiplicador[0] ? Multiplicando : 0, Multiplicador };
	end
	else if (Sh) Saidas = { 1'b0, Saidas[32:1]};
	else if (Ad) Saidas[32:16] = Soma;
end

endmodule
