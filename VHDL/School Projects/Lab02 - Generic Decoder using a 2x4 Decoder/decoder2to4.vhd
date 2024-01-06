library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder2to4 is
    Port ( A  : in  STD_LOGIC_VECTOR (1 downto 0);
           X  : out STD_LOGIC_VECTOR (3 downto 0);
           EN : in  STD_LOGIC);
end decoder2to4;

architecture Behavioral of decoder2to4 is

begin

process (A, EN)
begin
    X <= "0000";
    if (EN = '1') then
        case A is
            when "00"   => X(0) <= '1';
            when "01"   => X(1) <= '1';
            when "10"   => X(2) <= '1';
            when "11"   => X(3) <= '1';
            when others => X    <= "0000";
        end case;
    end if;
end process;
end Behavioral;