----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 12:58:51 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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

entity TOP is
    generic(TOP_N: integer:= 5);
    port (
    
        top_PORT_E: in std_logic;
        top_PORT_IN: in std_logic_vector(TOP_N-1 downto 0);
        top_PORT_SEL: in std_logic;
        top_PORT_OUT: out std_logic_vector(15 downto 0)
    
    
    );
end TOP;



architecture Behavioral of TOP is

    signal TEMP_2powN: std_logic_vector(2**TOP_N-1 downto 0);

    component generic_decoder 
        generic(N: integer := 5);
        
        port(
            PORT_E       : in STD_LOGIC;
            PORT_IN      : in STD_LOGIC_VECTOR (N-1 downto 0);
            PORT_OUT     : out STD_LOGIC_VECTOR ((2**N)-1 downto 0) --connect to TEMP
        );
    end component generic_decoder;
    
    component Mux_32x16
    port (
        PORT_A: in std_logic_vector(15 downto 0);
        PORT_B: in std_logic_vector(15 downto 0);
        PORT_SEL: in std_logic;
        PORT_OUT: out std_logic_vector(15 downto 0)
    
    );
    end component Mux_32x16;
    
--    component MUX_Nx1
--    --For a given N,
--    --the size of the MUX is 2^N,
--    --and There are N bits of selector 
--    --choose a N, and calculate SIZE_OF_MUX
--    --I don't know how to code it in VHDL, so needs to be done manually.

--    generic (N: integer:=5);

--    Port ( 
--        PORT_IN: in std_logic_vector((2**N)-1 downto 0); --connected by TEMP
--        PORT_SEL: in std_logic_vector(N-1 downto 0);
--        PORT_OUT: out std_logic
--    );
--    end component MUX_Nx1;


begin


    GEN_DECODER: generic_decoder generic map(N => TOP_N)
        port map (
            PORT_E => top_PORT_E,
            PORT_IN =>top_PORT_IN,
            PORT_OUT => TEMP_2powN
        );
        
    GEN_MUX: Mux_32x16
        port map (
            PORT_A => TEMP_2powN(15 downto 0),
            PORT_B => TEMP_2powN(31 downto 16),
            PORT_SEL => top_PORT_SEL,
            PORT_OUT => top_PORT_OUT
            
        );
        
--    GEN_MUX: MUX_Nx1 generic map (N => TOP_N)
--        port map (
--            PORT_IN => TEMP_2powN,
--            PORT_SEL => top_PORT_SEL,
--            PORT_OUT => top_PORT_OUT
--        );


end Behavioral;
