module v_buttons #(
	// What is the chunk type
	parameter [7:0] INTERFACE_RX_CHUNK_TYPE = 3,
	// The size of the chunk in bytes (maximum chunk size essentially)
	parameter RX_CONTENT_BUFFER_BYTE_SIZE = 3,
	// How many bits needed to index the whole buffer
	parameter RX_CONTENT_BUFFER_INDEX_SIZE = 32
)(
	// clock pin
	input CLK,

	// chunked RX inputs
	input [7:0] rx_chunk_type,
	input [(RX_CONTENT_BUFFER_BYTE_SIZE * 8) - 1:0] rx_chunk_bytes,
	input [RX_CONTENT_BUFFER_INDEX_SIZE - 1:0] rx_chunk_byte_size,
	input rx_is_chunk_ready,

	// last received button signal
	output [7:0] button_index,
	output button_pressed
);
	// What's the last updated button index
	reg [7:0] r_button_index = 0;
	// The RX chunk type
	reg [7:0] r_rx_chunk_type = INTERFACE_RX_CHUNK_TYPE;

	// Copy button index when available
	parameter R_VBUTTONS_STATE_SIZE = 1;
	parameter R_VBUTTONS_IDLE = 0;
	parameter R_VBUTTONS_BUTTON_PRESSED = 1;
	reg [R_VBUTTONS_STATE_SIZE - 1:0] r_vbuttons_state = R_VBUTTONS_IDLE;

	always @(posedge CLK)
	begin
		case (r_vbuttons_state)
			R_VBUTTONS_IDLE: begin
				if (rx_is_chunk_ready && rx_chunk_type == r_rx_chunk_type && rx_chunk_byte_size == 1) begin
					r_button_index[7:0] <= rx_chunk_bytes[7:0];
					r_vbuttons_state <= R_VBUTTONS_BUTTON_PRESSED;
				end
			end
			R_VBUTTONS_BUTTON_PRESSED: begin
				r_vbuttons_state <= R_VBUTTONS_IDLE;
			end
		endcase
	end

	// Outputs
	assign button_index = r_button_index;
	assign button_pressed = r_vbuttons_state == R_VBUTTONS_BUTTON_PRESSED;
endmodule
