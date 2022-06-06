`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2022 03:18:19 PM
// Design Name: 
// Module Name: FIFO_8x16_TB
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


module FIFO_8x16_TB(

    );
    
    reg r_Clk = 0;
    
    wire w_FIFO_Empty;
    wire w_FIFO_Full;
    wire [7:0] w_Data_Read;
    
    reg [7:0] r_Data_Write;
    reg r_Reset;
    reg r_Switch_Rd_Wr;
    reg r_Btn_Next;
    
    
    FIFO_8x16
    FIFO_8x16_Inst
    (
        .i_Clk(r_Clk),
        .i_Data_Write(r_Data_Write),
        .i_Reset(r_Reset),
        .i_Switch_Rd_Wr(r_Switch_Rd_Wr),       //Read = '0', Write = '1'
        .i_Btn_Next(r_Btn_Next),
    
        .o_FIFO_Empty(w_FIFO_Empty),
        .o_FIFO_Full(w_FIFO_Full),
        .o_Data_Read(w_Data_Read)
    
    );
    
    
    always#5 r_Clk <= ~r_Clk;
    
    initial begin
    
        r_Reset <= 1'b1;
        r_Switch_Rd_Wr <= 1'b1;                 //Test Reset
        r_Btn_Next <= 1'b0;
        r_Data_Write <= 8'b00100010;
        
        #20;
        r_Reset <= 1'b0;
        
        #20;
        r_Btn_Next <= 1'b1;                 //Test Data Write #1
        
        #20;
        r_Btn_Next <= 1'b0;
        r_Data_Write <= 8'b11011101;
        
        #20;
        r_Btn_Next <= 1'b1;                 //Test Data Write #2
        
        #20;
        r_Btn_Next <= 1'b0;
        r_Switch_Rd_Wr <= 1'b0;
        
        #20;
        r_Btn_Next <= 1'b1;             //Test Data Read #1
        
        #20; 
        r_Btn_Next <= 1'b0;
        
        #20;
        r_Btn_Next <= 1'b1;             //Test Data Read #2
        
        #20; 
        r_Btn_Next <= 1'b0;
        
        #5000;
    end
    
    
    
    
endmodule
