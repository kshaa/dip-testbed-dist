// Import NANDLAND's UART Verilog
include "uart_rx.v";
include "uart_tx.v";

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
	output LD7,
	
	// Physical GPIO: Switches
	input SW0,
	input SW1,
	input SW2,
	input SW3,
	input SW4,
	input SW5,
	input SW6,
	input SW7
);
	// Instantiate NANDLAND's UART RX instance
	wire [7:0] rx_data;
	reg [7:0] rx_data_reg_extra;
	reg [7:0] rx_data_reg;
	wire rx_ready;

	uart_rx uart_rx_instance (
		.i_Clock(CLK),
		.i_Rx_Serial(T19),
		.o_Rx_DV(rx_ready),
		.o_Rx_Byte(rx_data)
	);
	
	// Print out state of received data
	assign LD0 = rx_data_reg[0];
	assign LD1 = rx_data_reg[1];
	assign LD2 = rx_data_reg[2];
	assign LD3 = rx_data_reg[3];
	assign LD4 = rx_data_reg[4];
	assign LD5 = rx_data_reg[5];
	assign LD6 = rx_data_reg[6];
	assign LD7 = rx_data_reg[7];

	// Copy the data when it's been read
	always @(posedge CLK)
	begin
		if (rx_ready == 1 && rx_data != 8'b00000000) begin
			rx_data_reg <= rx_data;
		end
	end
	
	// Instantiate NANDLAND's UART TX instance
	wire tx_ready;
	wire [7:0] tx_data;
	wire tx_done;
	
	uart_tx uart_tx_instance (
		.i_Clock(CLK),
		.i_Tx_DV(tx_ready),
		.i_Tx_Byte(tx_data),
		.o_Tx_Active(),
		.o_Tx_Serial(T20),
		.o_Tx_Done(tx_done)
	);
	
	// Make tx_ready writeable
	reg r_tx_ready = 0;
	assign tx_ready = r_tx_ready;
	
   // Assign tx_data switch data
	assign tx_data[0] = SW0;
	assign tx_data[1] = SW1;
	assign tx_data[2] = SW2;
	assign tx_data[3] = SW3;
	assign tx_data[4] = SW4;
	assign tx_data[5] = SW5;
	assign tx_data[6] = SW6;
	assign tx_data[7] = SW7;
	
	// Make a CLK-based sleep counter for printing stuff
	reg [31:0] r_ticks = 0;

	// Every 100000000 ticks print data and reset counter
	always @(posedge CLK)
	begin
		if (r_ticks < 32'd100000000) begin
			r_ticks <= r_ticks + 1;
		end
		else if (r_ticks == 32'd100000000) begin
			r_tx_ready <= 1;
			r_ticks <= r_ticks + 1;
		end
		else begin
			r_tx_ready <= 0;
			r_ticks <= 0;
		end
	end
endmodule
