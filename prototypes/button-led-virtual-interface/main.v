`include "button_led_virtual_interface.v"
`include "bit_shift_controller.v"

// Define a UART reader/transmitter FPGA program
module main #(
	parameter SEND_ON_CHANGE = 1'b0,
	parameter CLKS_PER_BIT = 870,
	parameter CLKS_PER_SYNC = 32'd1666666,
	parameter SHIFTED_START_BITS = 8'b01010000
)(
	// Clock pin
	input CLK,
	
	// UART RX/TX pins
	input T19,
	output T20,

	// Physical GPIO LEDs for debugging
	output LD0,
	output LD1,
	output LD2,
	output LD3,
	output LD4,
	output LD5,
	output LD6,
	output LD7
);
	// Add wires for virtual interface
	wire [7:0] leds;
	wire [23:0] buttons;

	// Instantiate virtual interfaces
	button_led_virtual_interface #(
		.SEND_ON_CHANGE(SEND_ON_CHANGE),
		.CLKS_PER_BIT(CLKS_PER_BIT),
		.CLKS_PER_SYNC(CLKS_PER_SYNC)
	) button_led_virtual_interface_instance (
		.CLK(CLK),
		.T19(T19),
		.T20(T20),
		.leds(leds),
		.buttons(buttons)
	);

	// Example usage of virtual interfaces
	// Instantiate bit shift controller (changes LED state based on button input)
	bit_shift_controller #(
		.START_BITS(SHIFTED_START_BITS)
	) bit_shift_controller_instance (
		.buttons(buttons),
		.bits(leds)
	);

	// Print out state on physical LEDs for debugging
	assign LD0 = leds[0];
	assign LD1 = leds[1];
	assign LD2 = leds[2];
	assign LD3 = leds[3];
	assign LD4 = leds[4];
	assign LD5 = leds[5];
	assign LD6 = leds[6];
	assign LD7 = leds[7];
endmodule
