`timescale 1ns / 1ps



module TOP 
#(
    parameter g_Clks_Per_Bit = 217,     //UART Frequency = Clock Frequency / Baud Rate = 25Mhz (PPL) / 115200 = 217
    parameter g_Video_Width = 3,        //Set Video width size, only using [2:0] instead of [3:0]
        
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
    input i_RX_Serial,
    
    output o_TX_Serial,
    
    output o_HSync,
    output o_VSync,
    output [g_Video_Width-1:0] o_Pattern_Red,
    output [g_Video_Width-1:0] o_Pattern_Grn,
    output [g_Video_Width-1:0] o_Pattern_Blu,
    
    output [6:0] o_Segment_Display,
    output [7:0] o_Segment_Enable

);

    wire w_Clk;
    wire w_UART_DV;
    wire [7:0] w_UART_Data_Byte;
    wire [6:0] w_Segment_Display_1;
    wire [6:0] w_Segment_Display_2;
    
    clk_wiz_0 clk_wiz_0_Inst
    (
    .clk_out_25M(w_Clk),     // output clk_out_25M
    .clk_in_100M(i_Clk));      // input clk_in_100M


    UART_RX         //Instantiate UART Receiver
    #(
        .g_Clks_Per_Bit(g_Clks_Per_Bit)
    )
     UART_RX_Inst
    (
        .i_Clk(w_Clk),
        .i_RX_Serial(i_RX_Serial),
        .o_RX_DV(w_UART_DV),
        .o_RX_Byte(w_UART_Data_Byte)
    );
    
    UART_TX         //Instantiate UART Transmitter
    #(
        .g_Clks_Per_Bit(g_Clks_Per_Bit)
    )
     UART_TX_Inst
    (
        .i_Clk(w_Clk),
        .i_Data_Byte(w_UART_Data_Byte),
        .i_TX_DV(w_UART_DV),
        .o_TX_Serial(o_TX_Serial)
    );
    
    Seven_Segment_Display Seven_Segment_Display_Inst_1      //Instantiate Seven Segment Display of Segment 1
    (
        .i_Clk(w_Clk),
        .i_Byte(w_UART_Data_Byte[3:0]),
        .o_Segment(w_Segment_Display_1)
    );
    
   Seven_Segment_Display Seven_Segment_Display_Inst_2       //Instantiate Seven Segment Display of Segment 2
    (
        .i_Clk(w_Clk),
        .i_Byte(w_UART_Data_Byte[7:4]),
        .o_Segment(w_Segment_Display_2)
    );
    
    Seven_Segment_Enable Seven_Segment_Enable_Inst          //Instantiate Seven Segment Display Enabler
    (
        .i_Clk(w_Clk),
        .i_Segment_1(w_Segment_Display_1),
        .i_Segment_2(w_Segment_Display_2),
        .o_Segment_Display(o_Segment_Display),
        .o_Segment_En(o_Segment_Enable)
    );
    
    VGA_Pulse_Generator                     //Instantiate VGA Pulse Generator
    #(
        .g_Total_Col(g_Total_Col),
        .g_Active_Col(g_Active_Col),
        
        .g_Total_Row(g_Total_Row),
        .g_Active_Row(g_Active_Row),
        
        .g_Front_Col(g_Front_Col),
        .g_Front_Row(g_Front_Row),
        
        .g_Back_Col(g_Back_Col),
        .g_Back_Row(g_Back_Row)
    )
    VGA_Pulse_Generator_Inst
    (
        .i_Clk(w_Clk),
        .o_HSync(o_HSync),
        .o_VSync(o_VSync)
    );
    
    VGA_Pattern_Generator               //Instantiate VGA Pattern Generaton
    #(
        .g_Video_Width(g_Video_Width),
        .g_Total_Col(g_Total_Col),
        .g_Active_Col(g_Active_Col),
        
        .g_Total_Row(g_Total_Row),
        .g_Active_Row(g_Active_Row),
        
        .g_Front_Col(g_Front_Col),
        .g_Front_Row(g_Front_Row),
        
        .g_Back_Col(g_Back_Col),
        .g_Back_Row(g_Back_Row)
    )
    VGA_Pattern_Generator_Inst
    (
        .i_Clk(w_Clk),
        .i_Pattern_Sel(w_UART_Data_Byte[2:0]),
        .o_Pattern_Red(o_Pattern_Red),
        .o_Pattern_Grn(o_Pattern_Grn),
        .o_Pattern_Blu(o_Pattern_Blu)
    );

endmodule



















