module control(
	input [31:0] instr,
	output reg [4:0] a_reg, b_reg,
	output [11:0] ctrl
);

reg c_sel; 
reg d_sel;
reg [1:0] op_sel; 
reg rd_wr;
reg wb_sel;
reg write_back_en; 
reg [4:0] write_back_reg; 
assign ctrl = { c_sel, d_sel, op_sel, rd_wr, wb_sel, write_back_en, write_back_reg };
integer grupo = 3;

always @(instr[31:26], instr[25:21], instr[20:16], instr[15:11], instr[10:6], instr[5:0]) begin

	// Default
	a_reg = 0;
	b_reg = 0;
	c_sel = 1;
	d_sel = 1;
	op_sel = 3;
	rd_wr = 0;
	wb_sel = 0;
	write_back_en = 0;
	write_back_reg = 0;

	case (instr[31:26]) 
		// Formato R
		grupo: begin
			if (instr[10:6] == 10) begin
				a_reg = instr[25:21];
				b_reg = instr[20:16];
				c_sel = 0;
				rd_wr = 0;
				wb_sel = 0;
				write_back_en = 1;
				write_back_reg = instr[15:11];

				case (instr[5:0])
					// ADD
					32: begin
						d_sel = 1;
						op_sel = 0;
					end
					// SUB
					34: begin
						d_sel = 1;
						op_sel = 1;
					end
					// AND
					36: begin
						d_sel = 1;
						op_sel = 2;
					end
					// OR
					37: begin
						d_sel = 1;
						op_sel = 3;
					end
					// MULT
					50: begin
						d_sel = 0;
						op_sel = 0;
					end
					default: ;
				endcase
			end
		end
		// Formato I
		// LW
		(grupo+1): begin
			a_reg = instr[25:21];
			b_reg = 0;
			c_sel = 1;
			op_sel = 0;
			d_sel = 1;
			rd_wr = 0;
			wb_sel = 1;
			write_back_en = 1;
			write_back_reg = instr[20:16];
		end
		// SW
		(grupo+2): begin
			a_reg = instr[25:21];
			b_reg = instr[20:16];
			c_sel = 1;
			op_sel = 0;
			d_sel = 1;
			rd_wr = 1;
			wb_sel = 1;
			write_back_en = 0;
			write_back_reg = 0;
		end
		default: ;
	endcase
end


endmodule

