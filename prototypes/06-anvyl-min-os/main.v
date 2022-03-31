// Import kshaa's UART-based MinOS
`include "min_os.v"

// Define a UART reader/transmitter FPGA program
module main(
	// Clock pin
	input CLK,
	
	// UART RX/TX pins
	input T19,
	output T20,
	
	// Physical GPIO: LEDs
	output LD0,
	output LD1,
	output LD2,
	output LD3,
	output LD4,
	output LD5,
	output LD6,
	output LD7
);
	// Design a counter:
	// - r_ticks is incremented on every clock cycle
	// - r_counter is incremented every time r_ticks reaches sleep_ticks
	// - r_flipper is flipped every time r_ticks reaches sleep_ticks
	// - every time r_counter is incremented, r_ticks is reset
	reg [7:0] r_counter = 0; 
	reg r_flipper = 0;
	reg r_flipper_changed = 0;
	parameter sleep_ticks = 32'd100000000;
	reg [31:0] r_ticks = 0;
	always @(posedge CLK)
	begin
		if (r_ticks < sleep_ticks) begin
			// Tick clock
			r_ticks = r_ticks + 1;
		end else if (r_ticks == sleep_ticks) begin
			// Tick clock
			r_ticks = r_ticks + 1;
			// Increment counter
			r_counter <= r_counter + 1;
			// Flip flipper
			r_flipper <= !r_flipper;
			// Trigger display re-draw
			r_flipper_changed <= 1;
		end else if (r_ticks > sleep_ticks) begin
			// Reset clock
			r_ticks = 0;
			// Stop display update
			r_flipper_changed <= 0;
		end
	end

	// Design an output byte to render to virtual and physical LEDs
	// If any switch bit is on, the switch is the output
	// If all switches are off, the counter is the output
	wire [7:0] output_byte = switches == 0 ? r_counter : switches;

	// Design a coordinate system w/ two points controlled by buttons
	reg r_indexes_changed = 0;
	reg [7:0] a_index = 9;
	parameter A_LEFT = 8;
	parameter A_RIGHT = 10;
	parameter A_UP = 1;
	parameter A_DOWN = 9;
	reg [7:0] b_index = 14;
	parameter B_LEFT = 11;
	parameter B_RIGHT = 13;
	parameter B_UP = 4;
	parameter B_DOWN = 12;
	
	always @(posedge CLK)
	begin
		if (button_pressed) begin
			if (button_index == A_LEFT && (a_index % 8) > 0) begin
				a_index <= a_index - 1;
			end else if (button_pressed && button_index == A_RIGHT && (a_index % 8) < 7) begin
				a_index <= a_index + 1;
			end else if (button_pressed && button_index == A_UP && (a_index / 8) > 0) begin
				a_index <= a_index - 8;
			end else if (button_pressed && button_index == A_DOWN && (a_index / 8) < 7) begin
				a_index <= a_index + 8;
			end else if (button_index == B_LEFT && (b_index % 8) > 0) begin
				b_index <= b_index - 1;
			end else if (button_pressed && button_index == B_RIGHT && (b_index % 8) < 7) begin
				b_index <= b_index + 1;
			end else if (button_pressed && button_index == B_UP && (b_index / 8) > 0) begin
				b_index <= b_index - 8;
			end else if (button_pressed && button_index == B_DOWN && (b_index / 8) < 7) begin
				b_index <= b_index + 8;
			end 
			// Trigger display change
			r_indexes_changed <= 1;
		end else if (display_logic_changed) begin
			// If button unpressed, remember to toggle off display changes
			r_indexes_changed <= 0;
		end
	end

	// Design a display with some flipping bits in three corners
	wire display_logic_changed = r_flipper_changed || r_indexes_changed;
	reg [511:0] r_display = 0; // 64 bytes
	integer display_iterator = 0;
	always @(posedge CLK)
	begin
		for (display_iterator = 0; display_iterator < 64; display_iterator = display_iterator + 1)
			if (display_logic_changed) begin
				if (a_index == display_iterator) begin
					r_display[display_iterator * 8 +: 8] <= 8'b00111111;
				end else if (b_index == display_iterator) begin
					r_display[display_iterator * 8 +: 8] <= 8'b00010101;
				end else if (0 == display_iterator && r_flipper) begin
					r_display[display_iterator * 8 +: 8] <= 8'b00110000;
				end else if (7 == display_iterator && r_flipper) begin
					r_display[display_iterator * 8 +: 8] <= 8'b00001100;
				end else if (56 == display_iterator && r_flipper) begin
					r_display[display_iterator * 8 +: 8] <= 8'b00000011;
				end else begin
					r_display[display_iterator * 8 +: 8] <= 8'b00000000;
				end
			end
	end

	// Instantiate kshaa's UART-based MinOS:
	// - with output_byte assigned to virtual interface "leds"
	// - with r_display bytes assigned to virtual interface "display"
	// - with switches sourced out of the virtual interface "switches"
	wire [7:0] switches;
	wire [7:0] button_index;
	wire button_pressed;

	min_os min_os_instance (
		.CLK(CLK),
		.T19(T19),
		.T20(T20),
		.leds(output_byte),
		.display(r_display),
		.switches(switches),
		.button_index(button_index),
		.button_pressed(button_pressed)
	);

	// Assign output_byte value to physical LEDs
	assign LD0 = output_byte[0];
	assign LD1 = output_byte[1];
	assign LD2 = output_byte[2];
	assign LD3 = output_byte[3];
	assign LD4 = output_byte[4];
	assign LD5 = output_byte[5];
	assign LD6 = output_byte[6];
	assign LD7 = output_byte[7];
endmodule
