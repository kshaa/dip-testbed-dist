`timescale 1ns / 10ps

`include "uart_tx.v"
`include "button_led_virtual_interface.v"

module button_led_virtual_interface_tb;

	// Testbench configured for a 10 MHz clock (based on timescale & clock sleep period)
	// Both RX and TX is simulated using 115200 baud UART
	// 10000000 / 115200 = 87 Clocks Per Bit.
	parameter SEND_ON_CHANGE  = 1'b0;
	parameter CLOCK_PERIOD_NS = 100;
	parameter CLKS_PER_BIT    = 87;
	parameter BIT_PERIOD      = 8600;
	parameter CLKS_PER_SYNC   = 1000;

	// Clock 
	reg CLK = 0;

	// UUT Inputs
	reg T19 = 0;
	reg [7:0] leds = 0;

	// UUT Outputs
	wire T20;
	wire [23:0] buttons
 
	// Task that takes byte as input and sends it over UART
	task uart_write_byte;
		input [7:0] i_Data;
		integer ii;
		begin
		
		// Send Start Bit
		T19 <= 1'b0;
		#(BIT_PERIOD);
		#1000;
		
		// Send Data Byte
		for (ii=0; ii<8; ii=ii+1)
			begin
			T19 <= i_Data[ii];
			#(BIT_PERIOD);
			end
		
		// Send Stop Bit
		T19 <= 1'b1;
		#(BIT_PERIOD);
		end
	endtask

	// Instantiate the Unit Under Test (UUT)
	button_led_virtual_interface #(
		.SEND_ON_CHANGE(SEND_ON_CHANGE),
		.CLKS_PER_BIT(CLKS_PER_BIT),
		.CLKS_PER_SYNC(CLKS_PER_SYNC)
	) uut (
		.CLK(CLK), 
		.T19(T19), 
		.T20(T20), 
		.leds(leds), 
		.buttons(buttons)
	);

	// Keep generating a clock signal
  	always #(CLOCK_PERIOD_NS/2) CLK <= !CLK;
 
	// UUT test simulation
	initial begin
		// Configure file output
		$dumpfile("button_led_virtual_interface_tb.vcd");
    	$dumpvars(0, button_led_virtual_interface_tb);

		// Send a command to the UART virtual interface
		@(posedge CLK);
		uart_write_byte(8'b00000000);
		
		// Check UUT output
		if (buttons == 24'b00000000000000000000001)
			$display("[%t] Test success - correct button received", $realtime);
		else
			$display("[%t] Test failure - incorrect button Received", $realtime);

		// Send a command to the UART virtual interface
		@(posedge CLK);
		uart_write_byte(8'b00000001);
		
		// Check UUT output
		if (buttons == 24'b00000000000000000000010)
			$display("[%t] Test success - correct button received", $realtime);
		else
			$display("[%t] Test failure - incorrect button Received", $realtime);

		// Send a command to the UART virtual interface
		@(posedge CLK);
		uart_write_byte(8'b00000010);
		
		// Check UUT output
		if (buttons == 24'b000000000000000000000100)
			$display("[%t] Test success - correct button received", $realtime);
		else
			$display("[%t] Test failure - incorrect button Received", $realtime);

		// End test
		#100;
		$finish;
	end

endmodule
