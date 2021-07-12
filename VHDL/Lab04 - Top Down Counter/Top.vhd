----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 04:12:41 PM
-- Design Name: 
-- Module Name: Top - Behavioral
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

--FIX DOWN COUNTER
--Add reset - do this first
--Fix blur if possible




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    port (
        top_clk: in std_logic;                          
        top_updown: in std_logic;
        top_counter_reset: in std_logic;
        top_mux_reset: in std_logic;
        
        top_segment: out std_logic_vector(6 downto 0);
        top_display: out std_logic_vector(7 downto 0)
    );
end Top;

architecture Behavioral of Top is

    component Counter
        port (
            counter_clk: in std_logic;
            counter_updown: in std_logic;
            counter_reset: in std_logic;
            counter_output: out std_logic_vector(31 downto 0)    -- 4 times 8
        );
    end component Counter;

    component MUX
        port (
            MUX_clk: in std_logic;
            MUX_input: in std_logic_vector(31 downto 0); --4 times 8
            MUX_reset: in std_logic;
            MUX_output_segment: out std_logic_vector(6 downto 0);
            MUX_output_display: out std_logic_vector(7 downto 0)
        
        );
    end component MUX;

    signal counter_break: natural range 0 to 5000000:= 0;       --5000000 allows 1 to 10 in 1's digit in 1 second
    signal mux_break: natural range 0 to 50000:= 0;             --remember to restore by factor of 1000 after simulation

    signal counter_clk_input: std_logic:= '0';
    signal mux_clk_input: std_logic:= '0';
    
    signal counter_to_mux: std_logic_vector(31 downto 0);

begin

    Counter_GEN: Counter port map (
        counter_clk => counter_clk_input,
        counter_updown => top_updown,
        counter_reset => top_counter_reset,
        counter_output => counter_to_mux
    );
    
    MUX_GEN: MUX port map (
        MUX_clk => mux_clk_input,
        MUX_input => counter_to_mux,
        MUX_reset => top_mux_reset,
        MUX_output_segment => top_segment,
        MUX_output_display => top_display
    );

    TOP_GEN: process(top_clk)
    begin
        if (rising_edge(top_clk)) then
            counter_break <= counter_break + 1;
            mux_break <= mux_break + 1;
            if (counter_break >= 500000) then          --slows down the count
                counter_break <= 0;
                counter_clk_input <= not counter_clk_input;
            end if;
            if (mux_break >= 5000) then                --slows down the 7seg flicker
                mux_break <= 0;
                mux_clk_input <= not mux_clk_input;
            end if;
        end if;
    end process;

end Behavioral;
