library IEEE;
use IEEE.std_logic_1164.all;

entity Seven_Segment is 

    port (

        i_clk: in std_logic;
        i_Data: in std_logic_vector(3 downto 0);
        o_Segment: out std_logic_vector(6 downto 0)
    );
    
end Seven_Segment;




architecture RTL of Seven_Segment is

    signal r_Segment: std_logic_vector(7 downto 0) := (others => '0');  --pgfedcba
    

begin

    p_Seven_Segment: process(i_clk)
    begin
    
        if (rising_edge(i_clk)) then
        
            case (i_Data) is
                when "0000" => r_Segment <= x"3F";
                when "0001" => r_Segment <= x"06";
                when "0010" => r_Segment <= x"5B";
                when "0011" => r_Segment <= x"4F";
                when "0100" => r_Segment <= x"66";
                when "0101" => r_Segment <= x"6D";
                when "0110" => r_Segment <= x"7D";
                when "0111" => r_Segment <= x"07";
                when "1000" => r_Segment <= x"7F";
                when "1001" => r_Segment <= x"6F";
                when "1010" => r_Segment <= x"77";
                when "1011" => r_Segment <= x"7C";
                when "1100" => r_Segment <= x"39";
                when "1101" => r_Segment <= x"5E";
                when "1110" => r_Segment <= x"79";
                when "1111" => r_Segment <= x"71";       
            
                when others => r_Segment <= x"00";
            end case;
        
        
        end if; --(rising_edge(i_clk))
    
    end process;
    
    o_Segment <= not r_Segment(6 downto 0);

end RTL;
