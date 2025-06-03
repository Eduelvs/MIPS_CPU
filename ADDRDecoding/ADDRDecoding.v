module ADDRDecoding(
	input [31:0] ADDR,
	// 0 = memoria interna, 1 = memoria externa
	output reg CS
);
	
	integer inferior, superior;
	
	always @ (*)
	begin
		inferior = 32'h09F0;
		superior = 32'h0DEF;
		if(ADDR >= inferior && ADDR <= superior) CS = 0; 
		else CS = 1;	
	end 
	
endmodule 