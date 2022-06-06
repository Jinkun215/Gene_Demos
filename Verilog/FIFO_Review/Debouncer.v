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


module Debouncer(

    input i_Clk,
    input i_Btn,
    output o_Btn

    );
    
    reg r_Btn = 0;
    parameter counter_Limit = 100000;
    integer counter = 0;
    
    always@(posedge(i_Clk)) begin
    
        if (r_Btn != i_Btn && counter < counter_Limit-1)
            counter <= counter + 1;

        else if (counter == counter_Limit-1) begin
            counter <= 0;
            r_Btn <= i_Btn;
        end
        
        else
            counter <= 0;   
    
    end
    
    assign o_Btn = r_Btn;
    
    
endmodule
