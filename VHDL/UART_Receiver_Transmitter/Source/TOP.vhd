library IEEE;
use IEEE.std_logic_1164.all;


entity TOP is 

    generic (
        g_CLKS_PER_BIT: integer := 10417
    );

    port (
        
        i_Clk: in std_logic;
        i_RX_IN: in std_Logic;
        o_TX_OUT: out std_logic;               
        o_Seven_Segment: out std_logic_vector(6 downto 0);
        o_Display_Ports: out std_logic_vector(7 downto 0)
        
    );
    
end TOP;



architecture RTL of TOP is

    signal r_DV: std_logic:= '0';
    signal r_Data_Byte: std_logic_vector(7 downto 0):= (others => '0');

    signal r_Switch: std_logic:= '0';
    signal r_Seven_Segment_1: std_logic_vector(6 downto 0):= (others => '0');
    signal r_Seven_Segment_2: std_logic_vector(6 downto 0):= (others => '0');

    
    constant c_Counter_Limit: integer:= 50000;
    signal r_Counter: integer range 0 to c_Counter_Limit:= 0;

begin

    UART_RX_Inst: entity work.UART_RX
    generic map (
        g_CLKS_PER_BIT => g_CLKS_PER_BIT
    )
    port map (
        i_Clk => i_Clk,
        i_RX_Serial => i_RX_IN,
        o_RX_DV => r_DV,
        o_RX_Byte => r_Data_Byte
    
    );

    UART_TX_Inst: entity work.UART_TX
    generic map (
        g_CLKS_PER_BIT => g_CLKS_PER_BIT
    )
    port map (
        i_clk => i_Clk,
        i_TX_DV => r_DV,
        i_TX_Byte => r_Data_Byte,
        o_TX_Active => open,
        o_TX_Serial => o_TX_OUT,
        o_TX_Done => open
    );
    
    Seven_Segment_Inst_1: entity work.Seven_Segment
    port map (
        i_clk => i_Clk,
        i_Data => r_Data_Byte(3 downto 0),
        o_Segment => r_Seven_Segment_1
    );
    
    Seven_Segment_Inst_2: entity work.Seven_Segment
    port map (
        i_clk => i_Clk,
        i_Data => r_Data_Byte(7 downto 4),
        o_Segment => r_Seven_Segment_2
    );
    
    p_TOP: process(i_Clk) is
    begin
    
        if (rising_edge(i_Clk)) then
        
            if (r_Counter < c_Counter_Limit) then
                r_Counter <= r_Counter + 1;
            
            elsif (r_Counter = c_Counter_Limit) then
                r_Counter <= 0;
                
                if (r_Switch = '0') then
                    r_Switch <= '1';
                    o_Seven_Segment <= r_Seven_Segment_1;
                    o_Display_Ports <= "11111110";
                else
                    r_Switch <= '0';
                    o_Seven_Segment <= r_Seven_Segment_2;
                    o_Display_Ports <= "11111101";
                end if;
            
            else
                r_Counter <= 0;
            
            end if;
        
        
        end if; --rising_edge(i_Clk))
    
    end process p_TOP;


end RTL;




















