`timescale 1ns/100ps

module ACC_TB();
reg Load, Sh, Ad, Clk;
reg [32:0] Entradas;
wire[32:0] Saidas;

ACC DUT(
	.Clk(Clk),
	.Load(Load),
	.Sh(Sh),
	.Ad(Ad),
	.Entradas(Entradas),
	.Saidas(Saidas)
);


    initial Clk = 0;
    always #20 Clk = ~Clk;

    initial begin
        
        Load = 0;
        Sh = 0;
        Ad = 0;
        Entradas = 9'b0;

        // Teste 1: Load
        #40 Load = 1;
        Entradas = 9'b000000101; // Carrega valor 5 nos bits inferiores
        #40 Load = 0;

        // Verifica o valor de Saidas após carregar
        #40;

        // Teste 2: Shift
        #40 Sh = 1;
        #40 Sh = 0;

        // Verifica o valor de Saidas após o deslocamento
        #40;

        // Teste 3: Ad
        #40 Ad = 1;
        Entradas = 9'b101000000; // Adiciona valor 101000 nos bits superiores
        #40 Ad = 0;

        // Verifica o valor de Saidas após a adição
        #40;

        #200 $stop;
    end
endmodule

