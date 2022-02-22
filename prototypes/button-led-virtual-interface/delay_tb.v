`timescale 1ns / 10ps

`include "delay.v"

module delay_tb;
	// UUT Inputs
	reg CLK = 0;
	reg source_signal = 0;
	
	// UUT outputs
	wire delay_signal;

	// Instantiate the Unit Under Test (UUT)
	delay #(
		.CLKS_DELAY(2)
	) uut (
		.CLK(CLK),
		.source_signal(source_signal),
		.delay_signal(delay_signal)
	);

	// UUT test simulation
	initial begin
		// Configure file output
		$dumpfile("delay_tb.vcd");
    	$dumpvars(0, delay_tb);

		// Init clock
		CLK = 0;
		source_signal = 0;
		#5;

		// Trigger signal
		CLK = 1;
		source_signal = 1;
		#5;
		CLK = 0;
		source_signal = 0;
		#5;

		// Keep clock ticking
		CLK = 1;
		#5;
		CLK = 0;
		#5;
		CLK = 1;
		#5;
		CLK = 0;
		#5;

		// Check UUT output
		if (delay_signal == 1)
			$display("[%t] Test success - delay signalled", $realtime);
		else
			$display("[%t] Test failure - delay did not signal", $realtime);

		// Keep ticking clock
		CLK = 1;
		#5;
		CLK = 0;
		#5;

		// Check UUT output
		if (delay_signal == 0)
			$display("[%t] Test success - delay finished", $realtime);
		else
			$display("[%t] Test failure - delay did not finish", $realtime);

		// Keep ticking clock
		CLK = 1;
		#5;
		CLK = 0;
		#5;

		// End test
		#100;
		$finish;
	end

endmodule
