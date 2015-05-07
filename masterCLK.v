`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:18 04/29/2015 
// Design Name: 
// Module Name:    masterCLK 
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


module masterCLK(
    input clk, 
    input rst,
    
    output reg clock2Hz, 
    output reg clock1Hz,
    output reg clockFast,  // 500 Hz
    output reg clockBlink  //   3 Hz
    );

    reg [26:0] counter;
	 reg [26:0] fastCounter;
    // 100 Mhz = 100 000 000, 27 bits needed
    // 100 000 000 Hz
    
    always @ (posedge clk) 
    begin
        if (rst)
            begin
				
                clock2Hz <= 0; 
                clock1Hz <= 0;
                clockFast <= 0;
                clockBlink <= 0;
					 
					 counter <= 0;
					 fastCounter <= 0;
            end
        else
            begin
                if (counter == 'd100000000)
                begin
                    clock1Hz <= ~clock1Hz;
                    counter <= 'd0;
                end
                if (counter == 'd50000000 || counter == 'd100000000)                 
                begin
                    clock2Hz <= ~clock2Hz;
                end

                if (fastCounter == 'd200000)
                begin
                    clockFast <= ~clockFast;
						  fastCounter <= 'd0;
                end

                // If we say 1 second per 100 MHz, this is .33 seconds for 3 ticks a sec
                if ((counter == 'd33333333) || (counter == 'd66666666) || (counter == 'd99999999)) 
                begin
                    clockBlink <= ~clockBlink;
                end

                counter <= counter + 'd1;
				    fastCounter <= fastCounter + 'd1;

                
                /*
                    Need: Joshua's input

                    I see potential problem:

                    1. variable <= ~variable only flips the bit once
                        Shouldn't we be flipping it on, then off to signify
                            "This is on at the 100 Mhz mark only"
                        It seems to be that clock1Hz is on for 100 MHz, off for 100MHz, etc.
                        Should we have it be 1 tick (on then off) every 100 MHz?
                        Maybe flip the bit off on the next posedge?
                */


            end     // end else block
    end             // end always block 
  
endmodule
