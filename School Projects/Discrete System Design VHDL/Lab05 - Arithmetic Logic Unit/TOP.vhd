----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2021 10:15:36 PM
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
    port ( 
        TOP_clk: in std_logic; --
        TOP_SW_In: in std_logic_vector(7 downto 0);
        TOP_SW_Math: in std_logic_vector(1 downto 0); --
        TOP_SW_HexBCD: in std_logic; --
        TOP_Display: out std_logic_vector(7 downto 0); --
        TOP_BCD: out std_logic_vector(6 downto 0) --
    );
end TOP;

architecture Behavioral of TOP is

    component MUX_Display
        port (
            MUX_Display_clk: in std_logic;
            MUX_Display_Input: in std_logic_vector(27 downto 0);
            MUX_Display_7seg: out std_logic_vector(7 downto 0);
            MUX_Display_BCD: out std_logic_vector(6 downto 0)
        );
    end component MUX_Display;
    
        component MUX_HexBcd
        port (
            MUX_HexBcd_clk: in std_logic;
            MUX_HexBcd_HB: in std_logic;
            MUX_HexBcd_In: in std_logic_vector(7 downto 0);
            MUX_BCD: out std_logic_vector(13 downto 0)
        );
    end component MUX_HexBcd;

    component AU
        port (
            AU_clk: in std_logic;
            AU_Math: in std_logic_vector(1 downto 0);
            AU_In: in std_logic_vector(7 downto 0);
            AU_BCD: out std_logic_vector(13 downto 0)
        );
    end component AU;
    

    
    signal BCD_ALL: std_logic_vector(27 downto 0);
    
    signal Mux_Display_Counter: natural range 0 to 50000:= 0;
    signal Mux_Display_clk: std_logic:= '0';
    
begin
    
    MUX_DISPLAY_GEN: Mux_Display port map (
        MUX_Display_clk => Mux_display_clk,
        MUX_Display_Input => BCD_ALL,
        MUX_Display_7seg => TOP_Display,
        MUX_Display_BCD => TOP_BCD
    );
    
    MUX_HexBcd_Gen: Mux_HexBcd port map (
        MUX_HexBcd_clk => TOP_clk,
        MUX_HexBcd_HB => TOP_SW_HexBCD,
        MUX_HexBcd_In => TOP_SW_In,
        MUX_BCD => BCD_ALL(13 downto 0)
    );
    
    AU_Gen: AU port map (
        AU_clk => TOP_clk,
        AU_Math => TOP_SW_Math,
        AU_In => TOP_SW_In,
        AU_BCD => BCD_ALL(27 downto 14)
    );
    
    
   
    
    TOPGEN: process(TOP_Clk)
    begin
        if (rising_edge(top_clk)) then
            Mux_Display_Counter <= Mux_Display_Counter + 1;
            if (Mux_Display_counter >= 50000) then
                Mux_Display_counter <= 0;
                Mux_Display_Clk <= not Mux_display_clk;
            end if;
            
        end if;
    
    end process;
    
    end Behavioral;
    
    
    









