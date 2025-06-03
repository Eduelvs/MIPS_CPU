module instructionmemory
#(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 10)
(
	input [31:0] ADDR_Prog,
	input clk, rst,
	output reg [(DATA_WIDTH-1):0] data_out
);


// Declare the ROM variable
reg [DATA_WIDTH-1:0] mem[2**ADDR_WIDTH-1:0];

integer i;
integer offset = 32'h06F0;


	//Numeros
	parameter ng = 6'd3;  //Numero do grupo
	parameter ng1 = 6'd4; //Numero do grupo + 1
	parameter ng2 = 6'd5; //Numero do grupo + 2

	//Registros
	parameter r0 = 5'd0;
	parameter r1 = 5'd1;
	parameter r2 = 5'd2;
	parameter r3 = 5'd3;
	parameter r4 = 5'd4;
	parameter r5 = 5'd5;
	parameter r6 = 5'd6;
	parameter r7 = 5'd7;
	parameter r8 = 5'd8;

	//Operacoes
	parameter sub = 6'd34;
	parameter mul = 6'd50;
	parameter nop = 6'd1;

	//Endereco das variaveis
	parameter addr_a = 16'h09F0;
	parameter addr_b = 16'h09F1;
	parameter addr_c = 16'h09F2;
	parameter addr_d = 16'h09F3;

	//Ultimo endereco de memoria
	parameter ultimo_end = 16'h0DEF;



initial begin
	for (i = 0; i < 2**ADDR_WIDTH - 1; i = i + 1) begin
		mem[i] = 0; //Clear all istruction memory
	end
	// Pipeline Hazard
	mem[0]  = {ng1,r8,r0,addr_a};      //R0=A (LW)
	mem[1]  = {ng1,r8,r1,addr_b};      //R1=B (LW)
	mem[2]  = {ng1,r8,r2,addr_c};      //R2=C (LW)
	mem[3]  = {ng1,r8,r3,addr_d};      //R3=D (LW)
	mem[4]  = {ng,r1,r0,r4,5'd10,sub}; //R4=R1-R0 (SUB)
	mem[5]  = {ng,r2,r3,r5,5'd10,sub}; //R5=R2-R3 (SUB)
	mem[6]  = {ng,r4,r5,r6,5'd10,mul}; //R6<-R4*R5 (MUL)
	mem[7]  = {ng2,r8,r6,ultimo_end};  //DataMem[DEF] <- R6  (SW)


	// Codigo com bolhas.
	mem[8]  = {ng1,r8,r0,addr_a};       //R0=A (LW)
	mem[9]  = {ng1,r8,r1,addr_b};       //R1=B (LW)
	mem[10] = {ng1,r8,r2,addr_c};       //R2=C (LW)
	mem[11] = {ng1,r8,r3,addr_d};       //R3=D (LW)
	//NOP
	mem[13] = {ng,r1,r0,r4,5'd10,sub};  //R4=R1-R0 (SUB)
	//NOP
	mem[15] = {ng,r2,r3,r5,5'd10,sub};  //R5=R2-R3 (SUB)
	//NOP
	//NOP
	//NOP
	mem[19] = {ng,r4,r5,r6,5'd10,mul};  //R6<-R4*R5 (MUL)
	//NOP
	//NOP
	//NOP
	mem[23] = {ng2,r8,r6,ultimo_end};   //DataMem[DEF] <- R6  (SW)
	 
end

always @ (posedge clk or posedge rst) begin
	data_out <= rst ? 0 : mem[ADDR_Prog - offset];
end

endmodule
