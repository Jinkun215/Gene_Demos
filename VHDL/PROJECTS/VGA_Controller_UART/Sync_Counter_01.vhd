----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2022 01:55:20 AM
-- Design Name: 
-- Module Name: Sync_Counter_01 - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sync_Counter_01 is

    generic (
        g_TOTAL_COLS: integer:= 800;
        g_TOTAL_ROWS: integer:= 525;
        g_ACTIVE_COLS: integer:= 640;
        g_ACTIVE_ROWS: integer:= 480;
        g_COUNT_EXP: integer:= 10
    );

    port (
        i_clk: in std_logic;
        o_HSync: out std_logic;
        o_VSync: out std_logic;
        o_Col_Count: out std_logic_vector(g_COUNT_EXP-1 downto 0);
        o_Row_Count: out std_logic_vector(g_COUNT_EXP-1 downto 0)
    );
    
end Sync_Counter_01;

    

architecture Behavioral of Sync_Counter_01 is

    constant c_FRONT_PORCH_HORZ : integer := 18;
    constant c_BACK_PORCH_HORZ  : integer := 50;
    constant c_FRONT_PORCH_VERT : integer := 10;
    constant c_BACK_PORCH_VERT  : integer := 33;

    signal r_Col_Count: unsigned(g_COUNT_EXP-1 downto 0):= (others => '0');
    signal r_Row_Count: unsigned(g_COUNT_EXP-1 downto 0):= (others => '0');    
    
    signal r_HSync: std_logic:= '0';
    signal r_VSync: std_logic:= '0';

begin

    p_Count: process(i_clk)
    begin
        if rising_edge(i_clk) then

            if (r_Col_Count < to_unsigned(g_TOTAL_COLS-1, r_Col_Count'length)) then             --to_unsigned -> since g_TOTAL_COL is an integer, need to convert to compare with same type
                r_Col_Count <= r_Col_Count + 1;
                r_Row_Count <= r_Row_Count;
            else
                if (r_Row_Count < to_unsigned(g_TOTAL_ROWS-1, r_Row_Count'length)) then 
                    r_Col_Count <= (others => '0');
                    r_Row_Count <= r_Row_Count + 1;        
                else
                    r_Col_Count <= (others => '0');
                    r_Row_Count <= (others => '0');
                end if;        
            end if;

        end if;    
    end process;
    
    r_HSync <= '1' when r_Col_Count < g_ACTIVE_COLS else '0';
    r_VSync <= '1' when r_Row_Count < g_ACTIVE_ROWS else '0';

    o_Col_Count <= std_logic_vector(r_Col_Count);
    o_Row_Count <= std_logic_vector(r_Row_Count);
    
    p_Porch_Sync: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if ((to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS + c_FRONT_PORCH_HORZ or (to_integer(unsigned(r_Col_Count)) > g_TOTAL_COLS - c_BACK_PORCH_HORZ -1 ))) then
                o_HSync <= '1';
            else
                o_HSync <= r_HSync;
            end if;
            
            if ((to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS + c_FRONT_PORCH_VERT or (to_integer(unsigned(r_Row_Count)) > g_TOTAL_ROWS - c_BACK_PORCH_VERT -1 ))) then
                o_VSync <= '1';
            else
                o_VSync <= r_VSync;
            end if;            
        
        end if;  
  
    end process;
    
    


end Behavioral;








