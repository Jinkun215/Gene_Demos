

library IEEE;
use IEEE.std_logic_1164.all;


entity UART_RX is

    generic(
        g_Clks_Per_Bit: integer:= 217      -- Desired Amount = Frequency of Clk / Frequency of UART = 25Mhz / 115200 = 217
    );
    port (
        i_Clk: in std_logic;
        i_RX_Serial: in std_logic;
        o_RX_DV: out std_logic;
        o_RX_Byte: out std_logic_vector(7 downto 0)
    );

end UART_RX;



architecture RTL of UART_RX is

    type S_Type is (s_Idle, s_Start_Bit, s_Data_Bits, s_Stop_Bit, s_Cleanup);
    signal Current_State: S_Type:= s_Idle;
    
   
    signal r_RX_DV: std_logic:= '0';
    signal r_RX_Byte: std_logic_vector(7 downto 0):= (others => '0');
    
    signal r_Clk_Counter: integer range 0 to g_Clks_Per_Bit-1:= 0;
    signal r_Index: integer range 0 to 7:= 0;

begin

    p_Main: process(i_Clk) is
    begin
    
        if (rising_edge(i_Clk)) then
        
            case (Current_State) is
            
                when s_Idle =>
                    
                    r_RX_DV <= '0';
                    r_Clk_Counter <= 0;
                    r_Index <= 0;
                    
                    if (i_RX_Serial = '0') then                 --Wait until start bit (0 means begin)
                        Current_State <= s_Start_Bit;
                    else
                        Current_State <= s_Idle;
                    end if;       
                
                
                when s_Start_Bit =>
                    if (r_Clk_Counter < (g_Clks_Per_Bit-1)/2) then      --Wait until half of the Clks per Bit period so can read data at halfway poitn each time
                        r_Clk_Counter <= r_Clk_Counter + 1;
                        Current_State <= s_Start_Bit;
                    else
                        r_Clk_Counter <= 0;
                        if (i_RX_Serial = '0') then                 -- If start was not an error (not 0), start reading the Data.
                            Current_State <= s_Data_Bits;
                        else
                            Current_State <= s_Idle;
                        end if;   
                    end if;
                    
                when s_Data_Bits =>
                    if (r_Clk_Counter < g_Clks_Per_Bit-1) then          
                        r_Clk_Counter <= r_Clk_Counter + 1;
                        Current_State <= s_Data_Bits;
                    else
                        r_RX_Byte(r_Index) <= i_RX_Serial;          --Read each data one Clks per Bit cycle at a time until index = 7
                        r_Index <= r_Index + 1;
                        r_Clk_Counter <= 0;
                        if (r_Index < 7) then
                            Current_State <= s_Data_Bits;
                        else
                            Current_State <= s_Stop_Bit;
                        end if;
                   
                    end if;
                    
                    
                when s_Stop_Bit =>                                  
                    if (r_Clk_Counter < g_Clks_Per_Bit-1) then
                        r_Clk_Counter <= r_Clk_Counter + 1;
                        Current_State <= s_Stop_Bit;
                    else
                        r_Clk_Counter <= 0;                         -- When complete, send out an r_RX_DV bit to indicate finish
                        r_RX_DV <= '1';
                        Current_State <= s_Cleanup;
                    end if;

                when s_Cleanup =>
                    r_RX_DV <= '0';
                    Current_State <= s_Idle;
                    
                when others =>
                    Current_State <= s_Idle;
            
            end case;        
        
        end if; --if (rising_edge(i_Clk))
    
    end process p_Main;

    o_RX_DV <= r_RX_DV;
    o_RX_Byte <= r_RX_Byte;

end RTL;















