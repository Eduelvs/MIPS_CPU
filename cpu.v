/*
Grupo 3
Eduardo A. Carvalho - 2021017750
Leonardo Monteiro Labegalini - 2021012769
Lucas Luan B. Barbosa - 2021017872

a) Qual a latência do sistema?

	Desde a leitura da instrução da memória, até o write back no Register
	File, existe uma latência de 5 clicos.

b) Qual o throughput do sistema?

	O throughput maximo do sistema (quando não há bolhas) é de 1 instrução
	por ciclo.

c) Qual a máxima frequência operacional entregue pelo Time Quest Timing
Analizer para o multiplicador e para o sistema? (Indique a FPGA utilizada)

	TODO:
	FPGA: Cyclone IV GX EP4CGX150DF31C7,
	             _______________________________________
					 |  Slow 85C  |  Slow 0C   |  Fast 0C  |
	Sistema      | 109.66 MHz | 118.67 MHz | 201.01 MHz|
	Multiplicador| 294.20 MHz | 320.82 MHz | 604.96 MHz|

d) Qual a máxima frequência de operação do sistema? (Indique a FPGA utilizada)

	Como o clock do sistema é 33 vezes menor que o multiplicador, podemos fornecer ao PLL do sistema um clock multiplicador 
	máximo, embora o Time Quest relate que a frequência máxima deve ser menor:

	FPGA: Cyclone IV GX EP4CGX150DF31C7
	Sistema
		- Slow 85C: 8.9152 MHz
		- Slow 0C: 9.7218 MHz
		- Fast 0C: 18.332 MHz

e) Com a arquitetura implementada, a expressão (A*B) – (C+D) é executada
corretamente (se executada em sequência ininterrupta)? Por quê? O que pode ser
feito para que a expressão seja calculada corretamente?

	Não, porque há uma dependência de dados entre a terceira instrução e as duas primeiras instruções, e há um atraso de 4 ciclos
	entre leituras e escritas de registradores para essas instruções. Isso pode levar a riscos de encanamento. Portanto, as instruções 
	precisam ser reordenadas (o que não é possível neste caso) ou introduzidas bolhas para garantir 4 ciclos entre uma instrução e suas 
	dependências.

f) Analisando a sua implementação de dois domínios de clock diferentes, haverá
problemas com metaestabilidade? Porquê?

	Não, poreque os clocks estão sincronizados pela PLL, e a interação dos dois
	domínios só ocorre no ponto de sincronia.

g) A aplicação de um multiplicador do tipo utilizado, no sistema MIPS sugerido,
é eficiente em termos de velocidade? Porquê?

	Não, porque a maneira como o multiplicador está integrado no sistema MIPS permite substituí-lo por um multiplicador 
	funcional, que é mais rápido em termos de velocidade pura do que o multiplicador multiciclos, que tem sobrecargas.

h) Cite modificações cabíveis na arquitetura do sistema que tornaria o sistema
mais rápido (frequência de operação maior). Para cada modificação sugerida,
qual a nova latência e throughput do sistema?

	1.Substituição do multiplicador multiciclos por um multiplicador funcional:
		- Descrição: Trocar o multiplicador multiciclos por um multiplicador funcional.
		- Impacto na Latência e Throughput:
			- Latência: A latência, em termos de ciclos, permanece a mesma, mas o tempo de clock seria reduzido.
			- Throughput: O throughput, em termos de ciclos, não muda, mas a frequência de operação aumenta, o que 
			resulta em um throughput maior em termos de instruções por segundo. 
		
	2.Operação paralela do multiplicador multiciclo ao pipeline:
		- Descrição: Aproveitar o fato de o multiplicador ser multiciclo para fazê-lo operar em paralelo ao pipeline principal.
		- Impacto na Latência e Throughput:
			- Latência: Para instruções de multiplicação, a latência seria de 37 ciclos (33 ciclos no estágio de execução e 4 
			ciclos de latência adicional).
			- Throughput: O throughput para instruções de multiplicação seria de 1 instrução a cada 35 ciclos. Para outras instruções, 
			o throughput permanece 1 instrução por ciclo, mas a frequência de operação do sistema aumentaria significativamente.
*/
module cpu (
	input CLK, RST,
	input [31:0] Prog_BUS_READ,
	input [31:0] Data_BUS_READ,
	output [31:0] ADDR, ADDR_Prog,
	output CS, CS_P, WR_RD,
	output [31:0] Data_BUS_WRITE
);
	
	(*keep=1*) wire CLK_SYS;
	(*keep=1*) wire CLK_MUL, pll_locked, RST_SYS;
	wire sync_mul1, sync_mul;
	assign RST_SYS = RST || !pll_locked; 
	
	// Primeiro Estágio
	// Instruction Fetch
	
	pll PLL(
		RST,
		CLK,
		CLK_MUL,
		CLK_SYS,
		pll_locked
	);
	
	Register #(1) SYNC_MUL1(
		CLK_SYS, RST_SYS,
		pll_locked, sync_mul1
	);
	Register #(1) SYNC_MUL(
		CLK_SYS, RST_SYS,
		sync_mul1, sync_mul
	);
	
	
	
	(*keep=1*) wire [31:0] instr;
	wire [31:0] IntstructionOut;
	
	pc PC(
		CLK_SYS, RST_SYS,
		ADDR_Prog
	);
	
	instructionmemory InstructionMemory(
		ADDR_Prog,
		CLK_SYS, RST_SYS,
		IntstructionOut
	);
	
	mux MuxMemoryProg(
		IntstructionOut, Prog_BUS_READ,
		CS_P,
		instr
	);
	
	ADDRDecoding_Prog ADDRDecodingProg(
		ADDR_Prog,
		CS_P
	);
	
	//	Segundo Estágio
	// Instruction Decode
	
	(*keep=1*) wire [31:0] writeBack;
	wire writeBack_en;
	wire [4:0] writeBack_reg;
	wire [4:0] a_reg, b_reg;
	wire [31:0] wire_a, wire_b, imm_in;
	wire [31:0] wire_a_out, wire_b_out, imm;
	wire[11:0] ctrl_in;
	(*keep=1*) wire[11:0] ctrl;
	
	registerfile RegisterFile(
		CLK_SYS, RST_SYS,
		writeBack_en, writeBack_reg, writeBack,
		a_reg, b_reg,
		wire_a, wire_b
	);
	
	control Control(
		instr,
		a_reg, b_reg, ctrl_in
	);
	
	extend Extend(
		instr,
		imm_in
	);
	
	Register A(
		CLK_SYS, RST_SYS,
		wire_a, wire_a_out
	);
	
	Register B(
		CLK_SYS, RST_SYS,
		wire_b, wire_b_out
	);
	
	Register IMM(
		CLK_SYS, RST_SYS,
		imm_in, imm
	);
	
	
	Register #(12) CTRL1(
		CLK_SYS, RST_SYS,
		ctrl_in, ctrl
	);
	
	
	// Terceiro Estágio
	// Execute
	
	wire [31:0] mul, op, c_out, d_out, d_mem, b_mem;
	wire c_sel, d_sel;
	wire [1:0] op_sel;
	wire [7:0] ctrl_mem_in;
	wire [7:0] ctrl_mem;
	assign { c_sel, d_sel, op_sel, ctrl_mem_in } = ctrl;
	
	multiplicador MULT(
		mul,
		wire_a_out[15:0], wire_b_out[15:0],
		sync_mul,
		CLK_MUL, RST_SYS
	);
	
	mux Mux_Alu_In(
		wire_b_out, imm,
		c_sel,
		c_out
	);
	
	alu ALU(
		wire_a_out, c_out,
		op_sel,
		op
	);
	
	mux Mux_Alu_Out (
		mul, op,
		d_sel,
		d_out
	);
	
	Register D(
		CLK_SYS, RST_SYS,
		d_out, d_mem
	);
	
	Register B2(
		CLK_SYS, RST_SYS,
		wire_b_out, b_mem
	);
	
	Register #(8) CTRL2(
		CLK_SYS, RST_SYS,
		ctrl_mem_in, ctrl_mem
	);
	
	// Quarto Estágio
	// Memory
	
	wire [31:0] wire_d2_out, m_wb;
	wire rd_wr;
	wire [6:0] ctrl_wb_in; wire [7:0] ctrl_wb;
	assign { rd_wr, ctrl_wb_in } = ctrl_mem;
	assign WR_RD = !rd_wr;
	assign ADDR = d_mem;
	assign Data_BUS_WRITE = b_mem;
	
	ADDRDecoding ADDRDecoding(
		ADDR,
		CS
	);
	
	datamemory DataMemory(
		Data_BUS_WRITE, { ADDR[9:0] },
		WR_RD, CLK_SYS, RST_SYS,
		m_wb
	);
	
	Register D2(
		CLK_SYS, RST_SYS,
		d_mem, wire_d2_out
	);

	Register #(8) CTRL3(
		CLK_SYS, RST_SYS,
		{ CS, ctrl_wb_in }, ctrl_wb
	);
	
	// Quinto Estágio
	// Write Back
	
	wire wb_sel, cs_wb;
	wire [31:0] wire_m_out;
	assign { cs_wb, wb_sel, writeBack_en, writeBack_reg } = ctrl_wb;
	
	mux M(
		m_wb, Data_BUS_READ,
		cs_wb,
		wire_m_out
	);
	
	mux MUX_WB(
		wire_d2_out, wire_m_out,
		wb_sel,
		writeBack
	);

endmodule
