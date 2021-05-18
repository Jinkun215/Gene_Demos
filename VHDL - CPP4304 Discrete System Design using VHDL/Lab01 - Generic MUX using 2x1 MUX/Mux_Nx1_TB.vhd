----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2021 06:20:08 PM
-- Design Name: 
-- Module Name: Mux_Nx1_TB - Behavioral
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

entity Mux_Nx1_TB is
    generic (N_TB: integer:= 6);
end Mux_Nx1_TB;

architecture Behavioral of Mux_Nx1_TB is

    component Mux_Nx1
        generic (
            N: integer:= 6
        );
        port (
            Nx1_Inputs: in std_logic_vector((2**N)-1 downto 0); --7 downto 0
            Nx1_sel: in std_logic_vector(N-1 downto 0);  --2 downto 0
            Nx1_output: out std_logic
        );
    end component Mux_Nx1;
    
    constant clock_period: time:= 10ns;
    
    signal Nx1_Inputs_TB: std_logic_vector((2**N_TB)-1 downto 0);
    signal Nx1_sel_TB: std_logic_vector(N_TB-1 downto 0);
    signal Nx1_output_TB: std_logic;
    


begin

    COMPONENT_GEN: Mux_Nx1 generic map (N => N_TB)
        port map (
            Nx1_Inputs => Nx1_Inputs_TB,
            Nx1_sel => Nx1_sel_TB,
            Nx1_output => Nx1_output_TB
        );
        
    TB_1: process
    begin
        Nx1_Inputs_TB <= x"0000000000000000";
        Nx1_sel_TB <= "000000";        --should be output 0
        wait for clock_period;
        Nx1_Inputs_TB <= x"0000000000000001";    --should be output 1
        wait for clock_period;
        Nx1_sel_TB <= "000001";    --should be output 0
        wait for clock_period;
        Nx1_Inputs_TB <= x"0000000000000002";    --should be output 1
    
        wait for clock_period;
        Nx1_Inputs_TB <= x"2000000000000002";    --should be output 0
        Nx1_sel_TB <= "111111";
        
        wait for clock_period;
        Nx1_sel_TB <= "111110"; --should be output 0
        
        wait for clock_period;
        Nx1_sel_TB <= "111101"; --should be output 1
        
        wait;
        
        
    end process TB_1;
    


end Behavioral;
