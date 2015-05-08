`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:03:38 05/06/2015 
// Design Name: 
// Module Name:    master 
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
module master(
    input clk,
    input ADJ,
    input SEL,
    input rst,
	 input PAUSE,
    output [6:0] out,
    output [3:0] an
    );
    
    wire clock1Hz;
    wire clock2Hz;
    wire clockFast;
    wire clockBlink;
    wire clkOut;
	 
	 
	 reg [9:0] rstSample = 10'b0000000000;
	 reg [9:0] PAUSESample = 10'b0000000000;
	 reg [26:0] fastCounter = 'd0;
	 reg rstOut = 0;
	 reg PAUSEOut = 0;
	 always @(*)
	 begin
			if (fastCounter == 'd2000/*00*/)
                begin
					 fastCounter = 'd0;
					     if (rst == 1)
						  begin
								rstSample = rstSample + 1;
								rstSample = rstSample << 1;
						  end
						  else
								rstSample = 0;
								
						  if (PAUSE == 1)
						  begin
								PAUSESample = PAUSESample + 1;
								PAUSESample = PAUSESample << 1;
						  end
						  else
								PAUSESample = 0;
					 end
			else
				fastCounter = fastCounter + 'd1;
			if (rstSample == 10'b1111111111)
				rstOut = 1;
			else
				rstOut = 0;
			if (PAUSESample == 10'b1111111111)
				PAUSEOut = ~PAUSEOut;
	 end
	 
    masterCLK myCLK (
	     // inputs
        .clk (clk),
		  .rst (rstOut),
		  
		  //outputs
        .clock1Hz (clock1Hz),
        .clock2Hz (clock2Hz),
        .clockFast (clockFast),
        .clockBlink (clockBlink)
        );
        
	 masterToTimer mtt (
			// inputs
			.ADJ (ADJ),
			.SEL (SEL),
			
			.clk (clk),
			.clock2Hz (clock2Hz),
			.clock1Hz (clock1Hz),
			
			//output
			.clkOut (clkOut)
			);
			
	 timer timer_t (
		// input
		.masterCLK(clk),
		.SEL(SEL),
		.ADJ(ADJ),
		.rst(rstOut),
		.clk(clkOut),
		.PAUSE(PAUSEOut),
      .clockFast(clockFast),
		.clockBlink(clockBlink),
		//output
      .an (an),
		.out (out)	
		);

endmodule
