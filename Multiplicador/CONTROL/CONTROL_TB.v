`timescale 1ns/100ps
module CONTROL_TB();
reg 	Clk, K, St, M;
wire  Idle, Done, Load, Sh, Ad;
reg   [3:0] state;

CONTROL DUT(
	.Clk(Clk),
	.K(K),
	.St(St),
	.M(M),
	.Idle(Idle),
	.Done(Done),
	.Load(Load),
	.Sh(Sh),
	.Ad(Ad)
);

initial begin
	Clk = 0;
end

initial #600 $stop;

always #25 Clk = ~Clk;

always @(negedge Clk) begin 
	{K, St, M} = $random;
end

initial $init_signal_spy("DUT/CONTROL/state", "state", 1);
endmodule
