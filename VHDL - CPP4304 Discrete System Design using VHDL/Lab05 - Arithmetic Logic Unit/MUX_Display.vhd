----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 10:30:34 PM
-- Design Name: 
-- Module Name: MUX_Display - Behavioral
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

entity MUX_Display is
    port (
        MUX_Display_clk: in std_logic;
        MUX_Display_Input: in std_logic_vector(27 downto 0);
        MUX_Display_7seg: out std_logic_vector(7 downto 0);
        Mux_Display_BCD: out std_logic_vector(6 downto 0)
    );
end MUX_Display;

architecture Behavioral of MUX_Display is

    signal MUX_Sel: std_logic_vector(1 downto 0):= "00";

begin

    process(MUX_Display_clk)
    begin
    
        if (rising_edge(MUX_Display_clk)) then
        
            case MUX_Sel is
                when "00" => MUX_Display_7seg <= "01111111"; Mux_Display_BCD <= MUX_Display_Input(27 downto 21);
                when "01" => MUX_Display_7seg <= "10111111"; Mux_Display_BCD <= MUX_Display_Input(20 downto 14);
                when "10" => MUX_Display_7seg <= "11111011"; Mux_Display_BCD <= MUX_Display_Input(13 downto 7);
                when "11" => MUX_Display_7seg <= "11111110"; Mux_Display_BCD <= MUX_Display_Input(6 downto 0);
                when others => MUX_Display_7seg <= "11111111";
            end case;
            MUX_Sel <= std_logic_vector(unsigned(MUX_SEL) + 1);
        end if;
        
    
    end process;
    


end Behavioral;












