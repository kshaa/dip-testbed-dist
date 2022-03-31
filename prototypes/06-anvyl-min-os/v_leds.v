module v_leds #(
	parameter [7:0] INTERFACE_TX_CHUNK_TYPE = 2
)(
	// clock pin
	input CLK,

	// active led state
	input [7:0] leds,
	// signal to inform the user of this module that leds
	// have changed their value and should be updated i.e. sent out over UART 
	output should_update,
	// the value that the leds have been updated to
	output [7:0] tx_chunk_type,
	output [7:0] tx_chunk_bytes,
	// signal to tell this module "the leds have been updated, chill out"
	input reset
);
	// What's the last updated value of LEDs
	reg [7:0] r_last_leds = 0;
	// Should we update and send out the value of LEDs again?
	reg [7:0] r_should_update = 1;
	// The TX chunk type
	reg [7:0] r_tx_chunk_type = INTERFACE_TX_CHUNK_TYPE;

	// An FSM to receive leds and send them out over UART when they're changed
	parameter R_VLEDS_STATE_SIZE = 1;
	parameter R_VLEDS_IDLE = 0;
	parameter R_VLEDS_SHOULD_UPDATE = 1;
	reg [R_VLEDS_STATE_SIZE - 1:0] r_vleds_state = R_VLEDS_SHOULD_UPDATE;
 
	always @(posedge CLK)
	begin
		case (r_vleds_state)
			R_VLEDS_IDLE: begin
				if (leds != r_last_leds) begin
					r_last_leds <= leds;
					r_vleds_state <= R_VLEDS_SHOULD_UPDATE; 
				end
			end
			R_VLEDS_SHOULD_UPDATE: begin
				if (reset) begin
					r_vleds_state <= R_VLEDS_IDLE;
				end
			end
		endcase
	end

	// Outputs
	assign should_update = r_vleds_state == R_VLEDS_SHOULD_UPDATE;
	assign tx_chunk_type = r_tx_chunk_type;
	assign tx_chunk_bytes = r_last_leds;
endmodule
