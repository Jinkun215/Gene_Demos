----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 10:22:22 PM
-- Design Name: 
-- Module Name: BCD_Conversion - Behavioral
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

entity BCD_Conversion is
    port (
        BCD_Conversion_Input: in std_logic_vector(3 downto 0);
        BCD_Conversion_Output: out std_logic_vector(3 downto 0)
    );
end BCD_Conversion;

architecture Behavioral of BCD_Conversion is

begin

    process(BCD_Conversion_Input)
    begin
        
        if (unsigned(BCD_Conversion_input) <= 9) then
            BCD_Conversion_output <= BCD_Conversion_Input;
        else
            BCD_Conversion_output <= std_logic_vector(unsigned(BCD_Conversion_Input) + 6);
        end if;
    end process;    
    
end Behavioral;
