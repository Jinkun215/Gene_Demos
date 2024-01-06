----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2021 12:02:05 AM
-- Design Name: 
-- Module Name: FIFO - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is

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

end FIFO;

architecture Behavioral of FIFO is

--    type memory_array is array (0 to Depth_Size-1) of std_logic_vector(Data_Size-1 downto 0);
--    signal memory: memory_array;
    
--    signal Head: natural range 0 to Depth_Size-1:= 0;
--    signal Tail: natural range 0 to Depth_Size-1:= 0;
--    signal Looped: boolean:= false;
    

begin

    GEN_FIFO: process(FIFO_CLK)
        type memory_array is array (0 to Depth_Size-1) of std_logic_vector(Data_Size-1 downto 0);
        variable memory: memory_array;
        
        variable Head: natural range 0 to Depth_Size-1:= 0;
        variable Tail: natural range 0 to Depth_Size-1:= 0;
        variable Looped: boolean:= false;
    
    
    
    begin
    
        if (rising_edge(FIFO_CLK)) then
            if (FIFO_Reset = '1') then
                Head := 0;
                Tail := 0;
                Looped := false;
                
                FIFO_Read_Data <= (others => '0');
                FIFO_Flag_Full <= '0';
                FIFO_Flag_Empty <= '1';
            else
            
                if (FIFO_Write_En = '1' and Looped = True) then
                    if (Tail < Head) then
                        memory(Tail) := FIFO_Write_Data;
                        if (Tail < Depth_Size-1) then
                            Tail := Tail + 1;
                        else
                            Tail := 0;
                            Looped := False;
                        end if;
                    end if;
                
                elsif (FIFO_Write_En = '1' and Looped = False) then
                    if (Tail >= Head) then
                        memory(Tail) := FIFO_Write_Data;
                        if (Tail < Depth_Size-1) then
                            Tail := Tail + 1;
                        else
                            Tail := 0;
                            Looped := True;
                        end if;
                    end if;
                end if;  -- if (FIFO_Write_En = '1') then
                
                ---------------------------------------------------------------------
                if (FIFO_Read_En = '1' and Looped = True) then
                    if (Head >= Tail) then
                        FIFO_Read_Data <= memory(Head);
                        if (Head < Depth_Size-1) then
                            Head := Head + 1;
                        else
                            Head := 0;
                            Looped := False;
                        end if;
                    end if;
                
                elsif (FIFO_Read_En = '1' and Looped = False) then
                    if (Head < Tail) then
                        FIFO_Read_Data <= memory(Head);
                        if (Head < Depth_Size-1) then
                            Head := Head + 1;
                        else
                            Head := 0;
                            Looped := True;
                        end if;
                    end if;
                
                end if; -- if (FIFO_Read_En = '1') then
                
                
                ---------------------------------------------------------------------
                if (Head = Tail) then
                    if (Looped = true) then
                        FIFO_Flag_Full <= '1';
                        FIFO_Flag_Empty <= '0';
                    else
                        FIFO_Flag_Full <= '0';
                        FIFO_Flag_Empty <= '1';
                    end if;
                else
                    FIFO_Flag_Full <= '0';
                    FIFO_Flag_Empty <= '0';
                end if; -- if (Head = Tail) then
                
            
            end if; -- if (FIFO_Reset = '1') then   
        end if; -- if (rising_edge(FIFO_CLK)) then
    end process;


end Behavioral;












