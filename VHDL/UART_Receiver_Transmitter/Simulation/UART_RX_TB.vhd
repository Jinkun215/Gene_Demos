----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/26/2021 11:56:08 PM
-- Design Name: 
-- Module Name: UART_RX_TB - Behavioral
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

entity UART_RX_TB is
--  Port ( );
end UART_RX_TB;

architecture Behavioral of UART_RX_TB is

    constant c_CLK_PERIOD   : time    := 10ns;
    constant c_CLKS_PER_BIT : integer := 10417;
    constant c_BIT_PERIOD   : time    := 104170ns;
    
    signal r_Clock      :   std_logic := '0';
    signal r_RX_Byte    :   std_logic_vector(7 downto 0) := (others => '0');
    signal r_RX_Serial  :   std_logic := '0';
    
    procedure TEST_UART_RX (
        i_Data_in  : in std_logic_vector(7 downto 0);
        
        signal o_Serial : out std_logic ) is
        
        begin 
            
            o_Serial <= '0';
            wait for c_BIT_PERIOD;
            
            for ii in 0 to 7 loop
                o_Serial <= i_Data_in(ii);
                wait for c_BIT_PERIOD;
            end loop;
            
            o_Serial <= '1';
            wait for c_BIT_PERIOD;
                    
            
        end TEST_UART_RX;

begin

    UART_RX_inst: entity work.UART_RX 
    generic map (
        g_CLKS_PER_BIT => c_CLKS_PER_BIT
    )
    port map (
        i_Clk => r_Clock,
        i_RX_Serial => r_RX_Serial,
        o_RX_DV => open,
        o_RX_Byte => r_RX_Byte
    );
    
    r_Clock <= not r_Clock after c_CLK_PERIOD / 2;
    
    TEST_BENCH: process
    begin
    
        wait until rising_edge(r_Clock);
        TEST_UART_RX(X"C6", r_RX_Serial);
        wait until rising_edge(r_Clock);
        
        if r_RX_Byte = X"C6" then
            report "Test Successful - Correct Bytes Passed" severity note;
        else
            report "Test Failure - Incorrect Byte Passed" severity note;
        end if;
         
        assert false report "SIMULATION COMPLETED" severity failure;
    
    
    end process TEST_BENCH;

end Behavioral;




















