----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2021 10:54:27 AM
-- Design Name: 
-- Module Name: MUX_PxQ - Behavioral
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

entity MUX_PxQ is
    generic(
        P_WIDTH: integer:= 4;
        Q_WIDTH: integer: 8
    );
        
end MUX_PxQ;

architecture Behavioral of MUX_PxQ is

    component MUX
        generic (SEL_N: integer:= 2);   --inputs = 2**sel_N
        port (
            mux_sel: in std_logic_vector(SEL_N-1 downto 0);
            mux_in: in std_logic_vector((2**SEL_N)-1 downto 0);
            mux_op: out std_logic
        );
    end component MUX;


begin


end Behavioral;










