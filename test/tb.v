`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2024 08:13:55 PM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb();

    parameter half_cycle = 5;
    
    reg clk;
    reg reset;
    reg button;
    
    wire [2:0] led;
    wire [3:0] SSG_EN;
    
    always #half_cycle clk=!clk;
    
    main uut(clk, reset, button, led, SSG_EN);
    
    initial begin
    clk <= 0;
    reset <= 1;
    button <= 0;
    
    // short press
    #(2*half_cycle) reset <= 0;
    #(2*half_cycle) button <= 1;
    #(6*half_cycle) button <= 0;
    
    // long press
    #(10*half_cycle) button <= 1;
    #(12*half_cycle) button <= 0;
    
    // press at the middle
    #(30*half_cycle) button <= 1;
    #(12*half_cycle) button <= 0;
    
    // press button within relaxing time
    #(80*half_cycle) button <= 1;
    #(12*half_cycle) button <= 0;
    
    // press button after relaxing time
    #(30*half_cycle) button <= 1;
    #(12*half_cycle) button <= 0;
    
    #(300*half_cycle) $finish;
    end

endmodule
