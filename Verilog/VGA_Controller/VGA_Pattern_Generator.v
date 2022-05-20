`timescale 1ns / 1ps

module VGA_Pattern_Generator
    #(
        parameter g_Video_Width = 3,        //Set Video width size, only using [2:0] instead of [3:0]
        
        parameter g_Total_Col = 800,
        parameter g_Active_Col = 640,
        
        parameter g_Total_Row = 525,            //VGA Resolution size for Active 640 x 480 Screen
        parameter g_Active_Row = 480,           //  Full 800 x 525 pixel
        
        parameter g_Front_Col = 18,         //VGA Front Porch and Back Porch Pixel numbers
        parameter g_Front_Row = 10,
            
        parameter g_Back_Col = 50,
        parameter g_Back_Row = 33
    )
    (
        input i_Clk,
        input [2:0] i_Pattern_Sel,
        output reg [g_Video_Width-1:0] o_Pattern_Red,
        output reg [g_Video_Width-1:0] o_Pattern_Grn,
        output reg [g_Video_Width-1:0] o_Pattern_Blu

    
    );
    
    wire [9:0] w_Col_Counter;
    wire [9:0] w_Row_Counter;
    
    wire [g_Video_Width-1:0] pattern_Red[0:7];         //Create an Array that holds 8 patterns for each colr
    wire [g_Video_Width-1:0] pattern_Grn[0:7];
    wire [g_Video_Width-1:0] pattern_Blu[0:7];
    
    wire [2:0] color_Sel;

        always@(posedge(i_Clk)) begin
    
            case (i_Pattern_Sel)    //i_Pattern_Sel takes the 3 bits of Data received from UART
                3'b000: begin o_Pattern_Red <= pattern_Red[0]; o_Pattern_Grn <= pattern_Grn[0]; o_Pattern_Blu <= pattern_Blu[0]; end      
                      
                3'b001: begin o_Pattern_Red <= pattern_Red[1]; o_Pattern_Grn <= pattern_Grn[1]; o_Pattern_Blu <= pattern_Blu[1]; end      
                
                3'b010: begin o_Pattern_Red <= pattern_Red[2]; o_Pattern_Grn <= pattern_Grn[2]; o_Pattern_Blu <= pattern_Blu[2]; end      
                
                3'b011: begin o_Pattern_Red <= pattern_Red[3]; o_Pattern_Grn <= pattern_Grn[3]; o_Pattern_Blu <= pattern_Blu[3]; end      
                
                3'b100: begin o_Pattern_Red <= pattern_Red[4]; o_Pattern_Grn <= pattern_Grn[4]; o_Pattern_Blu <= pattern_Blu[4]; end      
                
                3'b101: begin o_Pattern_Red <= pattern_Red[5]; o_Pattern_Grn <= pattern_Grn[5]; o_Pattern_Blu <= pattern_Blu[5]; end      
                
                3'b110: begin o_Pattern_Red <= pattern_Red[6]; o_Pattern_Grn <= pattern_Grn[6]; o_Pattern_Blu <= pattern_Blu[6]; end      
                
                3'b111: begin o_Pattern_Red <= pattern_Red[7]; o_Pattern_Grn <= pattern_Grn[7]; o_Pattern_Blu <= pattern_Blu[7]; end      
                
                default: begin o_Pattern_Red <= pattern_Red[0]; o_Pattern_Grn <= pattern_Grn[0]; o_Pattern_Blu <= pattern_Blu[0]; end 
            
            endcase    
            
        end
    

    
    // Pattern 0: All White
        assign pattern_Red[0] = (w_Col_Counter < g_Active_Col && w_Row_Counter < g_Active_Row) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Grn[0] = (w_Col_Counter < g_Active_Col && w_Row_Counter < g_Active_Row) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Blu[0] = (w_Col_Counter < g_Active_Col && w_Row_Counter < g_Active_Row) ? {g_Video_Width{1'b1}} : 0;
    
    // Pattern 1: All Red
        assign pattern_Red[1] = (w_Col_Counter < g_Active_Col && w_Row_Counter < g_Active_Row) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Grn[1] = 0;
        assign pattern_Blu[1] = 0;
        
    // Pattern 2: All Green
        assign pattern_Red[2] = 0;
        assign pattern_Grn[2] = (w_Col_Counter < g_Active_Col && w_Row_Counter < g_Active_Row) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Blu[2] = 0;
        
    // Pattern 3: All Blue
        assign pattern_Red[3] = 0;
        assign pattern_Grn[3] = 0;
        assign pattern_Blu[3] = (w_Col_Counter < g_Active_Col && w_Row_Counter < g_Active_Row) ? {g_Video_Width{1'b1}} : 0;
    
    // Pattern 4: Checker Board Large
        assign pattern_Red[4] = (w_Col_Counter[7] == 1'b1 ^ w_Row_Counter[7] == 1'b0) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Grn[4] = (w_Col_Counter[7] == 1'b1 ^ w_Row_Counter[7] == 1'b0) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Blu[4] = (w_Col_Counter[7] == 1'b1 ^ w_Row_Counter[7] == 1'b0) ? {g_Video_Width{1'b1}} : 0;
        
    // Pattern 5: Checker Board Small
        assign pattern_Red[5] = (w_Col_Counter[5] == 1'b1 ^ w_Row_Counter[5] == 1'b0) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Grn[5] = (w_Col_Counter[5] == 1'b1 ^ w_Row_Counter[5] == 1'b0) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Blu[5] = (w_Col_Counter[5] == 1'b1 ^ w_Row_Counter[5] == 1'b0) ? {g_Video_Width{1'b1}} : 0;
    
    // Pattern 6: Color Bars
        assign color_Sel =  (w_Col_Counter < g_Active_Col / 8 * 1) ? 0 :
                            (w_Col_Counter < g_Active_Col / 8 * 2) ? 1 :
                            (w_Col_Counter < g_Active_Col / 8 * 3) ? 2 :
                            (w_Col_Counter < g_Active_Col / 8 * 4) ? 3 :
                            (w_Col_Counter < g_Active_Col / 8 * 5) ? 4 :
                            (w_Col_Counter < g_Active_Col / 8 * 6) ? 5 :
                            (w_Col_Counter < g_Active_Col / 8 * 7) ? 6 : 7;
                            
        assign pattern_Red[6] = (color_Sel == 4 | color_Sel == 5 | color_Sel == 6 | color_Sel == 7) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Grn[6] = (color_Sel == 2 | color_Sel == 3 | color_Sel == 6 | color_Sel == 7) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Blu[6] = (color_Sel == 1 | color_Sel == 3 | color_Sel == 5 | color_Sel == 7) ? {g_Video_Width{1'b1}} : 0;
    
    // Pattern 7: Col Pattern
    
        assign pattern_Red[7] = (w_Col_Counter[4] == 1'b0 ^ w_Row_Counter[2] == 1'b1) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Grn[7] = (w_Col_Counter[5] == 1'b0 ^ w_Row_Counter[3] == 1'b1) ? {g_Video_Width{1'b1}} : 0;
        assign pattern_Blu[7] = (w_Col_Counter[6] == 1'b0 ^ w_Row_Counter[4] == 1'b1) ? {g_Video_Width{1'b1}} : 0;
    

    
    Sync_Counter        //Initiate Sync_Counter
    #(
        .g_Total_Col(g_Total_Col),
        .g_Total_Row(g_Total_Row)
    )
    Sync_Counter_Inst
    (
        .i_Clk(i_Clk),
        .o_Col_Counter(w_Col_Counter),
        .o_Row_Counter(w_Row_Counter)
    );
    
    
endmodule