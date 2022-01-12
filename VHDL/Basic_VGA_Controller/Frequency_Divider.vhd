----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2022 02:47:05 PM
-- Design Name: 
-- Module Name: Frequency_Divider - Behavioral
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

entity Frequency_Divider is
    Generic (
        Divider_Val: integer:= 2    --Divides Frequency by 2*Val
    );
    port (
        i_Clk_Real: in std_logic;
        o_Clk_Divided: out std_logic
    );
end Frequency_Divider;

architecture Behavioral of Frequency_Divider is

    signal r_Counter: integer range 0 to Divider_Val-1:= 0;
    signal r_Clk_Divided: std_logic:= '0';

begin

    p_FD: process(i_Clk_Real) is
    begin
        if rising_edge(i_Clk_Real) then
        
            if (r_Counter = Divider_Val-1) then
                r_Counter <= 0;
                r_Clk_Divided <= not r_Clk_Divided;
                
            else
                r_Counter <= r_Counter + 1;
            end if;
        
        end if;
    
    end process;

    o_Clk_Divided <= r_Clk_Divided;

end Behavioral;









