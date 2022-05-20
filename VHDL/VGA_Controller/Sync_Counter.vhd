
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

entity Sync_Counter is
    generic (
        g_Total_Col: integer:= 800;
        g_Total_Row: integer:= 525
    );
    port (
        i_Clk: in std_logic;
        
        o_Col_Count: out std_logic_vector(9 downto 0);
        o_Row_Count: out std_logic_vector(9 downto 0)
        
    );
end Sync_Counter;

architecture RTL of Sync_Counter is

    signal counter_Column: integer range 0 to g_Total_Col-1:= 0;
    signal counter_Row: integer range 0 to g_Total_Row-1:= 0;

begin

    p_Main: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
        
            if (counter_Column < g_Total_Col-1) then
                counter_Column <= counter_Column + 1;
            else
                counter_Column <= 0;
                if (counter_Row < g_Total_Row-1) then
                    counter_Row <= counter_Row + 1;
                else
                    counter_Row <= 0;
                end if;
            end if;
        
        end if;  --rising_edge(i_Clk)
    
    end process p_Main;

    o_Col_Count <= std_logic_vector(to_unsigned(counter_Column, o_Col_Count'length));
    o_Row_Count <= std_logic_vector(to_unsigned(counter_Row, o_Row_Count'length));

end RTL;















