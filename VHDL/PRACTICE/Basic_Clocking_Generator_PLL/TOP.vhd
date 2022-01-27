----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2022 02:51:27 PM
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
    Port ( 
        i_clk : in STD_LOGIC
    
    );
end TOP;

architecture Behavioral of TOP is

    signal CLK_25MHZ: std_logic:= '0';
    
    signal counter: integer range 0 to 10:= 0;

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out25mhz          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

begin

    CLK_25MHZ_inst: clk_wiz_0
       port map ( 
      -- Clock out ports  
       clk_out25mhz => CLK_25MHZ,
       -- Clock in ports
       clk_in1 => i_clk
     );
 
    p_counter: process(CLK_25MHZ) is
    begin
        if (rising_edge(CLK_25MHZ)) then
            counter <= counter + 1;
        end if;
    
    end process p_counter;


end Behavioral;








