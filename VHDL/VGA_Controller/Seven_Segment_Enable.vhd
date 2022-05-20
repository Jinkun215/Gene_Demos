
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Seven_Segment_Enable is

    port (
        i_Clk: in std_logic;
        i_Seven_Segment_1: in std_logic_vector(6 downto 0);
        i_Seven_Segment_2: in std_logic_vector(6 downto 0);
        
        o_Segment_Display: out std_logic_vector(6 downto 0);
        o_Segment_En: out std_logic_vector(7 downto 0)
    
    );
    
end Seven_Segment_Enable;

architecture Behavioral of Seven_Segment_Enable is

    signal r_Seven_Segment_1: std_logic_vector(6 downto 0);
    signal r_Seven_Segment_2: std_logic_vector(6 downto 0);
    
    signal r_Segment_Display: std_logic_vector(6 downto 0);
    signal r_Segment_En: std_logic_vector(7 downto 0);
    
    signal r_SW: std_logic:= '0';
    
    constant counter_Limit: integer:= 100000;
    signal counter: integer range 0 to counter_Limit:= 0;

begin

    p_Main: process(i_Clk) is
    begin
    
        if (rising_edge(i_Clk)) then
        
            r_Seven_Segment_1 <= i_Seven_Segment_1;
            r_Seven_Segment_2 <= i_Seven_Segment_2;
            
            if (counter < counter_Limit) then
                counter <= counter + 1;
            else
                counter <= 0;

                if (r_SW = '0') then
                    r_Segment_Display <= r_Seven_Segment_1;
                    r_Segment_En <= "11111110";
                    r_SW <= not r_SW;                
                else
                    r_Segment_Display <= r_Seven_Segment_2;
                    r_Segment_En <= "11111101";
                    r_SW <= not r_SW;
            
                end if;
            
            end if;

        end if; -- if (rising_edge(i_Clk))
    end process p_Main;
    
    o_Segment_Display <= r_Segment_Display;
    o_Segment_En <= r_Segment_En;

end Behavioral;















