----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2021 11:45:17 PM
-- Design Name: 
-- Module Name: BCD_TO_7SEG - Behavioral
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

entity BCD_TO_7SEG is
    port (
        BCD_IN: in std_logic_vector(3 downto 0);
        SEG_OUT: out std_logic_vector(6 downto 0)
    );
end BCD_TO_7SEG;

architecture Behavioral of BCD_TO_7SEG is

begin
    GEN: process(BCD_IN)
    begin
        case BCD_IN is
            when "0000" => SEG_OUT <= "1000000";  --0
            when "0001" => SEG_OUT <= "1111001";  --1
            when "0010" => SEG_OUT <= "0100100";  --2
            when "0011" => SEG_OUT <= "0110000";  --3
            when "0100" => SEG_OUT <= "0011001";  --4
            when "0101" => SEG_OUT <= "0010010";  --5
            when "0110" => SEG_OUT <= "0000010";  --6
            when "0111" => SEG_OUT <= "1111000";  --7
            when "1000" => SEG_OUT <= "0000000";  --8
            when "1001" => SEG_OUT <= "0010000";  --9
            when others => SEG_OUT <= "ZZZZZZZ"; --others
        end case;
    end process GEN;
    
    

end Behavioral;
