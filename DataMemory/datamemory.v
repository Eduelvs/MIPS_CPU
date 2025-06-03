module datamemory //405.186 MHz
#(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 10)
(
	input [(DATA_WIDTH-1):0] data_in,
	input [(ADDR_WIDTH-1):0] ADDR,
	// 0 write, 1 read
	input WR_RD, clk, rst,
	output [(DATA_WIDTH-1):0] data_out
);

reg [DATA_WIDTH-1:0] mem[2**ADDR_WIDTH-1:0];
reg [ADDR_WIDTH-1:0] ADDR_Reg;
integer i;

initial begin
	for (i = 0; i < 2**ADDR_WIDTH - 1; i = i + 1) begin
		mem[i] = 0;
	end
	mem[0] = 2001;
	mem[1] = 4001;
	mem[2] = 5001;
	mem[3] = 3001;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ADDR_Reg <= 0;  // Inicializa o endereço durante o reset
    end else begin
        if (WR_RD == 0) begin
            // Somente escreve na memória quando WR_RD é 0 (escrita)
            mem[ADDR_Reg] <= data_in;
        end
        // Atualiza o endereço conforme necessário (aqui está apenas um exemplo)
        ADDR_Reg <= ADDR + 10'h210;
    end
end

assign data_out = mem[ADDR_Reg];

endmodule

