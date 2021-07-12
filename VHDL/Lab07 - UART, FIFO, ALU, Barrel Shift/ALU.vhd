----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 12:16:19 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    port (
        ALU_clk: in std_logic;
        ALU_Math: in std_logic_vector(1 downto 0);
        ALU_Input_A: in std_logic_vector(7 downto 0);
        ALU_Input_B: in std_logic_vector(7 downto 0);
        ALU_Output: out std_logic_vector(15 downto 0)
    );
end ALU;

architecture Behavioral of ALU is

--    component Hex_Fix
--        port (
--            HexFix_In: in std_logic_vector(15 downto 0);
--            HexFix_Out: out std_logic_vector(15 downto 0)
--        );
--    end component Hex_Fix;

    signal temp_digit_A: std_logic_vector(15 downto 0);
    signal temp_digit_B: std_logic_vector(15 downto 0);
--    signal temp_calculation: std_logic_vector(15 downto 0);

begin

--    HEX_FIX_Gen: Hex_Fix port map (
--        HexFix_In => temp_calculation,
--        HexFix_Out => ALU_Output
--    );

    process (ALU_clk)
    begin
        if (rising_edge(ALU_clk)) then
            temp_digit_A <= "00000000" & ALU_Input_A;
            temp_digit_B <= "00000000" & ALU_Input_B;
            case ALU_Math is
                when "00" => ALU_Output <= std_logic_vector(unsigned(temp_digit_A) + unsigned(ALU_Input_B));
                when "01" => ALU_Output <= std_logic_vector(unsigned(temp_digit_A) - unsigned(ALU_Input_B));
                when "10" => ALU_Output <= std_logic_vector(unsigned(ALU_Input_A) * unsigned(ALU_Input_B));
                when others => ALU_Output <= std_logic_vector(unsigned(temp_digit_A) / unsigned(ALU_Input_B));
            end case;
        end if;
    end process;



end Behavioral;









