`timescale 1ns / 1ps

module UART_TX 

#(
    parameter g_CLKS_PER_BIT = 10417
)
(
    input i_clk,
    input i_TX_DV,
    input [7:0] i_TX_Byte,
    output o_TX_Active,
    output reg o_TX_Serial,
    output o_TX_Done
);

    parameter s_Idle = 3'b000;
    parameter s_TX_Start = 3'b001;
    parameter s_TX_Data = 3'b010;
    parameter s_TX_Stop = 3'b011;
    parameter s_Cleanup = 3'b100;
    
    reg [2:0] r_SM_Main = s_Idle;
    reg [13:0] r_Clk_Count = 0;
    reg [2:0] r_Bit_Index = 0;
    reg [7:0] r_TX_Byte = 0; 
    reg r_TX_Active = 0;
    reg r_TX_Done = 0;
    
    
    always@(posedge(i_clk))
    begin
    
        case (r_SM_Main)
        
            s_Idle:
                begin
                
                o_TX_Serial <= 1'b1;
                r_TX_Done <= 1'b0;
                r_Clk_Count <= 0;
                r_Bit_Index <= 0;
                
                if (i_TX_DV == 1'b1)
                    begin
                    r_TX_Active <= 1'b1;
                    r_TX_Byte <= i_TX_Byte;
                    r_SM_Main <= s_TX_Start;
                    end
                else
                    r_SM_Main <= s_Idle;
                    
                end
                
            s_TX_Start:
                begin
                    
                    o_TX_Serial <= 1'b0;
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1)
                    begin
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Start;
                    end
                    
                    else
                    begin
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_TX_Data;
                    end
                end
                
            s_TX_Data:
                begin
                    o_TX_Serial <= r_TX_Byte[r_Bit_Index];
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1)
                        begin
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Data;
                        end
                        
                    else
                    begin
                        r_Clk_Count <= 0;
                        if (r_Bit_Index < 7)
                            begin
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= s_TX_Data;
                            end
                            
                        else
                            begin
                            r_Bit_Index <= 0;
                            r_SM_Main <= s_TX_Stop;
                            end
                    end
                end
                
            s_TX_Stop:
                begin
                o_TX_Serial <= 1'b1;
                
                if (r_Clk_Count < g_CLKS_PER_BIT-1)
                    begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main <= s_TX_Stop;
                    end
                
                else
                    begin
                    r_TX_Done <= 1'b1;
                    r_Clk_Count <= 0;
                    r_SM_Main <=s_Cleanup;
                    r_TX_Active <= 1'b0;
                    end
                
                end
                
            s_Cleanup:
                begin
                r_TX_Done <= 1'b1;
                r_Clk_Count <= 0;
                r_SM_Main <= s_Idle;
                end
                
            default:
                r_SM_Main <= s_Idle;
        endcase    
    
    end
    
    assign o_TX_Active = r_TX_Active;
    assign o_TX_Done = r_TX_Done;
    
endmodule










