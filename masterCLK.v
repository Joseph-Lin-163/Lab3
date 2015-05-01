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

    /*
        Need input for the ADJ, SEL, and RESET
        I believe the ADJ and SEL are synchronous while RESET is asynchronous?
        Correct me if I'm wrong -JL

        Any other inputs?
    */

    input SEL,
    input ADJ,
    input RESET,
    input clk,


    output reg clock2Hz, 
    output reg clock1Hz,
    output reg clockFast, // 500 Hz
    output reg clockBlink
    );

    /*
        Just a quick thought - we don't have something specific for the
        min and sec display. We have an output reg for clock2Hz, clock1Hz, at lines 24-27
        but how many bits are those regs? What does it look like in the endgame?

        My thought: output is the display on the 4 7-segment display
        output regs on those? Y/N? -JL
    */

    // Format:   7-seg display =>    | minT | minO | secT | secO |
    // T = tens, O = ones
    // minO and secO max is 9 [4 bits]
    // minT and secT max is 6 [3 bits]
    
    reg [3:0] sec0;
    reg [2:0] secT;
    reg [3:0] min0;
    reg [2:0] minT;


    reg [26:0] counter = 0;
    clock2Hz = 0; // needs to be in an always block, suggestion put in a rst signal for initialization
    clock1Hz = 0;
    clockFast = 0;
    clockBlink = 0;
    
    always @ (posedge clk) begin
        if (counter == 'd100000000)
        begin
            clock1Hz <= ~clock1Hz;
            counter = 'd0;
        end
        if (counter == 'd50000000) // only counting at this first 50000000, 
        // and nothing more, need to count at this interval not just this number
        // dont' use mod % though, really slow for synthesis
        begin
            clock2Hz <= ~clock2Hz;
        end
        if (counter == 'd200000)
        begin
            clockFast <= ~clockFast;
        end
        if (counter == 'd33333333)
        begin
            clockBlink <= ~clockBlink;
        end
        counter <= counter + 1;
    end
    
endmodule
