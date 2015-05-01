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
    output reg clock2Hz, 
    output reg clock1Hz,
    output reg clockFast, // 500 Hz
    output reg clockBlink
    );

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
