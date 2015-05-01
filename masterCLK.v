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
    
    reg [3:0] secO;
    reg [2:0] secT;
    reg [3:0] minO;
    reg [2:0] minT;


    reg [26:0] counter = 0;
    // 100 Mhz = 100 000 000, 27 bits needed


    /*
    // needs to be in an always block, suggestion put in a rst signal for initialization
    clock2Hz = 0; 
    clock1Hz = 0;
    clockFast = 0;
    clockBlink = 0;
    */


    /* 
        Strategy:
        Certain behaviors depending on input (ADJ,SEL,RESET)

        The always @ (posedge clk) acts as a while loop
        As long as the positive edge of the clock == 1
            Do the following code block

        Cases: 
        1. ADJ = 0, SEL = Dont care
            Seconds increase by 1 Hz

            /*
                    TODO: 

                        increase secO:

                            if sec0 == 9 (1001) 
                                set secO to 0
                                //increase secT:
                                if secT == 5 (101)
                                    set secT to 0
                                    // increase minO
                                    if minO == 9 (1001)
                                        set minO <= 0
                                        // increase minT
                                        if minT == 5 (101)
                                            minT = 0
                                        else
                                            minT <= minT + 1
                                    else
                                        minO <= minO + 1
                                else
                                    secT <= secT + 1
                            else
                                sec0 <= sec0 + 1
            */

        2. ADJ = 1, SEL = 0
            Seconds increase by 2 Hz
            Do not update Minutes if goes past 60
            Reset after 59
        3. ADJ = 1, SEL = 1
            Min increase by 2 Hz
            Reset after 59

        Collorary: Max time is 59:59
    */


    always @ (posedge clk) begin

        if (RESET) 
            begin
                secO <= 4'b0000;
                secT <= 3'b000;
                minO <= 4'b0000;
                minT <= 3'b000;

            end
        else if (ADJ == 0) 

            /*
                NOTICE: See the ADJ equal 0.png file for clarity on the code
                Red = block for incrementing secO
                Blue = block for incrementing secT
                Green = block for incrementing min0
                Purple = block for incrementing minT
            */

            begin
                if (sec0 == 4'b1001)
                    begin
                    secO <= 4'b0000;


                    if (secT == 3'b101)
                        begin
                        secT <= 3'b000

                            if (minO == 4'b1001)
                                begin
                                minO <= 4'b0000


                                if (minT == 3'b101)
                                    begin
                                    minT = 0
                                    end
                                else
                                    begin
                                    minT <= minT + 1
                                    end
                                end


                                end   
                            else
                                begin
                                minO <= minO + 1
                                end
                            end


                        end
                    else
                        begin
                        secT <= secT + 1
                        end
                    end


                    end
                else
                    begin
                    sec0 <= sec0 + 1
                    end
                end
            end
        else if (SEL == 0) // At this point, ADJ != 0, therefore ADJ == 1
            begin

            end
        else               // At this point, ADJ == 1, SEL != 0, therefore SEL == 1
            begin 

            end
        end


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
