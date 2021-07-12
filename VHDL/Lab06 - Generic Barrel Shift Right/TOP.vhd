----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2021 05:38:15 PM
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    generic (
        TOP_N: integer:= 3
    );
    port (
        TOP_Clk: in std_logic;
        TOP_Sel: in std_logic_vector(TOP_N-1 downto 0);
        TOP_SW: in std_logic_vector((2**TOP_N)-1 downto 0);
        TOP_8AN: out std_logic_vector(7 downto 0);
        TOP_HEX: out std_logic_vector(6 downto 0);
        TOP_LED: out std_logic_vector((2**TOP_N)-1 downto 0)
        
    );
end TOP;

architecture Behavioral of TOP is

    component MUX_Display
        port (
            MUX_Display_clk: in std_logic;
            MUX_Display_Input: in std_logic_vector(34 downto 0);   --5 display x 7 segments
            MUX_Display_8AN: out std_logic_vector(7 downto 0);
            Mux_Display_HEX: out std_logic_vector(6 downto 0)
        );
    end component MUX_Display;
    
    component Barrel_Shift
        generic (
            BS_N: integer:= 3   --BS_N = Number of Selectors; total Switch = 2**BS_N
        );
        
        port (
            --BS_clk: in std_logic;
            BS_Sel: in std_logic_vector(BS_N-1 downto 0);
            BS_SW: in std_logic_vector((2**BS_N)-1 downto 0);
            BS_Out: out std_logic_vector((2**BS_N)-1 downto 0)
        );
        
    end component Barrel_Shift;
    
    component Hex_7Seg
        port (
            Hex_7Seg_In: in std_logic_vector(3 downto 0);
            Hex_7Seg_Out: out std_logic_vector(6 downto 0)
        );
    end component Hex_7Seg;
    
    signal SW_Shifted: std_logic_vector((2**TOP_N)-1 downto 0);
    signal All_Hex: std_logic_vector(34 downto 0);
    signal Sel_4bit: std_logic_vector(3 downto 0);
    
    signal display_counter: natural range 0 to 50000:= 0;
    signal display_clk: std_logic:= '0';

begin

    MUX_DISPLAY_COMP: MUX_Display port map (
        MUX_Display_clk => display_clk,
        MUX_Display_Input => All_Hex,
        MUX_Display_8AN => TOP_8AN,
        Mux_Display_HEX => TOP_HEX
        
    );
    
    BARREL_SHIFT_COMP: Barrel_Shift generic map (BS_N => TOP_N)
        port map ( 
            BS_Sel => Top_Sel,
            BS_SW => TOP_SW,
            BS_Out => SW_Shifted
        );


    HEX_7SEG_COMP1: Hex_7Seg port map (
            Hex_7Seg_In => TOP_SW(7 downto 4),
            Hex_7Seg_Out => All_Hex(34 downto 28)

    );
    
    HEX_7SEG_COMP2: Hex_7Seg port map (
            Hex_7Seg_In => TOP_SW(3 downto 0),
            Hex_7Seg_Out => All_Hex(27 downto 21)

    );
    
    HEX_7SEG_COMP3: Hex_7Seg port map (
            Hex_7Seg_In => SW_Shifted(7 downto 4),
            Hex_7Seg_Out => All_Hex(20 downto 14)

    );
    
    HEX_7SEG_COMP4: Hex_7Seg port map (
            Hex_7Seg_In => SW_Shifted(3 downto 0),
            Hex_7Seg_Out => All_Hex(13 downto 7)

    );

    HEX_7SEG_COMP5: Hex_7Seg port map (
            Hex_7Seg_In => Sel_4bit,
            Hex_7Seg_Out =>  All_Hex(6 downto 0)

    );

    CLK_GEN: process(top_clk)
    begin
        if (rising_edge(top_clk)) then
            display_counter <= display_counter + 1;
            if (display_counter >= 50000) then
                display_counter <= 0;
                display_clk <= not display_clk;
            end if;   
            Sel_4bit <= '0' & TOP_Sel;
            TOP_LED <= SW_Shifted;
        end if; 
            
        end process;

end Behavioral;
