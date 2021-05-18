----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2021 06:32:10 PM
-- Design Name: 
-- Module Name: Display - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display is
    port (
        clk: in std_logic;
        SW_A: in std_logic_vector(7 downto 0);
        BCD_Output: out std_logic_vector(6 downto 0);
        AN: out std_logic_vector(7 downto 0)
    );
end Display;

architecture Behavioral of Display is

    component BCD_TO_7SEG
        port (
            BCD_IN: in std_logic_vector(3 downto 0);
            SEG_OUT: out std_logic_vector(6 downto 0)
        
        );
    end component BCD_TO_7SEG;

        signal segA_display: std_logic_vector(3 downto 0);
        signal FF: std_logic_vector(1 downto 0) := "00";
        signal clk_counter: natural range 0 to 50000:= 0;
        signal tens_digit: std_logic_vector(3 downto 0):= "0001";
        

begin

    BCD7SEG_GEN: BCD_TO_7SEG port map (
        BCD_IN => segA_display, 
        SEG_OUT => BCD_Output
    );

    CLK_GEN: process(clk)
    begin
        --SW(3 downto 0) = SW_A
        --SW(7 downto 4) = SW_B
        
        if (rising_edge(clk)) then
            clk_counter <= clk_counter + 1;
            if clk_counter >= 50000 then
                clk_counter <= 0;
                if (SW_A(3 downto 0) >= 10 and SW_A(7 downto 4) >= 10) then --A and B 10 or higher
                    case FF is
                        when "00" => segA_display <= SW_A(3 downto 0) + 6; AN <= "11111110";
                        when "01" => segA_display <= tens_digit; AN <= "11111101";
                        when "10" => segA_display <= SW_A(7 downto 4) + 6; AN <= "11101111";
                        when "11" => segA_display <= tens_digit; AN <= "11011111";
                        when others => AN <= "11111111";
                    end case; 
                        
                elsif (SW_A(3 downto 0) >= 10 and SW_A(7 downto 4) < 10) then  --A 10 or higher, B 9 or lower
                    case FF is
                        when "00" => segA_display <= SW_A(3 downto 0) + 6; AN <= "11111110";
                        when "01" => segA_display <= tens_digit; AN <= "11111101";
                        when "10" => segA_display <= SW_A(7 downto 4); AN <= "11101111";
                        when "11" => segA_display <= SW_A(7 downto 4); AN <= "11101111";
                        when others => AN <= "11111111";
                    end case; 
                    
                elsif (SW_A(3 downto 0) < 10 and SW_A(7 downto 4) >= 10) then  --A 9 or lower, B 10 or higher
                    case FF is
                        when "00" => segA_display <= SW_A(3 downto 0); AN <= "11111110"; 
                        when "01" => segA_display <= SW_A(7 downto 4) + 6; AN <= "11101111";
                        when "10" => segA_display <= tens_digit; AN <= "11011111";
                        when "11" => segA_display <= tens_digit; AN <= "11011111";
                        when others => AN <= "11111111";
                    end case; 
                    
                else    --A and B 9 or lower
                    case FF is
                        when "00" => segA_display <= SW_A(3 downto 0); AN <= "11111110";
                        when "01" => segA_display <= SW_A(3 downto 0); AN <= "11111110";
                        when "10" => segA_display <= SW_A(7 downto 4); AN <= "11101111";
                        when "11" => segA_display <= SW_A(7 downto 4); AN <= "11101111";
                        when others => AN <= "11111111";
                    end case; 
                    
                end if; --if (SW_A(3 down to 0)>= 10 and SW_A(7 downto 4) >= 10)
                
                FF <= FF + 1;
            end if; --if clk_counter >= 50000
        end if; --if(rising_edge(clk))
    
    end process CLK_GEN;    


end Behavioral;
