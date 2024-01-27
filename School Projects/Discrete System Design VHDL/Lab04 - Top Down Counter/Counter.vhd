----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 03:59:22 PM
-- Design Name: 
-- Module Name: Counter - Behavioral
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

entity Counter is
    port (
        counter_clk: in std_logic;
        counter_updown: in std_logic;
        counter_reset: in std_logic;
        counter_output: out std_logic_vector(31 downto 0)    -- 4 times 8
    );
end Counter;



architecture Behavioral of Counter is

    signal count_total: std_logic_vector(31 downto 0):= (others => '0');    
    

begin

    Counting: process (counter_clk, counter_reset)
    begin
    
        if (counter_reset = '1') then       
        
            if (counter_updown = '1') then  --if reset 1, updown 1, then reset to 00000000
                count_total <= (others => '0');
            else
                count_total <= X"99999999";     --if reset 1 updown 0, then reset to 99999999
            end if;
        
        
        else   --
            if (rising_edge(counter_clk)) then
                if (counter_updown = '1') then
                    count_total <= count_total + 1;
                    
                    adder_up_loop: for i in 0 to 7 loop         --Wraps BCD during up counting
                        if (i = 7) then  
                            if (count_total((4*i)+3 downto (4*i)) = "1010") then
                                count_total((4*i)+3 downto (4*i)) <= count_total((4*i)+3 downto(4*i)) + 6;
                            end if;
                        else
                            if (count_total((4*i)+3 downto (4*i)) = "1010") then
                                count_total((4*i)+3 downto (4*i)) <= count_total((4*i)+3 downto(4*i)) + 6;
                                count_total((4*(i+1))+3 downto(4*(i+1))) <= count_total((4*(i+1))+3 downto(4*(i+1))) + 1;
                            end if;
                        end if;
                        
                    end loop;   --end up loop
                else
                    count_total <= count_total - 1;
                    
                    adder_down_loop: for i in 7 downto 0 loop       --Wraps BCD during down counting
                        if (i = 0) then
                            if (count_total((4*i)+3 downto (4*i)) = "1111") then
                                count_total((4*i)+3 downto (4*i)) <= count_total((4*i)+3 downto(4*i)) - 6;
                            end if; 
                        else
                            if (count_total((4*i)+3 downto (4*i)) = "1111") then
                                count_total((4*i)+3 downto (4*i)) <= count_total((4*i)+3 downto(4*i)) - 6;
                                count_total((4*(i-1))+3 downto(4*(i-1))) <= count_total((4*(i-1))+3 downto(4*(i-1))) - 1;
                            end if;
                        end if; 
                                
                    end loop;   --end downloop
                end if; --end if updown = '1' 
            end if; --end rising_edge(clk)     
        end if; -- end if reset = '1'        
    end process;
    

    
    counter_output <= count_total;

end Behavioral;
