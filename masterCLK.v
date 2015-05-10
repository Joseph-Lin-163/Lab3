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
    output reg clockFast,   // 500 Hz
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
					 
					 counter <= 'd0;
					 fastCounter <= 'd0;
					 
			
            end
        else
            begin
                if (counter == 'd100000000)
                begin
                    clock1Hz <= ~clock1Hz;
                    counter <= 'd0;
                end
					 else
					     counter <= counter + 'd1;
					 
                if (counter == 'd50000000 || counter == 'd100000000)                 
                begin
                    clock2Hz <= ~clock2Hz;
                end

                if (fastCounter == 'd200000)
                begin
                    clockFast <= ~clockFast;
						  fastCounter <= 'd0;
                end
					 else
					     fastCounter <= fastCounter + 'd1;

                // If we say 1 second per 100 MHz, this is .33 seconds for 3 ticks a sec
                if ((counter == 'd33333333) || (counter == 'd66666666) || (counter == 'd99999999)) 
                begin
                    clockBlink <= ~clockBlink;
                end

            end     // end else block
    end             // end always block 

  
endmodule
