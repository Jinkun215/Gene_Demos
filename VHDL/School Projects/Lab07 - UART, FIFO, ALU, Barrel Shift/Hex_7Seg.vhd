----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 05:36:16 PM
-- Design Name: 
-- Module Name: Hex_7Seg - Behavioral
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

entity Hex_7Seg is
    port (
        Hex_7Seg_In: in std_logic_vector(3 downto 0);
        Hex_7Seg_Out: out std_logic_vector(6 downto 0)
    );
end Hex_7Seg;

architecture Behavioral of Hex_7Seg is

begin
    
    process(Hex_7Seg_In)
    begin
        case Hex_7Seg_In is
            when "0000" => Hex_7Seg_Out <= "1000000"; --0
            when "0001" => Hex_7Seg_Out <= "1111001"; --1
            when "0010" => Hex_7Seg_Out <= "0100100"; --2
            when "0011" => Hex_7Seg_Out <= "0110000"; --3
            when "0100" => Hex_7Seg_Out <= "0011001"; --4
            when "0101" => Hex_7Seg_Out <= "0010010"; --5
            when "0110" => Hex_7Seg_Out <= "0000010"; --6
            when "0111" => Hex_7Seg_Out <= "1111000"; --7
            when "1000" => Hex_7Seg_Out <= "0000000"; --8
            when "1001" => Hex_7Seg_Out <= "0010000"; --9
            when "1010" => Hex_7Seg_Out <= "0001000"; --A
            when "1011" => Hex_7Seg_Out <= "0000011"; --B
            when "1100" => Hex_7Seg_Out <= "1000110"; --C
            when "1101" => Hex_7Seg_Out <= "0100001"; --D
            when "1110" => Hex_7Seg_Out <= "0000110"; --E
            when "1111" => Hex_7Seg_Out <= "0001110"; --F
            when others => Hex_7Seg_Out <= "1111111";    --others
        end case;
    end process;


end Behavioral;




