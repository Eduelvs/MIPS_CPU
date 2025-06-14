module Register
#(parameter DATA_WIDTH = 32)
(
	input clk, rst,
	input [DATA_WIDTH - 1:0] d,
	output reg [DATA_WIDTH - 1:0] q
);

always @(posedge clk or posedge rst) begin
	if (rst) q = 0;
	else q = d;
end

endmodule

