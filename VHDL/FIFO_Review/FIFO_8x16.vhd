----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2022 10:50:34 AM
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

entity FIFO_8x16 is
    generic (
        constant g_DATA_Size: integer:= 8;
        constant g_FIFO_Size: integer:= 16
        
    );

    port (
        i_Clk: in std_logic;
        i_Data_Wr: in std_logic_vector(g_DATA_Size-1 downto 0);
        i_Reset: in std_logic;
        i_Rd_Wr: in std_logic;  -- '0' to Read, '1' to Write
        i_Btn: in std_logic;    -- pressed to write or read next value
        
        o_Data_Rd: out std_logic_vector(g_DATA_Size-1 downto 0);
        o_Fifo_Full: out std_logic;
        o_Fifo_Empty: out std_logic
    
    );
end FIFO_8x16;

architecture RTL of FIFO_8x16 is

    signal r_Fifo_Full: std_logic:= '0';
    signal r_Fifo_Empty: std_logic:= '1';
    
    type dataArr is array (0 to g_FIFO_Size-1) of std_logic_vector(g_DATA_Size-1 downto 0);
    signal r_Fifo_Data: dataArr;
    
    signal r_Data_Rd: std_logic_vector(g_DATA_Size-1 downto 0);
    
    signal r_Fifo_Index: integer range 0 to g_FIFO_Size:= 0;
    
    signal r_Debounced_Btn: std_logic:= '0';
    signal r_Prev_Btn: std_logic:= '0';
    
     


begin

    p_Main: process(i_Clk)
    begin
    
        if (rising_edge(i_Clk)) then
    
            if (i_Reset = '1') then
            
                r_Fifo_Full <= '0';
                r_Fifo_Empty <= '1';
                r_Fifo_Index <= 0;    
            
            else
                
                if (r_Debounced_Btn = '1' and r_Prev_Btn = '0') then
                
                    if (i_Rd_Wr = '0' and r_Fifo_Empty = '0') then      -- Read Data and Not Empty
                    
                        r_Data_Rd <= r_Fifo_Data(r_Fifo_Index-1);
                        r_Fifo_Index <= r_Fifo_Index - 1;
                        
                    
                    elsif(i_Rd_Wr = '1' and r_Fifo_Full = '0') then     -- Write Data nad Not Full
    
                         r_Fifo_Data(r_Fifo_Index) <= i_Data_Wr;
                         r_Fifo_Index <= r_Fifo_Index + 1;
                    
                    end if;
                    
                end if; -- (r_Der_Debounced_Btn = '1' and r_prev_Btn = '0')
                
                if (r_Fifo_Index = 0) then
                    r_Fifo_Empty <= '1';
                else
                    r_Fifo_Empty <= '0';
                end if;
                
                if (r_Fifo_Index = g_FIFO_Size) then    --index must be past 15
                    r_Fifo_Full <= '1';
                else
                    r_Fifo_Full <= '0';
                end if;
                
                r_Prev_Btn <= r_Debounced_Btn;      -- Ensure only one botton pressed is read or write
            
            end if; --if i_Reset = '1'
        
        end if;
    
    end process p_Main;
    
    o_Data_Rd <= r_Data_Rd;
    o_Fifo_Full <= r_Fifo_Full;
    o_Fifo_Empty <= r_Fifo_Empty;

    Debouncer_Inst: entity work.Debouncer
    port map (
        i_Clk => i_Clk,
        i_Btn => i_Btn,
        o_Debounced_Btn => r_Debounced_Btn
    );


end RTL;






















