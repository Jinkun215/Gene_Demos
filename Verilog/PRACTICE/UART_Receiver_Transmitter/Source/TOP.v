`timescale 1ns / 1ps


module TOP (

    input i_Clk,
    input i_UART_RX,
    output o_UART_TX,
    output [6:0] o_Seven_Segment,
    output [7:0] o_Display_Ports
    

);
    reg r_Switch = 0;
    wire [6:0] w_Seven_Segment_1;
    wire [6:0] w_Seven_Segment_2;
    reg [6:0] r_Seven_Segment_Base;
    reg [7:0] r_Display_Ports;
    
    wire w_DV;
    wire [7:0] w_Byte;
    
    parameter Counter_Limit = 50000;
    reg [15:0] Counter = 0;

    UART_RX #(.g_CLKS_PER_BIT() ) UART_RX_Inst
    (
        .i_Clk(i_Clk),
        .i_RX_Serial(i_UART_RX),
        .o_RX_DV(w_DV),
        .o_RX_Byte(w_Byte)
    
    );
    
    
    UART_TX #(.g_CLKS_PER_BIT() ) UART_TX_Inst
    (
        .i_clk(i_Clk),
        .i_TX_DV(w_DV),
        .i_TX_Byte(w_Byte),
        .o_TX_Active(),
        .o_TX_Serial(o_UART_TX),
        .o_TX_Done()
    
    );
    
    Seven_Segment Seven_Segment_Inst_1
    (
        .i_clk(i_Clk),
        .i_Data(w_Byte[3:0]),
        .o_Segment(w_Seven_Segment_1)
    
    );
    
    Seven_Segment Seven_Segment_Inst_2
    (
        .i_clk(i_Clk),
        .i_Data(w_Byte[7:4]),
        .o_Segment(w_Seven_Segment_2)
    
    );
    
    always@(posedge(i_Clk))
    begin
        
        if (Counter < Counter_Limit)
            Counter <= Counter + 1;
        else if (Counter == Counter_Limit)
            begin
            Counter <= 0;
            
            if (r_Switch == 1'b0)
                begin
                    r_Switch <= 1'b1;
                    r_Display_Ports <= 8'b11111110;
                    r_Seven_Segment_Base <= w_Seven_Segment_1;
                
                end
            else
                begin
                    r_Switch <= 1'b0;
                    r_Display_Ports <= 8'b11111101;
                    r_Seven_Segment_Base <= w_Seven_Segment_2;
                end
            
            end
        else
            Counter <= 0;
    end
    
    assign o_Seven_Segment = r_Seven_Segment_Base;
    assign o_Display_Ports = r_Display_Ports;



endmodule

















