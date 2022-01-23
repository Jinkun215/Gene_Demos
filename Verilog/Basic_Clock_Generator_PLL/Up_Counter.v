`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2022 01:10:07 AM
// Design Name: 
// Module Name: Up_Counter
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


module Up_Counter(

    input i_Clk

    );
    
    parameter counter_MAX = 100;
    integer counter = 0;
    
    
   clk_wiz_0 instance_name
   (
    // Clock out ports
    .CLK_100MHZ(CLK_100MHZ),     // output CLK_100MHZ
    .CLK_25MHZ(CLK_25MHZ),     // output CLK_25MHZ
    .CLK_400MHZ(CLK_400MHZ),     // output CLK_400MHZ
    // Status and control signals
    .reset(reset), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(i_Clk));      // input clk_in1
    
    always@(posedge(CLK_25MHZ)) begin
    
        if (counter < counter_MAX)
            counter <= counter + 1;
        else
            counter <= 0;
    
    end
    
    
    

endmodule
