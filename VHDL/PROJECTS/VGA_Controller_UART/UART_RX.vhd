----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2022 04:12:14 PM
-- Design Name: 
-- Module Name: UART_RX - Behavioral
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

entity UART_RX is
    generic (
        g_CLKS_PER_BIT: integer:= 2605;        -- VGA REQURIES 25MHZ -> 25MHZ/BAUD RATE = 25000000/9600 = 2605   
        g_DATA_SIZE: integer:= 8
    );
    port (
        i_clk: in std_logic;
        i_serial: in std_logic;
        o_RX_DV: out std_logic;
        o_RX_Data: out std_logic_vector(g_DATA_SIZE-1 downto 0)
    );
    
end UART_RX;

architecture Behavioral of UART_RX is

    type SM_States is (SM_IDLE, SM_START, SM_DATA_IN, SM_STOP, SM_CLEANUP);
    
    signal r_states: SM_States:= SM_IDLE;
    signal r_count: integer range 0 to g_CLKS_PER_BIT-1:= 0;
    signal r_data_count: integer range 0 to g_DATA_SIZE-1:= 0;
    signal r_RX_DV: std_logic:= '0';
    signal r_RX_Data: std_logic_vector(g_DATA_SIZE-1 downto 0):= (others => '0');
    

begin

    p_State_Machine: process(i_clk) is
    begin
    
        if rising_edge(i_clk) then
        
            case (r_states) is
            
                when SM_IDLE =>
                
                    r_count <= 0;
                    r_data_count <= 0;
                    r_RX_DV <= '0';
                    
                    if (i_serial = '0') then
                        r_states <= SM_START;
                    else
                        r_states <= SM_IDLE;
                    end if;
                    
                
                when SM_START =>
                    if (r_count < (g_CLKS_PER_BIT-1)/2) then
                        r_count <= r_count + 1;
                        r_states <= SM_START;
                    else
                        if (i_serial = '0') then
                        
                            r_count <= 0;
                            r_states <= SM_DATA_IN;
                        else
                            r_states <= SM_IDLE;
                        end if;
                   
                    end if;


                when SM_DATA_IN =>
                    if (r_count < g_CLKS_PER_BIT-1) then
                        r_count <= r_count + 1;
                        r_states <= SM_DATA_IN;
                    else
                        r_count <= 0;
                        r_RX_DATA(r_data_count) <= i_serial;
                        
                        if (r_data_count < g_DATA_SIZE-1) then
                            r_data_count <= r_data_count + 1;
                            r_states <= SM_DATA_IN;
                        else    
                            r_data_count <= 0;
                            r_states <= SM_STOP;
                        end if;
                    
                    end if;
                
                when SM_STOP =>
                    if (r_count < g_CLKS_PER_BIT-1) then
                        r_count <= r_count + 1;
                        r_states <= SM_STOP;
                    else
                        r_count <= 0;
                        r_RX_DV <= '1';
                        r_states <= SM_CLEANUP;
                    end if;
                
                when SM_CLEANUP =>
                    r_states <= SM_IDLE;
                    r_RX_DV <= '0';
                
                when others =>
                    r_states <= SM_IDLE;               
            
            end case;       
        
        end if; --if rising_edge(i_clk)    
    
    end process;
    
    o_RX_DV <= r_RX_DV;
    o_RX_Data <= r_RX_Data;

end Behavioral;



























