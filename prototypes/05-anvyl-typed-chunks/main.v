// Import NANDLAND's UART RX
`include "uart_rx.v"
// Import NANDLAND's UART TX
`include "uart_tx.v"
// Import kshaa's typed & chunked UART TX
`include "uart_tx_typed_chunker.v"
// Import kshaa's typed & chunked UART RX
`include "uart_rx_typed_chunker.v"

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
	// Instantiate NANDLAND's UART RX instance
	wire [7:0] rx_data;
	wire rx_ready;

	uart_rx uart_rx_instance (
		.i_Clock(CLK),
		.i_Rx_Serial(T19),
		.o_Rx_DV(rx_ready),
		.o_Rx_Byte(rx_data)
	);

	// Buffer-based chunk receiver
	parameter RX_CONTENT_BUFFER_BYTE_SIZE = 3;
	parameter RX_BUFFER_INDEX_SIZE = 32;

	wire [7:0] rx_chunk_type;
	wire [(RX_CONTENT_BUFFER_BYTE_SIZE * 8) - 1:0] rx_chunk_bytes;
	wire rx_chunk_byte_size;
	wire rx_is_chunk_ready;
	uart_rx_typed_chunker #(
		.CONTENT_BUFFER_BYTE_SIZE(RX_CONTENT_BUFFER_BYTE_SIZE),
		.BUFFER_INDEX_SIZE(RX_BUFFER_INDEX_SIZE)
	) uart_rx_typed_chunker_instance (
		.CLK(CLK),
		.rx_data(rx_data),
		.is_rx_ready(rx_ready),
		.chunk_type(rx_chunk_type),
		.chunk_bytes(rx_chunk_bytes),
		.chunk_byte_size(rx_chunk_byte_size),
		.is_chunk_ready(rx_is_chunk_ready)
	);

	// Instantiate NANDLAND's UART TX instance
	wire is_tx_ready;
	wire [7:0] tx_data;
	wire is_tx_done;

	uart_tx uart_tx_instance (
		.i_Clock(CLK),
		.i_Tx_DV(is_tx_ready),
		.i_Tx_Byte(tx_data),
		.o_Tx_Active(),
		.o_Tx_Serial(T20),
		.o_Tx_Done(is_tx_done)
	);

	// Buffer-based chunk sender
	parameter TX_CONTENT_BUFFER_BYTE_SIZE = 5;
	parameter TX_BUFFER_INDEX_SIZE = 32;
	
	reg r_tx_is_chunk_ready = 0;
	reg [7:0] r_tx_chunk_type = 0;
	reg [TX_BUFFER_INDEX_SIZE - 1:0] r_tx_chunk_byte_size = 0;
	reg [(TX_CONTENT_BUFFER_BYTE_SIZE * 8) - 1:0] r_tx_chunk_bytes = 0;
	
	wire chunk_is_tx_ready;
	wire [7:0] chunk_tx_data;
	
	uart_tx_typed_chunker #(
		.CONTENT_BUFFER_BYTE_SIZE(TX_CONTENT_BUFFER_BYTE_SIZE),
		.BUFFER_INDEX_SIZE(TX_BUFFER_INDEX_SIZE)
	) uart_tx_typed_chunker_instance (
		.CLK(CLK),
		.is_chunk_ready(r_tx_is_chunk_ready),
		.chunk_byte_size(r_tx_chunk_byte_size),
		.is_tx_done(is_tx_done),
		.chunk_bytes(r_tx_chunk_bytes),
		.chunk_type(r_tx_chunk_type),
		.is_tx_ready(chunk_is_tx_ready),
		.tx_data(chunk_tx_data)
	);

	assign is_tx_ready = chunk_is_tx_ready;
	assign tx_data = chunk_tx_data;

	// Print out state of received data on physical LEDs
	reg [0:7] r_ld = 0;
	assign LD0 = r_ld[0];
	assign LD1 = r_ld[1];
	assign LD2 = r_ld[2];
	assign LD3 = r_ld[3];
	assign LD4 = r_ld[4];
	assign LD5 = r_ld[5];
	assign LD6 = r_ld[6];
	assign LD7 = r_ld[7];

	// Every N ticks print data and reset counter
	// 100000000 = 1 second 	/ 1 FPS
	//  30000000 = 0.3 second 	/ 3 FPS
	//  10000000 = 0.1 second	/ 10 FPS
	//   5000000 = 0.05 second	/ 20 FPS
	//   2000000 = 0.02 second	/ 50 FPS
	parameter sleep = 32'd100000000;

	// An FSM based on CLK, which sends some data every N ticks
	reg [31:0] r_ticks = 0;
	always @(posedge CLK)
	begin
		if (r_ticks < sleep) begin
			// Tick clock
			r_ticks = r_ticks + 1;
		end else if (r_ticks == sleep) begin
			// Tick clock
			r_ticks = r_ticks + 1;

			// Load received chunk type into transmitted chunk type
			r_tx_chunk_type <= rx_chunk_type;

			// Load received chunk data into transmitted chunk data
			r_tx_chunk_bytes[7:0] <= rx_chunk_bytes[7:0];
			r_tx_chunk_bytes[15:8] <= rx_chunk_bytes[15:8];
			r_tx_chunk_bytes[23:16] <= rx_chunk_bytes[23:16];

			// Trigger chunked TX
			r_tx_is_chunk_ready <= 1;
			r_tx_chunk_byte_size <= 3;
		end else if (r_ticks > sleep) begin
			// Reset clock
			r_ticks = 0;

			// Reset chunked TX
			r_tx_is_chunk_ready <= 0;
			r_tx_chunk_byte_size <= 0;
		end
	end
endmodule
