`timescale 1ns / 1ps

module delay #(
	parameter CLKS_DELAY = 5
)(
	input CLK,
	input source_signal,
	output reg delay_signal = 0
);
	reg [31:0] r_ticks = 0;
	wire sensitivity = CLK || source_signal;

	always @(posedge sensitivity)
	begin
		// Start delay ticker if source_signal received
		if (r_ticks == 0 && source_signal) begin
			r_ticks = r_ticks + 1;
		// Keep ticking until delay reached
		end else if (r_ticks != 0 && r_ticks < CLKS_DELAY) begin
			r_ticks = r_ticks + 1;
		// When delay reached, bring delay signal high
		end else if (r_ticks == CLKS_DELAY) begin
			r_ticks = r_ticks + 1;
			delay_signal = 1;
		// After one clock cycle, bring delay signal low and restart
		end else if (r_ticks > CLKS_DELAY) begin
			r_ticks = 0;
			delay_signal = 0;
		end
	end

endmodule
