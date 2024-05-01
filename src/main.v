`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2024 08:13:55 PM
// Design Name: 
// Module Name: main
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


module main(
    input           clk,
    input           reset,
    input           button,
    output [2:0]    led,
    output [3:0]    SSG_EN
    );

    wire [3:0]  sel;
    wire [3:0]  T;
    wire        ld;
    
    fsm fsm_inst(
        .clk    (clk),
        .reset  (reset),
        .button (button),
        .T      (T),
        .sel    (sel),
        .ld     (ld),
        .led    (led)
    );
    
    timer timer_inst(
        .clk    (clk),
        .reset  (reset),
        .ld     (ld),
        .sel    (sel),
        .T      (T)
    );
        
    assign SSG_EN  =   4'b1111;   // disable the 7-segment LEDs
    
endmodule
