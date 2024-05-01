`timescale 1ns / 1ps

module relaxing_fsm(
    input               clk,
    input               reset,
    input               need_relaxing,    
    input      [3:0]    T,
	output              relaxing,
	output reg [3:0]    sel,
    output reg          ld
    );
    
    reg   [1:0]     c_state ;
    reg   [1:0]     n_state ;
    reg   [3:0]     start;
    
    parameter   RIDLE    =   1'b0;
    parameter   RST1     =   1'b1;

    parameter start_NULL = 4'b0000;
    parameter start_T2   = 4'b0010;
	
    always@(*)begin
    case(c_state)
        RIDLE: begin
            if(need_relaxing == 1'b1) begin
                n_state = RST1;
                start = start_T2;
            end
            else begin
                n_state = RIDLE;
                start = start_NULL;
            end
        end
        RST1: begin
            if(T[1])
                n_state = RIDLE;
            else
                n_state = RST1;
            start = start_NULL;
        end
        default: begin
            n_state = RIDLE;
            start = start_NULL;
        end     
    endcase
    end
    
    always@(posedge clk or posedge reset) begin
    if(reset)
        c_state  <=  RIDLE;
    else
        c_state <=  n_state;
    end
    
    always@(posedge clk or posedge reset)begin
    if(reset)begin
        sel <= start_NULL;
        ld <= 0;
    end
    else begin
        sel <= start;
        if(start == start_T2)
            ld <= 1;
        else
            ld <= 0;
    end
    end
 
    // FSM output
    assign  relaxing = (c_state == RST1)? 1'b1  : 1'b0;

endmodule
