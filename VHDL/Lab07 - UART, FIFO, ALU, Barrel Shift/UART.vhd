----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/31/2021 10:47:07 PM
-- Design Name: 
-- Module Name: myuart - Behavioral
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

entity UART is
    port (
        UART_clk: in std_logic;
        UART_RxD_in: in std_logic;
        UART_RAZ: in std_logic;
        UART_data_out: out std_logic_vector(7 downto 0)
    
    );
end UART;

architecture Behavioral of UART is

    signal RxD_Sync: std_logic;
    
    signal RST_UART_counter : STD_LOGIC;										         -- Reset of the counter
	signal UART_counter_internal : integer range 0 to 5210;					             -- Number of clk rising edges to increment counter
	signal UART_counter : integer range 0 to 19;   
	
	type state_type is (idle, start, demiStart, b0, b1, b2, b3, b4, b5, b6, b7);	     -- States of the FSM 
	signal state :state_type := idle;													 -- Default state    

begin

doubleTickUART:process(UART_clk) -- Counter
begin
	if (rising_edge(UART_clk)) then
	   if ((UART_RAZ='1') or (RST_UART_counter = '1')) then
            UART_counter <= 0;
            UART_counter_internal <= 0;
	   elsif (UART_counter_internal >= 5208) then 
			UART_counter <= (UART_counter + 1);
			UART_counter_internal <= 0;
	   else
			UART_counter_internal <= UART_counter_internal + 1;
	   end if;
	end if;
end process;

D_flip_flop_1:process(UART_clk)  -- Clock crossing, first flip flop 
begin
    if (rising_edge(UART_clk)) then
        RxD_Sync <= UART_RxD_in;
    end if;
end process;

fsm:process(UART_clk, UART_RAZ)	-- Finite state machine
begin
    if (rising_edge(UART_clk)) then
        if (UART_RAZ = '1') then
            state <= idle;
            UART_data_out <= "00000000";
            RST_UART_counter <= '1';
            --data_valid <= '0';
        else
		  case state is
			when idle => if RxD_sync = '0' then	     -- If in idle and low level detected on RxD_sync
							state <= start;
						 end if;
						 --data_valid <= '0';

						 RST_UART_counter <= '1';    -- Prevent from counting while in idle
			when start =>if (UART_counter = 1) then  -- If RxD_sync is low and half a period elapsed
							state <= demiStart;
						end if;
						RST_UART_counter <= '0'; -- Begin counting
						UART_data_out <= "00000000";         -- Reset former output data      
					--	data_valid <= '0';              -- Data is not valid 
			when demiStart => if (UART_counter = 3) then
								state <= b0;
								UART_data_out(0) <= RxD_sync;	-- Acquisition bit 1 of 8
							  end if;
			when b0 =>	if (UART_counter = 5) then
							state <= b1;
							UART_data_out(1) <= RxD_sync;	-- Acquisition bit 2 of 8
						end if;
			when b1 =>	if (UART_counter = 7) then
							state <= b2;
							UART_data_out(2) <= RxD_sync;	-- Acquisition bit 3 of 8
						end if;
			when b2 =>	if (UART_counter = 9) then
							state <= b3;
							UART_data_out(3) <= RxD_sync;	-- Acquisition bit 4 of 8
						end if;
			when b3 =>	if (UART_counter = 11) then
							state <= b4;
							UART_data_out(4) <= RxD_sync;	-- Acquisition bit 5 of 8
						end if;
			when b4 =>	if (UART_counter = 13) then
							state <= b5;
							UART_data_out(5) <= RxD_sync;	-- Acquisition bit 6 of 8
						end if;
			when b5 =>	if (UART_counter = 15) then
							state <= b6;
							UART_data_out(6) <= RxD_sync;	-- Acquisition bit 7 of 8
						end if;
			when b6 =>	if (UART_counter = 17) then
							state <= b7;	
							UART_data_out(7) <= RxD_sync;	-- Acquisition bit 8 of 8
						end if;
			when b7 =>	if (UART_counter = 19) then
							state <= idle;              -- state <= idle
				    --     if (UART_counter_internal = 0) then 
							--data_valid <= '1';          -- Data becomes valid
					 --    else 
					--        data_valid <= '0';
					--     end if; 
						end if;
			when others =>
			 state <= idle;
		end case;
	   end if;
	end if;
end process;

end Behavioral;













