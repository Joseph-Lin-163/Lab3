`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:58:18 05/04/2015 
// Design Name: 
// Module Name:    segDisp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module segDisp (
	input [3:0] in;
	output [6:0] out;
);

// A = top, B = top-right, ... , F = top left, G = middle
always @*
	begin 
	case(in)
		4'b0000: out <= 7'b1111110
		4'b0001: out <= 7'b0110000
		4'b0010: out <= 7'b1101101
		4'b0011: out <= 7'b1111001
		4'b0100: out <= 7'b0110011
		4'b0101: out <= 7'b1011011
		4'b0110: out <= 7'b1011111
		4'b0111: out <= 7'b1110000
		4'b1000: out <= 7'b1111111
		4'b1001: out <= 7'b1110011
	endcase
	end

endmodule