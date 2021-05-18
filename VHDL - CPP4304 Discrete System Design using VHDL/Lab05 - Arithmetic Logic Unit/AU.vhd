----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 10:50:03 PM
-- Design Name: 
-- Module Name: AU - Behavioral
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

entity AU is
    port (
        AU_clk: in std_logic;
        AU_Math: in std_logic_vector(1 downto 0);
        AU_In: in std_logic_vector(7 downto 0);
        AU_BCD: out std_logic_vector(13 downto 0)
    );
end AU;

architecture Behavioral of AU is

    component BCD_Conversion is
        port (
            BCD_Conversion_Input: in std_logic_vector(3 downto 0);
            BCD_Conversion_Output: out std_logic_vector(3 downto 0)
        );
    end component BCD_Conversion;
    
    component BCD_Display is
        port (
            BCD_Display_input: in std_logic_vector(3 downto 0);
            BCD_Display_output: out std_logic_vector(6 downto 0)
        );
    end component BCD_Display;
    
    component HexFix
        port (
            HexFix_In: in std_logic_vector(7 downto 0);
            HexFix_Out: out std_logic_vector(7 downto 0)
        );
        end component HexFix;
    
    signal temp_conversion: std_logic_vector(7 downto 0);
    signal temp_calculation: std_logic_vector(7 downto 0);
    signal temp_correction: std_logic_vector(7 downto 0);
    signal temp_digit1: std_logic_vector(7 downto 0);
    signal temp_digit2: std_logic_vector(7 downto 0);

begin

    GENLOOP: for i in 0 to 1 generate
        BCD_CONV: BCD_Conversion port map (
            BCD_Conversion_Input => AU_in(4*i+3 downto 4*i),
            BCD_Conversion_Output => temp_conversion(4*i+3 downto 4*i)
        );
        
        BCD_DISP: BCD_Display port map (
            BCD_Display_input => temp_correction(4*i+3 downto 4*i),
            BCD_Display_output => AU_BCD(7*i+6 downto 7*i)
        );
    end generate;
    
    HEX_FIX: HexFix port map (
        HexFix_In => temp_calculation,
        HexFix_Out => temp_correction
    );


    process (AU_clk)
    begin
        if (rising_edge(AU_clk)) then
                temp_digit1 <= "0000" & temp_conversion(3 downto 0);
                temp_digit2 <= "0000" & temp_conversion(7 downto 4);
            case AU_Math is
                when "00" => temp_calculation <= std_logic_vector(unsigned(temp_digit1) + unsigned(temp_digit2));
                when "01" => temp_calculation <= std_logic_vector(unsigned(temp_digit1) - unsigned(temp_digit2));
                when "10" => temp_calculation <= std_logic_vector(unsigned(temp_conversion(7 downto 4)) * unsigned(temp_conversion(3 downto 0)));
                when others => temp_calculation <= std_logic_vector(unsigned(temp_digit1) / unsigned(temp_digit2));
            end case;
        end if;
    end process;


end Behavioral;









