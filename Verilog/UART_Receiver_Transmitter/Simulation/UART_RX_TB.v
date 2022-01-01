`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/27/2021 12:42:39 AM
// Design Name: 
// Module Name: UART_RX_TB
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


module UART_RX_TB(

    );
    
    parameter c_CLK_PERIOD_NS = 10;
    parameter c_CLKS_PER_BIT = 10417;
    parameter c_BIT_PERIOD_NS = 104170;
    
    reg r_Clock = 0;
    reg r_RX_Serial = 1;
    wire [7:0] r_RX_Byte;
    
    task UART_RX_TEST;
        input [7:0] i_Data_in;
        integer ii;
        
        begin
            
            r_RX_Serial <= 1'b0;
            #(c_BIT_PERIOD_NS);
            #1000;
            
            for (ii=0; ii < 8; ii=ii+1)
                begin
                    r_RX_Serial <= i_Data_in[ii];
                    #(c_BIT_PERIOD_NS);
                end
            
            r_RX_Serial <= 1'b1;
            #(c_BIT_PERIOD_NS);
        
        end
    endtask
    
    UART_RX #(.g_CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_Inst
    (
        .i_Clk(r_Clock),
        .i_RX_Serial(r_RX_Serial),
        .o_RX_DV(),
        .o_RX_Byte(r_RX_Byte)    
    );
    
    always 
     #(c_CLK_PERIOD_NS/2) r_Clock <= !r_Clock;
    
    initial
        begin
            
            @(posedge r_Clock);
            UART_RX_TEST(8'h37);
            @(posedge r_Clock);
            
            if (r_RX_Byte == 8'h37)
                $display("Test Successful - Correct Bytes Received");
            else
                $display("Test Failure - Incorrect Bytes Received");
           $finish();

        end
  
    
    
endmodule
