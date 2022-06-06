`timescale 1ns /1ps



module FIFO_8x16
#(
    parameter g_DATA_SIZE = 8,
    parameter g_FIFO_SIZE = 16
)
(
    input i_Clk,
    input [g_DATA_SIZE-1:0] i_Data_Write,
    input i_Reset,
    input i_Switch_Rd_Wr,       //Read = '0', Write = '1'
    input i_Btn_Next,
    
    output reg o_FIFO_Empty,
    output reg o_FIFO_Full,
    output reg [g_DATA_SIZE-1:0] o_Data_Read
);

    wire r_Btn_Next;
    integer int_FIFO_Index = 0;
    reg prev_Switch = 0;
    
    reg [g_FIFO_SIZE-1:0] FIFO_DATA[g_DATA_SIZE-1:0] = 0;

    always@(posedge(i_Clk)) begin
    
        if (i_Reset == 1'b1) begin
        
            o_FIFO_Empty <= 1'b1;
            o_FIFO_Full <= 0;
            int_FIFO_Index <= 0;
        
        end //if (i_Reset == 1'b1) is True
        else begin
        
            if (r_Btn_Next == 1'b1 && prev_Switch == 1'b0) begin
            
                if (i_Switch_Rd_Wr == 1'b0 && o_FIFO_Empty != 1'b1) begin                           //Read = '0', Write = '1'
            
                         o_Data_Read <= FIFO_DATA[int_FIFO_Index-1];
                         int_FIFO_Index <= int_FIFO_Index - 1;
            
                end
                else if (i_Switch_Rd_Wr == 1'b1 && o_FIFO_Full != 1'b1) begin                       //Read = '0', Write = '1'
                
                        FIFO_DATA[int_FIFO_Index] <= i_Data_Write;
                        int_FIFO_Index <= int_FIFO_Index + 1;
                end

        
            end //if ((r_Btn_Next == 1'b1 && prev_Switch == 1'b0)) is True
            
            if (int_FIFO_Index == 0)
                o_FIFO_Empty <= 1'b1;
            else 
                o_FIFO_Empty <= 1'b0;
                
            if (int_FIFO_Index == g_FIFO_SIZE)
                o_FIFO_Full <= 1'b1;
            else
                o_FIFO_Full <= 1'b0;
            
            prev_Switch <= r_Btn_Next;
        
        end //if (i_Reset == 1'b1) is False
    end


    Debouncer
    Debouncer_Inst
    (
        .i_Clk(i_Clk),
        .i_Btn(i_Btn_Next),
        .o_Btn(r_Btn_Next)
    );


endmodule

















