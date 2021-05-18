----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 09:33:56 PM
-- Design Name: 
-- Module Name: MUX - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX is
    port (
        MUX_clk: in std_logic;
        MUX_input: in std_logic_vector(31 downto 0); --4 times 8
        MUX_reset: in std_logic;
        MUX_output_segment: out std_logic_vector(6 downto 0);
        MUX_output_display: out std_logic_vector(7 downto 0)
    
    );
end MUX;

architecture Behavioral of MUX is

    component BCD
        port (
            BCD_input: in std_logic_vector(3 downto 0);
            BCD_output: out std_logic_vector(6 downto 0)    
        );
    end component BCD;

    signal input_temp: std_logic_vector(3 downto 0);
    signal MUX_Sel: std_logic_vector(2 downto 0):= "000";

begin

    BCD_GEN: BCD port map (
        BCD_input => input_temp,
        BCD_output => MUX_output_segment
    );

    MUX_GEN: process (MUX_clk, MUX_reset)
    begin
        if (MUX_reset = '1') then           --when reset = 1, then set selector to 0 and display to first segment
            MUX_Sel <= "000";
            MUX_output_display <= "11111110";
        else
            
            if (rising_edge(MUX_clk)) then     --cycles through Mux
                case MUX_Sel is
                    when "000" => input_temp <= MUX_input(3 downto 0); MUX_output_display <= "11111110";
                    when "001" => input_temp <= MUX_input(7 downto 4); MUX_output_display <= "11111101";
                    when "010" => input_temp <= MUX_input(11 downto 8); MUX_output_display <= "11111011";
                    when "011" => input_temp <= MUX_input(15 downto 12); MUX_output_display <= "11110111";
                    when "100" => input_temp <= MUX_input(19 downto 16); MUX_output_display <= "11101111";
                    when "101" => input_temp <= MUX_input(23 downto 20); MUX_output_display <= "11011111";
                    when "110" => input_temp <= MUX_input(27 downto 24); MUX_output_display <= "10111111";
                    when "111" => input_temp <= MUX_input(31 downto 28); MUX_output_display <= "01111111";
                    when others => input_temp <= "ZZZZ"; MUX_output_display <= "11111111";
                
                end case;
                MUX_Sel <= MUX_Sel + 1;   
            end if; --end if risiing_edge
        end if;    --end if reset
    end process;

end Behavioral;






