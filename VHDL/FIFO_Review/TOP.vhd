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

entity TOP is
    generic (
        constant g_DATA_Size: integer:= 8;
        constant g_FIFO_Size: integer:= 16
        
    );  
    port (
        i_Clk: in std_logic;
        i_Data_Wr: in std_logic_vector(7 downto 0);
        i_Reset: in std_logic;
        i_Rd_Wr: in std_logic;
        i_Btn: in std_logic;
        
        o_Fifo_Full: out std_logic;
        o_Fifo_Empty: out std_logic;
        o_Seven_Segment_Display: out std_logic_vector(6 downto 0);
        o_Seven_Segment_Enable: out std_logic_vector(7 downto 0)
        
    );
end TOP;

architecture RTL of TOP is

    signal r_Data_Rd: std_logic_vector(7 downto 0):= (others => '0');
    
    signal r_Seven_Segment_Display_1: std_logic_vector(6 downto 0);
    signal r_Seven_Segment_Display_2: std_logic_vector(6 downto 0);
    signal r_Seven_Segment_Display_3: std_logic_vector(6 downto 0);
    signal r_Seven_Segment_Display_4: std_logic_vector(6 downto 0);
    
    constant counter_Limit: integer:= 100000;
    signal counter: integer range 0 to counter_Limit-1:= 0;
    
    signal r_Switch: std_logic_vector(1 downto 0):= "00";

begin

    FIFO_8x16_Inst: entity work.FIFO_8x16
    generic map (
        g_DATA_Size => g_DATA_Size,
        g_FIFO_Size => g_FIFO_Size
    )
    port map(
        i_Clk => i_Clk,
        i_Data_Wr => i_Data_Wr,
        i_Reset => i_Reset,
        i_Rd_Wr => i_Rd_Wr,
        i_Btn => i_Btn,
        
        o_Data_Rd => r_Data_Rd,
        o_Fifo_Full => o_Fifo_Full,
        o_Fifo_Empty => o_Fifo_Empty
    
    );
    
    Seven_Segment_Display_Inst_1: entity work.SevenSegment_Display
    port map (
        i_Clk => i_Clk,
        i_Data_Rd => i_Data_Wr(3 downto 0),
        
        o_Seven_Segment => r_Seven_Segment_Display_1
    );
    
    Seven_Segment_Display_Inst_2: entity work.SevenSegment_Display
    port map (
        i_Clk => i_Clk,
        i_Data_Rd => i_Data_Wr(7 downto 4),
        
        o_Seven_Segment => r_Seven_Segment_Display_2
    );
    
    Seven_Segment_Display_Inst_3: entity work.SevenSegment_Display
    port map (
        i_Clk => i_Clk,
        i_Data_Rd => r_Data_Rd(3 downto 0),
        
        o_Seven_Segment => r_Seven_Segment_Display_3
    );
    
    Seven_Segment_Display_Inst_4: entity work.SevenSegment_Display
    port map (
        i_Clk => i_Clk,
        i_Data_Rd => r_Data_Rd(7 downto 4),
        
        o_Seven_Segment => r_Seven_Segment_Display_4
    );
    
    p_Main: process(i_Clk)
    begin
        if (rising_edge(i_Clk)) then
            if (counter < counter_Limit-1) then
                counter <= counter + 1;
            else
                counter <= 0;
                
                if (r_Switch = "00") then
                    o_Seven_Segment_Display <= r_Seven_Segment_Display_1;
                    o_Seven_Segment_Enable <= "10111111";
                    r_Switch <= "01";
                elsif (r_Switch = "01") then
                    o_Seven_Segment_Display <= r_Seven_Segment_Display_2;
                    o_Seven_Segment_Enable <= "01111111";
                    r_Switch <= "10";
                elsif (r_Switch = "10") then
                    o_Seven_Segment_Display <= r_Seven_Segment_Display_3;
                    o_Seven_Segment_Enable <= "11111110";
                    r_Switch <= "11";
                elsif (r_Switch = "11") then
                    o_Seven_Segment_Display <= r_Seven_Segment_Display_4;
                    o_Seven_Segment_Enable <= "11111101";
                    r_Switch <= "00";
                end if;
                
            
            end if;
        
        end if;
    end process p_Main;

end RTL;



