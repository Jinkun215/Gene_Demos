----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2021 02:45:37 PM
-- Design Name: 
-- Module Name: HexFix - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hex_Fix is
    port (
        HexFix_In: in std_logic_vector(15 downto 0);
        HexFix_Out: out std_logic_vector(15 downto 0)
    );
end Hex_Fix;

architecture Behavioral of Hex_Fix is

    signal ones_digit: std_logic_vector(7 downto 0);
    signal tens_digit: std_logic_vector(7 downto 0);
    signal temp_int: integer:= 0;
    signal temp_tens: integer:= 0;
    signal temp_ones: integer:= 0;

begin

    process(HexFix_In)
    begin
        temp_int <= to_integer(unsigned(HexFix_In));
        temp_tens <= temp_int / 10;
        temp_ones <= temp_int mod 10;
        ones_digit <= std_logic_vector(to_unsigned(temp_ones, ones_digit'length));
        tens_digit <= std_logic_vector(to_unsigned(temp_tens, tens_digit'length));
        HexFix_out <= tens_digit & ones_digit;
    
    end process;

end Behavioral;














