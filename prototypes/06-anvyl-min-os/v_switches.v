module v_switches #(
	// What is the chunk type
	parameter [7:0] INTERFACE_RX_CHUNK_TYPE = 4,
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

	// last received switch values
	output [7:0] switches
);
	// What's the last updated value of switches
	reg [7:0] r_last_switches = 0;
	// The RX chunk type
	reg [7:0] r_rx_chunk_type = INTERFACE_RX_CHUNK_TYPE;

	// Copy switch value when available
	always @(posedge CLK)
	begin
		if (rx_is_chunk_ready && rx_chunk_type == r_rx_chunk_type && rx_chunk_byte_size == 1) begin
			r_last_switches[7:0] <= rx_chunk_bytes[7:0];
		end
	end

	// Outputs
	assign switches = r_last_switches;
endmodule
