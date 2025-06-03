module CONTROL(
	output reg Load, Sh, Ad,
	input Clk, K, M, St, Reset
);

// Declare states
parameter S0 = 0, S1 = 1, Done = 2;

// Declare state register
reg	[1:0] state;

// Determine the next state synchronously, based on the
// current state and the input
always @ (posedge Clk or posedge Reset) begin
	if (Reset) state = Done;
	else case (state)
		S0: begin
			if (K) state <= Done;
			else state <= S1;
		end
		S1: state <= S0;
		Done: begin
			if(St) state <= S1;
			else state <= Done;
		end
	endcase
end

// Determine the output based only on the current state
// and the input (do not wait for a clock edge).
always @ (state, Clk, K, M, Reset, St)
begin
		Load = 0;
		Sh = 0;
		Ad = 0;
		case (state)
			S0: if (!K && M) Ad = 1;
			S1: Sh = 1;
			Done: Load = 1;
		endcase
end

endmodule
