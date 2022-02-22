`timescale 1ns / 1ps

module bit_shift_controller #(
	parameter START_BITS = 8'b00010000
)(
	input [23:0] buttons,
	output [7:0] bits
);
	reg [7:0] r_bits = START_BITS;
	assign bits = r_bits;
	always @(buttons)
	begin
		r_bits = 
			(buttons[0] == 1 && r_bits[0] != 1) ? r_bits << 1 :
			(buttons[1] == 1 && r_bits[7] != 1) ? r_bits >> 1 :  
			(buttons[2] == 1) ? 8'b00010000 :
			(buttons[3] == 1) ? 8'b00101000 :
			(buttons[4] == 1) ? 8'b01010101 :
			(buttons[5] == 1) ? 8'b10101010 :
			(buttons[6] == 1) ? 8'b00000000 :
			(buttons[7] == 1) ? 8'b11111111 :
			(buttons[8] == 1) ? 8'b00000001 :
			(buttons[9] == 1) ? 8'b00000010 :
			(buttons[10] == 1) ? 8'b00000100 :
			(buttons[11] == 1) ? 8'b00001000 :
			(buttons[12] == 1) ? 8'b00010000 :
			(buttons[13] == 1) ? 8'b00100000 :
			(buttons[14] == 1) ? 8'b01000000 :
			(buttons[15] == 1) ? 8'b10000000 :
			r_bits;
	end
endmodule
