`timescale 1ns / 1ps



module UART_RX
    #(
        parameter g_Clks_Per_Bit = 217   // Desired Amount = Clock Frequency (PLL) / UART Frequency = 25Mhz / 115200 = 217
    )
    (

    input i_Clk,
    input i_RX_Serial,                  //Input from Computer using COM Port
    output o_RX_DV,                     //Outputs bit to communicate a byte has been read
    output [7:0] o_RX_Byte              
    );
    
    parameter s_Idle = 3'b000;          //Create States for Finite State Machines
    parameter s_Start_Bit = 3'b001;
    parameter s_Data_Bits = 3'b010;
    parameter s_Stop_Bit = 3'b011;
    parameter s_Cleanup = 3'b100;
    
    reg [2:0] current_State = s_Idle;
    reg [7:0] r_RX_Byte = 0;
    reg r_RX_DV = 0;
    integer index = 0;
    integer clk_Counter = 0;
    
    always@(posedge(i_Clk))
    begin
        case (current_State)
        
            s_Idle: begin               //At s_Idle, set r_RX_DV to 0, index to 0, counter to 0
                                        //Waits for the first 0 bit to indicate a start
                r_RX_DV <= 0;
                index = 0;
                clk_Counter = 0;
                
                if (i_RX_Serial == 1'b0)
                    current_State <= s_Start_Bit;
                else
                    current_State <= s_Idle;
            end
            
            
            s_Start_Bit: begin                                      //Waits half of Clks per Bit cycle to get to the middle point of frequency period in order to read each bit at its halfway point
                if (clk_Counter < (g_Clks_Per_Bit-1)/2) begin
                    clk_Counter <= clk_Counter + 1;
                    current_State <= s_Start_Bit;
                end
                else begin                                  //After halfway point, reset counter, and make sure the first bit is still 0.
                    clk_Counter <= 0;                       //If it wasn't (error) return to Idle.  If its still 0, start change to s_Data_Bits
                    if (i_RX_Serial == 1'b0)
                        current_State <= s_Data_Bits;
                    else
                        current_State <= s_Idle;
                end
            end
            
            
            s_Data_Bits: begin                              //Waits for one period of Clks per Bit
                if (clk_Counter < g_Clks_Per_Bit-1) begin
                    clk_Counter <= clk_Counter + 1;
                    current_State <= s_Data_Bits;
                end
                else begin                                  //Read the data from RX_Serial and place it in r_RX_Byte[index]
                    r_RX_Byte[index] <= i_RX_Serial;        //if index < 7, repeat until r_RX_Byte is full
                    index <= index + 1;
                    clk_Counter <= 0;
                    if (index < 7) 
                        current_State <= s_Data_Bits;       //Change state when completed
                    else
                        current_State <= s_Stop_Bit;
                end
            end
            
            
            s_Stop_Bit: begin                               //Wait for one period of Clks per Bit
                if (clk_Counter < g_Clks_Per_Bit-1) begin
                    clk_Counter <= clk_Counter + 1;
                    current_State <= s_Stop_Bit;
                end
                else begin                                  //Finish by sending a bit out to r_RX_DV to indicate finish
                    clk_Counter <= 0;                       
                    r_RX_DV <= 1'b1;
                    current_State <= s_Cleanup;
                end
                
            end
            
            s_Cleanup: begin
                r_RX_DV <= 0;
                current_State <= s_Idle;
            end
            
            default: 
                current_State <= s_Idle;
                
        endcase
    
    end
            
    assign o_RX_DV = r_RX_DV;                                       
    assign o_RX_Byte = r_RX_Byte;
    
    
endmodule
