`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2022 05:46:37 PM
// Design Name: 
// Module Name: Frequency_Divider
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


module Frequency_Divider

    #(
        parameter Divider_Value = 2
    )
    (
        input i_Clk_Real,
        output o_Clk_Divided
    );
    
    integer int_Count = 0;
    reg r_Clk = 0;
    
    always@(posedge(i_Clk_Real)) begin
    
        if (int_Count < Divider_Value-1)
            int_Count <= int_Count + 1;
        else begin
            int_Count <= 0;
            r_Clk <= ~r_Clk;
        end

    end
    
    assign o_Clk_Divided = r_Clk;    
    
endmodule







