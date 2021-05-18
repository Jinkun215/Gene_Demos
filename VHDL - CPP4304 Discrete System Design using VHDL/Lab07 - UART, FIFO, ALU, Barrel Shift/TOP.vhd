----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 12:18:41 PM
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    generic (
        TOP_BS_N: integer:= 3   --BS_N = Number of Selectors; total Switch = 2**BS_N
    );
    port (
        TOP_CLK: in std_logic;  --
        TOP_BS_Sel: in std_logic_vector(TOP_BS_N-1 downto 0); --
        TOP_ALU_Sel: in std_logic_vector(1 downto 0); --
        TOP_FIFO_Clk: in std_logic;
        TOP_FIFO_Write_En: in std_logic_vector(1 downto 0);
        TOP_FIFO_Read_En: in std_logic_vector(1 downto 0);
        TOP_RxD_In: in std_logic;
        TOP_Reset_All: in std_logic;
        
        TOP_8AN: out std_logic_vector(7 downto 0);  --
        TOP_HEX: out std_logic_vector(6 downto 0); --
        TOP_UART: out std_logic_vector(7 downto 0);
        TOP_FIFO_Full: out std_logic_vector(1 downto 0);
        TOP_FIFO_Empty: out std_logic_vector(1 downto 0)
    
    );
end TOP;

architecture Behavioral of TOP is

    --Import(?) all components

    component MUX_Display
        port (
            MUX_Display_clk: in std_logic;
            MUX_Display_Input: in std_logic_vector(31 downto 0);   
            MUX_Display_8AN: out std_logic_vector(7 downto 0);
            Mux_Display_HEX: out std_logic_vector(6 downto 0)
        );
    end component MUX_Display;
    
    component ALU
        port (
            ALU_clk: in std_logic;
            ALU_Math: in std_logic_vector(1 downto 0);
            ALU_Input_A: in std_logic_vector(7 downto 0);
            ALU_Input_B: in std_logic_vector(7 downto 0);
            ALU_Output: out std_logic_vector(15 downto 0)
        );
    end component ALU;
    
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
    
    component FIFO
    
        generic (
            Data_Size: natural := 8;
            Depth_Size: natural := 8
        );
        port (
            FIFO_CLK: in std_logic;
            FIFO_Reset: in std_logic;
            FIFO_Write_En: in std_logic;
            FIFO_Write_Data: in std_logic_vector(Data_Size-1 downto 0);
            FIFO_Read_En: in std_logic;
            FIFO_Read_Data: out std_logic_vector(Data_Size-1 downto 0);
            FIFO_Flag_Full: out std_logic;
            FIFO_Flag_Empty: out std_logic
        
        );
    
    end component FIFO;
    
    component UART
        port (
            UART_clk: in std_logic;
            UART_RxD_in: in std_logic;
            UART_RAZ: in std_logic;
            UART_data_out: out std_logic_vector(7 downto 0)
        
        );
    end component UART;

    -- Create all Signals

    signal display_counter: natural range 0 to 50000:= 0;
    signal display_clk: std_logic:= '0';
    
    
    signal uart_data_out_temp: std_logic_vector(7 downto 0);
    signal fifo_A_data_out: std_logic_vector(7 downto 0):= (others => '0');
    signal fifo_B_data_out: std_logic_vector(7 downto 0):= (others => '0');
    signal bs_A_data_out: std_logic_vector(7 downto 0):= (others => '0');
    signal bs_B_data_out: std_logic_vector(7 downto 0):= (others => '0');
    signal alu_data_out: std_logic_vector(15 downto 0):= (others => '0');
    
    signal hex_conversion_data_in: std_logic_vector(31 downto 0);


begin
    -- Generate all Component below
    MUX_Display_GEN: MUX_Display port map (
        MUX_Display_clk => display_clk,
        MUX_Display_Input => hex_conversion_data_in,
        MUX_Display_8AN => TOP_8AN,
        Mux_Display_HEX => TOP_HEX
    );
    
    ALU_GEN: ALU port map( 
        ALU_clk => TOP_CLK,
        ALU_Math => TOP_ALU_Sel,
        ALU_Input_A => bs_A_data_out,
        ALU_Input_B => bs_B_data_out,
        ALU_Output => alu_data_out
    );
    
    Barrel_Shift_Gen1: Barrel_Shift generic map (BS_N => TOP_BS_N)
    port map (
        BS_Sel => TOP_BS_Sel,
        BS_SW => fifo_A_data_out,
        BS_Out => bs_A_data_out
    );
    
    Barrel_Shift_Gen2: Barrel_Shift generic map (BS_N => TOP_BS_N)
    port map (
        BS_Sel => TOP_BS_Sel,
        BS_SW => fifo_B_data_out,
        BS_Out => bs_B_data_out
    );
    
    FIFO_A_Gen: FIFO port map (
        FIFO_CLK => TOP_FIFO_Clk,
        FIFO_Reset => TOP_Reset_All,
        FIFO_Write_En => TOP_FIFO_Write_En(1),
        FIFO_Write_Data => uart_data_out_temp,
        FIFO_Read_En => TOP_FIFO_Read_En(1),
        FIFO_Read_Data => fifo_A_data_out,
        FIFO_Flag_Full => TOP_FIFO_Full(1),
        FIFO_Flag_Empty => TOP_FIFO_Empty(1)
    );
    FIFO_B_Gen: FIFO port map (
        FIFO_CLK => TOP_FIFO_Clk,
        FIFO_Reset => TOP_Reset_All,
        FIFO_Write_En => TOP_FIFO_Write_En(0),
        FIFO_Write_Data => uart_data_out_temp,
        FIFO_Read_En => TOP_FIFO_Read_En(0),
        FIFO_Read_Data => fifo_B_data_out,
        FIFO_Flag_Full => TOP_FIFO_Full(0),
        FIFO_Flag_Empty => TOP_FIFO_Empty(0)
    );
    UART_Gen: UART port map (
        UART_clk => TOP_CLK,
        UART_RxD_in => TOP_RxD_In,
        UART_RAZ => TOP_Reset_All,
        UART_data_out => uart_data_out_temp
    );

    -- Non-Component generated processes below
    display_clk_Gen: process(TOP_CLK)
    begin
        if (rising_edge(Top_Clk)) then
            display_counter <= display_counter + 1;
            if (display_counter >= 50000) then
                display_counter <= 0;
                display_clk <= not display_clk;
            end if;
        end if;
    end process;

    pass_data_hex_gen: process(TOP_CLK)
    begin
        hex_conversion_data_in(15 downto 0) <= alu_data_out;
        hex_conversion_data_in(23 downto 16) <= fifo_B_data_out;
        hex_conversion_data_in(31 downto 24) <= fifo_A_data_out;
        TOP_UART <= uart_data_out_temp;
    end process;

end Behavioral;













