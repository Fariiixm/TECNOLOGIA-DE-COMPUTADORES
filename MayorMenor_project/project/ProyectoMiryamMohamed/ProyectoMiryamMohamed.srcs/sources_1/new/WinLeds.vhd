----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 13:09:35
-- Design Name: 
-- Module Name: WinLeds - Behavioral
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

entity WinLeds is
  Port ( rst : in std_logic;
		clk : in std_logic;
		leds : out std_logic_vector(15 downto 0));
end WinLeds;

architecture Behavioral of WinLeds is
    signal leds_aux : std_logic_vector(15 downto 0);
begin

    process (clk, rst)
	begin
		if rst = '1' then
			leds_aux <= (others=>'0');
		elsif rising_edge(clk) then
		    if leds_aux(14) = '0' then
                leds_aux <= (others => '1');
            else
                leds_aux <= (others => '0');
            end if;
		end if;
	end process;

	leds <= leds_aux;
end Behavioral;
