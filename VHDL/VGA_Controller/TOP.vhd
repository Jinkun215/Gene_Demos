library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity TOP is

    generic (
        g_Clks_Per_Bit: integer:= 217;
        g_Video_Width: integer:= 3;
    
        g_Total_Col: integer:= 800;
        g_Active_Col: integer:= 640;
        
        g_Total_Row: integer:= 525;
        g_Active_Row: integer:= 480;
        
        g_Col_Front: integer:= 18;
        g_Col_Back: integer:= 50;
        
        g_Row_Front: integer:= 10;
        g_Row_Back: integer:= 33
    );

    port (
        i_Clk: in std_logic;    
        i_RX_Serial: in std_logic;
        
        o_TX_Serial: out std_logic;
        
        o_HSync: out std_logic;
        o_VSync: out std_logic;
        o_Pattern_Red: out std_logic_vector(g_Video_Width-1 downto 0);
        o_Pattern_Grn: out std_logic_vector(g_Video_Width-1 downto 0);
        o_Pattern_Blu: out std_logic_vector(g_Video_Width-1 downto 0);
        
        o_Segment_Display: out std_logic_vector(6 downto 0);
        o_Segment_Enable: out std_logic_vector(7 downto 0)
    );
end TOP;



architecture RTL of TOP is

    signal w_Clk: std_logic;
    signal r_UART_DV: std_logic;
    signal r_UART_Data_Byte: std_logic_vector(7 downto 0);
    signal r_Segment_Display_1: std_logic_vector(6 downto 0);
    signal r_Segment_Display_2: std_logic_vector(6 downto 0);
    
    
    
    component clk_wiz_0
        port
        (
            clk_out_25M: out std_logic;
            clk_in_100M: in std_logic
        );
    end component;

begin

    clk_wiz_0_Inst: clk_wiz_0
    port map ( 
        clk_out_25M => w_Clk,
        clk_in_100M => i_Clk
    );
    
    UART_RX_Inst: entity work.UART_RX
    generic map (
        g_Clks_Per_Bit => g_Clks_Per_Bit
    )
    port map (
        i_Clk => w_Clk,
        i_RX_Serial => i_RX_Serial,
        o_RX_DV => r_UART_DV,
        o_RX_Byte => r_UART_Data_Byte
    );
    
    UART_TX_Inst: entity work.UART_TX
    generic map (
        g_Clks_Per_Bit => g_Clks_Per_Bit
    )
    port map (
        i_Clk => w_Clk,
        i_Data_Byte => r_UART_Data_Byte,
        i_TX_DV => r_UART_DV,
        o_TX_Serial => o_TX_Serial
    );
    
    Seven_Segment_Display_Inst_1: entity work.Seven_Segment_Display
    port map (
        i_Clk => w_Clk,
        i_Bits =>r_UART_Data_Byte(3 downto 0),
        o_Seven_Segment => r_Segment_Display_1
    );
    
    Seven_Segment_Display_Inst_2: entity work.Seven_Segment_Display
    port map (
        i_Clk => w_Clk,
        i_Bits =>r_UART_Data_Byte(7 downto 4),
        o_Seven_Segment => r_Segment_Display_2
    );
    
    Seven_Segment_Enable_Inst: entity work.Seven_Segment_Enable
    port map (
        i_Clk => w_Clk,
        i_Seven_Segment_1 => r_Segment_Display_1,
        i_Seven_Segment_2 => r_Segment_Display_2,
        
        o_Segment_Display => o_Segment_Display,
        o_Segment_En => o_Segment_Enable
    );

    VGA_Pulse_Generator_Inst: entity work.VGA_Pulse_Generator
    generic map (
        g_Total_Col => g_Total_Col,
        g_Active_Col => g_Active_Col,
        
        g_Total_Row => g_Total_Row,
        g_Active_Row => g_Active_Row,
        
        g_Col_Front => g_Col_Front,
        g_Col_Back => g_Col_Back,
        
        g_Row_Front => g_Row_Front,
        g_Row_Back => g_Row_Back
    )
    port map(
        i_Clk => w_Clk,
        
        o_HSync => o_HSync,
        o_VSync => o_VSync
    );
    
    VGA_Pattern_Generator_Inst: entity work.VGA_Pattern_Generator
    generic map (
        g_Video_Width => g_Video_Width,
    
        g_Total_Col => g_Total_Col,
        g_Active_Col => g_Active_Col,
        
        g_Total_Row => g_Total_Row,
        g_Active_Row => g_Active_Row,
        
        g_Col_Front => g_Col_Front,
        g_Col_Back => g_Col_Back,
        
        g_Row_Front => g_Row_Front,
        g_Row_Back => g_Row_Back
    )
    port map (
        i_Clk => w_Clk,
        i_Pattern_Sel => r_UART_Data_Byte(2 downto 0),
        
        o_Pattern_Red => o_Pattern_Red,
        o_Pattern_Grn => o_Pattern_Grn,
        o_Pattern_Blu => o_Pattern_Blu
    );
    
    
end RTL;
























