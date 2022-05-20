----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2022 11:20:31 AM
-- Design Name: 
-- Module Name: VGA_Pulse_Generator - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Pattern_Generator is
    generic (
        g_Video_Width: integer:= 3;
    
        g_Total_Col: integer:= 800;
        g_Active_Col: integer:= 640;
        
        g_Total_Row: integer:= 525;
        g_Active_Row: integer:= 480;
        
        g_Col_Front: integer:= 18;
        g_Col_Back: integer:= 50;
        
        g_Row_Front: integer:= 10;
        g_Row_Back: integer:= 33
    );
    port (
        i_Clk: in std_logic;
        i_Pattern_Sel: in std_logic_vector(2 downto 0);
        
        o_Pattern_Red: out std_logic_vector(g_Video_Width-1 downto 0);
        o_Pattern_Grn: out std_logic_vector(g_Video_Width-1 downto 0);
        o_Pattern_Blu: out std_logic_vector(g_Video_Width-1 downto 0)
        
        
    );
end VGA_Pattern_Generator;



architecture RTL of VGA_Pattern_Generator is

    signal r_Col_Count: std_logic_vector(9 downto 0):= (others => '0');
    signal r_Row_Count: std_logic_vector(9 downto 0):= (others => '0');
    
    type t_Pattern is array(0 to 7) of std_logic_vector(g_Video_Width-1 downto 0);
    signal Pattern_Red: t_Pattern;
    signal Pattern_Grn: t_Pattern;
    signal Pattern_Blu: t_Pattern;
    
    signal color_Sel: integer range 0 to 7:= 0;

begin

    Sync_Counter_Inst: entity work.Sync_Counter
        generic map (
            g_Total_Col => g_Total_Col,
            g_Total_Row => g_Total_Row
        )
        port map (
        i_Clk => i_Clk,
            o_Col_Count => r_Col_Count,
            o_Row_Count => r_Row_Count
        );

    p_Pattern_Sel: process(i_Clk)
    begin
        
        if (rising_edge(i_Clk)) then
    
            case (i_Pattern_Sel) is
                
                when "000" => o_Pattern_Red <= Pattern_red(0); o_Pattern_Grn <= Pattern_Grn(0); o_Pattern_Blu <= Pattern_Blu(0);
                when "001" => o_Pattern_Red <= Pattern_red(1); o_Pattern_Grn <= Pattern_Grn(1); o_Pattern_Blu <= Pattern_Blu(1);
                when "010" => o_Pattern_Red <= Pattern_red(2); o_Pattern_Grn <= Pattern_Grn(2); o_Pattern_Blu <= Pattern_Blu(2);
                when "011" => o_Pattern_Red <= Pattern_red(3); o_Pattern_Grn <= Pattern_Grn(3); o_Pattern_Blu <= Pattern_Blu(3);
                
                when "100" => o_Pattern_Red <= Pattern_red(4); o_Pattern_Grn <= Pattern_Grn(4); o_Pattern_Blu <= Pattern_Blu(4);
                when "101" => o_Pattern_Red <= Pattern_red(5); o_Pattern_Grn <= Pattern_Grn(5); o_Pattern_Blu <= Pattern_Blu(5);
                when "110" => o_Pattern_Red <= Pattern_red(6); o_Pattern_Grn <= Pattern_Grn(6); o_Pattern_Blu <= Pattern_Blu(6);
                when "111" => o_Pattern_Red <= Pattern_red(7); o_Pattern_Grn <= Pattern_Grn(7); o_Pattern_Blu <= Pattern_Blu(7);
                
                when others => o_Pattern_Red <= Pattern_red(0); o_Pattern_Grn <= Pattern_Grn(0); o_Pattern_Blu <= Pattern_Blu(0);
            
            end case;
        end if;
    end process p_Pattern_Sel;


    -- Pattern 0: All White
    Pattern_Red(0) <= (others => '1') when (to_integer(unsigned(r_Col_Count)) < g_Active_Col and 
                                          to_integer(unsigned(r_Row_Count)) < g_Active_Row) else (others => '0');
    Pattern_Grn(0) <= (others => '1') when (to_integer(unsigned(r_Col_Count)) < g_Active_Col and 
                                          to_integer(unsigned(r_Row_Count)) < g_Active_Row) else (others => '0');
    Pattern_Blu(0) <= (others => '1') when (to_integer(unsigned(r_Col_Count)) < g_Active_Col and 
                                          to_integer(unsigned(r_Row_Count)) < g_Active_Row) else (others => '0');
                   
     
    -- Pattern 1: All Red
    Pattern_Red(1) <= (others => '1') when (to_integer(unsigned(r_Col_Count)) < g_Active_Col and 
                                          to_integer(unsigned(r_Row_Count)) < g_Active_Row) else (others => '0');
    Pattern_Grn(1) <= (others => '0');
    Pattern_Blu(1) <= (others => '0');
    
    
    -- Pattern 2: All Green
    Pattern_Red(2) <= (others => '0');
    Pattern_Grn(2) <= (others => '1') when (to_integer(unsigned(r_Col_Count)) < g_Active_Col and 
                                          to_integer(unsigned(r_Row_Count)) < g_Active_Row) else (others => '0');
    Pattern_Blu(2) <= (others => '0');
    
    
    
    -- Pattern 3: All Blue
    Pattern_Red(3) <= (others => '0');
    Pattern_Grn(3) <= (others => '0');
    Pattern_Blu(3) <= (others => '1') when (to_integer(unsigned(r_Col_Count)) < g_Active_Col and 
                                          to_integer(unsigned(r_Row_Count)) < g_Active_Row) else (others => '0');
    
    
    -- Pattern 4: Big Checkmarks
    pattern_Red(4) <= (others => '1') when (r_Col_Count(6) = '0' xor r_Row_Count(5) = '1') else (others => '0');
    pattern_Grn(4) <= (others => '1') when (r_Col_Count(6) = '0' xor r_Row_Count(5) = '1') else (others => '0');
    pattern_Blu(4) <= (others => '1') when (r_Col_Count(6) = '0' xor r_Row_Count(5) = '1') else (others => '0');
    
    -- Pattern 5: Small Checkmarks
    pattern_Red(5) <= (others => '1') when (r_Col_Count(4) = '0' xor r_Row_Count(3) = '1') else (others => '0');
    pattern_Grn(5) <= (others => '1') when (r_Col_Count(4) = '0' xor r_Row_Count(3) = '1') else (others => '0');
    pattern_Blu(5) <= (others => '1') when (r_Col_Count(4) = '0' xor r_Row_Count(3) = '1') else (others => '0');
    
    -- Pattern 6: Color Bars
    color_Sel <= 0 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*1 else
                 1 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*2 else
                 2 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*3 else
                 3 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*4 else
                 4 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*5 else
                 5 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*6 else
                 6 when to_integer(unsigned(r_Col_Count)) < g_Active_Col/8*7 else
                 7;
                                        
    pattern_Red(6) <= (others => '1') when (color_Sel = 4) or (color_Sel = 5) or (color_Sel = 6) or (color_Sel = 7) else (others => '0');          
    pattern_Grn(6) <= (others => '1') when (color_Sel = 2) or (color_Sel = 3) or (color_Sel = 6) or (color_Sel = 7) else (others => '0');   
    pattern_Blu(6) <= (others => '1') when (color_Sel = 1) or (color_Sel = 3) or (color_Sel = 5) or (color_Sel = 7) else (others => '0');                                          
                                        
    
    -- Pattern 7: Cool Patterns
    pattern_Red(7) <= (others => '1') when (r_Col_Count(4) = '0' xor r_Row_Count(2) = '1') else (others => '0');
    pattern_Grn(7) <= (others => '1') when (r_Col_Count(5) = '0' xor r_Row_Count(3) = '1') else (others => '0');
    pattern_Blu(7) <= (others => '1') when (r_Col_Count(6) = '0' xor r_Row_Count(4) = '1') else (others => '0');

end RTL;





















