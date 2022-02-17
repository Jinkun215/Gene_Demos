----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2022 04:04:13 PM
-- Design Name: 
-- Module Name: Seven_Segment - Behavioral
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

entity Seven_Segment is
    port (
        i_clk: in std_logic;
        i_binary: in std_logic_vector(3 downto 0);
        o_seven_segment: out std_logic_vector(6 downto 0)
    
    );
end Seven_Segment;

architecture Behavioral of Seven_Segment is

    signal r_seven_segment: std_logic_vector(7 downto 0):= (others => '0');
    

begin

    p_convert: process(i_clk) is
    begin
        if (rising_edge(i_clk)) then
        
            -- HEX pGFEDCBA
        
            case (i_binary) is 
                when "0000" => r_seven_segment <= x"3F";
                when "0001" => r_seven_segment <= x"06";
                when "0010" => r_seven_segment <= x"5B";
                when "0011" => r_seven_segment <= x"4F";
                
                when "0100" => r_seven_segment <= x"66";
                when "0101" => r_seven_segment <= x"6D";
                when "0110" => r_seven_segment <= x"7D";
                when "0111" => r_seven_segment <= x"07";

                
                when "1000" => r_seven_segment <= x"7F";
                when "1001" => r_seven_segment <= x"6F";
                when "1010" => r_seven_segment <= x"77";
                when "1011" => r_seven_segment <= x"7C";
                
                when "1100" => r_seven_segment <= x"39";
                when "1101" => r_seven_segment <= x"5E";
                when "1110" => r_seven_segment <= x"79";
                when "1111" => r_seven_segment <= x"71";
                
                when others => r_seven_segment <= x"00";
            
            end case;
        end if;
    
    end process;
    
    o_seven_segment <= not r_seven_segment(6 downto 0);

end Behavioral;


















