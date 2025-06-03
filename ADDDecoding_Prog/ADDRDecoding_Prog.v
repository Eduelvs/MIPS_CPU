module ADDRDecoding_Prog(
	input [31:0] ADDR_Prog,
	output reg CS_P 
);
	integer inferior, superior;
	
	// Memoria programa de 1kB (0x400 Bytes), começando em 13d * 250h = 0x1E10
	// Memoria de programa 1E10h a 220Fh
	always @ (*)
	begin
		inferior = 32'h06F0;
		superior = 32'h0AEF;
		if(ADDR_Prog >= inferior && ADDR_Prog <= superior) CS_P = 0; 
		else CS_P = 1;	
	end 
	
endmodule