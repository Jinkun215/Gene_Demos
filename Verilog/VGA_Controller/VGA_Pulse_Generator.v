`timescale 1ns / 1ps

module VGA_Pulse_Generator
    #(
        parameter g_Total_Col = 800,        //VGA Resolution size for Active 640 x 480 Screen
        parameter g_Active_Col = 640,       //  Full 800 x 525 pixel
        
        parameter g_Total_Row = 525,        
        parameter g_Active_Row = 480,
        
        parameter g_Front_Col = 18,         //VGA Front Porch and Back Porch Pixel numbers
        parameter g_Front_Row = 10,
        
        parameter g_Back_Col = 50,
        parameter g_Back_Row = 33
    )
    (
        input i_Clk,
        output reg o_HSync,
        output reg o_VSync
        
    
    );
    
    wire [9:0] w_Col_Counter;
    wire [9:0] w_Row_Counter;
    
    
    
    always@(posedge(i_Clk)) begin                               //See VGA Front Proch, Back Porch detail on internet search for details
                                                                //Basically Sync = 1 when Counter is within Active Portion + porch section of VGA
        if (w_Col_Counter < g_Active_Col + g_Front_Col)         //and Sync = 0 when Counter is in the Blank section of VGA
            o_HSync <= 1'b1;
        else if (w_Col_Counter > g_Total_Col - 1 - g_Back_Col)
            o_HSync <= 1'b1;
        else
            o_HSync <= 1'b0;
            
        if (w_Row_Counter < g_Active_Row + g_Front_Row)
            o_VSync <= 1'b1;
        else if (w_Row_Counter > g_Total_Row - 1 - g_Back_Row)
            o_VSync <= 1'b1;
        else
            o_VSync <= 1'b0;
    
    end
    
    
    
    Sync_Counter                    //Instantiate Sync_Counter
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