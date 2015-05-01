`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:51:00 05/01/2015 
// Design Name: 
// Module Name:    masterToTimer 
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

module masterToTimer (
	input ADJ,
	input SEL,
	input RESET,
	input clk,
	input clock2Hz,
    input clock1Hz,
	//input clockFast,
	//input clockBlink,

	output clkOut
);

	reg clock2HzPrev = 1'b0;
    reg clock1HzPrev = 1'b0;
	//reg clockFastPrev = 1'b0;
	//reg clockBlinkPrev = 1'b0;

	/*
		Question:
		Where do we take care of the blinking and scanning?
	*/

	always @ (posedge clk)
	begin
		if (RESET)
			begin
				clock2HzPrev = 1'b0;
    			clock1HzPrev = 1'b0;
			end
		else
			begin
				if (ADJ == 0)
					begin
						if (clock1Hz != clock1HzPrev)
							begin
								clock1HzPrev = clock1Hz;
								clkOut <= 1'b1;
							end
						else
							begin
								clkOut <= 0'b0;
							end
					end
				else
					begin
						if (clock2Hz != clock2HzPrev)
							begin
								clock1HzPrev = clock1Hz;
								clkOut <= 1'b1;
							end
						else
							begin
								clkOut <= 0'b0;
							end
					end
			end
	end

	timer timer_t (
		.SEL(SEL),
		.ADJ(ADJ),
		.RESET(RESET),
		.clk(clkOut)
	);

endmodule


