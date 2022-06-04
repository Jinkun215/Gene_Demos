

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FIFO_8x16_TB is
--  Port ( );
end FIFO_8x16_TB;

architecture Behavioral of FIFO_8x16_TB is

    constant time_Period: time:= 10ns;

    signal tb_Clk: std_logic:= '0';
    signal tb_Data_Wr: std_logic_vector(7 downto 0):= (others => '0');
    signal tb_Reset: std_logic:= '0';
    signal tb_Rd_Wr: std_logic:= '0';   -- '0' to Read, '1' to Write
    signal tb_Btn: std_logic:= '0';
    
    signal tb_Data_Rd: std_logic_vector(7 downto 0):= (others => '0');
    signal tb_Fifo_Full: std_logic:= '0';
    signal tb_Fifo_Empty: std_logic:= '0';
    
    
    

begin

    tb_Clk <= not tb_Clk after time_Period / 2;
    
    p_Test: process             -- MUST DISABLE DEBOUNCER.VHD on FIFO_8x16.VHD
    begin
        tb_Reset <= '1';                --Reset
        tb_Data_Wr <= "10101010";       --Prepare next write data
        wait for 4 * time_Period;
        
        tb_Reset <= '0';                -- "Enable" FIFO
        tb_Rd_Wr <= '1';                -- Set to Write
        wait for time_Period;
        
        tb_Btn <= '1';                  -- Write first Data
        wait for time_Period;
        
        tb_Btn <= '0';                  
        wait for time_Period;
        
        tb_Data_Wr <= "01100110";       -- Prepare next write data
        wait for time_Period;
        
        tb_Btn <= '1';                  -- Write second Data
        wait for time_Period;
        
        tb_Btn <= '0';
        wait for time_Period;
        
        tb_Rd_Wr <= '0';                -- Set to Read
        wait for time_Period;
        
        tb_Btn <= '1';                  -- Read second Data
        wait for time_Period;
        
        tb_Btn <= '0';
        wait for time_Period;
        
        tb_Btn <= '1';                  -- Read first Data
        wait for time_Period;
        
        tb_Btn <= '0';
        wait for time_Period;
        
        tb_Btn <= '1';                  -- attempt to Read when Empty, nothing happens
        wait for time_Period;
        
        tb_Btn <= '0';
        wait;
        
    
    end process p_Test;

    FIFO_8x16_TB: entity work.FIFO_8x16         -- MUST DISABLE DEBOUNCER.VHD on FIFO_8x16.VHD
    generic map (
        g_DATA_Size => 8,
        g_FIFO_Size => 16
    )
    port map (
        i_Clk => tb_Clk,
        i_Data_Wr => tb_Data_Wr,
        i_Reset => tb_Reset,
        i_Rd_Wr => tb_Rd_Wr,
        i_Btn => tb_Btn,
    
        o_Data_Rd => tb_Data_Rd,
        o_Fifo_Full => tb_Fifo_Full,
        o_Fifo_Empty => tb_Fifo_Empty
    );




end Behavioral;













