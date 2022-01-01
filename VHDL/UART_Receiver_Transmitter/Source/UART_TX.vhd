library IEEE;
use IEEE.std_logic_1164.all;


entity UART_TX is

    generic (
        g_CLKS_PER_BIT: integer := 10417
    );
    port (
        i_clk: in std_logic;
        i_TX_DV: in std_logic;
        i_TX_Byte: in std_logic_vector(7 downto 0);
        o_TX_Active: out std_logic;
        o_TX_Serial: out std_logic;
        o_TX_Done: out std_Logic
    );
    
end UART_TX;



architecture RTL of UART_TX is

    type s_SM_State is (s_Idle, s_TX_Start, s_TX_Data, s_TX_Stop, s_Cleanup);
    
    signal r_SM_Main: s_SM_State:= s_Idle;
    signal r_Clk_Count: integer range 0 to g_CLKS_PER_BIT:= 0;
    signal r_Bit_Index: integer range 0 to 7:= 0;
    signal r_TX_Byte: std_logic_vector(7 downto 0):= (others => '0');
    signal r_TX_Done: std_logic:= '0';
    

begin

    p_UART_TX: process(i_clk) is
    begin
    
        if (rising_edge(i_clk)) then
        
            case (r_SM_Main) is
            
                when s_Idle => 
                    o_TX_Serial <= '1';
                    o_TX_Active <= '0';
                    r_TX_Done <= '0';
                    r_Clk_Count <= 0;
                    r_Bit_Index <= 0;
                    
                    if (i_TX_DV = '1') then
                        r_TX_Byte <= i_TX_Byte;
                        r_SM_Main <= s_TX_Start;
                    else
                        r_SM_Main <= s_Idle;
                    end if;
                
                when s_TX_Start =>
                
                    o_TX_Active <= '1';
                    o_TX_Serial <= '0';
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1) then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Start;
                    else
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_TX_Data;
                    end if;
                        
                when s_TX_Data =>
                
                    o_TX_Serial <= r_TX_Byte(r_Bit_Index);
                    
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1) then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Data;
                    else
                        r_Clk_Count <= 0;
                        if (r_Bit_Index < 7) then
                            r_Bit_Index <= r_Bit_Index + 1;
                            r_SM_Main <= s_TX_Data;
                        else
                            r_Bit_Index <= 0;
                            r_SM_Main <= s_TX_Stop;
                        end if;
                    end if;                    
                    
                when s_TX_Stop =>
                
                    o_TX_Serial <= '1';
                    
                    if (r_Clk_Count < g_CLKS_PER_BIT-1) then
                        r_Clk_Count <= r_Clk_Count + 1;
                        r_SM_Main <= s_TX_Stop;
                    else
                        r_TX_Done <= '1';
                        r_Clk_Count <= 0;
                        r_SM_Main <= s_Cleanup;
                    end if;                
                
                when s_Cleanup =>
                
                    o_TX_Active <= '0';
                    r_TX_Done <= '1';
                    r_SM_Main <= s_Idle;
                
                when others => 
                    r_SM_Main <= s_Idle;
            
            end case;         
        
        end if; --(rising_edge(i_clk))
    
    end process;

    o_TX_Done <= r_TX_Done;

end RTL;









