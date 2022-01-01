library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real."ceil";

entity generic_decoder is 
    generic(N: integer := 5);
    
    port(
        PORT_E       : in STD_LOGIC;
        PORT_IN      : in STD_LOGIC_VECTOR (N-1 downto 0);
        PORT_OUT     : out STD_LOGIC_VECTOR ((2**N)-1 downto 0)
    );
end generic_decoder;

architecture Behavioral of generic_decoder is

component decoder2to4
                Port (
                       A  : in  STD_LOGIC_VECTOR (1 downto 0);
                       X  : out STD_LOGIC_VECTOR (3 downto 0);
                       EN : in  STD_LOGIC
                );
end component;

Type tmp is array(0 to integer(ceil(real(N)/real(2))) + 1) of std_logic_vector(2**N downto 0);
signal tmp_reg: tmp;

begin

tmp_reg(0)(0) <= PORT_E;  

-- OUTER loops through the number of levels in N decoder
OUTER: for i in 0 to integer(ceil(real(N)/real(2))) - 1 generate

    -- check if N is even or odd  
    EVEN: if (N mod 2) = 0 generate
            -- if even, the number of decoders in a step are equal to 2^(2 x i) - 1, e.g. N = 4, i = 0, 2^(2 x 0) - 1 = 0 
            -- so loops once and create one decoder
            INNER_EVEN: for j in 0 to 2**(2*i) - 1 generate
                DECODER: decoder2to4 port map (
                                        EN    => tmp_reg(i)(j),
                                        A(1)  => PORT_IN(N-(2*i)-1),
                                        A(0)  => PORT_IN(N-(2*i)-2),
                                        X     => tmp_reg(i + 1)(4 * j + 3 downto 4 * j)
                                    );
             end generate INNER_EVEN;
         
         PORT_OUT <= tmp_reg(integer((real(N)/real(2))))(2**N - 1 downto 0);
         
    end generate EVEN;
    
    -- if odd, have to create first decoder that has one input that is grounded
    -- then, the number of decoders in a step are equal to 2^(2 x i - 1) - 1, e.g. N = 4, i = 1, 2^(2 x 1 - 1) - 1 = 1 
    -- so loops twice and create two decoders
    ODD: if (N mod 2) = 1 generate 
            FIRST: if i = 0 generate
                        DECODER: decoder2to4 port map (
                                        EN    => tmp_reg(0)(0),
                                        A(0)  => PORT_IN(N-1),
                                        A(1)  => '0',
                                        X     => tmp_reg(i + 1)(3 downto 0)
                                    );
            end generate FIRST;
            NEXTDEC: if (i > 0) generate
                INNER_ODD: for j in 0 to integer(2**(2 * i - 1) - 1) generate
                    DECODER: decoder2to4 port map (
                                        EN    => tmp_reg(i)(j),
                                        A(1)  => PORT_IN(N-(2*i)),
                                        A(0)  => PORT_IN(N-(2*i)-1),
                                        X     => tmp_reg(i + 1)(4 * j + 3 downto 4 * j)
                                    );
                 end generate INNER_ODD;
             end generate NEXTDEC;  
    
        PORT_OUT <= tmp_reg(N/2 + 1)(2**N - 1 downto 0); 
             
    end generate ODD;
end generate OUTER;

end Behavioral;
