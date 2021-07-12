----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2021 12:48:35 PM
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
        port(
        A: in std_logic;
        B: in std_logic;
        sel: in std_logic;
        output: out std_logic
        
         );
end MUX_2x1;

architecture Behavioral of MUX_2x1 is

begin
    Output <= (not sel and A) or (sel and B);

end Behavioral;
