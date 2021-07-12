----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 06:03:44 PM
-- Design Name: 
-- Module Name: MUX_2x1 - Behavioral
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

entity MUX_2x1 is
    port (
        MUX_2x1_A: in std_logic;
        MUX_2x1_B: in std_logic;
        MUX_2x1_Sel: in std_logic;
        Mux_2x1_Out: out std_logic
    );
end MUX_2x1;

architecture Behavioral of MUX_2x1 is

begin

    Mux_2x1_Out <= (Mux_2x1_A and not Mux_2x1_Sel) or (Mux_2x1_B and Mux_2x1_sel);

end Behavioral;
