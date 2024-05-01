`timescale 1ns / 1ps

module button_fsm(
    input              clk,
    input              reset,
    input              button,    
    input       [3:0]  T,
	output             button_pressed,
	output reg  [3:0]  sel,
    output reg         ld
    );
    
    reg   [1:0]     c_state ;
    reg   [1:0]     n_state ;
    reg   [3:0]     start;
    
    parameter   BIDLE    =   2'b00;
    parameter   BST1     =   2'b01;
    parameter   BST2     =   2'b11;

    parameter start_NULL = 4'b0000;
    parameter start_T1   = 4'b0001;
    parameter STOP       = 4'b1111;
	
    always@(*)begin
    case(c_state)
        BIDLE: begin
            if(button == 1'b1) begin
                n_state = BST1;
                start = start_T1;
            end
            else begin
                n_state = BIDLE;
                start = start_NULL;
            end
        end
        BST1: begin
            if(T[0]) begin
                n_state = BST2;
                start = start_NULL;
            end
            else begin
                if(button == 1'b0) begin
                    n_state = BIDLE;
                    start = STOP;
                end
                else begin
                    n_state = BST1;
                    start = start_NULL;
                end
             end
        end
        BST2: begin
            n_state = BIDLE;
            start = start_NULL;
        end
        default: begin
            n_state = BIDLE;
            start = start_NULL;
        end     
    endcase
    end
    
    always@(posedge clk or posedge reset) begin
    if(reset)
        c_state  <=  BIDLE;
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
        if(start == start_T1)
            ld <= 1;
        else
            ld <= 0;
    end
    end
 
    // FSM output
    assign  button_pressed = (c_state == BST2)? 1'b1  : 1'b0; 
  
endmodule
