library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Seven_Segment_Display is
    
    port (
        i_Clk: in std_logic;
        i_Bits: in std_logic_vector(3 downto 0);
        o_Seven_Segment: out std_logic_vector(6 downto 0)
    );
end Seven_Segment_Display;



architecture Behavioral of Seven_Segment_Display is

    signal r_Seven_Segment: std_logic_vector(7 downto 0):= (others => '0');     --Direction of hex numbers = XFGEDCBA

begin

    p_main: process(i_Clk)
    begin
    
        if (rising_edge(i_Clk)) then
        
            case (i_Bits) is
                
               when "0000" => r_Seven_Segment <= X"3F";     -- case 0
               when "0001" => r_Seven_Segment <= X"06";     -- case 1
               when "0010" => r_Seven_Segment <= X"5B";     -- case 2
               when "0011" => r_Seven_Segment <= X"4F";     -- case 3
                
               when "0100" => r_Seven_Segment <= X"66";     -- case 4
               when "0101" => r_Seven_Segment <= X"6D";     -- case 5
               when "0110" => r_Seven_Segment <= X"7D";     -- case 6
               when "0111" => r_Seven_Segment <= X"07";     -- case 7
                
               when "1000" => r_Seven_Segment <= X"7F";     -- case 8
               when "1001" => r_Seven_Segment <= X"6F";     -- case 9
               when "1010" => r_Seven_Segment <= X"77";     -- case 10 A
               when "1011" => r_Seven_Segment <= X"7C";     -- case 11 B
                
               when "1100" => r_Seven_Segment <= X"39";     -- case 12 C
               when "1101" => r_Seven_Segment <= X"5E";     -- case 13 D
               when "1110" => r_Seven_Segment <= X"79";     -- case 14 E
               when "1111" => r_Seven_Segment <= X"71";     -- case 15 F
               when others => r_Seven_Segment <= X"00";     -- default case
            end case;
        
        end if;        
    end process p_main;
    
    o_Seven_Segment <= not r_Seven_Segment(6 downto 0);
    
end Behavioral;
