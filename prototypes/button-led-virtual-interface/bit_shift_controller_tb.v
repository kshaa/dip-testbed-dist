`timescale 1ns / 10ps

`include "bit_shift_controller.v"

module bit_shift_controller_tb;
	// UUT Inputs
	reg [23:0] buttons = 0;
	
	// UUT outputs
	output [7:0] bits;

	// Instantiate the Unit Under Test (UUT)
	bit_shift_controller #(
		.START_BITS(8'b00011000)
	) uut (
		.buttons(buttons)
	);

	// UUT test simulation
	integer i;
	integer ii;
	initial begin
		// Configure file output
		$dumpfile("bit_shift_controller_tb.vcd");
    	$dumpvars(0, bit_shift_controller_tb);

		// Move completely to left
		for (i = 0; i < 10; i = i + 1) begin
			buttons = ; 
			#5;
			LEFT = 0; 
			#5;
		end

		// Check UUT output
		if (bits == 8'b00001100)
			$display("[%t] Test success - bit shifted to left", $realtime);
		else
			$display("[%t] Test failure - bit not shifted to left", $realtime);

		// Move completely to left
		for (ii = 0; ii < 10; ii = ii + 1) begin
			buttons = 24'b000000000000000000000001; 
			#5;
			buttons = 24'b000000000000000000000000; 
			#5;
		end

		// Check UUT output
		if (bits == 8'b00000011)
			$display("[%t] Test success - bit shifted to right", $realtime);
		else
			$display("[%t] Test failure - bit not shifted to right", $realtime);

		// Move completely to left
		for (i = 0; i < 10; i = i + 1) begin
			buttons = 24'b000000000000000000000010; 
			#5;
			buttons = 24'b000000000000000000000000; 
			#5;
		end

		// Check UUT output
		if (bits == 8'b11000000)
			$display("[%t] Test success - bit shifted to left", $realtime);
		else
			$display("[%t] Test failure - bit not shifted to left", $realtime);

		// End test
		#100;
		$finish;
	end

endmodule
