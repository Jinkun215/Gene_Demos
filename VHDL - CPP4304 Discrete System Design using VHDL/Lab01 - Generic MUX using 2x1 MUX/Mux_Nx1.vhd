----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2021 05:20:42 PM
-- Design Name: 
-- Module Name: Mux_Nx1 - Behavioral
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

entity Mux_Nx1 is
    generic (
        N: integer:= 3
    );
    port (
        Nx1_Inputs: in std_logic_vector((2**N)-1 downto 0); --7 downto 0
        Nx1_sel: in std_logic_vector(N-1 downto 0);  --2 downto 0
        Nx1_output: out std_logic
    );
end Mux_Nx1;

architecture Behavioral of Mux_Nx1 is

    component Mux_2x1
        port ( 
            inputs: in std_logic_vector(1 downto 0);
            sel: in std_logic;
            output: out std_logic
        );
    end component Mux_2x1;
    

    
    Type tmp2 is array(0 to N-1) of std_logic_vector((2**(N-1))-1 downto 0);    --3, 3 downto 0
    signal tmp_signal: tmp2;

begin

    OUTERLOOP: for i in 0 to N-1 generate

    begin
    
        SEL0: if (i = 0) generate
    
            INNERLOOP: for j in 0 to (2**(N-1)-1) generate
            
                MUX: Mux_2x1 port map (
                    sel => Nx1_sel(i),
                    inputs(0) => Nx1_Inputs(2*j),
                    inputs(1) => Nx1_Inputs(2*j+1),
                    output => tmp_signal(i)(j)
                    
                );
                
            end generate INNERLOOP;
         end generate SEL0;
         
         SEL_NOT0: if (i /= 0) generate
         
            INNERLOOP: for j in 0 to (2**(N-2)-1) generate
            
                MUX: Mux_2x1 port map (
                    sel => Nx1_sel(i),
                    inputs(0) => tmp_signal(i-1)(2*j),
                    inputs(1) => tmp_signal(i-1)(2*j+1),
                    output => tmp_signal(i)(j)
                    
                );
                
            end generate INNERLOOP;
         
         end generate SEL_NOT0;
   

    end generate OUTERLOOP;

    Nx1_Output <= tmp_signal(N-1)(0);

end Behavioral;
