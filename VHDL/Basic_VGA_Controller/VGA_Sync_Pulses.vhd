-- This module is designed for 640x480 resolution VGA, and requires a 25Mhz clock

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Sync_Pulses is
  generic (
    g_VIDEO_WIDTH : integer := 3;
    g_TOTAL_COLS  : integer := 800;
    g_TOTAL_ROWS  : integer := 525;
    g_ACTIVE_COLS : integer := 640;
    g_ACTIVE_ROWS : integer := 480 
    
    );
  port (
    i_Clk_Real  : in  std_logic;
    i_Switch    : in std_logic_vector(1 downto 0);
    o_HSync     : out std_logic;
    o_VSync     : out std_logic;
    
    o_Red: out std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
    o_Grn: out std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
    o_Blu: out std_logic_vector(g_VIDEO_WIDTH-1 downto 0)

    );
end entity VGA_Sync_Pulses;

architecture RTL of VGA_Sync_Pulses is

  signal i_Clk: std_logic:= '0';

  signal r_Col_Count : integer range 0 to g_TOTAL_COLS-1 := 0;
  signal r_Row_Count : integer range 0 to g_TOTAL_ROWS-1 := 0;
  
  signal pattern_Red: std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
  signal pattern_Grn: std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
  signal pattern_Blu: std_logic_vector(g_VIDEO_WIDTH-1 downto 0);
  
  signal r_VSync: std_logic := '0'; 
  signal r_HSync: std_logic := '0';

begin

    -- "Slows" down the clock by taking a 100Mhz clock into 25Mhz
    Frequency_Divider_Inst: entity work.Frequency_Divider
    generic map (
        Divider_Val => 2
    )
    port map (
        i_Clk_Real => i_Clk_Real,
        o_Clk_Divided => i_Clk
    );


    --Count Every column, one row at a time
      p_Row_Col_Count : process (i_Clk) is
      begin
        if rising_edge(i_Clk) then
          if r_Col_Count = g_TOTAL_COLS-1 then
            if r_Row_Count = g_TOTAL_ROWS-1 then
              r_Row_Count <= 0;
            else
              r_Row_Count <= r_Row_Count + 1;
            end if;
            r_Col_Count <= 0;
          else
            r_Col_Count <= r_Col_Count + 1;
          end if;
        end if;
      end process p_Row_Col_Count;
  
    -- Displays a pattern on screen based on switch input
    p_Pattern: process(i_Clk) is 
    begin
        if rising_edge(i_Clk) then
        
            --Show all White
            if (i_Switch = "00") then
        
                if (r_Col_Count < g_ACTIVE_COLS and r_Row_Count < g_ACTIVE_ROWS) then
                    pattern_Red <= (others => '1');
                    pattern_Grn <= (others => '1');
                    pattern_Blu <= (others => '1');
                else
                    pattern_Red <= (others => '0');
                    pattern_Grn <= (others => '0');
                    pattern_Blu <= (others => '0');
                end if;
                
            -- Show all Red
            elsif (i_Switch = "01") then
                if (r_Col_Count < g_ACTIVE_COLS and r_Row_Count < g_ACTIVE_ROWS) then
                    pattern_Red <= (others => '1');
                    pattern_Grn <= (others => '0');
                    pattern_Blu <= (others => '0');
                else
                    pattern_Red <= (others => '0');
                    pattern_Grn <= (others => '0');
                    pattern_Blu <= (others => '0');
                end if;
            
            -- Show all Green    
            elsif (i_Switch = "10") then
                if (r_Col_Count < g_ACTIVE_COLS and r_Row_Count < g_ACTIVE_ROWS) then
                    pattern_Red <= (others => '0');
                    pattern_Grn <= (others => '1');
                    pattern_Blu <= (others => '0');
                else
                    pattern_Red <= (others => '0');
                    pattern_Grn <= (others => '0');
                    pattern_Blu <= (others => '0');
                end if;
            
            -- Show all Blue    
            else
                if (r_Col_Count < g_ACTIVE_COLS and r_Row_Count < g_ACTIVE_ROWS) then
                    pattern_Red <= (others => '0');
                    pattern_Grn <= (others => '0');
                    pattern_Blu <= (others => '1');
                else
                    pattern_Red <= (others => '0');
                    pattern_Grn <= (others => '0');
                    pattern_Blu <= (others => '0');
                end if;

            end if;

        end if;

    end process;

    o_HSync <= '1' when r_Col_Count < g_ACTIVE_COLS else '0';
    o_VSync <= '1' when r_Row_Count < g_ACTIVE_ROWS else '0';
    
    o_Red <= pattern_red;
    o_Grn <= pattern_Grn;
    o_Blu <= pattern_Blu;
  
end architecture RTL;





