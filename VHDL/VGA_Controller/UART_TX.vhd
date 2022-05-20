
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART_TX is
    generic (
        g_Clks_Per_Bit: integer:= 217         -- Desired integer = Clock Frequency (PLL) / UART frequency = 25Mhz (Clock Wizard) / 115200 = 217
    );
    port (
        i_Clk: in std_logic;
        i_Data_Byte: in std_logic_vector(7 downto 0);
        i_TX_DV: in std_logic;
        
        o_TX_Serial: out std_logic
    
    );

end UART_TX;



architecture RTL of UART_TX is

    type S_Type is (s_Idle, s_Start_Bit, s_Data_Bits, s_Stop_Bit, s_Cleanup);
    signal Current_State: S_Type:= s_Idle;
    
    signal r_Clk_Counter: integer range 0 to g_Clks_Per_Bit:= 0;
    signal r_Data_Byte: std_logic_vector(7 downto 0):= (others => '0');
    signal r_Index: integer range 0 to 7:= 0;
    signal r_TX_Serial: std_logic:= '1';
    
    


begin

    p_Main: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
        
            case (Current_State) is
            
                when s_Idle =>
                    r_Clk_Counter <= 0;
                    r_Index <= 0;
                    r_TX_Serial <= '1';                         -- 
                    
                    if (i_TX_DV = '1') then                     --Begin when DV from Receiver is 1
                        r_Data_Byte <= i_Data_Byte;
                        Current_State <= s_Start_Bit;
                    else
                        Current_State <= s_Idle;
                    end if;               
                
                when s_Start_Bit =>
                    
                    if (r_Clk_Counter < g_Clks_Per_Bit-1) then
                        r_Clk_Counter <= r_Clk_Counter + 1;
                        Current_State <= s_Start_Bit;
                    else
                        r_TX_Serial <= '0';                         -- r_TX_Serial = 0 indicates start
                        r_Clk_Counter <= 0;
                        Current_State <= s_Data_Bits;
                    end if;                  
                    
                when s_Data_Bits =>
                    
                    
                    if (r_Clk_Counter < g_Clks_Per_Bit-1) then
                        r_Clk_Counter <= r_Clk_Counter + 1;
                        Current_State <= s_Data_Bits;
                    else
                        r_Clk_Counter <= 0;
                        r_TX_Serial <= r_Data_Byte(r_Index);

                        if (r_Index < 7) then
                            r_Index <= r_Index + 1;
                            Current_State <= s_Data_Bits;
                        else
                            r_Index <= 0;
                            Current_State <= s_Stop_Bit;
                        end if;                  
                    
                    end if;
                                    
                when s_Stop_Bit =>
                    
                    
                    if (r_Clk_Counter < g_Clks_Per_Bit-1) then
                        r_Clk_Counter <= r_Clk_Counter + 1;
                        Current_State <= s_Stop_Bit;
                    else
                        r_Clk_Counter <= 0;
                        Current_State <= s_Cleanup;
                        r_TX_Serial <= '1';
                    end if;
                
                when s_Cleanup =>
                    r_TX_Serial <= '1';
                    Current_State <= s_Idle;

                when others =>
                    Current_State <= s_Idle;
            
            end case;
        
        end if; -- if rising_edge(i_Clk)
    
    end process p_Main;

    o_TX_Serial <= r_TX_Serial;
    
end RTL;
















