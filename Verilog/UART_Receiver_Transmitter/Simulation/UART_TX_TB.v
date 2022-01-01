`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2021 08:05:34 PM
// Design Name: 
// Module Name: UART_TX_TB
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


module UART_TX_TB(

    );
    
  parameter c_CLKS_PER_BIT = 10417;
  parameter c_CLK_PERIOD_NS = 10;
     
    
    reg r_Clk = 0;
    
    wire w_RX_Data_In; //changed from reg
    reg r_TX_DV = 0;
    reg [7:0] r_TX_Byte = 0;
    wire w_TX_Serial; //changed from reg
    
    
    wire w_RX_DV;
    wire [7:0] w_RX_Byte;
    wire w_TX_Active;
    wire w_TX_Done;
    
    
    
    UART_RX #(.g_CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_inst
    (
        .i_Clk(r_Clk),
        .i_RX_Serial(w_RX_Data_In),
        .o_RX_DV(w_RX_DV),
        .o_RX_Byte(w_RX_Byte)

    );
    
    UART_TX #(.g_CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_inst
    (
        .i_clk(r_Clk),
        .i_TX_DV(r_TX_DV),
        .i_TX_Byte(r_TX_Byte),
        .o_TX_Active(w_TX_Active),
        .o_TX_Serial(w_TX_Serial),
        .o_TX_Done(w_TX_Done)
    
    );
    
    assign w_RX_Data_in = w_TX_Active ? w_TX_Serial : 1'b1;
    
    always #(c_CLK_PERIOD_NS/2) r_Clk <= !r_Clk;
    
    initial 
        begin
        
        @(posedge(r_Clk));
        @(posedge(r_Clk));
        r_TX_DV <= 1'b1;
        r_TX_Byte <= 8'h37;
        @(posedge(r_Clk));
        r_TX_DV <= 1'b0;
        @(posedge(w_RX_DV));
        if (w_RX_Byte == 8'h37)
            $display("Simulation Successful - Correct Bytes Passed");
        else
            $display("Simulation Failure - Inccorect Bytes Passed");
        
        $finish();
        
        
        end
    
endmodule










