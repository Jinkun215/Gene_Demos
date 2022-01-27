----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2021 12:48:32 AM
-- Design Name: 
-- Module Name: UART_RX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


    --g_CLKS_PER_BIT = Frequency of Board / Baud Rate = 10E6 / 9600
    -- it's the number of clock cycles required to 'check' 1 bit of data from UART


entity UART_RX is

    generic (
        g_CLKS_PER_BIT: integer := 10417 
    );
    
    port (
    
        i_Clk: in std_logic;
        i_RX_Serial: in std_logic;
        o_RX_DV: out std_logic;
        o_RX_Byte: out std_logic_vector(7 downto 0)        
        
    );

end UART_RX;

    --Strategy = Build State Machine -> From Idle, wait for the start bit -> When detected read 8 bit data -> wait for stop big -> Reset


architecture Behavioral of UART_RX is

    type s_SM_Type is (s_Idle, s_RX_Start, s_RX_Data, s_RX_Stop, s_Cleanup);
    signal r_SM_Main: s_SM_Type := s_Idle;
    
    signal r_Clk_Count: integer range 0 to g_CLKS_PER_BIT-1 := 0;
    signal r_Bit_Index: integer range 0 to 7 := 0;
    signal r_RX_Byte: std_logic_vector(7 downto 0);
    signal r_RX_DV: std_logic;
    
    signal w_SM_Main: std_logic_vector(2 downto 0) := (others => '0');

begin

    p_UART_RX: process(i_Clk) is
    begin
    
        if (rising_edge(i_Clk)) then
        
            case (r_SM_Main) is
            
                when s_Idle => 
                
                    r_Clk_Count <= 0;
                    r_Bit_index <= 0;
                    r_RX_DV <= '0';
                
                    if (i_RX_Serial = '0') then     --Start bit is '0', not start if '1'
                        r_SM_Main <= s_RX_Start;
                    else
                        r_SM_Main <= s_Idle;
                    end if;
                
                when s_RX_Start => 
                
                    if (r_Clk_Count < (g_CLKS_PER_BIT-1)/2) then    --Checks need only middle of start binary_read
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_RX_Start;
                    else
                        if (i_RX_Serial = '0') then     --ensure start bit is still at '0'
                            r_Clk_Count <= 0;
                            r_SM_Main <= s_RX_Data; 
                        else
                            r_SM_Main <= s_Idle;
                        end if;                
                    
                    end if;
                
                
                when s_RX_Data => 
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1) then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_RX_Data;
                    else
                        r_RX_Byte(r_Bit_Index) <= i_RX_Serial;
                        r_Clk_Count <= 0;
                        
                        if (r_Bit_Index < 7) then
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= s_RX_Data;                            
                        else
                            r_Bit_Index <= 0;
                            r_SM_Main <= s_RX_Stop;
                        
                        end if;
                    end if;
                    
                when s_RX_Stop => 
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1) then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_RX_Stop;
                    else
                        r_Clk_Count <= 0;
                        r_RX_DV <= '1';             --stop bit = 1;
                        r_SM_Main <= s_Cleanup;
                        
                    end if;
                
                when s_Cleanup => 
                    r_RX_DV <= '0';
                    r_SM_Main <= s_Idle;
                    
                when others =>
                    r_SM_main <= s_Idle;
            
            end case;
        
        end if; --(rising_edge(i_Clk))
    
    end process p_UART_RX;
    
    o_RX_Byte <= r_RX_Byte;
    o_RX_DV <= r_RX_DV;
    
    w_SM_Main <= "000" when r_SM_Main = s_Idle else
                 "001" when r_SM_Main = s_RX_Start else
                 "010" when r_SM_Main = s_RX_Data else
                 "011" when r_SM_Main = s_RX_Stop else
                 "100" when r_SM_Main = s_Cleanup else
                 "101"; --101 is when its at Error

end Behavioral;




















