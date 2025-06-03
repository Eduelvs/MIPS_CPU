`timescale 1ns/100ps
module multiplicador_TB();
	reg 	St, Clk, Rst;
	reg [15:0] Multiplicando;
	reg [15:0] Multiplicador;
	wire 	[31:0] Produto;

	multiplicador DUT(
		.Produto(Produto),  
		.Multiplicando(Multiplicando), 
		.Multiplicador(Multiplicador), 
		.St(St), 
		.Clk(Clk),
		.Reset(Rst)
	);

	
	initial begin
		Clk = 0;
		St = 0;
		Rst = 0;
		Multiplicando = 0;
		Multiplicador = 0;
		
		#40 St = 1;
		Multiplicando = 2000;
		Multiplicador = 2000;
		#40 St = 0;
			
	end
	
	always #20 Clk = ~Clk;
	
	initial #1390 $stop;

endmodule
