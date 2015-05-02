`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:18 04/29/2015 
// Design Name: 
// Module Name:    timer 
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

/*
****************************************************************************************

	This module will be for altering the digits on the 7-seg display
	Not the actual display, but the numbers in each slot

	Requires:
	masterCLK to feed the input of a clk (1 Hz, 2 Hz, etc.)

	Feeds into:
	segDisp.v to give it the numbers so that we have information to change the
    	lights on the 7-seg display


	This link may help in doing inter-module work:
		http://stackoverflow.com/questions/1704989/wiring-two-modules-in-verilog

		Transcript (DELETE LATER):

								 module dff (
								    input Clk,
								    input D,
								    output Q,
								    output Qbar
								  );

								  wire q_to_s;
								  wire qbar_to_r;
								  wire clk_bar;

								  assign clk_bar = ~Clk;

								  D_latch dlatch (
								    .D(D),
								    .Clk(Clk),
								    .Q(q_to_s),
								    .Qbar(qbar_to_r)
								  );

								  RS_latch rslatch (
								    .S(q_to_s),
								    .R(qbar_to_r),
								    .Clk(clk_bar),
								    .Qa(Q),
								    .Qb(Qbar)
								  );

								 endmodule

****************************************************************************************
*/

module timer (
	
    input SEL,
    input ADJ,
    input RESET,
    input clk


);

    // Format:   7-seg display =>    | minT | minO | secT | secO |
    // T = tens, O = ones
    // minO and secO max is 9 [4 bits]
    // minT and secT max is 6 [3 bits]
    
    reg [3:0] secO;
    reg [2:0] secT;
    reg [3:0] minO;
    reg [2:0] minT;

/* 
        Strategy:
        Certain behaviors depending on input (ADJ,SEL,RESET)

        The always @ (posedge clk) acts as a while loop
        As long as the positive edge of the clock == 1
            Do the following code block

        Cases: 
        1. ADJ = 0, SEL = Dont care
            Seconds increase by 1 Hz            
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
        2. ADJ = 1, SEL = 0
            Seconds increase by 2 Hz
            Do not update Minutes if goes past 60
            Reset after 59
        3. ADJ = 1, SEL = 1
            Min increase by 2 Hz
            Reset after 59

        Collorary: Max time is 59:59
    */


    always @(posedge clk)
    begin

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
                        secT <= 3'b000;

                            if (minO == 4'b1001)
                                begin
                                minO <= 4'b0000;


                                if (minT == 3'b101)
                                    begin
                                    minT = 0;
                                    end
                                else
                                    begin
                                    minT <= minT + 1;
                                    end
                                


                                end   
                            else
                                begin
                                minO <= minO + 1;
                                end                            

                        end
                    else
                        begin
                        secT <= secT + 1;
                        end
						end
                else
                    begin
                    sec0 <= sec0 + 1;
                    end    
            end
        else if (SEL == 0) // At this point, ADJ != 0, therefore ADJ == 1
            begin
            	if (sec0 == 4'b1001)
                    begin
                    secO <= 4'b0000;

                    if (secT == 3'b101)
                        begin
                        secT <= 3'b000;
                        end
                    else
                        begin
                        secT <= secT + 1;
                        end                    

                    end
                else
                    begin
                    sec0 <= sec0 + 1;
                    end    
            end
        else               // At this point, ADJ == 1, SEL != 0, therefore SEL == 1
            begin 
            	if (minO == 4'b1001)
                    begin
                    minO <= 4'b0000;


                    if (minT == 3'b101)
                    	begin
                        minT = 0;
                        end
                    else
                        begin
                        minT <= minT + 1;
                        end
                                
                    end   
				else
					begin
                    minO <= minO + 1;
                    end             
            end
    end

endmodule