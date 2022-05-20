`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2022 03:50:55 PM
// Design Name: 
// Module Name: Sync_Counter
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


module Sync_Counter
    #(
        parameter g_Total_Col = 800,        //Count for the Full VGA size of 640 x 480 resolution screen
        parameter g_Total_Row = 525
    )
    (
        input i_Clk,
        
        output reg [9:0] o_Col_Counter = 0,
        output reg [9:0] o_Row_Counter = 0
    );
    

    
    always@(posedge(i_Clk)) begin                   //Count Columns First
    
        if (o_Col_Counter < g_Total_Col-1) 
            o_Col_Counter <= o_Col_Counter + 1;
        else begin
        
            o_Col_Counter <= 0;                 //Count Row only when Column reach its end, then reset column count
            
            if (o_Row_Counter < g_Total_Row-1)
                o_Row_Counter <= o_Row_Counter + 1;
            else
                o_Row_Counter <= 0;         //when row reach its end, reset row count
        
        end

    end
    
    

endmodule
