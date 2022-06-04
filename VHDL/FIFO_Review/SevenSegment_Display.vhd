----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2022 10:59:45 AM
-- Design Name: 
-- Module Name: SevenSegment_Display - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegment_Display is
    port (
        i_Clk: in std_logic;
        i_Data_Rd: in std_logic_vector(3 downto 0);
        
        o_Seven_Segment: out std_logic_vector(6 downto 0)
    );
end SevenSegment_Display;

architecture Behavioral of SevenSegment_Display is

    --hex pgfedcba
    signal r_Seven_Segment: std_logic_vector(7 downto 0);
    
begin

    p_Main: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
        
            case (i_Data_Rd) is
            
                when "0000" => r_Seven_Segment <= x"3F";
                when "0001" => r_Seven_Segment <= x"06";
                when "0010" => r_Seven_Segment <= x"5B";
                when "0011" => r_Seven_Segment <= x"4F";
                
                when "0100" => r_Seven_Segment <= x"66";
                when "0101" => r_Seven_Segment <= x"6D";
                when "0110" => r_Seven_Segment <= x"7D";
                when "0111" => r_Seven_Segment <= x"07";
                
                when "1000" => r_Seven_Segment <= x"7F";
                when "1001" => r_Seven_Segment <= x"6F";
                when "1010" => r_Seven_Segment <= x"77";
                when "1011" => r_Seven_Segment <= x"7C";
                
                when "1100" => r_Seven_Segment <= x"39";
                when "1101" => r_Seven_Segment <= x"5E";
                when "1110" => r_Seven_Segment <= x"79";
                when "1111" => r_Seven_Segment <= x"71";
                
                when others => r_Seven_Segment <= x"00";

            end case;
            
            
        
        end if;
    
    end process p_Main;

    o_Seven_Segment <= not r_Seven_Segment(6 downto 0);
end Behavioral;














