----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.01.2025 13:07:10
-- Design Name: 
-- Module Name: LooseLeds - Behavioral
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

entity LooseLeds is
  Port ( 
        rst : in std_logic;
		clk : in std_logic;
		leds : out std_logic_vector(15 downto 0));
end LooseLeds;

architecture Behavioral of LooseLeds is
    signal leds_aux : std_logic_vector(15 downto 0);
begin

process (clk, rst)
	begin
		if rst = '1' then
			leds_aux <= (others => '0');
		elsif rising_edge(clk) then
		    if leds_aux(0) = '0' then
                leds_aux <= "0101010101010101";
            else
                leds_aux <= "1010101010101010";
            end if;
		end if;
end process;

	leds <= leds_aux;

end Behavioral;
