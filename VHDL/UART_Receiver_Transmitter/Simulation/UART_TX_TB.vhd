----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/28/2021 02:06:01 AM
-- Design Name: 
-- Module Name: UART_TX_TB - Behavioral
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

entity UART_TX_TB is
--  Port ( );
end UART_TX_TB;



architecture Behavioral of UART_TX_TB is

    constant c_Clk_Period: time:= 10ns;
    constant c_CLKS_PER_BIT: integer:= 10417;
    
    signal r_Clk: std_logic:= '0';
    signal r_RX_DV: std_logic:= '0';
    signal r_TX_DV: std_logic:= '0';
    signal r_RX_Data_In: std_logic:= '0';
    signal r_RX_Byte: std_logic_vector(7 downto 0):= (others => '0');
    signal r_TX_Byte: std_logic_vector(7 downto 0):= (others => '0');
    signal r_TX_Active: std_logic := '0';
    signal r_TX_Serial: std_logic := '0';
    signal r_TX_Done: std_logic := '0';
    

begin

    UART_RX_inst: entity work.UART_RX
    generic map (
        g_CLKS_PER_BIT => c_CLKS_PER_BIT
    )
    port map (
        i_Clk => r_Clk,
        i_RX_Serial => r_RX_Data_In,
        o_RX_DV => r_RX_DV,
        o_RX_Byte => r_RX_Byte
    );
    
    UART_TX_inst: entity work.UART_TX
    generic map (
        g_CLKS_PER_BIT => c_CLKS_PER_BIT
    )
    port map (
        i_clk => r_Clk,
        i_TX_DV => r_TX_DV,
        i_TX_Byte => r_TX_Byte,
        o_TX_Active => r_TX_Active,
        o_TX_Serial => r_TX_Serial,
        o_TX_Done => r_TX_Done
    );

    r_RX_Data_in <= r_TX_Serial when r_TX_Active = '1' else '1';
    
    r_Clk <= not r_clk after (c_Clk_Period/2);
    
    TestBench: process is
    begin
    
        wait until rising_edge(r_Clk);
        wait until rising_edge(r_Clk);
        r_TX_DV <= '1';
        r_TX_Byte <= X"A2";
        wait until rising_edge(r_Clk);
        r_TX_DV <= '0';
        wait until rising_edge(r_RX_DV);
        
        if r_RX_Byte = X"A2" then
            report "Simulation Successful - Correct Bytes Passed" severity note;
        else
            report "Simulation Failure - Incorrect Bytes Passed" severity note;
        end if;
        
        assert false report "Simulation Completed" severity failure;
    
    end process;


end Behavioral;












