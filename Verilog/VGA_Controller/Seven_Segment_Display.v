`timescale 1ns / 1ps


module Seven_Segment_Display(

    input i_Clk,
    input [3:0] i_Byte,
    output [6:0] o_Segment
    );
    
    reg [7:0] r_Segment = 0;
    
    always@(posedge(i_Clk))
    begin
        
        
        //Ports in order: XGFEDCBA
        case (i_Byte)
            4'b0000: r_Segment <= 8'h3F;    //case 0
            4'b0001: r_Segment <= 8'h06;    //case 1
            4'b0010: r_Segment <= 8'h5B;    //case 2
            4'b0011: r_Segment <= 8'h4F;    //case 3
            
            4'b0100: r_Segment <= 8'h66;    //case 4
            4'b0101: r_Segment <= 8'h6D;    //case 5
            4'b0110: r_Segment <= 8'h7D;    //case 6
            4'b0111: r_Segment <= 8'h07;    //case 7
            
            4'b1000: r_Segment <= 8'h7F;    //case 8
            4'b1001: r_Segment <= 8'h6F;    //case 9
            4'b1010: r_Segment <= 8'h77;    //case 10 A
            4'b1011: r_Segment <= 8'h7C;    //case 11 B
            
            4'b1100: r_Segment <= 8'h39;    //case 12 C
            4'b1101: r_Segment <= 8'h5E;    //case 13 D
            4'b1110: r_Segment <= 8'h79;    //case 14 E
            4'b1111: r_Segment <= 8'h71;    //case 15 F
            
            default: r_Segment <= 8'h00;    //default case
        
        endcase
    
    end
    
    assign o_Segment = ~r_Segment[6:0];
    
endmodule
