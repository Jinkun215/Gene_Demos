`timescale 1ns / 1ps


// g_CLKS_PER_BIT = FPGA CLock / Baud Rate = 10E6 / 9600 = 10417


module UART_RX

    #(
        parameter g_CLKS_PER_BIT = 10417
    )
    (
        input i_Clk,
        input i_RX_Serial,
        output o_RX_DV,
        output [7:0] o_RX_Byte
    );
    
    parameter s_Idle = 3'b000;
    parameter s_RX_Start = 3'b001;
    parameter s_RX_Data = 3'b010;
    parameter s_RX_Stop = 3'b011;
    parameter s_Cleanup = 3'b100;
    
    reg [2:0] r_SM_Main = s_Idle;
    reg [13:0] r_Clk_Count = 0;
    reg [2:0] r_Bit_Index = 0;
    reg r_RX_DV = 0;
    reg [7:0] r_RX_Byte = 0;
    
    
    always@(posedge(i_Clk))
    begin
    
        case (r_SM_Main)
            
            s_Idle:
            begin
                r_RX_DV <= 0;
                r_Clk_Count <= 0;
                r_Bit_Index <= 0;
                
                if (i_RX_Serial == 1'b0)
                    r_SM_Main <= s_RX_Start;
                else
                    r_SM_Main <= s_Idle;              
            end
            
            s_RX_Start:
            begin
                if (r_Clk_Count < (g_CLKS_PER_BIT-1)/2)
                begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main <= s_RX_Start;
                end                
                else
                begin
                    
                    if (i_RX_Serial == 1'b0)
                    begin
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_RX_Data;
                     end
                    else
                        r_SM_Main <= s_Idle;              
                end
            end
            
            s_RX_Data:
            begin
                if (r_Clk_Count < g_CLKS_PER_BIT-1)
                begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main <= s_RX_Data;
                end
                else
                begin
                    r_RX_Byte[r_Bit_Index] <= i_RX_Serial;
                    r_Clk_Count <= 0;
                    if (r_Bit_Index < 7)
                    begin
                        r_Bit_Index <= r_Bit_Index + 1; 
                        r_SM_Main <= s_RX_Data; 
                    end
                    else
                    begin
                        r_Bit_Index <= 0;
                        r_SM_Main <= s_RX_Stop;
                    end   
                end      
            end
            
            s_RX_Stop:
            begin
                if (r_Clk_Count < g_CLKS_PER_BIT-1)
                begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main <= s_RX_Stop;
                end
                else
                begin
                    r_Clk_Count <= 0;
                    r_RX_DV <= 1'b1;
                    r_SM_Main <= s_Cleanup;
                end
            end
            
            s_Cleanup:
            begin
                r_RX_DV <= 1'b0;
                r_SM_Main <= s_Idle;
            end
            
            default:
                r_SM_Main <= s_Idle;
        
        endcase
    
    end //posedge(i_Clk)
    
    assign o_RX_DV = r_RX_DV;
    assign o_RX_Byte = r_RX_Byte;
    
endmodule






