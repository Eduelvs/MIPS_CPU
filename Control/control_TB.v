`timescale 1ns/100ps
module control_TB();

	reg  [31:0] instr;
	wire [4:0] a_reg;
	wire [4:0] b_reg;
	wire [11:0] ctrl;
	
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

	//Endereco das variaveis
	parameter addr_a = 16'h09F0;
	parameter addr_b = 16'h09F1;
	parameter addr_c = 16'h09F2;
	parameter addr_d = 16'h09F3;

	//Ultimo endereco de memoria
	parameter ultimo_end = 16'h0DEF;
	
	control DUT (instr, a_reg, b_reg, ctrl);
	
	initial begin
		instr  = {ng1,r8,r0,addr_a};      //(LW)
		#20
		instr  = {ng,r1,r0,r4,5'd10,sub}; //(SUB)
		#20
		instr  = {ng,r4,r5,r6,5'd10,mul}; //(MUL)
		#20
		instr  = {ng2,r8,r6,ultimo_end};  //(SW)
		#40
		$stop;
	end
	
endmodule
