----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 10:30:52 PM
-- Design Name: 
-- Module Name: MUX_HexBcd - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX_HexBcd is
    port (
        MUX_HexBcd_clk: in std_logic;
        MUX_HexBcd_HB: in std_logic;
        MUX_HexBcd_In: in std_logic_vector(7 downto 0);
        MUX_BCD: out std_logic_vector(13 downto 0)
    );
end MUX_HexBcd;

architecture Behavioral of MUX_HexBcd is

   component BCD_Conversion
        port (
            BCD_Conversion_Input: in std_logic_vector(3 downto 0);
            BCD_Conversion_Output: out std_logic_vector(3 downto 0)
        );
    end component BCD_Conversion;
    
    component BCD_Display
        port (
            BCD_Display_input: in std_logic_vector(3 downto 0);
            BCD_Display_output: out std_logic_vector(6 downto 0)
        );
    end component BCD_Display;
    
    signal temp_pass_to_display: std_logic_vector(7 downto 0);
    signal temp_convert: std_logic_vector(7 downto 0);

begin

    GENLOOP: for i in 0 to 1 generate
        BCD_DISP: BCD_Display port map (
            BCD_Display_input => temp_pass_to_display(4*i+3 downto 4*i),
            BCD_Display_output => MUX_BCD(7*i+6 downto 7*i)
        );
        
--        BCD_CONV: BCD_Conversion port map (
--            BCD_Conversion_Input => temp_convert(4*i+3 downto 4*i),
--            BCD_Conversion_Output => temp_pass_to_display(4*i+3 downto 4*i)
--        );
    
    end generate;


    process(MUX_HexBcd_clk)
    begin
        if (rising_edge(MUX_HexBcd_clk)) then
            if (MUX_HexBcd_HB = '1') then   --Display Hex
                temp_pass_to_display(7 downto 4) <= MUX_HexBcd_In(7 downto 4);
                temp_pass_to_display(3 downto 0) <= MUX_HexBcd_In(3 downto 0); 
            else                            --Display BCD
                if (unsigned(MUX_HexBcd_In(7 downto 4)) >= 10) then
                    temp_pass_to_display(7 downto 4) <= std_logic_vector(unsigned(MUX_HexBcd_In(7 downto 4)) + 6);
                else
                    temp_pass_to_display(7 downto 4) <= std_logic_vector(unsigned(MUX_HexBcd_In(7 downto 4)));
                end if;
                if (unsigned(MUX_HexBcd_In(3 downto 0)) >= 10) then
                    temp_pass_to_display(3 downto 0) <= std_logic_vector(unsigned(MUX_HexBcd_In(3 downto 0)) + 6);
                else
                    temp_pass_to_display(3 downto 0) <= std_logic_vector(unsigned(MUX_HexBcd_In(3 downto 0)));
                end if;
            end if;
        
        end if;
        
    end process;

end Behavioral;












