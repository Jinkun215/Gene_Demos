----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/27/2022 04:03:16 PM
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
    port (
        i_clk: in std_logic;
        i_uart_rx: in std_logic;
        o_uart_tx: out std_logic;
        
        o_vga_hx: out std_logic;
        o_vga_vx: out std_logic;
        o_vga_red: out std_logic_vector(3 downto 0);
        o_vga_grn: out std_logic_vector(3 downto 0);
        o_vga_blu: out std_logic_vector(3 downto 0);
        
        o_seven_segment: out std_logic_vector(6 downto 0);
        o_display_port: out std_logic_vector(7 downto 0)
    );
end TOP;

architecture Behavioral of TOP is

    constant r_counter_MAX: integer:= 40000;

    signal CLK_25MHZ: std_logic:= '0';
    signal r_UART_Data: std_logic_vector(7 downto 0):= (others => '0');
    signal r_seven_segment_1: std_logic_vector(6 downto 0) := (others => '0');
    signal r_seven_segment_2: std_logic_vector(6 downto 0) := (others => '0');
    signal r_counter: integer range 0 to r_counter_MAX:= 0;
    signal r_switch: std_logic:= '0';
    
    signal r_UART_DV: std_logic:= '0';
    signal r_uart_tx: std_logic:= '0';
    signal r_TX_Active: std_logic:= '0';

    component clk_wiz_0
        port
         (-- Clock in ports
          -- Clock out ports
          CLK_25MHZ          : out    std_logic;
          clk_in1           : in     std_logic
         );
    end component;


begin

    CLK25MHZ_inst: clk_wiz_0
       port map ( 
      -- Clock out ports  
       CLK_25MHZ => CLK_25MHZ,
       -- Clock in ports
       clk_in1 => i_clk
     );
     
     UART_RX_inst: entity work.UART_RX
     generic map (
        g_CLKS_PER_BIT => 2605,
        g_DATA_SIZE => 8
     )
     port map (
        i_clk => CLK_25MHZ,
        i_serial => i_uart_rx,
        o_RX_DV => r_UART_DV,
        o_RX_Data => r_UART_Data
     );
     
     UART_TX_inst: entity work.UART_TX
     generic map (
        g_CLKS_PER_BIT => 2605,
        g_DATA_SIZE => 8
     )
     port map (
        i_clk => CLK_25MHZ,
        i_TX_DV => r_UART_DV,
        i_data_in => r_UART_Data,
        o_TX_Active => r_TX_Active,
        o_TX_Serial => r_uart_tx
     );
     
     
     Seven_Segment_inst_1: entity work.Seven_Segment
     port map (
        i_clk => CLK_25MHZ,
        i_binary => r_UART_Data(3 downto 0),
        o_seven_segment => r_seven_segment_1
     );
     
     Seven_Segment_inst_2: entity work.Seven_Segment
     port map (
        i_clk => CLK_25MHZ,
        i_binary => r_UART_Data(7 downto 4),
        o_seven_segment => r_seven_segment_2
     );
     
    VGA_Pattern_Gen_Inst: entity work.VGA_Pattern_Gen
    generic map (
        g_TOTAL_COLS => 800,
        g_TOTAL_ROWS => 525,
        g_ACTIVE_COLS => 640,
        g_ACTIVE_ROWS => 480,
        g_COUNT_EXP => 10
    )
    port map (
        i_clk => CLK_25MHZ,
        i_Pattern => r_UART_Data(3 downto 0),
        
        o_HSync => o_vga_hx,
        o_VSync => o_vga_vx,
        o_Red_Video => o_vga_red,
        o_Grn_Video => o_vga_grn,
        o_Blu_Video => o_vga_blu
        
    
    );
     
     p_TOP: process(CLK_25MHZ) is
     begin
        if (rising_edge(CLK_25MHZ)) then
        
            if (r_counter < r_counter_MAX) then
                r_counter <= r_counter + 1;
            else
                r_counter <= 0;
                
                if (r_switch = '0') then
                    r_switch <= not r_switch;
                    o_seven_segment <= r_seven_segment_1;
                    o_display_port <= "11111110";
                    
                else
                    r_switch <= not r_switch;
                    o_seven_segment <= r_seven_segment_2;
                    o_display_port <= "11111101";
                end if;
            
            end if;
        
        end if; --if (rising_edge(CLK_25MHZ))
     
     end process;
     
     o_uart_tx <= r_uart_tx when r_TX_Active = '1' else '1';


end Behavioral;





















