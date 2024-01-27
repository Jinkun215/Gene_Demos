----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 10:21:14 PM
-- Design Name: 
-- Module Name: BCD_Display - Behavioral
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

entity BCD_Display is
    port (
        BCD_Display_input: in std_logic_vector(3 downto 0);
        BCD_Display_output: out std_logic_vector(6 downto 0)
    );
end BCD_Display;

architecture Behavioral of BCD_Display is

begin

    GEN: process(BCD_Display_input)
    begin 

        case BCD_Display_input is
            when "0000" => BCD_Display_output <= "1000000"; --0
            when "0001" => BCD_Display_output <= "1111001"; --1
            when "0010" => BCD_Display_output <= "0100100"; --2
            when "0011" => BCD_Display_output <= "0110000"; --3
            when "0100" => BCD_Display_output <= "0011001"; --4
            when "0101" => BCD_Display_output <= "0010010"; --5
            when "0110" => BCD_Display_output <= "0000010"; --6
            when "0111" => BCD_Display_output <= "1111000"; --7
            when "1000" => BCD_Display_output <= "0000000"; --8
            when "1001" => BCD_Display_output <= "0010000"; --9
            when "1010" => BCD_Display_output <= "0001000"; --A
            when "1011" => BCD_Display_output <= "0000011"; --B
            when "1100" => BCD_Display_output <= "1000110"; --C
            when "1101" => BCD_Display_output <= "0100001"; --D
            when "1110" => BCD_Display_output <= "0000110"; --E
            when "1111" => BCD_Display_output <= "0001110"; --F
            when others => BCD_Display_output <= "1111111";    --others
        end case;

    end process;

end Behavioral;
