`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2022 01:13:51 AM
// Design Name: 
// Module Name: Up_Counter_TB
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


module Up_Counter_TB(

    );
    
    parameter CLK_PERIOD_NS = 10;
    reg r_Clk = 0;
    
    always#(CLK_PERIOD_NS/2) r_Clk <= ~r_Clk;
    
    Up_Counter Up_Counter_Inst
    (
        .i_Clk(r_Clk)
    );
    
    
    
    
endmodule
