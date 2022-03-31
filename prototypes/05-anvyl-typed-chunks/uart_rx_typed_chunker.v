// Buffer-based typed chunk receiver

// - The complementary counterpart to UART TX Typed Chunker
// - Parses binary streams for byte chunks
// - Decodes an identifier for every byte chunk parsed from the stream
// - For more info see uart_tx_typed_chunker.v

module uart_rx_typed_chunker #(
	// The size of the chunk in bytes (maximum chunk size essentially)
	parameter CONTENT_BUFFER_BYTE_SIZE = 3,
	// How many bits needed to index the whole buffer
	parameter BUFFER_INDEX_SIZE = 32
)(
	// Clock pin
	input CLK,
	// Received serial data
	input [7:0] rx_data,
	// Is data recently received
	input is_rx_ready,

	// The type of chunk that we've read 
	output [7:0] chunk_type,
	// The chunk byte content
	output [(CONTENT_BUFFER_BYTE_SIZE * 8) - 1:0] chunk_bytes,
	// The amount of bytes in the chunk
	output chunk_byte_size,
	// Has the chunk been succesfully read
	output is_chunk_ready
);
	// Have we finished reading the chunk
	reg r_is_chunk_done = 0;
	// What is the chunk type?
	reg [7:0] r_chunk_type = 0;
	// What are the contents of the chunk
	reg [(CONTENT_BUFFER_BYTE_SIZE * 8) - 1:0] r_chunk_bytes = 0;
	// Next writable index
	reg [BUFFER_INDEX_SIZE - 1:0] r_next_byte_index = 0;

	// FSM states
	parameter R_CHUNKER_STATE_SIZE = 3;
	parameter R_CHUNKER_IDLE = 0;
	parameter R_CHUNKER_READING_TYPE = 1;
	parameter R_CHUNKER_READING_BYTE = 2;
	parameter R_CHUNKER_READING_ESCAPED_BYTE = 3;
	parameter R_CHUNKER_FINISHED_CHUNK = 4; // success
	parameter R_CHUNKER_PARSE_ERROR = 5;	// failure
	reg [R_CHUNKER_STATE_SIZE - 1:0] r_chunker_state = R_CHUNKER_IDLE;

	// Copy the data when it's been read
	integer buffer_iterator = 0;
	always @(posedge CLK)
	begin
		case (r_chunker_state)
			R_CHUNKER_IDLE: begin
				if (is_rx_ready == 1 && rx_data == 0) begin
					r_chunker_state <= R_CHUNKER_READING_TYPE;
				end
			end
			R_CHUNKER_READING_TYPE: begin
				if (is_rx_ready == 1 && rx_data == 0) begin
					// A type of 0x00 is invalid (it's reserved for null-bytes)
					r_chunker_state <= R_CHUNKER_PARSE_ERROR;
				end else if (is_rx_ready == 1 && rx_data != 0) begin
					r_chunk_type <= rx_data;
					r_chunker_state <= R_CHUNKER_READING_BYTE;
				end
			end
			R_CHUNKER_READING_BYTE: begin
				if (is_rx_ready == 1 && rx_data == 0) begin
					r_chunker_state <= R_CHUNKER_READING_ESCAPED_BYTE;
				end else if (is_rx_ready == 1 && rx_data != 0) begin
					// At compile-time this is parsed as a template essentially 
					// and is then expanded into just a large list of if's w/ hardcoded indices from 0 to CONTENT_BUFFER_BYTE_SIZE
					// a better solution would be to use memory for this, but there's a time and place for everything  
					for (buffer_iterator = 0; buffer_iterator < CONTENT_BUFFER_BYTE_SIZE; buffer_iterator = buffer_iterator + 1)
						if (r_next_byte_index == buffer_iterator) begin
							// Write rx_data at the chunk buffer index
							r_chunk_bytes[buffer_iterator * 8 +: 8] <= rx_data;
							r_next_byte_index <= buffer_iterator + 1;
						end

					r_chunker_state <= R_CHUNKER_READING_BYTE;
				end
			end
			R_CHUNKER_READING_ESCAPED_BYTE: begin
				if (is_rx_ready == 1 && rx_data == 0) begin
					// At compile-time this is parsed as a template essentially 
					// and is then expanded into just a large list of if's w/ hardcoded indices from 0 to CONTENT_BUFFER_BYTE_SIZE
					// a better solution would be to use memory for this, but there's a time and place for everything  
					for (buffer_iterator = 0; buffer_iterator < CONTENT_BUFFER_BYTE_SIZE; buffer_iterator = buffer_iterator + 1)
						if (r_next_byte_index == buffer_iterator) begin
							// Write a null-byte at the chunk buffer index
							r_chunk_bytes[buffer_iterator * 8 +: 8] <= 0;
							r_next_byte_index <= buffer_iterator + 1;
						end

					r_chunker_state <= R_CHUNKER_READING_BYTE;
				end else if (is_rx_ready == 1 && rx_data == 1) begin
					// We've read an escaped end-of-chunk
					r_chunker_state <= R_CHUNKER_FINISHED_CHUNK;
				end else if (is_rx_ready) begin
					// In the middle of a chunk the only 
					// an escaped null-byte and an end-of-chunk byte are allowed
					r_chunker_state <= R_CHUNKER_PARSE_ERROR;
				end
			end
			R_CHUNKER_FINISHED_CHUNK: begin
				// This state will bring is_ready_chunk high, then move to idle
				r_chunker_state <= R_CHUNKER_IDLE;
				r_next_byte_index <= 0;
			end
			R_CHUNKER_PARSE_ERROR: begin
				// Lets just clean up and move to idle
				r_chunker_state <= R_CHUNKER_IDLE;
				r_next_byte_index <= 0;
			end
		endcase
	end

	// Outputs
	assign chunk_type = r_chunk_type;
	assign chunk_bytes = r_chunk_bytes;
	assign chunk_byte_size = r_next_byte_index;
	assign is_chunk_ready = r_chunker_state == R_CHUNKER_FINISHED_CHUNK;
endmodule
