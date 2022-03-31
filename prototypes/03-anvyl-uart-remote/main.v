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
	output LD7
);
	// Instantiate NANDLAND's UART RX instance
	wire [7:0] rx_data;
	reg [7:0] rx_data_reg;
	reg [7:0] rx_data_reg_prim;
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
		if (rx_ready == 1) begin
			rx_data_reg <= rx_data;
			rx_data_reg_prim <= rx_data + 1;
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
	
   // Assign rx_data + 1 to tx_data
	assign tx_data[0] = rx_data_reg_prim[0];
	assign tx_data[1] = rx_data_reg_prim[1];
	assign tx_data[2] = rx_data_reg_prim[2];
	assign tx_data[3] = rx_data_reg_prim[3];
	assign tx_data[4] = rx_data_reg_prim[4];
	assign tx_data[5] = rx_data_reg_prim[5];
	assign tx_data[6] = rx_data_reg_prim[6];
	assign tx_data[7] = rx_data_reg_prim[7];
	
	// Make a CLK-based sleep counter for printing stuff
	reg [31:0] r_ticks = 0;

	// Every N ticks print data and reset counter
	// 100000000 = 1 second
	// 100000000 = 1 second
	//  30000000 = 0.3 second
	//  10000000 = 0.1 second
	//   5000000 = 0.05 second
	//
	// Currently 0.05 seconds is the serial port refresh rate
	// although every read is 8 bytes, this program only writes 
	// 1 byte per the refresh rate i.e. you can go ~8 times faster
	// i.e. somewhere around 0.0625 seconds and thereby
	// the agent will read 8 bytes every 0.05 seconds
	//
	// N.B. If you write too fast, then the agent won't catch up
	// and eventually will lag extremely behind and you'll be sad
	// parameter sleep = 32'd30000000; // Around 3 FPS
    parameter sleep = 32'd2000000; // Around 50 FPS
	always @(posedge CLK)
	begin
		if (r_ticks < sleep) begin
			r_ticks = r_ticks + 1;
		end
		else if (r_ticks == sleep) begin
			r_tx_ready = 1;
			r_ticks = r_ticks + 1;
		end
		else begin
			r_tx_ready = 0;
			r_ticks = 0;
		end
	end
endmodule
