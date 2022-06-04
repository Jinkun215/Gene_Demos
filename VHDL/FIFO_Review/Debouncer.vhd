----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2022 11:31:18 AM
-- Design Name: 
-- Module Name: Debouncer - Behavioral
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

entity Debouncer is
    port (
        i_Clk: in std_logic;
        i_Btn: in std_logic;
        o_Debounced_Btn: out std_logic    
    );
end Debouncer;

architecture Behavioral of Debouncer is

    constant counter_limit: integer := 100000;
    signal counter: integer range 0 to 100000:= 0;
    
    signal r_Btn: std_logic:= '0';

begin

    p_Main: process(i_Clk)
    begin
    
        if (rising_edge(i_Clk)) then
            if (i_Btn /= r_Btn and counter < counter_limit) then
                counter <= counter + 1;
            elsif (counter = counter_limit) then 
                counter <= 0;
                r_Btn <= i_Btn;
            else
                counter <= 0;
            
            end if;
        
        end if;
    end process p_Main;
    
    o_Debounced_Btn <= r_Btn;

end Behavioral;










