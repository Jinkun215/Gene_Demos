`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2022 12:12:24 PM
// Design Name: 
// Module Name: TOP
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


module TOP
    #(
        parameter g_DATA_SIZE = 8,
        parameter g_FIFO_SIZE = 16
    )
    (
        input i_Clk,
        input [7:0] i_Data_In,
        input i_Reset,
        input i_Rd_Wr,
        input i_Btn,
        
        output o_FIFO_Empty,
        output o_FIFO_Full,
        output reg [6:0] o_Seven_Segment_Display,
        output reg [7:0] o_Seven_Segment_Enable
    
    );
    
    
    reg [1:0] r_Mode = 0;
    parameter counter_Limit = 100000;
    integer counter = 0;
    
    wire [g_DATA_SIZE-1:0] w_Data_Read;
    wire [6:0] w_Segment_Display_1;
    wire [6:0] w_Segment_Display_2;
    wire [6:0] w_Segment_Display_3;
    wire [6:0] w_Segment_Display_4;
    
    
    FIFO_8x16
    #(
       .g_DATA_SIZE(g_DATA_SIZE),
       .g_FIFO_SIZE(g_FIFO_SIZE)
    )
    FIFO_8x16_Inst
    (
        .i_Clk(i_Clk),
        .i_Data_Write(i_Data_In),
        .i_Reset(i_Reset),
        .i_Switch_Rd_Wr(i_Rd_Wr),       //Read = '0', Write = '1'
        .i_Btn_Next(i_Btn),
        
        .o_FIFO_Empty(o_FIFO_Empty),
        .o_FIFO_Full(o_FIFO_Full),
        .o_Data_Read(w_Data_Read)
    );
    
    Seven_Segment_Display
    Seven_Segment_Display_Inst_1
    (
        .i_Clk(i_Clk),
        .i_Byte_Data(i_Data_In[7:4]),
        .o_Segment_Display(w_Segment_Display_1)
    );
        
    Seven_Segment_Display
    Seven_Segment_Display_Inst_2
    (
        .i_Clk(i_Clk),
        .i_Byte_Data(i_Data_In[3:0]),
        .o_Segment_Display(w_Segment_Display_2)
    );
    
    Seven_Segment_Display
    Seven_Segment_Display_Inst_3
    (
        .i_Clk(i_Clk),
        .i_Byte_Data(w_Data_Read[7:4]),
        .o_Segment_Display(w_Segment_Display_3)
    );
    
    Seven_Segment_Display
    Seven_Segment_Display_Inst_4
    (
        .i_Clk(i_Clk),
        .i_Byte_Data(w_Data_Read[3:0]),
        .o_Segment_Display(w_Segment_Display_4)
    );
    
    
    
    
    
    
    
    always@(posedge(i_Clk)) begin
    
        if (counter < counter_Limit-1) begin
            counter <= counter + 1;
        
        end
        else begin
            counter <= 0;
        
            if (r_Mode == 2'b00) begin
                o_Seven_Segment_Enable <= 8'b01111111;
                o_Seven_Segment_Display <= w_Segment_Display_1;
                r_Mode <= 2'b01;
            end
            
            else if (r_Mode == 2'b01) begin
                o_Seven_Segment_Enable <= 8'b10111111;
                o_Seven_Segment_Display <= w_Segment_Display_2;
                r_Mode <= 2'b10;
            end
            
            else if (r_Mode == 2'b10) begin
                o_Seven_Segment_Enable <= 8'b11111101;
                o_Seven_Segment_Display <= w_Segment_Display_3;
                r_Mode <= 2'b11;
            end
            
            else if (r_Mode == 2'b11) begin
                o_Seven_Segment_Enable <= 8'b11111110;
                o_Seven_Segment_Display <= w_Segment_Display_4;
                r_Mode <= 2'b00;
            end
        
        end

    end
    
    
    
    
    
endmodule

















