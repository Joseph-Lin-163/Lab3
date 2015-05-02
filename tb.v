`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:18 04/29/2015 
// Design Name: 
// Module Name:    tb 
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
module tb(
    );

    reg clk, rst;
    wire clock1Hz;
    wire clock2Hz;
    wire clockFast;
    wire clockBlink;
    
    masterCLK myCLK (
        .clk (clk),
		  .rst (rst),
		  
        .clock1Hz (clock1Hz),
        .clock2Hz (clock2Hz),
        .clockFast (clockFast),
        .clockBlink (clockBlink)
        );
        
    initial begin
        clk = 1'b0;
		  rst = 1'b1;
        repeat(4) #1 clk = ~clk;
		  rst = 1'b0;
        forever #1 clk = ~clk;
    end
    
    initial begin
        #100000000
    $finish;
    end
endmodule
