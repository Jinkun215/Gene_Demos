`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2022 10:06:10 PM
// Design Name: 
// Module Name: VGA_Sync_Pulses
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


module VGA_Sync_Pulses
    #(
        parameter g_VIDEO_WIDTH = 3,
        parameter g_TOTAL_COLS = 800,
        parameter g_TOTAL_ROWS = 525,
        parameter g_ACTIVE_COLS = 640,
        parameter g_ACTIVE_ROWS = 480
    )
    (
    input i_Clk_Real,
    input [1:0] i_Switch,
    
    output o_HSync,
    output o_VSync,
    output [g_VIDEO_WIDTH-1:0] o_RED,
    output [g_VIDEO_WIDTH-1:0] o_GRN,
    output [g_VIDEO_WIDTH-1:0] o_BLU
    );
    
    wire w_Clk;
    
    integer int_Col_Count = 0;
    integer int_Row_Count = 0;
    
    reg [g_VIDEO_WIDTH-1:0] pattern_Red;
    reg [g_VIDEO_WIDTH-1:0] pattern_Grn;
    reg [g_VIDEO_WIDTH-1:0] pattern_Blu;
    
    
    // "Slow down" frequency by 2*value -> in this case 25Mhz
    Frequency_Divider #(.Divider_Value(2)) Frequency_Divider_Inst
    (
        .i_Clk_Real(i_Clk_Real),
        .o_Clk_Divided(w_Clk)
    );
    
    always@(posedge(w_Clk)) begin
        
        if (int_Col_Count == g_TOTAL_COLS-1) begin
        
            if (int_Row_Count == g_TOTAL_ROWS-1)
                int_Row_Count <= 0;
            else
                int_Row_Count <= int_Row_Count + 1;
                
            int_Col_Count <= 0;
            
            end
        
        else
            int_Col_Count <= int_Col_Count + 1;

    end //end alwasy@posedge
    
    always@(posedge(w_Clk)) begin
    
        // ALL WHITE
        if (i_Switch == 2'b00) begin
    
            if (int_Col_Count < g_ACTIVE_COLS && int_Row_Count < g_ACTIVE_ROWS) begin
                pattern_Red <= 3'b111;
                pattern_Grn <= 3'b111;
                pattern_Blu <= 3'b111;
            end
            
            else begin
                pattern_Red <= 3'b000;
                pattern_Grn <= 3'b000;
                pattern_Blu <= 3'b000;
            end
        end
        
        // ALL RED
        else if (i_Switch == 2'b01) begin
    
            if (int_Col_Count < g_ACTIVE_COLS && int_Row_Count < g_ACTIVE_ROWS) begin
                pattern_Red <= 3'b111;
                pattern_Grn <= 3'b000;
                pattern_Blu <= 3'b000;
            end
            
            else begin
                pattern_Red <= 3'b000;
                pattern_Grn <= 3'b000;
                pattern_Blu <= 3'b000;
            end
        end
        
        // ALL GREEN
        else if (i_Switch == 2'b10) begin
    
            if (int_Col_Count < g_ACTIVE_COLS && int_Row_Count < g_ACTIVE_ROWS) begin
                pattern_Red <= 3'b000;
                pattern_Grn <= 3'b111;
                pattern_Blu <= 3'b000;
            end
            
            else begin
                pattern_Red <= 3'b000;
                pattern_Grn <= 3'b000;
                pattern_Blu <= 3'b000;
            end
        end
        
        // ALL BLUE
        else begin
    
            if (int_Col_Count < g_ACTIVE_COLS && int_Row_Count < g_ACTIVE_ROWS) begin
                pattern_Red <= 3'b000;
                pattern_Grn <= 3'b000;
                pattern_Blu <= 3'b111;
            end
            
            else begin
                pattern_Red <= 3'b000;
                pattern_Grn <= 3'b000;
                pattern_Blu <= 3'b000;
            end
        end
    
    end //end always@posedge
    
    
    assign o_HSync = int_Col_Count < g_ACTIVE_COLS ? 1'b1 : 1'b0;
    assign o_VSync = int_Row_Count < g_ACTIVE_ROWS ? 1'b1 : 1'b0;
    
    assign o_RED = pattern_Red;
    assign o_GRN = pattern_Grn;
    assign o_BLU = pattern_Blu;
    
    
    
endmodule











