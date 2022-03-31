// Import NANDLAND's UART Verilog
`include "uart_rx.v"
`include "uart_tx.v"
`include "uart_tx_chunker.v"

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
	parameter BUFFER_BYTE_SIZE = 3;
	parameter BUFFER_INDEX_SIZE = 32;
	
	reg r_is_chunk_ready = 0;
	reg [BUFFER_INDEX_SIZE - 1:0] r_chunk_byte_size = 0;
	reg [(BUFFER_BYTE_SIZE * 8) - 1:0] r_chunk_bytes = 0;
	
	wire chunk_is_tx_ready;
	wire [7:0] chunk_tx_data;
	
	uart_tx_chunker #(
		.BUFFER_BYTE_SIZE(BUFFER_BYTE_SIZE),
		.BUFFER_INDEX_SIZE(BUFFER_INDEX_SIZE)
	) uart_tx_chunker_instance (
		.CLK(CLK),
		.is_chunk_ready(r_is_chunk_ready),
		.chunk_byte_size(r_chunk_byte_size),
		.is_tx_done(is_tx_done),
		.chunk_bytes(r_chunk_bytes),
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

	// Copy the data when it's been read
	reg [7:0] last_rx_data;
	always @(posedge CLK)
	begin
		if (rx_ready == 1) begin
			r_ld <= rx_data;
			last_rx_data <= rx_data;
		end
	end
	
	// Create bytes for input with several increments
	wire [7:0] rx_data_reg_prim = last_rx_data + 1;
	wire [7:0] rx_data_reg_prim_2 = last_rx_data + 2;
	wire [7:0] rx_data_reg_prim_3 = last_rx_data + 3;

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

			// Load data into chunk
			r_chunk_bytes[0] <= rx_data_reg_prim[0];
			r_chunk_bytes[1] <= rx_data_reg_prim[1];
			r_chunk_bytes[2] <= rx_data_reg_prim[2];
			r_chunk_bytes[3] <= rx_data_reg_prim[3];
			r_chunk_bytes[4] <= rx_data_reg_prim[4];
			r_chunk_bytes[5] <= rx_data_reg_prim[5];
			r_chunk_bytes[6] <= rx_data_reg_prim[6];
			r_chunk_bytes[7] <= rx_data_reg_prim[7];

			r_chunk_bytes[8]  <= rx_data_reg_prim_2[0];
			r_chunk_bytes[9]  <= rx_data_reg_prim_2[1];
			r_chunk_bytes[10] <= rx_data_reg_prim_2[2];
			r_chunk_bytes[11] <= rx_data_reg_prim_2[3];
			r_chunk_bytes[12] <= rx_data_reg_prim_2[4];
			r_chunk_bytes[13] <= rx_data_reg_prim_2[5];
			r_chunk_bytes[14] <= rx_data_reg_prim_2[6];
			r_chunk_bytes[15] <= rx_data_reg_prim_2[7];

			r_chunk_bytes[16] <= rx_data_reg_prim_3[0];
			r_chunk_bytes[17] <= rx_data_reg_prim_3[1];
			r_chunk_bytes[18] <= rx_data_reg_prim_3[2];
			r_chunk_bytes[19] <= rx_data_reg_prim_3[3];
			r_chunk_bytes[20] <= rx_data_reg_prim_3[4];
			r_chunk_bytes[21] <= rx_data_reg_prim_3[5];
			r_chunk_bytes[22] <= rx_data_reg_prim_3[6];
			r_chunk_bytes[23] <= rx_data_reg_prim_3[7];

			// Turn on chunked TX
			r_is_chunk_ready <= 1;
			r_chunk_byte_size <= 3;
		end else if (r_ticks > sleep) begin
			// Reset clock
			r_ticks = 0;

			// Turn off chunked TX
			r_is_chunk_ready <= 0;
			r_chunk_byte_size <= 0;
		end
	end
endmodule
