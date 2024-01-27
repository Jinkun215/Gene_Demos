----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 06:16:47 PM
-- Design Name: 
-- Module Name: Barrel_Shift - Behavioral
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

entity Barrel_Shift is
    generic (
        BS_N: integer:= 3   --BS_N = Number of Selectors; total Switch = 2**BS_N
    );
    
    port (
        --BS_clk: in std_logic;
        BS_Sel: in std_logic_vector(BS_N-1 downto 0);
        BS_SW: in std_logic_vector((2**BS_N)-1 downto 0);
        BS_Out: out std_logic_vector((2**BS_N)-1 downto 0)
    );
    
    
end Barrel_Shift;

architecture Behavioral of Barrel_Shift is

    component MUX_2x1
        port (
            MUX_2x1_A: in std_logic;
            MUX_2x1_B: in std_logic;
            MUX_2x1_Sel: in std_logic;
            Mux_2x1_Out: out std_logic
        );
    end component MUX_2x1;
    
    type temp is array(0 to BS_N-1) of std_logic_vector((2**BS_N)-1 downto 0);
    signal temp_register: temp;
   
    
begin


        GENERIC_LOOP_BS_N: for i in 0 to BS_N-1 generate
            FIRST: if (i = 0) generate
                J_LOOP_TOP: for j in 0 to (((2**BS_N)*((((2**BS_N)/(2**(BS_N-i-1)))-1))/((2**BS_N)/(2**(BS_N-i-1)))))-1 generate    --when BS_N = 3, j is 0 to 3
                    MUX_COMP: MUX_2x1 port map (
                        Mux_2x1_A => BS_SW(j),
                        Mux_2x1_B => BS_SW((j + (2**(BS_N-i-1)))),
                        Mux_2x1_Sel => BS_Sel(BS_N-i-1),
                        Mux_2x1_out => temp_register(i)(j) 
                    );
                end generate J_LOOP_TOP;
                J_LOOP_BOTTOM: for j in (((2**BS_N)*((((2**BS_N)/(2**(BS_N-i-1)))-1))/((2**BS_N)/(2**(BS_N-i-1))))) to (2**BS_N)-1 generate
                    MUX_COMP: MUX_2x1 port map (
                        Mux_2x1_A => BS_SW(j),
                        Mux_2x1_B => BS_SW(j - (((2**BS_N)-(2**(BS_N-i-1))))),
                        Mux_2x1_Sel => BS_Sel(BS_N-i-1),
                        Mux_2x1_out => temp_register(i)(j) 
                    );
                end generate J_LOOP_BOTTOM; 
            end generate FIRST;
            
            SUBSEQUENT: if (i > 0) generate
                J_LOOP_TOP: for j in 0 to (((2**BS_N)*((((2**BS_N)/(2**(BS_N-i-1)))-1))/((2**BS_N)/(2**(BS_N-i-1)))))-1 generate
                    MUX_COMP: Mux_2x1 port map (
                        Mux_2x1_A => temp_register(i-1)(j), 
                        Mux_2x1_B => temp_register(i-1)(j + (2**(BS_N-i-1))),
                        Mux_2x1_Sel => BS_Sel(BS_N-i-1),
                        Mux_2x1_out => temp_register(i)(j)
                    );              
                end generate J_LOOP_TOP;
                J_LOOP_BOTTOM: for j in (((2**BS_N)*((((2**BS_N)/(2**(BS_N-i-1)))-1))/((2**BS_N)/(2**(BS_N-i-1))))) to (2**BS_N)-1 generate
                    MUX_COMP: Mux_2x1 port map (
                        Mux_2x1_A => temp_register(i-1)(j), 
                        Mux_2x1_B => temp_register(i-1)(j - (((2**BS_N)-(2**(BS_N-i-1))))),
                        Mux_2x1_Sel => BS_Sel(BS_N-i-1),
                        Mux_2x1_out => temp_register(i)(j)
                    );     
                end generate J_LOOP_BOTTOM;            
            end generate SUBSEQUENT;
            
        end generate GENERIC_LOOP_BS_N;

    BS_Out <= temp_register(BS_N-1);
    

end Behavioral;








