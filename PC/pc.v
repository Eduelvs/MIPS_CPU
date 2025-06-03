module pc(
	input clk, rst,
	output reg [31:0] pc
);

always @(posedge clk or posedge rst) begin
	if (rst) 
		pc = 32'h06F0;
	else 
		pc = pc + 1;
end

endmodule