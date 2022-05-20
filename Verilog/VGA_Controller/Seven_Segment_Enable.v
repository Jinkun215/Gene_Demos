`timescale 1ns / 1ps




module Seven_Segment_Enable(

    input i_Clk,
    input [6:0] i_Segment_1,
    input [6:0] i_Segment_2,
    output [6:0] o_Segment_Display,
    output [7:0] o_Segment_En

    );
    
    parameter counter_Limit = 100000;       //Slow downt the cycle
    integer counter = 0;
    
    reg r_SW = 1'b0;
    reg [6:0] r_Segment_Display;
    reg [7:0] r_Segment_En;
    

    
    always@(posedge(i_Clk))
    begin
      
        
      
        if (counter < counter_Limit) begin
            counter <= counter + 1;
        end      
        else begin
            
            counter <= 0;
            
            if (r_SW == 1'b0) begin                 //When Switch = 0, Only show Segment 1
                r_Segment_Display <= i_Segment_1;
                r_Segment_En <= 8'b11111110;                
                r_SW <= ~r_SW;
            end
            else begin
                r_Segment_Display <= i_Segment_2;       //When Switch = 1, Only show Segment 2
                r_Segment_En <= 8'b11111101;      
                r_SW <= ~r_SW;
            end

        end
    
    end
    
    assign o_Segment_Display = r_Segment_Display;
    assign o_Segment_En = r_Segment_En;
    
    
endmodule



























