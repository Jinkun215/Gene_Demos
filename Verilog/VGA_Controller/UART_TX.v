`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2022 10:16:39 PM
// Design Name: 
// Module Name: UART_TX
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


module UART_TX
    #(
        parameter g_Clks_Per_Bit = 217   // Desired Amount = Clock Frequency (PLL) / UART Frequency = 25Mhz / 115200 = 217
    )
    (
        input i_Clk,
        input [7:0] i_Data_Byte,            
        input i_TX_DV,              //Used to indicate when to start transmitting
        
        output o_TX_Serial          //Sends 1 bit at a time
    );
    
    parameter s_Idle = 3'b000;      //Create States for Finite State 
    parameter s_Start_Bit = 3'b001;
    parameter s_Data_Bits = 3'b010;
    parameter s_Stop_Bit = 3'b011;
    parameter s_Cleanup = 3'b100;
    
    reg [2:0] Current_State = s_Idle;
    reg [7:0] r_Data_Byte = 0;
    reg r_TX_Serial = 1'b1;
    integer r_Clk_Counter = 0;
    integer r_Index = 0;
    
    always@(posedge(i_Clk)) begin
    
        case (Current_State) 
        
            s_Idle: begin                   //At s_Idle, set counter and index to 0.    Set r_TX_Serial to 1
                r_TX_Serial <= 1'b1;
                r_Clk_Counter <= 0;
                r_Index <= 0;
                
                if (i_TX_DV == 1'b1) begin          //When the UART_TX receive DV value from UART_RX, change state
                    r_Data_Byte <= i_Data_Byte;     //Load the Data into a register
                    Current_State <= s_Start_Bit;
                end
                else begin
                    Current_State <= s_Idle;
                end
            end
            
            s_Start_Bit: begin
                if (r_Clk_Counter < g_Clks_Per_Bit-1) begin         //wait for one period of CLocks per Bit
                    r_Clk_Counter <= r_Clk_Counter + 1;
                    Current_State <= s_Start_Bit;
                end
                else begin
                    r_Clk_Counter <= 0;                 //Set r_TX_Serial to indicate start bit
                    r_TX_Serial <= 1'b0;
                    Current_State <= s_Data_Bits;
                end
            end
            
            s_Data_Bits: begin
                if (r_Clk_Counter < g_Clks_Per_Bit-1) begin         //wait for one period of Clks per Bit
                    r_Clk_Counter <= r_Clk_Counter + 1;
                    Current_State <= s_Data_Bits;
                end
                else begin
                    r_TX_Serial <= r_Data_Byte[r_Index];            //Transmit each value of r_Data_Byte indicated by the index
                    r_Clk_Counter <= 0;
                    
                    if (r_Index < 7) begin                      //If index < 7, repeat until index = 7
                        r_Index <= r_Index + 1;
                        Current_State <= s_Data_Bits;
                    end
                    else begin
                        r_Index <= 0;
                        Current_State <= s_Stop_Bit;
                    end
                end
            end
            
            s_Stop_Bit: begin                                       //Wait for one period of Clks per Bit
                if (r_Clk_Counter < g_Clks_Per_Bit-1) begin
                    r_Clk_Counter <= r_Clk_Counter + 1;
                    Current_State <= s_Stop_Bit;
                end
                else begin                      //Set r_TX_Serial back to 1 to indicate idle
                    r_TX_Serial <= 1'b1;
                    r_Clk_Counter <= 0;
                    Current_State <= s_Cleanup;
                end
            end
            
            s_Cleanup: begin
                r_TX_Serial <= 1'b1;
                Current_State <= s_Idle;
            end
            
            default:
                Current_State <= s_Idle;
        
        endcase 
    
    end //end always@(posedge(i_Clk))
    
    assign o_TX_Serial = r_TX_Serial;
    
endmodule





















