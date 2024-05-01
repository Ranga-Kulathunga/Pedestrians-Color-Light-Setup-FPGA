`timescale 1ns / 1ps

module fsm(
    input               clk,
    input               reset,
    input               button,
    input       [3:0]   T,
    output reg  [3:0]   sel,
    output reg          ld,
    output reg  [2:0]   led
    );
    
        
    reg [1:0] c_state;
    reg [1:0] n_state;
    reg [3:0] start;
    
    parameter IDLE      = 2'b00;
    parameter ST1       = 2'b01;
    parameter ST2       = 2'b10;
    parameter ST_NULL   = 2'b11;
    
    parameter start_NULL = 4'b0000;
    parameter start_T3   = 4'b0100; // waiting time
    parameter start_T4   = 4'b1000; // crossing time
    
    // button mechanism
    wire button_pressed;
    wire [3:0] sel_b;
    wire [3:0] T_b;
    wire ld_b;
    
    timer button_timer_inst(
        .clk    (clk),
        .reset  (reset),
        .ld     (ld_b),
        .sel    (sel_b),
        .T      (T_b)
    );
    
    button_fsm button_fsm_inst(
        .clk            (clk), 
        .reset          (reset), 
        .button         (button),
        .T              (T_b),
        .button_pressed (button_pressed),
        .sel            (sel_b),
        .ld             (ld_b)
    );
    
    assign button_en = button_pressed ? 1'b1 : 1'b0;
    
    // relaxing mechanism
    reg need_relaxing;
    wire relaxing;
    wire [3:0] sel_r;
    wire [3:0] T_r;
    wire ld_r;
    
    timer relaxing_timer_inst(
        .clk    (clk),
        .reset  (reset),
        .ld     (ld_r),
        .sel    (sel_r),
        .T      (T_r)
    );
    
    relaxing_fsm relaxing_fsm_inst(
        .clk            (clk), 
        .reset          (reset), 
        .need_relaxing         (need_relaxing),
        .T              (T_r),
        .relaxing       (relaxing),
        .sel            (sel_r),
        .ld             (ld_r)
    );
    
    assign relaxing_en = relaxing ? 1'b1 : 1'b0;
    
    always @(*) begin
    case(c_state)
        IDLE: begin
            if(button_en && !relaxing_en) begin
                n_state = ST1;
                start = start_T3;
            end
            else begin
                if (relaxing_en)
                    need_relaxing = 1'b0;
                n_state = IDLE;
                start = start_NULL;
            end
        end
        ST1: begin
            if(T[2]) begin
                n_state = ST2;
                start = start_T4;
            end
            else begin
                n_state = ST1;
                start = start_NULL;
            end
        end
        ST2: begin
            if(T[3]) begin
                n_state = IDLE;
                need_relaxing = 1'b1;
            end
            else begin
                n_state = ST2;
            end
            start = start_NULL;
        end
        ST_NULL: begin
            n_state = IDLE;
            start = start_NULL;
        end
        default: begin
            n_state = IDLE;
            start = start_NULL;
        end
    endcase
    end
    
    always@(posedge clk or posedge reset) begin
    if(reset)
        c_state <= IDLE;
    else 
        c_state <= n_state;
    end
    
    always@(posedge clk or posedge reset) begin
    if(reset)begin
        sel <= start_NULL;
        ld <= 0;
    end
    else begin
        sel <= start;
        if(start == start_T3 || start == start_T4)
            ld <= 1;
        else
            ld <= 0;
    end
    end
    
    always@(posedge clk or posedge reset) begin
        if(reset)
            led = 3'b001;
        else begin
            if(c_state == ST1)
                led = 3'b010;
            else if(c_state == ST2)
                led = 3'b100;
            else
                led = 3'b001;
        end
    end
    
    
endmodule
