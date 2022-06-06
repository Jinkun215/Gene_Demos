`timescale 1ns / 1ps


module Seven_Segment_Display
(
    input i_Clk,
    input [7:0] i_Byte_Data,
    output [6:0] o_Segment_Display
);

    reg [7:0] r_Segment_Display = 0;

    always@(posedge(i_Clk)) begin
    
        case (i_Byte_Data)                          //Format:  8 bits -> xGFEDCBA
                                                    //Case 0 to 15, turn off Display if other
            4'b0000: r_Segment_Display <= 8'h3F;    
            4'b0001: r_Segment_Display <= 8'h06;    
            4'b0010: r_Segment_Display <= 8'h5B;
            4'b0011: r_Segment_Display <= 8'h4F;
            
            4'b0100: r_Segment_Display <= 8'h66;
            4'b0101: r_Segment_Display <= 8'h6D;
            4'b0110: r_Segment_Display <= 8'h7D;
            4'b0111: r_Segment_Display <= 8'h07;
            
            4'b1000: r_Segment_Display <= 8'h7F;
            4'b1001: r_Segment_Display <= 8'h6F;
            4'b1010: r_Segment_Display <= 8'h77;
            4'b1011: r_Segment_Display <= 8'h7C;
            
            4'b1100: r_Segment_Display <= 8'h39;
            4'b1101: r_Segment_Display <= 8'h5E ;
            4'b1110: r_Segment_Display <= 8'h79;
            4'b1111: r_Segment_Display <= 8'h71;
            
            default: r_Segment_Display <= 8'h00;
        
        endcase
    
    end
    
    assign o_Segment_Display = ~r_Segment_Display[6:0];    


endmodule