`timescale 1ns / 1ps

module timer(
    input               clk,
    input               reset,
    input               ld,
    input       [3:0]   sel,
    output reg  [3:0]   T
    );
    
    reg [31:0]  limit;
    reg [31:0]  counter;
    reg [3:0]   en;
    
    parameter T1        = 3;//100000000;
    parameter T2        = 30;//500000000;
    parameter T3        = 20;//250000000;
    parameter T4        = 20;//250000000;
    parameter T_STOP    = -1;
    
    always@(*) begin
    case(sel)
        4'b0000: limit = T1;
        4'b0001: limit = T1;
        4'b0010: limit = T2;
        4'b0100: limit = T3;
        4'b1000: limit = T4;
        4'b1111: limit = T_STOP;
        default: limit = T1;
    endcase
    end
    
    always@(posedge clk, posedge reset) begin
    if(reset || limit == T_STOP) begin
        counter <=0;
        en <= 4'b0000;
        T <= 4'b0000;
    end
    else
        if(ld && !(|en))begin
            counter <= limit;
            en <= sel;
            T <= 4'b0000;
        end
        else if(counter == 0)begin
            counter <=0;
            en <= 4'b0000;
            T <= en;
        end
        else if(|en)
            counter <= counter - 1;
        else
            T <= 4'b0000;
    end
    
endmodule
