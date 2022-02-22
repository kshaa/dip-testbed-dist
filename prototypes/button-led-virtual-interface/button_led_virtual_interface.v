// Import NANDLAND's UART Verilog
`include "uart_rx.v"
`include "uart_tx.v"

// Define a UART reader/transmitter FPGA program
module button_led_virtual_interface #(
	// Send state over serial only on changes
	parameter SEND_ON_CHANGE = 1'b0,
	// How many clock ticks for receiving a bit
	// (see `uart_rx.v` or `uart_tx.v` for more comments)
	parameter CLKS_PER_BIT = 870,
	// How many clock ticks until state is checked and possibly transmitted/synchronized
	parameter CLKS_PER_SYNC = 32'd1666666
)(
	// Clock pin
	input CLK,
	
	// UART RX/TX pins
	input T19,
	output T20,

	// LED interface
	input [7:0] leds,

	// Button interface
	output [23:0] buttons
);
	// Instantiate NANDLAND's UART RX instance
	wire rx_is_done;
	wire [7:0] rx_data;
	uart_rx #(
		.CLKS_PER_BIT(CLKS_PER_BIT)
	) uart_rx_instance (
		.i_Clock(CLK),
		.i_Rx_Serial(T19),
		.o_Rx_DV(rx_is_done),
		.o_Rx_Byte(rx_data)
	);

	// Assign received data to buttons
	assign buttons[0] = rx_is_done == 1 && rx_data == 0;
	assign buttons[1] = rx_is_done == 1 && rx_data == 1;
	assign buttons[2] = rx_is_done == 1 && rx_data == 2;
	assign buttons[3] = rx_is_done == 1 && rx_data == 3;
	assign buttons[4] = rx_is_done == 1 && rx_data == 4;
	assign buttons[5] = rx_is_done == 1 && rx_data == 5;
	assign buttons[6] = rx_is_done == 1 && rx_data == 6;
	assign buttons[7] = rx_is_done == 1 && rx_data == 7;
	assign buttons[8] = rx_is_done == 1 && rx_data == 8;
	assign buttons[9] = rx_is_done == 1 && rx_data == 9;
	assign buttons[10] = rx_is_done == 1 && rx_data == 10;
	assign buttons[11] = rx_is_done == 1 && rx_data == 11;
	assign buttons[12] = rx_is_done == 1 && rx_data == 12;
	assign buttons[13] = rx_is_done == 1 && rx_data == 13;
	assign buttons[14] = rx_is_done == 1 && rx_data == 14;
	assign buttons[15] = rx_is_done == 1 && rx_data == 15;
	assign buttons[16] = rx_is_done == 1 && rx_data == 16;
	assign buttons[17] = rx_is_done == 1 && rx_data == 17;
	assign buttons[18] = rx_is_done == 1 && rx_data == 18;
	assign buttons[19] = rx_is_done == 1 && rx_data == 19;
	assign buttons[20] = rx_is_done == 1 && rx_data == 20;
	assign buttons[21] = rx_is_done == 1 && rx_data == 21;
	assign buttons[22] = rx_is_done == 1 && rx_data == 22;
	assign buttons[23] = rx_is_done == 1 && rx_data == 23;
	
	// Instantiate NANDLAND's UART TX instance
	reg [7:0] r_old_led_state = 0;
	reg r_just_started = 1;
	reg r_tx_enable = 0;
	uart_tx #(
		.CLKS_PER_BIT(CLKS_PER_BIT)
	) uart_tx_instance (
		.i_Clock(CLK),
		.i_Tx_DV(r_tx_enable),
		.i_Tx_Byte(leds),
		.o_Tx_Active(),
		.o_Tx_Serial(T20)
	);

	// Clock tick counter for state synchronization timing
	reg [31:0] r_ticks = 0;

	// Regularly (every CLKS_PER_SYNC) check LED state and transmit on changes 
	always @(posedge CLK)
	begin
		// Keep ticking clock until next sync
		if (r_ticks < CLKS_PER_SYNC) begin
			r_ticks = r_ticks + 1;
		end
		// When sleep counter reached, execute sync
		else if (r_ticks == CLKS_PER_SYNC) begin
			// Execute sync only when first started and when bits changed
			if ((SEND_ON_CHANGE == 1'b0) || ((leds != r_old_led_state) || r_just_started == 1)) begin
				r_old_led_state = leds;
				r_just_started = 0;
				r_tx_enable = 1;
			end
			// Keep ticking
			r_ticks = r_ticks + 1;
		end else begin
			// After sync, update outputs, stop transmisison & reset clock
			r_tx_enable = 0;
			r_ticks = 0;
		end
	end
endmodule
