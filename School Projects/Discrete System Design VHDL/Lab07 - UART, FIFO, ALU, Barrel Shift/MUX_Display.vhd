----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 06:10:13 PM
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
use IEEE.numeric_std.all;

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
        MUX_Display_Input: in std_logic_vector(31 downto 0);  
        MUX_Display_8AN: out std_logic_vector(7 downto 0);
        Mux_Display_HEX: out std_logic_vector(6 downto 0)
    );
end MUX_Display;

architecture Behavioral of MUX_Display is

    component Hex_7Seg
        port (
            Hex_7Seg_In: in std_logic_vector(3 downto 0);
            Hex_7Seg_Out: out std_logic_vector(6 downto 0)
        );
    end component Hex_7Seg;

    signal MUX_Sel: std_logic_vector(2 downto 0):= "000";
    signal Input_to_Convert: std_logic_vector(3 downto 0);

begin

    Hex_7seg_gen: Hex_7Seg port map (
        Hex_7Seg_In => Input_to_Convert,
        Hex_7Seg_Out => Mux_Display_HEX
    );

    process(MUX_Display_clk)
    begin
    
        if (rising_edge(MUX_Display_clk)) then
        
            case MUX_Sel is
                when "000" => MUX_Display_8AN <= "01111111"; Input_to_Convert <= MUX_Display_Input(31 downto 28);
                when "001" => MUX_Display_8AN <= "10111111"; Input_to_Convert <= MUX_Display_Input(27 downto 24);
                when "010" => MUX_Display_8AN <= "11011111"; Input_to_Convert <= MUX_Display_Input(23 downto 20);
                when "011" => MUX_Display_8AN <= "11101111"; Input_to_Convert <= MUX_Display_Input(19 downto 16);
                when "100" => MUX_Display_8AN <= "11110111"; Input_to_Convert <= MUX_Display_Input(15 downto 12);
                when "101" => MUX_Display_8AN <= "11111011"; Input_to_Convert <= MUX_Display_Input(11 downto 8);
                when "110" => MUX_Display_8AN <= "11111101"; Input_to_Convert <= MUX_Display_Input(7 downto 4);
                when "111" => MUX_Display_8AN <= "11111110"; Input_to_Convert <= MUX_Display_Input(3 downto 0);
                when others => MUX_Display_8AN <= "11111111";
            end case;
            MUX_Sel <= std_logic_vector(unsigned(MUX_SEL) + 1);
        end if;
        
    
    end process;
    


end Behavioral;










