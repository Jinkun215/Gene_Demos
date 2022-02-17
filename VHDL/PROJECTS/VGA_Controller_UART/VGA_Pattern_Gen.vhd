----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2022 02:07:13 AM
-- Design Name: 
-- Module Name: VGA_Pattern_Gen - Behavioral
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

entity VGA_Pattern_Gen is
    generic (
        g_TOTAL_COLS: integer:= 800;
        g_TOTAL_ROWS: integer:= 525;
        g_ACTIVE_COLS: integer:= 640;
        g_ACTIVE_ROWS: integer:= 480;
        g_COUNT_EXP: integer:= 10
    );
    port (
        i_clk: in std_logic;
        i_Pattern: in std_logic_vector(3 downto 0);
        
        o_HSync: out std_logic;
        o_VSync: out std_logic;
        o_Red_Video: out std_logic_vector(3 downto 0);
        o_Grn_Video: out std_logic_vector(3 downto 0);
        o_Blu_Video: out std_logic_vector(3 downto 0)
        
    
    );
    
end VGA_Pattern_Gen;

architecture Behavioral of VGA_Pattern_Gen is

    signal r_HSync: std_logic:= '0';
    signal r_VSync: std_logic:= '0';
    signal r_Col_Count: std_logic_vector(g_COUNT_EXP-1 downto 0):= (others => '0');
    signal r_Row_Count: std_logic_vector(g_COUNT_EXP-1 downto 0):= (others => '0');
    
    type t_Patterns is array (0 to 15) of std_logic_vector(3 downto 0);
    signal red_Patterns: t_Patterns;
    signal grn_Patterns: t_Patterns;
    signal blu_Patterns: t_Patterns;

begin

    Sync_Coutner_01_Inst: entity work.Sync_Counter_01 
     generic map (
        g_TOTAL_COLS => 800,
        g_TOTAL_ROWS => 525,
        g_ACTIVE_COLS => 640,
        g_ACTIVE_ROWS => 480,
        g_COUNT_EXP => 10
    )
    port map (
        i_clk => i_clk,
        o_HSync => r_HSync,
        o_VSync => r_VSync,
        o_Col_Count => r_Col_Count,
        o_Row_Count => r_Row_Count
    );
    
    p_Patterns: process(i_clk)
    begin
        if rising_edge(i_clk) then  --Make only 4 patterns (5 with default) for testing purposes
            case (i_Pattern) is
                when "0000" => 
                    o_Red_Video <= red_Patterns(0);
                    o_Grn_Video <= grn_Patterns(0);
                    o_Blu_Video <= blu_Patterns(0);
                    
                when "0001" =>
                    o_Red_Video <= red_Patterns(1);
                    o_Grn_Video <= grn_Patterns(1);
                    o_Blu_Video <= blu_Patterns(1);
                    
                when "0010" =>
                    o_Red_Video <= red_Patterns(2);
                    o_Grn_Video <= grn_Patterns(2);
                    o_Blu_Video <= blu_Patterns(2);
                    
                when "0011" =>
                    o_Red_Video <= red_Patterns(3);
                    o_Grn_Video <= grn_Patterns(3);
                    o_Blu_Video <= blu_Patterns(3);
                    
                when "0100" =>
                    o_Red_Video <= red_Patterns(4);
                    o_Grn_Video <= grn_Patterns(4);
                    o_Blu_Video <= blu_Patterns(4);
                
                when "0101" =>
                    o_Red_Video <= red_Patterns(5);
                    o_Grn_Video <= grn_Patterns(5);
                    o_Blu_Video <= blu_Patterns(5);
                    
                when "0110" =>
                    o_Red_Video <= red_Patterns(6);
                    o_Grn_Video <= grn_Patterns(6);
                    o_Blu_Video <= blu_Patterns(6);
                    
                when "0111" =>
                    o_Red_Video <= red_Patterns(7);
                    o_Grn_Video <= grn_Patterns(7);
                    o_Blu_Video <= blu_Patterns(7);  
   
               when "1000" =>
                    o_Red_Video <= red_Patterns(8);
                    o_Grn_Video <= grn_Patterns(8);
                    o_Blu_Video <= blu_Patterns(8);        
                    
                when "1001" =>
                    o_Red_Video <= red_Patterns(9);
                    o_Grn_Video <= grn_Patterns(9);
                    o_Blu_Video <= blu_Patterns(9);     
                    
               when "1010" =>
                    o_Red_Video <= red_Patterns(10);
                    o_Grn_Video <= grn_Patterns(10);
                    o_Blu_Video <= blu_Patterns(10);      
                    
               when "1011" =>
                    o_Red_Video <= red_Patterns(11);
                    o_Grn_Video <= grn_Patterns(11);
                    o_Blu_Video <= blu_Patterns(11);    
                    
               when "1100" =>
                    o_Red_Video <= red_Patterns(12);
                    o_Grn_Video <= grn_Patterns(12);
                    o_Blu_Video <= blu_Patterns(12);         
                     
                     
                     
                when others =>
                    o_Red_Video <= red_Patterns(0);
                    o_Grn_Video <= grn_Patterns(0);
                    o_Blu_Video <= blu_Patterns(0);
            end case;
            

            
        end if; --rising_edge(i_clk)    
    end process;
    
    o_HSync <= r_HSync;
    o_VSync <= r_VSync;
    
    -------------------------------------------------------
    -- Pattern 0 - All Black
    -------------------------------------------------------
    red_Patterns(0) <= (others => '0');
    grn_Patterns(0) <= (others => '0');
    blu_Patterns(0) <= (others => '0');

    
    -------------------------------------------------------
    -- Pattern 1 - All Red
    -------------------------------------------------------
    red_Patterns(1) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    grn_Patterns(1) <= (others => '0');    
    blu_Patterns(1) <= (others => '0');   
  
    
    -------------------------------------------------------
    -- Pattern 2 - All Green
    -------------------------------------------------------
    red_Patterns(2) <= (others => '0');
    grn_Patterns(2) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    blu_Patterns(2) <= (others => '0');
    
    -------------------------------------------------------
    -- Pattern 3 - All Blue
    -------------------------------------------------------
    red_Patterns(3) <= (others => '0');
    grn_Patterns(3) <= (others => '0');
    blu_Patterns(3) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    
    -------------------------------------------------------
    -- Pattern 4 - All Magenta
    -------------------------------------------------------
    red_Patterns(4) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    grn_Patterns(4) <= (others => '0');
    blu_Patterns(4) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    
    -------------------------------------------------------
    -- Pattern 5 - All Yellow
    -------------------------------------------------------
    red_Patterns(5) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    grn_Patterns(5) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    blu_Patterns(5) <= (others => '0');   
    
    -------------------------------------------------------
    -- Pattern 6 - All Cyan
    -------------------------------------------------------
    red_Patterns(6) <= (others => '0');
    grn_Patterns(6) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    blu_Patterns(6) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    
    -------------------------------------------------------
    -- Pattern 7 - All White
    -------------------------------------------------------
    red_Patterns(7) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    grn_Patterns(7) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    blu_Patterns(7) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS and to_integer(unsigned(r_Row_Count)) < g_ACTIVE_ROWS else (others => '0');
    
    -------------------------------------------------------
    -- Pattern 8 - Checker (Big)
    -------------------------------------------------------
    red_Patterns(8) <= (others => '1') when r_Col_Count(6) = '1' xor r_Row_Count(6) = '0' else (others => '0');
    grn_Patterns(8) <= red_Patterns(8);       
    blu_Patterns(8) <= red_Patterns(8);
    
    
    -------------------------------------------------------
    -- Pattern 9 - Checker (Small)
    -------------------------------------------------------
    red_Patterns(9) <= (others => '1') when r_Col_Count(3) = '1' xor r_Row_Count(3) = '0' else (others => '0');
    grn_Patterns(9) <= red_Patterns(9);       
    blu_Patterns(9) <= red_Patterns(9);
    
    -------------------------------------------------------
    -- Pattern 10 - Half Red Half Blue Divded by Column
    -------------------------------------------------------
    red_Patterns(10) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < (g_ACTIVE_COLS/2) else (others => '0');
    grn_Patterns(10) <= (others => '0');
    blu_Patterns(10) <= (others => '1') when to_integer(unsigned(r_Col_Count)) > (g_ACTIVE_COLS/2)-1 and to_integer(unsigned(r_Col_Count)) < g_ACTIVE_COLS else (others => '0');
    
    -------------------------------------------------------
    -- Pattern 11 - Third of Each Divided by Column
    -------------------------------------------------------
    red_Patterns(11) <= (others => '1') when to_integer(unsigned(r_Col_Count)) < (g_ACTIVE_COLS/3) else (others => '0');
    grn_Patterns(11) <= (others => '1') when to_integer(unsigned(r_Col_Count)) > (g_ACTIVE_COLS/3)-1 and to_integer(unsigned(r_Col_Count)) < (g_ACTIVE_COLS/3*2) else (others => '0');
    blu_Patterns(11) <= (others => '1') when to_integer(unsigned(r_Col_Count)) > (g_ACTIVE_COLS/3*2)-1 and to_integer(unsigned(r_Col_Count)) < (g_ACTIVE_COLS) else (others => '0');
    
    -------------------------------------------------------
    -- Pattern 12 - Third of Each Divided by Column
    -------------------------------------------------------
    red_Patterns(12) <= (others => '1') when to_integer(unsigned(r_Row_Count)) < (g_ACTIVE_ROWS/3) else (others => '0');
    grn_Patterns(12) <= (others => '1') when to_integer(unsigned(r_Row_Count)) > (g_ACTIVE_ROWS/3)-1 and to_integer(unsigned(r_Row_Count)) < (g_ACTIVE_ROWS/3*2) else (others => '0');
    blu_Patterns(12) <= (others => '1') when to_integer(unsigned(r_Row_Count)) > (g_ACTIVE_ROWS/3*2)-1 and to_integer(unsigned(r_Row_Count)) < (g_ACTIVE_ROWS) else (others => '0');
    




end Behavioral;






















