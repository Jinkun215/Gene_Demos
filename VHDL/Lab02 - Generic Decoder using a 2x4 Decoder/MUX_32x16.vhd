----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 01:29:04 PM
-- Design Name: 
-- Module Name: Mux_32x16 - Behavioral
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

entity Mux_32x16 is
    port (
        PORT_A: in std_logic_vector(15 downto 0);
        PORT_B: in std_logic_vector(15 downto 0);
        PORT_SEL: in std_logic;
        PORT_OUT: out std_logic_vector(15 downto 0)
    
    );
end Mux_32x16;

architecture Behavioral of Mux_32x16 is

    component MUX_2x1
            port(
            A: in std_logic;
            B: in std_logic;
            sel: in std_logic;
            output: out std_logic
            
             );
    end component MUX_2x1;

begin

    FORLOOP: for i in 0 to 15 generate
        GEN_MUX: MUX_2x1 port map (
        
            A => PORT_A(i),
            B => PORT_B(i),
            sel => PORT_SEL,
            output => PORT_OUT(i)
        
        );
    end generate;



end Behavioral;
