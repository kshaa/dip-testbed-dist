`timescale 1ns / 10ps

`include "main.v"

module main_tb;

	// Testbench configured for a 10 MHz clock (based on timescale & clock sleep period)
	// Both RX and TX is simulated using 115200 baud UART
	// 10000000 / 115200 = 87 Clocks Per Bit.
	parameter CLOCK_PERIOD_NS = 10;
	parameter CLKS_PER_BIT    = 870;
	parameter BIT_PERIOD      = 8600;
	parameter CLKS_PER_SYNC   = 1000;
	parameter SHIFTED_START_BITS = 8'b01010000;

	// Clock 
	reg CLK = 0;

	// UUT Inputs
	reg T19 = 0;

	// UUT Outputs
	wire T20;
 
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
	main #(
		.CLKS_PER_BIT(CLKS_PER_BIT),
		.CLKS_PER_SYNC(CLKS_PER_SYNC),
		.SHIFTED_START_BITS(SHIFTED_START_BITS)
	) uut(
		.CLK(CLK),
		.T19(T19),
		.T20(T20)
	);

	// Keep generating a clock signal
  	always #(CLOCK_PERIOD_NS/2) CLK <= !CLK;
 
	// UUT test simulation
	initial begin
		// Configure file output
		$dumpfile("main_tb.vcd");
    	$dumpvars(0, main_tb);

		// Send a command "move right"
		@(posedge CLK);
		uart_write_byte(8'b00000001);
		@(posedge CLK);

		// Send a command "move left"
		@(posedge CLK);
		uart_write_byte(8'b00000000);
		@(posedge CLK);

		// Send a command "move right"
		@(posedge CLK);
		uart_write_byte(8'b00000001);
		@(posedge CLK);


		// Send a command "move left"
		@(posedge CLK);
		uart_write_byte(8'b00000000);
		@(posedge CLK);

		// End test
		#5000;
		$finish;
	end

endmodule
