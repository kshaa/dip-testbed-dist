module v_display #(
	parameter [7:0] INTERFACE_TX_CHUNK_TYPE = 6,
	// The size of the display in bytes
	parameter DISPLAY_BUFFER_BYTE_SIZE = 64,
	// How many bits needed to index the whole buffer
	parameter DISPLAY_BUFFER_INDEX_SIZE = 8
)(
	// clock pin
	input CLK,

	// active display state
	input [(DISPLAY_BUFFER_BYTE_SIZE * 8) - 1:0] display,
	// signal to inform the user of this module that leds
	// have changed their value and should be updated i.e. sent out over UART 
	output should_update,
	// the value that the leds have been updated to
	output [7:0] tx_chunk_type,
	output [15:0] tx_chunk_bytes,
	// signal to tell this module "the leds have been updated, chill out"
	input reset
);
	// What's the last updated value of LEDs
	reg [7:0] r_last_leds = 0;
	reg [(DISPLAY_BUFFER_BYTE_SIZE * 8) - 1:0] r_old_display = 0;
	reg [(DISPLAY_BUFFER_BYTE_SIZE * 8) - 1:0] r_new_display = 0;
	reg [(DISPLAY_BUFFER_BYTE_SIZE * 8) - 1:0] r_display = 0;
	// Active updated pixel index and chunk contents
	reg [DISPLAY_BUFFER_INDEX_SIZE - 1:0] r_update_index = 0;
	reg [15:0] r_update_value = 0;
	// The TX chunk type
	reg [7:0] r_tx_chunk_type = INTERFACE_TX_CHUNK_TYPE;

	// An FSM to receive leds and send them out over UART when they're changed
	parameter R_VDISPLAY_STATE_SIZE = 3;
	parameter R_VDISPLAY_IDLE = 0;
	parameter R_VDISPLAY_SHOULD_PREPARE_UPDATE = 1;
	parameter R_VDISPLAY_SHOULD_UPDATE = 2;
	parameter R_VDISPLAY_FINISH = 3;
	reg [R_VDISPLAY_STATE_SIZE - 1:0] r_vdisplay_state = R_VDISPLAY_IDLE;
 
 	integer buffer_iterator = 0;
	always @(posedge CLK)
	begin
		case (r_vdisplay_state)
			R_VDISPLAY_IDLE: begin
				if (display != r_display) begin
					r_old_display <= r_display;
					r_new_display <= display;
					r_update_index <= 0;
					r_vdisplay_state <= R_VDISPLAY_SHOULD_PREPARE_UPDATE;
				end
			end
			R_VDISPLAY_SHOULD_PREPARE_UPDATE: begin
				for (buffer_iterator = 0; buffer_iterator < DISPLAY_BUFFER_BYTE_SIZE; buffer_iterator = buffer_iterator + 1)
					if (r_update_index == buffer_iterator) begin
						r_update_value[7:0] <= r_update_index;
						r_update_value[15:8] <= r_new_display[buffer_iterator * 8 +: 8];
					end
				r_vdisplay_state <= R_VDISPLAY_SHOULD_UPDATE;
			end
			R_VDISPLAY_SHOULD_UPDATE: begin
				if (reset) begin
					if (r_update_index <= (DISPLAY_BUFFER_BYTE_SIZE - 1)) begin
						r_update_index <= r_update_index + 1;
						r_vdisplay_state <= R_VDISPLAY_SHOULD_PREPARE_UPDATE;
					end else begin
						r_vdisplay_state <= R_VDISPLAY_FINISH;
					end
				end
			end
			R_VDISPLAY_FINISH: begin
				r_display <= r_new_display;
				r_vdisplay_state <= R_VDISPLAY_IDLE;
			end
		endcase
	end

	// Outputs
	assign should_update = r_vdisplay_state == R_VDISPLAY_SHOULD_UPDATE;
	assign tx_chunk_type = r_tx_chunk_type;
	assign tx_chunk_bytes = r_update_value;
endmodule
