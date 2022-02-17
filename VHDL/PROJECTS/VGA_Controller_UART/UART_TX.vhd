----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/06/2022 11:41:14 PM
-- Design Name: 
-- Module Name: UART_TX - Behavioral
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

entity UART_TX is
    generic (
        g_CLKS_PER_BIT: integer:= 2605; -- VGA REQURIES 25MHZ -> 25MHZ/BAUD RATE = 25000000/9600 = 2605   
        g_DATA_SIZE: integer:= 8
    );
    port (
        i_clk: in std_logic;
        i_TX_DV: in std_logic;
        i_data_in: in std_logic_vector(7 downto 0);
        o_TX_serial: out std_logic;
        o_TX_Active: out std_logic
    );
    
end UART_TX;

    

architecture Behavioral of UART_TX is

    type SM_STATES is (SM_IDLE, SM_START, SM_DATA_OUT, SM_STOP, SM_CLEANUP);
    
    signal r_states: SM_STATES:= SM_IDLE;
    signal r_count: integer range 0 to g_CLKS_PER_BIT-1:= 0;
    signal r_data_count: integer range 0 to g_DATA_SIZE-1:= 0;
    signal r_data_in: std_logic_vector(7 downto 0):= (others => '0');
   
    

begin

    p_TX: process(i_clk) is
    begin
    
        if (rising_edge(i_clk)) then
    
            case (r_states) is
                when SM_IDLE =>
                
                    o_TX_Serial <= '1';
                    o_TX_Active <= '0';
                    r_count <= 0;
                    r_data_count <= 0;
                    
                    if (i_TX_DV = '1') then
                        r_data_in <= i_data_in;
                        r_states <= SM_START;
                    else
                        r_states <= SM_IDLE;
                    end if;
                    
                when SM_START =>
                    
                    o_TX_Active <= '1';
                    o_TX_Serial <= '0';
                    
                    if (r_count < g_CLKS_PER_BIT-1) then
                        r_count <= r_count + 1;
                        r_states <= SM_START;
                    else
                        r_count <= 0;
                        r_states <= SM_DATA_OUT;
                    
                    end if;
                    
                when SM_DATA_OUT =>
                
                    o_TX_Serial <= r_data_in(r_data_count);
                    
                    if (r_count < g_CLKS_PER_BIT-1) then
                        r_count <= r_count + 1;
                        r_states <= SM_DATA_OUT;
                    else
                        r_count <= 0;
    
                        if (r_data_count < g_DATA_SIZE-1) then
                            r_data_count <= r_data_count + 1;
                            r_states <= SM_DATA_OUT;
                        else
                            r_data_count <= 0;
                            r_states <= SM_STOP;
                        end if;
                    end if;
                
                when SM_STOP =>
                    o_TX_Serial <= '1';
                    
                    if (r_count < g_CLKS_PER_BIT-1) then
                        r_count <= r_count + 1;
                        r_states <= SM_STOP;
                    else
                        r_count <= 0;
                        r_states <= SM_CLEANUP;
                    end if;
                    
                when SM_CLEANUP =>
                    o_TX_Active <= '0';
                    r_states <= SM_IDLE;
                
                when others => 
                    r_states <= SM_IDLE;            
            
            end case;
            
        end if; --if(rising_edge(i_clk))
    
    end process;

end Behavioral;













