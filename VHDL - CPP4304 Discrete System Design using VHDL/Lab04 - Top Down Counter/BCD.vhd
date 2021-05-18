----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 03:41:39 PM
-- Design Name: 
-- Module Name: BCD - Behavioral
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

entity BCD is
    port (
        BCD_input: in std_logic_vector(3 downto 0);
        BCD_output: out std_logic_vector(6 downto 0)    
    );
end BCD;

architecture Behavioral of BCD is

begin

    GEN: process(BCD_input)
    begin 
        case BCD_input is
            when "0000" => BCD_output <= "1000000";  --0
            when "0001" => BCD_output <= "1111001"; --1
            when "0010" => BCD_output <= "0100100"; --2
            when "0011" => BCD_output <= "0110000"; --3
            when "0100" => BCD_output <= "0011001"; --4
            when "0101" => BCD_output <= "0010010"; --5
            when "0110" => BCD_output <= "0000010"; --6
            when "0111" => BCD_output <= "1111000"; --7
            when "1000" => BCD_output <= "0000000"; --8
            when "1001" => BCD_output <= "0010000"; --9
            when others => BCD_output <= "1111111";    --others
        end case;
    end process;


end Behavioral;












