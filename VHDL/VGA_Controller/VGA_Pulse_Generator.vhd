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

entity VGA_Pulse_Generator is
    generic (
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
        
        o_HSync: out std_logic;
        o_VSync: out std_logic
        
    );
end VGA_Pulse_Generator;



architecture RTL of VGA_Pulse_Generator is

    signal r_Col_Count: std_logic_vector(9 downto 0):= (others => '0');
    signal r_Row_Count: std_logic_vector(9 downto 0):= (others => '0');
    
    signal r_HSync: std_logic:= '0';
    signal r_VSync: std_logic:= '0';
    
    

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
    
    p_Main: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
    
            if (to_integer(unsigned(r_Col_Count)) < g_Active_Col + g_Col_Front) then
                r_HSync <= '1';
            elsif (to_integer(unsigned(r_Col_Count)) > g_Total_Col -1 - g_Col_Back) then
                r_HSync <= '1';
            else
                r_HSync <= '0';
            end if;
            
            if (to_integer(unsigned(r_Row_Count)) < g_Active_Row + g_Row_Front) then
                r_VSync <= '1';
            elsif (to_integer(unsigned(r_Row_Count)) > g_Total_Row -1 - g_Row_Back) then
                r_VSync <= '1';
            else
                r_VSync <= '0';
            end if;
        end if;
    end process p_Main;

    o_HSync <= r_HSync;
    o_VSync <= r_VSync;
    
end RTL;  














